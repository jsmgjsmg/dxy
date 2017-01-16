
local CharacterController = CharacterController or class("CharacterController")

_G.SkillList = _G.SkillList or {}

function CharacterController:ctor()
    self.m_view = nil
    self._model = nil
    self:initController()
    self:initCTSkill()
    self:initEvent()
end 

function CharacterController:initEvent()
	dxyDispatcher_addEventListener("TalkingDataUpdate",self,self.updateTalkingData)
end

function CharacterController:updateTalkingData(data)
    local enCAT = enCharacterAttrType
    if data.type == enCAT.LV then
		zzm.TalkingDataModel:setLevel(data.value)  
	end
end

function CharacterController:initCTSkill()
    _G.CTSkillList = _G.CTSkillList or {}
    for i = 1, 3 do
        _G.CTSkillList[i] = {}
        for n = 1,6 do
            _G.CTSkillList[i][n] = {}
        end
    end

end

function CharacterController:initController()
    self._model = zzm.LoginModel
    self:registerListenner()
    print("CharacterController initController")
end

function CharacterController:getLayer()
    if _G.backPack == nil then
        require("game.equip.view.CharacterLayer")
        _G.backPack = CharacterLayer.create()
        _G.backPack:retain()
    end
    return _G.backPack
end

function CharacterController:showLayer()
    local scene = SceneManager:getCurrentScene()
    UIManager:addUI(self:getLayer(), "CharacterLayer")
    scene:addChild(self:getLayer())
    zzm.CharacterModel.isTipsToGoods = false
end

function CharacterController:closeLayer()
    if _G.backPack then
        UIManager:closeUI("CharacterLayer")
--        self.m_view = nil
    end
    zzm.CharacterModel.isTipsToGoods = true
end

function CharacterController:releaseLayer()
    if _G.backPack then   	
        _G.backPack:release()
        _G.backPack = nil
    end
end

-----------------------------------------------------------------
--Network 
--
--initNetwork
function CharacterController:registerListenner()
    _G.NetManagerLuaInst:registerListenner(NetEventType.Rec_Backpack_Back,self)
    _G.NetManagerLuaInst:registerListenner(NetEventType.Rec_Backpack_Add,self)
    _G.NetManagerLuaInst:registerListenner(NetEventType.Rec_Backpack_Del,self)
    _G.NetManagerLuaInst:registerListenner(NetEventType.Rec_RoleAttr_Update,self)
    _G.NetManagerLuaInst:registerListenner(NetEventType.Rec_Look_RoleAttr_Back,self)
    _G.NetManagerLuaInst:registerListenner(NetEventType.Rec_Swallow_Succeed,self)
    _G.NetManagerLuaInst:registerListenner(NetEventType.Rec_Melting_EquipAttr,self)
    _G.NetManagerLuaInst:registerListenner(NetEventType.Rec_Spirit_Strengthen_Result,self)
    _G.NetManagerLuaInst:registerListenner(NetEventType.Rec_Spirit_Resolve_Result,self)
    _G.NetManagerLuaInst:registerListenner(DefineProto.PROTO_GOODS_RETURN_EQUIP_SELL,self)
   -- _G.NetManagerLuaInst:registerListenner(NetEventType.Rec_Skill_List,self)
   -- _G.NetManagerLuaInst:registerListenner(NetEventType.Rec_CTSkill_List,self)
end

function CharacterController:unregisterListenner()
    _G.NetManagerLuaInst:unregisterListenner(NetEventType.Rec_Backpack_Back,self)
    _G.NetManagerLuaInst:unregisterListenner(NetEventType.Rec_Backpack_Add,self)
    _G.NetManagerLuaInst:unregisterListenner(NetEventType.Rec_Backpack_Del,self)
    _G.NetManagerLuaInst:unregisterListenner(NetEventType.Rec_RoleAttr_Update,self)
    _G.NetManagerLuaInst:unregisterListenner(NetEventType.Rec_Look_RoleAttr_Back,self)
    _G.NetManagerLuaInst:unregisterListenner(NetEventType.Rec_Swallow_Succeed,self)
    _G.NetManagerLuaInst:unregisterListenner(NetEventType.Rec_Melting_EquipAttr,self)
    _G.NetManagerLuaInst:unregisterListenner(NetEventType.Rec_Spirit_Strengthen_Result,self)
    _G.NetManagerLuaInst:unregisterListenner(NetEventType.Rec_Spirit_Resolve_Result,self)
    _G.NetManagerLuaInst:unregisterListenner(DefineProto.PROTO_GOODS_RETURN_EQUIP_SELL,self)
   -- _G.NetManagerLuaInst:unregisterListenner(NetEventType.Rec_Skill_List,self)
    --_G.NetManagerLuaInst:unregisterListenner(NetEventType.Rec_CTSkill_List,self)
end

-----------------------------------------------------------------
--Request
-- 请求背包 Request Type Req_Role_Backpack  Receive Type Rec_Backpack_Back
function CharacterController:request_Backpack()
    print("request_Backpack  ")
    local msg = mc.packetData:createWritePacket(NetEventType.Req_Role_Backpack); --编写发送包
    mc.NetMannager:getInstance():sendMsg(msg); --发送 包
end

-- 请求使用物品，穿装备 Request Type Req_Backpack_UseItem  Receive Type Rec_Backpack_Del
function CharacterController:request_UseItem(idx)
    print("request_UseItem  ")
    local msg = mc.packetData:createWritePacket(NetEventType.Req_Backpack_UseItem); --编写发送包
    msg:writeShort(idx)
    mc.NetMannager:getInstance():sendMsg(msg); --发送 包
end

-- 请求脱装备 Request Type Req_Backpack_CastEquip  Receive Type Rec_Backpack_Add
function CharacterController:request_CastEquip(idx)
    print("request_CastEquip  " ..idx)
    local msg = mc.packetData:createWritePacket(NetEventType.Req_Backpack_CastEquip); --编写发送包
    msg:writeShort(idx)
    mc.NetMannager:getInstance():sendMsg(msg); --发送 包
end

-- 请求吞噬装备 Request Type Req_Swallow_Equip  Receive Type Rec_Swallow_Succeed
--{subType = 1, {1,2,3,4}}
function CharacterController:request_SwallowEquip(data)
    print("request_SwallowEquip  ")
    --dxyWaitBack:show({NetEventType.Rec_Swallow_Succeed})
    --dxyWaitBack:show()
    local msg = mc.packetData:createWritePacket(NetEventType.Req_Swallow_Equip); --编写发送包
    msg:writeShort(data.subType)
    msg:writeShort(#data.list)
    for index=1, #data.list do
        msg:writeShort(data.list[index])
    end
    mc.NetMannager:getInstance():sendMsg(msg); --发送 包
end

--请求熔炼装备Request Type Req_Melting_Equip  Receive Type Rec_Melting_EquipAttr
--{idx_attr = 1,idx_goods = 1}
function CharacterController:request_MeltingEquip(data)
    print("request_MeltingEquip")
    local msg = mc.packetData:createWritePacket(NetEventType.Req_Melting_Equip); --编写发送包
    msg:writeShort(data.idx_attr)
    msg:writeShort(data.idx_goods)
    mc.NetMannager:getInstance():sendMsg(msg); --发送 包
end

--请求熔炼后恢复原来的属性Request Type Req_Melting_RecoverAttr
function CharacterController:request_Melting_RecoverAttr()
    print("request_Melting_RecoverAttr")
    local msg = mc.packetData:createWritePacket(NetEventType.Req_Melting_RecoverAttr); --编写发送包
    mc.NetMannager:getInstance():sendMsg(msg); --发送 包
end

--请求装备器灵Req_Spirit_UseItem
function CharacterController:request_UseSpirit(idx)
    print("request_UseSpirit  ")
    local msg = mc.packetData:createWritePacket(NetEventType.Req_Spirit_UseItem); --编写发送包
    msg:writeShort(idx)
    mc.NetMannager:getInstance():sendMsg(msg); --发送 包
end

--请求脱下器灵Req_Spirit_CastSpirit
function CharacterController:request_CastSpirit(idx)
    print("request_CastSpirit  ")
    local msg = mc.packetData:createWritePacket(NetEventType.Req_Spirit_CastSpirit); --编写发送包
    msg:writeShort(idx)
    mc.NetMannager:getInstance():sendMsg(msg); --发送 包
end

--请求分解器灵Req_Spirit_Resolve
--data = {typelen,typeList={1,2,3,4,5}}
function CharacterController:request_Resolve(data)
    print("request_Resolve")
    local msg = mc.packetData:createWritePacket(NetEventType.Req_Spirit_Resolve); --编写发送包
    msg:writeByte(#data.typeList)
    for var=1, #data.typeList do
        msg:writeByte(data.typeList[var])
    end
    mc.NetMannager:getInstance():sendMsg(msg); --发送 包
end

--请求分解单件器灵Req_Spirit_oneResolve
function CharacterController:request_oneResolve(idx)
	print("request_oneResolve"..idx)
    local msg = mc.packetData:createWritePacket(NetEventType.Req_Spirit_oneResolve); --编写发送包
    msg:writeShort(idx)
    mc.NetMannager:getInstance():sendMsg(msg); --发送 包
end

--请求强化器灵Req_Spirit_Strengthen
--data = {isUse=0or1,type=1or3,idx=1}
function CharacterController:request_Strengthen(data)
    print("request_Strengthen")
    local msg = mc.packetData:createWritePacket(NetEventType.Req_Spirit_Strengthen); --编写发送包
    msg:writeByte(data.isUse)
    msg:writeByte(data.type)
    msg:writeShort(data.idx)
    mc.NetMannager:getInstance():sendMsg(msg); --发送 包
end

--请求获取技能列表
function CharacterController:request_SkillList()
    local msg = mc.packetData:createWritePacket(NetEventType.Req_Skill_List); --编写发送包
    mc.NetMannager:getInstance():sendMsg(msg); --发送 包
end

--请求解锁技能
function CharacterController:request_DeblockSkill(id)
    local msg = mc.packetData:createWritePacket(NetEventType.Req_Deblock_Skill); --编写发送包
    msg:writeInt(id)
    mc.NetMannager:getInstance():sendMsg(msg); --发送 包
end

--请求升级技能
function CharacterController:request_UpgradeSkill(id)
    local msg = mc.packetData:createWritePacket(NetEventType.Req_Upgrade_Skill); --编写发送包
    msg:writeInt(id)
    mc.NetMannager:getInstance():sendMsg(msg); --发送 包
end

--请求发送技能链
function CharacterController:request_CTSkillList()
    local msg = mc.packetData:createWritePacket(NetEventType.Req_CTSkill_List); --编写发送包
    mc.NetMannager:getInstance():sendMsg(msg); --发送 包
end

--请求放置技能到技能链
function CharacterController:request_CTSkillAddSkill(chainId,idx,skill_id)
    local msg = mc.packetData:createWritePacket(NetEventType.Req_CTSkill_AddSkill); --编写发送包
    msg:writeByte(chainId)
    msg:writeByte(idx)
    msg:writeInt(skill_id)
    mc.NetMannager:getInstance():sendMsg(msg); --发送 包
end

--请求解锁技能链
function CharacterController:request_CTSkillDeblock(chainId,idx)
    local msg = mc.packetData:createWritePacket(NetEventType.Req_CTSkill_Deblock); --编写发送包
    msg:writeByte(chainId)
    msg:writeByte(idx)
    mc.NetMannager:getInstance():sendMsg(msg); --发送 包
end

--单件出售装备
function CharacterController:request_EquipSell(idx)
    print("request_EquipSell")
	local msg = mc.packetData:createWritePacket(DefineProto.PROTO_GOODS_EQUIP_SELL); --编写发送包
    msg:writeShort(idx)
    mc.NetMannager:getInstance():sendMsg(msg); --发送 包
end

--一键出售装备
--data = {typelen,typeList={1,2,3,4,5}}
function CharacterController:request_autoEquipSell(data)
    print("request_autoEquipSell")
    local msg = mc.packetData:createWritePacket(DefineProto.PROTO_GOODS_EQUIP_MORE_SELL); --编写发送包
    msg:writeByte(#data.typeList)
    for var=1, #data.typeList do
        msg:writeByte(data.typeList[var])
    end
    mc.NetMannager:getInstance():sendMsg(msg); --发送 包
end

-----------------------------------------------------------------
--Receive
function CharacterController:dealMsg(msg)
    local cmdType = msg:getpacketCmdType()
    if cmdType == NetEventType.Rec_RoleAttr_Update then
        local gold = _G.RoleData.Gold
        local rmb = _G.RoleData.RMB
        local power = 0
        local count = msg:readUshort()
        print("Rec_RoleAttr_Update count:"..count)
        for index=1, count do
            local type = msg:readByte()
            local value = enCharacterAttrType:readUpdateMsg(msg,type)
            zzm.CharacterModel:updateCharacterData(type, value)
            if type == 2 then
                _G.gRoleRMB = value
            end
        end
                
    elseif cmdType == NetEventType.Rec_Backpack_Back then

        local max = msg:readUshort()
        local count = msg:readUshort()
        print( max .. " -----------1 " .. count)
        for index=1, count do
            local goods = zzd.GoodsData.new()
            goods.backpackType = enBackpackType.BACKPACK
            goods:readMsg(msg)
            if goods.config then          	
                zzm.CharacterModel:insertGoods(goods)
            else
                print("出问题的序号:"..count)
            end
        end
        
    elseif cmdType == NetEventType.Rec_Backpack_Add then
        local type = msg:readByte()
        local count = msg:readUshort()
        for index=1, count do
            local goods = zzd.GoodsData.new()
            goods.backpackType = type
            goods:readMsg(msg)
            if goods.config then
                zzm.CharacterModel:addGoods(goods)
                if zzm.CharacterModel.isTipsToGoods and SceneManager.m_curSceneName ~= "GameScene" then
--                    cn:TipsSchedule(goods.config.Name.." +"..goods.count or 1)
                    cn:TipsSchedule("获得： "..goods.config.Name)
                end
            else
                print("出问题的序号:"..count)
            end
        end
        
        dxyDispatcher_dispatchEvent("MainScene_updateRoleTips")
  
    elseif cmdType == NetEventType.Rec_Backpack_Del then
        local type = msg:readByte()
        local count = msg:readUshort()
        print(" -----------3 type:" ..type .. "  count" .. count)
        for index=1, count do
            local idx = msg:readUshort()
            zzm.CharacterModel:removeGoods(type, idx)
        end
        
        dxyDispatcher_dispatchEvent("MainScene_updateRoleTips")
        
    elseif cmdType == NetEventType.Rec_Look_RoleAttr_Back then
        print(" -----------4 ")
        --角色数据，在申请进入游戏返回时已建立角色数据，现在对部分属性赋值
        local role = zzm.CharacterModel:getCharacterData()
        role:readMsg(msg)
    elseif cmdType == NetEventType.Rec_Swallow_Succeed then
        zzm.TalkingDataModel:onEvent(EumEventId.EQUIP_STRENGTHEN,{})
        dxyDispatcher_dispatchEvent(dxyEventType.EquipStrengthen_Effect)
        SoundsFunc_playSounds(SoundsType.SUCCEED,false)
        local subType = msg:readUshort()
        print("---------5 subType:"..subType)
    elseif cmdType == NetEventType.Rec_Melting_EquipAttr then
        --接收熔炼随机到的属性索引
        local idx_attr = msg:readUshort()
        print("---------6 idx_attr:"..idx_attr)
        zzm.CharacterModel:updateMeltingData(idx_attr)
        
        --调用熔炼确认界面
        dxyDispatcher_dispatchEvent(dxyEventType.EquipSmelting_Confirm)
    elseif cmdType == NetEventType.Rec_Spirit_Strengthen_Result then
        --接收器灵强化结果
        local result = msg:readByte()
        if result == 1 then
            SoundsFunc_playSounds(SoundsType.SUCCEED,false)
            dxyFloatMsg:show("强化成功")
        elseif result == 0 then
            SoundsFunc_playSounds(SoundsType.FAILE_TO_USE,false)
            dxyFloatMsg:show("强化失败")
        end
    elseif cmdType == NetEventType.Rec_Spirit_Resolve_Result then
        --接收器灵分解获得的灵气
        local anima = msg:readInt()
        local amulet = msg:readInt()
        if amulet ~= 0 then        	
            dxyFloatMsg:show("分解获得"..anima.."灵气和 "..amulet.."护符")
        else
            dxyFloatMsg:show("分解获得"..anima.."灵气")
        end
    elseif cmdType == DefineProto.PROTO_GOODS_RETURN_EQUIP_SELL then
        --接收装备分解获得的金币
        local gold = msg:readUint()
        dxyFloatMsg:show("出售获得"..gold.."铜钱")
    end
    -- 默认返回false ，表示不中断读取下一个msg
    return false

end

function CharacterController:getSkillList(list)
    for i = 1 , #_G.SkillList do
        if _G.SkillList[i].id == list.id then
            _G.SkillList[i].lv = list.lv
            return
        end
    end
    _G.SkillList[#_G.SkillList+1] = list
    return
end

return CharacterController

