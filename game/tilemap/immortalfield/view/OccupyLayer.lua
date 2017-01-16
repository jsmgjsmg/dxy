OccupyLayer = OccupyLayer or class("OccupyLayer",function()
    return cc.Layer:create()
end)

function OccupyLayer.create()
	local layer = OccupyLayer.new()
	return layer
end


function OccupyLayer:ctor()
	self._csb = nil
	self.ItemList_hourRes = {}
	self.ItemList_maxRes = {}
	
	self:initUI()
	dxyExtendEvent(self)
    dxySwallowTouches(self)--拦截
end

function OccupyLayer:initUI()
	self._csb = cc.CSLoader:getInstance():createNodeWithFlatBuffersFile("dxyCocosStudio/csd/ui/immortalfield/OccupyLayer.csb")
    self:addChild(self._csb)
    
    self.visibleSize = cc.Director:getInstance():getVisibleSize()
    self.origin = cc.Director:getInstance():getVisibleOrigin()
    local posX = self.origin.x + self.visibleSize.width/2
    local posY = self.origin.y + self.visibleSize.height/2

    self._csb:setPosition(posX, posY)
    
	self.btn_back = self._csb:getChildByName("btnBack")
    self.btn_occupy = self._csb:getChildByName("BtnOccupy")
    
    
    self.hourResourceNode = self._csb:getChildByName("hourResourceNode")
    self.panel_hourResource = self.hourResourceNode:getChildByName("Panel")
    
    self.maxResourceNode = self._csb:getChildByName("maxResourceNode")
    self.panel_maxResource = self.maxResourceNode:getChildByName("Panel")
    
    self.manorText = self._csb:getChildByName("manorText")
    self.rmbUseText = self._csb:getChildByName("rmbUseText")
    self.rmbUseText:setString("花费9999元宝")
    
    self._scrollHeight_hour = self.panel_hourResource:getContentSize().height - 100
    self._scrollWidth_hour = self.panel_hourResource:getContentSize().width
    
    self._scrollHeight_max = self.panel_maxResource:getContentSize().height - 100
    self._scrollWidth_max = self.panel_maxResource:getContentSize().width
    
    local data = zzm.ImmortalFieldModel.occupyData
    self:addDataToPanel(data)
end


function OccupyLayer:removeEvent()
	
end

function OccupyLayer:initEvent()
	if self.btn_back then
        self.btn_back:addTouchEventListener(function(target,type)
            if (type == 2) then
                self:removeFromParent()
            end
        end)
	end
	
    if self.btn_occupy then
        self.btn_occupy:addTouchEventListener(function(target,type)
            if (type == 2) then

            end
        end)
    end
end

function OccupyLayer:addDataToPanel(data)
    require("game.tilemap.immortalfield.view.ResourceItem")
    if not data then return end
    for i=1, #data do
        local resourceItem = ResourceItem:create()
        self.panel_hourResource:addChild(resourceItem)
--        resourceItem:update(data)
        resourceItem:setScale(0.6)
        resourceItem:setPosition(100,self._scrollHeight_hour)
        self.ItemList_hourRes[i] = resourceItem
        self._scrollHeight_hour = self._scrollHeight_hour - 65
--        self.panel_hourResource:setInnerContainerSize(cc.size(self._scrollWidth_hour,self._scrollHeight_hour))
    end
    
    for i=1, #data do
        local resourceItem = ResourceItem:create()
        self.panel_maxResource:addChild(resourceItem)
        --        resourceItem:update(data)
        resourceItem:setScale(0.6)
        resourceItem:setPosition(100,self._scrollHeight_max)
        self.ItemList_maxRes[i] = resourceItem
        self._scrollHeight_max = self._scrollHeight_max - 65
--        self.panel_maxResource:setInnerContainerSize(cc.size(self._scrollWidth_max,self._scrollHeight_max))
    end
end

