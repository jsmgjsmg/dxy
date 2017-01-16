OneBtnTips = OneBtnTips or class("OneBtnTips",function()
    return cc.Node:create()
end)

function OneBtnTips:create()
    local node = OneBtnTips:new()

    UIManager:addUI(node, "OneBtnTips")
    SceneManager:getCurrentScene():addChild(node) 

    return node
end

function OneBtnTips:ctor()
    self._csb = nil

    self:initUI()

    self:initEvent()
end

function OneBtnTips:initUI()
    self._csb = cc.CSLoader:createNode("dxyCocosStudio/csd/ui/commonUI/OneBtnTips.csb")
    self:addChild(self._csb)

    self.visibleSize = cc.Director:getInstance():getVisibleSize()
    self.origin = cc.Director:getInstance():getVisibleOrigin()

    self:setPosition(cc.p(self.origin.x + self.visibleSize.width/2,self.origin.y + self.visibleSize.height/2))

    self.bg = self._csb:getChildByName("bg")

    self.btn = self.bg:getChildByName("Btn")

    self.text = self.bg:getChildByName("Text")

end

function OneBtnTips:initEvent()
    -- 拦截
    dxySwallowTouches(self)
end

function OneBtnTips:WhenClose()
    self:removeFromParent()
end

function OneBtnTips:update(text,btntxt,fun)
    self.text:setString(text)
    self.btn:setTitleText(btntxt)    

    self.btn:addTouchEventListener(fun)
end