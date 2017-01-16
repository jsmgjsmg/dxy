EquipSellConfirm = EquipSellConfirm or class("EquipSellConfirm",function()
	return cc.Layer:create()
end)

function EquipSellConfirm:create()
    local layer = EquipSellConfirm:new()
    return layer
end

function EquipSellConfirm:ctor()
	self._csb = nil
	
	self:initUI()
	self:initEvent()
end

function EquipSellConfirm:initUI()
    self._csb = cc.CSLoader:createNode("dxyCocosStudio/csd/ui/equip/equipSellConfirm.csb")
    self:addChild(self._csb)
    
    self.visibleSize = cc.Director:getInstance():getVisibleSize()
    self.origin = cc.Director:getInstance():getVisibleOrigin()

    self:setPosition(self.origin.x + self.visibleSize.width/2 , self.origin.y + self.visibleSize.height/2)
    
    local act = cc.CSLoader:createTimeline("dxyCocosStudio/csd/ui/equip/equipSellConfirm.csb")
    self._csb:runAction(act)
    act:gotoFrameAndPlay(0,false)
    
    self.bg = self._csb:getChildByName("bg")
    self.txt = self.bg:getChildByName("Text")
    self.btn_confirm = self.bg:getChildByName("confirmBtn")
    self.btn_cancel = self.bg:getChildByName("cancelBtn")
    
end

function EquipSellConfirm:update(data)
	self.m_data = data
	
	self.txt:setString("是否出售该装备获得"..self.m_data.config.PriceGold.."铜钱?")
end

function EquipSellConfirm:initEvent()

    self.btn_confirm:addTouchEventListener(function(target,type)
        if type == 2 then
            SoundsFunc_playSounds(SoundsType.UNIVERSAL_BTN,false)
        	zzc.CharacterController:request_EquipSell(self.m_data.idx)
            zzm.TalkingDataModel:onEvent(EumEventId.EQUIP_SELL,{})
            self:removeFromParent()
        end
    end)
    
    self.btn_cancel:addTouchEventListener(function(target,type)
        if type == 2 then
            SoundsFunc_playSounds(SoundsType.UNIVERSAL_BTN,false)
            self:removeFromParent()
        end
    end)
    
    -- 拦截
    dxySwallowTouches(self,self.bg)
end