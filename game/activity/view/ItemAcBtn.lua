ItemAcBtn = ItemAcBtn or class("ItemAcBtn",function()
    return ccui.Button:create("dxyCocosStudio/png/friend/friend_n.png","dxyCocosStudio/png/friend/friend_s.png","dxyCocosStudio/png/friend/friend_s.png")
end)

function ItemAcBtn:ctor()

end

function ItemAcBtn:create()
    local node = ItemAcBtn.new()
    node:init()
    return node
end

function ItemAcBtn:init()
--    self._csb = cc.CSLoader:createNode("dxyCocosStudio/csd/ui/activity/ItemBtn.csb")
--    self:addChild(self._csb)
    
--    self._btn = self._csb:getChildByName("Button")
    self:setScale(0.90)

    self:setAnchorPoint(0,1)
    self:addTouchEventListener(function(target,type)
        if type == 2 then
            dxyDispatcher_dispatchEvent("ActivityNode_HideOtherBtn",self.m_data)
        end
    end)

end

function ItemAcBtn:update(data)
    self.m_data = data
    if not self.m_data then
        return
    end
    self:setTitleText(ActivityConfig:getFirstConfigByType(self.m_data).Title)
    self:setTitleFontName("res/dxyCocosStudio/font/MicosoftBlack.ttf")
    self:setTitleFontSize(26)
end