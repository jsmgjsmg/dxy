FairyNode = FairyNode or class("FairyNode",function()
    return cc.Node:create()
end)
local PATH = "dxyCocosStudio/png/fairy/"

function FairyNode:ctor()
    self.visibleSize = cc.Director:getInstance():getVisibleSize()
    self.origin = cc.Director:getInstance():getVisibleOrigin()
end

function FairyNode:create(j)
    local node = FairyNode:new()
    node:init(j)
    return node
end

function FairyNode:init(j)
    self._csb = cc.CSLoader:createNode("dxyCocosStudio/csd/ui/fairy/FairyNode.csb")
    self:addChild(self._csb)
    self._csb:setPosition(self.origin.x + self.visibleSize.width / 2, self.origin.y + self.visibleSize.height / 2)
    
    local timeLine = cc.CSLoader:createTimeline("dxyCocosStudio/csd/ui/fairy/FairyNode.csb")
    self._csb:runAction(timeLine)
    timeLine:gotoFrameAndPlay(0,true)
    timeLine:setTimeSpeed(0.8)
    
    local swallow = self._csb:getChildByName("swallow")
    swallow:setContentSize(self.visibleSize.width,self.visibleSize.height)
    swallow:setPositionY(self.visibleSize.height / 2 - 67)
    swallow:setSwallowTouches(true)
    
    self._data = zzm.FairyModel.arrFairyData[j]
    
    self._left = self._csb:getChildByName("ndLeft")
    self._right = self._csb:getChildByName("ndRight")

    dxyExtendEvent(self)

---Left--------------------------------------------------------------------------    
--返回按钮
    local ndBack = self._left:getChildByName("ndBack")
    ndBack:setPosition(-self.visibleSize.width/2,self.visibleSize.height/2)
    local btn_back = ndBack:getChildByName("btn_back")
    btn_back:addTouchEventListener(function(target,type)
        if type == 2 then
            SoundsFunc_playSounds(SoundsType.CLOSE_PAGE,false)
            if(FairyNode._handle)then
                cc.Director:getInstance():getScheduler():unscheduleScriptEntry(FairyNode._handle)
                FairyNode._handle = nil
            end
            self:removeFromParent()
        end
    end)

--级数、鲜花、体力    
    self._txtLv = self._left:getChildByName("lv"):getChildByName("txt_lv")
    self._txtFlower = self._left:getChildByName("flower"):getChildByName("txt_flower")
    self._lbPower = self._left:getChildByName("bgPower"):getChildByName("lb_power")
    self._txtPower = self._left:getChildByName("bgPower"):getChildByName("txt_power")

--图片、技能、名字
    local bgFairy = self._left:getChildByName("bgFairy")
    local bgLight = bgFairy:getChildByName("bgFairy")
    local spFairy = bgFairy:getChildByName("spFairy")
    local spName = bgFairy:getChildByName("spName")
    bgLight:setSpriteFrame(cc.SpriteFrameCache:getInstance():getSpriteFrame(PATH.."pj_"..j.."_big.png"))
    spFairy:setSpriteFrame(cc.SpriteFrameCache:getInstance():getSpriteFrame(PATH..FairyConfig:getFairyIcon(self._data["Id"])..".png"))
    spName:setSpriteFrame(cc.SpriteFrameCache:getInstance():getSpriteFrame(PATH..FairyConfig:getFairyName(self._data["Id"])..".png"))

    local bgSkill = bgFairy:getChildByName("bgSkill")
    self._lock = bgSkill:getChildByName("lock")
    self._btnSkill = bgSkill:getChildByName("btnSkill")
    local skillData = FairyConfig:getPassiveIcon(self._data["Id"])
    self._btnSkill:loadTextureNormal(skillData["SkillIcon"])
    self._btnSkill:loadTexturePressed(skillData["SkillIcon"])
    self._btnSkill:addTouchEventListener(function(target,type)
        if type == 2 then
            --弹出技能信息
            SoundsFunc_playSounds(SoundsType.OPEN_PAGE,false)
            require "src.game.fairy.view.FairySkill"
            local skill = FairySkill:create(self._data)
            self:addChild(skill)
        end
    end)

--帮助
    local btn_help = self._left:getChildByName("btn_help")
    btn_help:addTouchEventListener(function(target,type)
        if type == 2 then
            --弹出提示按钮
            SoundsFunc_playSounds(SoundsType.OPEN_PAGE,false)
            TipsFrame:create("帮助")
        end
    end)
    
    
---Right--------------------------------------------------------------------------
--双修倒数时间
    self.bgTime = self._right:getChildByName("bgTime")
    self._txtTime = self.bgTime:getChildByName("txtTime")

    local bgHeart = self._right:getChildByName("bgHeart") 
--好感度
    self._bflFeel = bgHeart:getChildByName("bfl_feel")
    self._lbFeel = bgHeart:getChildByName("lb_feel")
    self._light = bgHeart:getChildByName("light")
    self._spFeel = bgHeart:getChildByName("spFeel")
    self._ndClip = bgHeart:getChildByName("ndClip")
    self._heartSize = bgHeart:getContentSize()
    
--裁剪

    require "game.fairy.view.HeartEffect"
    self._effect = HeartEffect:create()

    local clipping = cc.ClippingNode:create()
    self._sp = cc.Sprite:create("res/dxyCocosStudio/png/fairy/effect/TM.png")
    clipping:setStencil(self._sp)
    clipping:addChild(self._effect)
    clipping:setInverted(true)
    self._ndClip:addChild(clipping)
    
--赠送、双修
    self._btnDoit = self._right:getChildByName("btn_doit")
    if self._data.Lv == 0 then
        self._btnDoit:setTouchEnabled(false)
        self._btnDoit:setBright(false)
    end
    self._btnGive = self._right:getChildByName("btn_give")
    self._txtNum = self._btnGive:getChildByName("txtNum")
    self._btnDoit:addTouchEventListener(function(target,type)
        if type == 2 then
            SoundsFunc_playSounds(SoundsType.OPEN_PAGE,false)
            require "src.game.fairy.view.HoleNode"
            local _csb = HoleNode:create(self._data)
            self:addChild(_csb)
        end
    end)
    self._btnGive:addTouchEventListener(function(target,type)
        if type == 2 then
            SoundsFunc_playSounds(SoundsType.UNIVERSAL_BTN,false)
            if self._data["Lv"] >= FairyConfig:getMaxLvByFairy() then
--                self._btnGive:setTouchEnabled(false)
--                self._btnGive:setBright(false)
                self._txtNum:setString(0)
                self._txtPercent:setString("0%")
                dxyFloatMsg:show("仙女已到达等级上限")
            else
                zzc.FairyController:registerGiveFlowers(self._data["Id"])
            end
        end
    end)
    
    self._txtPercent = self._btnGive:getChildByName("txtPer"):getChildByName("txtPercent")
    
--属性加成
    local bgPros = self._right:getChildByName("bgPros")
    self._bflAtk = bgPros:getChildByName("bfl_atk")
    self._bflDef = bgPros:getChildByName("bfl_def")
    self._bflHp = bgPros:getChildByName("bfl_hp")
    
    self:updateGiveFlowers(self._data)
    self:updatePower(self._data)
    self:unLockSkill(self._data)
    if self._data["isDoit"] == 1 then
        self:updateDoit(self._data)
    end
end

function FairyNode:initEvent()
    dxyDispatcher_addEventListener("updateGiveFlowers",self,self.updateGiveFlowers)
    dxyDispatcher_addEventListener("updateDoit",self,self.updateDoit)
    dxyDispatcher_addEventListener("FairyNode_updatePower",self,self.updatePower)
    dxyDispatcher_addEventListener("unLockSkill",self,self.unLockSkill)
end

function FairyNode:removeEvent()
    dxyDispatcher_removeEventListener("updateGiveFlowers",self,self.updateGiveFlowers)
    dxyDispatcher_removeEventListener("updateDoit",self,self.updateDoit)
    dxyDispatcher_removeEventListener("FairyNode_updatePower",self,self.updatePower)
    dxyDispatcher_removeEventListener("unLockSkill",self,self.unLockSkill)
end

function FairyNode:updateGiveFlowers(data) --赠送鲜花
--等级、鲜花
    self._data = data
    
    if self._data.Lv == 0 then
        self._btnDoit:setTouchEnabled(false)
        self._btnDoit:setBright(false)
    else
        self._btnDoit:setTouchEnabled(true)
        self._btnDoit:setBright(true)
    end

    self._txtLv:setString(self._data["Lv"])
    self._txtFlower:setString(cn:convert(_G.FairyData.Flower))
--好感度    
    local feel = FairyConfig:getFavorMaxByFairy(self._data["Id"])
    self._bflFeel:setString(self._data["FD"].."/"..feel)
    self._lbFeel:setPercent(self._data["FD"]/feel*100)
    
    local percent = self._data["FD"]/feel
    self._sp:setPositionY(self._heartSize.height*percent)
    
    
--属性加成
    self._bflAtk:setString(self._data["Atk"])
    self._bflDef:setString(self._data["Def"])
    self._bflHp:setString(self._data["Hp"])
--赠送鲜花数
    self._txtNum:setString(FairyConfig:getFlowerByFairy(self._data["Id"],self._data["Lv"]))
    self._txtPercent:setString(FairyConfig:getLvUpConfig(self._data["Lv"]).SendFlowersOdds.."%")
end

function FairyNode:updateDoit(data) --双修时间
    self._data = data

    if self._data["isDoit"] == 1 then
        local _overTime = self._data["overTime"]
        local count = _overTime - os.time() - _G.DiffTimer
        if count > 0 then
            local interval = 1
            self.bgTime:setVisible(true)
            local showTime = (string.format("%02d",os.date("%H",count)-8))..":"..os.date("%M",count)..":"..os.date("%S",count)
            self._txtTime:setString(showTime)
            local sharedScheduler = cc.Director:getInstance():getScheduler()
            FairyNode._handle = sharedScheduler:scheduleScriptFunc(function()
                count = count - 1
                local showTime = (string.format("%02d",os.date("%H",count)-8))..":"..os.date("%M",count)..":"..os.date("%S",count)
                self._txtTime:setString(showTime)
                if count <= 0 then
                    if(FairyNode._handle)then
                        cc.Director:getInstance():getScheduler():unscheduleScriptEntry(FairyNode._handle)
                        FairyNode._handle = nil
                        self.bgTime:setVisible(false)
                    end
                end
            end,1,false)
        end
    elseif self._data["isDoit"] == 0 then
        self.bgTime:setVisible(false)
    end
end

function FairyNode:updatePower(data)--双修疲劳
    self._data = data

    local _txtPower = self._data["FV"]
    local FV = FairyConfig:getFVByFairy(self._data["Id"])
    self._txtPower:setString(_txtPower.."/"..FV)
    self._lbPower:setPercent(_txtPower/FV*100)
end 

function FairyNode:unLockSkill(data)
    self._data = data

    if data["sk_Islock"] == 1 then
        self._lock:setVisible(false)
    end
end

