--场景，副本，章节 数据提供器

SceneConfigProvider = {
    }

--根据章节ID，和宝箱ID获取宝箱星星条件
function SceneConfigProvider:getBoxStartByIndex(chapterId,index)
    if chapterId <1 or chapterId > 10 or index < 1 or index > 3 then
        return 0
    end
    return luacf.StarReward.StarRewardConfig.ChapterConfig[chapterId].StarReward[index].StarNumber
end   

--消耗体力    
function SceneConfigProvider:getPhysical()
    return luacf.Power.PowerConfig.BaseConfig.Base.Consume
end

--返回普通副本消耗元力
function SceneConfigProvider:getCommonPhysical()
    return luacf.Power.PowerConfig.BaseConfig.Base.CopyConsume
end

--返回章节数量
function SceneConfigProvider:getChapterCount()
    return #luacf.Chapter.ChapterConfig.Chapter
end

--返回所有章节
function SceneConfigProvider:getChapterList()
    return luacf.Chapter.ChapterConfig.Chapter
end

--返回经验比例
--function SceneConfigProvider:getExpRatio()
--    local list = luacf.AutocephalyValue.AutocephalyValueConfig.content
--    for key, var in pairs(list) do
--      if var.content == "ExpRatio" then
--          return var.Value
--      end
--    end
--end

--返回金币比例
function SceneConfigProvider:getGoldRatio()
    local list = luacf.AutocephalyValue.AutocephalyValueConfig.content
    for key, var in pairs(list) do
        if var.content == "GoldRatio" then
            return var.Value
        end
    end
end

function SceneConfigProvider:getChapterIDByCopyId(copyId)
    for key, chapter in pairs(luacf.Chapter.ChapterConfig.Chapter) do
        for key, copy in pairs(chapter.CopyId) do
            if copy.CopyId == copyId then
                return chapter.Id
            end
        end
    end
    print("Error : not find Chapter, copyID: " .. copyId)
    return 0
end

--返回所有章节
function SceneConfigProvider:getChapterByIndex(index)
    if index <1 or index > self:getLength() then
        print("Error index, out of safe[0, ",self:getChapterCount(),"] Range。 index：",index)
    end
    return luacf.Chapter.ChapterConfig.Chapter[index]
end

--返回指定章节
function SceneConfigProvider:getChapterById(chapterID)
    for key, chapter in pairs(luacf.Chapter.ChapterConfig.Chapter) do
        if chapter.Id == chapterID then
            return chapter
        end
    end
    print("Error : not find Chapter, chapterID: " .. chapterID)
    return nil
end


function SceneConfigProvider:getStartDataById(ID)
    for key, start in pairs(luacf.StarAppraise.StarAppraiseConfig.StarAppraise) do
        if start.ID == ID then
            return start.Appraise
        end
    end
    print("Error : not find StarAppraise, copyID: " .. ID)
    return nil
end

--返回指定章节
function SceneConfigProvider:getCopyById(copyID)
    for key, copy in pairs(luacf.Copy.CopyConfig.Scene) do
        if copy.Id == copyID then
            return copy
        end
    end
    print("Error : not find copy, copyID: " .. copyID)
    return nil
end

--返回开始logo
--function SceneConfigProvider:getLogoData(logoID)
--    for key, logo in pairs(luacf.Logo.LogoConfig.LogoBase) do
--        if logo.Id == logoID then
--            return logo
--        end
--    end
--end

--返回指定章节前一章Id
function SceneConfigProvider:getCopyKeyById(copyID)
    for key, Copy in pairs(luacf.Copy.CopyConfig.Scene) do
        if Copy.Id == copyID then
            if copyID == 10101 then
                return Copy.Id
            else
                local key1 = key - 1
                local list = luacf.Copy.CopyConfig.Scene
                for key2, copy in pairs(list) do
                    if key2 == key1 then
                        return copy.Id
                    end
                end
            end

        end
    end
    return nil
end

--通过物品ID查找物品基本数据，没有找到返回nil
function SceneConfigProvider:findGoodsById(id)
    local list = luacf.Goods.GoodsConfig.GoodsItem.Information
    for key, item in pairs(list) do
        if item.Id == id then
            return item
        end
    end
    return nil
end

--通过物品基本属性ID查找物品基本属性，没有找到返回nil
function SceneConfigProvider:findBaseAttrById(id)
    local list = luacf.Goods.GoodsConfig.GoodsBase.BaseAttr
    for key, var in pairs(list) do
        if var.ID == id then
            return var
        end
    end
    return nil
end

--返回指定章节
function SceneConfigProvider:getCopyRewardById(copyID)
    for key, copy in pairs(luacf.CopyWinReward.CopyWinReward.Reward) do
        if copy.ID == copyID then
            return copy
        end
    end
    print("Error : not find CopyWinReward, copyID: " .. copyID)
    return nil
end

--根据副本ID获取第几章节
function SceneConfigProvider:getChapterByCopyId(copyId)
    local list = luacf.Copy.CopyConfig.Scene
    for key, var in pairs(list) do
        if var.Id == copyId then
            return var.ChapterId
        end
    end
    return nil
end

function SceneConfigProvider:getScenesConfig(id)
    local list = luacf.Scenes.ScenesConfig.Scenes
    for key, var in pairs(list) do
        if var.ID == id then
            return var
        end
    end
end
