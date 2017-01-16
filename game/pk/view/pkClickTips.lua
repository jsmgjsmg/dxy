pkClickTips = pkClickTips or class("pkClickTips",function()
	return cc.Layer:create()
end)

function pkClickTips:create()
    local layer = pkClickTips:new()
    return layer
end

function pkClickTips:ctor()
	self._csb = nil
	
    self.visibleSize = cc.Director:getInstance():getVisibleSize()
    self.origin = cc.Director:getInstance():getVisibleOrigin()
	
	self:initUI()
	self:initEvent()
end

function pkClickTips:initUI()
	self._csb = cc.CSLoader:createNode("dxyCocosStudio/csd/ui/pk/pkClickTips.csb")
	self:addChild(self._csb)
	
    self._csb:setPosition(self.origin.x + self.visibleSize.width / 2, self.origin.y + self.visibleSize.height / 2)
	
	self.bg = self._csb:getChildByName("bg")
	self.name = self.bg:getChildByName("name")
	self.btn_view = self.bg:getChildByName("viewInfoBtn")
	self.btn_add = self.bg:getChildByName("addBtn")
	
end

function pkClickTips:initEvent()

    self.btn_view:addTouchEventListener(function(target,type)
        if type == 2 then
            _G.RankData.Uid = self.m_data.Uid
            zzc.RoleinfoController:showLayer()
            self:removeFromParent()
        end
    end)
    
    self.btn_add:addTouchEventListener(function(target,type)
        if type == 2 then
            zzc.FriendController:request_AddFriend(self.m_data.Uid)
            dxyFloatMsg:show("已发送请求")
            self:removeFromParent()
        end
    end)
    
    -- 拦截
    dxySwallowTouches(self,self.bg)
end

function pkClickTips:update(data)
	self.m_data = data
	
	if not self.m_data then
		return 
	end
	
	self.name:setString(self.m_data.Name)
end
