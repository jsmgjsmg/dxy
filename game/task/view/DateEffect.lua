local DateEffect = class("DateEffect",function()
    return cc.Node:create()
end)

function DateEffect:ctor()

end

function DateEffect:create()
    local node = DateEffect:new()
    node:init()
    return node
end

function DateEffect:init()
    self._csb = cc.CSLoader:createNode("res/dxyCocosStudio/csd/ui/task/DateEffect.csb")
    self:addChild(self._csb)
    
    self._tl = cc.CSLoader:createTimeline("res/dxyCocosStudio/csd/ui/task/DateEffect.csb")
    self._csb:runAction(self._tl)
    self._tl:gotoFrameAndPlay(0,true)
end

return DateEffect