SpiritAttribute = SpiritAttribute or class("SpiritAttribute",function()
	return cc.Layer:create()
end)

SpiritAttribute_Point_Type ={
    left = 1,
    right = 2,
}

function SpiritAttribute:create()
	local layer = SpiritAttribute:new()
	return layer
end

function SpiritAttribute:ctor()
    self._csbNode = nil
    
    self.left_point = nil
    self.right_point = nil
    self.txt_attribute = nil
    
	self:initUI()
end

function SpiritAttribute:initUI()
	self._csbNode = cc.CSLoader:createNode("dxyCocosStudio/csd/ui/spirit/spiritAttribute.csb")
	self:addChild(self._csbNode)
	
	self.left_point = self._csbNode:getChildByName("left_point")
	self.right_point = self._csbNode:getChildByName("right_point")
	self.txt_attribute = self._csbNode:getChildByName("attributeTxt")
end

function SpiritAttribute:update(data)
    --data = {type = "攻击",value = 100}
    if data then    
        local enCAT = enCharacterAttrType
        self.txt_attribute:setString(enCAT:getTypeName(data.type)..":+"..data.value)
        self.left_point:setVisible(true)
        self.right_point:setVisible(true)
    else
        self._attribute:setString("空")
    end
end

function SpiritAttribute:showPoint(type)
    if type == SpiritAttribute_Point_Type.left then
        self.left_point:setVisible(false)
    elseif type == SpiritAttribute_Point_Type.right then
        self.right_point:setVisible(false)
	end
end