SkillCUnlock = SkillCUnlock or class("SkillCUnlock",function()
	return cc.Layer:create()
end)

function SkillCUnlock:create()
	local layer = SkillCUnlock:new()
	return layer
end

function SkillCUnlock:ctor()
    self._csbNode = nil
    
    self.m_data = nil
    
    self.bg = nil
    
    self.txt_copper = nil
    self.txt_lv = nil
    self.txt_if = nil
    
    self.btn_unlock = ccui.Button
    
	self:initUI()
	self:initEvent()
end

function SkillCUnlock:initUI()
	self._csbNode = cc.CSLoader:createNode("dxyCocosStudio/csd/ui/skill/SkillCUnlock.csb")
	self:addChild(self._csbNode)
	
    self.bg = self._csbNode:getChildByName("bg")
	
	local node = self._csbNode:getChildByName("node")
	self.txt_copper = node:getChildByName("copperTxt")
	self.txt_lv = node:getChildByName("lvTxt")
	self.txt_if = node:getChildByName("ifTxt")
	
	self.btn_unlock = self._csbNode:getChildByName("unlockBtn")
end

function SkillCUnlock:update(data)
	self.m_data = data
	
    local ctskill = CTSkillConfig:getCTSkillByIdAndinx(self.m_data.id,self.m_data.idx)
    self.txt_copper:setString(ctskill.SkillDeblockingGold)
    self.txt_lv:setString("LV:"..ctskill.SkillDeblockingLv)
	
end

function SkillCUnlock:initEvent()

    -- 拦截
    dxySwallowTouches(self,self.bg)

	self.btn_unlock:addTouchEventListener(function(target,type)
	   if type == 2 then
            SoundsFunc_playSounds(SoundsType.UNIVERSAL_BTN,false)
           zzc.SkillController:request_CTSkillDeblock(self.m_data.id,self.m_data.idx)
	   	   self:removeFromParent()
	   end
	end)
end