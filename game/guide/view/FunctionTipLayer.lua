
FunctionTipsLayer = FunctionTipsLayer or class("FunctionTipsLayer",function()
    return cc.Layer:create()
end)

function FunctionTipsLayer.create()
    local layer = FunctionTipsLayer.new()
    return layer
end

function FunctionTipsLayer:ctor()
    self._csbNode = nil
    self:initUI()
    dxyExtendEvent(self)
end

function FunctionTipsLayer:initUI()
    self._csbNode = cc.CSLoader:getInstance():createNodeWithFlatBuffersFile("res/dxyCocosStudio/csd/ui/guide/FunctionTipsLayer.csb")
    self:addChild(self._csbNode)

    self.visibleSize = cc.Director:getInstance():getVisibleSize()
    self.origin = cc.Director:getInstance():getVisibleOrigin()

    local posX = self.origin.x + self.visibleSize.width/2
    local posY = self.origin.y + self.visibleSize.height/2

    self:setPosition(posX, posY)
    
    self.image = self._csbNode:getChildByName("Image")
    self.content = self._csbNode:getChildByName("Text_1")
    self.condition = self._csbNode:getChildByName("Text_2")
end

function FunctionTipsLayer:update(data)
    self.m_data = data
    if self.m_data then
        self.image:loadTexture(self.m_data.TipsPicture)
        self.content:setString(self.m_data.Text)
        self.condition:setString(self.m_data.TipsText)
    end
end

function FunctionTipsLayer:removeEvent()

end

function FunctionTipsLayer:initEvent()

    local bg = self._csbNode:getChildByName("BG")
    -- 拦截
    local function onTouchBegan(touch, event)

        return true
    end

    local function onTouchMoved(touch, event)

    end

    local function onTouchEnded(touch, event)
        local location = touch:getLocation()

        local point = bg:convertToNodeSpace(location)
        local rect = cc.rect(0,0,bg:getContentSize().width,bg:getContentSize().height)
        if cc.rectContainsPoint(rect,point) == false then
            self:removeFromParent()
        end

    end

    local listener = cc.EventListenerTouchOneByOne:create()
    listener:registerScriptHandler(onTouchBegan,cc.Handler.EVENT_TOUCH_BEGAN )
    listener:registerScriptHandler(onTouchMoved,cc.Handler.EVENT_TOUCH_MOVED )
    listener:registerScriptHandler(onTouchEnded,cc.Handler.EVENT_TOUCH_ENDED )
    local eventDispatcher = self:getEventDispatcher()
    eventDispatcher:addEventListenerWithSceneGraphPriority(listener, self)
    listener:setSwallowTouches(true)
end

function FunctionTipsLayer:backCallBack()
--    local accout = self.input_account:getString()
--    local password = self.input_password:getString()
--    local gameScene = LoadingController.new():getScene()
--    SceneManager:enterScene(gameScene, "LoadingScene")
end



