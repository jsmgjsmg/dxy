ResourceLayer = ResourceLayer or class("ResourceLayer",function()
	return cc.Layer:create()
end)

function ResourceLayer.create()
	local layer = ResourceLayer.new()
	return layer
end


function ResourceLayer:ctor()
	self:initUI()
	dxyExtendEvent(self)
    dxySwallowTouches(self)--拦截
end

function ResourceLayer:initUI()
	self._csb = cc.CSLoader:getInstance():createNodeWithFlatBuffersFile("dxyCocosStudio/csd/ui/immortalfield/ResourceLayer.csb")
    self:addChild(self._csb)
    
    self.visibleSize = cc.Director:getInstance():getVisibleSize()
    self.origin = cc.Director:getInstance():getVisibleOrigin()
    local posX = self.origin.x + self.visibleSize.width/2
    local posY = self.origin.y + self.visibleSize.height/2

    self._csb:setPosition(posX, posY)
    
	self.btn_back = self._csb:getChildByName("btnBack")
    self.btn_get = self._csb:getChildByName("btnGet")
    
    self.curContribution = self._csb:getChildByName("curContribution")
    self.allContribution = self._csb:getChildByName("allContribution")
    self.numKill = self._csb:getChildByName("numKill")
    self.powerValue = self._csb:getChildByName("powerValue")
    self.resourcePercent = self._csb:getChildByName("resourcePercent")
    
    self.panel_res = self._csb:getChildByName("Panel_1")
    self.panel_all = self._csb:getChildByName("Panel_2")
    self.panel_myRes = self._csb:getChildByName("Panel_3")
    
    
    self._scrollHeight_res = self.panel_res:getContentSize().height - 100
    self._scrollWidth_res = self.panel_res:getContentSize().width

    self._scrollHeight_all = self.panel_all:getContentSize().height - 100
    self._scrollWidth_all = self.panel_all:getContentSize().width

    self._scrollHeight_myRes = self.panel_myRes:getContentSize().height - 100
    self._scrollWidth_myRes = self.panel_myRes:getContentSize().width
    
    local data = zzm.ImmortalFieldModel.manorResData
    self:addDataToPanel(data)
end

function ResourceLayer:removeEvent()
	
end

function ResourceLayer:initEvent()
    if self.btn_back then
        self.btn_back:addTouchEventListener(function(target,type)
            if (type == 2) then
                self:removeFromParent()
            end
        end)
    end
    
    if self.btn_get then
        self.btn_get:addTouchEventListener(function(target,type)
            if (type == 2) then
                
            end
        end)
    end
end


function ResourceLayer:addDataToPanel(data)
    require("game.tilemap.immortalfield.view.ResourceItem")
    if not data then return end
    for i=1, #data do
        local resourceItem = ResourceItem:create()
        resourceItem:update(data[i])
        resourceItem.txtName:setVisible(false)
        self.panel_res:addChild(resourceItem)
        resourceItem:setScale(0.6)
        resourceItem:setPosition(100,self._scrollHeight_res)
        self._scrollHeight_res = self._scrollHeight_res + 50
        
         local allNum = CCLabel:createWithTTF("","dxyCocosStudio/font/MicosoftBlack.ttf",32)
        self.panel_all:addChild(allNum)
        --        resourceItem:update(data)
        allNum:setString(data.allNum)
        allNum:setScale(0.6)
        allNum:setPosition(100,self._scrollHeight_all)
--        self.ItemList[i] = resourceItem
        self._scrollHeight_all = self._scrollHeight_all + 50
        
        local myNum = CCLabel:createWithTTF("","dxyCocosStudio/font/MicosoftBlack.ttf",32)
        self.panel_myRes:addChild(myNum)
        --        resourceItem:update(data)
        myNum:setString(data.myNum)
        myNum:setScale(0.6)
        myNum:setPosition(100,self._scrollHeight_myRes)
        --        self.ItemList[i] = resourceItem
        self._scrollHeight_myRes = self._scrollHeight_myRes + 50
    end
end

