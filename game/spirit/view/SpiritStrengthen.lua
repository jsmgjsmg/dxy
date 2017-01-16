SpiritStrengthen = SpiritStrengthen or class("SpiritStrengthen",function()
	return cc.Layer:create()
end)

require("game.spirit.view.SpiritItem")

function SpiritStrengthen:create()
	local layer = SpiritStrengthen:new()
	return layer
end

function SpiritStrengthen:ctor()
    self._csbNode = nil
    
    self.m_data = nil
    
    self.left_icon = nil
    self.right_icon = nil
    
    self.txt_left_name = nil
    self.txt_right_name = nil
    self.txt_left_strenlv = nil
    self.txt_right_strenlv = nil
    
    self.txt_needReiki = nil
    self.txt_amulet = nil
    
    self._sendData = {}
    self._sendData.isUse = 0
    self._sendData.type = 0
    self._sendData.idx = 0
    
    self.btn_confirm = ccui.Button
    self.ckb_amulet = ccui.CheckBox
    
	self:initUI()
	dxyExtendEvent(self)
end

function SpiritStrengthen:initUI()
	self._csbNode = cc.CSLoader:createNode("dxyCocosStudio/csd/ui/spirit/spiritStrengthen.csb")
	self:addChild(self._csbNode)
	
	self.bg = self._csbNode:getChildByName("frame")
	
    self.btn_confirm = self._csbNode:getChildByName("confirmBtn")
    self.ckb_amulet = self._csbNode:getChildByName("amuletCkb")
    
    self.left_icon = self._csbNode:getChildByName("left_icon")
    self.right_icon = self._csbNode:getChildByName("right_icon")
    
    self.txt_left_name = self._csbNode:getChildByName("leftTxt")
    self.txt_right_name = self._csbNode:getChildByName("rightTxt")
    self.txt_left_strenlv = self._csbNode:getChildByName("leftStrenLevel")
    self.txt_right_strenlv = self._csbNode:getChildByName("rightStrenLevel")
    
    self.txt_needReiki = self._csbNode:getChildByName("needReiki")
    self.txt_needGold = self._csbNode:getChildByName("needGold")
    self.txt_amulet = self._csbNode:getChildByName("amuletTxt")
	
end

function SpiritStrengthen:initEvent()

    dxyDispatcher_addEventListener(dxyEventType.Spirit_Strength,self,self.resetData)
    
    -- 拦截
    dxySwallowTouches(self,self.bg)
    
    self.btn_confirm:addTouchEventListener(function(target,type)
        if type == 2 then
            zzc.CharacterController:request_Strengthen(self._sendData)
            zzm.TalkingDataModel:onEvent(EumEventId.SPIRIT_STRENGTHEN,{})
        end
    end)
    
    self.ckb_amulet:addEventListener(function(target,type)
        if type == ccui.CheckBoxEventType.selected then
            self._sendData.isUse = 1
        else
        	self._sendData.isUse = 0
        end
    end)    
end

function SpiritStrengthen:removeEvent()
    dxyDispatcher_removeEventListener(dxyEventType.Spirit_Strength,self,self.resetData)
end

function SpiritStrengthen:update(data,type)
	self.m_data = data
    self._sendData.type = type
    self._sendData.idx = self.m_data.idx
    self:resetData(self.m_data)
end

function SpiritStrengthen:resetData(data)
    local baseRate = zzm.SpiritModel:getStrengthBaseRote()
    local strengthlvCoefficient
    local amulet
    local gold
    local lvCoefficient = zzm.SpiritModel:findCoefficientBySpiritLv(data.config.Lv)
    local qualityCoefficient = zzm.SpiritModel:findCoefficientBySpiritQuality(data.config.Quality)
    
    require("game.spirit.view.SpiritItem")
    local leftIcon = SpiritItem:create()
    leftIcon:update(data)
    self.left_icon:addChild(leftIcon)
    
    local rightIcon = SpiritItem:create()
    rightIcon:update(data)
    self.right_icon:addChild(rightIcon)
    
    self.txt_left_name:setString(data.config.Name)
    self.txt_left_name:setColor(Quality_Color[data.config.Quality])
    self.txt_right_name:setString(data.config.Name)
    self.txt_right_name:setColor(Quality_Color[data.config.Quality])
    self.txt_left_strenlv:setString("+"..data.lv)
    if data.lv >= zzm.SpiritModel:getMaxStrengthenLvByQuality(data.config.Quality) then
        self.txt_right_strenlv:setString("+"..data.lv)
        rightIcon:setLv(data.lv)
        strengthlvCoefficient = 0
        amulet = 0
        gold = 0
    else       
        self.txt_right_strenlv:setString("+"..data.lv+1)
        rightIcon:setLv(data.lv+1)
        strengthlvCoefficient = zzm.SpiritModel:findCoefficientByStrengthLv(data.lv + 1)
        amulet = zzm.SpiritModel:getNextLvAmulet(data.lv+1)
        gold = math.ceil(MagicSoulConfigProvider:getMagicSoulStrengthenGold() * MagicSoulConfigProvider:getMagicSoulStrengthenBaseGold() * MagicSoulConfigProvider:getMagicSoulLvAdd(data.config.Lv) * MagicSoulConfigProvider:getMagicSoulStrengthenLvAdd(data.lv + 1) * MagicSoulConfigProvider:getMagicSoulQualityAdd(data.config.Quality))
    end
    self.txt_amulet:setString("×"..amulet)
    self.txt_needGold:setString("×"..gold)
    self.txt_needReiki:setString("×"..math.floor(baseRate * strengthlvCoefficient * lvCoefficient * qualityCoefficient))
end