JoinFairyTips = JoinFairyTips or class("JoinFairyTips",function()
	return cc.Layer:create()
end)

function JoinFairyTips:crete()
    local layer = JoinFairyTips:new()
    return layer
end

function JoinFairyTips:ctor()
    
    self._csb = nil
    
    self.txt_power = nil
    self.txt_declaration = nil
    self.btn_join = ccui.Button
    
	self:initUI()
	self:initEvent()
end

function JoinFairyTips:initUI()
	self._csb = cc.CSLoader:createNode("dxyCocosStudio/csd/ui/chat/JoinFairyTips.csb")
	self:addChild(self._csb)
	
    self.visibleSize = cc.Director:getInstance():getVisibleSize()
    self.origin = cc.Director:getInstance():getVisibleOrigin()

    local posX = self.origin.x + self.visibleSize.width/2
    local posY = self.origin.y + self.visibleSize.height/2

    self:setPosition(posX, posY)
	
	self.btn_join = self._csb:getChildByName("joinBtn")
	
	local node = self._csb:getChildByName("node")
	self.txt_power = node:getChildByName("powerTxt")
    self.txt_declaration = node:getChildByName("declarationTxt")
	
end

function JoinFairyTips:initEvent()

    local bg = self._csb:getChildByName("bg")
    -- 拦截
    dxySwallowTouches(self,bg)

	if self.btn_join then
		self.btn_join:addTouchEventListener(function(target,type)
		  if type == 2 then
		  	
		  end
		end)
	end
end

function JoinFairyTips:update(data)
	
end