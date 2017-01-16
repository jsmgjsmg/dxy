FairySkill = FairySkill or class("FairySkill",function()
    return cc.Node:create()
end)
local PATH = "res/dxyCocosStudio/csd/ui/fairy/"

function FairySkill:ctor()
    self.visibleSize = cc.Director:getInstance():getVisibleSize()
    self.origin = cc.Director:getInstance():getVisibleOrigin()
end

function FairySkill:create(data)
    local node = FairySkill:new()
    node:init(data)
    return node
end

function FairySkill:init(data)
    self._csb = cc.CSLoader:createNode("res/dxyCocosStudio/csd/ui/fairy/FairySkill.csb")
    self:addChild(self._csb)
    self._csb:setPosition(self.origin.x + self.visibleSize.width / 2, self.origin.y + self.visibleSize.height / 2)
    
    self._data = data
    local BaseConfig = FairyConfig:getBaseConfig(self._data.Id)

    dxyExtendEvent(self)
    
    local Image = self._csb:getChildByName("Image")
    dxySwallowTouches(self,Image)
    
--skill
    local skillData = FairyConfig:getPassiveIcon(data["Id"])
    local fairyConfig = FairyConfig:getFairyConfig(data["Id"])
    local spSkill = self._csb:getChildByName("bgSkill"):getChildByName("spSkill")
    spSkill:setTexture(skillData.SkillIcon)

--txt    
    local txtName = self._csb:getChildByName("txtName")
    txtName:setString(skillData.SkillName)

    local txtCon = self._csb:getChildByName("txtCon")
    txtCon:setString(fairyConfig.SkillConsume)

    local txtInt = self._csb:getChildByName("txtInt")
    txtInt:setString(skillData.Info)

    self._btnPutOn = self._csb:getChildByName("btnPutOn")
    self._btnPutDown = self._csb:getChildByName("btnPutDown")
    self._txtTips = self._csb:getChildByName("txtTips")
    
    if self._data.sk_Islock ~= 0 then
        if self._data.curSkill == 0 then
            self._btnPutOn:setVisible(true)
            self._btnPutDown:setVisible(false)
        else
            self._btnPutOn:setVisible(false)
            self._btnPutDown:setVisible(true)
        end
    else
        self._txtTips:setVisible(true)
        self._txtTips:setString("仙女"..BaseConfig.DeblockingSkillLV.."级解锁技能")
    end
    
    self._btnPutOn:addTouchEventListener(function(target,type)
        if type == 2 then
            SoundsFunc_playSounds(SoundsType.USE_GOODS,false)
            zzc.FairyController:skillControll(data.Id,1)
            self:removeFromParent()
        end
    end)
    
    self._btnPutDown:addTouchEventListener(function(target,type)
        if type == 2 then
            SoundsFunc_playSounds(SoundsType.USE_GOODS,false)
            zzc.FairyController:skillControll(data.Id,0)
            self:removeFromParent()
        end
    end)
end

function FairySkill:initEvent()
    dxyDispatcher_addEventListener("FairySkill_updateSkillState",self,self.updateSkillState)
end

function FairySkill:removeEvent()
    dxyDispatcher_removeEventListener("FairySkill_updateSkillState",self,self.updateSkillState)
end

function FairySkill:updateSkillState(data)
    if self._data.Id == data.Id then
        if data.curSkill == 0 then
            self._btnPutOn:setVisible(true)
            self._btnPutDown:setVisible(false)
            dxyFloatMsg:show("已卸下")
        else
            self._btnPutOn:setVisible(false)
            self._btnPutDown:setVisible(true)
            dxyFloatMsg:show("装备成功")
        end
    end
end
