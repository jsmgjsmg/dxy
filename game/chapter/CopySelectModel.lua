local CopySelectModel = class("CopySelectModel")
CopySelectModel.__index = CopySelectModel

function CopySelectModel:ctor()
    self.EACH_COPY_START = 3  -- 每个副本星星最大数量
    self.maxChapterID = 0
    self.copyList = {}        -- 副本列表
    self.chapterList = {}     -- 章节列表
    self.openCopyList = {}
    self.boxRewardList = {}
    self:initModel()
    self:initEvent()
end

function CopySelectModel:initModel()
    
    self.copyList = {
        
    }

    self.chapterList = 
    {
        
    }
    
    self.nilCopyList = {}
    self.curChapter = 1 --当前或最新章节
    
    self.curCopyData = nil
    
    self.isFightEffect = false

end

function CopySelectModel:initEvent()
    dxyDispatcher_addEventListener(dxyEventType.Character_AttrUpdate,self,self.updateCopyOpen)
end

--function CopySelectModel:removeEvent()
--    dxyDispatcher_removeEventListener("CopySelectModel_updateCopyOpen",self,self.updateCopyOpen)
--end

--server back
function CopySelectModel:insertBoxData(data)
    print("server boxId = "..data.boxId)
    print("server state = "..data.state)
    if self.boxRewardList[data.chapterId] == nil then
        self.boxRewardList[data.chapterId] = {}
    end
    self.boxRewardList[data.chapterId][data.boxId] = data
end

--server back
function CopySelectModel:insertCopyData(id, start)
    print("server id = "..id)
    print("server start = "..start)
    if id ~= 10101 then
        local aheadCopyId = SceneConfigProvider:getCopyKeyById(id)

        local num = 0
        while self.openCopyList[aheadCopyId] == nil do
            num = num + 1
            self.nilCopyList[num] = {id = aheadCopyId, start = 0, config = nil}
            aheadCopyId = SceneConfigProvider:getCopyKeyById(aheadCopyId)
        end
        if #self.nilCopyList > 0 then
            for i = #self.nilCopyList,1,-1 do
                self.openCopyList[self.nilCopyList[i].id] = self.nilCopyList[i]
            end
        end
        self.nilCopyList = {}
--        for i = #self.nilCopyList,1,-1 do
--            self.openCopyList[self.nilCopyList[i].id] = self.nilCopyList[i]
--        end
    end
    
    
    
--    local isCopyNil = true
--    for key, var in ipairs(self.openCopyList) do
--    	if var.id == aheadCopyId then
--    		isCopyNil = false
--    	end
--        
--    end
--    if isCopyNil then
--        self.openCopyList[aheadCopyId] = {id = aheadCopyId, start = 0, config = nil}
--    end
    
    self.openCopyList[id] = {id = id, start = start, config = nil}
--    if start>0 then
--        zzm.GuideModel:setOpenCopy(1, id)
--    end
    self:updateMaxChapter(id)
    self:updateCopyOpen()
end

function CopySelectModel:updateMaxChapter(copyId)
    local chapterId = SceneConfigProvider:getChapterIDByCopyId(copyId)
    if self.maxChapterID < chapterId then
    	self.maxChapterID = chapterId
        if self.maxChapterID > 10 then
    		self.maxChapterID = 10
    	end
    end
end

function CopySelectModel:getNewLv(data)
	self.newLv = nil
	if data.type == 10 then
		self:updateLvCopyOpen(data.value)
	end
	return
end

function CopySelectModel:updateCopyOpen()
    for key, var in pairs(self.openCopyList) do
		if var.start < 1 then
            local copyData = SceneConfigProvider:getCopyById(var.id)
--            local role = zzm.CharacterModel:getCharacterData()
            if copyData.DeblockingLv <= _G.gMainPlayerLv then
				self.isFightEffect = true
                dxyDispatcher_dispatchEvent("MainScene_updateFightEffect")
				return
			end
		end
	end
	self.isFightEffect = false
    dxyDispatcher_dispatchEvent("MainScene_updateFightEffect")
end

function CopySelectModel:updateLvCopyOpen(newLv)
    if self.openCopyList == nil then return end
    for key, var in pairs(self.openCopyList) do
        if var.start < 1 then
            local copyData = SceneConfigProvider:getCopyById(var.id)
            --            local role = zzm.CharacterModel:getCharacterData()
            if copyData.DeblockingLv <= newLv then
                self.isFightEffect = true
                dxyDispatcher_dispatchEvent("MainScene_updateFightEffect")
                return
            end
        end
    end
    self.isFightEffect = false
    dxyDispatcher_dispatchEvent("MainScene_updateFightEffect")
end

--server data
function CopySelectModel:getCopyData(id)
    return self.openCopyList[id]
end

function CopySelectModel:getLastCopyData()
    local max = nil
    for key, var in pairs(self.openCopyList) do
    	if not max then
    	    max = key
    	else
    	   if max < key then
    	       max = key
    	   end
    	end
    end
    return self.openCopyList[max]
end

--当前章节
function CopySelectModel:setCurChapter(chapter)
	self.curChapter = chapter
end

function CopySelectModel:getCurChapter()
	return self.curChapter
end

-- 根据副本ID查找副本，木有找到返回nil
function CopySelectModel:findCopyByID(copyId)
    for key, copy in pairs(self.openCopyList) do
        if copy.id == copyId then
            return copy
        end
    end
    print("error copyId, not find copy。 copyId：",copyId)
    return nil
end

-- 根据章节ID获取最大星星数量，木有找到章节返回nil
function CopySelectModel:getAllStartByID(chapterId)
    local chapter = self:getChapterByID(chapterId)
    if chapter then
        return #chapter.CopyId * self.EACH_COPY_START
    end
    return nil
end

-- 根据章节ID获取当前已有星星数量，木有找到章节返回nil
function CopySelectModel:getCurStartByID(chapterId)
    local chapter = self:getChapterByID(chapterId)
    if chapter then
        local count = 0
        for index=1, #chapter.CopyId do
            local copy = self:findCopyByID(chapter.CopyId[index].CopyId)
        	if copy then
        		count = count + copy.start
        	end
        end
        return count
    end
    return nil
end

function CopySelectModel:getStartProgress(chapterId)
    local all = self:getAllStartByID(chapterId)
    if all == nil then
    	return 0
    end
    local cur = self:getCurStartByID(chapterId)
    if cur == nil then
        return 0
    end
    return cur/all*100
end

function CopySelectModel:getBoxProgressByIndex(index)
    local chapterId = self:getCurChapter()
    local start = self:getBoxStartByIndex(chapterId,index)
    local allStart = self:getAllStartByID(chapterId)
    return start/allStart
end   


function CopySelectModel:getBoxStartProgerssByIndex(chapterId,index)
    return self:getBoxStartByIndex(chapterId,index)/self:getAllStartByID(chapterId)
end  

--根据章节ID，和宝箱ID获取宝箱星星条件
function CopySelectModel:getBoxStartByIndex(chapterId,index)
    return SceneConfigProvider:getBoxStartByIndex(chapterId,index)
end   

function CopySelectModel:getOpenChapterCount()
    return self.maxChapterID
end

-- 根据章节ID查找章节，木有找到返回nil
function CopySelectModel:getChapterByID(chapterId)
    return SceneConfigProvider:getChapterById(chapterId)
end

-- 根据table索引查找章节，木有找到返回nil
function CopySelectModel:getChapterByIndex(index)
    return SceneConfigProvider:getChapterByIndex(index)
end

-- 获取章节总数
function CopySelectModel:getLength()
    return SceneConfigProvider:getChapterCount()
end

-- 获取章节总数
function CopySelectModel:getChapterList()
    return SceneConfigProvider:getChapterList()
end

return CopySelectModel