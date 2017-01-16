local RoleinfoController = RoleinfoController or class("RoleinfoController")

function RoleinfoController:ctor()
    self.m_view = nil
    self._model = nil
    self.visibleSize = cc.Director:getInstance():getVisibleSize()
    self.origin = cc.Director:getInstance():getVisibleOrigin()
    self:initController()
end 

function RoleinfoController:initController()
    self:registerListenner()
    print("RoleinfoController initController")
end

function RoleinfoController:getLayer()
    if self.m_view == nil then
        require("game/roleinfo/view/RoleinfoLayer")
        self.m_view = RoleinfoLayer:create()
    end
    return self.m_view
end

function RoleinfoController:showLayer()
    local scene = SceneManager:getCurrentScene()
    UIManager:addUI(self:getLayer(), "RoleinfoLayer")
    scene:addChild(self:getLayer())
    self:getLayer():setPosition(self.origin.x + self.visibleSize.width / 2,self.origin.y + self.visibleSize.height / 2)
end

function RoleinfoController:closeLayer()
    if self.m_view then
        UIManager:closeUI("RoleinfoLayer")
        self.m_view = nil
    end
end

-----------------------------------------------------------------
function RoleinfoController:registerListenner()
    _G.NetManagerLuaInst:registerListenner(NetEventType.Rec_Role_GetDate,self)
    _G.NetManagerLuaInst:registerListenner(DefineProto.PROTO_ROLE_RETURN_RANKING,self)
end

function RoleinfoController:unregisterListenner()
    _G.NetManagerLuaInst:unregisterListenner(NetEventType.Rec_Role_GetDate,self)
    _G.NetManagerLuaInst:unregisterListenner(DefineProto.PROTO_ROLE_RETURN_RANKING,self)
end

-----------------------------------------------------------------
--发送
function RoleinfoController:request_Rename(data)
    print("request_Rename")
    local msg = mc.packetData:createWritePacket(NetEventType.Req_Role_Rename); --编写发送包
    msg:writeString(data)
    mc.NetMannager:getInstance():sendMsg(msg); --发送 包
end

--请求信息
function RoleinfoController:getDataWithPro(uid,type)
    local msg = mc.packetData:createWritePacket(NetEventType.Req_Role_GetDate)
    msg:writeInt(uid)
    msg:writeByte(type)
    mc.NetMannager:getInstance():sendMsg(msg)
    print("~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"..NetEventType.Req_Role_GetDate.." uid:"..uid.." type:"..type)
end

--请求排行榜
function RoleinfoController:getPKranking(uid)
    local msg = mc.packetData:createWritePacket(DefineProto.PROTO_ROLE_CHECK_RANGKING)
    msg:writeInt(uid)
    mc.NetMannager:getInstance():sendMsg(msg)
    print("~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"..DefineProto.PROTO_ROLE_CHECK_RANGKING.." uid:"..uid)
end

-----------------------------------------------------------------
--接收
function RoleinfoController:dealMsg(msg)
    local cmd = msg:getCmd() 
    if cmd == NetEventType.Rec_Role_GetDate then --1046 (接收数据)
        local type = msg:readUbyte()
        print(type)
        if type == 0 then  ---基础数值
            local data = {}
            data.Uid =     msg:readUint()
            data.Name =    msg:readString()
            data.Pro =     msg:readUbyte()
            data.Lv =      msg:readUshort()
            data.Exp =     msg:readUint()
            data.NeedExp = msg:readUint()
            data.Power =   msg:readUint()
            data.Hp =      msg:readUint()
            data.Mp =      msg:readUint()        
            data.Atk =     msg:readUint()
            data.Def =     msg:readUint()
            data.Crit =    msg:readUint()
            data.Odds =    msg:readUint()
            data.isGroup = msg:readUbyte()
            if data.isGroup ~= 0 then
                data.Group = msg:readString()
            end
            zzm.RoleinfoModel:initBASE(data)
        elseif type == 1 then  ---装备
            local len = msg:readUshort()
            for i=1,len do
                local goods = zzd.GoodsData.new()
                goods:readMsg(msg)
                zzm.RoleinfoModel:initEQUIP(goods)
                if i == len then
                    dxyDispatcher_dispatchEvent("EquipinfoLayer_update")
                end
            end
        elseif type == 2 then  ---技能
            local len1 = msg:readUbyte()
            local data = {} 
            for i=1,len1 do
                data[i] = {}
                data[i].Id = msg:readUbyte()
                local len2 = msg:readUbyte()
                for j=1,len2 do
                    data[i][j] = {}
                    data[i][j].idx = msg:readUbyte()
                    data[i][j].skill_id = msg:readUint()
                    data[i][j].is_unlock = msg:readUbyte()
                end
            end
            zzm.RoleinfoModel:initSKILL(data)
        elseif type == 3 then  ---器灵
            local len = msg:readUbyte()
            for i=1,len do
                local goods = zzd.GoodsData.new()
                goods:readMsg(msg)
                zzm.RoleinfoModel:initSPIRIT(goods)
            end
        elseif type == 4 then  ---元神
            local data = {}
            data.Lv = msg:readUshort()
            local len = msg:readUbyte()
            for i=1,len do
                local idx = msg:readUbyte()
                local type = msg:readByte()
                cn:readPro(msg,type,data)
            end
            zzm.RoleinfoModel:initYUANSHEN(data)
        elseif type == 5 then  ---法器
            local len = msg:readUbyte()
            local data = {}
            for i=1,len do
                data[i] = {}
                data[i].Id = msg:readUint() 
                data[i].isLock = msg:readUbyte()
                if data[i].isLock == 1 then
                    data[i].Star = msg:readUbyte()
                    local len2 = msg:readUbyte()
                    for j=1,len2 do
                        local idx = msg:readUbyte()
                        local type = msg:readByte()
                        cn:readPro(msg,type,data[i])
                    end
                end
            end
            zzm.RoleinfoModel:initMAGIC(data)
        elseif type == 6 then  ---仙女
            local data = {}
            data.Id = msg:readUint()
            data.Lv = msg:readUshort()
            data.sk_isLock = msg:readUbyte()
            data.AllAtk = msg:readUint()
            data.AllDef = msg:readUint()
            data.AllHp = msg:readUint()
            zzm.RoleinfoModel:initFAIRY(data)
        elseif type == 7 then  ---神将
            local data = {}
            data.isCur = msg:readUbyte()
            if data.isCur == 1 then
                data.Id = msg:readUint()
                data.Star = msg:readUbyte()
                data.AllAtk = msg:readUint()
                data.AllDef = msg:readUint()
                data.AllHp = msg:readUint()
            end
            zzm.RoleinfoModel:initGENERAL(data)
            
        elseif type == 8 then --其他
            dxyDispatcher_dispatchEvent("FairyInfoLayer_update")
        end
        
    elseif cmd == DefineProto.PROTO_ROLE_RETURN_RANKING then --1052(竞技场排行榜)
        local rank = msg:readUint()
        dxyDispatcher_dispatchEvent("RoleinfoLayer_updateRank",rank)
     
    end
end

return RoleinfoController