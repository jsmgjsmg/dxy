ChatMsgTips = ChatMsgTips or class("ChatMsgTips",function()
	return cc.Node:create()
end)

function ChatMsgTips:ctor()
    self._csb = nil
	self:initUI()
end

function ChatMsgTips:initUI()
	self._csb = cc.CSLoader:createNode("dxyCocosStudio/csd/ui/chat/ChatMsgTips.csb")
	self:addChild(self._csb)
	
	self.visibleSize = cc.Director:getInstance():getVisibleSize()
    self.origin = cc.Director:getInstance():getVisibleOrigin()
    
    self.txt = self._csb:getChildByName("txt")
    
end

function ChatMsgTips:show(msg)
    if not msg then return end
    local msgTips = ChatMsgTips.new()
    msgTips:init(msg)
    SceneManager:getCurrentScene():addChild(msgTips) 
end

function ChatMsgTips:init(msg)
	self.txt:setString(msg)
	
    local posX = self.origin.x + self.visibleSize.width/2
    local posYS = self.origin.y + self.visibleSize.height/2
    
    self:setPosition(posX, posYS)
    
    local action1 = cc.EaseSineOut:create(cc.FadeOut:create(1))
    local action2 = cc.CallFunc:create(function() self:removeFromParent() end)
    local sequence = cc.Sequence:create(action1, action2)
    self:runAction(sequence)
end