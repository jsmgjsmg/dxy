require("game.equip.view.EquipItem")
RoleInfoLayer = RoleInfoLayer or class("RoleInfoLayer",function()
	return cc.Layer:create()
end)

function RoleInfoLayer.create()
	local layer = RoleInfoLayer:new()
	return layer
end

function RoleInfoLayer:ctor()
    self.roleNode = nil
    self._equipList = {}
    
    --self._nameList = {"helmet","necklace","clothes","pants","weapon","shoes"}
    self._nameList = {"weapon","pants","helmet","necklace","clothes","shoes"}
    
	self:initUI()
    dxyExtendEvent(self)
end

function RoleInfoLayer:runTimeLine()  	
    self._timeLine = cc.CSLoader:createTimeline("dxyCocosStudio/csd/ui/equip/roleInfoLayer.csb")
    self._csbNode:runAction(self._timeLine)
    self._timeLine:gotoFrameAndPlay(0,true)
    self._timeLine:setTimeSpeed(0.3)
end

function RoleInfoLayer:initUI()
	self._csbNode = cc.CSLoader:createNode("dxyCocosStudio/csd/ui/equip/roleInfoLayer.csb")
    self:addChild(self._csbNode)
	
--    self._timeLine = cc.CSLoader:createTimeline("dxyCocosStudio/csd/ui/equip/roleInfoLayer.csb")
--    self._csbNode:runAction(self._timeLine)
--    self._timeLine:gotoFrameAndPlay(0,true)

	
    local node = self._csbNode:getChildByName("attributeNode")
    self.text_Life = node:getChildByName("lifeTxt")
    self.text_Magic = node:getChildByName("magicTxt")
    self.text_Atk = node:getChildByName("attackTxt")
    self.text_Def = node:getChildByName("defenseTxt")
	


    self.roleNode = self._csbNode:getChildByName("roleNode")
	--local dataList = zzm.CharacterModel:getEquipedList()
    for index=1, #self._nameList do  
	    local name = self._nameList[index]
	    local node = self.roleNode:getChildByName(name)
	    if node then
            --local data = zzm.CharacterModel:getEquipedBySubtype(index)
            self._equipList[name] = EquipItem:create()
            self._equipList[name]:setName("equiped_"..self._nameList[index])
            node:addChild(self._equipList[name])
            self._equipList[name]:setBG(self._nameList[index])
            --self._equipList[name]:update(data)
	    end
	end
    self.pic_role = self.roleNode:getChildByName("rolePic")
    
    local role = zzm.CharacterModel:getCharacterData()
    local enCAT = enCharacterAttrType
    self.pic_role:setTexture(HeroConfig:getValueById(role:getValueByType(enCAT.PRO))["BgLing"])
    
    self:runTimeLine()
    
end

function RoleInfoLayer:removeEvent()
    dxyDispatcher_removeEventListener(dxyEventType.Character_AttrUpdate,self,self.updateValue)
    dxyDispatcher_removeEventListener(dxyEventType.UserItem_CastEquip,self,self.castEquip)
    dxyDispatcher_removeEventListener(dxyEventType.UserItem_WearEquip,self,self.wearEquip)
    dxyDispatcher_removeEventListener(dxyEventType.UserItem_ReplaceEquip,self,self.replaceEquip)
end

function RoleInfoLayer:initEvent()
--    if not self._timeLine then	
--        self._timeLine = cc.CSLoader:createTimeline("dxyCocosStudio/csd/ui/equip/roleInfoLayer.csb")
--    end
--    --self._csbNode:runAction(self._timeLine)
--    self._timeLine:gotoFrameAndPlay(0,true)

    local role = zzm.CharacterModel:getCharacterData()
    local enCAT = enCharacterAttrType
    self.text_Life:setString(role:getValueByType(enCAT.HP))
    self.text_Magic:setString(role:getValueByType(enCAT.MP))
    self.text_Atk:setString(role:getValueByType(enCAT.ATK))
    self.text_Def:setString(role:getValueByType(enCAT.DEF))
    
    for index=1, #self._nameList do  
        local name = self._nameList[index]
        local node = self.roleNode:getChildByName(name)
        if node then
            local data = zzm.CharacterModel:getEquipedBySubtype(index)
            self._equipList[name]:setBG(self._nameList[index])
            self._equipList[name]:update(data)
            self._equipList[name]:setEquipSmeltShow(false)
        end
    end
    dxyDispatcher_addEventListener(dxyEventType.Character_AttrUpdate,self,self.updateValue)
    dxyDispatcher_addEventListener(dxyEventType.UserItem_CastEquip,self,self.castEquip)
    dxyDispatcher_addEventListener(dxyEventType.UserItem_WearEquip,self,self.wearEquip)
    dxyDispatcher_addEventListener(dxyEventType.UserItem_ReplaceEquip,self,self.replaceEquip)
end

function RoleInfoLayer:replaceEquip(goods)
    print("===========1 " .. goods.idx)
    local name = self._nameList[goods.idx]
    local equip = self._equipList[name]
    if equip and equip.m_data and equip.m_data.idx == goods.idx then
        equip:update(goods)
        return
    end
end

function RoleInfoLayer:wearEquip(goods)
    print("===========2 " .. goods.idx)
    local name = self._nameList[goods.idx]
    local equip = self._equipList[name]
    if equip and equip.m_data == nil then
        equip:update(goods)
        return
    end
end

function RoleInfoLayer:castEquip(idx)
    print("===========3 " .. idx)
    local name = self._nameList[idx]
    local equip = self._equipList[name]
    if equip and equip.m_data and equip.m_data.idx ==idx then
        equip:update()
        return
    end
end

function RoleInfoLayer:updateValue(data)
    local type = data.type
    if type == enCharacterAttrType.HP then
    	self.text_Life:setString(data.value)
    elseif type == enCharacterAttrType.MP then
        self.text_Magic:setString(data.value)
    elseif type == enCharacterAttrType.ATK then
        self.text_Atk:setString(data.value)
    elseif type == enCharacterAttrType.DEF then
        self.text_Def:setString(data.value)
    else
    
    end
end

