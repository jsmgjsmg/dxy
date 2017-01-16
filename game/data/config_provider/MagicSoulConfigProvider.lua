--器灵表数据提供器

MagicSoulConfigProvider = {
}

--获取分解基础倍率
function MagicSoulConfigProvider:getResolveBaseRate()
    local item = luacf.MagicSoul.MagicSoulConfig.MagicSoulBaseAnima.BaseConfig.Base.Explode
    return item
end

--通过等级获取等级分解系数,没有找到返回nil
function MagicSoulConfigProvider:findCoefficientByLv(lv)
    local list = luacf.MagicSoul.MagicSoulConfig.MagicSoulBaseAnima.LvAddConfig.LvAdd
    for key, item in pairs(list) do
    	if item.Lv == lv then
    		return item.Add
    	end
    end
    return nil
end

--通过品质获取器灵分解系数,没有找到返回nil
function MagicSoulConfigProvider:findCoefficientByQuality(quality)
    local list = luacf.MagicSoul.MagicSoulConfig.MagicSoulBaseAnima.QualityAddConfig.QualityAdd
    for key, item in pairs(list) do
        if item.Quality == quality then
            return item.Add
        end
    end
    return nil
end

--通过强化基础倍率
function MagicSoulConfigProvider:getStrengthBaseRote()
	local item = luacf.MagicSoul.MagicSoulConfig.MagicSoulAnima.BaseConfig.Base.Consume
	return item
end

--通过强化等级获取器灵强化系数，没有找到返回nil
function MagicSoulConfigProvider:findCoefficientByStrengthLv(StrengthLv)
    local list = luacf.MagicSoul.MagicSoulConfig.MagicSoulAnima.StrengthenLvAddConfig.StrengthenLvAdd
    for key, item in ipairs(list) do
        if item.StrengthenLv == StrengthLv then
    		return item.Add
    	end
    end
    return nil
end

--通过器灵等级获取器灵强化系数,没有找到返回nil
function MagicSoulConfigProvider:findCoefficientBySpiritLv(lv)
    local list = luacf.MagicSoul.MagicSoulConfig.MagicSoulAnima.LvAddConfig.LvAdd
    for key, item in ipairs(list) do
        if item.Lv == lv then
            return item.Add
        end
    end
    return nil
end

--通过器灵品质获取器灵强化系数,没有找到返回nil
function MagicSoulConfigProvider:findCoefficientBySpiritQuality(Quality)
    local list = luacf.MagicSoul.MagicSoulConfig.MagicSoulAnima.QualityAddConfig.QualityAdd
    for key, item in ipairs(list) do
        if item.Quality == Quality then
            return item.Add
        end
    end
    return nil
end

--根据器灵品质获取器灵可强化的最大等级
function MagicSoulConfigProvider:getMaxStrengthLvByQuality(Quality)
	local list = luacf.MagicSoul.MagicSoulConfig.MagicSoulStrengthen.StrengthenLvConfig.StrengthenLv
    for key, var in pairs(list) do
		if var.Quality == Quality then
			return var.Lv
		end
	end
	return nil
end

--获取强化器灵的基础金钱倍率
function MagicSoulConfigProvider:getMagicSoulStrengthenGold()
	local item = luacf.MagicSoul.MagicSoulConfig.MagicSoulStrengthen.BaseConfig.GoldBase.Gold
	return item
end

--获取强化器灵的基础金钱初始值
function MagicSoulConfigProvider:getMagicSoulStrengthenBaseGold()
	local item = luacf.MagicSoul.MagicSoulConfig.MagicSoulStrengthen.BaseConfig.GoldBase.Base
	return item
end

--根据器灵等级获取强化加成
function MagicSoulConfigProvider:getMagicSoulLvAdd(lv)
	local list = luacf.MagicSoul.MagicSoulConfig.MagicSoulStrengthen.LvAddConfig.LvAdd
    for key, var in pairs(list) do
		if var.Lv == lv then
			return var.Add
		end
	end
	return nil
end

--根据器灵强化等级获取强化加成
function MagicSoulConfigProvider:getMagicSoulStrengthenLvAdd(strengthenLv)
    local list = luacf.MagicSoul.MagicSoulConfig.MagicSoulStrengthen.StrengthenLvAddConfig.StrengthenLvAdd
    for key, var in pairs(list) do
        if var.StrengthenLv == strengthenLv then
            return var.Add
        end
    end
    return nil
end

--根据器灵品质获取强化加成
function MagicSoulConfigProvider:getMagicSoulQualityAdd(quality)
	local list = luacf.MagicSoul.MagicSoulConfig.MagicSoulStrengthen.QualityAddConfig.QualityAdd
    for key, var in pairs(list) do
		if var.Quality == quality then
			return var.Add
		end
	end
	return nil
end

--根据器灵强化下一等级获取所需的护符
function MagicSoulConfigProvider:getNextLvAmulet(nextLv)
	local list = luacf.MagicSoul.MagicSoulConfig.StrengthenSuccessRate.SuccessRate
	for key, var in pairs(list) do
		if var.StrLv == nextLv then
			return var.Num
		end
	end
	return nil
end


function MagicSoulConfigProvider:getAllScene()
    local list = luacf.MagicSoulScene.MagicSoulSceneConfig.MagicSoulSceneType.SceneType
    return list
end

--根据类型获取器灵副本解锁等级
function MagicSoulConfigProvider:getUnlockLvByType(type)
    local list = luacf.MagicSoulScene.MagicSoulSceneConfig.CopyLv.UnLock
    for key, var in pairs(list) do
		if var.Id == type then
			return var.Lv
		end
	end
	return nil
end

--根据器灵副本解锁等级获取类型
function MagicSoulConfigProvider:getTypeByUnlockLv(unlockLv)
    local list = luacf.MagicSoulScene.MagicSoulSceneConfig.CopyLv.UnLock
    for key, var in pairs(list) do
        if var.Lv == unlockLv then
            return var.Id
        end
    end
    return nil
end

--根据器灵副本等级获取名字
function MagicSoulConfigProvider:getCopyNameByLv(lv)
    local list = luacf.MagicSoulScene.MagicSoulSceneConfig.CopyLv.UnLock
    for key, var in pairs(list) do
    	if var.Lv == lv then
    		return var.Name
    	end
    end
    return nil
end

--根据器灵副本等级和难度获取一个副本所需金钱
function MagicSoulConfigProvider:getCopyNeedGold(lv,diff)
    local list = luacf.MagicSoulScene.MagicSoulSceneConfig.CopyGold.Gold
    for key, var in pairs(list) do
    	if var.Lv == lv and var.CopyDifficulty == diff then
    		return var.RoomGold
    	end
    end
    return nil
end

--根据器灵副本等级和难度获取一轮副本所需金钱
function MagicSoulConfigProvider:getAllCopyNeedGold(lv,diff)
    local list = luacf.MagicSoulScene.MagicSoulSceneConfig.CopyGold.Gold
    for key, var in pairs(list) do
        if var.Lv == lv and var.CopyDifficulty == diff then
            return var.CopyGold
        end
    end
    return nil
end

--根据器灵副本等级和难度获取一个副本所需元宝
function MagicSoulConfigProvider:getCopyNeedRmb(lv,diff)
    local list = luacf.MagicSoulScene.MagicSoulSceneConfig.CopyGold.Gold
    for key, var in pairs(list) do
        if var.Lv == lv and var.CopyDifficulty == diff then
            return var.RoomRmb
        end
    end
    return nil
end

--根据器灵副本等级和难度获取一轮副本所需元宝
function MagicSoulConfigProvider:getAllCopyNeedRmb(lv,diff)
    local list = luacf.MagicSoulScene.MagicSoulSceneConfig.CopyGold.Gold
    for key, var in pairs(list) do
        if var.Lv == lv and var.CopyDifficulty == diff then
            return var.CopyRmb
        end
    end
    return nil
end

--根据器灵副本等级获取5个可能掉落
function MagicSoulConfigProvider:getDropByLv(lv)
    local list = luacf.MagicSoulScene.MagicSoulSceneConfig.CopyLv.UnLock
    for key, var in pairs(list) do
        if var.Lv == lv then
    		return var.Drop
    	end
    end
    return nil
end

--根据器灵副本等级，难度等级获取副本state
function MagicSoulConfigProvider:getSpiritCopyStateByLvAndDiff(lv,diff)
    for key, var in pairs(zzm.SpiritModel.spiritCopyPassData) do
		if var.Lv == lv then
			if diff == 1 then
                if var.General then
                	return var.General
                end
			elseif diff == 2 then
                if var.Medium then
                    return var.Medium
                end
			elseif diff == 3 then
                if var.Advanced then
                    return var.Advanced
                end
			end
		end
	end
	return false
end

--根据器灵副本扫荡次数获取扣除的元宝
function MagicSoulConfigProvider:getRmbByCount(count)
    local list = luacf.MagicSoulScene.MagicSoulSceneConfig.MopUp.RmbNum
    for key, var in pairs(list) do
    	if var.Num == count + 1 then
    		return var.Rmb
    	end
    end
    if count + 1 > #list then
       for key1, var1 in pairs(list) do
       	   if key1 == #list then
       	   	  return var1.Rmb
       	   end
       end
    end
    return nil
end

--获取器灵副本探索次数上限
function MagicSoulConfigProvider:getSearchCountMax()
	return luacf.MagicSoulScene.MagicSoulSceneConfig.NumMax.Max.Num
end