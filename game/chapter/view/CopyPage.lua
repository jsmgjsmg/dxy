
CopyPage = CopyPage or class("CopyPage",function()
    return ccui.Layout:create()
end)

function CopyPage:create(index)
    local node = CopyPage.new()
    node:initUI(index)
    return node
end

function CopyPage:ctor()
    self._csbNode = nil
    self.copyPanel = nil
    self.copyBG = nil
    self.m_data = nil
    self.arrCopyItem = {}
end

function CopyPage:initUI(data)
    self._csbNode = cc.CSLoader:createNode("dxyCocosStudio/csd/ui/copy/CopyPage.csb")
    self:addChild(self._csbNode)
    
--    self:setAnchorPoint(cc.p(0,0))
--    self:setTouchEnabled(true)

    self.visibleSize = cc.Director:getInstance():getVisibleSize()
    self.origin = cc.Director:getInstance():getVisibleOrigin()
    
    self.m_data = data

    local posX = self.origin.x + self.visibleSize.width/2
    local posY = self.origin.y + self.visibleSize.height/2
    
    self.copyPanel = self._csbNode:getChildByName("Panel")
    self.copyBG = self._csbNode:getChildByName("CopyBG")
    self.copyBG:setPosition(posX, posY)

    self.chapterRoute = self._csbNode:getChildByName("D"..self.m_data)
    if self.chapterRoute then
        local posX = self.origin.x + self.visibleSize.width/2
        local posY = self.origin.y + self.visibleSize.height/2
        self.chapterRoute:setPosition(posX,posY)
        self.chapterRoute:setVisible(true)
    end

    require("game.chapter.view.CopyItem")
    self.chapter = zzm.CopySelectModel:getChapterByID(self.m_data)
    local id = self.chapter.Id
    local name = self.chapter.Name
    local copyList = self.chapter.CopyId
    
    for index=1,#copyList do
        local itemData = SceneConfigProvider:getCopyById(copyList[index].CopyId)
        local copy = zzm.CopySelectModel:getCopyData(itemData.Id)
        local point = self.chapterRoute:getChildByName(copyList[index].CopyId.."")
        if point and copy then
            point:setVisible(true)
        end

        self.arrCopyItem[index] = CopyItem.create()
        self.copyPanel:addChild(self.arrCopyItem[index])
    end
end

function CopyPage:update()
    for i=1,#self.arrCopyItem do
        self.arrCopyItem[i]:setConfig(SceneConfigProvider:getCopyById(self.chapter.CopyId[i].CopyId))
        self.arrCopyItem[i]:setName("CopyItem"..self.chapter.CopyId[i].CopyId)
    end
    
--    self.chapterRoute = self._csbNode:getChildByName("D"..self.m_data)
--    if self.chapterRoute then
--        local posX = self.origin.x + self.visibleSize.width/2
--        local posY = self.origin.y + self.visibleSize.height/2
--    	self.chapterRoute:setPosition(posX,posY)
--        self.chapterRoute:setVisible(true)
--    end
--    
--    -- data 为章节ID
--    local chapter = zzm.CopySelectModel:getChapterByID(self.m_data)
--    local id = chapter.Id
--    local name = chapter.Name
--    local copyList = chapter.CopyId
--    
--    local path = "dxyCocosStudio/png/chapter/new/"
--    --self.copyBG:setTexture(path .. data.Image)
--    --self.titleText:setString(data.TitleName)
--    
--    for index=1,#copyList do
--        local data = SceneConfigProvider:getCopyById(copyList[index].CopyId)
--        local copy = zzm.CopySelectModel:getCopyData(data.Id)
--        local point = self.chapterRoute:getChildByName(copyList[index].CopyId.."")
--        if point and copy then
--            point:setVisible(true)
--        end
--            
--        local item = CopyItem.create()
--        self.copyPanel:addChild(item)
--        
----        self.arrCopyItem[index] = CopyItem.create()
----        self.copyPanel:addChild(self.arrCopyItem[index])
--        
--        item:setConfig(data)
--	   item:setName("CopyItem"..copyList[index].CopyId)
--    end
    
end

function CopyPage:getPageSize()
    return self.copyBG:getContentSize() 
end




