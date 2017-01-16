--装备强化数据提供器
EquipStrengthenConfig = {
}

--获取最大强化等级
function EquipStrengthenConfig:getLvMax()
	local item = luacf.EquipStrengthen.EquipStrengthenConfig.lvMax.LvMax
	return item 
end

--根据装备等级获取升级所需要的基础经验
function EquipStrengthenConfig:getBaseExp(lv)
	local list = luacf.EquipStrengthen.EquipStrengthenConfig.BaseConfig.Base
    for key, var in pairs(list) do
		if var.LV == lv then
			return var.UpLvExp
		end
	end
	return nil
end

--根据装备等级获取强化所需要的基础金钱
function EquipStrengthenConfig:getBaseSpendGold(lv)
    local list = luacf.EquipStrengthen.EquipStrengthenConfig.BaseConfig.Base
    for key, var in pairs(list) do
        if var.LV == lv then
            return var.SpendGold
        end
    end
    return nil
end

--根据装备等级获取熔炼所需要的基础金钱
function EquipStrengthenConfig:getBaseDevourGold(lv)
    local list = luacf.EquipStrengthen.EquipStrengthenConfig.BaseConfig.Base
    for key, var in pairs(list) do
        if var.LV == lv then
            return var.DevourGold
        end
    end
    return nil
end

--根据装备品阶获取升级的经验加成百分比
function EquipStrengthenConfig:getQualityUpRatio(quality)
    local list = luacf.EquipStrengthen.EquipStrengthenConfig.ExpQualityConfig.ExpQuality
    for key, var in pairs(list) do
    	if var.Quality == quality then
    		return var.UpLvRatio / 100.0
    	end
    end
    return nil
end

--根据装备品阶获取熔炼的加成百分比
function EquipStrengthenConfig:getQualityEatRatio(quality)
    local list = luacf.EquipStrengthen.EquipStrengthenConfig.ExpQualityConfig.ExpQuality
    for key, var in pairs(list) do
        if var.Quality == quality then
            return var.EatRatio / 100.0
        end
    end
    return nil
end

--根据装备强化等级获取升级的经验加成百分比
function EquipStrengthenConfig:getUpLvRatio(upLv)
    local list = luacf.EquipStrengthen.EquipStrengthenConfig.UpLvConfig.UpLv
    for key, var in pairs(list) do
    	if var.StrengthenLv == upLv then
    		return var.StrengthenUpLvRatio / 100.0
    	end
    end
    return nil
end

--根据装备类型获取升级的经验加成百分比
function EquipStrengthenConfig:getEquipTypeRatio(equipType)
    local list = luacf.EquipStrengthen.EquipStrengthenConfig.EquipTypeConfig.EquipType
    for key, var in pairs(list) do
    	if var.EquipType == equipType then
    		return var.EquipPercent / 100.0
    	end
    end
    return nil
end

--根据装备强化等级获取属性加成百分比
function EquipStrengthenConfig:getAttrPercent(upLv)
    local list = luacf.EquipStrengthen.EquipStrengthenConfig.StrengthenUpLvConfig.StrengthenUpLv
    for key, var in pairs(list) do
    	if var.StrengthenLv == upLv then
    		return var.AttrPercent / 100.0
    	end
    end
    return nil
end