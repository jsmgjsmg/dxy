TipFlowers = TipFlowers or class("TipFlowers",function()
    return cc.Node:create()
end)

function TipFlowers:ctor()
    self.visibleSize = cc.Director:getInstance():getVisibleSize()
    self.origin = cc.Director:getInstance():getVisibleOrigin()
end

function TipFlowers:create(id,num)
    local node = TipFlowers:new()
    node:initTip(id,num)
    return node
end

function TipFlowers:initTip(id,num)
    self._csb = cc.CSLoader:createNode("res/dxyCocosStudio/csd/ui/fairy/TipFlowers.csb")
    self:addChild(self._csb)
    self._csb:setPosition(self.origin.x + self.visibleSize.width / 2, self.origin.y + self.visibleSize.height / 2)
    
    local swallow = self._csb:getChildByName("swallow")
    swallow:setSwallowTouches(true)
    
    local tip = self._csb:getChildByName("tipBG")
    local _bflFlowers = tip:getChildByName("bfl_number")
    _bflFlowers:setString(math.ceil(num))
    
    local _btnGive = tip:getChildByName("btn_give")
    _btnGive:addTouchEventListener(function(target,type)
        if type == 2 then
            zzc.FairyController:registerGiveFlowers(id)
            self:removeFromParent()
        end
    end)
    
    swallow:addTouchEventListener(function(target,type)
        if type == 2 then
            self:removeFromParent()
        end
    end)
end