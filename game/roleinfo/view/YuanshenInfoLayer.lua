YuanshenInfoLayer = YuanshenInfoLayer or class("YuanshenInfoLayer",function()
	return cc.Layer:create()
end)

function YuanshenInfoLayer:create()
    local layer = YuanshenInfoLayer:new()
    return layer
end

function YuanshenInfoLayer:ctor()
	self._csb = nil
	
	self:initUI()
--	self:initEvent()
end

function YuanshenInfoLayer:initUI()
	self._csb = cc.CSLoader:createNode("dxyCocosStudio/csd/ui/roleinfo/yuanshenInfoLayer.csb")
	self:addChild(self._csb)
	
    dxyExtendEvent(self)
	
	self.lv = self._csb:getChildByName("lv")
	self.icon = self._csb:getChildByName("icon")
    self.ball = self._csb:getChildByName("ball")
	self.txt_atk = self._csb:getChildByName("ATK")
	self.txt_def = self._csb:getChildByName("DEF")
	self.txt_hp = self._csb:getChildByName("HP")

    if _G.RankData.Uid == _G.RoleData.Uid then
        self:MinePro()
    else
    	zzc.RoleinfoController:getDataWithPro(_G.RankData.Uid,4)
    end
end

--function YuanshenInfoLayer:initEvent()
--    local data = zzm.YuanShenModel:getYuanShen()
    
--    self.txt_atk:setString(data["Atk"])
--    self.txt_def:setString(data["Def"])
--    self.txt_hp:setString(data["Hp"])

--    self.lv:setString(data["Lv"].."级")
--    local ysIcon = YuanShenConfig:getYSIcon(data["Lv"])
--    self.icon:setTexture("dxyCocosStudio/png/yuanshen/"..ysIcon)
--end

function YuanshenInfoLayer:initEvent()
    dxyDispatcher_addEventListener("YuanshenInfoLayer_update",self,self.update)
end

function YuanshenInfoLayer:removeEvent()
    dxyDispatcher_removeEventListener("YuanshenInfoLayer_update",self,self.update)
end

function YuanshenInfoLayer:update()
    local YUANSHEN = zzm.RoleinfoModel._arrRoleData.YUANSHEN
    self.txt_atk:setString(YUANSHEN["Atk"])
    self.txt_def:setString(YUANSHEN["Def"])
    self.txt_hp:setString(YUANSHEN["Hp"])
    
    self.lv:setString(YUANSHEN["Lv"].."级")
    local ysIcon = YuanShenConfig:getYSIcon(YUANSHEN["Lv"])
    self.icon:setVisible(true)
    self.ball:setVisible(true)
    self.icon:setSpriteFrame(cc.SpriteFrameCache:getInstance():getSpriteFrame("dxyCocosStudio/png/yuanshen/"..ysIcon.Icon_L))
    self.ball:setSpriteFrame(cc.SpriteFrameCache:getInstance():getSpriteFrame("dxyCocosStudio/png/yuanshen/"..ysIcon.Icon))
end

function YuanshenInfoLayer:MinePro()
    local data = zzm.YuanShenModel:getYuanShen()

    self.icon:setVisible(true)
    self.ball:setVisible(true)
    
    self.txt_atk:setString(data["Atk"] or 0)
    self.txt_def:setString(data["Def"] or 0)
    self.txt_hp:setString(data["Hp"] or 0)

    self.lv:setString(data["Lv"].."级")
    local ysIcon = YuanShenConfig:getYSIcon(data["Lv"])
    self.icon:setSpriteFrame(cc.SpriteFrameCache:getInstance():getSpriteFrame("dxyCocosStudio/png/yuanshen/"..ysIcon.Icon_L))
    self.ball:setSpriteFrame(cc.SpriteFrameCache:getInstance():getSpriteFrame("dxyCocosStudio/png/yuanshen/"..ysIcon.Icon))
end