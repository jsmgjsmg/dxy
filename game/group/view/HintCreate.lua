HintCreate = HintCreate or class("HintCreate",function()
    return cc.Node:create()
end)

function HintCreate:ctor()
    self.visibleSize = cc.Director:getInstance():getVisibleSize()
    self.origin = cc.Director:getInstance():getVisibleOrigin()
end

function HintCreate:create(vip)
    local node = HintCreate:new()
    node:init(vip)
    return node
end

function HintCreate:init(vip)
    self._csb = cc.CSLoader:createNode("dxyCocosStudio/csd/ui/group/HintCreate.csb")
    self:addChild(self._csb)
    self._csb:setPosition(self.origin.x + self.visibleSize.width / 2, self.origin.y + self.visibleSize.height / 2)

    -- 拦截
    dxySwallowTouches(self)
    
    self._txtVip = self._csb:getChildByName("txt_vip")
    self._txtVip:setString("Vip"..vip) --19:创建仙门权限
    
    local _btnSure = self._csb:getChildByName("btn_sure")
    _btnSure:addTouchEventListener(function(target,type)
        if type == 2 then
            SoundsFunc_playSounds(SoundsType.UNIVERSAL_BTN,false)
            self:removeFromParent()
        end       
    end)
end