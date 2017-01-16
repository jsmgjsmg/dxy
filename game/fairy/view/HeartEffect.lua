HeartEffect = HeartEffect or class("HeartEffect",function()
    return cc.Node:create()
end)

function HeartEffect:ctor()

end

function HeartEffect:create()
    local node = HeartEffect:new()
    node:init()
    return node
end

function HeartEffect:init()
    self._csb = cc.CSLoader:createNode("dxyCocosStudio/csd/ui/fairy/HeartEffect.csb")
    self:addChild(self._csb)

    local timeLine = cc.CSLoader:createTimeline("dxyCocosStudio/csd/ui/fairy/HeartEffect.csb")
    self._csb:runAction(timeLine)
    timeLine:gotoFrameAndPlay(0,true)
end