local YuanShenController = YuanShenController or class("YuanShenController")

function YuanShenController:ctor()
    self:registerListener()
    self._arrCrit = {}
end

function YuanShenController:registerListener()
    _G.NetManagerLuaInst:registerListenner(NetEventType.Rec_YuanShen_YuanGodUp,self)
    _G.NetManagerLuaInst:registerListenner(NetEventType.Rec_YuanShen_InitYuanGod,self)
    _G.NetManagerLuaInst:registerListenner(NetEventType.Rec_YuanShen_MagicUnLock,self)
    _G.NetManagerLuaInst:registerListenner(NetEventType.Rec_YuanShen_MagicType,self)
    _G.NetManagerLuaInst:registerListenner(NetEventType.Rec_YuanShen_MagicType,self)
end

function YuanShenController:unregisterListenner()
    _G.NetManagerLuaInst:unregisterListenner(NetEventType.Rec_YuanShen_YuanGodUp,self)
    _G.NetManagerLuaInst:unregisterListenner(NetEventType.Rec_YuanShen_InitYuanGod,self)
    _G.NetManagerLuaInst:unregisterListenner(NetEventType.Rec_YuanShen_MagicUnLock,self)
    _G.NetManagerLuaInst:unregisterListenner(NetEventType.Rec_YuanShen_MagicType,self)
end

function YuanShenController:showLayer()
    require "game.yuanshen.view.YSInitLayer"
    local scene = SceneManager:getCurrentScene()
    self._layer = YSInitLayer:create()
    scene:addChild(self._layer)  
    return self._layer
end

function YuanShenController:closeLayer()
    if self._layer then
        self._layer:removeFromParent()
        self._layer = nil
    end
end

----发送消息---------------------------------------------------------
--元神升级
function YuanShenController:upGradeYS(type)
    local _strMsg = mc.packetData:createWritePacket(NetEventType.Req_YuanShen_YuanGodUp)
    _strMsg:writeByte(type)
    mc.NetMannager:getInstance():sendMsg(_strMsg)
    print("~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~send: "..NetEventType.Req_YuanShen_YuanGodUp.." type: "..type)
end

--法器解锁
function YuanShenController:unLockMagic(id,type)
    local _strMsg = mc.packetData:createWritePacket(NetEventType.Req_YuanShen_MagicUnLock)
    _strMsg:writeInt(id)
    _strMsg:writeByte(type)
    mc.NetMannager:getInstance():sendMsg(_strMsg)
    print("~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~send: "..NetEventType.Req_YuanShen_MagicUnLock.." id: "..id.." type:"..type)
end

--法器升星
function YuanShenController:upGradeStar(id)
    local _strMsg = mc.packetData:createWritePacket(NetEventType.Req_YuanShen_MagicUp)
    _strMsg:writeInt(id)
    mc.NetMannager:getInstance():sendMsg(_strMsg)
    print("~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~send: "..NetEventType.Req_YuanShen_MagicUp.." id: "..id)
end

--技能升级
function YuanShenController:upGradeSkill(id)
    local _strMsg = mc.packetData:createWritePacket(NetEventType.Req_YuanShen_SkillUp)
    _strMsg:writeInt(id)
    mc.NetMannager:getInstance():sendMsg(_strMsg)
    print("~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~send: "..NetEventType.Req_YuanShen_SkillUp.." id: "..id)
end

--技能石合成
function YuanShenController:MergerGoods(type,stoneType,id)
    local _strMsg = mc.packetData:createWritePacket(DefineProto.PROTO_YUAN_GOD_A_COMPOUND_STONE)
    _strMsg:writeByte(type)
    _strMsg:writeByte(stoneType)
    _strMsg:writeInt(id)
    mc.NetMannager:getInstance():sendMsg(_strMsg)
    print("~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~send: "..DefineProto.PROTO_YUAN_GOD_A_COMPOUND_STONE.." type: "..type.." stoneType"..stoneType.." id"..id)
end

--一键合成
function YuanShenController:MergerAll()
    local _strMsg = mc.packetData:createWritePacket(DefineProto.PROTO_YUAN_GOD_SYNTHETIC_STONES)
    mc.NetMannager:getInstance():sendMsg(_strMsg)
    print("~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~send: "..DefineProto.PROTO_YUAN_GOD_SYNTHETIC_STONES)
end

---接收消息---------------------------------------------------------
function YuanShenController:dealMsg(msg)
    local cmd = msg:getCmd()
    if cmd == NetEventType.Rec_YuanShen_InitYuanGod then --3005(元神初始化)
        zzm.YuanShenModel._arrYuanShen["Lv"] = msg:readUshort()
        zzm.YuanShenModel._arrYuanShen["Exp"] = msg:readUshort()
        local num = msg:readUbyte()
        for j=1,num do
            local idx = msg:readUbyte()
            local type = msg:readUbyte()
            cn:readPro(msg,type,zzm.YuanShenModel._arrYuanShen)
        end
        
        local len = msg:readUbyte()
        for i=1,len do
            local data = {}
            data["Id"] = msg:readUint()
            data["isLock"] = msg:readUbyte()
            if data["isLock"] == 1 then
                data["Star"] = msg:readUbyte()
                data["skillId"] = msg:readUint()
                data["skillLv"] = msg:readUshort()
                local num = msg:readUbyte()
                for k=1,num do
                    local idx = msg:readUbyte()
                    local type = msg:readUbyte()
                    cn:readPro(msg,type,data)
                end
            elseif data["isLock"] == 0 then
                data["Exp"] = msg:readUint()
            end
            zzm.YuanShenModel:initMagic(data)
        end
    
    elseif cmd == NetEventType.Rec_YuanShen_YuanGodUp then --3015(元神升级)
        zzm.TalkingDataModel:onEvent(EumEventId.YUANSHEN_TRAIN,{})
        zzm.YuanShenModel._arrYuanShen["Lv"] = msg:readUshort()
        zzm.YuanShenModel._arrYuanShen["Exp"] = msg:readUshort()
        local len = msg:readUbyte()
        for i=1, len do
            local idx = msg:readUbyte()
            local type = msg:readByte()
            cn:readPro(msg,type,zzm.YuanShenModel._arrYuanShen)
        end
        local pro = msg:readUbyte()
        if pro == 1 then
            zzm.YuanShenModel._arrYuanShen["goods_Exp"] = msg:readUshort()
--            dxyFloatMsg:show("获得元气："..goods_Exp)
        elseif pro == 10 then
            zzm.YuanShenModel._arrYuanShen["goods_Exp"] = msg:readUshort()
--            zzm.YuanShenModel:TipsSchedule("获得元气："..goods_Exp)
        end
--        dxyDispatcher_dispatchEvent("upGradeYS",zzm.YuanShenModel._arrYuanShen)
        dxyDispatcher_dispatchEvent("YuanShenNode_addGradeYSData",zzm.YuanShenModel._arrYuanShen)
        dxyDispatcher_dispatchEvent("upDateTips")
        dxyDispatcher_dispatchEvent("MainScene_updateSoulTips")
        
    elseif cmd == NetEventType.Rec_YuanShen_MagicUnLock then --3035(法器解锁)
        local crit = msg:readUbyte()
        if crit > 1 then
            require "src.game.yuanshen.view.TipsCrit"
            local scene = SceneManager:getCurrentScene()           
            local _csb = TipsCrit:create()
            scene:addChild(_csb)
        end
        
        local data = {}
        local id = msg:readUint()
        for key,var in pairs(zzm.YuanShenModel._arrMagic) do
            if var.Id == id then
                var["isLock"] = msg:readUbyte()
                if var["isLock"] == 1 then
                    var["Star"] = msg:readUbyte()
                    var["skillId"] = msg:readUint()
                    var["skillLv"] = msg:readUshort()
                    local len = msg:readUbyte()
                    for i=1,len do
                        local idx = msg:readUbyte()
                        local type = msg:readUbyte()
                        cn:readPro(msg,type,var)
                    end
                    data["var"] = var
                    data["key"] = key
                    
                elseif var["isLock"] == 0 then
                    var["Exp"] = msg:readUint()
                    data["var"] = var
                    data["key"] = key
                end
                dxyDispatcher_dispatchEvent("upDateBtnState",data)
                dxyDispatcher_dispatchEvent("upDateUnLock",data["var"])
                break
            end
        end

    elseif cmd == NetEventType.Rec_YuanShen_MagicType then --3025(接收法器属性)
        local id = msg:readUint()
        for key,var in pairs(zzm.YuanShenModel._arrMagic) do
            if var.Id == id then
                local star = msg:readUbyte()
                var["Star"] = star
                var["skillId"] = msg:readUint()
                local skillLv = msg:readUshort()
                var["skillLv"] = skillLv 
                local len = msg:readUbyte()
                for i=1,len do
                    local idx = msg:readUbyte()
                    local type = msg:readUbyte()
                    cn:readPro(msg,type,var)
                end
                if star ~= var["Star"] then
                     zzm.TalkingDataModel:onEvent(EumEventId.MAGIC_UPGRADE,{})
                end
                if skillLv ~=  var["skillLv"] then
                    zzm.TalkingDataModel:onEvent(EumEventId.MAGIC_SKILL_UPGRADE,{})
                end
                dxyDispatcher_dispatchEvent("upGradeStar",var)
                dxyDispatcher_dispatchEvent("upGradeSkill",var)
                dxyDispatcher_dispatchEvent("ConsumeSkill_updateRes",var)
                break                
            end
        end
        
    end
end

return YuanShenController
