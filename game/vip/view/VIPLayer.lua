VIPLayer = VIPLayer or class("VIPLayer",function()
    return cc.Layer:create()
end)

function VIPLayer:ctor()
    self.winSize = cc.Director:getInstance():getVisibleSize()
    self._arrLayout = {}
end

function VIPLayer:create()
    local layer = VIPLayer:new()
    layer:initLayer()
    return layer
end

function VIPLayer:initLayer()
    self._csb = cc.CSLoader:createNode("dxyCocosStudio/csd/ui/vip/VIPLayer.csb")
    self:addChild(self._csb)
    local csbSize = self._csb:getContentSize()
    local rowGap = (self.winSize.width - csbSize.width) / 2
    local listGap = (self.winSize.height - csbSize.height) / 2
    self._csb:setPosition(rowGap,listGap)
    
    
--翻页容器
    local nd_state = self._csb:getChildByName("nd_state")
    self._pageView = nd_state:getChildByName("PageView")
    local pageSize = self._pageView:getContentSize()
    for i=1,VipConfig:getVipLen() do
        require "src.game.vip.view.LayOut"
        local data = {[1]=pageSize,[2]=i}
        local layout = LayOut:create(data)
        self._pageView:addPage(layout)
        table.insert(self._arrLayout,layout)
    end
    
    self._pageView:scrollToPage(_G.RoleData.VipLv - 1)
    
    self._pageView:addEventListener(function(target,type)
        if type == ccui.PageViewEventType.turning then
            local index = self._pageView:getCurPageIndex()
            self._bflIntroduce:setString(index+1)
        end
    end)

--vip等级介绍
    self._bflIntroduce = nd_state:getChildByName("bg"):getChildByName("bgtop"):getChildByName("bfl_introduce")
    
--左右翻页按钮
    self._btnLeft = nd_state:getChildByName("btn_left")
    self._btnLeft:addTouchEventListener(function(target,type)
        if type == 2 then
            SoundsFunc_playSounds(SoundsType.UNIVERSAL_BTN,false)
            local index = self._pageView:getCurPageIndex()
            self._pageView:scrollToPage(index-1)
            self._btnRight:setVisible(true)
--            if index-1 == 0 then
--                self._btnLeft:setVisible(false)
--            end
            self:HideBtn(index-1)
            self:jumToTop()
        end
    end)
    
    self._btnRight = nd_state:getChildByName("btn_right")
    self._btnRight:addTouchEventListener(function(target,type)
        if type == 2 then
            SoundsFunc_playSounds(SoundsType.UNIVERSAL_BTN,false)
            local index = self._pageView:getCurPageIndex()
            self._pageView:scrollToPage(index+1)
            self._btnLeft:setVisible(true)
            self:HideBtn(index+1)
            self:jumToTop()
        end
    end)
    
    local index = self._pageView:getCurPageIndex()
    self:HideBtn(index)
end

function VIPLayer:jumToTop()
    for i=1,#self._arrLayout do
        self._arrLayout[i]:jumpToTop()
    end
end

function VIPLayer:HideBtn(index)
    if index == 0 then
        self._btnLeft:setVisible(false)
    elseif index == VipConfig:getVipLen()-1 then
        self._btnRight:setVisible(false)
    end
end
