AttributeNode = AttributeNode or class("AttributeNode",function()
    return cc.Layer:create()
end)

function AttributeNode:create()
    local node = AttributeNode:new()
    return node
end

function AttributeNode:ctor()
    self.btn_selectFrame = ccui.Button
    self._selectFrame = nil
    self._point = nil
    self._attribute = nil

    self:initUI()
    self:initEvent()
end

function AttributeNode:initUI()
    local attributeNode = cc.CSLoader:createNode("dxyCocosStudio/csd/ui/equip/attributeNode.csb")
    self:addChild(attributeNode)

    self.btn_selectFrame = attributeNode:getChildByName("selectFrameBtn")
    self._selectFrame = attributeNode:getChildByName("selectFrame")
    self._point = attributeNode:getChildByName("point")
    self._attribute = attributeNode:getChildByName("attributeTxt")
    
    self._selectFrame:setVisible(false)
    --self:updateFrame(data)
    --self:update(data)

end

function AttributeNode:initEvent()

--    self.btn_selectFrame:addTouchEventListener(function(target,type)
--        if type == 2 then
--        	print("点击属性")
--        	if not self._selectFrame:isVisible() then
--                self:setFrameShow(true)
--        	end
--        end
--    end)
--    -- 拦截
--    local function onTouchBegan(touch, event)
--        local startPoint = self._selectFrame:convertTouchToNodeSpace(touch)
--        if cc.rectContainsPoint(self._selectFrame:getBoundingBox(),startPoint) then        	
--            return true
--        end
--        return false
--    end
--
--    local function onTouchMoved(touch, event)
--
--    end
--
--    local function onTouchEnded(touch, event)
--        local flag = self._selectFrame:isVisible()
--        if not flag then
--            self._selectFrame:setVisible(true)
--        end
--    end
--
--    local listener = cc.EventListenerTouchOneByOne:create()
--    listener:registerScriptHandler(onTouchBegan,cc.Handler.EVENT_TOUCH_BEGAN )
--    listener:registerScriptHandler(onTouchMoved,cc.Handler.EVENT_TOUCH_MOVED )
--    listener:registerScriptHandler(onTouchEnded,cc.Handler.EVENT_TOUCH_ENDED )
--    local eventDispatcher = self:getEventDispatcher()
--    eventDispatcher:addEventListenerWithSceneGraphPriority(listener, self)
end

function AttributeNode:update(data)
    --data = {type = "攻击",value = 100 ,quality = 0}
    if data then  	
        local enCAT = enCharacterAttrType
        self._attribute:setString(enCAT:getTypeName(data.type).."+"..data.value)
        self._attribute:setColor(Quality_Color[data.quality])
        self._point:setVisible(true)
    else
        self._attribute:setString("空")
        self._attribute:setColor(Quality_Color[1])
        --self._point:setVisible(false)
    end
end

function AttributeNode:setFrameTouch(flag)
    self.btn_selectFrame:setVisible(flag)
end

function AttributeNode:setFrameShow(flag)
	self._selectFrame:setVisible(flag)
end

--function AttributeNode:updateFrame(data)
--    data = {flag = false}
--    self._selectFrame:setVisible(data.flag)
--end