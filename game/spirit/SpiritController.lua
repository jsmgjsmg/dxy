local SpiritController = SpiritController or class("SpiritController")

function SpiritController:ctor()
	self.m_view = nil
	self._model = nil
    self.visibleSize = cc.Director:getInstance():getVisibleSize()
    self.origin = cc.Director:getInstance():getVisibleOrigin()
	self:initController()
end

function SpiritController:initController()
    self:registerListenner()
    print("SpiritController initController")
end

function SpiritController:getLayer()
    if self.m_view == nil then
        require("game/spirit/view/SpiritLayer")
        self.m_view = SpiritLayer:create()
    end
    return self.m_view
end

function SpiritController:showLayer()
    local scene = SceneManager:getCurrentScene()
    UIManager:addUI(self:getLayer(), "SpiritLayer")
    scene:addChild(self:getLayer())
    self:getLayer():setPosition(self.origin.x + self.visibleSize.width / 2,self.origin.y + self.visibleSize.height / 2)
--    zzm.CharacterModel.isTipsToGoods = false
    return self:getLayer()
end

function SpiritController:closeLayer()
    if self.m_view then
        UIManager:closeUI("SpiritLayer")
        self.m_view = nil
    end
    zzm.CharacterModel.isTipsToGoods = true
end

function SpiritController:secondOpenCopyLayer()
    --打开地图界
    self.m_view:onSelectByType(SpiritLayerType.SearchLayer)
    if zzm.SpiritModel:isClear() then
    	return
    end
    local layer = SpiritCopyMapLayer.create()
    layer:update(zzm.SpiritModel.curSpiritDifficulty,zzm.SpiritModel.curSpiritLv)
    local scene = SceneManager:getCurrentScene()
    scene:addChild(layer)
    layer:updateValue()
end

function SpiritController:OpenCopyLayer()
    self.m_view:onSelectByType(SpiritLayerType.SearchLayer)
end

-----------------------------------------------------------------
--Network 
--
--initNetwork
function SpiritController:registerListenner()
    _G.NetManagerLuaInst:registerListenner(DefineProto.PROTO_COPY_MAGICSOUL_COPY_DATA,self)
    _G.NetManagerLuaInst:registerListenner(DefineProto.PROTO_COPY_PICKUP_MAGICSOUL_COPY_PROGRESS,self)
    _G.NetManagerLuaInst:registerListenner(DefineProto.PROTO_COPY_PICKUP_MAGICSOUL_COPY_COUNT_DATA,self)
end

function SpiritController:unregisterListenner()
    _G.NetManagerLuaInst:unregisterListenner(DefineProto.PROTO_COPY_MAGICSOUL_COPY_DATA,self)
    _G.NetManagerLuaInst:unregisterListenner(DefineProto.PROTO_COPY_PICKUP_MAGICSOUL_COPY_PROGRESS,self)
    _G.NetManagerLuaInst:unregisterListenner(DefineProto.PROTO_COPY_PICKUP_MAGICSOUL_COPY_COUNT_DATA,self)
end

--探索器灵副本
function SpiritController:searchSpiritCopy(type,difficulty,lv)
    local msg = mc.packetData:createWritePacket(DefineProto.PROTO_COPY_EXPLORER_MAGICSOUL_COPY); --编写发送包
    msg:writeByte(type)
    msg:writeByte(difficulty)
    msg:writeByte(lv)
    mc.NetMannager:getInstance():sendMsg(msg); --发送 包
end

-----------------------------------------------------------------
--Receive
function SpiritController:dealMsg(msg)
    local cmdType = msg:getpacketCmdType() 
    if cmdType == DefineProto.PROTO_COPY_MAGICSOUL_COPY_DATA then
        zzm.SpiritModel.spirit_type = msg:readUbyte()
        local len = msg:readUbyte()
        zzm.SpiritModel.spirit_copy = {}
    	for index=1, len do
    	    local data = {}
    	    data.idx = msg:readUbyte()
            data.copy_id = msg:readUint()
            data.copydifficulty = msg:readUbyte()
            data.state = msg:readUbyte()
    		zzm.SpiritModel.spirit_copy[index] = data
    	end
        dxyDispatcher_dispatchEvent(dxyEventType.Spirit_Copy_Update)
    elseif cmdType == DefineProto.PROTO_COPY_PICKUP_MAGICSOUL_COPY_PROGRESS then
        zzm.SpiritModel.searchCount = msg:readUshort()
        local searchRmb = msg:readUshort()
        local len = msg:readUshort()
        local data = {}
        for i=1, len do
            data[i] = {}
            data[i].Lv = msg:readUshort()
            local diff = msg:readUbyte()
            if diff == 1 then--普通
                data[i].General = true
            elseif diff == 2 then--中等
                data[i].Medium = true
            elseif diff == 3 then--高级
                data[i].Advanced = true
            end
        end
        zzm.SpiritModel:insertSpiritCopyPassData(data)
        
    elseif cmdType == DefineProto.PROTO_COPY_PICKUP_MAGICSOUL_COPY_COUNT_DATA then
        zzm.SpiritModel.spiritSweepCount = msg:readUshort()
        zzm.SpiritModel.useRmb = msg:readUshort()
        dxyDispatcher_dispatchEvent("SpiritSerachLayer_updateRmbtxt")
    end
    -- 默认返回false ，表示不中断读取下一个msg
    return false
end

return SpiritController