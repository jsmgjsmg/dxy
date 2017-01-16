RechargeLayer = RechargeLayer or class("RechargeLayer",function(target,type)
    return cc.Layer:create()
end)
local WIDE = 200
local PATH = "dxyCocosStudio/png/recharge/"
local VIP = "dxyCocosStudio/png/vip/"

function RechargeLayer:ctor()
    self.winSize = cc.Director:getInstance():getVisibleSize()
--    cc.SpriteFrameCache:getInstance():addSpriteFrames("dxyCocosStudio/png/recharge/Change.plist")
    self._arrItem = {}
end

function RechargeLayer:create()
    local layer = RechargeLayer:new()
    layer:init()
    return layer
end

function RechargeLayer:init()
    self._csb = cc.CSLoader:createNode("dxyCocosStudio/csd/ui/recharge/RechargeLayer.csb")
    self:addChild(self._csb)
    local csbSize = self._csb:getContentSize()
    local rowGap = (self.winSize.width - csbSize.width) / 2
    local listGap = (self.winSize.height - csbSize.height) / 2
    self._csb:setPosition(rowGap,listGap)
    
    dxyExtendEvent(self)
    -- 拦截
    dxySwallowTouches(self)
    
    local swallow = self._csb:getChildByName("swallow")
    swallow:setContentSize(self.winSize.width,self.winSize.height)
    
---title
    require "src.game.utils.TopTitleNode"
    local title = TopTitleNode:create(self,PATH.."txt1.png",1)
    self:addChild(title,1)
    
--ndVip
    self._ndVip = self._csb:getChildByName("ndVip")
    self._btnRoot = self._csb:getChildByName("btnRoot")
    self._btnShop = self._csb:getChildByName("btnShop")
    self._btnShop:setVisible(false)
    self._btnRoot:addTouchEventListener(function(target,type)
        if type == 2 then
            SoundsFunc_playSounds(SoundsType.OPEN_PAGE,false)
            self._sv:setVisible(false)
            self._btnRoot:setVisible(false)
            self._btnShop:setVisible(true)
            dxyDispatcher_dispatchEvent("TopTitleNode_changeTitle",VIP.."VIP.png")
            require "src.game.vip.view.VIPLayer"
            self._vip = VIPLayer:create()
            self:addChild(self._vip,2)
        end
    end)
    
    self._btnShop:addTouchEventListener(function(target,type)
        if type == 2 then
            SoundsFunc_playSounds(SoundsType.OPEN_PAGE,false)
            self:removeChild(self._vip)
            dxyDispatcher_dispatchEvent("TopTitleNode_changeTitle",PATH.."txt1.png")
            self._sv:setVisible(true)
            self._btnRoot:setVisible(true)
            self._btnShop:setVisible(false)
        end
    end)
    
    self._hideNode = self._ndVip:getChildByName("hideNode") 
    self._bflVip = self._ndVip:getChildByName("bflVip") 
    self._bflBecome = self._hideNode:getChildByName("bflBecome") 
    self._bflNeed = self._hideNode:getChildByName("bflNeed")
    
    self._iconYuanbao = self._hideNode:getChildByName("icon3")
    self._iconRmb = self._hideNode:getChildByName("Text_3")
    if _G.gSDKhuoshu or _G.gSDKAoyou then
    	self._iconYuanbao:setVisible(false)
        self._iconRmb:setVisible(true)
    else
        self._iconYuanbao:setVisible(true)
        self._iconRmb:setVisible(false)
    end
    
    self._lbExp = self._ndVip:getChildByName("bgExp"):getChildByName("lbExp")
    
--ndShop
    local ndShop = self._csb:getChildByName("ndShop")
    self._sv = ndShop:getChildByName("ScrollView")
    
    local NUM = RechargeConfig:getRechargeLen()
    local contSize = self._sv:getContentSize()
    local realWidth = WIDE * NUM
    local endWidth = contSize.width > realWidth and contSize.width or realWidth
    self._sv:setContentSize(cc.size(self.winSize.width,contSize.height))
    self._sv:setInnerContainerSize(cc.size(endWidth,contSize.height))

    for i=1,NUM do
        require "src.game.recharge.view.ItemShop"
        local data = RechargeConfig:getRechargeByKey(i)
        local item = ItemShop:create()
        item:setData(data)
        self._sv:addChild(item)
        item:setPosition((i-1)*WIDE,455)
        table.insert(self._arrItem,item)
    end
    
    self:updateVIP()
end

function RechargeLayer:initEvent()
    dxyDispatcher_addEventListener("RechargeLayer_changeItem",self,self.changeItem)
    dxyDispatcher_addEventListener("RechargeLayer_updateVIP",self,self.updateVIP)
end

function RechargeLayer:removeEvent()
    dxyDispatcher_removeEventListener("RechargeLayer_changeItem",self,self.changeItem)
    dxyDispatcher_removeEventListener("RechargeLayer_updateVIP",self,self.updateVIP)
end

function RechargeLayer:changeItem(data)
    for key, var in pairs(self._arrItem) do
    	if var._data["Id"] == data["Id"] then
            var:setData(var._data)
    	    break
    	end
    end
end

function RechargeLayer:updateVIP()
    local Rate = VipConfig:getRate()

    self._bflVip:setString(_G.RoleData.VipLv)
    local lv = _G.RoleData.VipLv + 1
    local need = 0
    if lv > VipConfig:getVipLen() then
        lv = VipConfig:getVipLen()
    end
    self._bflBecome:setString(lv)
    
    local rmb = VipConfig:getRmbByLv(lv)*Rate --下一级值
    need = rmb - _G.RoleData.ALLRMB      --下一级所需
	if _G.gSDKhuoshu or _G.gSDKAoyou then
		need = need / Rate
	end
--    if lv == VipConfig:getVipLen() and need < 0 then
    if lv >= VipConfig:getVipLen() then
        self._lbExp:setPercent(100)
        self._hideNode:setVisible(false)
    else
        self._bflNeed:setString(need)
        
        local cur = 0
        if _G.RoleData.VipLv ~= 0 then
            cur = VipConfig:getRmbByLv(_G.RoleData.VipLv) * Rate --当前级值
        end
        local a = (rmb - cur)  --下一级与上一级的差
        local b = _G.RoleData.ALLRMB - cur --充值已超出当前级值
        local percent = b / a * 100 --百分比
        self._lbExp:setPercent(percent)
    end
end
