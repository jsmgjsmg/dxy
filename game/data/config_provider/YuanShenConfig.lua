YuanShenConfig = YuanShenConfig or class("YuanShenConfig")
YuanShenConfig._skillStone = {}

------元神----------------------------------------------------------------
--获取等级属性
function YuanShenConfig:getDataByLv(lv)
    local list = luacf.Yuanshen.YuanShenConfig.YuanShenConfig.YuanShen 
    for i,j in pairs(list) do 
        if j.Lv == lv then
            return j
        end
    end
end

--获取元神Icon
function YuanShenConfig:getYSIcon(lv)
    local list = luacf.Yuanshen.YuanShenConfig.YuanShenConfig.YuanShen 
    for i,j in pairs(list) do 
        if j.Lv == lv then
            return j
        end
    end
end

--获取元神等级上限
function YuanShenConfig:getMaxLv()
    return #luacf.Yuanshen.YuanShenConfig.YuanShenConfig.YuanShen - 1
end

--获取元神下一级属性
function YuanShenConfig:getNextPro(lv)
    lv = lv + 1
    local max = self:getMaxLv()
    if lv >= max then
        lv = max
    end
    local list = luacf.Yuanshen.YuanShenConfig.YuanShenConfig.YuanShen 
    for i,j in pairs(list) do 
        if j.Lv == lv then
            return j
        end
    end
end

--获取元神下一级升级所需
function YuanShenConfig:getNextRes(lv)
    local list = luacf.Yuanshen.YuanShenConfig.YuanShenConfig.YuanShen 
    for i,j in pairs(list) do 
        if j.Lv == lv then
            return j
        end
    end
end

--抽到物品
function YuanShenConfig:getWainById(id)
    local list = luacf.Yuanshen.YuanShenConfig.WainConfig.Wain
    for i,j in pairs(list) do 
        if j.Id == id then
            return j
        end
    end
end

--蜕变所需
function YuanShenConfig:getChangePro(lv)
    local list = luacf.Yuanshen.YuanShenConfig.ChangeConfig.Change
    for key, var in pairs(list) do
    	if lv == var.Lv then
    	    local data = {}
            data["Gold"] = var.Gold
            data["Renown"] = var.Renown
            return data
    	end
    end
    return false
end

------法器----------------------------------------------------------------
--获取法器config
function YuanShenConfig:getMagicById(id)
    local list = luacf.Yuanshen.YuanShenConfig.MagicItemConfig.MagicItem
    for key, var in pairs(list) do
    	if var.Id == id then
    	   return var
    	end
    end
end


--获取法器解锁所需
function YuanShenConfig:getUnLockMagic(id)
    local list = luacf.Yuanshen.YuanShenConfig.UnLockConfig.UnLockExp
    for key, var in pairs(list) do
    	if var.Id == id then
    	    return var
    	end 
    end
end

--获取法器解锁等级
function YuanShenConfig:getMagicUnLock(id)
    local list = luacf.Yuanshen.YuanShenConfig.MagicItemConfig.MagicItem
    for key,var in pairs(list) do
        if var.Id == id then
            return var.UnLockLv
        end
    end
end

--获取法器大Icon
function YuanShenConfig:getMagicIconBig(id)
    local list = luacf.Yuanshen.YuanShenConfig.MagicItemConfig.MagicItem
    for key,var in pairs(list) do
        if var.Id == id then
            return var.Icon
        end
    end
end

--获取法器黑暗Icon
function YuanShenConfig:getMagicIconDark(id)
    local list = luacf.Yuanshen.YuanShenConfig.MagicItemConfig.MagicItem
    for key,var in pairs(list) do
        if var.Id == id then
            return var.LockIcon
        end
    end
end

--获取法器名字
function YuanShenConfig:getMagicName(id)
    local list = luacf.Yuanshen.YuanShenConfig.MagicItemConfig.MagicItem
    for key,var in pairs(list) do
        if var.Id == id then
            return var.Label
        end
    end
end
    
--获取升星所需
function YuanShenConfig:getUpStarNeed(id,star)
    local list = luacf.Yuanshen.YuanShenConfig.MagicItemConfig.MagicItem
    for key, var in pairs(list) do
        if var.Id == id then
            local type = var.Type
            local starList = var.Star
            for key,target in pairs(starList) do
                if target.Star == star then
                    local goods = {}
                    goods["Type"] = type
                    goods["GoodsId"] = target.GoodsId
                    goods["GoodsNum"] = target.GoodsNum
                    return goods
                end
            end
        end 
    end
end

function YuanShenConfig:getUpStarGoods(id)
    local list = luacf.Yuanshen.YuanShenConfig.MagicItemConfig.MagicItem
    local goods = {}
    for key, var in pairs(list) do
        if var.Id == id then
            goods["Type"] = var.Type
            goods["GoodsId"] = var.Star[1].GoodsId
            return goods
        end
    end
end

----技能----------------------------------------------------------
--技能升级所需
function YuanShenConfig:getUpSkillPro(id,lv)
    local type = nil
    local list = luacf.Yuanshen.YuanShenConfig.MagicItemConfig.MagicItem
    for key,var in pairs(list) do
        if var.Id == id then
            type = var.Type
            break
        end
    end

    local list = luacf.Yuanshen.YuanShenConfig.SkillConfig.Skill
    local data = {}
    for key,var in pairs(list) do
        if var.Type == type then
            local goodsList = var.Goods
            for i,target in pairs(goodsList) do
                if target.Lv == lv + 1 then
                    return target
                end
            end
            return goodsList[#goodsList]
        end
    end
end

--获取技能属性
function YuanShenConfig:getSkillPro(id)
    local skId = nil
    local list = luacf.Yuanshen.YuanShenConfig.MagicItemConfig.MagicItem
    for key,var in pairs(list) do
        if var.Id == id then
            skId = var.SkillId
            break
        end
    end
    
    local skillList = luacf.Skill.SkillConfig.SkillBase
    for key,var in pairs(skillList) do
        if var.Id == skId then
            return var
        end
    end
end

--获取最高等级技能石
function YuanShenConfig:getStoneLast(type)
    local list = luacf.Yuanshen.YuanShenConfig.SkillConfig.Skill
    for key,var in pairs(list) do
        if var.Type == type then
            local goodsList = var.Goods
            return goodsList[#goodsList]
        end
    end
end

--通过ID获取技能石类型
function YuanShenConfig:getTypeById(id)
    local goods = luacf.Yuanshen.YuanShenConfig.SkillConfig.Skill[1].Goods
    for key,var in pairs(goods) do
        if var.ID == id then
            return 1
        end
    end
    return 2
end

--获取技能最高等级
function YuanShenConfig:getMaxSkillLv()
    return #luacf.Yuanshen.YuanShenConfig.SkillConfig.Skill[1].Goods
end


--function YuanShenConfig:SecondType()
--    local goods = luacf.Yuanshen.YuanShenConfig.SkillConfig.Skill[2].Goods
--    
--end

