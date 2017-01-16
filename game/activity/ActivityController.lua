local ActivityController = class("ActivityController")

function ActivityController:ctor()
    self:registerListener()
end

function ActivityController:registerListener()
    _G.NetManagerLuaInst:registerListenner(DefineProto.PROTO_ACTIVITY_LOGIN_MSG,self)
    _G.NetManagerLuaInst:registerListenner(DefineProto.PROTO_ACTIVITY_RETURN_ACTIVITY,self)
    _G.NetManagerLuaInst:registerListenner(DefineProto.PROTO_ACTIVITY_RETURN_ACTIVITY_STATE,self)
    _G.NetManagerLuaInst:registerListenner(DefineProto.PROTO_ACTIVITY_RETURN_EXCHANGE_AWARD,self)
    
end

function ActivityController:unregisterListenner()
    _G.NetManagerLuaInst:unregisterListenner(DefineProto.PROTO_ACTIVITY_LOGIN_MSG,self)
    _G.NetManagerLuaInst:unregisterListenner(DefineProto.PROTO_ACTIVITY_RETURN_ACTIVITY,self)
    _G.NetManagerLuaInst:unregisterListenner(DefineProto.PROTO_ACTIVITY_RETURN_ACTIVITY_STATE,self)
    _G.NetManagerLuaInst:unregisterListenner(DefineProto.PROTO_ACTIVITY_RETURN_EXCHANGE_AWARD,self)
end

---show
function ActivityController:showLayer()
    require("game.activity.view.ActivityNode")
    local scene = SceneManager:getCurrentScene()
    self._layer = ActivityNode:create()
    scene:addChild(self._layer)
    zzm.CharacterModel.isTipsToGoods = false
    dxyDispatcher_dispatchEvent("MainScene_updateActivityTips")
end

function ActivityController:closeLayer()
    if self._layer then
        self._layer:removeFromParent()
        self._layer = nil
        zzm.ActivityModel:whenClose()
    end
    zzm.CharacterModel.isTipsToGoods = true
end

---send
function ActivityController:registerAcType(type)
    local _strMsg = mc.packetData:createWritePacket(DefineProto.PROTO_ACTIVITY_GET_ACTIVITY)
    _strMsg:writeByte(type)
    mc.NetMannager:getInstance():sendMsg(_strMsg)
    print("send: ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"..DefineProto.PROTO_ACTIVITY_GET_ACTIVITY.." type "..type)
end

function ActivityController:getActivity(id)
    local _strMsg = mc.packetData:createWritePacket(DefineProto.PROTO_ACTIVITY_GET_REWARD)
    _strMsg:writeInt(id)
    mc.NetMannager:getInstance():sendMsg(_strMsg)
    print("send: ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"..DefineProto.PROTO_ACTIVITY_GET_REWARD.." id "..id)
end

function ActivityController:sendCdkey(cdkey)
    local _strMsg = mc.packetData:createWritePacket(DefineProto.PROTO_ACTIVITY_EXCHANGE)
	_strMsg:writeString(cdkey)
	mc.NetMannager:getInstance():sendMsg(_strMsg)
    print("send:"..DefineProto.PROTO_ACTIVITY_EXCHANGE.."~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~")
end

---dealMsg
function ActivityController:dealMsg(msg)
    local cmd = msg:getCmd()
    if cmd == DefineProto.PROTO_ACTIVITY_LOGIN_MSG then --登陆下发活动类型(11001)
        local len = msg:readUbyte()
        for i=1,len do
            local type = msg:readUbyte()
            if ActivityConfig:isExistByType(type) then
                zzm.ActivityModel:initBtnType(type)
            end
        end
        table.sort(zzm.ActivityModel.AcBtnList,function(t1,t2) return t1<t2 end)
        
    elseif cmd == DefineProto.PROTO_ACTIVITY_RETURN_ACTIVITY then --返回活动列表(11006)
        local type = msg:readUbyte()
        local len = msg:readUbyte()
        for i=1,len do
            local data = {}
            data.Id = msg:readUint()
            data.Finish = msg:readUint()
            data.State = msg:readUbyte()
            data.Config = ActivityConfig:getAcConfigById(data.Id)
            if data.Config then
                zzm.ActivityModel:initAcByType(type,data)
            end
        end
        zzm.ActivityModel:counttingAc(type)
        zzm.ActivityModel:sortByType(type)
        
    elseif cmd == DefineProto.PROTO_ACTIVITY_RETURN_ACTIVITY_STATE then --11012(返回领取状态)
        local data = {}
        data.type = msg:readUbyte()
        data.id = msg:readUint()
        data.state = msg:readUbyte()
        zzm.ActivityModel:changeAcByType(data)
    
    elseif cmd == DefineProto.PROTO_ACTIVITY_RETURN_EXCHANGE_AWARD then --11016(返回兑换奖励列表)
       local len = msg:readUbyte()
   	   local data = {}
       for i=1, len do
            data[i] = {}
            data[i].Type = msg:readUbyte()
            if data[i].Type==6 or data[i].Type==10 then
                data[i].Id = msg:readUint()
           end
            data[i].Num = msg:readUint()
       end
       cn:showRewardsGet(data)
            
    end
end

return ActivityController