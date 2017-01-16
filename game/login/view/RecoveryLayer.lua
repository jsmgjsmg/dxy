RecoveryLayer = RecoveryLayer or class("RecoveryLayer",function()
    return cc.Node:create()
end)

function RecoveryLayer:ctor()
    self.visibleSize = cc.Director:getInstance():getVisibleSize()
    self.origin = cc.Director:getInstance():getVisibleOrigin()
end

function RecoveryLayer:create(data)
    local node = RecoveryLayer:new()
    node:init(data)
    return node
end

function RecoveryLayer:init(data)
    self._csb = cc.CSLoader:createNode("dxyCocosStudio/csd/ui/login/RecoveryLayer.csb")
    self:addChild(self._csb)
--    self._csb:setPosition(self.origin.x + self.visibleSize.width / 2, self.origin.y + self.visibleSize.height / 2)

    -- 拦截
    dxySwallowTouches(self)
    
    local Rec = self._csb:getChildByName("RecoveryRole")
    local btnSure = Rec:getChildByName("Sure")
    local btnCancel = Rec:getChildByName("Cancle")
    btnSure:addTouchEventListener(function(target,type)
        if type == 2 then
            SoundsFunc_playSounds(SoundsType.OPEN_PAGE,false)
            zzc.LoginController:delRole(data.uid,1)
            self:removeFromParent()
        end
    end)
    btnCancel:addTouchEventListener(function(target,type)
        if type == 2 then
            SoundsFunc_playSounds(SoundsType.CLOSE_PAGE,false)
            self:removeFromParent()
        end
    end)
end