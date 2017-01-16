local SweepController = SweepController or class("SweepController")

function SweepController:ctor()
    self.m_view = nil
    self.visibleSize = cc.Director:getInstance():getVisibleSize()
    self.origin = cc.Director:getInstance():getVisibleOrigin()
    self:initController()
end 

function SweepController:initController()
    self:registerListenner()
    print("SweepController initController")
end

function SweepController:getLayer()
    if self.m_view == nil then
        require("game.sweep.view.SweepMainLayer")
        self.m_view = SweepMainLayer:create()
    end
    return self.m_view
end

function SweepController:showLayer()
    local scene = SceneManager:getCurrentScene()
    UIManager:addUI(self:getLayer(), "SweepMainLayer")
    scene:addChild(self:getLayer())
    self:getLayer():setPosition(self.origin.x + self.visibleSize.width / 2,self.origin.y + self.visibleSize.height / 2)
end

function SweepController:closeLayer()
    if self.m_view then
        UIManager:closeUI("SweepMainLayer")
        self.m_view = nil
    end
end

-----------------------------------------------------------------
--Network 
--
--initNetwork
function SweepController:registerListenner()
    _G.NetManagerLuaInst:registerListenner(DefineProto.PROTO_PEENTO_LOGIN_MSG,self)
    _G.NetManagerLuaInst:registerListenner(DefineProto.PROTO_PEENTO_RETURN_MOP_UP,self)
    _G.NetManagerLuaInst:registerListenner(DefineProto.PROTO_PEENTO_RETURN_ELITE_MOP_UP,self)
end

function SweepController:unregisterListenner()
    _G.NetManagerLuaInst:unregisterListenner(DefineProto.PROTO_PEENTO_LOGIN_MSG,self)
    _G.NetManagerLuaInst:unregisterListenner(DefineProto.PROTO_PEENTO_RETURN_MOP_UP,self)
    _G.NetManagerLuaInst:unregisterListenner(DefineProto.PROTO_PEENTO_RETURN_ELITE_MOP_UP,self)
end

--摘取蟠桃
function SweepController:request_removalPeach()
    local msg = mc.packetData:createWritePacket(DefineProto.PROTO_PEENTO_PLUCKER); --编写发送包
    mc.NetMannager:getInstance():sendMsg(msg); --发送 包
end

--催熟蟠桃
function SweepController:request_ripening()
    local msg = mc.packetData:createWritePacket(DefineProto.PROTO_PEENTO_RIPENER); --编写发送包
    mc.NetMannager:getInstance():sendMsg(msg); --发送 包
end

--扫荡
function SweepController:request_sweep(copy_id,data)
    local msg = mc.packetData:createWritePacket(DefineProto.PROTO_PEENTO_MOP_UP); --编写发送包
    msg:writeInt(copy_id)
    msg:writeByte(#data)
    for index=1, #data do
    	msg:writeByte(data[index].type)
    	msg:writeInt(data[index].count)
    end
    mc.NetMannager:getInstance():sendMsg(msg); --发送 包
end

--领取奖励
function SweepController:request_receive(data)
    local msg = mc.packetData:createWritePacket(DefineProto.PROTO_PEENTO_GET); --编写发送包
    msg:writeByte(#data)
    for index=1, #data do
    	msg:writeByte(data[index])
    end
    mc.NetMannager:getInstance():sendMsg(msg); --发送 包
end

--精英副本扫荡
function SweepController:request_eliteSweep(copy_id,len)
    local msg = mc.packetData:createWritePacket(DefineProto.PROTO_PEENTO_ELITE_MOP_UP); --编写发送包
    msg:writeInt(copy_id)
    msg:writeShort(len)
    mc.NetMannager:getInstance():sendMsg(msg); --发送 包
end

--神将副本扫荡
function SweepController:request_generalSweep()
    local msg = mc.packetData:createWritePacket(DefineProto.PROTO_GODWILL_GODWILL_MOPUP); --编写发送包
    mc.NetMannager:getInstance():sendMsg(msg); --发送 包
    print("~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~send: "..DefineProto.PROTO_GODWILL_GODWILL_MOPUP)
end

function SweepController:peachTips(old,type)
    local new = zzm.SweepModel:getPeachNum()
    if new > old and old ~= 0 then
        local str = ""
        if type == 1 then
            str = "三"
        elseif type == 2 then
            str = "六"
        elseif type == 3 then
            str = "九"
        end
        cn:TipsSchedule("获得"..str.."千年蟠桃 " .. (new-old))
    end
end

-----------------------------------------------------------------
--Receive
function SweepController:dealMsg(msg)
    local cmdType = msg:getpacketCmdType()
    if cmdType == DefineProto.PROTO_PEENTO_LOGIN_MSG then
        zzm.SweepModel.treeNum = msg:readUshort()
        zzm.SweepModel.limit = msg:readUshort()
        zzm.SweepModel.ripedCount = msg:readUshort()
        zzm.SweepModel.ripeCount = msg:readUshort()
        zzm.SweepModel.ripeTime = msg:readUint()
        local old = zzm.SweepModel:getPeachNum()
        local type = 13
        local len = msg:readUbyte()
        for index=1, len do
            local data = {}
        	data.type = msg:readUbyte()
        	data.count = msg:readUint()
			old = zzm.SweepModel:getPeachNum()
        	zzm.SweepModel.peach_list[index] = data
        	type = data.type
			if not zzm.SweepModel.isLoginSend then
				self:peachTips(old,type)
			end		
        end		
		zzm.SweepModel.isLoginSend = false

        dxyDispatcher_dispatchEvent(dxyEventType.Sweep_Data_Update)
        dxyDispatcher_dispatchEvent(dxyEventType.Sweep_Ripening_Update)
        
        dxyDispatcher_dispatchEvent("MainScene_updateSweepTips")
    elseif cmdType == DefineProto.PROTO_PEENTO_RETURN_MOP_UP then
        require("game.sweep.view.SweepResultLayer")
        local layer = SweepResultLayer:create()
        SceneManager:getCurrentScene():addChild(layer)
        dxyDispatcher_dispatchEvent("sweep_close_layer")
        zzm.SweepModel.award_list = {}
        local len = msg:readUshort()
        
        if len < zzm.SweepModel.sendNum then
        	dxyFloatMsg:show("背包已满,整理后再扫荡")
        end
        
        for index=1, len do
        	local data = {}
        	data.idx = msg:readUshort()
        	data.exp = msg:readUint()
        	data.gold = msg:readUint()
        	local equipLen = msg:readUbyte()
        	local equipData = {}
            for var=1, equipLen do
                equipData[var] = {}
        		equipData[var].goods_id = msg:readUint()
        		equipData[var].count = msg:readUshort()
        	end
        	data.equip = equipData
        	
        	zzm.SweepModel.award_list[index] = data
        end
        dxyDispatcher_dispatchEvent(dxyEventType.Sweep_Result_Update)
    elseif cmdType == DefineProto.PROTO_PEENTO_RETURN_ELITE_MOP_UP then
        local layer = UIManager:getUI("SweepEliteResultLayer")
        if layer then
            layer:reset()
        else
            require("game.sweep.view.SweepEliteResultLayer")
            layer = SweepEliteResultLayer:create()
            UIManager:addUI(layer, "SweepEliteResultLayer")
            SceneManager:getCurrentScene():addChild(layer) 
        end
        zzm.SweepModel.award_elite_list = {}
        local len = msg:readUshort()
        for index=1, len do
        	local data = {}
        	data.idx = msg:readUshort()
            data.gold = msg:readUint()
            data.renown = msg:readUint()
            local stoneLen = msg:readUbyte()
            local stoneData = {}
            for var=1, stoneLen do
                stoneData[var] = {}
                stoneData[var].goods_id = msg:readUint()
                stoneData[var].count = msg:readUshort()
            end
            data.stone = stoneData
              
            zzm.SweepModel.award_elite_list[index] = data   
        end
        dxyDispatcher_dispatchEvent(dxyEventType.Sweep_Result_Update)
--    elseif cmdType == "" then
    
    end
    -- 默认返回false ，表示不中断读取下一个msg
    return false
end

return SweepController