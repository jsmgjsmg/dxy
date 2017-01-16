
FriendUpListPage = FriendUpListPage or class("FriendUpListPage",function()
    return cc.Layer:create()
end)

function FriendUpListPage.create(type)
    local layer = FriendUpListPage.new(type)
    return layer
end

function FriendUpListPage:ctor(type)
    self._csbNode = nil
    self._curIndex = 0
    self._pageType = type
--    require("game.login.view.OneServerItem")
    require("game.friend.view.FriendListItem")

    dxyExtendEvent(self)
    self:initUI()
    --self:initEvent()  
end

function FriendUpListPage:initUI()
    self._csbNode = cc.CSLoader:getInstance():createNodeWithFlatBuffersFile("dxyCocosStudio/csd/ui/friend/FriendUpListPage.csb")
    self:addChild(self._csbNode)
    
    local node = self._csbNode:getChildByName("Panel")
    self.btn_OneKeyGive = node:getChildByName("OneKeyGive")
    self.btn_OneKeyGet = node:getChildByName("OneKeyGet")
    self.listView = node:getChildByName("ListView")
    
    self:updateFriendList()

end

function FriendUpListPage:updateFriendList()

    self.listView:removeAllChildren()
    local list = zzm.FriendModel:getFriendDataByType(self._pageType)
    if self._pageType == FRIEND_PANEL_TYPE.ListLayer then
        self.btn_OneKeyGet:setVisible(false)
    elseif self._pageType == FRIEND_PANEL_TYPE.GiftLayer then
        self.btn_OneKeyGive:setVisible(false)
    end
    local count = 0
    self.listItem = {}
    for key, var in pairs(list) do
        count = count + 1
        local item = FriendListItem.create(self._pageType)
        item:updateAddItem(var)
        self.listView:pushBackCustomItem(item) --pushBackCustomItem
        self.listItem[count] = item
    end
    self._curIndex = 0
    self.curItem = self.listItem[self._curIndex+1]
    if self.curItem then
        self.curItem:setSelect(true)
    end
end

function FriendUpListPage:removeEvent()
    dxyDispatcher_removeEventListener(dxyEventType.Friend_List_Update,self,self.updateFriendList)
    dxyDispatcher_removeEventListener("FriendUpListPage_DeletItem",self,self.updateItem)
end

function FriendUpListPage:initEvent()
    dxyDispatcher_addEventListener(dxyEventType.Friend_List_Update,self,self.updateFriendList)
    dxyDispatcher_addEventListener("FriendUpListPage_DeletItem",self,self.updateItem)
    if(self.btn_OneKeyGive)then
        self.btn_OneKeyGive:addTouchEventListener(function(target,type)
            if(type==2)then
                zzc.FriendController:request_GiveGift(0,FRIEND_PANEL_TYPE.ListLayer)
                self:upateSendGiftBtn()
--                zzc.FriendController:request_InitFriend()
            end
        end)
    end
    
    if(self.btn_OneKeyGet)then
        self.btn_OneKeyGet:addTouchEventListener(function(target,type)
            if(type==2)then
                zzc.FriendController:request_AcceptGift(0)
                zzc.FriendController:request_InitFriend()
            end
        end)
    end

    if (self.listView) then
        self.listView:addEventListener(function(target,type)
            if(type==ccui.ListViewEventType.ONSELECTEDITEM_END)then
                print("select child index = %d",target:getCurSelectedIndex())
                if self._curIndex ~= target:getCurSelectedIndex() then
                    self._curIndex = target:getCurSelectedIndex()
                    self.curItem:setSelect(false)
                    self.curItem = self.listItem[self._curIndex+1]
                    self.curItem:setSelect(true)
                end
            end
        end)
    end

end

function FriendUpListPage:updateItem(count)
    for key, var in pairs(self.listItem) do
        if var.m_data and var.m_data.uid == count then
	 		var:removeFromParent()
	 		break
	 	end
	 end
	 
end

function FriendUpListPage:upateSendGiftBtn()
    for key, var in pairs(self.listItem) do
		var:setBtnVisible()
	end
end
