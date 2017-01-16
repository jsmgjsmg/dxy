SwallowAllTouches = SwallowAllTouches or class("SwallowAllTouches",function()
    return cc.Node:create()
end)
SwallowAllTouchesList = {}

function SwallowAllTouches:ctor()
    self.visibleSize = cc.Director:getInstance():getVisibleSize()
    self.origin = cc.Director:getInstance():getVisibleOrigin()
    self:init()
end

function SwallowAllTouches:init()
    self._csb = cc.CSLoader:createNode("dxyCocosStudio/csd/ui/commonUI/SwallowAllTouches.csb")
    self:addChild(self._csb)
    
    self._csb:setPosition(self.origin.x + self.visibleSize.width / 2, self.origin.y + self.visibleSize.height / 2)
    
    self._btn = self._csb:getChildByName("Button")
    self._btn:addTouchEventListener(function(target,type) 
        if type == 2 then
            self:BtnCallBack()
        end
    end)
    
    dxySwallowTouches(self)
end

function SwallowAllTouches:show(state1,state2,target,key)
    if self._node then
        self:close()
    end
    self._node = SwallowAllTouches.new()
    self._key = key
    self._node:update(state1,state2,target)
    SceneManager:getCurrentScene():addChild(self._node)
end

function SwallowAllTouches:update(state1,state2,target)
    if state1 then
        self._btn:loadTextureNormal(state1)
        self._btn:loadTexturePressed(state2)

        local worldPos = target:convertToWorldSpace(cc.p(0,0))
        local pt = self._btn:convertToNodeSpace(worldPos)
        self._btn:setPosition(pt.x,pt.y)

        self._btn:setVisible(true)
    else
        self._btn:setVisible(false)
    end
end

function SwallowAllTouches:close()
    if self._node then
        self._node:removeFromParent()
        self._node = nil
        print("SwallowAllTouches close.........")
    end
end

function SwallowAllTouches:BtnCallBack()
    dxyDispatcher_dispatchEvent(self._key)
end

