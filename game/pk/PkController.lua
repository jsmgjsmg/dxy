local PkController = PkController or class("PkController")

function PkController:ctor()
    self.m_view = nil
    self._model = nil
    self.visibleSize = cc.Director:getInstance():getVisibleSize()
    self.origin = cc.Director:getInstance():getVisibleOrigin()
    self:initController()
end

function PkController:initController()
    self:registerListenner()
    print("PkController initController")
end

function PkController:getLayer()
    if self.m_view == nil then
        require("game.pk.view.PkLayer")
        self.m_view = PkLayer:create()
    end
    return self.m_view
end

function PkController:showLayer()
    local scene = SceneManager:getCurrentScene()
    UIManager:addUI(self:getLayer(), "PkLayer")
    scene:addChild(self:getLayer())
    zzc.PkController:request_timer()
    self:getLayer():setPosition(self.origin.x + self.visibleSize.width / 2,self.origin.y + self.visibleSize.height / 2)
    return self:getLayer()
end

function PkController:closeLayer()
    if self.m_view then
        UIManager:closeUI("PkLayer")
        self.m_view = nil
    end
end

-----------------------------------------------------------------
--Network 
--
--initNetwork
function PkController:registerListenner()
    _G.NetManagerLuaInst:registerListenner(NetEventType.Rec_Pk_GetData,self)
    _G.NetManagerLuaInst:registerListenner(DefineProto.PROTO_WAR_PK_MATCH_RESULT,self)
    _G.NetManagerLuaInst:registerListenner(DefineProto.PROTO_WAR_PK_DATA_SELF_BACK,self)
    _G.NetManagerLuaInst:registerListenner(DefineProto.PROTO_WAR_PK_MATCH_COUNT_DATA,self)
    _G.NetManagerLuaInst:registerListenner(DefineProto.PROTO_WAR_PK_BUY_COST_DATA,self)
end

function PkController:unregisterListenner()
    _G.NetManagerLuaInst:unregisterListenner(NetEventType.Rec_Pk_GetData,self)
    _G.NetManagerLuaInst:unregisterListenner(DefineProto.PROTO_WAR_PK_MATCH_RESULT,self)
    _G.NetManagerLuaInst:unregisterListenner(DefineProto.PROTO_WAR_PK_DATA_SELF_BACK,self)
    _G.NetManagerLuaInst:unregisterListenner(DefineProto.PROTO_WAR_PK_MATCH_COUNT_DATA,self)
    _G.NetManagerLuaInst:unregisterListenner(DefineProto.PROTO_WAR_PK_BUY_COST_DATA,self)
end

--请求竞技场数据
function PkController:getPkData()
    print("Req_Pk_GetData")
    local msg = mc.packetData:createWritePacket(NetEventType.Req_Pk_GetData)
    mc.NetMannager:getInstance():sendMsg(msg)
end

--请求购买挑战次数
function PkController:request_buyCount()
    print("request_buyCount")
    local msg = mc.packetData:createWritePacket(DefineProto.PROTO_WAR_BUY)
    mc.NetMannager:getInstance():sendMsg(msg)
end

--匹配
function PkController:request_matching()
    local msg = mc.packetData:createWritePacket(DefineProto.PROTO_WAR_PK_MATCH); --编写发送包
    mc.NetMannager:getInstance():sendMsg(msg); --发送 包
    print("send~~~~~~~~~~~~~~~~~~~~ "..DefineProto.PROTO_WAR_PK_MATCH)
end

--取消匹配
function PkController:cancel_matching()
    local msg = mc.packetData:createWritePacket(DefineProto.PROTO_WAR_PK_MATCH_CANCEL); --编写发送包
    mc.NetMannager:getInstance():sendMsg(msg); --发送 包
    print("send~~~~~~~~~~~~~~~~~~~~ "..DefineProto.PROTO_WAR_PK_MATCH_CANCEL)
end

--请求自身擂台数据
function PkController:request_timer()
    local msg = mc.packetData:createWritePacket(DefineProto.PROTO_WAR_PK_DATA_SELF_REQ); --编写发送包
    mc.NetMannager:getInstance():sendMsg(msg); --发送 包
    print("send~~~~~~~~~~~~~~~~~~~~ "..DefineProto.PROTO_WAR_PK_DATA_SELF_REQ)
end

--购买挑战次数
function PkController:getMatchTimer()
    local msg = mc.packetData:createWritePacket(DefineProto.PROTO_WAR_PK_MATCH_COUNT_BUY); --编写发送包
    mc.NetMannager:getInstance():sendMsg(msg); --发送 包
    print("send~~~~~~~~~~~~~~~~~~~~ "..DefineProto.PROTO_WAR_PK_MATCH_COUNT_BUY)
end

--获取购买消耗
function PkController:getMatchTimerNeed()
    local msg = mc.packetData:createWritePacket(DefineProto.PROTO_WAR_PK_BUY_COST_REQ); --编写发送包
    mc.NetMannager:getInstance():sendMsg(msg); --发送 包
    print("send~~~~~~~~~~~~~~~~~~~~ "..DefineProto.PROTO_WAR_PK_BUY_COST_REQ)
end

-----------------------------------------------------------------
--Receive
function PkController:dealMsg(msg)
    local cmdType = msg:getpacketCmdType() 
    if cmdType == NetEventType.Rec_Pk_GetData then
        zzm.PkModel.ranking = msg:readUint()
        local len = msg:readUbyte()
    	for index=1, len do
    	    local data = {}
    	    data.type = msg:readUbyte()
            data.uid = msg:readUint()
            data.uname = msg:readString()
            data.pro = msg:readUbyte()
            data.lv = msg:readUshort()
            data.ranking = msg:readUint()
            data.fight = msg:readUint()
            zzm.PkModel.player_list[index] = data
    	end
        zzm.PkModel:sortList()
    	
        dxyDispatcher_dispatchEvent(dxyEventType.Pk_Data_Upgrade)
    end
	
    if cmdType == DefineProto.PROTO_WAR_PK_MATCH_RESULT then --9602 匹配结果
        local data = {}
        data.Uid = msg:readUint()
        data.Name = msg:readString()
        data.Pro = msg:readUbyte()
        data.Power = msg:readUint()
        data.Total = msg:readUint()
        data.Win = msg:readUint()
		zzm.PkModel:initHisData(data)
	end
	
    if cmdType == DefineProto.PROTO_WAR_PK_MATCH_CANCEL_OK then --9606 取消匹配
        dxyDispatcher_dispatchEvent("ArenaNode_changeBtnState",2)
	end
	
    if cmdType == DefineProto.PROTO_WAR_PK_DATA_SELF_BACK then --9552 自身擂台数据返回
        local data = {}
        data.Total = msg:readUint()
        data.Win = msg:readUint()
	    data.Timer = msg:readUshort()
	    local len = msg:readUshort()
	    data.Rewards = {}
	    for i=1,len do
    	    data.Rewards[i] = {}
    	    data.Rewards[i].Type = msg:readUbyte()
    	    data.Rewards[i].Num = msg:readUint()
	    end
	    zzm.PkModel:initMatchData(data)
	end
	
    if cmdType == DefineProto.PROTO_WAR_PK_MATCH_COUNT_DATA then --9612 匹配更新次数
        zzm.PkModel.MatchData.Timer = msg:readUshort()
        dxyDispatcher_dispatchEvent("ArenaNode_updateTimer")
        
    end
    
    if cmdType == DefineProto.PROTO_WAR_PK_BUY_COST_DATA then --9616 购买擂台战次数消耗元宝
        zzm.PkModel.MatchData.BuyNeed = msg:readUint()
        dxyDispatcher_dispatchEvent("ArenaNode_openTipsPage")

    end
	
	
    -- 默认返回false ，表示不中断读取下一个msg
    return false
end

return PkController