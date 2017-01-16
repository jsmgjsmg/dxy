
TipsFrame = TipsFrame or class("TipsFrame",function()
    return cc.Node:create()
end)

function TipsFrame:ctor()
    
end

function TipsFrame:init(msg)

    local tips = cc.CSLoader:createNode("dxyCocosStudio/csd/ui/common/TipsFrame.csb")
    SceneManager:getCurrentScene():addChild(self) 
    self:addChild(tips)
    
    local act = cc.CSLoader:createTimeline("dxyCocosStudio/csd/ui/common/TipsFrame.csb")
    tips:runAction(act)
    act:gotoFrameAndPlay(0,false)
    
    self.visibleSize = cc.Director:getInstance():getVisibleSize()
    self.origin = cc.Director:getInstance():getVisibleOrigin()
    
    self:setPosition(self.origin.x + self.visibleSize.width/2 , self.origin.y + self.visibleSize.height/2)
    
    local closeBtn = tips:getChildByName("bg"):getChildByName("closeBtn")
    
    local text = tips:getChildByName("bg"):getChildByName("text")
    
    local function closeBtnTouchCallback(sender,eventType) --关闭按钮
        if eventType == ccui.TouchEventType.began then
        
        elseif eventType == ccui.TouchEventType.moved then
            
        elseif eventType == ccui.TouchEventType.ended then
            SoundsFunc_playSounds(SoundsType.CLOSE_PAGE,false)
            UIManager:closeTipsFrame(self:getTag())
            self:removeFromParent()
        elseif eventType == ccui.TouchEventType.canceled then
            
        end
    end

    closeBtn:addTouchEventListener(closeBtnTouchCallback)
    
--    local content = cc.Label:createWithSystemFont("","Trebuchet MS",26)
--    --content:setDimensions(430,content:getDimensions().height) --宽高
--    content:setDimensions(430,0) --宽高
--    content:setAlignment(0) --对齐方式
--    content:setAnchorPoint(0,1) --锚点
--    content:setString(msg)
--    content:setPosition(-212,64)
--    tips:addChild(content)
    text:setString(msg)
    
    
    local bg = tips:getChildByName("bg")
    -- 拦截
    dxySwallowTouches(self,bg)
end

function TipsFrame:create(msg)
    
    local Tips = TipsFrame.new()
    Tips:init(msg)
    return Tips
    
end