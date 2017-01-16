local RecruitMoneyController = RecruitMoneyController or class("RecruitMoneyController")

function RecruitMoneyController:ctor()
    self.m_view = nil
    self._model = nil
    self.visibleSize = cc.Director:getInstance():getVisibleSize()
    self.origin = cc.Director:getInstance():getVisibleOrigin()
    self:initController()
end

function RecruitMoneyController:initController()
    self:registerListenner()
    print("RecruitMoneyController initController")
end

function RecruitMoneyController:getLayer()
    if self.m_view == nil then
        require("game.recruitMoney.view.RecruitMoneyLayer")
        self.m_view = RecruitMoneyLayer:create()
    end
    return self.m_view
end

function RecruitMoneyController:showLayer()
    local scene = SceneManager:getCurrentScene()
    UIManager:addUI(self:getLayer(), "RecruitMoneyLayer")
    scene:addChild(self:getLayer())
    self:getLayer():setPosition(self.origin.x + self.visibleSize.width / 2,self.origin.y + self.visibleSize.height / 2)
end

function RecruitMoneyController:closeLayer()
    if self.m_view then
        UIManager:closeUI("RecruitMoneyLayer")
        self.m_view = nil
    end
end

-----------------------------------------------------------------
--Network 
--
--initNetwork
function RecruitMoneyController:registerListenner()
    _G.NetManagerLuaInst:registerListenner(DefineProto.PROTO_LUCKY_LOGIN_MSG,self)
    _G.NetManagerLuaInst:registerListenner(DefineProto.PROTO_LUCKY_RETURN_LUCKY,self)
    _G.NetManagerLuaInst:registerListenner(DefineProto.PROTO_LUCKY_RETURN_LUCKY_BOX,self)
end

function RecruitMoneyController:unregisterListenner()
    _G.NetManagerLuaInst:unregisterListenner(DefineProto.PROTO_LUCKY_LOGIN_MSG,self)
    _G.NetManagerLuaInst:unregisterListenner(DefineProto.PROTO_LUCKY_RETURN_LUCKY,self)
    _G.NetManagerLuaInst:unregisterListenner(DefineProto.PROTO_LUCKY_RETURN_LUCKY_BOX,self)
end

--招财(type:0 单次  1 10次)
function RecruitMoneyController:request_Recruit(type)
    print("request_Recruit")
    local msg = mc.packetData:createWritePacket(DefineProto.PROTO_LUCKY_LUCKY)
    msg:writeByte(type)
    mc.NetMannager:getInstance():sendMsg(msg)
end

--开宝箱
function RecruitMoneyController:request_OpenBox(boxId)
    print("request_OpenBox")
    local msg = mc.packetData:createWritePacket(DefineProto.PROTO_LUCKY_LUCKY_BOX)
    msg:writeByte(boxId)
    mc.NetMannager:getInstance():sendMsg(msg)
end

-----------------------------------------------------------------
--Receive
function RecruitMoneyController:dealMsg(msg)
    local cmdType = msg:getpacketCmdType() 
    if cmdType == DefineProto.PROTO_LUCKY_LOGIN_MSG then
        zzm.RecruitMoneyModel.lucky_count = msg:readShort()
        zzm.RecruitMoneyModel.lucky_limit = msg:readShort()
        local boxlen = msg:readByte()
        for index=1, boxlen do
        	local data = {}
        	data.boxid = msg:readByte()
        	data.boxstate = msg:readByte()
        	zzm.RecruitMoneyModel.box_list[index] = data
        end
        dxyDispatcher_dispatchEvent(dxyEventType.Recruit_Money_Update)
    elseif cmdType == DefineProto.PROTO_LUCKY_RETURN_LUCKY then
        local data = {}
        data.gold = msg:readInt()
        data.rate = msg:readByte()   
         
        zzm.RecruitMoneyModel:critTips(data)
    elseif cmdType == DefineProto.PROTO_LUCKY_RETURN_LUCKY_BOX then
        local gold = msg:readInt()
        dxyFloatMsg:show("开启宝箱,获得铜钱"..gold)
    end
    -- 默认返回false ，表示不中断读取下一个msg
    return false
end

return RecruitMoneyController