PackageChangeLayer = PackageChangeLayer or class("PackageChangeLayer",function()
    return cc.Node:create()
end)

function PackageChangeLayer:ctor()
--    self.visibleSize = cc.Director:getInstance():getVisibleSize()
--    self.origin = cc.Director:getInstance():getVisibleOrigin()
	self:initNode()
	
end

function PackageChangeLayer:initNode()
    self._csb = cc.CSLoader:createNode("dxyCocosStudio/csd/ui/activity/GetGiftBag.csb")
    self:addChild(self._csb)
--    self._csb:setPosition(self.origin.x + self.visibleSize.width / 2, self.origin.y + self.visibleSize.height / 2)
    
    local giftBag = self._csb:getChildByName("giftBag")
    self.btn_sure = giftBag:getChildByName("btn_sure")
    --self.btn_cancel = self._csb:getChildByName("btn_cancel")
    self.inputCdkey = giftBag:getChildByName("inputCdkey")
    self.cdkeyText = self.inputCdkey:getChildByName("cdkeyText")
    
    --dxySwallowTouches(self)
    self.btn_sure:addTouchEventListener(function(target,type)
    	   if type == 2 then
    	   	  local cdkey = self.cdkeyText:getString()
    	   	  if cdkey == nil or cdkey ==""  then
    	   	  	dxyFloatMsg:show("请输入兑换码")
    	   	  	return
    	   	  else
                zzc.ActivityController:sendCdkey(cdkey)
--                self:removeFromParent()
    	   	  end
    	   	  
    	   	  
    	   end
    	end)
    	
end

function PackageChangeLayer:update()

end