local FairyController = FairyController or class("FairyController")

function FairyController:ctor()
    self:registerListener()
end

function FairyController:registerListener()
    _G.NetManagerLuaInst:registerListenner(NetEventType.Rec_Fairy_InitFairy,self)
    _G.NetManagerLuaInst:registerListenner(NetEventType.Rec_Fairy_GiveFlowersSucc,self)
    _G.NetManagerLuaInst:registerListenner(NetEventType.Rec_Fairy_GiveFlowersFail,self)
    _G.NetManagerLuaInst:registerListenner(NetEventType.Rec_Fairy_unLockFairy,self)
    _G.NetManagerLuaInst:registerListenner(NetEventType.Rec_Fairy_unLockFairySkill,self)
    _G.NetManagerLuaInst:registerListenner(NetEventType.Rec_Fairy_SendDoit,self)
    _G.NetManagerLuaInst:registerListenner(NetEventType.Rec_Fairy_overDoit,self)
    _G.NetManagerLuaInst:registerListenner(NetEventType.Rec_Fairy_upDateFV,self)
    _G.NetManagerLuaInst:registerListenner(NetEventType.Rec_Fairy_AllFairyPro,self)
    _G.NetManagerLuaInst:registerListenner(NetEventType.Rec_Fairy_SendDoit,self)
    _G.NetManagerLuaInst:registerListenner(DefineProto.PROTO_FAIRY_RETURN_EQUIP_SKILL,self)
    _G.NetManagerLuaInst:registerListenner(1024,self)
end

function FairyController:unregisterListenner()
    _G.NetManagerLuaInst:unregisterListenner(NetEventType.Rec_Fairy_InitFairy,self)
    _G.NetManagerLuaInst:unregisterListenner(NetEventType.Rec_Fairy_GiveFlowersSucc,self)
    _G.NetManagerLuaInst:unregisterListenner(NetEventType.Rec_Fairy_GiveFlowersFail,self)
    _G.NetManagerLuaInst:unregisterListenner(NetEventType.Rec_Fairy_unLockFairy,self)
    _G.NetManagerLuaInst:unregisterListenner(NetEventType.Rec_Fairy_unLockFairySkill,self)
    _G.NetManagerLuaInst:unregisterListenner(NetEventType.Rec_Fairy_SendDoit,self)
    _G.NetManagerLuaInst:unregisterListenner(NetEventType.Rec_Fairy_overDoit,self)
    _G.NetManagerLuaInst:unregisterListenner(NetEventType.Rec_Fairy_upDateFV,self)
    _G.NetManagerLuaInst:unregisterListenner(NetEventType.Rec_Fairy_AllFairyPro,self)
    _G.NetManagerLuaInst:unregisterListenner(NetEventType.Rec_Fairy_SendDoit,self)
    _G.NetManagerLuaInst:unregisterListenner(DefineProto.PROTO_FAIRY_RETURN_EQUIP_SKILL,self)
    _G.NetManagerLuaInst:unregisterListenner(1024,self)
end

function FairyController:showLayer()
    require "game.fairy.view.FairyLayer"
    local scene = SceneManager:getCurrentScene()
    scene:addChild(FairyLayer:create())
end

---发送消息--------------------------------------------------------------------------
--初始化仙女
--function FairyController:registerInitFairy()
--    local _strMsg = mc.packetData:createWritePacket(NetEventType.Req_Fairy_InitFairy)
--    mc.NetMannager:getInstance():sendMsg(_strMsg)
--    print("send: "..NetEventType.Req_Fairy_InitFairy.."~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~")
--end

--送花
function FairyController:registerGiveFlowers(id)
    local _strMsg = mc.packetData:createWritePacket(NetEventType.Req_Fairy_GiveFlowers)
    _strMsg:writeInt(id)
    mc.NetMannager:getInstance():sendMsg(_strMsg)
    print("send: "..NetEventType.Req_Fairy_GiveFlowers.."~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~")
end

--双修
function FairyController:registerSendDoit(id,hole)
    local _strMsg = mc.packetData:createWritePacket(NetEventType.Req_Fairy_SendDoit)
    _strMsg:writeInt(id)
    _strMsg:writeInt(hole)
    mc.NetMannager:getInstance():sendMsg(_strMsg)
    print("send: "..NetEventType.Req_Fairy_SendDoit.."~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~".." Id:"..id.." Hole:"..hole)
end

--装备技能
function FairyController:skillControll(id,type)
    local _strMsg = mc.packetData:createWritePacket(DefineProto.PROTO_FAIRY_EQUIP_SKILL)
    _strMsg:writeInt(id)
    _strMsg:writeByte(type)
    mc.NetMannager:getInstance():sendMsg(_strMsg)
    print("send: "..DefineProto.PROTO_FAIRY_EQUIP_SKILL.."~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~".." Id:"..id.." type:"..type)
end

---接收消息--------------------------------------------------------------------------
function FairyController:dealMsg(msg)
    local cmd = msg:getCmd()
    if cmd == 1024 then
        local num = msg:readUshort()
        for i=1,num do
            local type = msg:readUbyte()
            if type == 7 then
                local flower = enCharacterAttrType:readMsg(msg,type)
                _G.FairyData.Flower = flower
                dxyDispatcher_dispatchEvent("upDateData")
            end
        end
        
    elseif cmd == NetEventType.Rec_Fairy_InitFairy then --4505
        local len = msg:readUbyte()
        for i=1,len do
            zzm.FairyModel.arrFairyData[i] = {}
            zzm.FairyModel.arrFairyData[i]["Id"] = msg:readUint()         --id
            zzm.FairyModel.arrFairyData[i]["Lv"] = msg:readUshort()       --lv
            zzm.FairyModel.arrFairyData[i]["QE"] = msg:readUbyte()        --品质
            zzm.FairyModel.arrFairyData[i]["FV"] = msg:readUint()         --疲劳
            zzm.FairyModel.arrFairyData[i]["FD"] = msg:readUshort()       --好感
            zzm.FairyModel.arrFairyData[i]["sk_Id"] = msg:readUint()      --技能id
            zzm.FairyModel.arrFairyData[i]["sk_Islock"] = msg:readUbyte() --技能是否解锁
            zzm.FairyModel.arrFairyData[i]["isLock"] = msg:readUbyte()    --仙女是否解锁
            zzm.FairyModel.arrFairyData[i]["curSkill"] = msg:readUbyte()  --仙女技能是否使用中
            zzm.FairyModel.arrFairyData[i]["isDoit"] = msg:readUbyte()    --是否双修
            if zzm.FairyModel.arrFairyData[i]["isDoit"] == 1 then
                zzm.FairyModel.arrFairyData[i]["overTime"] = msg:readUint()--双修结束时间
            end
            
            local proNum = msg:readUbyte()
            for j=1,proNum do
                local key = msg:readUbyte()
                local type = msg:readUbyte()
                if type == 1 then
                    zzm.FairyModel.arrFairyData[i]["Hp"] = msg:readUint()
                elseif type == 2 then
                    zzm.FairyModel.arrFairyData[i]["Mp"] = msg:readUint()
                elseif type == 3 then
                    zzm.FairyModel.arrFairyData[i]["Atk"] = msg:readUint()
                elseif type == 4 then
                    zzm.FairyModel.arrFairyData[i]["Def"] = msg:readUint()
                elseif type == 5 then
                    zzm.FairyModel.arrFairyData[i]["Crit"] = msg:readUint()
                elseif type == 6 then
                    zzm.FairyModel.arrFairyData[i]["Odds"] = msg:readUint()
                elseif type == 7 then
                    zzm.FairyModel.arrFairyData[i]["Speed"] = msg:readUint()
                end
            end
        end
        
    elseif cmd == NetEventType.Rec_Fairy_GiveFlowersSucc then --4510
        zzm.TalkingDataModel:onEvent(EumEventId.FAIRY_TRAIN,{})
        local data = nil
        local id = msg:readUint()
        for i,target in pairs(zzm.FairyModel.arrFairyData) do
            if target.Id == id then
                target["Lv"] = msg:readUshort()
                target["FD"] = msg:readUshort()
                local proNum = msg:readUbyte()
                for j=1,proNum do 
                    local key = msg:readUbyte()
                    local type = msg:readUbyte()
                    if     type == 1 then
                        zzm.FairyModel.arrFairyData[i]["Hp"] = msg:readUint()
                    elseif type == 2 then
                        zzm.FairyModel.arrFairyData[i]["Mp"] = msg:readUint()
                    elseif type == 3 then
                        zzm.FairyModel.arrFairyData[i]["Atk"] = msg:readUint()
                    elseif type == 4 then
                        zzm.FairyModel.arrFairyData[i]["Def"] = msg:readUint()
                    elseif type == 5 then
                        zzm.FairyModel.arrFairyData[i]["Crit"] = msg:readUint()
                    elseif type == 6 then
                        zzm.FairyModel.arrFairyData[i]["Odds"] = msg:readUint()
                    elseif type == 7 then
                        zzm.FairyModel.arrFairyData[i]["Speed"] = msg:readUint()
                    end
                end
                data = zzm.FairyModel.arrFairyData[i]
                break
            end
        end
        UpGradeEffect:show()
        dxyDispatcher_dispatchEvent("updateGiveFlowers",data)
        
    elseif cmd == NetEventType.Rec_Fairy_GiveFlowersFail then --4512
        zzm.TalkingDataModel:onEvent(EumEventId.FAIRY_TRAIN,{})
        local data = nil
        local fd = 0        
        local id = msg:readUint()
        for i,target in pairs(zzm.FairyModel.arrFairyData) do
            if target.Id == id then
                zzm.FairyModel.arrFairyData[i]["FD"] = msg:readUshort()
                fd = zzm.FairyModel.arrFairyData[i]["FD"]
                data = zzm.FairyModel.arrFairyData[i]
                break
            end
        end
        dxyFloatMsg:show("好感度提高到 "..fd)
        dxyDispatcher_dispatchEvent("updateGiveFlowers",data)
        
    elseif cmd == NetEventType.Rec_Fairy_unLockFairy then --4515（仙女解锁）
        local id = msg:readUint()
        local num = nil
        for i,target in pairs(zzm.FairyModel.arrFairyData) do
            if target.Id == id then
                zzm.FairyModel.arrFairyData[i]["isLock"] = msg:readUbyte()
                num = i
                local len = msg:readUbyte()
                for j=1,len do
                    local idx = msg:readUbyte()
                    local type = msg:readUbyte()
                    if type == 1 then
                        zzm.FairyModel.arrFairyData[i]["Hp"] = msg:readUint()
                    elseif type == 2 then
                        zzm.FairyModel.arrFairyData[i]["Mp"] = msg:readUint()
                    elseif type == 3 then
                        zzm.FairyModel.arrFairyData[i]["Atk"] = msg:readUint()
                        print(zzm.FairyModel.arrFairyData[i]["Atk"])
                    elseif type == 4 then
                        zzm.FairyModel.arrFairyData[i]["Def"] = msg:readUint()
                    elseif type == 5 then
                        zzm.FairyModel.arrFairyData[i]["Crit"] = msg:readUint()
                    elseif type == 6 then
                        zzm.FairyModel.arrFairyData[i]["Odds"] = msg:readUint()
                    elseif type == 7 then
                        zzm.FairyModel.arrFairyData[i]["Speed"] = msg:readUint()
                    end
                end
                break
            end
        end
       if zzc.GuideController:checkFunctionTips(enFunctionType.XianNv) == true then
            dxyFloatMsg:show("解锁了一个仙女")
        end
        dxyDispatcher_dispatchEvent("unLockFairy",num)
    
    elseif cmd == NetEventType.Rec_Fairy_unLockFairySkill then --4540（技能解锁）
        local id = msg:readUint()
        local num = nil
        local data = nil
        for i,target in pairs(zzm.FairyModel.arrFairyData) do
            if target.Id == id then
                target.sk_Islock = msg:readUbyte()
                num = i
                data = target
                break
            end
        end
        dxyFloatMsg:show("解锁了仙女技能")
        dxyDispatcher_dispatchEvent("unLockFairy",num)
        dxyDispatcher_dispatchEvent("unLockSkill",data)
        
    elseif cmd == NetEventType.Rec_Fairy_overDoit then --4528
        local id = msg:readUint()
        local data = nil
        for i,target in pairs(zzm.FairyModel.arrFairyData) do
            if target.Id == id then
                target.isDoit = msg:readUbyte()
                local Exp = msg:readUint()
                TipsFrame:create("双修结束,获得: "..Exp.." 经验")
                data = target
                break
            end
        end
        dxyDispatcher_dispatchEvent("updateDoit",data)
        
    elseif cmd == NetEventType.Rec_Fairy_upDateFV then --4535
        local id = msg:readUint()
        local data = nil
        for i,target in pairs(zzm.FairyModel.arrFairyData) do
            if target.Id == id then
                target.FV = msg:readUint()
                data = target
                break
            end
        end
        dxyDispatcher_dispatchEvent("FairyNode_updatePower",data)
    
    elseif cmd == NetEventType.Rec_Fairy_AllFairyPro then --4545
        _G.FairyData["Hp"] = msg:readUint()
        _G.FairyData["Atk"] = msg:readUint()
        _G.FairyData["Def"] = msg:readUint()
        dxyDispatcher_dispatchEvent("upDatePro")
        
    elseif cmd == NetEventType.Rec_Fairy_SendDoit then --4525
        zzm.TalkingDataModel:onEvent(EumEventId.FRAIRY_DOUBLEREPAIR,{})
        local id = msg:readUint()
        local nowTime = nil
        local data = nil
        local num = nil
        for i,target in pairs(zzm.FairyModel.arrFairyData) do
            if target.Id == id then
                target.FV = msg:readUint()
                target.isDoit = msg:readUbyte()
                nowTime = msg:readUint()
                target.overTime = msg:readUint()
                data = target
                num = i
                break
            end
        end
        dxyDispatcher_dispatchEvent("updateDoit",data)
        dxyDispatcher_dispatchEvent("FairyNode_updatePower",data)
        dxyDispatcher_dispatchEvent("closeWin")
        
    elseif cmd == DefineProto.PROTO_FAIRY_RETURN_EQUIP_SKILL then --4555(技能选项)
        local id = msg:readUint()
        local curSkill = msg:readUbyte()
        for key, var in pairs(zzm.FairyModel.arrFairyData) do
        	if var.Id == id then
                var.curSkill = curSkill
                dxyDispatcher_dispatchEvent("FairySkill_updateSkillState",var)
                break
        	end
        end
        
        
    end
end

return FairyController