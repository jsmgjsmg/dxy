ItemPrayLog = ItemPrayLog or class("ItemPrayLog",function()
    return cc.Node:create()
end)

function ItemPrayLog:ctor()

end

function ItemPrayLog:create()
    local node = ItemPrayLog.new()
    node:init()
    return node
end

function ItemPrayLog:init()
    self._csb = cc.CSLoader:createNode("dxyCocosStudio/csd/ui/groupfunc/ItemLog.csb")
    self:addChild(self._csb)
    
    self._txtName = self._csb:getChildByName("txtName")
    self._txtNum = self._csb:getChildByName("txtNum")
end

function ItemPrayLog:update(data)
    self._txtName:setString(data.Name)
    self._txtNum:setString(data.Exp)
end