local WorldBossController = class("WorldBossController")

function WorldBossController:ctor()
    self:registerListener()
end

function WorldBossController:registerListener()
    _G.NetManagerLuaInst:registerListenner(DefineProto.PROTO_SYSTEM_STATE_UPDATE,self)
    _G.NetManagerLuaInst:registerListenner(9082,self)
end

function WorldBossController:unregisterListenner()
    _G.NetManagerLuaInst:unregisterListenner(DefineProto.PROTO_SYSTEM_STATE_UPDATE,self)
    _G.NetManagerLuaInst:unregisterListenner(9082,self)
end

function WorldBossController:showLayer()
    self._layer = require ("src.game.worldboss.view.BossLayer"):create()
    local scene = SceneManager:getCurrentScene()
    scene:addChild(self._layer)
end

function WorldBossController:closeLayer()
    if self._layer then
        self._layer:removeFromParent()
        self._layer = nil
    end
end

---发送消息-----------------------------------------------------------
function WorldBossController:getCurRank()
    local _strMsg = mc.packetData:createWritePacket(9080)
    mc.NetMannager:getInstance():sendMsg(_strMsg)
    print("~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~send: 9080")
end

---dealMsg---------------------------------------------------------
function WorldBossController:dealMsg(msg)
    local cmd = msg:getCmd()
    if cmd == DefineProto.PROTO_SYSTEM_STATE_UPDATE then---900
        local type = msg:readUbyte()
        if type == DefineConst.CONST_STATE_TYPE_WORLD_BOSS then
            local state = msg:readUbyte()
            zzm.WorldBossModel:initState(state)
        end
        
        if type == DefineConst.CONST_STATE_TYPE_SOCIATY_WAR then
            local state = msg:readUbyte()
            zzm.TilemapModel:setState(state)
        end
        
    elseif cmd == 9082 then---9082(伤害排行)
        zzm.WorldBossModel.HurtRank = {}
        local len = msg:readUshort()
        for i=1,len do
            local data = {}
            data.Uid = msg:readUint()
            data.Name = msg:readString()
            data.Pro = msg:readUbyte()
            data.Harm = msg:readUint()
            zzm.WorldBossModel:initRank(data)
            if i == len then
                zzm.WorldBossModel:sort()
                dxyDispatcher_dispatchEvent("HarmRank_addItem")
            end
        end        
    end
end

return WorldBossController