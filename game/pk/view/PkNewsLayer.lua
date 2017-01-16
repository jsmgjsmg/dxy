PkNewsLayer = PkNewsLayer or class("PkNewsLayer",function()
	return cc.Layer:create()
end)

function PkNewsLayer:create()
    local layer = PkNewsLayer:new()
    return layer
end

function PkNewsLayer:ctor()
	self._csb = nil
	
	self:initUI()
	self:initEvent()
	
end

function PkNewsLayer:initUI()
	self._csb = cc.CSLoader:createNode("dxyCocosStudio/csd/ui/pk/pkNewsLayer.csb")
	self:addChild(self._csb)
	
	self.btn_close = self._csb:getChildByName("closeBtn")
end

function PkNewsLayer:initEvent()
	self.btn_close:addTouchEventListener(function(target,type)
	   if type == 2 then
            SoundsFunc_playSounds(SoundsType.CLOSE_PAGE,false)
	   	   self:removeFromParent()
	   end
	end)
	
    -- 拦截
    dxySwallowTouches(self)
end