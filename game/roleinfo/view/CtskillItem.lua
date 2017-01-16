CtskillItem = CtskillItem or class("CtskillItem",function()
	local path = "dxyCocosStudio/png/roleinfo/newroleinfo/moves/skill_unequip.png"
    return ccui.Button:create(path,path,path)
end)

function CtskillItem:create()
    local node = CtskillItem:new()
    return node
end

function CtskillItem:ctor()
    self._csb = nil
    
    self:initUI()
--    self:initEvent()
end

function CtskillItem:initUI()
	self._csb = cc.CSLoader:createNode("dxyCocosStudio/csd/ui/roleinfo/ctskillItem.csb")
	self:addChild(self._csb)
	
    local x = self:getContentSize().width / 2
    local y = self:getContentSize().height / 2 

    self._csb:setPosition(cc.p(x,y))
    
    self.BG_1 = self._csb:getChildByName("BG_1")
    self.BG_2 = self._csb:getChildByName("BG_2")
    self.Icon = self._csb:getChildByName("Icon")
    self.Lock = self._csb:getChildByName("Lock")
    
end

function CtskillItem:update(data)
--	self.m_data = data
--	
--	if self.m_data.is_unlock == 0 then
--        self.BG_1:setVisible(false)
--        self.BG_2:setVisible(true)
--        self.Icon:setVisible(false)
--        self.Lock:setVisible(true)
--	elseif self.m_data.is_unlock == 1 then
--	   if self.m_data.skill_id ~= 0 then
--            self.BG_1:setVisible(true)
--            self.BG_2:setVisible(false)
--            self.Icon:setVisible(true)
--            self.Icon:setScale(0.6)
--            self.Icon:setTexture(SkillConfig:getSkillConfigById(self.m_data.skill_id).Icon)
--            self.Lock:setVisible(false)
--	   else
--            self.BG_1:setVisible(true)
--            self.BG_2:setVisible(false)
--            self.Icon:setVisible(false)
--            self.Lock:setVisible(false)
--	   end
--	end
    if data.is_unlock == 1 then
        if data.skill_id ~= 0 then
            self.BG_1:setVisible(true)
            self.BG_2:setVisible(false)
            self.Icon:setVisible(true)
            self.Icon:setScale(0.65)
            self.Icon:setTexture(SkillConfig:getSkillConfigById(data.skill_id).Icon)
            self.Lock:setVisible(false)
        else
            self.BG_1:setVisible(true)
            self.BG_2:setVisible(false)
            self.Icon:setVisible(false)
            self.Lock:setVisible(false)
        end
    end

end
