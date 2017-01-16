
CopySelectLayer = CopySelectLayer or class("CopySelectLayer",function()
    return cc.Layer:create()
end)

function CopySelectLayer.create()
    local layer = CopySelectLayer.new()
    return layer
end

function CopySelectLayer:ctor()
    self._csbNode = nil
    self.btn_back = nil
    self.titleName = nil
    self.pageView = nil
    self.arrPageView = {}
    self:initUI()
end

function CopySelectLayer:initUI()

    self._csbNode = cc.CSLoader:getInstance():createNodeWithFlatBuffersFile("dxyCocosStudio/csd/ui/copy/CopySelectLayer.csb")
    self:addChild(self._csbNode)
    
    dxyExtendEvent(self)
    
    self.visibleSize = cc.Director:getInstance():getVisibleSize()
    self.origin = cc.Director:getInstance():getVisibleOrigin()
    
    local posX = self.origin.x + self.visibleSize.width/2
    local posY = self.origin.y + self.visibleSize.height/2

    self:setPosition(posX, posY)
    local titleNode = self._csbNode:getChildByName("TitleNode")
    titleNode:setPositionY(self.origin.y + self.visibleSize.height/2)
    local titleBg = titleNode:getChildByName("copy_title_bg")
    local backNode = titleNode:getChildByName("BackNode")
    backNode:setPositionX(-(self.origin.x + self.visibleSize.width/2) +10)
    self.btn_back = backNode:getChildByName("Back")
    local copyNameBg = titleBg:getChildByName("CopyNameBG")
    self.titleName = copyNameBg:getChildByName("CopyName")
    
    local path = "dxyCocosStudio/png/chapter/ChapterTitle/Chapter_1.png"
    self.titleName:setTexture(path)
    
    local node = self._csbNode:getChildByName("ProgressNode")
    
    node:setPositionY(self.origin.y - self.visibleSize.height/2)
    
    self.bar_count = node:getChildByName("LoadingBar")
    self.ckb_list = {}
    self.boxStart = {}
    for index=1, 3 do
        self.ckb_list[index] = self.bar_count:getChildByName("box_"..index)
        if self.ckb_list[index] then
            self.boxStart[index] = self.ckb_list[index]:getChildByName("Text")
        end
    end

    
    local node = self._csbNode:getChildByName("Panel")
    node:setContentSize(self.visibleSize.width,self.visibleSize.height)
    
    self.pageView = node:getChildByName("PageView")


--    self.btn_addManual = node:getChildByName("Manual"):getChildByName("Button")
--    self.btn_startReward = node:getChildByName("Start"):getChildByName("Button")
    
    self.pageView:removeAllChildren()
    
    require("game.chapter.view.CopyPage")
    local pageSize = nil
    self._chapterCount = zzm.CopySelectModel:getOpenChapterCount() --已开章节数
    if self._chapterCount == nil or self._chapterCount <=0 then
        self._chapterCount = 1
    end
    for index=1, self._chapterCount do
        local page = CopyPage:create(index)--index 为对应章节ID
        self.pageView:insertPage(page,index-1)
        table.insert(self.arrPageView,page)
        page:update()
        pageSize = page:getPageSize()
    end
    
    self.pageView:setPosition(pageSize.width/2, pageSize.height/2)
    self.pageView:setContentSize(pageSize.width,pageSize.height)
    self.pageView:setCustomScrollThreshold(pageSize.width*0.1)
    
    self.pageView:addEventListener(function(target,type)
        if type == ccui.PageViewEventType.turning then
            local chapterID = self.pageView:getCurPageIndex()+1
            self:scrollToPage(chapterID)
            zzm.CopySelectModel:setCurChapter(chapterID)
            self:setTitleName(chapterID)   
            --self:setCkbData(chapterID)   ming      
        end
    end)
    
---zAdd---
    self._ndLeftN = self._csbNode:getChildByName("ndLeftN")
    self._ndRightN = self._csbNode:getChildByName("ndRightN")
    self._ndLeftN:setPosition(-posX,-30)
    self._ndRightN:setPosition(posX,-30)
    
    self._btnLast = self._ndLeftN:getChildByName("btnLast")
    self._btnLast:addTouchEventListener(function(target,type)
        if type == 2 then
            local curPage = self.pageView:getCurPageIndex()
            self:scrollToPage(curPage)
        end
    end)
    
    self._btnNext = self._ndRightN:getChildByName("btnNext")
    self._btnNext:addTouchEventListener(function(target,type)
        if type == 2 then
            local curPage = self.pageView:getCurPageIndex()
            self:scrollToPage(curPage+2)
        end
    end)
    
    
end

---ADD-----
function CopySelectLayer:realUpdate()
    local curChapterCount = zzm.CopySelectModel:getOpenChapterCount() --已开章节数
    if curChapterCount > self._chapterCount then
        --新增PageView
        self._chapterCount = curChapterCount
        local page = CopyPage:create()
        self.pageView:insertPage(page,self._chapterCount-1)
        table.insert(self.arrPageView,page)
        page:update()
    end
    
--    local temp = self._chapterCount - 1 < 1 and 1 or self._chapterCount - 1
--    for j=self._chapterCount,temp do
--        for i=1,#self.arrPageView do
            self.arrPageView[self._chapterCount]:update()
--        end
--    end
end

function CopySelectLayer:setCkbData(chapterId)
    local data = zzm.CopySelectModel.boxRewardList[chapterId]
    if #data then
        for index=1, #data do
            for key, var in pairs(data) do
                if index == var.boxId then
                    self:setCkbState(var)
                end
            end
        end
    end

    local pro = zzm.CopySelectModel:getStartProgress(chapterId)
    self.bar_count:setPercent(pro)
end

function CopySelectLayer:setTitleName(chapterID)
    local path = "dxyCocosStudio/png/chapter/ChapterTitle/Chapter_"
    path = path .. chapterID .. ".png"
    self.titleName:setTexture(path)
end

function CopySelectLayer:removeEvent()
    dxyDispatcher_removeEventListener("CopySelectLayer_scrollToPage",self,self.scrollToPage)
    dxyDispatcher_removeEventListener("CopySelectLayer_realUpdate",self,self.realUpdate)
end

function CopySelectLayer:initEvent()
    if(self.btn_back)then
        self.btn_back:addTouchEventListener(function(target,type)
            if(type==2)then
                SoundsFunc_playSounds(SoundsType.CLOSE_PAGE,false)
                zzc.CopySelectController:closeLayer()
            end
        end)
    end
    
    for index=1, #self.ckb_list do
        self.ckb_list[index]:addEventListener(function(target,type)
--            if type == ccui.CheckBoxEventType.selected then
                self.ckb_list[index]:setSelected(true)
                	SoundsFunc_playSounds(SoundsType.OPEN_PAGE,false)
                    local chapterId = zzm.CopySelectModel:getCurChapter()
                	local data = zzm.CopySelectModel.boxRewardList[chapterId]
                	
                	require("game.chapter.view.GetRewardsLayer")
                    local rewardLayer = GetRewardsLayer:create()
--                    if self.ckb_list[index]:isBright() then
                    	rewardLayer:setUIData(index,self.ckb_list[index],data[index].state,"CopyReward")
--                    else
--                        rewardLayer:setUIData(index,self.ckb_list[index],data.State,"CopyReward")
--                    end
                    
                    SceneManager:getCurrentScene():addChild(rewardLayer)
                
                
--            end
        end)
    end
    local chapterId = zzm.CopySelectModel:getOpenChapterCount()
    chapterId = 1
--    self.pageView:scrollToPage(chapterId - 1)
    self:scrollToPage(chapterId)
    self:setTitleName(chapterId)
    --self:setCkbData(chapterId) ming
    dxyDispatcher_addEventListener("CopySelectLayer_scrollToPage",self,self.scrollToPage)
    dxyDispatcher_addEventListener("CopySelectLayer_realUpdate",self,self.realUpdate)
end

function CopySelectLayer:scrollToPage(num)
    self.pageView:scrollToPage(num-1)
    self._ndRightN:setVisible(true)
    self._ndLeftN:setVisible(true)
    if self.pageView:getCurPageIndex() == 0 then
        self._ndLeftN:setVisible(false)
    end
    if self.pageView:getCurPageIndex()+1 == zzm.CopySelectModel:getOpenChapterCount() or self.pageView:getCurPageIndex()+1 == SceneConfigProvider:getChapterCount() then
        self._ndRightN:setVisible(false)
    end
end

function CopySelectLayer:setCkbState(data)
    local touchenable = false
    local bright = false
    local selected = false 
    
    if data.state == DefineConst.CONST_LUCKY_BOX_STATE_UNFINISHED then
        touchenable = true
        bright = false
        selected = false 
    elseif data.state == DefineConst.CONST_LUCKY_BOX_STATE_REWARDS then
        touchenable = true
        bright = true
        selected = false 
    elseif data.state == DefineConst.CONST_LUCKY_BOX_STATE_FINISH then
        touchenable = true
        bright = true
        selected = true 
    end
    self.ckb_list[data.boxId]:setTouchEnabled(touchenable)
    self.ckb_list[data.boxId]:setBright(bright)
    self.ckb_list[data.boxId]:setSelected(selected)
    local chapterId = zzm.CopySelectModel:getCurChapter()
    local progress = zzm.CopySelectModel:getBoxStartProgerssByIndex(chapterId,data.boxId)
    local start = zzm.CopySelectModel:getBoxStartByIndex(chapterId,data.boxId)
    local str = start .. " 星"
    self.boxStart[data.boxId]:setString(str)
    self.ckb_list[data.boxId]:setPositionX(progress*740)
end