FairyInfoLayer = FairyInfoLayer or class("FairyInfoLayer",function()
	return cc.Layer:create()
end)
local PATH = "dxyCocosStudio/png/fairy/"

function FairyInfoLayer:create()
    local layer = FairyInfoLayer:new()
    return layer
end

function FairyInfoLayer:ctor()
	self._csb = nil
	
	self:initUI()
--	self:initEvent()
end

function FairyInfoLayer:initUI()
	self._csb = cc.CSLoader:createNode("dxyCocosStudio/csd/ui/roleinfo/fairyInfoLayer.csb")
	self:addChild(self._csb)
	
    dxyExtendEvent(self)
	
	self.txt_lv = self._csb:getChildByName("lv")
	
	local bg = self._csb:getChildByName("bg")
	self.bgFairy = bg:getChildByName("bgFairy")
	self.fairyIcon = bg:getChildByName("fairyIcon")
	self.fairyName = bg:getChildByName("name")
	
    self.skillFrame = bg:getChildByName("skillFrame")
    self.skillIcon = self.skillFrame:getChildByName("skillIcon")
    self.skillLock = bg:getChildByName("skillLock")
    
    self.txt_atk = self._csb:getChildByName("ATK")
    self.txt_def = self._csb:getChildByName("DEF")
    self.txt_hp = self._csb:getChildByName("HP")
    
    if _G.RankData.Uid == _G.RoleData.Uid then
        self:MinePro()
    else
        zzc.RoleinfoController:getDataWithPro(_G.RankData.Uid,6)
    end
	
end

--function FairyInfoLayer:initEvent()
--    local PATH = "dxyCocosStudio/png/fairy/"
--    local data = zzm.FairyModel.arrFairyData
--    local count = #zzm.FairyModel.arrFairyData
--    local index = 1
--    for var=count, 1, -1 do
--        if data[var]["isLock"] == 1 then
--    		index = var
--    		break
--    	end
--    end
--    self.bgFairy:loadTexture(PATH.."halo"..index..".png")
--    self.fairyIcon:setTexture(PATH..FairyConfig:getFairyIcon(data[index]["Id"]).."_min1.png")
--    self.fairyName:setTexture(PATH..FairyConfig:getFairyName(data[index]["Id"])..".png")
--    
--    local skillData = FairyConfig:getPassiveIcon(data[index]["Id"])
--    self.skillIcon:setTexture(skillData["SkillIcon"])
--    
--    if data[index]["sk_Islock"] == 1 then
--        self.skillLock:setVisible(false)
--    else
--        self.skillLock:setVisible(true)
--    end
--    
--    self.txt_lv:setString("LV:"..data[index]["Lv"])
--    self.txt_atk:setString(data[index]["Atk"])
--    self.txt_def:setString(data[index]["Def"])
--    self.txt_hp:setString(data[index]["Hp"])
--end

function FairyInfoLayer:initEvent()
    dxyDispatcher_addEventListener("FairyInfoLayer_update",self,self.update)
end

function FairyInfoLayer:removeEvent()
    dxyDispatcher_removeEventListener("FairyInfoLayer_update",self,self.update)
end

function FairyInfoLayer:update()
    local FAIRY = zzm.RoleinfoModel._arrRoleData.FAIRY
    
    local curId = FAIRY.Id or zzm.FairyModel.arrFairyData[1]["Id"]
    local index = FairyConfig:getKeyById(curId) 
    local skillData = FairyConfig:getPassiveIcon(curId)
    if FAIRY.Id then
--        self.bgFairy:setTexture(PATH.."halo"..index..".png")
        self.bgFairy:setSpriteFrame(cc.SpriteFrameCache:getInstance():getSpriteFrame(PATH.."halo"..index..".png"))
        self.fairyIcon:setSpriteFrame(cc.SpriteFrameCache:getInstance():getSpriteFrame(PATH..FairyConfig:getFairyIcon(curId).."_min1.png"))
        self.fairyName:setSpriteFrame(cc.SpriteFrameCache:getInstance():getSpriteFrame(PATH.."xn_"..index.."_name1.png"))
        self.skillFrame:setSpriteFrame(cc.SpriteFrameCache:getInstance():getSpriteFrame(PATH.."skill_N.png"))
        self.skillIcon:setTexture(skillData.SkillIcon)
        if FAIRY.sk_isLock and FAIRY.sk_isLock == 0 then
            self.skillLock:setTexture(PATH.."lock1.png")
            self.skillLock:setVisible(true)
        else
            self.skillLock:setVisible(false)
        end
    else
        self.bgFairy:setTexture(PATH.."halo0.png")
        self.fairyIcon:setSpriteFrame(cc.SpriteFrameCache:getInstance():getSpriteFrame(PATH..FairyConfig:getFairyIcon(curId).."_min2.png"))
        self.fairyName:setSpriteFrame(cc.SpriteFrameCache:getInstance():getSpriteFrame(PATH.."xn_"..index.."_name2.png"))
        self.skillFrame:setSpriteFrame(cc.SpriteFrameCache:getInstance():getSpriteFrame(PATH.."skill_D.png"))
        self.skillIcon:setTexture(skillData.SkillLockIcon)
        self.skillLock:setVisible(true)
    end
    self.bgFairy:setVisible(true)
    self.fairyIcon:setVisible(true)
    self.fairyName:setVisible(true)
    self.skillFrame:setVisible(true)
    self.skillIcon:setVisible(true)
    
    local lv = FAIRY["Lv"] or 0
    self.txt_lv:setString("LV:"..lv)
    self.txt_atk:setString(FAIRY.AllAtk or 0)
    self.txt_def:setString(FAIRY.AllDef or 0)
    self.txt_hp:setString(FAIRY.AllHp or 0)
end

function FairyInfoLayer:MinePro()
    local data = zzm.FairyModel.arrFairyData
    local count = #zzm.FairyModel.arrFairyData
    local index = 1
    for var=count, 1, -1 do
        if data[var]["isLock"] == 1 then
            index = var
            break
        end
    end
    local skillData = FairyConfig:getPassiveIcon(data[index]["Id"])
    if data[index].isLock == 1 then
        self.bgFairy:setSpriteFrame(cc.SpriteFrameCache:getInstance():getSpriteFrame(PATH.."halo"..index..".png"))
        self.fairyIcon:setSpriteFrame(cc.SpriteFrameCache:getInstance():getSpriteFrame(PATH..FairyConfig:getFairyIcon(data[index]["Id"]).."_min1.png"))
        self.fairyName:setSpriteFrame(cc.SpriteFrameCache:getInstance():getSpriteFrame(PATH.."xn_"..index.."_name1.png"))
        self.skillFrame:setSpriteFrame(cc.SpriteFrameCache:getInstance():getSpriteFrame(PATH.."skill_N.png"))
        self.skillIcon:setTexture(skillData.SkillIcon)
        if data[index].sk_Islock == 0 then
            self.skillLock:setTexture(PATH.."lock1.png")
            self.skillLock:setVisible(true)
        else
            self.skillLock:setVisible(false)
        end
    else
        self.bgFairy:setSpriteFrame(cc.SpriteFrameCache:getInstance():getSpriteFrame(PATH.."halo0.png"))
        self.fairyIcon:setSpriteFrame(cc.SpriteFrameCache:getInstance():getSpriteFrame(PATH..FairyConfig:getFairyIcon(data[index]["Id"]).."_min2.png"))
        self.fairyName:setSpriteFrame(cc.SpriteFrameCache:getInstance():getSpriteFrame(PATH.."xn_"..index.."_name2.png"))
        self.skillFrame:setSpriteFrame(cc.SpriteFrameCache:getInstance():getSpriteFrame(PATH.."skill_D.png"))
        self.skillIcon:setTexture(skillData.SkillLockIcon)
        self.skillLock:setVisible(true)
    end
    
    self.bgFairy:setVisible(true)
    self.fairyIcon:setVisible(true)
    self.fairyName:setVisible(true)
    self.skillFrame:setVisible(true)
    self.skillIcon:setVisible(true)
    
    self.txt_lv:setString("LV:"..data[index]["Lv"])
    
    local _allAtk = 0
    local _allDef = 0
    local _allHp = 0
    for i=1,3 do
        if zzm.FairyModel.arrFairyData[i]["Atk"] and zzm.FairyModel.arrFairyData[i]["Atk"] ~= 0 then
            _allAtk = _allAtk + zzm.FairyModel.arrFairyData[i]["Atk"]
            _allDef = _allDef + zzm.FairyModel.arrFairyData[i]["Def"]
            _allHp = _allHp + zzm.FairyModel.arrFairyData[i]["Hp"]
        end
    end
    self.txt_atk:setString(_allAtk)
    self.txt_def:setString(_allDef)
    self.txt_hp:setString(_allHp)
end