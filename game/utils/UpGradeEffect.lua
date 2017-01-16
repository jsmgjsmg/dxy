UpGradeEffect = UpGradeEffect or class("UpGradeEffect",function()
    return cc.Node:create()
end)

function UpGradeEffect:ctor()
    self.winSize = cc.Director:getInstance():getVisibleSize()
    self.origin = cc.Director:getInstance():getVisibleOrigin()
end

function UpGradeEffect:create()
    local node = UpGradeEffect:new()
    node:init()
    return node
end

function UpGradeEffect:init()
    self._csb = cc.CSLoader:createNode("res/dxyCocosStudio/csd/ui/UpGradeEffect.csb")
    self:addChild(self._csb)
    self._csb:setPosition(self.origin.x + self.winSize.width / 2, self.origin.y + self.winSize.height / 2)

    self._tl = cc.CSLoader:createTimeline("res/dxyCocosStudio/csd/ui/UpGradeEffect.csb") 
    self._csb:runAction(self._tl) 
    
    if not self._tl:isPlaying() then
        self._tl:gotoFrameAndPlay(0,false)
    end
    
    local role = zzm.CharacterModel:getCharacterData()
    local enCAT = enCharacterAttrType
    local pro = role:getValueByType(enCAT.PRO)
    
    local spHead = self._csb:getChildByName("spHead")
    spHead:setTexture("res/HeroIcon/IconHkee_10"..pro..".png")
    
--    UPGRADE
    SoundsFunc_playSounds(SoundsType.UPGRADE,false)
    
    self._myTimer = self._myTimer or require("game.utils.MyTimer").new()
    local function tick()
		if self._myTimer then
			self._myTimer:stop()
			self:removeFromParent()
		end
    end
    self._myTimer:start(1.5, tick)
    
end

function UpGradeEffect:show()
    local node = UpGradeEffect:new()
    node:init()
    local scene = SceneManager:getCurrentScene()
    scene:addChild(node)
end