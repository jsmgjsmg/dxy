EquipSwallowEffect = EquipSwallowEffect or class("EquipSwallowEffect",function()
    return cc.Node:create()
end)

function EquipSwallowEffect:ctor()
    self.winSize = cc.Director:getInstance():getVisibleSize()
    self.origin = cc.Director:getInstance():getVisibleOrigin()
end

function EquipSwallowEffect:create()
    local node = EquipSwallowEffect:new()
    node:init()
    return node
end

function EquipSwallowEffect:init()
    SoundsFunc_playSounds(SoundsType.UCCEED,false)

    self._csb = cc.CSLoader:createNode("dxyCocosStudio/csd/ui/equip/equipSwallowEffect.csb")
    self:addChild(self._csb)
    self._csb:setPosition(self.origin.x + self.winSize.width / 2, self.origin.y + self.winSize.height / 2)

    self._tl = cc.CSLoader:createTimeline("dxyCocosStudio/csd/ui/equip/equipSwallowEffect.csb") 
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