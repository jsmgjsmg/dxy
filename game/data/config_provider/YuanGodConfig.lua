YuanGodConfig = YuanGodConfig or class("YuanGodConfig")

---元神
function YuanGodConfig:getYuanShenByLv(lv)
    local list = luacf.Yuanshen.YuanShenConfig.YuanShenConfig.YuanShen 
    for i,j in pairs(list) do 
        if j.Lv == lv then
            return j
        end
    end
end

function YuanGodConfig:getYuanShenLen()
    return #luacf.Yuanshen.YuanShenConfig.YuanShenConfig.YuanShen
end

----------------------------------------------------------------------------
---法器
function YuanGodConfig:getMagicById(id)
    local list = luacf.Yuanshen.YuanShenConfig.MagicItemConfig.MagicItem
    for i,j in pairs(list) do 
        if j.Id == id then
            return j
        end
    end
end

function YuanGodConfig:getMagicLen()
    return #luacf.Yuanshen.YuanShenConfig.MagicItemConfig.MagicItem
end

function YuanGodConfig:getMagicIdList()
    local Id_List = {}
    local list = luacf.Yuanshen.YuanShenConfig.MagicItemConfig.MagicItem
    for i=1,#list do
        Id_List[i] = list[i].Id
    end
    return Id_List
end

function YuanGodConfig:getIconByIdAndStar(id,star)
    local list = luacf.Yuanshen.YuanShenConfig.MagicItemConfig.MagicItem
    for i,item in pairs(list) do 
        if item.Id == id then
            for j,starList in pairs(item.Star) do
                if starList.Star == star then
                    return starList.Icon
                end
            end
        end
    end
end

function YuanGodConfig:getStarByIdAndStar(id,star)
    local list = luacf.Yuanshen.YuanShenConfig.MagicItemConfig.MagicItem
    for i,item in pairs(list) do 
        if item.Id == id then
            for j,itemStar in pairs(item.Star) do
                if itemStar.Star == star then
                    return itemStar
                end
            end
        end
    end
end

function YuanGodConfig:getStarLenById(id)
    local list = luacf.Yuanshen.YuanShenConfig.MagicItemConfig.MagicItem
    for i,magic in pairs(list) do
        if magic.Id == id then
            return #magic.Star
        end
    end
end

---------------------------------------------------------------------------------
---元气
function YuanGodConfig:getWainById(id)
    local list = luacf.Yuanshen.YuanShenConfig.WainConfig.Wain
    for i,j in pairs(list) do 
        if j.Id == id then
            return j
        end
    end
end

function YuanGodConfig:getWainLen()
    return #luacf.Yuanshen.YuanShenConfig.WainConfig.Wain
end
