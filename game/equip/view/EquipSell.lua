EquipSell = EquipSell or class("EquipSell",function()
	return cc.Layer:create()
end)

function EquipSell:create()
    local layer = EquipSell:new()
    return layer
end

function EquipSell:ctor()
	self._csb = nil
	
    self.ckbList = {}

    self.m_data = {}
--    self.m_data.typelen = 0
    self.m_data.typeList ={}
	
	self:initUI()
	self:initEvent()
end

function EquipSell:initUI()
    self._csb = cc.CSLoader:createNode("dxyCocosStudio/csd/ui/equip/equipSell.csb")
    self:addChild(self._csb)
    
    local act = cc.CSLoader:createTimeline("dxyCocosStudio/csd/ui/equip/equipSell.csb")
    self._csb:runAction(act)
    act:gotoFrameAndPlay(0,false)
    
    self.bg = self._csb:getChildByName("bg")
    
    self.txt_gold = self.bg:getChildByName("goldTxt")

    self.btn_close = self.bg:getChildByName("closeBtn")
    self.btn_confirm = self.bg:getChildByName("confirmBtn")

    local infoNode = self.bg:getChildByName("infoNode")
    for index=1,5 do
        self.ckbList[index] = infoNode:getChildByName("ckb_"..index)
        if index < 4 then
            self.ckbList[index]:setSelected(true)
        end
    end
end

function EquipSell:initEvent()

    for index=1,5 do
        if self.ckbList[index]:isSelected() == true then
            self:setCkbState(index,true)
        else
            self:setCkbState(index,false)
        end
    end

--    self:reset()
    
--    self.txt_gold:setString(0)

    self.btn_close:addTouchEventListener(function(target,type)
        if type == 2 then
            SoundsFunc_playSounds(SoundsType.CLOSE_PAGE,false)
            self:removeFromParent()
        end
    end)
    
    self.btn_confirm:addTouchEventListener(function(target,type)
        if type == 2 then
            if tonumber(self.txt_gold:getString()) ~= 0 then
                for index=1, #self.m_data.typeList do                   
                    zzm.TalkingDataModel:onEvent(EumEventId.EQUIP_SELL,{})
                end
                zzc.CharacterController:request_autoEquipSell(self.m_data)
                SoundsFunc_playSounds(SoundsType.UNIVERSAL_BTN,false)
                self:removeFromParent()
            else
                SoundsFunc_playSounds(SoundsType.FAILE_TO_USE,false)
                TipsFrame:create("没有该品质的装备!")
            end
        end
    end)
    
    for index=1,5 do
        self.ckbList[index]:addEventListener(function(target,type)
            if type == ccui.CheckBoxEventType.selected then
                self:setCkbState(index,true)
            else
                self:setCkbState(index,false)
            end
        end)
    end
	
	
    -- 拦截
    dxySwallowTouches(self,self.bg)
end

function EquipSell:removeEvent()

end

function EquipSell:setCkbState(index,flag)
    if flag then
--        self.m_data.typelen = self.m_data.typelen + 1
        table.insert(self.m_data.typeList,#self.m_data.typeList+1,index)
    else
--        self.m_data.typelen = self.m_data.typelen - 1
        for key, var in pairs(self.m_data.typeList) do
            if var == index then
                table.remove(self.m_data.typeList,key)
                break
            end
        end
    end
    table.sort(self.m_data.typeList)
    self:setGold()
end

function EquipSell:setGold()
    local _gold = 0
    local equipList = zzm.CharacterModel:getBackpackList()
    for key1,type in pairs(self.m_data.typeList) do
        for key2,equip in pairs(equipList) do
            if type == equip.config.Quality and equip.lv == 0 and equip.exp == 0 then
                _gold = _gold + equip.config.PriceGold
            end
        end
    end
    self.txt_gold:setString(_gold)
end

function EquipSell:reset()
    for index=1,5 do
        self.ckbList[index]:setSelected(false)
    end
    self.m_data.typeList = {}
    self.m_data.typelen = 0
end