Fragment = Fragment or class("Fragment",function()
    return cc.Node:create()
end)
local HEIGHT = 97
local WIDTH = 97
local ROW = 12  

function Fragment:ctor()
    self.visibleSize = cc.Director:getInstance():getVisibleSize()
    self.origin = cc.Director:getInstance():getVisibleOrigin()
    self._arrBoxItem = {}
end

function Fragment:create()
    local node = Fragment:new()
    node:init()
    return node
end

function Fragment:init()
    self._csb = cc.CSLoader:createNode("res/dxyCocosStudio/csd/ui/general/Fragment.csb")
    self:addChild(self._csb)
    self._csb:setPosition(self.origin.x + self.visibleSize.width / 2, self.origin.y + self.visibleSize.height / 2)
    
    dxyExtendEvent(self)
    
    local _btnChange = self._csb:getChildByName("btn_change")
    _btnChange:addTouchEventListener(function(target,type)
        if type == 2 then
            self._parent:Back()
        end
    end)
    
    self._sv = self._csb:getChildByName("ScrollView")
    local width = self._sv:getContentSize().width
    local svHeight = ROW * HEIGHT
    self._sv:setInnerContainerSize(cc.size(width,svHeight))
    local posx = 0
    local posy = 0
    local count = 0
    for i=1,12 do --列
        posy = (i-1) * HEIGHT + 50
        for j=1,4 do --行
            posx = (j-1) * WIDTH + 50
            require "src.game.general.view.ItemBox"
            count = count + 1
            local data = {[1]=self._sv,[2]=posx,[3]=svHeight-posy,[4]=2}
            self._arrBoxItem[count] = ItemBox:create(data)
            self._arrBoxItem[count]:upDate(zzm.GeneralModel.Fragment[count])
            self._sv:addChild(self._arrBoxItem[count],1)
            self._arrBoxItem[count]:setPosition(posx,svHeight - posy)
        end
    end
    
    local _btnDestroy = self._csb:getChildByName("btn_destroy")
    _btnDestroy:addTouchEventListener(function(target,type)
        if type == 2 then
            require "src.game.general.view.DestroyMore"
            local more = DestroyMore:create(2)
            self:addChild(more)
        end
    end)
end

function Fragment:initEvent()
    dxyDispatcher_addEventListener("addFragment",self,self.addFragment)
    dxyDispatcher_addEventListener("delFragment",self,self.delFragment)
    dxyDispatcher_addEventListener("changeFragment",self,self.changeFragment)
end

function Fragment:removeEvent()
    dxyDispatcher_removeEventListener("addFragment",self,self.addFragment)
    dxyDispatcher_removeEventListener("delFragment",self,self.delFragment)
    dxyDispatcher_removeEventListener("changeFragment",self,self.changeFragment)
end

function Fragment:addFragment(data)
    for i,target in pairs(self._arrBoxItem) do
        if target._data == nil then
            target:upDate(data)
            break
        end
    end
end

function Fragment:delFragment(id)
    for i,target in pairs(self._arrBoxItem) do
        if target._data and target._data.Id == id then
            target:upDate()
            break
        end
    end
end

function Fragment:changeFragment(data)
    for i,target in pairs(self._arrBoxItem) do
        if data["Id"] == target._data["Id"] then
            target:upDate(data)
            break
        end
    end
end

function Fragment:setParentFunc(parent)
    self._parent = parent
end