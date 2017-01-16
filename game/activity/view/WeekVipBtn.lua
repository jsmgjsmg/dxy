WeekVipBtn = WeekVipBtn or class("WeekVipBtn",function()
    return cc.Node:create()
end)

function WeekVipBtn:ctor()

end

function WeekVipBtn:create()
    local node = WeekVipBtn.new()
    node:init()
    return node
end

function WeekVipBtn:init()
    self._csb = cc.CSLoader:createNode("dxyCocosStudio/csd/ui/activity/WeekVipBtn.csb")
    self:addChild(self._csb)
    
    self._btn = self._csb:getChildByName("Button")
    self._btn:addTouchEventListener(function(target,type)
        if type == 2 then
        
        end
    end)
end

function WeekVipBtn:update(data)
    self.m_data = data
    if not self.m_data then
        return
    end
    self._btn:setTitleText()
end

