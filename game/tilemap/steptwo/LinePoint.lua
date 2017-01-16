LinePoint = LinePoint or class("LinePoint",function()
    return cc.Node:create()
end)

function LinePoint:ctor()

end

function LinePoint:create()
    local node = LinePoint:new()
    node:init()
    return node
end

function LinePoint:init()
    self._linePoint = cc.CSLoader:createNode("dxyCocosStudio/csd/ui/tilemap_test/LinePoint.csb")
    self._pointImage = self._linePoint:getChildByName("Image")

    self:addChild(self._linePoint)
end

function LinePoint:update(pos)
    self.m_pos = pos
    local layerPos = CMap:layerCoordForPosition(pos)
    self:setPosition(layerPos.x,layerPos.y)
end