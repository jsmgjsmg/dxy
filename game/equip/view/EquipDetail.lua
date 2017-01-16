Equip_Detail_Type = {
    equiped = 1,
    noequip = 2,
    compare = 3,
}

EquipDetail = EquipDetail or class("EquipDetail",function()
	return cc.Layer:create()
end)

function EquipDetail:create()
	local layer = EquipDetail:new()
	return layer
end

function EquipDetail:ctor()

    self.m_data = nil

    self.equipedNode = nil
    self.btn_equiped_devour = ccui.Button
    self.btn_equiped_unload = ccui.Button
    self.pic_equiped_quality = nil
    self.pic_equiped_icon = nil
    self.txt_equiped_name = nil
    self.txt_equiped_strengLv = nil
    self.txt_equiped_needLv = nil
    self.txt_equiped_baseAttrValue = nil
    self.bar_equiped_growth = ccui.LoadingBar
    self.txt_equiped_growth = nil
    self.equiped_property = {}
    
    self.noequipNode = nil
    self.btn_noequip_equip = ccui.Button
    self.btn_noequip_sell = ccui.Button
    self.pic_noequip_quality = nil
    self.pic_noequip_icon = nil
    self.txt_noequip_name = nil
    self.txt_noequip_strengLv = nil
    self.txt_noequip_needLv = nil
    self.txt_noequip_baseAttrValue = nil
    self.bar_noequip_growth = ccui.LoadingBar
    self.txt_noequip_growth = nil
    self.noequip_property = {}
    
    self.compareNode = nil
    self.compare_equiped = nil
    self.btn_compare_smelt = ccui.Button
    self.btn_compare_devour = ccui.Button
    self.pic_compare_equiped_quality = nil
    self.pic_compare_equiped_icon = nil
    self.txt_compare_equiped_name = nil
    self.txt_compare_equiped_strengLv = nil
    self.txt_compare_equiped_needLv = nil
    self.txt_compare_equiped_baseAttrValue = nil
    self.bar_compare_equiped_growth = ccui.LoadingBar
    self.txt_compare_equiped_growth = nil
    self.compare_equiped_property = {}
    
    self.compare_noequip = nil
    self.btn_compare_equip = ccui.Button
    self.btn_compare_sell = ccui.Button
    self.pic_compare_noequip_quality = nil
    self.pic_compare_noequip_icon = nil
    self.txt_compare_noequip_name = nil
    self.txt_compare_noequip_strengLv = nil
    self.txt_compare_noequip_needLv = nil
    self.txt_compare_noequip_baseAttrValue = nil
    self.bar_compare_noequip_growth = ccui.LoadingBar
    self.txt_compare_noequip_growth = nil
    self.compare_noequip_property = {}
    
	self:initUI()
	self:initEvent()
end

function EquipDetail:initUI()
	local equipDetail = cc.CSLoader:createNode("dxyCocosStudio/csd/ui/equip/equipDetail.csb")
	self:addChild(equipDetail)
	
	self.panel = equipDetail:getChildByName("Panel")
	
	self.equipedNode = equipDetail:getChildByName("equipedNode")
	self.btn_equiped_devour = self.equipedNode:getChildByName("devourBtn")
	self.btn_equiped_unload = self.equipedNode:getChildByName("unloadBtn")
    self.pic_equiped_quality = self.equipedNode:getChildByName("Icon"):getChildByName("quality")
    self.pic_equiped_icon = self.equipedNode:getChildByName("Icon"):getChildByName("Icon")
	self.txt_equiped_name = self.equipedNode:getChildByName("Name")
	self.txt_equiped_strengLv = self.equipedNode:getChildByName("strengthenLevel")
	self.txt_equiped_needLv = self.equipedNode:getChildByName("needLevelTxt")
    self.txt_equiped_baseAttrValue = self.equipedNode:getChildByName("basePropertyTxt")
    local node = self.equipedNode:getChildByName("growthNode")
    self.bar_equiped_growth = node:getChildByName("growthBar")
    self.txt_equiped_growth = node:getChildByName("growthExp")
    for index=1, 6 do
        self.equiped_property[index] = self.equipedNode:getChildByName("property_"..index)
    end
	
	self.noequipNode = equipDetail:getChildByName("noequipNode")
	self.btn_noequip_equip = self.noequipNode:getChildByName("equipBtn")
	self.btn_noequip_sell = self.noequipNode:getChildByName("sellBtn")
    self.pic_noequip_quality = self.noequipNode:getChildByName("Icon"):getChildByName("quality")
    self.pic_noequip_icon = self.noequipNode:getChildByName("Icon"):getChildByName("Icon")
    self.txt_noequip_name = self.noequipNode:getChildByName("Name")
    self.txt_noequip_strengLv = self.noequipNode:getChildByName("strengthenLevel")
    self.txt_noequip_needLv = self.noequipNode:getChildByName("needLevelTxt")
    self.txt_noequip_baseAttrValue = self.noequipNode:getChildByName("basePropertyTxt")
    node = self.noequipNode:getChildByName("growthNode")
    self.bar_noequip_growth = node:getChildByName("growthBar")
    self.txt_noequip_growth = node:getChildByName("growthExp")
    for index=1, 6 do
        self.noequip_property[index] = self.noequipNode:getChildByName("property_"..index)
    end
	
	self.compareNode = equipDetail:getChildByName("compareNode")
    self.compare_equiped = self.compareNode:getChildByName("equiped")
    self.btn_compare_smelt = self.compare_equiped:getChildByName("smeltBtn")
    self.btn_compare_devour = self.compare_equiped:getChildByName("devourBtn")
    self.txt_compare_equiped_name = self.compare_equiped:getChildByName("Name")
    self.pic_compare_equiped_quality = self.compare_equiped:getChildByName("Icon"):getChildByName("quality")
    self.pic_compare_equiped_icon = self.compare_equiped:getChildByName("Icon"):getChildByName("Icon")
    self.txt_compare_equiped_strengLv = self.compare_equiped:getChildByName("strengthenLevel")
    self.txt_compare_equiped_needLv = self.compare_equiped:getChildByName("needLevelTxt")
    self.txt_compare_equiped_baseAttrValue = self.compare_equiped:getChildByName("basePropertyTxt")
    node = self.compare_equiped:getChildByName("growthNode")
    self.bar_compare_equiped_growth = node:getChildByName("growthBar")
    self.txt_compare_equiped_growth = node:getChildByName("growthExp")
    for index=1, 6 do
        self.compare_equiped_property[index] = self.compare_equiped:getChildByName("property_"..index)
    end
    
    self.compare_noequip = self.compareNode:getChildByName("noequip")
    self.btn_compare_equip = self.compare_noequip:getChildByName("equipBtn")
    self.btn_compare_sell = self.compare_noequip:getChildByName("sellBtn")
    self.pic_compare_noequip_quality = self.compare_noequip:getChildByName("Icon"):getChildByName("quality")
    self.pic_compare_noequip_icon = self.compare_noequip:getChildByName("Icon"):getChildByName("Icon")
    self.txt_compare_noequip_name = self.compare_noequip:getChildByName("Name")
    self.txt_compare_noequip_strengLv = self.compare_noequip:getChildByName("strengthenLevel")
    self.txt_compare_noequip_needLv = self.compare_noequip:getChildByName("needLevelTxt")
    self.txt_compare_noequip_baseAttrValue = self.compare_noequip:getChildByName("basePropertyTxt")
    node = self.compare_noequip:getChildByName("growthNode")
    self.bar_compare_noequip_growth = node:getChildByName("growthBar")
    self.txt_compare_noequip_growth = node:getChildByName("growthExp")
    for index=1, 6 do
        self.compare_noequip_property[index] = self.compare_noequip:getChildByName("property_"..index)
    end
end

function EquipDetail:initEvent()

--人物装备吞噬
    self.btn_equiped_devour:addTouchEventListener(function(target,type)
        if type == 2  then
            SoundsFunc_playSounds(SoundsType.UNIVERSAL_BTN,false)
            dxyDispatcher_dispatchEvent(dxyEventType.RoleView_OpenSubView,CHARACTER_SUB_TYPE.SWALLOW)
            self:removeFromParent()
        end
    end)
    
    
--人物装备卸下
    self.btn_equiped_unload:addTouchEventListener(function(target,type)
        if type == 2  then
            SoundsFunc_playSounds(SoundsType.USE_GOODS,false)
            zzc.CharacterController:request_CastEquip(self.m_data.config.TypeSub)
            self:removeFromParent()
        end
    end)
    
   --背包装备装备
    self.btn_noequip_equip:addTouchEventListener(function(target,type)
        if type == 2 then
            SoundsFunc_playSounds(SoundsType.USE_GOODS,false)
            zzc.CharacterController:request_UseItem(self.m_data.idx)
            self:removeFromParent()
        end
    end)
    --背包装备出售
    self.btn_noequip_sell:addTouchEventListener(function(target,type)
        if type == 2 then
            SoundsFunc_playSounds(SoundsType.UNIVERSAL_BTN,false)
            require("game.equip.view.EquipSellConfirm")
            local layer = EquipSellConfirm:create()
            layer:update(self.m_data)
            SceneManager:getCurrentScene():addChild(layer)
            self:removeFromParent()
        end
    end)
    
    --装备对比熔炼
    self.btn_compare_smelt:addTouchEventListener(function(target,type)
        if type == 2 then
            SoundsFunc_playSounds(SoundsType.UNIVERSAL_BTN,false)
            dxyDispatcher_dispatchEvent(dxyEventType.RoleView_OpenSubView,CHARACTER_SUB_TYPE.MELTING)
            --self:removeFromParent()
        end
    end)
    
    --装备对比吞噬
    self.btn_compare_devour:addTouchEventListener(function(target,type)
        if type == 2 then
            SoundsFunc_playSounds(SoundsType.UNIVERSAL_BTN,false)
            dxyDispatcher_dispatchEvent(dxyEventType.RoleView_OpenSubView,CHARACTER_SUB_TYPE.SWALLOW)
            self:removeFromParent()
        end
    end)
    
    --装备对比装备
    self.btn_compare_equip:addTouchEventListener(function(target,type)
        if type == 2 then
            SoundsFunc_playSounds(SoundsType.USE_GOODS,false)
            zzc.CharacterController:request_UseItem(self.m_data.idx)
            self:removeFromParent()
        end
    end)
    
    --装备对比出售
    self.btn_compare_sell:addTouchEventListener(function(target,type)
        if type == 2 then
            SoundsFunc_playSounds(SoundsType.UNIVERSAL_BTN,false)
            require("game.equip.view.EquipSellConfirm")
            local layer = EquipSellConfirm:create()
            layer:update(self.m_data)
            SceneManager:getCurrentScene():addChild(layer)
            self:removeFromParent()
        end
    end)

	 -- 拦截
    local function onTouchBegan(touch, event)
       
        return true
    end

    local function onTouchMoved(touch, event)

    end

    local function onTouchEnded(touch, event)
--        self:removeFromParent()    
        local location = touch:getLocation()

        local point = self.panel:convertToNodeSpace(location)
        local rect = cc.rect(0,0,self.panel:getContentSize().width,self.panel:getContentSize().height)
        if cc.rectContainsPoint(rect,point) == false then
            self:removeFromParent()
        end
    end

    local listener = cc.EventListenerTouchOneByOne:create()
    listener:registerScriptHandler(onTouchBegan,cc.Handler.EVENT_TOUCH_BEGAN )
    listener:registerScriptHandler(onTouchMoved,cc.Handler.EVENT_TOUCH_MOVED )
    listener:registerScriptHandler(onTouchEnded,cc.Handler.EVENT_TOUCH_ENDED )
    local eventDispatcher = self:getEventDispatcher()
    eventDispatcher:addEventListenerWithSceneGraphPriority(listener, self.panel)
    listener:setSwallowTouches(true)
end

function EquipDetail:update(data)
    self:reset()
	self.m_data = data
	if self.m_data.backpackType == enBackpackType.BACKPACK then
        if self.m_data.config.Type == 1  then
            if zzm.CharacterModel:getEquipedBySubtype(self.m_data:getSubType()) then
                self:showView(Equip_Detail_Type.compare)
                self:setEquipData(Equip_Detail_Type.compare)
        	else
                self:showView(Equip_Detail_Type.noequip)
                self:setEquipData(Equip_Detail_Type.noequip)
        	end
        elseif self.m_data.config.Type == 2 then
            print("物品")
            self:showView(4)
        end
    elseif self.m_data.backpackType == enBackpackType.ROLE_EQUIP then
        self:showView(Equip_Detail_Type.equiped)
        self:setEquipData(Equip_Detail_Type.equiped)
    else
        --print("Error Backpack Type, type:".. goods.backpackType)
    end
end

function EquipDetail:showView(type)
	self.equipedNode:setVisible(false)
    self.noequipNode:setVisible(false)
    self.compareNode:setVisible(false)
    
    if type == Equip_Detail_Type.equiped then
    	self.equipedNode:setVisible(true)
    elseif type == Equip_Detail_Type.noequip then
    	self.noequipNode:setVisible(true)
    elseif type == Equip_Detail_Type.compare then
    	self.compareNode:setVisible(true)
    end
end

function EquipDetail:setEquipData(type)
    if type == Equip_Detail_Type.equiped then
        self.pic_equiped_quality:setTexture(self.m_data:getQualityIcon())
        self.pic_equiped_icon:setTexture(self.m_data:getIcon())
        self.txt_equiped_name:setString(self.m_data.config.Name)
        self.txt_equiped_name:setColor(Quality_Color[self.m_data.config.Quality])
        self.txt_equiped_strengLv:setString("+"..self.m_data.lv)
        self.txt_equiped_strengLv:setVisible(not (self.m_data.lv == 0))
        self.btn_equiped_devour:setVisible(self.m_data.lv < EquipStrengthenConfig:getLvMax())
        self.txt_equiped_needLv:setString("需求等级:"..self.m_data.config.Lv)
        local enCAT = enCharacterAttrType
        if self.m_data.base_attr_vf == self.m_data.base_attr_v then
            self.txt_equiped_baseAttrValue:setString(enCAT:getTypeName(self.m_data.base_attr_t)..":"..self.m_data.base_attr_v)
        else
            self.txt_equiped_baseAttrValue:setString(enCAT:getTypeName(self.m_data.base_attr_t)..":"..self.m_data.base_attr_v.."(+"..(self.m_data.base_attr_vf-self.m_data.base_attr_v)..")")
        end
        self.bar_equiped_growth:setPercent(self.m_data.exp / self.m_data.exp_uplv * 100)
        self.txt_equiped_growth:setString(self.m_data.exp.."/"..self.m_data.exp_uplv)
        for index=1, 6 do
            if index > self.m_data.attr_count then
                break
            end
        	local node = AttributeNode:create()
        	self.equiped_property[index]:addChild(node)
            node:setFrameTouch(false)
            node:update(self.m_data.attr_solt[index])
        end
    elseif type == Equip_Detail_Type.noequip then
        self.pic_noequip_quality:setTexture(self.m_data:getQualityIcon())
        self.pic_noequip_icon:setTexture(self.m_data:getIcon())
        self.txt_noequip_name:setString(self.m_data.config.Name)
        self.txt_noequip_name:setColor(Quality_Color[self.m_data.config.Quality])
        self.txt_noequip_strengLv:setString("+"..self.m_data.lv)
        self.txt_noequip_strengLv:setVisible(not (self.m_data.lv == 0))
        self.txt_noequip_needLv:setString("需求等级:"..self.m_data.config.Lv)
        local enCAT = enCharacterAttrType
        if self.m_data.base_attr_vf == self.m_data.base_attr_v then
            self.txt_noequip_baseAttrValue:setString(enCAT:getTypeName(self.m_data.base_attr_t)..":"..self.m_data.base_attr_v)
        else           
            self.txt_noequip_baseAttrValue:setString(enCAT:getTypeName(self.m_data.base_attr_t)..":"..self.m_data.base_attr_v.."(+"..(self.m_data.base_attr_vf-self.m_data.base_attr_v)..")")
        end
        self.bar_noequip_growth:setPercent(self.m_data.exp / self.m_data.exp_uplv * 100)
        self.txt_noequip_growth:setString(self.m_data.exp.."/"..self.m_data.exp_uplv)
        for index=1, 6 do
            if index > self.m_data.attr_count then
                break
            end
            local node = AttributeNode:create()
            self.noequip_property[index]:addChild(node)
            node:setFrameTouch(false)
            node:update(self.m_data.attr_solt[index])
        end
    elseif type == Equip_Detail_Type.compare then
        --背包的装备
        self.pic_compare_noequip_quality:setTexture(self.m_data:getQualityIcon())
        self.pic_compare_noequip_icon:setTexture(self.m_data:getIcon())
        self.txt_compare_noequip_name:setString(self.m_data.config.Name)
        self.txt_compare_noequip_name:setColor(Quality_Color[self.m_data.config.Quality])
        self.txt_compare_noequip_strengLv:setString("+"..self.m_data.lv)
        self.txt_compare_noequip_strengLv:setVisible(not (self.m_data.lv == 0))
        self.txt_compare_noequip_needLv:setString("需求等级:"..self.m_data.config.Lv)
        local enCAT = enCharacterAttrType
        if self.m_data.base_attr_vf == self.m_data.base_attr_v then
            self.txt_compare_noequip_baseAttrValue:setString(enCAT:getTypeName(self.m_data.base_attr_t)..":"..self.m_data.base_attr_v)
        else
            self.txt_compare_noequip_baseAttrValue:setString(enCAT:getTypeName(self.m_data.base_attr_t)..":"..self.m_data.base_attr_v.."(+"..(self.m_data.base_attr_vf-self.m_data.base_attr_v)..")")
        end
        self.bar_compare_noequip_growth:setPercent(self.m_data.exp / self.m_data.exp_uplv * 100)
        self.txt_compare_noequip_growth:setString(self.m_data.exp.."/"..self.m_data.exp_uplv)
        for index=1, 6 do
            if index > self.m_data.attr_count then
                break
            end
            local node = AttributeNode:create()
            self.compare_noequip_property[index]:addChild(node)
            node:setFrameTouch(false)
            node:update(self.m_data.attr_solt[index])
        end
        --人物身上的装备
        --根据点击背包装备子类型获取人物身上对应装备的data
        local data = zzm.CharacterModel:getEquipedBySubtype(self.m_data.config.TypeSub)
        self.pic_compare_equiped_quality:setTexture(data:getQualityIcon())
        self.pic_compare_equiped_icon:setTexture(data:getIcon())
        self.txt_compare_equiped_name:setString(data.config.Name)
        self.txt_compare_equiped_name:setColor(Quality_Color[data.config.Quality])
        self.txt_compare_equiped_strengLv:setString("+"..data.lv)
        self.txt_compare_equiped_strengLv:setVisible(not (data.lv == 0))
        self.btn_compare_devour:setVisible(data.lv < EquipStrengthenConfig:getLvMax())
        self.txt_compare_equiped_needLv:setString("需求等级:"..data.config.Lv)
        local enCAT = enCharacterAttrType
        if data.base_attr_vf == data.base_attr_v then
            self.txt_compare_equiped_baseAttrValue:setString(enCAT:getTypeName(data.base_attr_t)..":"..data.base_attr_v)
        else
            self.txt_compare_equiped_baseAttrValue:setString(enCAT:getTypeName(data.base_attr_t)..":"..data.base_attr_v.."(+"..(data.base_attr_vf-data.base_attr_v)..")")
        end
        self.bar_compare_equiped_growth:setPercent(data.exp / data.exp_uplv * 100)
        self.txt_compare_equiped_growth:setString(data.exp.."/"..data.exp_uplv)
        for index=1, 6 do
            if index > data.attr_count then
                break
            end
            local node = AttributeNode:create()
            self.compare_equiped_property[index]:addChild(node)
            node:setFrameTouch(false)
            node:update(data.attr_solt[index])
        end
        if self.m_data.config.Quality < 3 or data.config.Quality < 3 then
        	self.btn_compare_smelt:setVisible(false)
        else
            self.btn_compare_smelt:setVisible(true)
        end
    end
end

function EquipDetail:reset()
    for index=1, 6 do      
        self.equiped_property[index]:removeAllChildren()
        self.noequip_property[index]:removeAllChildren()
        self.compare_equiped_property[index]:removeAllChildren()
        self.compare_noequip_property[index]:removeAllChildren()
    end
end
