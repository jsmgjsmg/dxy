EyeEffect = EyeEffect or class("EyeEffect",function()
    return cc.Node:create()
end)

function EyeEffect:ctor()
    self.winSize = cc.Director:getInstance():getVisibleSize()
    self.origin = cc.Director:getInstance():getVisibleOrigin()
    self._eyeEffect = {}
end

function EyeEffect:create()
    local node = EyeEffect:new()
    node:init()
    return node
end

function EyeEffect:init()
    self._csb = cc.CSLoader:createNode("res/dxyCocosStudio/csd/ui/yuanshen/EyeEffect.csb")
    self:addChild(self._csb)
    self._csb:setPosition(self.origin.x + self.winSize.width / 2, self.origin.y + self.winSize.height / 2)
    
    for i=1,6 do
        self._eyeEffect[i] = self._csb:getChildByName("eye"..i)
    end

    self._tl = cc.CSLoader:createTimeline("res/dxyCocosStudio/csd/ui/yuanshen/EyeEffect.csb") 
    self._csb:runAction(self._tl) 
    self._tl:gotoFrameAndPlay(0,true) 
end

function EyeEffect:changeEffect(num)
    for i=1,6 do
        if i == num then
            self._eyeEffect[i]:setVisible(true)
        else
            self._eyeEffect[i]:setVisible(false)
        end
    end
end
