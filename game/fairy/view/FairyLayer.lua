FairyLayer = FairyLayer or class("FairyLayer",function()
    return cc.Node:create()
end)
local PATH = "dxyCocosStudio/png/fairy/"

function FairyLayer:ctor()
    self.winSize = cc.Director:getInstance():getVisibleSize()
    self.origin = cc.Director:getInstance():getVisibleOrigin()
    self._arrBtn = {}
    self._arrName = {}
    self._arrLock = {}
    self._bgSkill = {}
    self._arrSkill = {}
    self._arrHalo = {}
    self._arrSkillInt = {}    
    cc.SpriteFrameCache:getInstance():addSpriteFrames("res/dxyCocosStudio/png/fairy/Change1.plist")
end

function FairyLayer:create()
    local layer = FairyLayer:new()
    layer:init()
    return layer
end

function FairyLayer:init()
    self._csb = cc.CSLoader:createNode("dxyCocosStudio/csd/ui/fairy/FairyLayer.csb")
    self:addChild(self._csb)
--    local csbSize = self._csb:getContentSize()
--    local rowGap = (self.winSize.width - csbSize.width) / 2
--    local listGap = (self.winSize.height - csbSize.height) / 2
    self._csb:setPosition(self.origin.x + self.winSize.width / 2, self.origin.y + self.winSize.height / 2)
    
    dxyExtendEvent(self)
    -- 拦截
    dxySwallowTouches(self)
    
--    local swallow = self._csb:getChildByName("swallow")
--    swallow:setContentSize(self.winSize.width,self.winSize.height)
    local Image = self._csb:getChildByName("Image")
    Image:setContentSize(self.winSize.width,self.winSize.height)

--title    
    require "src.game.utils.TopTitleNode"
    local node = TopTitleNode:create(self,PATH.."txt2.png")
    self:addChild(node)
    
    self._FairyNum = FairyConfig:getFairyNum()
    
    local ndBtn = self._csb:getChildByName("ndBtn")
    for i=1,self._FairyNum do
        local mo = ndBtn:getChildByName("mo"..i)
        self._arrBtn[i] = mo:getChildByName("btnFairy")
        self._arrName[i] = mo:getChildByName("spName")
        self._bgSkill[i] = mo:getChildByName("bgSkill")
        self._arrLock[i] = self._bgSkill[i]:getChildByName("lock")
        self._arrSkill[i] = self._bgSkill[i]:getChildByName("btnSkill")
        self._arrHalo[i] = mo:getChildByName("halo")
  --仙女状态 /技能状态  
        self:unLockFairy(i)
    end

--Btn
    for j=1,self._FairyNum do
        self._arrBtn[j]:addTouchEventListener(function(target,type)
            if type == 2 then
                SoundsFunc_playSounds(SoundsType.OPEN_PAGE,false)
                local data = zzm.FairyModel.arrFairyData[j]
                if data["isLock"] == 1 then
                    --仙女按钮
                    require "src.game.fairy.view.FairyNode"
                    local _fairy = FairyNode:create(j)
                    self:addChild(_fairy)
                else
                    --提示开锁条件信息
                    TipsFrame:create(FairyConfig:getLockInfo(data["Id"]))
                end
            end
        end)
    
        --技能按钮
        self._arrSkill[j]:addTouchEventListener(function(target,type)
            if type == 2 then
                SoundsFunc_playSounds(SoundsType.OPEN_PAGE,false)
                TipsFrame:create(self._arrSkillInt[j]["SkillName"].."\n"..self._arrSkillInt[j]["Info"])
            end
        end)
    end
    
--总属性加成
    local ndDown = self._csb:getChildByName("ndDown") 
    self._atk = ndDown:getChildByName("bfl_atk")
    self._def = ndDown:getChildByName("bfl_def")
    self._hp = ndDown:getChildByName("bfl_hp")
    local btnHelp = ndDown:getChildByName("btnHelp")
    btnHelp:addTouchEventListener(function(target,type)
        if type == 2 then
            SoundsFunc_playSounds(SoundsType.OPEN_PAGE,false)
            TipsFrame:create("仙女介绍........")
        end
    end)
    
    self:upDatePro()
end

function FairyLayer:initEvent()
    dxyDispatcher_addEventListener("unLockFairy",self,self.unLockFairy)
    dxyDispatcher_addEventListener("upDatePro",self,self.upDatePro)
end

function FairyLayer:removeEvent()
    dxyDispatcher_removeEventListener("unLockFairy",self,self.unLockFairy)
    dxyDispatcher_removeEventListener("upDatePro",self,self.upDatePro)
end

function FairyLayer:upDatePro()
    local _allAtk = 0
    local _allDef = 0
    local _allHp = 0
    for i=1,self._FairyNum do
        if zzm.FairyModel.arrFairyData[i]["Atk"] and zzm.FairyModel.arrFairyData[i]["Atk"] ~= 0 then
            _allAtk = _allAtk + zzm.FairyModel.arrFairyData[i]["Atk"]
            _allDef = _allDef + zzm.FairyModel.arrFairyData[i]["Def"]
            _allHp = _allHp + zzm.FairyModel.arrFairyData[i]["Hp"]
        end
    end
    self._atk:setString(_allAtk)
    self._def:setString(_allDef)
    self._hp:setString(_allHp)
end

function FairyLayer:unLockFairy(i)
    local data = zzm.FairyModel.arrFairyData[i]
    if data["isLock"] == 1 then
        self._arrBtn[i]:setBright(true)
        self._arrHalo[i]:setSpriteFrame(cc.SpriteFrameCache:getInstance():getSpriteFrame(PATH.."halo"..i..".png"))
        self._arrName[i]:setSpriteFrame(cc.SpriteFrameCache:getInstance():getSpriteFrame(PATH..FairyConfig:getFairyName(data["Id"])..".png"))
        self._bgSkill[i]:setSpriteFrame(cc.SpriteFrameCache:getInstance():getSpriteFrame(PATH.."skill_N.png"))
        self._arrSkillInt[i] = FairyConfig:getPassiveIcon(data["Id"])
        self._arrSkill[i]:loadTextureNormal(self._arrSkillInt[i]["SkillIcon"])
        self._arrSkill[i]:loadTexturePressed(self._arrSkillInt[i]["SkillIcon"])
        if data["sk_Islock"] == 1 then
            self._arrLock[i]:setVisible(false)    
        elseif data["sk_Islock"] == 0 then
            self._arrLock[i]:setSpriteFrame(cc.SpriteFrameCache:getInstance():getSpriteFrame(PATH.."lock1.png"))
        end
    elseif data["isLock"] == 0 then
        self._arrBtn[i]:setBright(false)
        self._arrSkillInt[i] = FairyConfig:getPassiveIcon(data["Id"])
        self._arrSkill[i]:loadTextureNormal(self._arrSkillInt[i]["SkillLockIcon"])
        self._arrSkill[i]:loadTexturePressed(self._arrSkillInt[i]["SkillLockIcon"])
    end
    
end