ChatClickTips = ChatClickTips or class("ChatCliskTips",function()
	return cc.Layer:create()
end)

function ChatClickTips:create()
	local layer = ChatClickTips:new()
	return layer
end

function ChatClickTips:ctor()
    
    self._csbNode = nil
    
    self.btn_seeMsg = ccui.Button
    self.btn_addFriend = ccui.Button
    self.btn_shield = ccui.Button
    
    self.name = nil
    
	self:initUI()
	self:initEvent()
end

function ChatClickTips:initUI()
	self._csbNode = cc.CSLoader:createNode("dxyCocosStudio/csd/ui/chat/ChatClickTips.csb")
	self:addChild(self._csbNode)
	
    self.btn_seeMsg = self._csbNode:getChildByName("seeMsgBtn")
    self.btn_addFriend = self._csbNode:getChildByName("addFriendBtn")
    self.btn_shield = self._csbNode:getChildByName("shieldBtn")

    self.name = self._csbNode:getChildByName("nameTxt")
    
    self.btn_seeMsg:setPressedActionEnabled(true)
    self.btn_addFriend:setPressedActionEnabled(true)
    self.btn_shield:setPressedActionEnabled(true)
	
end

function ChatClickTips:initEvent()
	
    local bg = self._csbNode:getChildByName("bg")
    -- 拦截
    dxySwallowTouches(self,bg)
    
    self.btn_seeMsg:addTouchEventListener(function(target,type)
        if type == 2 then
        	
        end
    end)
    
    self.btn_addFriend:addTouchEventListener(function(target,type)
        if type == 2 then
            
        end
    end)
    
    self.btn_shield:addTouchEventListener(function(target,type)
        if type == 2 then
            
        end
    end)
	
end

function ChatClickTips:update(data)
	
end