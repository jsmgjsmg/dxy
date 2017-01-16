
LotteryDrawItem = LotteryDrawItem or class("LotteryDrawItem",function()
    return cc.Node:create()
end)

LotteryDrawItem.parentSize = 300

function LotteryDrawItem.create()
    local node = LotteryDrawItem.new()
    return node
end

function LotteryDrawItem:ctor()
    self._csbNode = nil
    self:initUI()
end

function LotteryDrawItem:initUI()
    self._csbNode = cc.CSLoader:createNode("dxyCocosStudio/csd/ui/lotterydraw/LotteryDrawItem.csb")
    self:addChild(self._csbNode)
    self.itemPanel = self._csbNode:getChildByName("Panel")
    self.contentText = self.itemPanel:getChildByName("Text")
end

function LotteryDrawItem:update(data)
    self.m_data = data
    if self.m_data == nil then
    	return
    end
    
    local name = ""
    
    if data.subtype == 1 then
    	name = "[" .. data.uname .. "]人品大爆发，" 
    end
    local message = name .. "获得了" .. cn:GetRewardsInfo(data)
    
--    self.contentText:setString(message)
--    self.contentText:setPosition(10,10)
    
    

    local contents = cc.Label:createWithTTF("","dxyCocosStudio/font/MicosoftBlack.ttf",20)
--    local contents = cc.Label:createWithTTF("","Trebuchet Ms",20)
    contents:setDimensions(LotteryDrawItem.parentSize-30, contents:getDimensions().height)
    contents:setAlignment(0)
    contents:setAnchorPoint(0,0)
    contents:setString(message)
    self.itemPanel:addChild(contents)
    contents:setPosition(10,10)
    
    self.itemPanel:setContentSize(300, contents:getContentSize().height)
end

function LotteryDrawItem:getItemHgight()
    return self.itemPanel:getContentSize().height + 5
end




