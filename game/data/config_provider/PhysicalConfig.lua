--体力配置表
PhysicalConfig = {
}

--获取基础字段表
function PhysicalConfig:getBaseValue()
	local list = luacf.Power.PowerConfig.BaseConfig.Base
	
	return list
end

--获取购买表
function PhysicalConfig:getBuyList()
    local list = luacf.Power.PowerConfig.BuyConfig.Buy
    
    return list
end

--根据当前购买次数获取购买体力所需元宝
function PhysicalConfig:getRmbByCount(count)
	local list = luacf.Power.PowerConfig.BuyConfig.Buy
	
    for key, var in pairs(list) do
		if count == var.Num then
			return var.Rmb
		end
	end
	return nil
end

--获取神将副本体力基本表
function PhysicalConfig:getGodBaseValue()
    local list = luacf.Power.PowerConfig.GodConfig.Base
    return list
end

--获取神将副本购买表
function PhysicalConfig:getGodBuyList()
    local list = luacf.Power.PowerConfig.GodBuyConfig.GodBuy

    return list
end

--根据当前购买次数获取购买神将副本体力所需元宝
function PhysicalConfig:getGodRmbByCount(count)
    local list = luacf.Power.PowerConfig.GodBuyConfig.GodBuy

    for key, var in pairs(list) do
        if count == var.Num then
            return var.Rmb
        end
    end
    return nil
end