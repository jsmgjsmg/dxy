YSInitLayer = YSInitLayer or class("YSInitLayer",function()
    return cc.Layer:create()
end)

function YSInitLayer:ctor()
    self.winSize = cc.Director:getInstance():getVisibleSize()
    self.origin = cc.Director:getInstance():getVisibleOrigin()
end

function YSInitLayer:create()
    local layer = YSInitLayer:new()
    layer:init()
    return layer
end

function YSInitLayer:init()
    self._csb = cc.CSLoader:createNode("dxyCocosStudio/csd/ui/yuanshen/YSInitLayer.csb")
    self:addChild(self._csb)
    local csbSize = self._csb:getContentSize()
    local rowGap = (self.winSize.width - csbSize.width) / 2
    local listGap = (self.winSize.height - csbSize.height) / 2
--    self._csb:setPosition(rowGap,listGap)
    self._csb:setPosition(0,0)
    self:setContentSize(self.winSize.width,self.winSize.height)
    -- 拦截
    dxySwallowTouches(self)
    dxyExtendEvent(self)

    local posX = self.origin.x + self.winSize.width/2
    local posY = self.origin.y + self.winSize.height/2

    local top = self._csb:getChildByName("top")
    top:setPosition(posX,posY*2)

    local ndTop = self._csb:getChildByName("ndTop")
    ndTop:setPosition(0,posY*2)
    ---back
    local btnBack = ndTop:getChildByName("btnBack")
    btnBack:addTouchEventListener(function(target,type)
        if type == 2 then
            self._layer:whenClose()
            zzc.YuanShenController:closeLayer()
        end
    end)
    ---change
    self._btnYS = ndTop:getChildByName("btnYS")
    self._btnYS:addTouchEventListener(function(target,type)
        if type == 2 then
            self._pageView:scrollToPage(0)
            SoundsFunc_playSounds(SoundsType.UNIVERSAL_BTN,false)

            self._btnMagic:setTouchEnabled(true)
            self._btnMagic:setBright(true)
            self._btnYS:setTouchEnabled(false)
            self._btnYS:setBright(false)
        end
    end)

    self._btnMagic = ndTop:getChildByName("btnMagic")
    self._btnMagic:addTouchEventListener(function(target,type)
        if type == 2 then
            self._pageView:scrollToPage(1)
            SoundsFunc_playSounds(SoundsType.UNIVERSAL_BTN,false)

            self._btnYS:setTouchEnabled(true)
            self._btnYS:setBright(true)
            self._btnMagic:setTouchEnabled(false)
            self._btnMagic:setBright(false)
        end
    end)

    self._btnYS:setTouchEnabled(false)
    self._btnYS:setBright(false)

    ---ndData
    local ndData = ndTop:getChildByName("ndData")
    ndData:setPositionX(posX*2)
    require "src.game.utils.TopDataNode"
    local data = TopDataNode:create()
    ndData:addChild(data)

    ---PageView
    self._pageView = self._csb:getChildByName("PageView")
--    self._pageView:setPosition(posX, posY)
    self._pageView:setPosition(0, 0)
    self._pageView:setContentSize(posX*2, posY*2)
    require "src.game.yuanshen.view.YuanShenNode"
    self._node = YuanShenNode:create()
    self._pageView:addPage(self._node)
    require "src.game.yuanshen.view.YuanShenLayer"
    self._layer = YuanShenLayer:create()
    self._pageView:addPage(self._layer)

    self._pageView:scrollToPage(0)
end

function YSInitLayer:initEvent()
    dxyDispatcher_addEventListener("YSInitLayer_scrollToPage",self,self.scrollToPage)
end

function YSInitLayer:removeEvent()
    dxyDispatcher_removeEventListener("YSInitLayer_scrollToPage",self,self.scrollToPage)
end

function YSInitLayer:scrollToPage(page)
    if page == 0 then
        self._btnYS:setTouchEnabled(false)
        self._btnYS:setBright(false)
        self._btnMagic:setTouchEnabled(true)
        self._btnMagic:setBright(true)
    elseif page == 1 then
        self._btnYS:setTouchEnabled(true)
        self._btnYS:setBright(true)
        self._btnMagic:setTouchEnabled(false)
        self._btnMagic:setBright(false)
    end
    self._pageView:scrollToPage(page)
end

