--财神宝库配置表

MoneySceneConfig = {
}


function MoneySceneConfig:getBaseValueByKey(key)
	local list = luacf.MoneyScene.MoneySceneConfig.MoneySceneBase
	if list[key] then
        return list[key]
	end
	return nil
end

--根据层数获取所需等级
function MoneySceneConfig:getLvByLayer(layer)
    local list = luacf.MoneyScene.MoneySceneConfig.LvBaseConfig.LvBase
    for key, var in pairs(list) do
    	if var.Layer == layer then
    		return var.Lv
    	end
    end
    return nil
end

--根据翻牌次数获取元宝
function MoneySceneConfig:getCardRmbByCount(count)
    local list = luacf.MoneyScene.MoneySceneConfig.CardConfig.Card
    for key, var in pairs(list) do
    	if var.Number == count then
    		return var.Rmb
    	end
    end
    return nil
end

--根据翻牌次数获取开启的VIP等级
function MoneySceneConfig:getVipByCount(count)
	local list = luacf.MoneyScene.MoneySceneConfig.CardNumConfig.Number
    for key, var in pairs(list) do
		if var.Number == count then
			return var.Vip
		end
	end
	
    if count > #list then
        return list[#list].Vip
	end
	
    return list[1].Vip
end

--根据层数获取至少获得的铜钱
function MoneySceneConfig:getMinGold(layer)
	local layerData = luacf.MoneyScene.MoneySceneConfig.LvBaseConfig.LvBase
    for key, var in pairs(layerData) do
        if layer == var.Layer then
            return cn:convert(tonumber(var.LvGold) + tonumber(var.CardGold))
		end
	end
	return 0
end

--根据层数获取至多获得的铜钱
function MoneySceneConfig:getMaxGold(layer)
    local layerData = luacf.MoneyScene.MoneySceneConfig.LvBaseConfig.LvBase
    local lvGold = nil
    local cardGold = nil
    local cardRmbGold = nil
    for key, var in pairs(layerData) do
        if layer == var.Layer then
            lvGold = var.LvGold
            cardGold = var.CardGold
            cardRmbGold = var.CardRmbGold
    	end
    end
    
    local freeRate = 0
    local rmbRate = 0
    local freeRateData = nil
    local rmbRateData = nil
    local multipleData = luacf.MoneyScene.MoneySceneConfig.MultipleConfig.Multiple
    for key, var in pairs(multipleData) do
    	if var.Type == 1 then
    		freeRateData = var.RandomMultiple
        elseif var.Type == 2 then
            rmbRateData = var.RandomMultiple
    	end
    end
    
    for key, var in pairs(freeRateData) do
    	if var.Multiple >= freeRate then
            freeRate = var.Multiple
    	end
    end
    
    for key, var in pairs(rmbRateData) do
        if var.Multiple >= rmbRate then
            rmbRate = var.Multiple
        end
    end
    
    return cn:convert(math.floor(lvGold + cardGold * (freeRate / 100) + cardRmbGold * (rmbRate / 100) * 4))
    
end