
ChatListPage = ChatListPage or class("ChatListPage",function()
    return cc.Layer:create()
end)

function ChatListPage.create(type)
    local layer = ChatListPage.new(type)
    return layer
end

function ChatListPage:ctor(type)
    self._csbNode = nil
    self._curIndex = 0
    self._channelType = type
    require("game/chat/view/ChatItem")
    self:initUI()
    dxyExtendEvent(self)
end

function ChatListPage:initUI()
    self._csbNode = cc.CSLoader:getInstance():createNodeWithFlatBuffersFile("dxyCocosStudio/csd/ui/chat/ChatListPage.csb")
    self:addChild(self._csbNode)

    local node = self._csbNode:getChildByName("Panel")
    self.btn_SendMessage = node:getChildByName("Button")
    self.input_Message = node:getChildByName("InputBG"):getChildByName("TextField")
    self.scrollView = node:getChildByName("Panel"):getChildByName("ScrollView")
    self.scrollView:setScrollBarEnabled(false)
    
    self._scrollHeight = self.scrollView:getContentSize().height
    self._scrollWidth = self.scrollView:getContentSize().width
    
    self:addAllMessage()

end

function ChatListPage:addAllMessage()
    ChatItem.parentSize = self._scrollWidth
    local dataList = zzm.ChatModel:getMessageByChannel(self._channelType)
    --local dataList = zzm.ChatModel:getMessageByUID(167)
    
    for index=1,#dataList do
        self:addMessage(dataList[index])
    end
end

function ChatListPage:addMessage(message)
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

function ChatListPage:removeEvent()
    dxyDispatcher_removeEventListener('dxyEventType.Chat_Add_Message',self,self.addMessage)
end

function ChatListPage:initEvent()
    dxyDispatcher_addEventListener("dxyEventType.Chat_Add_Message",self,self.addMessage)

    if(self.btn_SendMessage)then
        self.btn_SendMessage:addTouchEventListener(function(target,type)
            if(type==2)then
                local message = self.input_Message:getString()
                if not message or message == "" then
                    TipsFrame:create("消息不能为空")
                    return
                end
                if zzc.ChatController:checkMessage(message) then
                    TipsFrame:create("消息包含敏感字符")
                    return
                end
                local data = {}
                data.uid = 0
                data.channel = self._channelType
                data.message = message
                zzc.ChatController:request_SendMessage(data)
                self.input_Message:setString("")
            end
        end)
    end
end

