HelperNode = HelperNode or class("HelperNode",function()
	return cc.Node:create()
end)

function HelperNode:create()
    local node = HelperNode:new()
    return node
end

function HelperNode:ctor()
	self._csb = nil
	
	self:initUI()
	self:initEvent()
end

function HelperNode:initUI()
    self._csb = cc.CSLoader:createNode("dxyCocosStudio/csd/ui/helper/HelperNode.csb")
    self:addChild(self._csb)
    
    self.scrollView = self._csb:getChildByName("ScrollView")
end

function HelperNode:initEvent()
	
end

function HelperNode:update(data)	
	if data == CKB_TYPE[1] then
	   self:loadWantStrongItem(data)
	else		
        self:loadOtherItem(data)
	end
end

function HelperNode:loadWantStrongItem(type)
    local data = HelperConfig:getHelperListByType(type)

    if #data == 0 then
        return
    end
    
    local openData = {}
    for key, var in pairs(data) do
        if var.FunctionOpen == 1 and BUTTON_FUN_OPEN[var.Id]() then
            table.insert(openData,#openData + 1,var)
        end

        if var.FunctionOpen == 2 then
            table.insert(openData,#openData + 1,var)
        end
    end

    if #openData == 0 then
        return
    end
    
    require("game.helper.view.WantStrongItem")
    local item = nil
    local itemSize = WantStrongItem:create():getContentSize()
    local x,y = 0,0
    local index = 1
    self.item_list = {}

    self.scrollView:setInnerContainerSize(cc.size(itemSize.width,itemSize.height * #openData))

    for i=1,#openData,1 do
        item = WantStrongItem:create()
        item:setAnchorPoint(cc.p(0,0))
        x = 3
        y = self.scrollView:getInnerContainerSize().height - (itemSize.height * i)
        item:setPosition(cc.p(x,y))
        self.scrollView:addChild(item)
        self.item_list[index] = item
        self.item_list[index]:update(openData[index])
        index = index + 1
    end
end

function HelperNode:loadOtherItem(type)

    local data = HelperConfig:getHelperListByType(type)
    if #data == 0 then
    	return
    end
    
    local openData = {}
    for key, var in pairs(data) do
    	if var.FunctionOpen == 1 and BUTTON_FUN_OPEN[var.Id]() then
            table.insert(openData,#openData + 1,var)
    	end
    	
        if var.FunctionOpen == 2 then
            table.insert(openData,#openData + 1,var)
    	end
    end
    
    if #openData == 0 then
        return
    end
    
    require("game.helper.view.OtherItem")
    local item = nil
    local itemSize = OtherItem:create():getContentSize()
    local x,y = 0,0
    local index = 1
    self.item_list = {}
    
    self.scrollView:setInnerContainerSize(cc.size(itemSize.width,itemSize.height * #openData))

    for i=1,#openData,1 do
        item = OtherItem:create()
        item:setAnchorPoint(cc.p(0,0))
        x = 3
        y = self.scrollView:getInnerContainerSize().height - (itemSize.height * i)
        item:setPosition(cc.p(x,y))
        self.scrollView:addChild(item)
        self.item_list[index] = item
        self.item_list[index]:update(openData[index])
        index = index + 1
    end
end