PowerRaiseEffect = PowerRaiseEffect or class("PowerRaiseEffect",function()
    return cc.Node:create()
end)

function PowerRaiseEffect:ctor()
    self.winSize = cc.Director:getInstance():getVisibleSize()
    self.origin = cc.Director:getInstance():getVisibleOrigin()
end

function PowerRaiseEffect:create(power)
    local node = PowerRaiseEffect:new()
    node:init(power)
    return node
end

function PowerRaiseEffect:init(power)
    self._csb = cc.CSLoader:createNode("dxyCocosStudio/csd/ui/PowerRaiseEffect.csb")
    self:addChild(self._csb)
    self._csb:setPosition(self.origin.x + self.winSize.width / 2, self.origin.y + self.winSize.height / 2)

    self.bmf_power = self._csb:getChildByName("zi"):getChildByName("powerBmf")
    self.bmf_power:setString(power)

    self._tl = cc.CSLoader:createTimeline("dxyCocosStudio/csd/ui/PowerRaiseEffect.csb") 
    self._csb:runAction(self._tl) 

    if not self._tl:isPlaying() then
        self._tl:gotoFrameAndPlay(0,false)
    end

    self._myTimer = self._myTimer or require("game.utils.MyTimer").new()
    local function tick()
        self._myTimer:stop()
        self:removeFromParent()
    end
    self._myTimer:start(1, tick)

end