--竞技场数据表
PkConfig = {
}

--获取竞技场基础数据
function PkConfig:getBaseData()
	local list = luacf.Arena.ArenaConfig.ArenaBase.Base
	
	if list then
		return list
	end
	
	return nil
end

--获取竞技场购买数据
function PkConfig:getBuyCountData()
	local list = luacf.Arena.ArenaConfig.ArenaBase.NumBuy
	
	if list then
		return list
	end
	
	return nil
end

--根据购买的次数获取需要的元宝
function PkConfig:getRmbByCount(count)
    local list = luacf.Arena.ArenaConfig.ArenaBase.NumBuy
    
    for key, var in pairs(list) do
    	if var.Num == count then
    		return var.Rmb
    	end
    end
    return nil
end

--根据排名获取每日奖励数据
function PkConfig:getRewardByRanking(ranking)
	local hundredInternal = luacf.Arena.ArenaConfig.Ranking.DailyReward.HundredInternal
    local hundredBack = luacf.Arena.ArenaConfig.Ranking.DailyReward.HundredBack
    
    if ranking <= #hundredInternal then
        for key, var in pairs(hundredInternal) do
    		if ranking == var.Ranking then
    			return var
    		end
    	end
    else
        for key, var in pairs(hundredBack) do
            if ranking >= var.RankingMax and ranking <= var.RankingMin then
                return var
            end
        end
    end
    if ranking >= hundredBack[#hundredBack].RankingMax then
        return hundredBack[#hundredBack]
    end
    return nil 
end

function PkConfig:getMatchMax()
    return luacf.Pk.PkConfig.ValueConfig.PowerMax
end

function PkConfig:getMatchTimerNeed(timer)
    local list = luacf.Pk.PkConfig.PowerBuyConfig.PowerBuy
    if timer > #list then
        cn:TipsSchedule("购买次数已用完")
        return
    end
    for key, var in pairs(list) do
        if var.PowerBuyNumber == timer then
    	   return var
    	end
    end
end