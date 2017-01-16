--装备品质计算
EquipQualityConfig = {
}

--获取每个品质属性的最大值
function EquipQualityConfig:getAttrMax()
    local ret = {}
    local list = luacf.EquipQuality.EquipQualityConfig.LvAttr
    for key, var in pairs(list) do
        ret[var.Quality] = var.MaxPercent / 100.0
    end    
    return ret
end
