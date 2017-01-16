SpiritInfoItem = SpiritInfoItem or class("SpiritInfoItem",function()
	local path = "dxyCocosStudio/png/spirit/frame.png"
    return ccui.Button:create(path,path,path)
end)

function SpiritInfoItem:create()
    local node = SpiritInfoItem:new()
    return node
end

function SpiritInfoItem:ctor()
	self._csb = nil
	
	self:initUI()
	self:initEvent()
end

function SpiritInfoItem:initUI()
	self._csb = cc.CSLoader:createNode("dxyCocosStudio/csd/ui/roleinfo/spiritInfoItem.csb")
	self:addChild(self._csb)
	
    local x = self:getContentSize().width / 2
    local y = self:getContentSize().height / 2 

    self._csb:setPosition(cc.p(x,y))
    
    self.lv = self._csb:getChildByName("lv")
    self.icon = self._csb:getChildByName("Icon")
    self.quality = self._csb:getChildByName("quality")
    
end

function SpiritInfoItem:initEvent()
	
end

function SpiritInfoItem:setParent(parent)
	self.parent = parent
end

function SpiritInfoItem:update(data)
	self.m_data = data
	if self.m_data then
	    self.icon:setVisible(true)
        self.icon:setTexture(self.m_data:getIcon())
        self.lv:setVisible(true)
        self.lv:setString("LV:"..self.m_data.config.Lv)
        self.quality:setVisible(true)
        self.quality:setTexture(self.m_data:getSpiritQualityIcon())
--       self.parent.txt_name:setString(self.m_data.config.Name.." +"..self.m_data.lv)
--       self.parent.txt_name:setColor(Quality_Color[self.m_data.config.Quality])
--       self.parent.txt_atk:setString(self.m_data.attr_solt[1].value)
--       self.parent.txt_def:setString(self.m_data.attr_solt[2].value)
--       self.parent.txt_hp:setString(self.m_data.attr_solt[3].value)
	else
        self.icon:setVisible(false)
        self.lv:setString("")
        self.quality:setVisible(false)
--        self.parent.txt_name:setString("")
--        self.parent.txt_atk:setString(0)
--        self.parent.txt_def:setString(0)
--        self.parent.txt_hp:setString(0)
	end
end