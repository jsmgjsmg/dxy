local GeneralController = GeneralController or class("GeneralController")

function GeneralController:ctor()
    self:registerListener()
end

function GeneralController:registerListener()
    _G.NetManagerLuaInst:registerListenner(NetEventType.Rec_General_InitStage,self)
    _G.NetManagerLuaInst:registerListenner(NetEventType.Rec_General_InitFragment,self)
    _G.NetManagerLuaInst:registerListenner(NetEventType.Rec_General_InitGeneral,self)
    _G.NetManagerLuaInst:registerListenner(NetEventType.Rec_General_AddFragment,self)
    _G.NetManagerLuaInst:registerListenner(NetEventType.Rec_General_UpDateFragment,self)
    _G.NetManagerLuaInst:registerListenner(NetEventType.Rec_General_AddGeneral,self)
    _G.NetManagerLuaInst:registerListenner(NetEventType.Rec_General_UpGradeStar,self)
    _G.NetManagerLuaInst:registerListenner(NetEventType.Rec_General_DestroyFragment,self)
    _G.NetManagerLuaInst:registerListenner(NetEventType.Rec_General_DestroyGeneral,self)
    _G.NetManagerLuaInst:registerListenner(NetEventType.Rec_General_FightGeneral,self)
    _G.NetManagerLuaInst:registerListenner(NetEventType.Rec_General_PutDownGeneral,self)
    _G.NetManagerLuaInst:registerListenner(NetEventType.Rec_General_AddSoul,self)
    _G.NetManagerLuaInst:registerListenner(NetEventType.Rec_General_AllPro,self)
    _G.NetManagerLuaInst:registerListenner(NetEventType.Rec_General_ToPlayer,self)
    _G.NetManagerLuaInst:registerListenner(NetEventType.Rec_General_UpDateGeneral,self)
    _G.NetManagerLuaInst:registerListenner(NetEventType.Rec_General_Tips,self)
    _G.NetManagerLuaInst:registerListenner(NetEventType.Rec_General_ConvertFragment,self)
    _G.NetManagerLuaInst:registerListenner(DefineProto.PROTO_COPY_RETURN_REFRESH_GODCOPY,self)
    _G.NetManagerLuaInst:registerListenner(1024,self)
end

function GeneralController:unregisterListenner()
    _G.NetManagerLuaInst:unregisterListenner(NetEventType.Rec_General_InitStage,self)
    _G.NetManagerLuaInst:unregisterListenner(NetEventType.Rec_General_InitFragment,self)
    _G.NetManagerLuaInst:unregisterListenner(NetEventType.Rec_General_InitGeneral,self)
    _G.NetManagerLuaInst:unregisterListenner(NetEventType.Rec_General_AddFragment,self)
    _G.NetManagerLuaInst:unregisterListenner(NetEventType.Rec_General_UpDateFragment,self)
    _G.NetManagerLuaInst:unregisterListenner(NetEventType.Rec_General_AddGeneral,self)
    _G.NetManagerLuaInst:unregisterListenner(NetEventType.Rec_General_UpGradeStar,self)
    _G.NetManagerLuaInst:unregisterListenner(NetEventType.Rec_General_DestroyFragment,self)
    _G.NetManagerLuaInst:unregisterListenner(NetEventType.Rec_General_DestroyGeneral,self)
    _G.NetManagerLuaInst:unregisterListenner(NetEventType.Rec_General_PutDownGeneral,self)
    _G.NetManagerLuaInst:unregisterListenner(NetEventType.Rec_General_AddSoul,self)
    _G.NetManagerLuaInst:unregisterListenner(NetEventType.Rec_General_UpDateGeneral,self)
    _G.NetManagerLuaInst:unregisterListenner(NetEventType.Rec_General_Tips,self)
    _G.NetManagerLuaInst:unregisterListenner(NetEventType.Rec_General_ConvertFragment,self)
    _G.NetManagerLuaInst:unregisterListenner(DefineProto.PROTO_COPY_RETURN_REFRESH_GODCOPY,self)
    _G.NetManagerLuaInst:unregisterListenner(1024,self)
end

function GeneralController:showLayer()
    require "game.general.view.GeneralLayer"
    local scene = SceneManager:getCurrentScene()
    self._layer = GeneralLayer:create()
    scene:addChild(self._layer)  
    zzm.GeneralModel.isOnGeneral = true
    return self._layer
end

---发送消息------------------------------------------------------
--碎片合成
function GeneralController:sendMergerMsg(id)
    local _strMsg = mc.packetData:createWritePacket(NetEventType.Req_General_Merger)
    _strMsg:writeInt(id)
    mc.NetMannager:getInstance():sendMsg(_strMsg)
    print("~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~send: "..NetEventType.Req_General_Merger.." pro: "..id)
end

--神将升星
function GeneralController:sendUpStarMsg(id)
    local _strMsg = mc.packetData:createWritePacket(NetEventType.Req_General_UpGradeStar)
    _strMsg:writeInt(id)
    mc.NetMannager:getInstance():sendMsg(_strMsg)
    print("~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~send: "..NetEventType.Req_General_UpGradeStar.." pro: "..id)
end

--单个分解
function GeneralController:DestroyThing(id,num)
    local _strMsg = mc.packetData:createWritePacket(NetEventType.Req_General_DestroyOne)
    _strMsg:writeInt(id)
    _strMsg:writeInt(num)
    mc.NetMannager:getInstance():sendMsg(_strMsg)
    print("~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~send: "..NetEventType.Req_General_DestroyOne.." id"..id.." num"..num)
end

--多选分解
function GeneralController:DestroyMore(data,type)
    local _strMsg = mc.packetData:createWritePacket(NetEventType.Req_General_DestroyMore)
    _strMsg:writeByte(data[1])
    for i=1,data[1] do
        _strMsg:writeByte(data[2][i])
        print("~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~send: "..NetEventType.Req_General_DestroyMore.." Num: "..data[1].." type: "..type.." data: "..data[2][i])
    end
    mc.NetMannager:getInstance():sendMsg(_strMsg)
end

--兑换
function GeneralController:ConvertFragment(id,num)
    local _strMsg = mc.packetData:createWritePacket(NetEventType.Req_General_ConvertFragment)
    _strMsg:writeInt(id)
    _strMsg:writeShort(num)
    mc.NetMannager:getInstance():sendMsg(_strMsg)
    print("~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~send: "..NetEventType.Req_General_ConvertFragment.." id: "..id.." num: "..num)
end

--出战
function GeneralController:FightGeneral(id)
    local _strMsg = mc.packetData:createWritePacket(NetEventType.Req_General_FightGeneral)
    _strMsg:writeInt(id)
    mc.NetMannager:getInstance():sendMsg(_strMsg)
    print("~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~send: "..NetEventType.Req_General_FightGeneral.." id: "..id)
end

--卸下
function GeneralController:putDownGeneral()
    local _strMsg = mc.packetData:createWritePacket(NetEventType.Req_General_PutDownGeneral)
    mc.NetMannager:getInstance():sendMsg(_strMsg)
    print("~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~send: "..NetEventType.Req_General_PutDownGeneral)
end

--吸魂
function GeneralController:AddSoul()
    local _strMsg = mc.packetData:createWritePacket(NetEventType.Req_General_AddSoul)
    mc.NetMannager:getInstance():sendMsg(_strMsg)
    print("~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~send: "..NetEventType.Req_General_AddSoul)
end

--刷新副本
function GeneralController:UpDateCopy()
    dxyWaitBack:show()
    local _strMsg = mc.packetData:createWritePacket(DefineProto.PROTO_COPY_REFRESH_GODCOPY)
    mc.NetMannager:getInstance():sendMsg(_strMsg)
    print("~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~send: "..DefineProto.PROTO_COPY_REFRESH_GODCOPY)
end
--    PROTO_COPY_REFRESH_GODCOPY                       = 4120,      -- 刷新神将副本
--    PROTO_COPY_RETURN_REFRESH_GODCOPY                = 4125,      -- 返回刷新神将副本

---接收消息------------------------------------------------------
function GeneralController:dealMsg(msg)
    local cmd = msg:getCmd()
    if cmd == NetEventType.Rec_General_InitStage then --7068(初始化封神台)
        _G.GeneralData.Lv = msg:readUshort()
        _G.GeneralData.Exp = msg:readUint()
        _G.GeneralData.Atk = msg:readUint()
        _G.GeneralData.Def = msg:readUint()
        _G.GeneralData.Hp = msg:readUint()
    
    elseif cmd == NetEventType.Rec_General_InitFragment then --7005(初始化碎片)
        local len = msg:readUbyte()
        for i=1,len do
            local data = {}
            data["Id"] = msg:readUint()
            data["Num"] = msg:readUshort()
            data.Config = GodGeneralConfig:getGeneralData(data["Id"],2)
            if data.Config then
                zzm.GeneralModel:initFragment(data)
            end
        end
        
    elseif cmd == NetEventType.Rec_General_InitGeneral then --7010(初始化神将)
        _G.GeneralData.Current = 0
        local add = {}
        zzm.GeneralModel.General["allAtk"] = msg:readUint()
        zzm.GeneralModel.General["allDef"] = msg:readUint()
        zzm.GeneralModel.General["allHp"] = msg:readUint()
        zzm.GeneralModel.General["useAtk"] = msg:readUint()
        zzm.GeneralModel.General["useDef"] = msg:readUint()
        zzm.GeneralModel.General["useHp"] = msg:readUint()
        
        local len = msg:readUbyte()
        for i=1,len do
            local data = {}
            data["Id"] = msg:readUint()
            data["Quality"] = msg:readUbyte()
            data["Star"] = msg:readUbyte()
            data["isCur"] = msg:readUbyte()
            if data["isCur"] == 1 then
                _G.GeneralData.Current = data["Id"]
            end
            local len2 = msg:readUbyte()
            for j=1,len2 do
                local type = msg:readUbyte()
                cn:readPro(msg,type,data)
            end
            zzm.GeneralModel:initGeneralCard(data)
            if i == len then
                print(i.."**************************************"..len.."////////////////////////////////////")
                zzm.GeneralModel:RankGeneralCard()
            end
        end
        
    elseif cmd == NetEventType.Rec_General_AddFragment then --7012（新增碎片）
        local data = {}
        data["Id"] = msg:readUint()
        data["Num"] = msg:readUshort()
        data.Config = GodGeneralConfig:getGeneralData(data["Id"],2)
        if data.Config then
            zzm.GeneralModel:addFragment(data)
        end
    
    elseif cmd == NetEventType.Rec_General_UpDateFragment then --7013（更新碎片）
        local id = msg:readUint()
        for i,target in pairs(zzm.GeneralModel.Fragment) do
            if target["Id"] == id then
                local newNum = msg:readUshort()
                if target["Num"] < newNum then
                    local temp = newNum - target["Num"]
                    if zzm.GeneralModel.isOnGeneral then
                        dxyFloatMsg:show(GoodsConfigProvider:findGoodsById(id).Name.." +"..temp)
                    end
                end 
                target["Num"] = newNum
                zzm.GeneralModel:changeFragment(target)
                break
            end
        end
        
    elseif cmd == NetEventType.Rec_General_AddGeneral then  --7019（新增神将）
        local data = {}
        data["Id"] = msg:readUint()
        data["Quality"] = msg:readUbyte()
        data["Star"] = msg:readUbyte()
        data["isCur"] = msg:readUbyte()
        if data["isCur"] == 1 then
            _G.GeneralData.Current = data["Id"]
        end
        local len2 = msg:readUbyte()
        for j=1,len2 do
            local type = msg:readUbyte()
            cn:readPro(msg,type,data)
        end
        zzm.GeneralModel:addGeneralCard(data)
        zzm.GeneralModel:RankGeneralCard()
        dxyFloatMsg:show("合成成功")
        dxyDispatcher_dispatchEvent("GeneralFS_updateFS")
        dxyDispatcher_dispatchEvent("ResForMerger_updatePro",data)
        
    elseif cmd == NetEventType.Rec_General_UpGradeStar then --7025（神将升星）
        zzm.TalkingDataModel:onEvent(EumEventId.GENERAL_UPGRADE,{})
        local id = msg:readUint()
        for i,target in pairs(zzm.GeneralModel.General.Card) do
            if target.Id == id then
                target["Star"] = msg:readUbyte()
                local len = msg:readUbyte()
                for j=1,len do
                    local type = msg:readUbyte()
                    cn:readPro(msg,type,target)
                end
                zzm.GeneralModel:updateStar(target)
                break
            end
        end
        
    elseif cmd == NetEventType.Rec_General_DestroyFragment then --7036（碎片分解）
        local len = msg:readUbyte()
        for i=1,len do
            local id = msg:readUint()
            zzm.GeneralModel:delFragment(id)
        end
        
    elseif cmd == NetEventType.Rec_General_DestroyGeneral then --7028(神将分解)
        local len = msg:readUbyte()
        for i=1,len do
            local id = msg:readUint()
            zzm.GeneralModel:delGeneral(id)
        end
    
    elseif cmd == NetEventType.Rec_General_FightGeneral then --7045(更换出战神将)
        local id = msg:readUint()
        for key, var in ipairs(zzm.GeneralModel.General.Card) do
        	if var.Id == id then
        	   var.isCur = msg:readUbyte()
        	   if var.isCur == 1 then
                    _G.GeneralData.Current = var.Id
        	   end
        	   break
        	end
        end
        zzm.GeneralModel:updateFight()
    
    elseif cmd == NetEventType.Rec_General_PutDownGeneral then --7052(卸下神将)
        local id = msg:readUint()
        _G.GeneralData.Current = 0
        zzm.GeneralModel:updateFight(id)
    
    elseif cmd == NetEventType.Rec_General_AddSoul then --7060(接收神台吸魂)
        _G.GeneralData.Lv = msg:readUshort()
        _G.GeneralData.Exp = msg:readUint() 
        _G.GeneralData.Atk = msg:readUint()
        _G.GeneralData.Def = msg:readUint()
        _G.GeneralData.Hp = msg:readUint()
        dxyDispatcher_dispatchEvent("updateAddSoul")
    
    elseif cmd == NetEventType.Rec_General_AllPro then --7070(接收封神总属性)
        zzm.GeneralModel.General["allAtk"] = msg:readUint()
        zzm.GeneralModel.General["allDef"] = msg:readUint()
        zzm.GeneralModel.General["allHp"] = msg:readUint()
        dxyDispatcher_dispatchEvent("GeneralFS_ComputePro")
    
    elseif cmd == NetEventType.Rec_General_ToPlayer then --7072(接收封神对角色属性)
        zzm.GeneralModel.General["useAtk"] = msg:readUint()
        zzm.GeneralModel.General["useDef"] = msg:readUint()
        zzm.GeneralModel.General["useHp"] = msg:readUint()
        dxyDispatcher_dispatchEvent("GeneralFS_ComputePro")
        
    elseif cmd == NetEventType.Rec_General_UpDateGeneral then --7075(接收更新神将属性)
        local data = {}
        local len = msg:readUbyte()
        for i=1,len do
            data.Id = msg:readUint()
            local len2 = msg:readUbyte()
            for j=1,len2 do
                local type = msg:readUbyte()
                cn:readPro(msg,type,data)
                zzm.GeneralModel:updateAllCard(data)
            end
        end
        
    elseif cmd == NetEventType.Rec_General_Tips then --7065(Tips)
        zzm.TalkingDataModel:onEvent(EumEventId.GENERAL_STAGE_TARIN,{})
        local crit = msg:readUbyte()
        local exp = msg:readUint()
        zzm.GeneralModel:TipsSchedule("获得经验:"..exp,crit)
    
    elseif cmd == NetEventType.Rec_General_ConvertFragment then --7014(兑换碎片)
        local num = msg:readUshort()
        for i=1,num do
            zzm.TalkingDataModel:onEvent(EumEventId.GENERAL_FRAGMENT_EXCHANGE,{})
        end
        
    elseif cmd == DefineProto.PROTO_COPY_RETURN_REFRESH_GODCOPY then --4125(返回刷新神将副本)
        zzm.GeneralModel._GNCopyDFC = msg:readUbyte()
        zzm.GeneralModel._GNCopyMST = msg:readUint()
        dxyDispatcher_dispatchEvent("GNCopyUD")
        
    end
end

return GeneralController
