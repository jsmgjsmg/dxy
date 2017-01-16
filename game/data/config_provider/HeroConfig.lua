--英雄配置表
HeroConfig = {
}

function HeroConfig:getConfig()
	local list = luacf.Hero.HeroConfig.Heros
	return list
end

function HeroConfig:getValueById(id)
	local list = luacf.Hero.HeroConfig.Heros
	return list[id]
end

function HeroConfig:getOssatureById(id)
    local hero = HeroConfig:getValueById(id)
    local list = luacf.Ossature.OssatureConfig.Ossature
    for key, var in pairs(list) do
    	if var.Id == hero.ResId then
    	    return var
    	end
    end
end

function HeroConfig:getMoveSpeed()
    return luacf.HeroBaseAttr.HeroBaseAttrConfig.HeroBaseAttr[1]
end

function HeroConfig:getIdByPro(jop)
    for key, var in pairs(luacf.Hero.HeroConfig.Heros) do
		if var.Jop == jop then
			return var.Id
		end
	end
end