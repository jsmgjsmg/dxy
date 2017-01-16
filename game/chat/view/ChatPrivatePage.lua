
ChatPrivatePage = ChatPrivatePage or class("ChatPrivatePage",function()
    return cc.Layer:create()
end)

ChatPrivatePage.curentUid = 0
ChatPrivatePage.curentName = ""

function ChatPrivatePage.create()
    local layer = ChatPrivatePage.new()
    return layer
end

function ChatPrivatePage:ctor()
    self._csbNode = nil
    self._curIndex = 0
    require("game/chat/view/ChatItem")
    require "game/chat/view/ChatPrivate"
    self:initUI()
    dxyExtendEvent(self)
end

function ChatPrivatePage:initUI()
    self._csbNode = cc.CSLoader:getInstance():createNodeWithFlatBuffersFile("dxyCocosStudio/csd/ui/chat/ChatPrivatePage.csb")
    self:addChild(self._csbNode)

    local node = self._csbNode:getChildByName("Panel")
    self.btn_SendMessage = node:getChildByName("Button")
    self.input_Message = node:getChildByName("InputBG"):getChildByName("TextField")
    self.scrollView = node:getChildByName("Panel"):getChildByName("ScrollView")
    self.scrollView:setScrollBarEnabled(false)
    self.ListView = node:getChildByName("RolePanel"):getChildByName("ListView")
    self.nameText = node:getChildByName("Title"):getChildByName("Text")
    
    self._scrollHeight = self.scrollView:getContentSize().height
    self._scrollWidth = self.scrollView:getContentSize().width
    
    local data = zzm.ChatModel:getPriveteData()
    self.itemList = {}
    local index = 0
    for key, var in pairs(data) do
        if ChatPrivatePage.curentUid == 0 then
        	ChatPrivatePage.curentUid = key
            ChatPrivatePage.curentName = var[1].specialname
        end
        local item = ChatPrivate.create()
        item.uid = key
        item.specialname = var[1].specialname
        item:updateButton(key)
        self.ListView:pushBackCustomItem(item) --pushBackCustomItem
        self.itemList[index] = item
        index = index + 1
    end
    
    self:updateTitle()
    
    self:addAllMessage(ChatPrivatePage.curentUid)

end

function ChatPrivatePage:updateTitle()
    if ChatPrivatePage.curentUid == 0 then
        self.nameText:setString("")
    else
--        local name = zzm.ChatModel:getPriveteRoleName(ChatPrivatePage.curentUid) 
        if ChatPrivatePage.curentName then
        	self.nameText:setString("当前正和“" .. ChatPrivatePage.curentName .. "”聊天")
        end
        
    end
    
end

function ChatPrivatePage:update(uid, name)
    if uid ~= nil then
        ChatPrivatePage.curentUid = uid
        ChatPrivatePage.curentName = name
        if name ~= nil then
            self.nameText:setString("当前正和“" .. name .. "”聊天")
        else
            self.nameText:setString("当前正和“" .. uid .. "”聊天")
        end
        self:addAllMessage(ChatPrivatePage.curentUid)
    end
end

function ChatPrivatePage:addAllMessage(uid)
    ChatItem.parentSize = self._scrollWidth
    --local dataList = zzm.ChatModel:getMessageByChannel(EnumChannelType.World)
    local dataList = zzm.ChatModel:getMessageByUID(uid)
    self.scrollView:removeAllChildren()
    for index=1,#dataList do
        self:addMessage(dataList[index])
    end
end

function ChatPrivatePage:addMessage(message)
    if message.channel ~= EnumChannelType.Private then
    	return
    end
    if message.special ~= ChatPrivatePage.curentUid then
        return
    end
    local item = ChatItem.create()
    self.scrollView:addChild(item)
    item:setPosition(0,self._scrollHeight)
    item:update(message)
    self._scrollHeight = self._scrollHeight + item:getItemHgight()
    self.scrollView:setInnerContainerSize(cc.size(self._scrollWidth,self._scrollHeight))
end

function ChatPrivatePage:removeEvent()
    dxyDispatcher_removeEventListener('dxyEventType.Chat_Add_Message',self,self.addMessage)
end

function ChatPrivatePage:initEvent()
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
                if not ChatPrivatePage.curentUid or ChatPrivatePage.curentUid == 0 then
                    TipsFrame:create("请选择私聊对象")
                    return
                end
                print("-------UID:".. ChatPrivatePage.curentUid)
                
                local data = {}
                data.uid = ChatPrivatePage.curentUid
                data.channel = EnumChannelType.Private
                data.message = message
                zzc.ChatController:request_SendMessage(data)
                self.input_Message:setString("")
            end
        end)
    end
    if (self.ListView) then
        self.ListView:addEventListener(function(target,type)
            if(type==ccui.ListViewEventType.ONSELECTEDITEM_END)then
                print("select child index = %d",target:getCurSelectedIndex())
--                if self._curIndex ~= target:getCurSelectedIndex() then
                    self._curIndex = target:getCurSelectedIndex()
                    ChatPrivatePage.curentUid = self.itemList[self._curIndex].uid
                    ChatPrivatePage.curentName = self.itemList[self._curIndex].specialname
                    print(ChatPrivatePage.curentUid)
                    print(ChatPrivatePage.curentName)
                    self:updateTitle()
                    self:addAllMessage(ChatPrivatePage.curentUid)
--                end
            end
        end)
    end

end

