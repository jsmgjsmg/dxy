EquipItem = EquipItem or class("EquipItem",function()
    return cc.Node:create()
end)

function EquipItem:create()
    local node = EquipItem:new()
    return node
end

function EquipItem:ctor()
    self.equipFrame = nil

    self:initUI()
end

function EquipItem:initUI()
    local equipItem = cc.CSLoader:createNode("dxyCocosStudio/csd/ui/equip/equipItem.csb")
    self:addChild(equipItem)

    self.equipFrame = equipItem:getChildByName("equipFrame")
end

function EquipItem:getFrameSize()
    local size = self.equipFrame:getContentSize()
    return size
end