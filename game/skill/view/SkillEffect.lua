SkillEffect = SkillEffect or class("SkillEffect",function()
    return cc.Node:create()
end)

function SkillEffect:ctor()
    self.winSize = cc.Director:getInstance():getVisibleSize()
    self.origin = cc.Director:getInstance():getVisibleOrigin()
end

function SkillEffect:create()
    local node = SkillEffect:new()
    node:init()
    return node
end

function SkillEffect:init()
    self._csb = cc.CSLoader:createNode("dxyCocosStudio/csd/ui/skill/SkillEffect.csb")
    self:addChild(self._csb)

    self._tl = cc.CSLoader:createTimeline("dxyCocosStudio/csd/ui/skill/SkillEffect.csb") 
    self._csb:runAction(self._tl) 

    if not self._tl:isPlaying() then
        self._tl:gotoFrameAndPlay(0,false)
    end

    self._myTimer = self._myTimer or require("game.utils.MyTimer").new()
    local function tick()
        SwallowAllTouches:close()
        self._myTimer:stop()
        self:removeFromParent()
    end
    SwallowAllTouches:show()
    self._myTimer:start(0.9, tick)

end