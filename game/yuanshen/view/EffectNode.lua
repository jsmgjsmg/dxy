EffectNode = EffectNode or class("EffectNode",function()
    return cc.Node:create()
end)

function EffectNode:ctor()
    self.winSize = cc.Director:getInstance():getVisibleSize()
    self.origin = cc.Director:getInstance():getVisibleOrigin()
    self._EffectBall = {}
    self._arrTurnAngle = {
        [1] = 30,
        [2] = -4,
        [3] = -38,
        [4] = -72,
        [5] = -106,
        [6] = -140,
    }
    self:init()
end

function EffectNode:init()
    self._csb = cc.CSLoader:createNode("res/dxyCocosStudio/csd/ui/yuanshen/EffectNode.csb")
    self:addChild(self._csb)
    self._csb:setPosition(self.origin.x + self.winSize.width / 2, self.origin.y + self.winSize.height / 2)
    
    self._tl = cc.CSLoader:createTimeline("res/dxyCocosStudio/csd/ui/yuanshen/EffectNode.csb") 
    self._csb:runAction(self._tl) 
    self._tl:gotoFrameAndPlay(0,false)
    
    local ndEffect = self._csb:getChildByName("ndEffect")
    for i=1,6 do
        self._EffectBall[i] = ndEffect:getChildByName("effect"..i)
    end
    
    self._ndLineEffect = self._csb:getChildByName("ndLineEffect")
    self._lineEffect = self._ndLineEffect:getChildByName("lineEffect")
end

function EffectNode:PlayEffect(data)

    local node = EffectNode:new()
    SceneManager:getCurrentScene():addChild(node) 

    local config = YuanShenConfig:getDataByLv(data["Lv"])
    for i=1,6 do
        if i == config.Effect then
            node._EffectBall[i]:setVisible(true)
        else
            node._EffectBall[i]:setVisible(false)
        end
    end

    node:TurnLineEffect()

    self._myTimer = self._myTimer or require("game.utils.MyTimer").new()
    local function tick()
        self._myTimer:stop()
        self._myTimer = nil
        node:removeFromParent()
    end
    self._myTimer:start(1,tick)
end

function EffectNode:TurnLineEffect()
    local rand = math.random(1,6)
    self._ndLineEffect:setRotation(self._arrTurnAngle[rand])
end