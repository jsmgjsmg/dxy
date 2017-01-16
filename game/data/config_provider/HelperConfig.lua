--小助手配置表
HelperConfig = {
}

--根据类型获取一个组里的内容
function HelperConfig:getHelperListByType(type)
    local list = luacf.Helper.HelperConfig.HelperGroup.Helper
    local groupList = {}
    for key, var in pairs(list) do
		if var.Type == type then
            table.insert(groupList,#groupList + 1,var)
		end
	end
    return groupList
end

--根据ID,等级获取系统的初始推荐战力
function HelperConfig:getBasePowerByIdLv(id,lv)
    local list = luacf.Helper.HelperConfig.RecommendPowerGroup.RecommendPower
    local powerList = {}
    for key, var in pairs(list) do
    	if var.Id == id then
    		powerList = var.Recommend
    	end
    end
    
    for key, var in pairs(powerList) do
    	if var.Lv == lv then
    		return var.RecommendPower
    	end
    end
    
    return 0
end

--根据vip等级获取推荐战力系数
function HelperConfig:getRatioByVipLv(vipLv)
    local list = luacf.Helper.HelperConfig.RecommendPercent.RecommendPower
    for key, var in pairs(list) do
    	if var.VipLv == vipLv then
    		return var.Percent
    	end
    end
    
    return 0
end