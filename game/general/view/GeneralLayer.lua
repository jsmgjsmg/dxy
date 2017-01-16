GeneralLayer = GeneralLayer or class("GeneralLayer",function()
    return cc.Layer:create()
end)

function GeneralLayer:ctor()
    self.winSize = cc.Director:getInstance():getVisibleSize()
    self.origin = cc.Director:getInstance():getVisibleOrigin()
end

function GeneralLayer:create()
    local layer = GeneralLayer:new()
    layer:initLayer()
    return layer
end

function GeneralLayer:initLayer()
    self._csb = cc.CSLoader:createNode("dxyCocosStudio/csd/ui/general/GeneralLayer.csb")
    self:addChild(self._csb)
    local csbSize = self._csb:getContentSize()
    local rowGap = (self.winSize.width - csbSize.width) / 2
    local listGap = (self.winSize.height - csbSize.height) / 2
--    self._csb:setPosition(rowGap,listGap)
    self._csb:setPosition(0,0)
    self:setContentSize(self.winSize.width,self.winSize.height)
    
    local posX = self.origin.x + self.winSize.width/2
    local posY = self.origin.y + self.winSize.height/2

    -- 拦截
    dxySwallowTouches(self)
    local swallow = self._csb:getChildByName("swallow")
    swallow:setContentSize(self.winSize.width,self.winSize.height)
    
    local bgTop = self._csb:getChildByName("bgTop")
    bgTop:setPosition(posX,self.winSize.height)
    
    self._ndTop = self._csb:getChildByName("nd_top")
    self._ndTop:setPosition(0,self.winSize.height)
    
--pageview
    self._pageView = self._csb:getChildByName("PageView")    
    
--返回、切换按钮
    local _btnBack = self._ndTop:getChildByName("btn_back")
    _btnBack:addTouchEventListener(function(target,type)
        if type == 2 then
            SoundsFunc_playSounds(SoundsType.CLOSE_PAGE,false)
            zzm.GeneralModel.isOnGeneral = false
            self:removeFromParent()
        end
    end)
    self._btnFirst = self._ndTop:getChildByName("btn_First")
    self._btnSecond = self._ndTop:getChildByName("btn_Second")
    self._btnFirst:setTouchEnabled(false)
    self._btnFirst:setBright(false)
    
--钱
    local ndData = self._ndTop:getChildByName("nd_data")
    ndData:setPositionX(self.winSize.width)
    require "src.game.utils.TopDataNode"
    local data = TopDataNode:create()
    ndData:addChild(data)
    
--切换
    self._pageView:setPosition(0,0)
    self._pageView:setContentSize(self.winSize.width, self.winSize.height)
    
    require "src.game.general.view.GeneralStage"
    self._stage = GeneralStage:create()
    self._pageView:addPage(self._stage)
    require "src.game.general.view.GeneralRank"
    self._rank = GeneralRank:create()
    self._pageView:addPage(self._rank)

    self._pageView:scrollToPage(0)
    
    self._btnFirst:addTouchEventListener(function(target,type)
        if type == 2 then
            self._pageView:scrollToPage(0)
            SoundsFunc_playSounds(SoundsType.UNIVERSAL_BTN,false)
            
            self._btnFirst:setTouchEnabled(false)
            self._btnFirst:setBright(false)
            self._btnSecond:setTouchEnabled(true)
            self._btnSecond:setBright(true)
        end
    end)
    self._btnSecond:addTouchEventListener(function(target,type)
        if type == 2 then
            self._pageView:scrollToPage(1)
            SoundsFunc_playSounds(SoundsType.UNIVERSAL_BTN,false)
                        
            self._btnFirst:setTouchEnabled(true)
            self._btnFirst:setBright(true)
            self._btnSecond:setTouchEnabled(false)
            self._btnSecond:setBright(false)
        end
    end)
end

function GeneralLayer:scrollToPage(page)
    if page == 0 then
        self._btnFirst:setTouchEnabled(false)
        self._btnFirst:setBright(false)
        self._btnSecond:setTouchEnabled(true)
        self._btnSecond:setBright(true)
    elseif page == 1 then
        self._btnFirst:setTouchEnabled(true)
        self._btnFirst:setBright(true)
        self._btnSecond:setTouchEnabled(false)
        self._btnSecond:setBright(false)
    end
    self._pageView:scrollToPage(page)
end