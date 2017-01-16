RecruitMoneyLayer = RecruitMoneyLayer or class("RecruitMoneyLayer",function()
	return cc.Layer:create()
end)

function RecruitMoneyLayer:create()
    local layer = RecruitMoneyLayer:new()
    return layer
end

function RecruitMoneyLayer:ctor()
	self._csb = nil
	
	self:initUI()
	dxyExtendEvent(self)
end

function RecruitMoneyLayer:initUI()
    self._csb = cc.CSLoader:createNode("dxyCocosStudio/csd/ui/recruitMoney/recruitMoneyLayer.csb")
    self:addChild(self._csb)
    
    local bg = self._csb:getChildByName("bg")
    
    self.btn_close = bg:getChildByName("closeBtn")
    self.btn_recruit = bg:getChildByName("recruitBtn")
    self.btn_recruitTen = bg:getChildByName("recruitTenBtn")
    
    local node = bg:getChildByName("node")
    self.txt_rmb = node:getChildByName("rmbTxt")
    self.txt_gold = node:getChildByName("goldTxt")
    self.txt_count = node:getChildByName("countTxt")
    
    self.bar_count = node:getChildByName("LoadingBar")
    self.ckb_list = {}
    for index=1, 3 do
        self.ckb_list[index] = self.bar_count:getChildByName("box_"..index)
    end
    
end

function RecruitMoneyLayer:initEvent()
    
    dxyDispatcher_addEventListener(dxyEventType.Recruit_Money_Update,self,self.updateValue)

    self:updateValue()
    
    self.btn_close:addTouchEventListener(function(target,type)
        if type == 2 then
        	zzc.RecruitMoneyController:closeLayer()
        end
    end)
    
    self.btn_recruit:addTouchEventListener(function(target,type)
        if type == 2 then
            zzc.RecruitMoneyController:request_Recruit(DefineConst.CONST_LUCKY_ONE_LUCKY)
        end
    end)
    
    self.btn_recruitTen:addTouchEventListener(function(target,type)
        if type == 2 then
            zzc.RecruitMoneyController:request_Recruit(DefineConst.CONST_LUCKY_TEN_LUCKY)
        end
    end)
    
    for index=1, #self.ckb_list do
    	self.ckb_list[index]:addEventListener(function(target,type)
    	   if type == ccui.CheckBoxEventType.selected then
    	       SoundsFunc_playSounds(SoundsType.OPEN_PAGE,false)
    	       zzc.RecruitMoneyController:request_OpenBox(index)
    	       self.ckb_list[index]:setTouchEnabled(false)
    	   end
    	end)
    end
    
    -- 拦截
    dxySwallowTouches(self)
end

function RecruitMoneyLayer:removeEvent()
    dxyDispatcher_removeEventListener(dxyEventType.Recruit_Money_Update,self,self.updateValue)
end

function RecruitMoneyLayer:WhenClose()
    self:removeFromParent()
end

function RecruitMoneyLayer:updateValue()
    local role = zzm.CharacterModel:getCharacterData()
    local enCAT = enCharacterAttrType
    
    local num = zzm.RecruitMoneyModel.lucky_limit - zzm.RecruitMoneyModel.lucky_count
	self.txt_rmb:setString(RecruitMoneyConfig:getNeedRmb(num + 1))
    self.txt_gold:setString(RecruitMoneyConfig:getBaseGold() * RecruitMoneyConfig:getScaleByLv(role:getValueByType(enCAT.LV)))
    
    self.txt_count:setString("("..zzm.RecruitMoneyModel.lucky_count.."/"..zzm.RecruitMoneyModel.lucky_limit..")")
    
    self.bar_count:setPercent(num / 20 * 100)
    
    local data = zzm.RecruitMoneyModel.box_list
    for index=1, #data do
        for key, var in pairs(data) do
            if index == var.boxid then
    			self:setCkbState(var)
    		end
    	end
    end
end

function RecruitMoneyLayer:setCkbState(data)

    if data.boxstate == DefineConst.CONST_LUCKY_BOX_STATE_UNFINISHED then
        self.ckb_list[data.boxid]:setTouchEnabled(false)
        self.ckb_list[data.boxid]:setBright(false)
        self.ckb_list[data.boxid]:setSelected(false)
    elseif data.boxstate == DefineConst.CONST_LUCKY_BOX_STATE_REWARDS then
        self.ckb_list[data.boxid]:setTouchEnabled(true)
        self.ckb_list[data.boxid]:setBright(true)
        self.ckb_list[data.boxid]:setSelected(false)
    elseif data.boxstate == DefineConst.CONST_LUCKY_BOX_STATE_FINISH then
        self.ckb_list[data.boxid]:setTouchEnabled(false)
        self.ckb_list[data.boxid]:setBright(true)
        self.ckb_list[data.boxid]:setSelected(true)
	end
end