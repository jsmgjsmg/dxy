--试练塔配置表

TowerConfig = {
}

--根据试练塔类型获取数据
function TowerConfig:getDataByType(type)
	local list = luacf.Train.TrainConfig.TrainBase
    for key, var in pairs(list) do
		if type == var.TrainType then
			return var
		end
	end
	return nil
end

--根据试练塔类型获取翻牌配置
function TowerConfig:getCardByType(type)
	local list = luacf.Train.TrainConfig.TrainBase
    for key, var in pairs(list) do
		if type == var.TrainType then
			return var.CardConfig.Card
		end
	end
	return nil 
end

--根据试练塔类型获取翻牌次数的VIP
function TowerConfig:getVipByType(type)
    local list = luacf.Train.TrainConfig.TrainBase
    for key, var in pairs(list) do
        if type == var.TrainType then
            return var.CardNumConfig.Number 
        end
    end
    return nil 
end