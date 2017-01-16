TowerLayer = TowerLayer or class("TowerLayer",function()
    return cc.Layer:create()
end)

function TowerLayer:create()
    local layer = TowerLayer:new()
    return layer
end

function TowerLayer:ctor()
    self._csb = nil

    self.itemList = {}

    self:initUI()
    self:initEvent()
end

function TowerLayer:initUI()
    self._csb = cc.CSLoader:createNode("dxyCocosStudio/csd/ui/tower/TowerLayer.csb")
    self:addChild(self._csb)

    self.visibleSize = cc.Director:getInstance():getVisibleSize()
    self.origin = cc.Director:getInstance():getVisibleOrigin()
    
    local leftNode = self._csb:getChildByName("LeftNode")
    leftNode:setPosition(cc.p(-self.visibleSize.width / 2 +self.origin.x,self.visibleSize.height / 2 +self.origin.y))
    self.btn_back = leftNode:getChildByName("backBtn")
    
    local topBg = self._csb:getChildByName("TitleNode"):getChildByName("BG")
--    topBg:setContentSize(self.visibleSize.width,self.visibleSize.height)
    local dataNode = self._csb:getChildByName("RightNode")
    dataNode:setPosition(cc.p(self.visibleSize.width / 2 + self.origin.x ,self.visibleSize.height / 2 + self.origin.y - 35))
    require "src.game.utils.TopDataNode"
    local data = TopDataNode:create()
    dataNode:addChild(data)
    
    local itemNode = self._csb:getChildByName("ItemNode")
    require("game.tower.view.TowerItem")
    self.item = TowerItem:create()
    itemNode:addChild(self.item)

end

function TowerLayer:initEvent()

    self.btn_back:addTouchEventListener(function(target,type)
        if type == 2 then
            SoundsFunc_playSounds(SoundsType.CLOSE_PAGE,false)
            zzc.TowerController:closeLayer()
        end
    end)

    -- 拦截
    dxySwallowTouches(self)
end

function TowerLayer:WhenClose()
    if self.item._handleExp then
        cc.Director:getInstance():getScheduler():unscheduleScriptEntry(self.item._handleExp)
        self.item._handleExp = nil
    end
    if self.item._handleFlower then
        cc.Director:getInstance():getScheduler():unscheduleScriptEntry(self.item._handleFlower)
        self.item._handleFlower = nil
    end
    if self.item._handleRenown then
        cc.Director:getInstance():getScheduler():unscheduleScriptEntry(self.item._handleRenown)
        self.item._handleRenown = nil
    end
    self:removeFromParent()
end