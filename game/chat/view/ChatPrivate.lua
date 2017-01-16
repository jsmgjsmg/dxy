
ChatPrivate = ChatPrivate or class("ChatPrivate",function()
    return ccui.Layout:create()
end)

ChatPrivate.parentSize = 400

function ChatPrivate.create()
    local node = ChatPrivate.new()
    return node
end

function ChatPrivate:ctor()
    self._csbNode = nil
    self.uid = 0
    self:initUI()
end

function ChatPrivate:initUI()
    self._csbNode = cc.CSLoader:createNode("dxyCocosStudio/csd/ui/chat/ChatPrivate.csb")
    self:addChild(self._csbNode)

    self:setContentSize(cc.size(200,50))
    self:setAnchorPoint(cc.p(0,0))
    self:setTouchEnabled(true)

    self.itemButton = self._csbNode:getChildByName("Button")
    self.contentsText = self.itemButton:getChildByName("Text")
end

function ChatPrivate:update(data)
    self.m_data = data
    self.titleText:setString(self.m_data.title)

    local contents = cc.Label:createWithTTF("","dxyCocosStudio/font/MicosoftBlack.ttf",20)
    contents:setDimensions(ChatPrivate.parentSize,contents:getDimensions().height)
    contents:setAlignment(0)
    contents:setAnchorPoint(0,0)
    contents:setString(self.m_data.contents)
    self.itemPanel:addChild(contents)

    local contentsHeight = contents:getContentSize().height
    self.itemPanel:setContentSize(ChatPrivate.parentSize, contentsHeight)
    self.titleBG:setPositionY(contentsHeight)
end

function ChatPrivate:updateButton(uid)
    self.m_data = uid
    local name = zzm.ChatModel:getPriveteRoleName(uid) 
    self.contentsText:setString(name)
   -- self.itemButton:setTouchEnabled(true)
end

function ChatPrivate:getItemHgight()
    return self.titleBG:getContentSize().height + self.itemPanel:getContentSize().height
end




