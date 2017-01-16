CKB_TYPE = {
    1,  --变强
    2,  --升级
    3,  --铜钱
    4,  --元宝
}

HELPER_TYPE = {
    [1] = "我要变强",
    [2] = "我要升级",
    [3] = "我要铜钱",
    [4] = "我要元宝",
}

BUTTON_FUNCTION = {
    [1] = function()
    	zzc.CharacterController:showLayer()
    end,
    [2] = function()
        zzc.GeneralController:showLayer()
    end,
    [3] = function()
    	zzc.SpiritController:showLayer()
    end,
    [4] = function()
    	zzc.SkillController:showLayer()
    end,
    [5] = function()
    	zzc.YuanShenController:showLayer()
    end,
    [6] = function()
    	zzc.FairyController:showLayer()
    end,
    [7] = function()
        zzc.GroupController:showLayer()
    end,
    [8] = function()
    	zzc.RecruitMoneyController:showLayer()
    end,
    [9] = function()
    	zzc.CornucopiaController:showLayer()
    end,
    [10] = function()
    	zzc.TowerController:showLayer()
    end,
    [11] = function()
    	zzc.SweepController:showLayer()
    end,
    [12] = function()
        if _G.RoleData.ALLRMB >= RechargeConfig:getDemand() and zzm.RechargeModel._isFirst >= 2 then
            zzc.RechargeController:showLayer()
        else
            zzc.RechargeController:showNode()
        end
    end
}

BUTTON_FUN_OPEN = {
    [1] = function()
        return zzm.GuideModel:isOpenFunctionByType(enFunctionType.ZhuangBei)
    end,
    [2] = function()
        return zzm.GuideModel:isOpenFunctionByType(enFunctionType.FengShenTai)
    end,
    [3] = function()
        return zzm.GuideModel:isOpenFunctionByType(enFunctionType.LingShan)
    end,
    [4] = function()
        return zzm.GuideModel:isOpenFunctionByType(enFunctionType.JiNeng)
    end,
    [5] = function()
        return zzm.GuideModel:isOpenFunctionByType(enFunctionType.YuanShen)
    end,
    [6] = function()
        return zzm.GuideModel:isOpenFunctionByType(enFunctionType.XianNv)
    end,
    [7] = function()
        return zzm.GuideModel:isOpenFunctionByType(enFunctionType.XianMen)
    end,
    [8] = function()
        
    end,
    [9] = function()
        return zzm.GuideModel:isOpenFunctionByType(enFunctionType.CaiShenBaoKu)
    end,
    [10] = function()
        return zzm.GuideModel:isOpenFunctionByType(enFunctionType.ShiLianTa)
    end,
    [11] = function()
        return zzm.GuideModel:isOpenFunctionByType(enFunctionType.SaoDang)
    end,
    [12] = function()
        
    end
}

HelperLayer = HelperLayer or class("HelperLayer",function()
	return cc.Layer:create()
end)

function HelperLayer:create()
    local layer = HelperLayer:new()
    return layer
end

function HelperLayer:ctor()
    self._csb = nil

	self:initUI()
	self:initEvent()
end

function HelperLayer:initUI()
	self._csb = cc.CSLoader:createNode("dxyCocosStudio/csd/ui/helper/HelperLayer.csb")
	self:addChild(self._csb)
	
	self.btn_close = self._csb:getChildByName("closeBtn")
	
	local ckbNode = self._csb:getChildByName("ckbNode")
    self.ckb_list = {}
    for index=1, #CKB_TYPE do
        self.ckb_list[index] = ckbNode:getChildByName("CheckBox_"..index)
    end
    
    self.helperNode = self._csb:getChildByName("Node")
    require("game.helper.view.HelperNode")

end

function HelperLayer:initEvent()
    if self.btn_close then
        self.btn_close:addTouchEventListener(function(target,type)
            if type == 2 then
				SoundsFunc_playSounds(SoundsType.CLOSE_PAGE,false)
                zzc.HelperController:closeLayer()
            end
        end)
    end
    
    for index=1, #CKB_TYPE do
    	self.ckb_list[index]:addEventListener(function(target,type)
    	   if type == ccui.CheckBoxEventType.selected then
    	       self:selectType(index)
    	   end
    	end)
    end
    
    -- 拦截
    dxySwallowTouches(self)
end

function HelperLayer:selectType(type)
    for index=1, #CKB_TYPE do
		if type == index then
            self.ckb_list[index]:setSelected(true)
            self.ckb_list[index]:setTouchEnabled(false)
        else
            self.ckb_list[index]:setSelected(false)
            self.ckb_list[index]:setTouchEnabled(true)
		end
	end
	
	self.helperNode:removeAllChildren()
	local node = HelperNode:create()
	node:update(type)
	self.helperNode:addChild(node)
end

function HelperLayer:update(type)
    if type ~= nil then
        self:selectType(type)
    else
        self:selectType(1)
    end
end

function HelperLayer:WhenClose()
    self:removeFromParent()
end