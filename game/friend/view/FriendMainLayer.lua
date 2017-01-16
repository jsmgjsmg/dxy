
FRIEND_PANEL_TYPE = {
    ListLayer = 1,
    ApplyLayer = 2,
    ContactLayer = 3,
    GiftLayer = 4,
    AddLayer = 5,
}

FriendMainLayer = FriendMainLayer or class("FriendMainLayer",function()
    return cc.Layer:create()
end)

function FriendMainLayer.create()
    local layer = FriendMainLayer.new()
    return layer
end

function FriendMainLayer:ctor()
    self._csbNode = nil
    self.redFriendList = {}
    require("game.friend.view.FriendFunctionTips")
--    zzc.FriendController:request_InitFriend()
    self:initUI()
    dxyExtendEvent(self)
end

function FriendMainLayer:initUI()
    self._csbNode = cc.CSLoader:getInstance():createNodeWithFlatBuffersFile("dxyCocosStudio/csd/ui/friend/FriendMainLayer.csb")
    self:addChild(self._csbNode)
    self.visibleSize = cc.Director:getInstance():getVisibleSize()
    self.origin = cc.Director:getInstance():getVisibleOrigin()

    local posX = self.origin.x + self.visibleSize.width/2
    local posY = self.origin.y + self.visibleSize.height/2

    self:setPosition(posX, posY)

    self.containerPanel = self._csbNode:getChildByName("Panel")
    local node = self._csbNode:getChildByName("BG")
    --node:setContentSize(self.visibleSize.width,self.visibleSize.height)
    
    self.btn_back = self._csbNode:getChildByName("Back")
    self.btn_back:setPosition(-posX+50, posY-40)
    
    local tab = node:getChildByName("Image_1"):getChildByName("TabPanel")
    self.ckb_friendList = tab:getChildByName("CheckBox_01")
    self.ckb_friendApply = tab:getChildByName("CheckBox_02")
    self.redFriendList[FRIEND_PANEL_TYPE.ApplyLayer] = self.ckb_friendApply:getChildByName("Red")
    self.ckb_friendContact = tab:getChildByName("CheckBox_03")
    self.redFriendList[FRIEND_PANEL_TYPE.ContactLayer] = self.ckb_friendContact:getChildByName("Red")
    self.ckb_friendGift = tab:getChildByName("CheckBox_04")
    self.redFriendList[FRIEND_PANEL_TYPE.GiftLayer] = self.ckb_friendGift:getChildByName("Red")
    self.ckb_friendAdd = tab:getChildByName("CheckBox_05")
    
    require "game.friend.view.FriendUpListPage"
    require "game.friend.view.FriendFullListPage"
    require "game.friend.view.FriendAddPage"

    self:onSelectByType(FRIEND_PANEL_TYPE.ListLayer)
    print("dd")
    self:updateFriendRed({type = FRIEND_PANEL_TYPE.ApplyLayer, flag = zzm.FriendModel.applyRed})
    self:updateFriendRed({type = FRIEND_PANEL_TYPE.ContactLayer, flag = zzm.FriendModel.recentlyRed})
    self:updateFriendRed({type = FRIEND_PANEL_TYPE.GiftLayer, flag = zzm.FriendModel.giftRed})
end

function FriendMainLayer:updateFriendRed(data)
    local red = self.redFriendList[data.type]
    if red then
        red:setVisible(data.flag)
    end
end

function FriendMainLayer:WhenClose()
    self:removeFromParent()
end

function FriendMainLayer:removeEvent()
    
    if  zzm.FriendModel.applyRed == false and  zzm.FriendModel.recentlyRed == false and  zzm.FriendModel.giftRed == false then
        dxyDispatcher_dispatchEvent("MainScene_updateFriendRedIcon", false)
    else
        dxyDispatcher_dispatchEvent("MainScene_updateFriendRedIcon", true)
    end
    dxyDispatcher_removeEventListener("FriendMainLayer_updateFriendRed",self,self.updateFriendRed)
    
end

function FriendMainLayer:initEvent()
    dxyDispatcher_addEventListener("FriendMainLayer_updateFriendRed",self,self.updateFriendRed)
    
    if(self.btn_back)then
        self.btn_back:addTouchEventListener(function(target,type)
            if(type==2)then
                self:removeFromParent()
            end
        end)
    end
    if (self.ckb_friendList) then
        self.ckb_friendList:addTouchEventListener(function(target,type)
            if type == 2 then
                self:onSelectByType(FRIEND_PANEL_TYPE.ListLayer)
            end
        end)
    end
    if (self.ckb_friendApply) then
        self.ckb_friendApply:addTouchEventListener(function(target,type)
            if type == 2 then
                self:onSelectByType(FRIEND_PANEL_TYPE.ApplyLayer)
                self:updateFriendRed({type = FRIEND_PANEL_TYPE.ApplyLayer, flag = false})
            end
        end)
    end
    if (self.ckb_friendContact) then
        self.ckb_friendContact:addTouchEventListener(function(target,type)
            if type == 2 then
                self:onSelectByType(FRIEND_PANEL_TYPE.ContactLayer)
                self:updateFriendRed({type = FRIEND_PANEL_TYPE.ContactLayer, flag = false})
                
                zzm.FriendModel.recentlyRed = false
            end
        end)
    end
    if (self.ckb_friendGift) then
        self.ckb_friendGift:addTouchEventListener(function(target,type)
            if type == 2 then
                self:onSelectByType(FRIEND_PANEL_TYPE.GiftLayer)
                self:updateFriendRed({type = FRIEND_PANEL_TYPE.GiftLayer, flag = false})
            end
        end)
    end
    if (self.ckb_friendAdd) then
        self.ckb_friendAdd:addTouchEventListener(function(target,type)
            if type == 2 then
                self:onSelectByType(FRIEND_PANEL_TYPE.AddLayer)
            end
        end)
    end

    -- 拦截
    dxySwallowTouches(self)
end

function FriendMainLayer:setCkbUSelect()
    self.ckb_friendList:setTouchEnabled(true)
    self.ckb_friendApply:setTouchEnabled(true)
    self.ckb_friendContact:setTouchEnabled(true)
    self.ckb_friendGift:setTouchEnabled(true)
    self.ckb_friendAdd:setTouchEnabled(true)
    
    self.ckb_friendList:setBright(true)
    self.ckb_friendApply:setBright(true)
    self.ckb_friendContact:setBright(true)
    self.ckb_friendGift:setBright(true)
    self.ckb_friendAdd:setBright(true)
end

function FriendMainLayer:onSelectByType(type)
    self:setCkbUSelect()
    self.containerPanel:removeAllChildren()
    local page = nil
    if type == FRIEND_PANEL_TYPE.ListLayer then
        self.ckb_friendList:setTouchEnabled(false)
        self.ckb_friendList:setBright(false)
        page = FriendUpListPage.create(type)
    elseif type == FRIEND_PANEL_TYPE.ApplyLayer then
        self.ckb_friendApply:setTouchEnabled(false)
        self.ckb_friendApply:setBright(false)
        page = FriendFullListPage.create(type)
    elseif type == FRIEND_PANEL_TYPE.ContactLayer then
        self.ckb_friendContact:setTouchEnabled(false)
        self.ckb_friendContact:setBright(false)
        page = FriendFullListPage.create(type)
    elseif type == FRIEND_PANEL_TYPE.GiftLayer then
        self.ckb_friendGift:setTouchEnabled(false)
        self.ckb_friendGift:setBright(false)
        page = FriendUpListPage.create(type)
    elseif type == FRIEND_PANEL_TYPE.AddLayer then
        self.ckb_friendAdd:setTouchEnabled(false)
        self.ckb_friendAdd:setBright(false)
        page = FriendAddPage.create(type)
    end
    if page then
        self.containerPanel:addChild(page)
    else
        dxyFloatMsg:show("敬请期待，正在开发！")
        print("Error，Page is nil！")
    end
end
