local ConsumeSkill = class("ConsumeSkill",function()
    return cc.Node:create()
end)
local PATH = "dxyCocosStudio/png/yuanshen/stone/"

function ConsumeSkill:ctor()
    self.visibleSize = cc.Director:getInstance():getVisibleSize()
    self.origin = cc.Director:getInstance():getVisibleOrigin()
end

function ConsumeSkill:create(data)
    local node = ConsumeSkill:new()
    node:init(data)
    return node
end

function ConsumeSkill:init(data)
    self._csb = cc.CSLoader:createNode("dxyCocosStudio/csd/ui/yuanshen/ConsumeSkill.csb")
    self:addChild(self._csb)
    self._csb:setPosition(self.origin.x + self.visibleSize.width / 2, self.origin.y + self.visibleSize.height / 2)
    
    self._data = zzm.YuanShenModel:getMagicById(data.Id)
    
    dxyExtendEvent(self)
    -- 拦截
    dxySwallowTouches(self)
    
    self._spStone = self._csb:getChildByName("spStone")
    local SkillConfig = YuanShenConfig:getUpSkillPro(self._data.Id,self._data.skillLv)
--    spStone:setTexture(PATH..GoodsConfigProvider:findGoodsById(SkillConfig.ID).Icon..".png")
    
    self._txtGold = self._csb:getChildByName("txtGold")
    
    self._txtStone = self._csb:getChildByName("txtStone")
    
    local btnSure = self._csb:getChildByName("btnSure")
    btnSure:addTouchEventListener(function(target,type)
        if type == 2 then
            SoundsFunc_playSounds(SoundsType.UNIVERSAL_BTN,false)
            zzc.YuanShenController:upGradeSkill(self._data.skillId)
        end
    end)
    
    local btnCancel = self._csb:getChildByName("btnCancel")
    btnCancel:addTouchEventListener(function(target,type)
        if type == 2 then
            SoundsFunc_playSounds(SoundsType.CLOSE_PAGE,false)
            self:removeFromParent()
        end
    end)
    
    self:updateRes(data)
end

function ConsumeSkill:initEvent()
    dxyDispatcher_addEventListener("ConsumeSkill_updateRes",self,self.updateRes)
end

function ConsumeSkill:removeEvent()
    dxyDispatcher_removeEventListener("ConsumeSkill_updateRes",self,self.updateRes)
end

function ConsumeSkill:updateRes(data)
    local config = YuanShenConfig:getUpSkillPro(data.Id,data.skillLv)
--    self._spStone:setTexture(PATH..GoodsConfigProvider:findGoodsById(config.ID).Icon..".png")
    self._spStone:setSpriteFrame(cc.SpriteFrameCache:getInstance():getSpriteFrame(PATH..GoodsConfigProvider:findGoodsById(config.ID).Icon..".png"))

    self._txtGold:setString("×"..config.Gold)
    local max = zzm.CharacterModel:findStone(config.ID)
    self._txtStone:setString(max.."/"..config.Num)
end

return ConsumeSkill