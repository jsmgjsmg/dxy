
FriendListPage = FriendListPage or class("FriendListPage",function()
    return cc.Layer:create()
end)

function FriendListPage.create()
    local layer = FriendListPage.new()
    return layer
end

function FriendListPage:ctor()
    self._csbNode = nil
    self._curIndex = 0

--    require("game.login.view.OneServerItem")
    require("game.friend.view.FriendListItem")

    self:initUI()
    self:initEvent()
end

function FriendListPage:initUI()
    self._csbNode = cc.CSLoader:getInstance():createNodeWithFlatBuffersFile("dxyCocosStudio/csd/ui/friend/FriendListPage.csb")
    self:addChild(self._csbNode)
    
    local node = self._csbNode:getChildByName("Panel")
    self.btn_OneKey = node:getChildByName("Button")
    self.listView = node:getChildByName("ListView")

    local count = 10--zzc.LoginController:getServerGroup()
    for index=count,1,-1 do
        local item = FriendListItem.create()
        self.listView:pushBackCustomItem(item) --pushBackCustomItem
    end

end

function FriendListPage:initEvent()
    if(self.btn_OneKey)then
        self.btn_OneKey:addTouchEventListener(function(target,type)
            if(type==2)then
                --self:requestSever(zzc.LoginController:getLastServer())
            end
        end)
    end

    if (self.listView) then
        self.listView:addEventListener(function(target,type)
            if(type==ccui.ListViewEventType.ONSELECTEDITEM_END)then
                print("select child index = %d",target:getCurSelectedIndex())
                if self._curIndex ~= target:getCurSelectedIndex() then
                    self._curIndex = target:getCurSelectedIndex()
--                    local dataList = zzc.LoginController:getSelectServer(self._curIndex)
--                    self:updateSelectServer(dataList)
                end
            end
        end)
    end

end

