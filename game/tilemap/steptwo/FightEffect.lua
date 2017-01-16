FightEffect = FightEffect or class("FightEffect",function()
    return cc.Node:create()
end)

function FightEffect:ctor()
    self._data = nil
end

function FightEffect:create()
    local node = FightEffect:new()
    node:init()
    return node    
end

function FightEffect:init()
    self._csb = cc.CSLoader:createNode("dxyCocosStudio/csd/ui/tilemap_test/FightEffect.csb")
    self:addChild(self._csb)
    
    self._tl = cc.CSLoader:createTimeline("dxyCocosStudio/csd/ui/tilemap_test/FightEffect.csb")
    self._csb:runAction(self._tl)
    self._tl:gotoFrameAndPlay(0,true)
end

function FightEffect:update(pos)
    self._data = pos
    self:setPosition(pos.x,pos.y)
end
