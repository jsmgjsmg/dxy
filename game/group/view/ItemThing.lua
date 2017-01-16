ItemThing = ItemThing or class("ItemThing",function()
    return cc.Node:create()
end)

function ItemThing:ctor()

end

function ItemThing:create(data)
    local node = ItemThing:new()
    node:init(data)
    return node
end

function ItemThing:init(data)
    self._csb = cc.CSLoader:createNode("res/dxyCocosStudio/csd/ui/group/ItemThing.csb")
    self:addChild(self._csb)
    
    local txt = cn:cgThing(data)
    local thing = self._csb:getChildByName("thing")
    thing:setString(txt)
end