--装备基础数值表
EquipBaseConfig = {
}

--根据装备类型获取基础概率
function EquipBaseConfig:getBaseForType(type)
	local list = luacf.EquipBase.EquipBaseConfig.EquipBase.Base
    for key, var in pairs(list) do
		if type == var.EquipType then
			return var.AttrPercent / 100.0
		end
	end
end

--根据装备品质获取基础概率
function EquipBaseConfig:getBaseForQuality(quality)
	local list = luacf.EquipBase.EquipBaseConfig.QualityConfig.Quality
    for key, var in pairs(list) do
		if quality == var.QualityType then
			return var.QualityAttrPercent / 100.0
		end
	end
end

--根据装备等级和属性类型获取基础值
function EquipBaseConfig:getBase(lv,attrType)
	local list = luacf.EquipBase.EquipBaseConfig.EquipAttrConfig.EquipAttr
    for key, var in pairs(list) do
		if lv == var.Lv then
			return var[attrType]
		end
	end
end