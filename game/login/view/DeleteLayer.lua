DeleteLayer = DeleteLayer or class("DeleteLayer",function()
    return cc.Node:create()
end)

function DeleteLayer:ctor()
    self.visibleSize = cc.Director:getInstance():getVisibleSize()
    self.origin = cc.Director:getInstance():getVisibleOrigin()
end

function DeleteLayer:create(data)
    local node = DeleteLayer:new()
    node:init(data)
    return node
end

function DeleteLayer:init(data)
    self._csb = cc.CSLoader:createNode("dxyCocosStudio/csd/ui/login/DeleteLayer.csb")
    self:addChild(self._csb)
    --self:setPosition(self.origin.x + self.visibleSize.width / 2, self.origin.y + self.visibleSize.height / 2)

    -- 拦截
    dxySwallowTouches(self)
    
    
    local Del = self._csb:getChildByName("DeleteRole")
    local Input = Del:getChildByName("OKInput")
    local TextField = Input:getChildByName("TextField")
    
    local btnSure = Del:getChildByName("Sure")
    local btnCancel = Del:getChildByName("Cancle")
    btnSure:addTouchEventListener(function(target,type)
        if type == 2 then
            local txt = TextField:getString()
            if txt == "确定" then
                SoundsFunc_playSounds(SoundsType.CLOSE_PAGE,false)
                zzc.LoginController:delRole(data.uid,0)
                self:removeFromParent()
            else
                SoundsFunc_playSounds(SoundsType.FAILE_TO_USE,false)
                TipsFrame:create("确认删除请输入'确定'")
            end
        end
    end)
    btnCancel:addTouchEventListener(function(target,type)
        if type == 2 then
            SoundsFunc_playSounds(SoundsType.CLOSE_PAGE,false)
            self:removeFromParent()
        end
    end)
end