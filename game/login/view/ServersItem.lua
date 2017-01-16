
ServersItem = ServersItem or class("ServersItem",function()
    return ccui.Layout:create()
end)

ServersItem.parentSize = 400

function ServersItem.create()
    local node = ServersItem.new()
    return node
end

function ServersItem:ctor()
    self._csbNode = nil
    self:initUI()
end

function ServersItem:initUI()
    self._csbNode = cc.CSLoader:createNode("dxyCocosStudio/csd/ui/login/ServersItem.csb")
    self:addChild(self._csbNode)

    self:setContentSize(cc.size(200,50))
    self:setAnchorPoint(cc.p(0,0))
    self:setTouchEnabled(true)

    self.itemButton = self._csbNode:getChildByName("Button")
    self.contentsText = self.itemButton:getChildByName("Text")
end

function ServersItem:update(data)
    self.m_data = data
    self.titleText:setString(self.m_data.title)

    local contents = cc.Label:createWithTTF("","dxyCocosStudio/font/MicosoftBlack.ttf",20)
    contents:setDimensions(OneServerItem.parentSize,contents:getDimensions().height)
    contents:setAlignment(0)
    contents:setAnchorPoint(0,0)
    contents:setString(self.m_data.contents)
    self.itemPanel:addChild(contents)

    local contentsHeight = contents:getContentSize().height
    self.itemPanel:setContentSize(OneServerItem.parentSize, contentsHeight)
    self.titleBG:setPositionY(contentsHeight)
end

function ServersItem:updateButton(title)
    self.m_data = title
    self.contentsText:setString(title)
    self.itemButton:setTouchEnabled(true)
end

function ServersItem:updateServer(title)
    self.m_data = title
    self.contentsText:setString(title)
end

function ServersItem:getItemHgight()
    return self.titleBG:getContentSize().height + self.itemPanel:getContentSize().height
end




