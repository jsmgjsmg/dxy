
ChatItem = ChatItem or class("ChatItem",function()
    return cc.Node:create()
end)

ChatItem.parentSize = 400


function ChatItem.create()
    local node = ChatItem.new()
    return node
end

function ChatItem:ctor()
    self._csbNode = nil
    self:initUI()
end

function ChatItem:initUI()
    require("game.chat.view.ChatAddGroup")
    require("src.game.chat.view.ChatFunctionTips")
    self._csbNode = cc.CSLoader:createNode("dxyCocosStudio/csd/ui/chat/ChatItem.csb")
    self:addChild(self._csbNode)

    self.itemPanel = self._csbNode:getChildByName("Panel")
    self.titleBG = self.itemPanel:getChildByName("TitlePanel")
    self.titleText = self.titleBG:getChildByName("NameText")
    self.timeText = self.titleText:getChildByName("TimeText")
    self.contentText = self.itemPanel:getChildByName("Text")
    
    self.titleText:addTouchEventListener(function(target,type)
            if(type==2)then
                local role = zzm.CharacterModel:getCharacterData()
                local enCAT = enCharacterAttrType
                local uid = role:getValueByType(enCAT.UID)
                if self.m_data.uid == uid then
                	--TipsFrame:create("你选择的是自己。。。")
                	return
                end
                ChatFunctionTips.m_data = self.m_data
                ChatFunctionTips.create()
            end
        end)
end

function ChatItem:update(data)
    self.m_data = data
    local name = self.m_data.uname
    local message = self.m_data.message
    self.titleText:setString(name)

    self.timeText:setString("         ("..cn:toMD(self.m_data.time)..")")
    
    self.contentText:setString(message)
    local w = self.contentText:getContentSize().width
    local bgW = ChatItem.parentSize - 20
    if w < ChatItem.parentSize-30 then
        bgW = w + 20
    end
    
    self.contentText:setString("")
    if self.m_data.subType == 1 then
    	self.contentText:setString("["..self.m_data.factionName.."]")
        self.contentText:setPosition(10,10)
    elseif self.m_data.subType == 2 then
        self.contentText:setString(message)
        self.contentText:setPosition(10,10)
        message = "."
    end
   
    local contents = cc.Label:createWithTTF("","dxyCocosStudio/font/MicosoftBlack.ttf",20)
--    local contents = cc.Label:createWithTTF("","Trebuchet Ms",20)
    contents:setDimensions(ChatItem.parentSize-30, contents:getDimensions().height)
    contents:setAlignment(0)
    contents:setAnchorPoint(0,0)
    contents:setString(message)
    self.itemPanel:addChild(contents)
    contents:setPosition(10,10)
    local contentsHeight = contents:getContentSize().height

    --local contentsHeight = self._richChat:getContentSize().height
    local titleHeight = self.titleBG:getContentSize().height
    local itemHeight = contentsHeight + 20
    self.itemPanel:setContentSize(bgW, itemHeight)
    self.itemPanel:setPositionX(10)
    self.titleBG:setPositionY(itemHeight-5)
    
    if self.m_data.channel == EnumChannelType.World and self.m_data.subType == 1 then
        local function onTouchBegan(touch, event) 
            local location = touch:getLocation()
            local point = self.contentText:convertToNodeSpace(location)
            local rect = cc.rect(0,0,self.contentText:getContentSize().width,self.contentText:getContentSize().height)
            if cc.rectContainsPoint(rect,point) then
                return true
            end
            return false
        end
        local function onTouchEnded(touch, event)
                local role = zzm.CharacterModel:getCharacterData()
                local enCAT = enCharacterAttrType
                local power = role:getValueByType(enCAT.POWER)
                
                if tonumber(self.m_data.power) > power then
                    TipsFrame:create("你的战力不足，加油吧。。。")
                    return
                end
                ChatAddGroup.m_data = self.m_data
                ChatAddGroup.create()
        end

        local listener = cc.EventListenerTouchOneByOne:create()
        listener:registerScriptHandler(onTouchBegan,cc.Handler.EVENT_TOUCH_BEGAN )
        listener:registerScriptHandler(onTouchEnded,cc.Handler.EVENT_TOUCH_ENDED )
        local eventDispatcher = self:getEventDispatcher()
        eventDispatcher:addEventListenerWithSceneGraphPriority(listener, self.contentText)

    elseif self.m_data.channel == EnumChannelType.World and self.m_data.subType == 2 then
        local function onTouchBegan(touch, event) 
            local location = touch:getLocation()
            local point = self.contentText:convertToNodeSpace(location)
            local rect = cc.rect(0,0,self.contentText:getContentSize().width,self.contentText:getContentSize().height)
            if cc.rectContainsPoint(rect,point) then
                return true
            end
            return false
        end
        local function onTouchEnded(touch, event)
            local role = zzm.CharacterModel:getCharacterData()
            local enCAT = enCharacterAttrType
            local power = role:getValueByType(enCAT.POWER)

            if tonumber(self.m_data.power) > power then
                TipsFrame:create("你的战力不足，加油吧。。。")
                return
            end
            zzc.GroupController:JoinTeamTower(self.m_data.special)
            dxyFloatMsg:show("已发送组队请求。")
--                ChatAddGroup.m_data = self.m_data
--                ChatAddGroup.create()
        end

        local listener = cc.EventListenerTouchOneByOne:create()
        listener:registerScriptHandler(onTouchBegan,cc.Handler.EVENT_TOUCH_BEGAN )
        listener:registerScriptHandler(onTouchEnded,cc.Handler.EVENT_TOUCH_ENDED )
        local eventDispatcher = self:getEventDispatcher()
        eventDispatcher:addEventListenerWithSceneGraphPriority(listener, self.contentText)

    end
end

function ChatItem:getItemHgight()
    return self.itemPanel:getContentSize().height + 35
end




