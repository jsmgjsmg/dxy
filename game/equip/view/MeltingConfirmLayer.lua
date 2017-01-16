MeltingConfirmLayer = MeltingConfirmLayer or class("MeltingConfirmLayer",function()
	return cc.Layer:create()
end)

function MeltingConfirmLayer:create()
	local layer = MeltingConfirmLayer:new()
	return layer
end

function MeltingConfirmLayer:ctor()
    self.visibleSize = cc.Director:getInstance():getVisibleSize()
    self.origin = cc.Director:getInstance():getVisibleOrigin()
    
    self.txt_before = nil
    self.txt_after = nil
    self.txt_recovery = nil
    self.btn_recovery = ccui.Button
    self.btn_confirm = ccui.Button
    
    
	self:initUI()
	self:initEvent()
end

function MeltingConfirmLayer:initUI()
	local meltingConfirmLayer = cc.CSLoader:createNode("dxyCocosStudio/csd/ui/equip/smeltConfirmLayer.csb")
	self:addChild(meltingConfirmLayer)
    self:setPosition(self.origin.x + self.visibleSize.width/2 , self.origin.y + self.visibleSize.height/2)
    SceneManager:getCurrentScene():addChild(self)
    	
	self.txt_before = meltingConfirmLayer:getChildByName("beforeTxt")
	self.txt_after = meltingConfirmLayer:getChildByName("afterTxt")
	self.txt_recovery = meltingConfirmLayer:getChildByName("recoveryTxt")
	self.btn_recovery = meltingConfirmLayer:getChildByName("recoveryBtn")
	self.btn_confirm = meltingConfirmLayer:getChildByName("confirmBtn")
	
    self:update(zzm.CharacterModel:getMeltingData())
end

function MeltingConfirmLayer:initEvent()

    self.txt_recovery:setString(AutocephalyValueConfig:getValueByContent("smelt"))

	self.btn_recovery:addTouchEventListener(function(target,type)
	   if type == ccui.TouchEventType.ended then
            SoundsFunc_playSounds(SoundsType.UNIVERSAL_BTN,false)
	   	   zzc.CharacterController:request_Melting_RecoverAttr()
           self:removeFromParent()
           dxyDispatcher_dispatchEvent(dxyEventType.EquipSmelting_Close)
	   end
	end)
	
	self.btn_confirm:addTouchEventListener(function(target,type)
	   if type == ccui.TouchEventType.ended then
            SoundsFunc_playSounds(SoundsType.UNIVERSAL_BTN,false)
            zzm.CharacterModel:floatMsg()
	   	   self:removeFromParent()
	   	   dxyDispatcher_dispatchEvent(dxyEventType.EquipSmelting_Close)
	   end
	end)
	
    -- 拦截
    dxySwallowTouches(self)
	
end

function MeltingConfirmLayer:update(data)
    local enCAT = enCharacterAttrType
    if data.melt_leftIdx == 0 then
	   self.btn_recovery:setTouchEnabled(false)
	   self.btn_recovery:setBright(false)
	   self.txt_before:setString("空")
	else
        self.btn_recovery:setTouchEnabled(true)
        self.btn_recovery:setBright(true)
        self.txt_before:setString(enCAT:getTypeName(data.melt_left.attr_solt[data.melt_leftIdx].type)..":+"..data.melt_left.attr_solt[data.melt_leftIdx].value)
        self.txt_before:setColor(Quality_Color[data.melt_left.attr_solt[data.melt_leftIdx].quality])
	end
    self.txt_after:setString(enCAT:getTypeName(data.melt_right.attr_solt[data.melt_rightIdx].type)..":+"..data.melt_right.attr_solt[data.melt_rightIdx].value)
    self.txt_after:setColor(Quality_Color[data.melt_right.attr_solt[data.melt_rightIdx].quality])
end