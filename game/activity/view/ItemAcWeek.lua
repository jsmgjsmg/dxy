ItemAcWeek = ItemAcWeek or class("ItemAcWeek",function()
    return cc.Node:create()
end)
require("game.activity.view.WeekVipBtn")
local SPACE = 85

function ItemAcWeek:ctor()
    self.bflVip = {}
    self.arrGoods = {}
    self.arrColor = {}
    self.arrSprite = {}
    self.arrVipBtn = {}
end

function ItemAcWeek:create()
    local node = ItemAcWeek.new()
    node:init()
    return node
end

function ItemAcWeek:init()
    self._csb = cc.CSLoader:createNode("dxyCocosStudio/csd/ui/activity/ItemAcWeek.csb")
    self:addChild(self._csb)

    for i=1,2 do    
        self.bflVip[i] = self._csb:getChildByName("bflVip"..i)
    end
    self._bflCurVip = self._csb:getChildByName("bflCurVip")
    self._txtTimer = self._csb:getChildByName("txtTimer")
    
--change
    local ndChange = self._csb:getChildByName("ndChange")
    for j=1,4 do
        self.arrGoods[j] = ndChange:getChildByName("goods"..j)
        self.arrColor[j] = self.arrGoods[j]:getChildByName("spColor")
        self.arrSprite[j] = self.arrGoods[j]:getChildByName("Sprite")
    end
    self._txtBefore = ndChange:getChildByName("titleBefore"):getChildByName("txtBefore")
    self._txtAffter = ndChange:getChildByName("titleAffter"):getChildByName("txtAffter")
    
    self._btnOver = self._csb:getChildByName("btnOver")
    self._btnBuy = self._csb:getChildByName("btnBuy")
    self._btnOver:addTouchEventListener(function(target,type)
        if type == 2 then
        
        end
    end)
    self._btnBuy:addTouchEventListener(function(target,type)
        if type == 2 then
        
        end
    end)
   
--sv
    local bgSV = self._csb:getChildByName("bgSV")
    local sv = bgSV:getChildByName("ScrollView")
    local vipLen = VipConfig:getVipLen()
    local conSize = sv:getContentSize()
    local last = cn:setSVSize(sv,"width",vipLen,SPACE)
    for k = 1,vipLen do
        self.arrVipBtn[k] = WeekVipBtn:create()
        self.arrVipBtn[k]:update()
        self.arrVipBtn[k]:setPosition((k-1)*SPACE,conSize.height)
    end
    
    local btnNext = bgSV:getChildByName("btnNext")
    btnNext:addTouchEventListener(function(target,type)
        if type == 2 then
            sv:scrollToBottom()
        end
    end)
    
end