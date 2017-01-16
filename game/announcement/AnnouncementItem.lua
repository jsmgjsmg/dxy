
AnnouncementItem = AnnouncementItem or class("AnnouncementItem",function()
    return cc.Node:create()
end)

AnnouncementItem.parentSize = 400

function AnnouncementItem.create()
    local node = AnnouncementItem.new()
    return node
end

function AnnouncementItem:ctor()
    self._csbNode = nil
    self:initUI()
end

function AnnouncementItem:initUI()
    self._csbNode = cc.CSLoader:createNode("dxyCocosStudio/csd/ui/announcement/AnnouncementItem.csb")
    self:addChild(self._csbNode)
    
    self.itemPanel = self._csbNode:getChildByName("Panel")
    self.titleBG = self.itemPanel:getChildByName("TitleBG")
    self.titleText = self.titleBG:getChildByName("Text")
    self.contentsText = self.itemPanel:getChildByName("Text")
end

function AnnouncementItem:update(data)
    self.m_data = data
    self.titleText:setString(self.m_data.title)
    
    local contents = cc.Label:createWithTTF("","dxyCocosStudio/font/MicosoftBlack.ttf",20)
    contents:setDimensions(AnnouncementItem.parentSize-15,contents:getDimensions().height)
    contents:setAlignment(0)
    contents:setAnchorPoint(0,0)
    contents:setString(self.m_data.content)
    self.itemPanel:addChild(contents)
    contents:setPosition(10,5)
    
    local contentsHeight = contents:getContentSize().height
    local titleHeight = self.titleBG:getContentSize().height
    local itemHeight = contents:getContentSize().height + self.titleBG:getContentSize().height + 10
    self.itemPanel:setContentSize(AnnouncementItem.parentSize, itemHeight)
    self.titleBG:setPositionY(itemHeight-5)
    
end

function AnnouncementItem:getItemHgight()
    return self.itemPanel:getContentSize().height + 5
end




