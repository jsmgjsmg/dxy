WorldBossConfig = WorldBossConfig or class("WorldBossConfig")

---活动
function WorldBossConfig:getEventGroup()
    return luacf.WorldBoss.WorldBossConfig.EventGroup.Event
end

---上榜上限
function WorldBossConfig:getRankLen()
    return #luacf.WorldBoss.WorldBossConfig.RewardGroup.RankingReward
end

------奖励
function WorldBossConfig:getRewardByNum(num)
    local len = self:getRankLen()
    if num <= len then ---上榜
        local list = luacf.WorldBoss.WorldBossConfig.RewardGroup.RankingReward
        return list[num]
    else ---未上榜
        local list = luacf.WorldBoss.WorldBossConfig.RewardGroup.ParticipateReward
        for i=1,#list do
            if list[i].LowRange and num <= list[i].LowRange then
                return list[i]
            else
                return list[#list]
            end
        end
    end
end

---击杀奖励 
function WorldBossConfig:getKillReward()
    return dxyConfig_toList(luacf.WorldBoss.WorldBossConfig.RewardGroup.KillReward)
end

function WorldBossConfig:getResourceByKey(key)
    return luacf.WorldBoss.WorldBossConfig.ResourceGroup.Resource[key]
end

function WorldBossConfig:getWBSkeleton()
    local id = luacf.WorldBoss.WorldBossConfig.ResourceGroup.Resource.SkeletonId
    local list2 = luacf.Ossature.OssatureConfig.Ossature
    for key, var in pairs(list2) do
        if var.Id == id then
            return var.Ossature
        end
    end
end