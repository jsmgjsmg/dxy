FairyConfig = FairyConfig or class("FairyConfig")


---获取仙女个数
function FairyConfig:getFairyNum()
    return #luacf.FemaleCelestial.FemaleCelestialConfig.baseConfig.base
end

---获取洞府个数
function FairyConfig:getHoleNum()
    return #luacf.FemaleCelestial.FemaleCelestialConfig.HotelConfig.Hotel
end

---获取双修所得经验----------------------------------------------------------------------------
function FairyConfig:getExpByHole(id,lv,hole)
    local list1 = luacf.FemaleCelestial.FemaleCelestialConfig.baseConfig.base
    local quality = nil --品质
    local ratio = nil   --等级基数
    for i,base in pairs(list1) do
        if base.ID == id then
            quality = base.Quality
            ratio = base.ExpIncreaseBaseRatio
            break
        end
    end

    local list2 = luacf.FemaleCelestial.FemaleCelestialConfig.QualityConfig.Quality
    local acquire = nil --品质基数
    for i,qua in pairs(list2) do
        if qua.Quality == quality then
            acquire = qua.ExpAcquireAdd/100
            break
        end
    end

    local list3 = luacf.FemaleCelestial.FemaleCelestialConfig.HotelConfig.Hotel
    local holeAdd = nil --洞府基数
    for i,hotel in pairs(list3) do
        if hotel.Type == hole then
            holeAdd = hotel.ExpAcquireAdd/100
            break
        end
    end

    local ExpInitial = luacf.FemaleCelestial.FemaleCelestialConfig.ExpAcquireBaseConfig.ExpAcquireBase.ExpInitial
    local ExpIncrease = luacf.FemaleCelestial.FemaleCelestialConfig.ExpAcquireBaseConfig.ExpAcquireBase.ExpIncrease/100

    return (ratio+lv)*ExpIncrease*acquire*holeAdd+ExpInitial
end

---获取双修所需金额/所获----------------------------------------------------------------------------
function FairyConfig:getGoldByHole(lv,hole)
    local data = {}
    local goldAdd = 0
    local expAdd = 0
    local Rmb = 0
    local Rmb2 = 0
    local holeType = 0
    
    local list = luacf.FemaleCelestial.FemaleCelestialConfig.LvUpConfig.LvUp
    for key, var in pairs(list) do
    	if lv == var.Lv then
    	    data.Exp = var.Exp
    	    data.ExpGold = var.ExpGold
    	    Rmb = var.Rmb
    	    Rmb2 = var.Rmb2
    	    break
    	end
    end
    
    local list3 = luacf.FemaleCelestial.FemaleCelestialConfig.HotelConfig.Hotel
    for i,hotel in pairs(list3) do
        if hotel.Type == hole then
            goldAdd = hotel.GoldConsumeAdd/100
            expAdd = hotel.ExpAcquireAdd/100
            holeType = hotel.ConsumeType
            data.ExpAcquireTime = hotel.ExpAcquireTime
            break
        end
    end
    data.Exp = data.Exp*expAdd
    if hole == 1 then
        data.ExpGold = data.ExpGold*goldAdd
    elseif hole == 2 then
        data.ExpGold = Rmb * goldAdd
    elseif hole == 3 then
        data.ExpGold = Rmb2*goldAdd
    end
    
    return data
end

---NEW--------------------------------------------------------------------
function FairyConfig:getHoleConfig(lv,hole)

end

---获取赠送鲜花数量----------------------------------------------------------------------------------------------
function FairyConfig:getFlowerByFairy(id,lv)

    local list2 = luacf.FemaleCelestial.FemaleCelestialConfig.LvUpConfig.LvUp
    local flower = nil
    for i,lvUp in pairs(list2) do
        if lvUp.Lv == lv then
            flower = lvUp.FlowersNumber
            break
        end
    end

    local list3 = luacf.FemaleCelestial.FemaleCelestialConfig.QualityConfig.Quality
    local base = nil
    for i,Quality in pairs(list3) do
        if Quality.Id == id then
            base = Quality.FlowersNumberAdd/100
            break
        end
    end

    return flower*base
end

function FairyConfig:getLvUpConfig(lv)
    local list2 = luacf.FemaleCelestial.FemaleCelestialConfig.LvUpConfig.LvUp
    for i,lvUp in pairs(list2) do
        if lvUp.Lv == lv then
            return lvUp
        end
    end
end

function FairyConfig:getBaseConfig(id)
    local list1 = luacf.FemaleCelestial.FemaleCelestialConfig.baseConfig.base
    for i,base in pairs(list1) do
        if base.ID == id then
            return base
        end
    end
end

---获取好感度上限--------------------------------------------------------------------------------------------------
function FairyConfig:getFavorMaxByFairy(id)
    local list = luacf.FemaleCelestial.FemaleCelestialConfig.baseConfig.base
    for i,base in pairs(list) do
        if base.ID == id then
            return base.favorMax
        end
    end
end

---获取等级上限--------------------------------------------------------------------------------------------------
function FairyConfig:getMaxLvByFairy()
    return #luacf.FemaleCelestial.FemaleCelestialConfig.LvUpConfig.LvUp-1
end

---获取疲劳值上限-------------------------------------------------------------------------------------------------
function FairyConfig:getFVByFairy(id)
    local list = luacf.FemaleCelestial.FemaleCelestialConfig.baseConfig.base
    for i,base in pairs(list) do
        if base.ID == id then
            return base.Fatigued
        end
    end
end

--获取仙女Icon
function FairyConfig:getFairyIcon(id)
    local list = luacf.FemaleCelestial.FemaleCelestialConfig.baseConfig.base
    for key, var in pairs(list) do
        if var.ID == id then
            return var.Picture
        end
    end
end

--获取名字Iocn
function FairyConfig:getFairyName(id)
    local list = luacf.FemaleCelestial.FemaleCelestialConfig.baseConfig.base
    for key, var in pairs(list) do
        if var.ID == id then
            return var.Icon
        end
    end
end

--获取锁住提示
function FairyConfig:getLockInfo(id)
    local list = luacf.FemaleCelestial.FemaleCelestialConfig.baseConfig.base
    for key, var in pairs(list) do
        if var.ID == id then
            return var.LockInfo
        end
    end
end

--获取亮技能图标
function FairyConfig:getPassiveIcon(id)
    local list = luacf.FemaleCelestial.FemaleCelestialConfig.baseConfig.base
    local skillId = nil
    for key, var in pairs(list) do
    	if var.ID == id then
            skillId = var.SkillId
            break
    	end
    end
    
    local skillList = luacf.FemaleCelestialSkill.FemaleCelestialSkillConfig.FemaleCelestial
    for key, var in pairs(skillList) do
    	if var.ID == skillId then
    	   return var
    	end
    end
end

--获取仙女背景光圈
function FairyConfig:getFairyLight(id)
    local list = luacf.FemaleCelestial.FemaleCelestialConfig.baseConfig.base
    local skillId = nil
    for key, var in pairs(list) do
        if var.ID == id then
            return 
        end
    end
end

function FairyConfig:getFairyConfig(id)
    local list = luacf.FemaleCelestial.FemaleCelestialConfig.baseConfig.base
    local skillId = nil
    for key, var in pairs(list) do
        if var.ID == id then
            return var
        end
    end
end

function FairyConfig:getKeyById(id)
    local list = luacf.FemaleCelestial.FemaleCelestialConfig.baseConfig.base
    for i=1,#list do
        if id == list[i].ID then
            return i
        end
    end
end