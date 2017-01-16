
FriendAddPage = FriendAddPage or class("FriendAddPage",function()
    return cc.Layer:create()
end)

function FriendAddPage.create()
    local layer = FriendAddPage.new()
    return layer
end

function FriendAddPage:ctor()
    self._csbNode = nil
    self._curIndex = 0

    require("game.friend.view.FriendListItem")

    dxyExtendEvent(self)
    self:initUI()
    --self:initEvent()  
end

function FriendAddPage:initUI()
    self._csbNode = cc.CSLoader:getInstance():createNodeWithFlatBuffersFile("dxyCocosStudio/csd/ui/friend/FriendApplyPage.csb")
    self:addChild(self._csbNode)

    local node = self._csbNode:getChildByName("Panel")
    self.btn_Add = node:getChildByName("Button")
    self.bth_Search = node:getChildByName("InputBG"):getChildByName("Button")
    self.listView = node:getChildByName("ListView")
    self.input_Name = node:getChildByName("InputBG"):getChildByName("TextField")
    self.textCount = node:getChildByName("Text")

    self:updateFriendList()
end

function FriendAddPage:updateFriendList()

    self.listView:removeAllChildren()
    local list = zzm.FriendModel:getFriendDataByType(FRIEND_LIST_TYPE.SearchList)
    local count = 0
    self.listItem = {}
    for key, var in pairs(list) do
        count = count + 1
        local item = FriendListItem.create(FRIEND_PANEL_TYPE.AddLayer)
        item:updateAddItem(var)
        self.listView:pushBackCustomItem(item) --pushBackCustomItem
        self.listItem[count] = item
    end
    self.textCount:setString("搜索到"..count.."个结果")
    self._curIndex = 0
    self.curItem = self.listItem[self._curIndex+1]
    if self.curItem then
        self.curItem:setSelect(true)
    end
end


function FriendAddPage:removeEvent()
    dxyDispatcher_removeEventListener(dxyEventType.Friend_List_Update,self,self.updateFriendList)
end

function FriendAddPage:initEvent()
    dxyDispatcher_addEventListener(dxyEventType.Friend_List_Update,self,self.updateFriendList)
    
    if(self.btn_Add)then
        self.btn_Add:addTouchEventListener(function(target,type)
            if(type==2)then
                if self.curItem and self.curItem.m_data then
                    zzc.FriendController:request_AddFriend(self.curItem.m_data.uid)
                    self.listView:removeAllChildren()
                else
                    TipsFrame:create("请先输入名字，输入框右侧搜索按钮！然后选中一个玩家。")
                end
            end
        end)
    end
    
    if(self.bth_Search)then
        self.bth_Search:addTouchEventListener(function(target,type)
            if(type==2)then
                local data = {}
                local name = self.input_Name:getString()
                if name == nil or name == "" then
                    TipsFrame:create("账号不能为空！")
                    return
                end
                zzc.FriendController:request_SearchFriend(name)
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

