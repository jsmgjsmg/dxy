TipsCrit = TipsCrit or class("TipsCrit",function()
    return cc.Node:create()
end)

function TipsCrit:ctor()
    self.visibleSize = cc.Director:getInstance():getVisibleSize()
    self.origin = cc.Director:getInstance():getVisibleOrigin()
end

function TipsCrit:create()
    local node = TipsCrit:new()
    node:init()
    return node
end

function TipsCrit:init()
    self._csb = cc.CSLoader:createNode("dxyCocosStudio/csd/ui/yuanshen/TipsCrit.csb")
    self:addChild(self._csb)
    self._csb:setPosition(self.origin.x + self.visibleSize.width / 2, self.origin.y + self.visibleSize.height / 2)

    local tl = cc.CSLoader:createTimeline("dxyCocosStudio/csd/ui/yuanshen/TipsCrit.csb")
    tl:gotoFrameAndPlay(0,false)
    self._csb:runAction(tl) 
    
    self._myTimer = self._myTimer == nil and require("game.utils.MyTimer").new() or self._myTimer
    local function tick()
        self._myTimer:stop()
        self:removeFromParent()
    end
    self._myTimer:start(1.5, tick)

end