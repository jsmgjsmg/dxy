

FriendFullListPage = FriendFullListPage or class("FriendFullListPage",function()
    return cc.Layer:create()
end)

FriendFullListPage.PageType = nil

function FriendFullListPage.create(type)
    local layer = FriendFullListPage.new(type)
    return layer
end

function FriendFullListPage:ctor(type)
    self._csbNode = nil
    self._curIndex = 0
    self._pageType = type
    --    require("game.login.view.OneServerItem")
    require("game.friend.view.FriendListItem")


    dxyExtendEvent(self)
    self:initUI()
    --self:initEvent()  
end

function FriendFullListPage:initUI()
    self._csbNode = cc.CSLoader:getInstance():createNodeWithFlatBuffersFile("dxyCocosStudio/csd/ui/friend/FriendFullListPage.csb")
    self:addChild(self._csbNode)

    local node = self._csbNode:getChildByName("Panel")
    self.listView = node:getChildByName("ListView")
    self:updateFriendList()
end

function FriendFullListPage:updateFriendList()

    self.listView:removeAllChildren()
    local list = nil
    if self._pageType == FRIEND_PANEL_TYPE.ContactLayer then
        list = zzm.FriendModel:getRecentlyList()
    else
        list = zzm.FriendModel:getFriendDataByType(self._pageType)
    end
--    local list = zzm.FriendModel:getFriendDataByType(self._pageType)
    
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

function FriendFullListPage:removeEvent()
    dxyDispatcher_removeEventListener(dxyEventType.Friend_List_Update,self,self.updateFriendList)
end

function FriendFullListPage:initEvent()
    dxyDispatcher_addEventListener(dxyEventType.Friend_List_Update,self,self.updateFriendList)
    if (self.listView) then
        self.listView:addEventListener(function(target,type)
            if(type==ccui.ListViewEventType.ONSELECTEDITEM_END)then
                print("select child index = %d",target:getCurSelectedIndex())
                if self._curIndex ~= target:getCurSelectedIndex() then
                    self._curIndex = target:getCurSelectedIndex()
                    self.curItem:setSelect(false)
                    self.curItem = self.listItem[self._curIndex+1]
                    self.curItem:setSelect(true)
                    
                     --self.curItem:removeFromParent()
                end
            end
        end)
    end

end

