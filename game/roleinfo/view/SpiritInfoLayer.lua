SpiritInfoLayer = SpiritInfoLayer or class("SpiritInfoLayer",function()
	return cc.Layer:create()
end)

function SpiritInfoLayer:create()
    local layer = SpiritInfoLayer:new()
    return layer
end

function SpiritInfoLayer:ctor()
	self._csb = nil
	
	self:initUI()
--	self:initEvent()
end

function SpiritInfoLayer:initUI()
	self._csb = cc.CSLoader:createNode("dxyCocosStudio/csd/ui/roleinfo/spiritInfoLayer.csb")
	self:addChild(self._csb)
	
    dxyExtendEvent(self)
	
	self.txt_name = self._csb:getChildByName("name")

    local infoNode = self._csb:getChildByName("infoNode")
    self.txt_atk = infoNode:getChildByName("ATK")
    self.txt_def = infoNode:getChildByName("DEF")
    self.txt_hp = infoNode:getChildByName("HP")
    
    local node = self._csb:getChildByName("spiritNode")
    require("game.roleinfo.view.SpiritInfoItem")
    self._item = SpiritInfoItem:create()
    self._item:setParent(self)
    node:addChild(self._item)
    
    if _G.RankData.Uid == _G.RoleData.Uid then
        self:MinePro()
    else
    	zzc.RoleinfoController:getDataWithPro(_G.RankData.Uid,3)
    end
end

function SpiritInfoLayer:initEvent()
    dxyDispatcher_addEventListener("SpiritInfoLayer_update",self,self.update)
end

function SpiritInfoLayer:removeEvent()
    dxyDispatcher_removeEventListener("SpiritInfoLayer_update",self,self.update)
end

function SpiritInfoLayer:update()

--       self.parent.txt_name:setString(self.m_data.config.Name.." +"..self.m_data.lv)
--       self.parent.txt_name:setColor(Quality_Color[self.m_data.config.Quality])
--       self.parent.txt_atk:setString(self.m_data.attr_solt[1].value)
--       self.parent.txt_def:setString(self.m_data.attr_solt[2].value)
--       self.parent.txt_hp:setString(self.m_data.attr_solt[3].value)
	local SPIRIT = zzm.RoleinfoModel._arrRoleData.SPIRIT
	
	if SPIRIT.config and SPIRIT.lv then
	    self.txt_name:setString(SPIRIT.config.Name.." +"..SPIRIT.lv or "")
        self.txt_name:setColor(Quality_Color[SPIRIT.config.Quality or 1])
        self.txt_atk:setString(SPIRIT.attr_solt[1].value or 0)
        self.txt_def:setString(SPIRIT.attr_solt[2].value or 0)
        self.txt_hp:setString(SPIRIT.attr_solt[3].value or 0)
        self._item:update(SPIRIT)
	end
end

function SpiritInfoLayer:MinePro()
    self.m_data = zzm.CharacterModel:getSpirit()
    if self.m_data then
        self.txt_name:setString(self.m_data.config.Name.." +"..self.m_data.lv)
        self.txt_name:setColor(Quality_Color[self.m_data.config.Quality])
        self.txt_atk:setString(self.m_data.attr_solt[1].value)
        self.txt_def:setString(self.m_data.attr_solt[2].value)
        self.txt_hp:setString(self.m_data.attr_solt[3].value)
        
        self._item:update(self.m_data)
    end
end