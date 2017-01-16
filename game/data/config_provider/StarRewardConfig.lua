--星星数奖励提供器

StarRewardConfig = {
    }
    
    
--通过章节Id,宝箱Id查找奖励
function StarRewardConfig:findIngotRewardByChapterId(chapterId,index)
    if chapterId <1 or chapterId > 10 or index < 1 or index > 3 then
        return 0
    end
    return dxyConfig_toList(luacf.StarReward.StarRewardConfig.ChapterConfig[chapterId].StarReward[index].Rewards)
end