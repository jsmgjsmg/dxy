local DoubleCheck = class("DoubleCheck",function()
    return cc.Node:create()
end)

function DoubleCheck:ctor()
    self.visibleSize = cc.Director:getInstance():getVisibleSize()
    self.origin = cc.Director:getInstance():getVisibleOrigin()
end

function DoubleCheck:create()
    local node = DoubleCheck:new()
    node:init()
    return node
end

function DoubleCheck:init()
    self._csb = cc.CSLoader:createNode("res/dxyCocosStudio/csd/ui/setup/DoubleCheck.csb")
    self:addChild(self._csb)
    self._csb:setPosition(self.origin.x + self.visibleSize.width / 2, self.origin.y + self.visibleSize.height / 2)

    -- 拦截
    dxySwallowTouches(self)

    local btnSure = self._csb:getChildByName("btnSure")
    btnSure:addTouchEventListener(function(target,type)
        if type == 2 then
            SoundsFunc_playSounds(SoundsType.CLOSE_PAGE,false)
            if _G._isLocal then
                os.exit()
            else               
                SDKManagerLua.instance():exit()
                self:removeFromParent()
            end
        end
    end)
    
    local btnCancel = self._csb:getChildByName("btnCancel")
    btnCancel:addTouchEventListener(function(target,type)
        if type == 2 then
            SoundsFunc_playSounds(SoundsType.CLOSE_PAGE,false)
            self:removeFromParent()
        end
    end)

end

return DoubleCheck
