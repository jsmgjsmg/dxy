
ChatNoSendPage = ChatNoSendPage or class("ChatNoSendPage",function()
    return cc.Layer:create()
end)

function ChatNoSendPage.create(type)
    local layer = ChatNoSendPage.new(type)
    return layer
end

function ChatNoSendPage:ctor(type)
    self._csbNode = nil
    self._curIndex = 0
    self._channelType = type
    require("game/chat/view/ChatItem")
    self:initUI()
    dxyExtendEvent(self)
end

function ChatNoSendPage:initUI()
    self._csbNode = cc.CSLoader:getInstance():createNodeWithFlatBuffersFile("dxyCocosStudio/csd/ui/chat/ChatNoSendPage.csb")
    self:addChild(self._csbNode)

    local node = self._csbNode:getChildByName("Panel")
    self.scrollView = node:getChildByName("Panel"):getChildByName("ScrollView")
    
    self._scrollHeight = self.scrollView:getContentSize().height
    self._scrollWidth = self.scrollView:getContentSize().width
    
    self:addAllMessage()

end

function ChatNoSendPage:addAllMessage()
    ChatItem.parentSize = self._scrollWidth
    local dataList = zzm.ChatModel:getMessageByChannel(self._channelType)
    --local dataList = zzm.ChatModel:getMessageByUID(167)
    
    for index=1,#dataList do
        self:addMessage(dataList[index])
    end
end

function ChatNoSendPage:addMessage(message)
    if message.channel ~= self._channelType then
    	return
    end
    local item = ChatItem.create()
    self.scrollView:addChild(item)
    item:setPosition(0,self._scrollHeight)
    item:update(message)
    self._scrollHeight = self._scrollHeight + item:getItemHgight()
    self.scrollView:setInnerContainerSize(cc.size(self._scrollWidth,self._scrollHeight))
end

function ChatNoSendPage:removeEvent()
    dxyDispatcher_removeEventListener('dxyEventType.Chat_Add_Message',self,self.addMessage)
end

function ChatNoSendPage:initEvent()
    dxyDispatcher_addEventListener("dxyEventType.Chat_Add_Message",self,self.addMessage)
end

