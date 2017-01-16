local GroupThing = GroupThing or class("GroupThing",function()
    return cc.Node:create()
end)
local HEIGHT = 35

function GroupThing:ctor()
    self.visibleSize = cc.Director:getInstance():getVisibleSize()
    self.origin = cc.Director:getInstance():getVisibleOrigin()
    self._arrThing = {}
end

function GroupThing:create()
    local node = GroupThing:new()
    node:init()
    return node
end

function GroupThing:init()
    self._csb = cc.CSLoader:createNode("dxyCocosStudio/csd/ui/group/GroupThing.csb")
    self:addChild(self._csb)
    self._csb:setPosition(self.origin.x + self.visibleSize.width / 2, self.origin.y + self.visibleSize.height / 2)
    
    dxyExtendEvent(self)
    
    self._sv = self._csb:getChildByName("ScrollView")
    self._sv:setScrollBarEnabled(false)
    local ThingData = zzm.GroupModel.ThingData
    local len = #ThingData
    for i=1,len do
        self:addThing(ThingData[i])
    end
end

function GroupThing:initEvent()
    dxyDispatcher_addEventListener("addThing",self,self.addThing)
end

function GroupThing:removeEvent()
    dxyDispatcher_removeEventListener("addThing",self,self.addThing)
end

function GroupThing:addThing(data)
    require "src.game.group.view.ItemThing"
    local thing = ItemThing:create(data)
    table.insert(self._arrThing,thing)
    self._sv:addChild(thing)
    self:setPos()
end

function GroupThing:setPos()
    local len = #self._arrThing
    local content = self._sv:getContentSize()
    local real = len * HEIGHT
    local last = content.height > real and content.height or real
    self._sv:setInnerContainerSize(cc.size(content.width,last))
    for i=1,len do
        self._arrThing[i]:setPosition(0,last-(i-1)*HEIGHT)
    end
end

return GroupThing