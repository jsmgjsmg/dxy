FirstRecharge = FirstRecharge or class("FirstRecharge",function()
    return cc.Node:create()
end)
local GOODS = 5

function FirstRecharge:ctor()
    self.visibleSize = cc.Director:getInstance():getVisibleSize()
    self.origin = cc.Director:getInstance():getVisibleOrigin()
    self._arrPos = {}
end

function FirstRecharge:create()
    local node = FirstRecharge:new()
    node:init()
    return node
end

function FirstRecharge:init()
    self._csb = cc.CSLoader:createNode("res/dxyCocosStudio/csd/ui/recharge/FirstRecharge.csb")
    self:addChild(self._csb)
    self._csb:setPosition(self.origin.x + self.visibleSize.width / 2, self.origin.y + self.visibleSize.height / 2)

    -- 拦截
    dxySwallowTouches(self)

--btn    
    local btnBack = self._csb:getChildByName("btnBack")
    btnBack:addTouchEventListener(function(target,type)
        if type == 2 then
            SoundsFunc_playSounds(SoundsType.CLOSE_PAGE,false)
            self:removeFromParent()
        end
    end)
    
    local btnCharge = self._csb:getChildByName("btnRecharge")
    btnCharge:addTouchEventListener(function(target,type)
        if type == 2 then
            SoundsFunc_playSounds(SoundsType.OPEN_PAGE,false)
--            require "src.game.recharge.view.RechargeLayer"
--            local _csb = RechargeLayer:create()
--            local scene = SceneManager:getCurrentScene()
--            scene:addChild(_csb)
            zzc.RechargeController:showLayer()
            self:removeFromParent()
        end
    end)
    
    local btnGet = self._csb:getChildByName("btnGet")
    btnGet:addTouchEventListener(function(target,type)
        if type == 2 then
            SoundsFunc_playSounds(SoundsType.UNIVERSAL_BTN,false)
            zzc.RechargeController:GetMonthCard()
            self:removeFromParent()
        end
    end)

    if zzm.RechargeModel._isFirst == 0 then
        btnCharge:setVisible(true)
        btnGet:setVisible(false)
    elseif zzm.RechargeModel._isFirst == 1 then
        btnCharge:setVisible(false)
        btnGet:setVisible(true)
    end
    
    
--goods
    self._ndGoods = self._csb:getChildByName("ndGoods")
    for i=1,GOODS do
        local goods = self._ndGoods:getChildByName("goods"..i)
        local posx,posy = goods:getPosition()
        local data = {[1]={posx,posy},[2]=i}
        self:initGoods(data)
    end
    
end

function FirstRecharge:initGoods(data)
    require "src.game.recharge.view.ItemFirstGoods"
    local _csb = ItemFirstGoods:create(data[2])
    _csb:setPosition(data[1][1],data[1][2])
    self._ndGoods:addChild(_csb)
end