EquipinfoItem = EquipinfoItem or class("EquipinfoItem",function()
	return cc.Node:create()
end)

function EquipinfoItem:create()
	local node = EquipinfoItem:new()
	return node
end

function EquipinfoItem:ctor()

    self.itemFrame = nil
    self.itemIcon = nil
    self.txt_level = nil
    self.txt_name = nil

	self:initUI()
end

function EquipinfoItem:initUI()
	local equipinfoItem = cc.CSLoader:createNode("dxyCocosStudio/csd/ui/roleinfo/equipinfoItem.csb")
	self:addChild(equipinfoItem)
	
	self.itemFrame = equipinfoItem:getChildByName("itemFrame")
	self.itemIcon = equipinfoItem:getChildByName("icon")
    self.txt_level = equipinfoItem:getChildByName("level")
    self.txt_name = equipinfoItem:getChildByName("name")
    self.pic_quality = equipinfoItem:getChildByName("quality")
    
    self.txt_level:setString("")
    self.txt_name:setString("")
end

function EquipinfoItem:update(data)
    self.m_data = data
    if self.m_data then
        self.txt_name:setVisible(true)
        self.txt_level:setVisible(true)
        self.itemIcon:setVisible(true)
        self.pic_quality:setVisible(true)
        
        self.txt_name:setString(self.m_data.config.Name)
        self.txt_name:setColor(Quality_Color[self.m_data.config.Quality])
        self.txt_level:setString("+"..self.m_data.lv)
        self.itemIcon:setTexture("Icon/"..self.m_data.config.Icon..".png")
        self.pic_quality:setTexture(self.m_data:getQualityIcon())
    else
        self.txt_name:setString("")
        self.txt_level:setString("")
        self.itemIcon:setVisible(false)
        self.pic_quality:setVisible(false)
    end
end

function EquipinfoItem:setBG(name)
    local path = "dxyCocosStudio/png/roleinfo/newroleinfo/equip/"
    if name then
        self.itemFrame:setTexture(path..name..".png")
    end
end