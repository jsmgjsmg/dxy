MergerTips = MergerTips or class("MergerTips",function()
    return cc.Node:create()
end)

function MergerTips:ctor()
    self.visibleSize = cc.Director:getInstance():getVisibleSize()
    self.origin = cc.Director:getInstance():getVisibleOrigin()
    self._arrStar = {}
end

function MergerTips:create(data)
    local node = MergerTips:new()
    node:initTips(data)
    return node
end

function MergerTips:initTips(data)
    self._csb = cc.CSLoader:createNode("res/dxyCocosStudio/csd/ui/general/MergerTips.csb")
    self:addChild(self._csb)
    self._csb:setPosition(self.origin.x + self.visibleSize.width / 2, self.origin.y + self.visibleSize.height / 2)
    
    local swallow = self._csb:getChildByName("swallow")
    swallow:setSwallowTouches(true)
    
    self._txt = self._csb:getChildByName("txt")
    self._txt:setString("是否兑换："..data["Name"])
    
    local _btnCancel = self._csb:getChildByName("btn_cancel")
    local _btnSure = self._csb:getChildByName("btn_sure")
    
    _btnCancel:addTouchEventListener(function(target,type)
        if type == 2 then
            SoundsFunc_playSounds(SoundsType.CLOSE_PAGE,false)
            self:removeFromParent()
        end
    end)
    _btnSure:addTouchEventListener(function(target,type)
        if type == 2 then
            SoundsFunc_playSounds(SoundsType.UNIVERSAL_BTN,false)
            zzc.GeneralController:ConvertFragment(data["ChipId"])
            self:removeFromParent()
        end
    end)
end