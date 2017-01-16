SpiritDetail = SpiritDetail or class("SpiritDetail",function()
	return cc.Layer:create()
end)

Spirit_Detail_Type = {
    equiped = 1,
    noequip = 2,
    compare = 3,
}
require("game.spirit.view.SpiritAttribute")
require("game.spirit.view.SpiritItem")

function SpiritDetail:create()
	local layer = SpiritDetail:new()
	return layer
end

function SpiritDetail:ctor()
    self._csbNode = nil
    
    self.m_data = nil
    
    self.equiped_posx = 0
    self.equiped_posy = 0
    self.noequip_posx = 0
    self.noequip_posy = 0

    self.equipedNode = nil
    self.left_iconNode = nil
    self.txt_equiped_name = nil
    self.txt_equiped_level = nil
    self.btn_equiped_strengthen = ccui.Button
    self.btn_equiped_unload = ccui.Button
    self.leftAttribute = {}
    
    self.noequipNode = nil
    self.right_iconNode = nil
    self.txt_noequip_name = nil
    self.txt_noequip_level = nil
    self.btn_noequip_equip = ccui.Button
    self.btn_noequip_resolve = ccui.Button
    self.btn_noequip_strengthen = ccui.Button
    self.rightAttribute = {}

	self:initUI()
	dxyExtendEvent(self)
end

function SpiritDetail:initUI()
	self._csbNode = cc.CSLoader:createNode("dxyCocosStudio/csd/ui/spirit/spiritDetail.csb")
	self:addChild(self._csbNode)
	
	self.equipedNode = self._csbNode:getChildByName("equipedNode")
	self.left_iconNode = self.equipedNode:getChildByName("iconNode")
    self.txt_equiped_name = self.equipedNode:getChildByName("nameTxt")
    self.txt_equiped_level = self.equipedNode:getChildByName("levelTxt")
    self.btn_equiped_strengthen = self.equipedNode:getChildByName("strengthenBtn")
    self.btn_equiped_unload = self.equipedNode:getChildByName("unloadBtn")
    self.txt_equiped_skill = self.equipedNode:getChildByName("skillTxt")
    for index=1, 3 do
        self.leftAttribute[index] = self.equipedNode:getChildByName("attribute_"..index)
    end
	
	self.noequipNode = self._csbNode:getChildByName("noequipNode")
	self.right_iconNode = self.noequipNode:getChildByName("iconNode")
    self.txt_noequip_name = self.noequipNode:getChildByName("nameTxt")
    self.txt_noequip_level = self.noequipNode:getChildByName("levelTxt")
    self.btn_noequip_equip = self.noequipNode:getChildByName("equipBtn")
    self.btn_noequip_resolve = self.noequipNode:getChildByName("resolveBtn")
    self.btn_noequip_strengthen = self.noequipNode:getChildByName("strengthenBtn")
    self.txt_noequip_skill = self.noequipNode:getChildByName("skillTxt")
    for index=1, 3 do
        self.rightAttribute[index] = self.noequipNode:getChildByName("attribute_"..index)
    end
    
    self.equiped_posx,self.equiped_posy = self.equipedNode:getPosition()
    self.noequip_posx,self.noequip_posy = self.noequipNode:getPosition()
	
end

function SpiritDetail:initEvent()
    -- 拦截
    local function onTouchBegan(touch, event)

        return true
    end

    local function onTouchMoved(touch, event)

    end

    local function onTouchEnded(touch, event)
        self:removeFromParent()
    end

    local listener = cc.EventListenerTouchOneByOne:create()
    listener:registerScriptHandler(onTouchBegan,cc.Handler.EVENT_TOUCH_BEGAN )
    listener:registerScriptHandler(onTouchMoved,cc.Handler.EVENT_TOUCH_MOVED )
    listener:registerScriptHandler(onTouchEnded,cc.Handler.EVENT_TOUCH_ENDED )
    local eventDispatcher = self:getEventDispatcher()
    eventDispatcher:addEventListenerWithSceneGraphPriority(listener, self)
    listener:setSwallowTouches(true)
    
    --已装备器灵强化
    self.btn_equiped_strengthen:addTouchEventListener(function(target,type)
        if type == 2 then
            SoundsFunc_playSounds(SoundsType.UNIVERSAL_BTN,false)
            if zzm.CharacterModel:getSpirit().config.Quality > 3 then           	
                zzm.CharacterModel:setCurStrengthSpirit(zzm.CharacterModel:getSpirit(),enBackpackType.SPIRIT)
                dxyDispatcher_dispatchEvent(dxyEventType.Spirit_Layer,Spirit_Layer_Type.spirit_strengthen)
            else
                dxyFloatMsg:show("紫色品质以下不能进行强化")
            end
        end
    end)
    
    --已装备器灵卸下
    self.btn_equiped_unload:addTouchEventListener(function(target,type)
        if type == 2 then
            SoundsFunc_playSounds(SoundsType.UNIVERSAL_BTN,false)
            zzc.CharacterController:request_CastSpirit(self.m_data.config.TypeSub)
            self:removeFromParent()
        end
    end)
    
    
    --未装备器灵装备
    self.btn_noequip_equip:addTouchEventListener(function(target,type)
        if type == 2 then
            SoundsFunc_playSounds(SoundsType.USE_GOODS,false)
            zzc.CharacterController:request_UseSpirit(self.m_data.idx)
            self:removeFromParent()
        end
    end)
        
    --未装备器灵分解
    self.btn_noequip_resolve:addTouchEventListener(function(target,type)
        if type == 2 then
            SoundsFunc_playSounds(SoundsType.RESOLVE_SPIRIT,false)
            zzc.CharacterController:request_oneResolve(self.m_data.idx)
            self:removeFromParent()
            zzm.TalkingDataModel:onEvent(EumEventId.SPIRIT_RESOLVE,{})
        end
    end)

    --未装备器灵强化
    self.btn_noequip_strengthen:addTouchEventListener(function(target,type)
        if type == 2 then
            SoundsFunc_playSounds(SoundsType.UNIVERSAL_BTN,false)
            if self.m_data.config.Quality > 3 then 
                zzm.CharacterModel:setCurStrengthSpirit(self.m_data,enBackpackType.BACKPACK)
                dxyDispatcher_dispatchEvent(dxyEventType.Spirit_Layer,Spirit_Layer_Type.spirit_strengthen)
            else
                dxyFloatMsg:show("紫色品质以下不能进行强化")
            end
        end
    end)     
end

function SpiritDetail:removeEvent()
	
end

function SpiritDetail:update(data)
    self:reset()
	self.m_data = data
    if self.m_data.backpackType == enBackpackType.BACKPACK then
        if zzm.CharacterModel:getSpirit() then
            self:showView(Spirit_Detail_Type.compare)
            self:setSpiritData(Spirit_Detail_Type.compare)
        else
            self:showView(Spirit_Detail_Type.noequip)
            self:setSpiritData(Spirit_Detail_Type.noequip)
        end
    elseif self.m_data.backpackType == enBackpackType.SPIRIT then
        self:showView(Spirit_Detail_Type.equiped)
        self:setSpiritData(Spirit_Detail_Type.equiped)
    else
		
	end
end

function SpiritDetail:showView(type)
	self.equipedNode:setVisible(false)
	self.noequipNode:setVisible(false)
	
    if type == Spirit_Detail_Type.equiped then
        self.equipedNode:setVisible(true)
        self.equipedNode:setPosition(cc.p(0,0))
	elseif type == Spirit_Detail_Type.noequip then
        self.noequipNode:setVisible(true)
        self.noequipNode:setPosition(cc.p(0,0))
	elseif type == Spirit_Detail_Type.compare then
        self.equipedNode:setVisible(true)
        self.noequipNode:setVisible(true)
        self.equipedNode:setPosition(cc.p(self.equiped_posx,self.equiped_posy))
        self.noequipNode:setPosition(cc.p(self.noequip_posx,self.noequip_posy))
	end
end

function SpiritDetail:setSpiritData(type)
    if type == Spirit_Detail_Type.equiped then
        if self.m_data.config.Quality < 4 then
        	self.btn_equiped_strengthen:setVisible(false)
        else
            self.btn_equiped_strengthen:setVisible(true)
        end
        local node = SpiritItem:create()
        self.left_iconNode:addChild(node)
        node:updateOnlyData(self.m_data)
        if self.m_data.lv > 0 then
        	self.txt_equiped_name:setString(self.m_data.config.Name.." +"..self.m_data.lv)
        else          
            self.txt_equiped_name:setString(self.m_data.config.Name)
        end
        self.txt_equiped_name:setColor(Quality_Color[self.m_data.config.Quality])
        self.txt_equiped_level:setString(self.m_data.config.Lv)
        if self.m_data.config.SkillID then       	
            self.txt_equiped_skill:setString(SkillConfig:getSkillConfigById(self.m_data.config.SkillID).Info)
        else
            self.txt_equiped_skill:setString("")
        end
        for index=1, 3 do
        	local node = SpiritAttribute:create()
            self.leftAttribute[index]:addChild(node)
            node:update(self.m_data.attr_solt[index])
            node:showPoint(SpiritAttribute_Point_Type.left)
        end
    elseif type == Spirit_Detail_Type.noequip then
        if self.m_data.config.Quality < 4 then
            self.btn_noequip_strengthen:setVisible(false)
        else
            self.btn_noequip_strengthen:setVisible(true)
        end
        local node = SpiritItem:create()
        self.right_iconNode:addChild(node)
        node:updateOnlyData(self.m_data)
        if self.m_data.lv > 0 then
            self.txt_noequip_name:setString(self.m_data.config.Name.." +"..self.m_data.lv)
        else          
            self.txt_noequip_name:setString(self.m_data.config.Name)
        end
        self.txt_noequip_name:setColor(Quality_Color[self.m_data.config.Quality])
        self.txt_noequip_level:setString(self.m_data.config.Lv)
        if self.m_data.config.SkillID then          
            self.txt_noequip_skill:setString(SkillConfig:getSkillConfigById(self.m_data.config.SkillID).Info)
        else
            self.txt_noequip_skill:setString("")
        end
        for index=1, 3 do
            local node = SpiritAttribute:create()
            self.rightAttribute[index]:addChild(node)
            node:update(self.m_data.attr_solt[index])
            node:showPoint(SpiritAttribute_Point_Type.right)
        end
    elseif type == Spirit_Detail_Type.compare then
        --背包中的器灵
        if self.m_data.config.Quality < 4 then
            self.btn_noequip_strengthen:setVisible(false)
        else
            self.btn_noequip_strengthen:setVisible(true)
        end
        local node = SpiritItem:create()
        self.right_iconNode:addChild(node)
        node:updateOnlyData(self.m_data)
        if self.m_data.lv > 0 then
            self.txt_noequip_name:setString(self.m_data.config.Name.." +"..self.m_data.lv)
        else          
            self.txt_noequip_name:setString(self.m_data.config.Name)
        end
        self.txt_noequip_name:setColor(Quality_Color[self.m_data.config.Quality])
        self.txt_noequip_level:setString(self.m_data.config.Lv)
        if self.m_data.config.SkillID then          
            self.txt_noequip_skill:setString(SkillConfig:getSkillConfigById(self.m_data.config.SkillID).Info)
        else
            self.txt_noequip_skill:setString("")
        end
        for index=1, 3 do
            local node = SpiritAttribute:create()
            self.rightAttribute[index]:addChild(node)
            node:update(self.m_data.attr_solt[index])
            node:showPoint(SpiritAttribute_Point_Type.right)
        end
        
        --已装备的器灵
        local data = zzm.CharacterModel:getSpirit()
        
        if data.config.Quality < 4 then
            self.btn_equiped_strengthen:setVisible(false)
        else
            self.btn_equiped_strengthen:setVisible(true)
        end
        
        node = SpiritItem:create()
        self.left_iconNode:addChild(node)
        node:updateOnlyData(data)
        if data.lv > 0 then
            self.txt_equiped_name:setString(data.config.Name.." +"..data.lv)
        else          
            self.txt_equiped_name:setString(data.config.Name)
        end
        self.txt_equiped_name:setColor(Quality_Color[data.config.Quality])
        self.txt_equiped_level:setString(data.config.Lv)
        if data.config.SkillID then          
            self.txt_equiped_skill:setString(SkillConfig:getSkillConfigById(data.config.SkillID).Info)
        else
            self.txt_equiped_skill:setString("")
        end
        for index=1, 3 do
            local node = SpiritAttribute:create()
            self.leftAttribute[index]:addChild(node)
            node:update(data.attr_solt[index])
            node:showPoint(SpiritAttribute_Point_Type.left)
        end
    end
end

function SpiritDetail:reset()
	for index=1, 3 do
        self.leftAttribute[index]:removeAllChildren()
        self.rightAttribute[index]:removeAllChildren()
	end
    self.left_iconNode:removeAllChildren()
    self.right_iconNode:removeAllChildren()
end