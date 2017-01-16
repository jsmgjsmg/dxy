MyClippingNode = MyClippingNode or class("MyClippingNode")

function MyClippingNode:create()
    local clippingNode = MyClippingNode:new()
    return clippingNode
end

function MyClippingNode:ctor()
    self._stencil = nil
    self._clippingNode = nil
    self._img = nil
    self._size = nil
    self._px = 0
    self._py = 0
end

function MyClippingNode:init(path,px,py,_self)

    self._px = px
    self._py = py

    --create stencil
    self._stencil = cc.Sprite:create(tostring(path))
    self._stencil:setAnchorPoint(cc.p(0,0))

    self._size = self._stencil:getContentSize()

    --create clippingNode
    self._clippingNode = cc.ClippingNode:create()
    self._clippingNode:setAnchorPoint(cc.p(0,0))
    self._clippingNode:setAlphaThreshold(0)
    self._clippingNode:setPosition(self._px,self._py)
    self._clippingNode:setStencil(self._stencil)
    self._clippingNode:setInverted(false)
    _self:addChild(self._clippingNode)

    --create showImg
    self._img = cc.Sprite:create(tostring(path))
    self._img:setAnchorPoint(cc.p(0,0))
    self._clippingNode:addChild(self._img)

end

function MyClippingNode:setPercentage(percentage)-- percentage范围0-1
    local _integer,_decimal = math.modf(percentage)

    local newPoX = self._px - self._size.width * (1-_decimal)
    self._stencil:setPosition(newPoX,self._py)
end