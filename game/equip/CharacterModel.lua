local CharacterModel = class("CharacterModel")
CharacterModel.__index = CharacterModel

function CharacterModel:ctor()
	self.itemIconList ={}
	self:initModel()
	self.isTipsToGoods = true
	self.isCopyRealUpdate = false
end

function CharacterModel:initModel()
    self.isSwallow = false
    self.isFloatRisePower = true
    self.swallowEquipData = {}
    
    self.curSpiritData = {}
    self.curStrengthSpirit = {}
    self.isSpiritPack = 1

    self.curItemData = {}
    self.meltingData = {}
    self.roleData = {}
    self.roleData.characterData = {} --角色属性数据
    self.roleData.backpackData = {}  --主角背包数据
    self.roleData.skillData = {}     --主角技能数据
    
    
	self.itemIconList = {
        empty = "equipFrame_1.png",
        helmet = "helmet.png",
        necklace = "necklace.png",
        clothes = "clothes",
        pants = "pants.png",
        weapon = "weapon.png",
        shoes = "shoes.png",
	}

    --temp data
    local role = zzd.CharacterData.new()
    role.uid = 19880605
    role.gold = 50
    role.rmb = 0
    role.renown = 0
    role.godsoul = 0
    role.anima = 0
    role.soul = 0
    role.flower = 0
    role.energysoul = 0
    role.amulet = 0
    role.moneycount = 0
    role.moneylayer = 1
    role.physical = 1
    role.physicalbuy = 1
    role.trainexpcount = 1
    role.trainflowercount = 1
    role.trainrenowncount = 1
    role.explore = 1
    role.warcount = 0
    role.warbuy = 0
    role.gncopyud = 0
    role.gncopycn = 0
    role.gncopydfc = 1
    role.gncopymst = 0
    role.godphysicalbuy = 0
    role.tccount = 1
    role.tclevel = 1

    role.name = "ming"
    role.pro = 1
    role.lv = 1
    role.time_del = 0

    role.atk = 50
    role.def = 20
    role.crit = 1
    role.hp = 100
    role.mp = 200

    self:setCharacterData(role)

    _G.RoleData.Uid = role.uid
    _G.RoleData.Gold = role.gold
    _G.RoleData.Renown = role.renown
    _G.RoleData.RMB = role.rmb
    _G.gRoleRMB = role.rmb
        
    _G.FairyData.Flower = role.flower
end

function CharacterModel:setIsSwallow(flag)
	self.isSwallow = flag
end

function CharacterModel:setIsFloatRisePower(flag)
	self.isFloatRisePower = flag
end

------------
--熔炼装备数据和属性槽索引
--data = {melt_left ={},melt_leftIdx = 1,melt_right = {}, melt_rightIdx = 0}
function CharacterModel:getMeltingData()
	return self.meltingData
end

function CharacterModel:setMeltingData(data)
	self.meltingData = data
end

function CharacterModel:updateMeltingData(rightIdx)
	self.meltingData.melt_rightIdx = rightIdx
end

---------------
--当前选中单个背包数据
--
function CharacterModel:getCurItemData()
	return self.curItemData
end

function CharacterModel:setCurItemData(data)
	self.curItemData = data
end

----------------
--当前选中单个器灵数据
--
function CharacterModel:getCurSpiritData()
	return self.curSpiritData
end

function CharacterModel:setCurSpiritData(data)
	self.curSpiritData = data
end

----------------
--强化的器灵数据
--
function CharacterModel:getCurStrengthSpirit()
    return self.curStrengthSpirit,self.isSpiritPack
end

function CharacterModel:setCurStrengthSpirit(data,type)
	self.curStrengthSpirit = data
	self.isSpiritPack = type
end


---------------------------------------------------------
-- Backpack
-- 
-- 获取背包物品列表
function CharacterModel:getBackpackList()
    local ret = {}
    for key, var in pairs(self.roleData.backpackData) do
        print("Check: ID: "..var.goods_id.." idx: "..var.idx.."*******************************************************************")
    	if var.config.Type == enGoodsType.EQUIP then
    		table.insert(ret,#ret + 1,var)
    	end
    end
    return ret
end

---技能石
function CharacterModel:getStoneOfMagic()
    local ret = {}
    for key, var in pairs(self.roleData.backpackData) do
        if var.config.Type == enGoodsType.MAGIC and var.config.TypeSub == 2 then
            table.insert(ret,var)
        end
    end
    return ret
end

function CharacterModel:findStone(id)
    local arr = self:getStoneOfMagic()
    for key, var in pairs(arr) do
    	if var.goods_id == id then
    	    return var.count
    	end
    end
	return 0
end

--通过ID获取单件物品
function CharacterModel:getGoodsById(id)
    for key, var in pairs(self.roleData.backpackData) do
    	if var.goods_id == id then
    	   return var
    	end
    end
    local data = {["count"]=0}
    return data
end

--获取器灵物品列表
function CharacterModel:getSpiritList()
    local ret = {}
    for key, var in ipairs(self.roleData.backpackData) do
        if var.config.Type == enGoodsType.SPIRIT then
            table.insert(ret,#ret + 1,var)
        end
    end
    return ret
end


--
function CharacterModel:getHeroSkill()
    
end


-- 获取角色身上装备列表
function CharacterModel:getEquipedList()
    return self.roleData.characterData.equipList
end

-- 获取角色身上装备，通过装备子类型，装备槽索引，身上装备idx（1，2，3，4，5，6）
function CharacterModel:getEquipedBySubtype(type)
    return self.roleData.characterData.equipList[type]
end

--获取角色已装备的器灵
function CharacterModel:getSpirit()
    return self.roleData.characterData.spiritData
end

-- 添加新物品到背包
function CharacterModel:insertGoods(goods)
    print("insertGoods idx:  ".. goods.idx)
    if goods.backpackType == enBackpackType.BACKPACK then
        table.insert(self.roleData.backpackData,#self.roleData.backpackData+1,goods)
        self:sortGoods()
        dxyDispatcher_dispatchEvent(dxyEventType.UserItem_AddItem, goods)
        dxyDispatcher_dispatchEvent(dxyEventType.Spirit_Strength,goods)
        dxyDispatcher_dispatchEvent("YuanShenLayer_updateAllRes")
        
    elseif goods.backpackType == enBackpackType.ROLE_EQUIP then
        self.roleData.characterData.equipList[goods.idx] = goods
        dxyDispatcher_dispatchEvent(dxyEventType.UserItem_WearEquip, goods)
        dxyDispatcher_dispatchEvent(dxyEventType.Backpack_Refresh)
    elseif  goods.backpackType == enBackpackType.SPIRIT then
        self.roleData.characterData.spiritData = goods
        dxyDispatcher_dispatchEvent(dxyEventType.UserItem_WearEquip, goods)
        dxyDispatcher_dispatchEvent(dxyEventType.Spirit_Strength,goods)
    else
        print("Error Backpack Type, type:".. goods.backpackType)
    end

end

-- 从背包删除物品
function CharacterModel:removeGoods(type, idx)
    
    print("removeGoods idx:  ".. idx)
    local index = self:findGoodsByidx(type, idx)
    if index == 0 then
        print("Error: not find goods, idx:".. idx)
    else
        if type == enBackpackType.BACKPACK then
            table.remove(self.roleData.backpackData,index)
            dxyDispatcher_dispatchEvent("SkillStone_delStone", idx)
            dxyDispatcher_dispatchEvent(dxyEventType.UserItem_DelItem, idx)
            dxyDispatcher_dispatchEvent("YuanShenLayer_updateAllRes")
            
        elseif type == enBackpackType.ROLE_EQUIP then
            self.roleData.characterData.equipList[index] = nil
            dxyDispatcher_dispatchEvent(dxyEventType.UserItem_CastEquip, index)
            dxyDispatcher_dispatchEvent(dxyEventType.Backpack_Refresh)
        elseif  type == enBackpackType.SPIRIT then
            self.roleData.characterData.spiritData = nil
            dxyDispatcher_dispatchEvent(dxyEventType.UserItem_CastEquip, index)
        else
            print("Error Backpack Type, type:".. type)
        end
    end

end

-- 更新背包已有物品
function CharacterModel:updateGoods(goods, index)
    print("updateGoods index:  ", goods.idx)
    if goods.backpackType == enBackpackType.BACKPACK then
        self.roleData.backpackData[index] = goods
        self:sortGoods()
        dxyDispatcher_dispatchEvent(dxyEventType.UserItem_Replace, goods)
        dxyDispatcher_dispatchEvent("YuanShenLayer_updateAllRes")
        
    elseif goods.backpackType == enBackpackType.ROLE_EQUIP then
        self.roleData.characterData.equipList[goods.idx] = goods
        dxyDispatcher_dispatchEvent(dxyEventType.UserItem_ReplaceEquip, goods)
        dxyDispatcher_dispatchEvent(dxyEventType.EquipStrengthen_ResultBackj,goods)
        dxyDispatcher_dispatchEvent(dxyEventType.Spirit_Strength,goods)
        dxyDispatcher_dispatchEvent(dxyEventType.Backpack_Refresh)
    elseif  goods.backpackType == enBackpackType.SPIRIT then
        self.roleData.characterData.spiritData = goods
        dxyDispatcher_dispatchEvent(dxyEventType.UserItem_ReplaceEquip, goods)
        dxyDispatcher_dispatchEvent(dxyEventType.Spirit_Strength,goods)
    else
        print("Error Backpack Type, type:".. goods.backpackType)
    end
end

-- 服务器下发添加物品，如果已存在相同idx就更新否则添加
function CharacterModel:addGoods(goods)

--    if zzm.CharacterModel.isTipsToGoods and SceneManager.m_curSceneName ~= "GameScene" then
--        cn:TipsSchedule(goods.config.Name.." +"..goods.count or 1)
--    end


    local index = self:findGoods(goods)
    print("----index: " .. index)
    if index == 0 then
    	self:insertGoods(goods)
--        ---物品飘字
--        if zzm.CharacterModel.isTipsToGoods and SceneManager.m_curSceneName ~= "GameScene" then
--            cn:TipsSchedule(goods.config.Name.." +"..goods.count or 1)
--        end
--        ---
        if goods.config.Type == enGoodsType.MAGIC and goods.config.TypeSub == 2 then
            dxyDispatcher_dispatchEvent("SkillStone_addStone",goods)
            dxyDispatcher_dispatchEvent("StoneMsg_updateAfter",goods)
        end
    else
--        ---物品飘字
--        if goods.backpackType == enBackpackType.BACKPACK then
--            local curData = self:findGoodsByidx(enBackpackType.BACKPACK, index)
--            if zzm.CharacterModel.isTipsToGoods and SceneManager.m_curSceneName ~= "GameScene" then
--                if goods.count < curData.count then
--                    cn:TipsSchedule(goods.config.Name.." +"..goods.count - curData.count)
--                end
--            end
--        end
--        ---
        self:updateGoods(goods,index)
        if goods.config.Type == enGoodsType.MAGIC and goods.config.TypeSub == 2 then
            dxyDispatcher_dispatchEvent("SkillStone_changeStone",goods)
            dxyDispatcher_dispatchEvent("StoneMsg_updateBefore",goods)
        end
    end
end

-- 在背包查找物品是否存在，存在返回index，否则返回0
function CharacterModel:findGoods(goods)
    return self:findGoodsByidx(goods.backpackType, goods.idx)
end

-- 通过idx查找物品是否存在，存在返回index，否则返回0
function CharacterModel:findGoodsByidx(type, idx)
    if type == enBackpackType.BACKPACK then
        --背包里面物品没有空的index
        for index, value in pairs(self.roleData.backpackData) do
            if value.idx == idx then
                return index
            end
        end
    elseif type == enBackpackType.ROLE_EQUIP then
        --装备栏物品使用物品idx做存储索引
        if self.roleData.characterData.equipList[idx] then
        	return idx
        end
    elseif type == enBackpackType.SPIRIT then
        if self.roleData.characterData.spiritData then
            return idx
        end
    else
        print("Error Backpack Type, type:".. type)
    end
    return 0
end

-- 物品变更后排序
function CharacterModel:sortGoods()
    table.sort(self.roleData.backpackData,self.sortRules)
end

function CharacterModel.sortRules(goodsA,goodsB)
	if goodsA.config.Lv == goodsB.config.Lv then
	   if goodsA.config.Quality == goodsB.config.Quality then
           if goodsA.config.TypeSub == goodsB.config.TypeSub then
                if goodsA.lv == goodsB.lv then
                	return goodsA.config.Id > goodsB.config.Id
                else
                    return goodsA.lv > goodsB.lv
                end
           else
	           return goodsA.config.TypeSub < goodsB.config.TypeSub
	       end   
	   else      
	       return goodsA.config.Quality > goodsB.config.Quality
	   end
	else
	   return goodsA.config.Lv > goodsB.config.Lv
	end
end

---------------------------------------------------------
-- Character
-- 
-- 获取角色属性数据
function CharacterModel:getCharacterData()
    return self.roleData.characterData
end

-- 设置角色属性数据
function CharacterModel:setCharacterData(data)
	self.roleData.characterData = data
end

-- 获取角色属性数据，通过角色UID
function CharacterModel:getCharacterDataById(idx)
	--return self.roleData.characterData[idx]
end

-- 服务器更新角色属性数据，type属性类型，value变更后的值
function CharacterModel:updateCharacterData(type, value)
    print("Update role Attr Type:  "..enCharacterAttrType:getAttrName(type) .. " value: " .. value)
    
    self:upGradeEffect(type, value)
    
    self.roleData.characterData:setValueByType(type, value)
    if self.isCopyRealUpdate then
        dxyDispatcher_dispatchEvent("CopySelectLayer_realUpdate")
        self.isCopyRealUpdate = false
    end
    dxyDispatcher_dispatchEvent(dxyEventType.Character_AttrUpdate, {type =type, value = value})
    dxyDispatcher_dispatchEvent("updateValue", {type =type, value = value})
    dxyDispatcher_dispatchEvent("upDateGolds")
    dxyDispatcher_dispatchEvent("TalkingDataUpdate",{type =type, value = value})
    dxyDispatcher_dispatchEvent("MainScene_updateSkillTips")
    dxyDispatcher_dispatchEvent("MainScene_updateCornucopiaTips")
    dxyDispatcher_dispatchEvent("MainScene_updateLingshanTips")
    dxyDispatcher_dispatchEvent("MainScene_updateSoulTips")
end

---------------------------------------------------------
-- View

function CharacterModel:upGradeEffect(type,value)
    if DefineConst.CONST_FIELD_LV == type then ---升级
        local role = zzm.CharacterModel:getCharacterData()
        local enCAT = enCharacterAttrType
        local lastLV = role:getValueByType(enCAT.LV)
--        dxyDispatcher_dispatchEvent("CopySelectLayer_CopyItem",lastLV)
        if value > lastLV then
            UpGradeEffect:show()
            self.isCopyRealUpdate = true
            zzc.PkController:request_timer()
        end
    elseif DefineConst.CONST_FIELD_POWER == type then   ---战力
        local role = zzm.CharacterModel:getCharacterData()
        local enCAT = enCharacterAttrType
        local lastPower = role:getValueByType(enCAT.POWER)
        self.riseValue = 0
        if value > lastPower then
            self.riseValue = value -lastPower
            if self.isFloatRisePower then
                 self:floatMsg()
            end
        end
    else    
        if zzm.CharacterModel.isTipsToGoods and SceneManager.m_curSceneName ~= "GameScene" then
            local role = zzm.CharacterModel:getCharacterData()
            local enCAT = enCharacterAttrType
            local last = role:getValueByType(type)
            if value > last then
                cn:TipsSchedule(enCAT:getTypeName(type).." +"..value-last)
            end
        end
    end
    
end

function CharacterModel:floatMsg()
    if self.riseValue <= 0 then
    	return
    end
    require "game.utils.PowerRaiseEffect"
    local scene = SceneManager:getCurrentScene()
    scene:addChild(PowerRaiseEffect:create(self.riseValue)) 
end
 
-- 强化一键填充
function CharacterModel:getSwallowList()
    local ret = {}
    print(#self.roleData.backpackData)
    for index, value in pairs(self.roleData.backpackData) do
        print(value:getType())
        if value:getType() == 1 and value.lv == 0 and value.config.Lv <= self.swallowEquipData.config.Lv then
            table.insert(ret,#ret + 1,value)
        end
    end
    return ret
end

--判断背包是否已满
function CharacterModel:backPackRemainSpace()
    local backPack = zzm.CharacterModel:getBackpackList()

    local remainSpace = AutocephalyValueConfig:getValueByContent("EquipListNum") * AutocephalyValueConfig:getValueByContent("EquipRowNum") - #backPack
    
    return remainSpace
end


function CharacterModel:getItemIconByKey(key)
	for k,v in pairs(self.itemIconList) do
		if k == key then
			return v
		end
	end
	return nil
end

return CharacterModel