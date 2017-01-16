CustomTips = CustomTips or class("CustomTips",function()
	return cc.Node:create()
end)

function CustomTips:create()
    local node = CustomTips:new()

    UIManager:addUI(node, "CustomTips")
    SceneManager:getCurrentScene():addChild(node) 
    
    return node
end

function CustomTips:ctor()
    self._csb = nil

    self:initUI()

    self:initEvent()
end

function CustomTips:initUI()
    self._csb = cc.CSLoader:createNode("dxyCocosStudio/csd/ui/commonUI/customTips.csb")
    self:addChild(self._csb)

    self.visibleSize = cc.Director:getInstance():getVisibleSize()
    self.origin = cc.Director:getInstance():getVisibleOrigin()

    self:setPosition(cc.p(self.origin.x + self.visibleSize.width/2,self.origin.y + self.visibleSize.height/2))

    self.bg = self._csb:getChildByName("bg")

    self.btn_ok = self.bg:getChildByName("okBtn")

    self.btn_cancel = self.bg:getChildByName("cancelBtn")

    self.text = self.bg:getChildByName("Text")

end

function CustomTips:initEvent()
    self.btn_cancel:addTouchEventListener(function(target,type)
        if type == 2 then
            SoundsFunc_playSounds(SoundsType.CLOSE_PAGE,false)
            UIManager:closeUI("CustomTips")
        end
    end)

    -- 拦截
    dxySwallowTouches(self)
end

function CustomTips:WhenClose()
    self:removeFromParent()
end

function CustomTips:update(text,fun)
	self.text:setString(text)
	
	self.btn_ok:addTouchEventListener(fun)
end