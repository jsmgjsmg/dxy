Spirit_Layer_Type = {
    spirit_detail = 1,
    spirit_resolve = 2,
    spirit_strengthen = 3,
}

SpiritNode = SpiritNode or class("SpiritNode",function()
	return ccui.Layout:create()
end)

require("game.spirit.view.SpiritItem")
require("game.spirit.view.SpiritResolve")
require("game.spirit.view.SpiritDetail")
require("game.spirit.view.SpiritStrengthen")

function SpiritNode:create()
	local node = SpiritNode:new()
	return node
end

function SpiritNode:ctor()
    self._csbNode = nil
    
    self.layerNode = nil
    self._subLayer = {}
    
    self.txt_amulet = nil
    self.txt_reiki = nil
    
    self.txt_name = nil
    self.txt_explain = nil
    self.spiritNode = nil
    self._spirit = nil
    
    self.scrollView = ccui.ScrollView
    self.btn_resolve = ccui.Button
    
    self.itemList = {}
    
	self:initUI()
	dxyExtendEvent(self)
end

function SpiritNode:initUI()
	self._csbNode = cc.CSLoader:createNode("dxyCocosStudio/csd/ui/spirit/spiritLayer.csb")
    self:addChild(self._csbNode)
    
    local timeLine = cc.CSLoader:createTimeline("dxyCocosStudio/csd/ui/spirit/spiritLayer.csb")
    self._csbNode:runAction(timeLine)
    timeLine:gotoFrameAndPlay(0,true)
    timeLine:setTimeSpeed(0.3)
    
    self.visibleSize = cc.Director:getInstance():getVisibleSize()
    self.origin = cc.Director:getInstance():getVisibleOrigin()

    local posX = self.origin.x + self.visibleSize.width/2
    local posY = self.origin.y + self.visibleSize.height/2

    self._csbNode:setPosition(posX, posY)
    
    self.layerNode = self._csbNode:getChildByName("LayerNode")
    
    local equipedNode = self._csbNode:getChildByName("equipedNode")
    
    self.txt_amulet = equipedNode:getChildByName("amuletTxt")
    self.txt_reiki = equipedNode:getChildByName("reikiTxt")
    
    self.txt_name = equipedNode:getChildByName("nameTxt")
    self.txt_explain = equipedNode:getChildByName("explainTxt")
    self.spiritNode = equipedNode:getChildByName("spiritNode")
    self._spirit = SpiritItem:create()
    self.spiritNode:addChild(self._spirit)
    self._spirit:setName("equipSpirit")
    
    local noequipNode = self._csbNode:getChildByName("noequipNode")
    self.btn_resolve = noequipNode:getChildByName("resolveBtn")
    self.scrollView = noequipNode:getChildByName("scrollView")
    self.scrollView:setScrollBarEnabled(false)
    self:addScrollView()
    
    --self.btn_resolve:setTouchEnabled(false)
end

function SpiritNode:initEvent()

    local index = 1
    local dataList = zzm.CharacterModel:getSpiritList()
    for index=1,#self.itemList do
        self.itemList[index]:update(dataList[index])
    end
    
    self._spirit:update(zzm.CharacterModel:getSpirit())
    
    if zzm.CharacterModel:getSpirit() then   	
        self.txt_name:setString(zzm.CharacterModel:getSpirit().config.Name)
        self.txt_name:setColor(Quality_Color[zzm.CharacterModel:getSpirit().config.Quality])
        if zzm.CharacterModel:getSpirit().config.SkillID then  	
            self.txt_explain:setString(SkillConfig:getSkillConfigById(zzm.CharacterModel:getSpirit().config.SkillID).Info)
        else
            self.txt_explain:setString("")
        end
    else
        self.txt_name:setString("")
        self.txt_explain:setString("")
    end
    
    local role = zzm.CharacterModel:getCharacterData()
    local enCAT = enCharacterAttrType
    self.txt_amulet:setString(role:getValueByType(enCAT.AMULET))
    self.txt_reiki:setString(role:getValueByType(enCAT.ANIMA))
    
    dxyDispatcher_addEventListener(dxyEventType.Character_AttrUpdate,self,self.updateValue)
    
    dxyDispatcher_addEventListener(dxyEventType.Spirit_Layer,self,self.showLayerType)
    
    dxyDispatcher_addEventListener(dxyEventType.UserItem_AddItem,self,self.addItem)
    dxyDispatcher_addEventListener(dxyEventType.UserItem_DelItem,self,self.delItem)
    dxyDispatcher_addEventListener(dxyEventType.UserItem_Replace,self,self.changeItem)
    
    dxyDispatcher_addEventListener(dxyEventType.UserItem_CastEquip,self,self.castEquip)
    dxyDispatcher_addEventListener(dxyEventType.UserItem_WearEquip,self,self.wearEquip)
    dxyDispatcher_addEventListener(dxyEventType.UserItem_ReplaceEquip,self,self.replaceEquip)
    
	self.btn_resolve:addTouchEventListener(function(target,type)
	   if type == 2 then
          SoundsFunc_playSounds(SoundsType.UNIVERSAL_BTN,false)
          dxyDispatcher_dispatchEvent(dxyEventType.Spirit_Layer,Spirit_Layer_Type.spirit_resolve)
	   end
	end)
end

function SpiritNode:removeEvent()

    dxyDispatcher_removeEventListener(dxyEventType.Character_AttrUpdate,self,self.updateValue)
    dxyDispatcher_removeEventListener(dxyEventType.Spirit_Layer,self,self.showLayerType)

    dxyDispatcher_removeEventListener(dxyEventType.UserItem_AddItem,self,self.addItem)
    dxyDispatcher_removeEventListener(dxyEventType.UserItem_DelItem,self,self.delItem)
    dxyDispatcher_removeEventListener(dxyEventType.UserItem_Replace,self,self.changeItem)
    
    dxyDispatcher_removeEventListener(dxyEventType.UserItem_CastEquip,self,self.castEquip)
    dxyDispatcher_removeEventListener(dxyEventType.UserItem_WearEquip,self,self.wearEquip)
    dxyDispatcher_removeEventListener(dxyEventType.UserItem_ReplaceEquip,self,self.replaceEquip)
end

function SpiritNode:showLayerType(type)
    if type == Spirit_Layer_Type.spirit_detail then
        self.layerNode:removeAllChildren()
        --if not self._subLayer[type] then
        	self._subLayer[type] = SpiritDetail:create()
        	--self._subLayer[type]:retain()
        --end
        self.layerNode:addChild(self._subLayer[type])
        self._subLayer[type]:update(zzm.CharacterModel:getCurSpiritData())
    elseif type == Spirit_Layer_Type.spirit_resolve then
        self.layerNode:removeAllChildren()
        --if not self._subLayer[type] then
            self._subLayer[type] = SpiritResolve:create()
            --self._subLayer[type]:retain()
        --end
        self.layerNode:addChild(self._subLayer[type])
    elseif type == Spirit_Layer_Type.spirit_strengthen then
        self.layerNode:removeAllChildren()
        --if not self._subLayer[type] then
            self._subLayer[type] = SpiritStrengthen:create()
            --self._subLayer[type]:retain()
       -- end
        self.layerNode:addChild(self._subLayer[type])
        self._subLayer[type]:update(zzm.CharacterModel:getCurStrengthSpirit())
	end
end

function SpiritNode:addScrollView()
    local item = nil
    local itemSize = nil
    local x,y = 0,0 
    local index = 1
	for i=12,1,-1 do
	   for j=1,5 do
	       item = SpiritItem:create()
	       item:update()
           itemSize = item:getFrameSize()
           x = (itemSize.height / 2 + 1.0) * (2 * j - 1)
           y = (itemSize.width / 2) * (2 * i - 1)
           item:setPosition(cc.p(x,y))
           self.scrollView:addChild(item)
           self.itemList[index] = item
           self.itemList[index]:setName("spiritItem_"..index)
           index = index + 1
	   end
	end
    self.scrollView:setInnerContainerSize(cc.size((itemSize.width)*5,(itemSize.height)*12))
end

function SpiritNode:refreshItem()
	local data = zzm.CharacterModel:getSpiritList()
    for index=1, #self.itemList do
        self.itemList[index]:update(data[index])
	end
end

function SpiritNode:changeItem(goods)
--    for key, item in ipairs(self.itemList) do
--        if item.m_data and item.m_data.idx == goods.idx then
--            item:update(goods)
--            return
--        end
--    end
    self:refreshItem()
end

function SpiritNode:addItem(goods)
--    for key, item in ipairs(self.itemList) do
--        if item.m_data == nil then
--            item:update(goods)
--            return
--        end
--    end
    self:refreshItem()
end

function SpiritNode:delItem(idx)
--    for key, item in ipairs(self.itemList) do
--        if item.m_data and item.m_data.idx == idx then
--            item:update()
--            return
--        end
--    end
    self:refreshItem()
end

function SpiritNode:replaceEquip(goods)
    print("===========1 " .. goods.idx)
    local spirit = self._spirit
    if spirit and spirit.m_data then
        spirit:update(goods)
        self.txt_name:setString(goods.config.Name)
        self.txt_name:setColor(Quality_Color[goods.config.Quality])
        if goods.config.SkillID then          
            self.txt_explain:setString(SkillConfig:getSkillConfigById(goods.config.SkillID).Info)
        else
            self.txt_explain:setString("")
        end
        return
    end
end

function SpiritNode:wearEquip(goods)
    print("===========2 " .. goods.idx)
    local spirit = self._spirit
    if spirit and spirit.m_data == nil then
        spirit:update(goods)
        self.txt_name:setString(goods.config.Name)
        self.txt_name:setColor(Quality_Color[goods.config.Quality])
        if goods.config.SkillID then          
            self.txt_explain:setString(SkillConfig:getSkillConfigById(goods.config.SkillID).Info)
        else
            self.txt_explain:setString("")
        end       
        return
    end
end

function SpiritNode:castEquip(idx)
    print("===========3 " .. idx)
    local spirit = self._spirit
    if spirit and spirit.m_data then
        spirit:update()
        self.txt_name:setString("")
        self.txt_explain:setString("")
        return
    end
end

function SpiritNode:updateValue()
    local role = zzm.CharacterModel:getCharacterData()
    local enCAT = enCharacterAttrType
    self.txt_amulet:setString(role:getValueByType(enCAT.AMULET))
    self.txt_reiki:setString(role:getValueByType(enCAT.ANIMA))
end
