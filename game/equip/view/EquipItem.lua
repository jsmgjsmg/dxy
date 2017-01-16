require("game.equip.view.EquipDetail")

--Quality_Color = {
--    cc.c3b(255,255,255),
--    cc.c3b(0,255,0),
--    cc.c3b(0,168,255),
--    cc.c3b(252,10,255),
--    cc.c3b(255,252,0),
--}

local PATH = "res/dxyCocosStudio/png/equip/"

EquipItem = EquipItem or class("EquipItem",function()
    local path = "dxyCocosStudio/png/equip/equipFrame_1.png"
    return ccui.Button:create(path,path,path)
end)

EquipItem.ItemNode = nil

function EquipItem:create()
    local node = EquipItem:new()
    return node
end

function EquipItem:ctor()
    self.equipFrame = nil
    --self:setName("EquipItem")
    self:initUI()
    self:initEvent()
end

function EquipItem:initUI()
    local equipItem
    if EquipItem.ItemNode == nil then
        equipItem = cc.CSLoader:createNode("dxyCocosStudio/csd/ui/equip/equipItem.csb")
        self:addChild(equipItem)
        local x = self:getContentSize().width / 2
        local y = self:getContentSize().height / 2

        equipItem:setPosition(cc.p(x,y))
    else
        equipItem = EquipItem.ItemNode
        EquipItem.ItemNode = nil
    end

    equipItem:stopAllActions()
    self._timeLine = cc.CSLoader:createTimeline("dxyCocosStudio/csd/ui/equip/equipItem.csb") 
    equipItem:runAction(self._timeLine) 
    self._timeLine:gotoFrameAndPlay(0,true) 

    self.equipIcon = equipItem:getChildByName("Icon")
    self.equipFrame = equipItem:getChildByName("equipFrame")
    self.text_Count = equipItem:getChildByName("Count")
    self.text_Count:setString("")

    self.selectedBg = equipItem:getChildByName("SelectedBg")
    self.quality = equipItem:getChildByName("quality")
    self.notOptional = equipItem:getChildByName("NotOptional")
    
    self.smelting = equipItem:getChildByName("smelting")
    self.equiping = equipItem:getChildByName("equiping")
    
    self.effect = equipItem:getChildByName("Effect")
    
    self.smelting:setVisible(false)
    self.equiping:setVisible(false)
    
    self:setOptional(true)
end

function EquipItem:setParent(parent)
    self._parent = parent
end

function EquipItem:getFrameSize()
    local size = self.equipFrame:getContentSize()
    return size
end

function EquipItem:initEvent()
    self:addTouchEventListener(function(target,type)
        if(type==2 and self.m_data)then
            print("-------------------" .. self.m_data.idx)     
            SoundsFunc_playSounds(SoundsType.OPEN_PAGE,false)
            if zzm.CharacterModel.isSwallow and self.m_data.config.Type == 1 then
                if self.notOptional:isVisible() then
                    dxyFloatMsg:show("低级装备不能吞噬高级装备")
                    return
                end
                dxyDispatcher_dispatchEvent(dxyEventType.EquipStrengthen_SetItemIn,self.m_data)
                self:showSelected()
            else
                zzm.CharacterModel:setCurItemData(self.m_data)
                dxyDispatcher_dispatchEvent(dxyEventType.RoleView_OpenSubView, CHARACTER_SUB_TYPE.EQUIP_DETAIL)
            end
        end
    end)
end


function EquipItem:updateReward(data)
    self.m_data = data
    if not self.m_data then
        return
    end

    if  self.m_data.type == DefineConst.CONST_AWARD_GOODS or --6
        self.m_data.type == DefineConst.CONST_AWARD_CHIP or  --10
        self.m_data.type == DefineConst.CONST_AWARD_RAND_EQUIP or --22
        self.m_data.type == DefineConst.CONST_AWARD_RAND_MAGICSOUL or --23
        self.m_data.type == DefineConst.CONST_AWARD_RAND_GODCHIP 
        then --24
        local data = GoodsConfigProvider:findGoodsById(self.m_data.value)
        if data  then
            self.quality:setTexture(PATH.."spiritQuality_"..data.Quality..".png")
            if  self.m_data.type == DefineConst.CONST_AWARD_CHIP or --10
                self.m_data.type == DefineConst.CONST_AWARD_RAND_GODCHIP then --24
                self.equipIcon:setTexture("GodGeneralsIcon/"..data.Icon..".png")
            else
                self.equipIcon:setTexture("Icon/"..data.Icon..".png")
            end
        end

        self.text_Count:setString("")
        if self.m_data.num >1 then
            self.text_Count:setString(self.m_data.num)
        end
        
    else
        self.equipIcon:setTexture(zzd.TaskData.arrGoodsIcon[self.m_data.type])
        self.quality:setTexture(PATH.."spiritQuality_1.png")
        self.text_Count:setString("")
        if self.m_data.value >1 then
            self.text_Count:setString(self.m_data.value)
        end
    end
    
    if self.m_data.hight == 1 then
        self.effect:setVisible(true)
    else
        self.effect:setVisible(false)
    end
    

end

function EquipItem:update(data)
    self.m_data = data
    if self.m_data then
        if self.m_data.count ~= 1 then
            self.text_Count:setString(self.m_data.count)
        end
        self.equipIcon:setVisible(true)
        self.equipIcon:setTexture(self.m_data:getIcon())
        self.text_Count:setString("")
        self.quality:setVisible(true)
        self.quality:setTexture(self.m_data:getQualityIcon())
    else
        self.equipIcon:setVisible(false)
        self.text_Count:setString("")
        self.quality:setVisible(false)
    end
    self:initSelected(false)
end

function EquipItem:updateConfig(data,count)
    self.m_data = data
    if self.m_data then
        self:setVisible(true)
        self.equipIcon:setVisible(true)
        local path = "Icon/"
        if self.m_data.Icon == "String" or self.m_data.Icon == nil then
            path = path .. "props_yao.png"
        else
            path = path .. self.m_data.Icon .. ".png"
        end
        print(path)
        self.equipIcon:setTexture(path)
        self.text_Count:setString("")
        self.quality:setVisible(true)
        path = "dxyCocosStudio/png/equip/quality_"
        path = path..self.m_data.Quality..".png"
        print(path)
	    self.selectedBg:setVisible(false)
        self.quality:setTexture(path)
        --self.quality:setTexture(path))
        self:addTouchEventListener(function(target,type)
            if(type==2 and self.m_data)then
                print("-------------------" .. self.m_data.Name)
            end
        end)
        if count then
        	if count ~= 1 then
        		self.text_Count:setString(count)
        		self.text_Count:setVisible(true)
        	end
        end
    else
        self:setVisible(false)
    end
end

function EquipItem:showSelected()
    self.selectedBg:setVisible(not self.selectedBg:isVisible())
end

function EquipItem:initSelected(flag)
    if not flag then
        self.selectedBg:setVisible(flag)
    end
end

function EquipItem:setOptional(flag)
    --self:setTouchEnabled(flag)
    self.notOptional:setVisible(not flag)
end

function EquipItem:setBG(name)
    local path = "dxyCocosStudio/png/equip/"
    if name then
        --self.equipFrame:setTexture(path..name..".png")
        self.equipFrame:setTexture(path..name..".png")
        --self.pic_equip:setTexture(path..data)
    end
end

function EquipItem:setEquipSmeltShow(flag)
    self.smelting:setVisible(flag)
    self.equiping:setVisible(flag)
end

function EquipItem:isShowEquipSmelt()
    if not self.m_data then
        self.smelting:setVisible(false)
        self.equiping:setVisible(false)
        return
    end
    
    local role = zzm.CharacterModel:getCharacterData()
    local enCAT = enCharacterAttrType
    local lv = role:getValueByType(enCAT.LV)
    
    local data = zzm.CharacterModel:getEquipedBySubtype(self.m_data.config.TypeSub)
    if not data then
        self.equiping:setVisible(self.m_data.config.Lv <= lv)
    	return
    end
    
    local backpackPower = 0
    local equipedPower = 0
    
    backpackPower = self:calculatePower(self.m_data.base_attr_t,self.m_data.base_attr_vf)
    for index=1, #self.m_data.attr_solt do
        backpackPower = backpackPower + self:calculatePower(self.m_data.attr_solt[index].type,self.m_data.attr_solt[index].value)
    end
    
    equipedPower = self:calculatePower(data.base_attr_t,data.base_attr_vf)
    for index=1, #data.attr_solt do
        equipedPower = equipedPower + self:calculatePower(data.attr_solt[index].type,data.attr_solt[index].value)
    end
    
    self.smelting:setVisible(self.m_data.config.Quality >= 3 and data.config.Quality >= 3)
    self.equiping:setVisible(backpackPower > equipedPower and self.m_data.config.Lv <= lv)
    
end

function EquipItem:calculatePower(type,value)
    local enCAT = enCharacterAttrType
    local power = 0
	if type == enCAT.ATK then
		power = value * 1
	elseif type == enCAT.DEF then
	   power = value * 2
	elseif type == enCAT.HP then
	   power = value * 0.2
	end
	return power
end