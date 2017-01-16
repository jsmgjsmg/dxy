--蟠桃园配置表

PeentoConfig = {
}

--根据第几次催熟获取数据项
function PeentoConfig:getDataByCount(count)
    if count > self:getCanBuyNum() then
        count = self:getCanBuyNum()
    end
	local list = luacf.Peento.PeenotConfig.BuyConfig.Buy
    for key, var in pairs(list) do
		if count == var.Count then
			return var
		end
	end
end

--根据类型获取蟠桃配置
function PeentoConfig:getConfigByType(type)
	local list = luacf.Peento.PeenotConfig.PeenotAdditionConfig.PeenotAddition
	
	for key, var in pairs(list) do
		if var.Type == type then
			return var
		end
	end
	
	return nil
end

--获取可购买总数
function PeentoConfig:getCanBuyNum()
    local list = luacf.Peento.PeenotConfig.BuyConfig.Buy
    
    return #list
end
