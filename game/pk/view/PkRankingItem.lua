PkRankingItem = PkRankingItem or class("PkRankingItem",function()
    local path_1 = "dxyCocosStudio/png/pk/rankingItemBg.png"
    local path_2 = "dxyCocosStudio/png/pk/rankingItemBg_1.png"
    return ccui.Button:create(path_1,path_2,path_1)
end)

function PkRankingItem:create()
    local node = PkRankingItem:new()
    return node
end

function PkRankingItem:ctor()
	self._csb = nil
	
	self:initUI()
	self:initEvent()
end

function PkRankingItem:initUI()
	self._csb = cc.CSLoader:createNode("dxyCocosStudio/csd/ui/pk/pkRankingItem.csb")
	self:addChild(self._csb)
	
	self.txt_ranking = self._csb:getChildByName("ranking")
	self.pic_head = self._csb:getChildByName("picBtn"):getChildByName("pic")
	self.txt_name = self._csb:getChildByName("name")
    self.txt_lv = self._csb:getChildByName("lv")
    self.txt_renown = self._csb:getChildByName("renown")
	
end

function PkRankingItem:initEvent()
	self:addTouchEventListener(function(target,type)
	   if type == 2 and self.m_data.Type ~= 0 then
	       require("game.pk.view.pkClickTips")
	       local layer = pkClickTips:create()
	       layer:update(self.m_data)
           SceneManager:getCurrentScene():addChild(layer)
	   end
	end)
end

function PkRankingItem:update(data)
	self.m_data = data
	
	if not self.m_data then
		return
	end
	
	if self.m_data.Rank == 1 then
        self.txt_ranking:setString("1st")
	elseif self.m_data.Rank == 2 then
        self.txt_ranking:setString("2nd")
	elseif self.m_data.Rank == 3 then
        self.txt_ranking:setString("3rd")
	else
        self.txt_ranking:setString(self.m_data.Rank)
	end
    
    self.pic_head:setTexture(HeroConfig:getValueById(self.m_data.Pro)["IconSquare"])
    self.txt_name:setString(self.m_data.Name)
    self.txt_lv:setString("LV."..self.m_data.Lv)
    self.txt_renown:setString(self.m_data.Reward)
	
end