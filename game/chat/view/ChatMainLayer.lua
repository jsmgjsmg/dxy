
CHAT_TYPE = {
    World = 1,
    Faction = 2,
    Friend = 3,
    Team = 4,
    System = 5,
}

ChatMainLayer = ChatMainLayer or class("ChatMainLayer",function()
    return cc.Layer:create()
end)

function ChatMainLayer.create()
    local layer = ChatMainLayer.new()
    return layer
end

function ChatMainLayer:ctor()
    self._csbNode = nil
    self.RedChatList = {}
    self.redPointList = {}
    self:initUI()
    dxyExtendEvent(self)
end

function ChatMainLayer:initUI()
    self._csbNode = cc.CSLoader:getInstance():createNodeWithFlatBuffersFile("dxyCocosStudio/csd/ui/chat/ChatMainLayer.csb")
    self:addChild(self._csbNode)
    self.visibleSize = cc.Director:getInstance():getVisibleSize()
    self.origin = cc.Director:getInstance():getVisibleOrigin()

    local posX = self.origin.x + self.visibleSize.width/2
    local posY = self.origin.y + self.visibleSize.height/2

    self:setPosition(posX, posY)

    self.containerPanel = self._csbNode:getChildByName("Panel")
    local node = self._csbNode:getChildByName("BG")
    self.btn_back = self._csbNode:getChildByName("Back")
    self.btn_back:setPosition(-posX+50, posY-40)

    local tab = node:getChildByName("Image_2"):getChildByName("TabPanel")
    self.ckb_ChatWorld = tab:getChildByName("CheckBox_01")
    self.redPointList[CHAT_TYPE.World] = self.ckb_ChatWorld:getChildByName("Red")
    self.ckb_ChatFaction = tab:getChildByName("CheckBox_02")
    self.redPointList[CHAT_TYPE.Faction] = self.ckb_ChatFaction:getChildByName("Red")
    self.ckb_ChatFriend = tab:getChildByName("CheckBox_03")
    self.redPointList[CHAT_TYPE.Friend] = self.ckb_ChatFriend:getChildByName("Red")
    self.ckb_ChatTeam = tab:getChildByName("CheckBox_04")
    self.redPointList[CHAT_TYPE.Team] = self.ckb_ChatTeam:getChildByName("Red")
    self.ckb_ChatSystem = tab:getChildByName("CheckBox_05")
    self.redPointList[CHAT_TYPE.System] = self.ckb_ChatSystem:getChildByName("Red")

    require "game.chat.view.ChatListPage"
    require "src/game/chat/view/ChatPrivatePage.lua"
    require "game.chat.view.ChatNoSendPage"

    self:onSelectByType(EnumChannelType.World)
    dxyDispatcher_dispatchEvent("MainScene_updateChatRedIcon", false)
    
    self:updateRedPoint({type = CHAT_TYPE.World, flag = zzm.ChatModel.RedChatList[CHAT_TYPE.World]})
    self:updateRedPoint({type = CHAT_TYPE.Faction, flag = zzm.ChatModel.RedChatList[CHAT_TYPE.Faction]})
    self:updateRedPoint({type = CHAT_TYPE.Friend, flag = zzm.ChatModel.RedChatList[CHAT_TYPE.Friend]})
    self:updateRedPoint({type = CHAT_TYPE.Team, flag = zzm.ChatModel.RedChatList[CHAT_TYPE.Team]})
    self:updateRedPoint({type = CHAT_TYPE.System, flag = zzm.ChatModel.RedChatList[CHAT_TYPE.System]})
end

function ChatMainLayer:updateRedPoint(data)
    local red = self.redPointList[data.type]
    if red then
    	red:setVisible(data.flag)
    end
end

function ChatMainLayer:WhenClose()
    dxyDispatcher_dispatchEvent("MainScene_updateChatRedIcon", false)
    self:removeFromParent()
    
    --zzc.ChatController:unregisterListenner()
end

function ChatMainLayer:removeEvent()
    
    dxyDispatcher_dispatchEvent("MainScene_updateChatRedIcon", false)
    dxyDispatcher_removeEventListener("ChatMainLayer_updateRedPoint",self,self.updateRedPoint)
    zzm.ChatModel.RedChat = false
end

function ChatMainLayer:initEvent()
    dxyDispatcher_addEventListener("ChatMainLayer_updateRedPoint",self,self.updateRedPoint)
    if(self.btn_back)then
        self.btn_back:addTouchEventListener(function(target,type)
            if(type==2)then
                --self:removeFromParent()
                zzc.ChatController:closeLayer()
            end
        end)
    end
    if (self.ckb_ChatWorld) then
        self.ckb_ChatWorld:addTouchEventListener(function(target,type)
            if type == 2 then
                self:onSelectByType(EnumChannelType.World)
            end
        end)
    end
    if (self.ckb_ChatFaction) then
        self.ckb_ChatFaction:addTouchEventListener(function(target,type)
            if type == 2 then
                self:onSelectByType(EnumChannelType.Faction)
            end
        end)
    end
    if (self.ckb_ChatFriend) then
        self.ckb_ChatFriend:addTouchEventListener(function(target,type)
            if type == 2 then
                self:onSelectByType(EnumChannelType.Private)
            end
        end)
    end
    if (self.ckb_ChatTeam) then
        self.ckb_ChatTeam:addTouchEventListener(function(target,type)
            if type == 2 then
                self:onSelectByType(EnumChannelType.Team)
            end
        end)
    end
    if (self.ckb_ChatSystem) then
        self.ckb_ChatSystem:addTouchEventListener(function(target,type)
            if type == 2 then
                self:onSelectByType(EnumChannelType.System)
            end
        end)
    end

    -- 拦截
    dxySwallowTouches(self)
end

function ChatMainLayer:setCkbUSelect()
    self.ckb_ChatWorld:setTouchEnabled(true)
    self.ckb_ChatFaction:setTouchEnabled(true)
    self.ckb_ChatFriend:setTouchEnabled(true)
    self.ckb_ChatTeam:setTouchEnabled(true)
    self.ckb_ChatSystem:setTouchEnabled(true)

    self.ckb_ChatWorld:setBright(true)
    self.ckb_ChatFaction:setBright(true)
    self.ckb_ChatFriend:setBright(true)
    self.ckb_ChatTeam:setBright(true)
    self.ckb_ChatSystem:setBright(true)
end

function ChatMainLayer:onSelectByType(type, p1, p2)
    if type == nil then
    	type = EnumChannelType.World
    end
    self:setCkbUSelect()
    self.containerPanel:removeAllChildren()
    local page = nil
    zzm.ChatModel.RedChatList[type] = false
    self:updateRedPoint({type = type, flag = false})
    if type == EnumChannelType.World then
        self.ckb_ChatWorld:setTouchEnabled(false)
        self.ckb_ChatWorld:setBright(false)
        page = ChatListPage.create(EnumChannelType.World)
    elseif type == EnumChannelType.Faction then
        self.ckb_ChatFaction:setTouchEnabled(false)
        self.ckb_ChatFaction:setBright(false)
        page = ChatListPage.create(EnumChannelType.Faction)
    elseif type == EnumChannelType.Private then
        self.ckb_ChatFriend:setTouchEnabled(false)
        self.ckb_ChatFriend:setBright(false)
        page = ChatPrivatePage.create()
        page:update(p1,p2)
    elseif type == EnumChannelType.Team then
        self.ckb_ChatTeam:setTouchEnabled(false)
        self.ckb_ChatTeam:setBright(false)
        page = ChatNoSendPage.create(EnumChannelType.Team)
    elseif type == EnumChannelType.System then
        self.ckb_ChatSystem:setTouchEnabled(false)
        self.ckb_ChatSystem:setBright(false)
        page = ChatNoSendPage.create(EnumChannelType.System)
    end
    if page then
        self.containerPanel:addChild(page)
    else
        dxyFloatMsg:show("敬请期待，正在开发！")
        print("Error，Page is nil！")
    end
end


