SpiritItem = SpiritItem or class("SpiritItem",function()
    local path = "dxyCocosStudio/png/roleinfo/newroleinfo/equip/clothes.png"
    return ccui.Button:create(path,path,path)
end)

function SpiritItem:create()
	local node = SpiritItem:new()
	return node
end

function SpiritItem:ctor()
    self._csbNode = nil
    self.frame = nil
    self.icon = nil
    self.txt_lv = nil
    self.m_data = nil
        
	self:initUI()
	self:initEvent()
end

function SpiritItem:initUI()
	self._csbNode = cc.CSLoader:createNode("dxyCocosStudio/csd/ui/spirit/spiritItem.csb")
	self:addChild(self._csbNode)
	
    local x = self:getContentSize().width / 2
    local y = self:getContentSize().height / 2 

    self._csbNode:setPosition(cc.p(x,y))
	
	self.frame = self._csbNode:getChildByName("Frame")
	self.quality = self._csbNode:getChildByName("quality")
	self.icon = self._csbNode:getChildByName("icon")
	self.name = self._csbNode:getChildByName("name")
	self.txt_lv = self._csbNode:getChildByName("lvTxt")
	
end

function SpiritItem:initEvent()
    self:addTouchEventListener(function(target,type)
        if type == 2 and self.m_data then
            print("-------------------" .. self.m_data.idx)
            SoundsFunc_playSounds(SoundsType.OPEN_PAGE,false)
            --zzc.CharacterController:request_UseSpirit(self.m_data.idx)
            zzm.CharacterModel:setCurSpiritData(self.m_data)
            dxyDispatcher_dispatchEvent(dxyEventType.Spirit_Layer,Spirit_Layer_Type.spirit_detail)
        end
    end)
end

function SpiritItem:getFrameSize()
    local size = self.frame:getContentSize()
    return size
end

function SpiritItem:update(data)
	self.m_data = data
	if self.m_data then
        self.name:setString("")
        self.quality:setVisible(true)
        self.quality:setTexture(self.m_data:getSpiritQualityIcon())
        self.icon:setVisible(true)
        self.icon:setTexture(self.m_data:getIcon())
        self.txt_lv:setString("+"..self.m_data.lv)
        self.txt_lv:setVisible(not (self.m_data.lv == 0))
	else
	    self.name:setString("")
        self.quality:setVisible(false)
		self.icon:setVisible(false)
		self.txt_lv:setString("")
	end
end

function SpiritItem:updateOnlyData(data)
    self.name:setString("")
    self.quality:setVisible(true)
    self.quality:setTexture(data:getSpiritQualityIcon())
    self.icon:setVisible(true)
    self.icon:setTexture(data:getIcon())
    self.txt_lv:setString("+"..data.lv)
    self.txt_lv:setVisible(not (data.lv == 0))
end

--更新副本可能掉落数据
function SpiritItem:updateCopyData(config)
    self.name:setString("")
    self.quality:setVisible(true)
    self.quality:setTexture(self:getSpiritQualityIcon(config))
    self.icon:setVisible(true)
    self.icon:setTexture(self:getIcon(config))
    self.txt_lv:setString("")
end

--物品Icon
function SpiritItem:getIcon(config)
    local path = "Icon/"
    if config.Icon == "String" or config.Icon == nil then
        path = path .. "props_yao.png"
    else
        path = path .. config.Icon .. ".png"
    end
    return path
end

--器灵品质Icon
function SpiritItem:getSpiritQualityIcon(config)
    local path = "dxyCocosStudio/png/equip/spiritQuality_"
    path = path..config.Quality..".png"
    return path
end

function SpiritItem:setLv(lv)
    self.txt_lv:setString("+"..lv)
end