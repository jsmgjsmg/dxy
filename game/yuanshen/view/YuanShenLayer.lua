YuanShenLayer = YuanShenLayer or class("YuanShenLayer",function()
    return ccui.Layout:create()
end)
local PATH = "dxyCocosStudio/png/yuanshen/"
local STONE_PATH = "dxyCocosStudio/png/yuanshen/stone/"
local STAR = 9

function YuanShenLayer:ctor()
    self.winSize = cc.Director:getInstance():getVisibleSize()
    self.origin = cc.Director:getInstance():getVisibleOrigin()
    self._arrStar = {}   --星星
    self._arrBtn = {}    --page按钮
    self._arrState = {}  --
    self._arrTips = {}   --提示*
    self._lastBtn = nil  --上一个按钮
    self._stoneIcon = {}
end

function YuanShenLayer:create()
    local layer = YuanShenLayer:new()
    layer:init()
    return layer
end

function YuanShenLayer:init()
    self._csb = cc.CSLoader:createNode("res/dxyCocosStudio/csd/ui/yuanshen/YuanShenLayer.csb")
    self:addChild(self._csb)

    dxyExtendEvent(self)

--    local csbSize = self._csb:getContentSize()
--    local rowGap = (self.winSize.width - csbSize.width) / 2
--    local listGap = (self.winSize.height - csbSize.height) / 2
    self._csb:setPosition(self.origin.x + self.winSize.width / 2, self.origin.y + self.winSize.height / 2)
    local swallow = self._csb:getChildByName("swallow")
    swallow:setContentSize(self.winSize.width,self.winSize.height)

---ndRes
    local ndRes = self._csb:getChildByName("ndRes")
    self._txtQS = ndRes:getChildByName("txtQS")
    self._txtKS = ndRes:getChildByName("txtKS")
    self._stoneIcon["401101"] = ndRes:getChildByName("txtQS")
    self._stoneIcon["401201"] = ndRes:getChildByName("txtKS")

    ---left
    self._ndLeft = self._csb:getChildByName("ndLeftt")

    --name
    self._name = self._ndLeft:getChildByName("name")
    
    --magic 
    self._MagicIcon = self._ndLeft:getChildByName("Icon")
    self._posx,self._posy = self._MagicIcon:getPosition()
    local action1 = cc.EaseSineInOut:create(cc.MoveBy:create(1.8,cc.p(0,30)))
    local action2 = cc.EaseSineInOut:create(cc.MoveBy:create(1.8,cc.p(0,-30)))
    local sequence = cc.Sequence:create(action1,action2)
    self._forever = cc.RepeatForever:create(sequence)
    self._forever:retain()
    
    --bg
    local bgw = self._ndLeft:getChildByName("bgw")
    local bgn = self._ndLeft:getChildByName("bgn")
    local rotateto = cc.RotateBy:create(1,10)
    local rotateto2 = cc.RotateBy:create(1,-10)
    local pos = cc.RepeatForever:create(rotateto)
    local aga = cc.RepeatForever:create(rotateto2)
    bgw:runAction(pos)
    bgn:runAction(aga)

    --star
    self._ndHide = self._ndLeft:getChildByName("ndHide")
--    self._txtAllRes = self._ndHide:getChildByName("txtAllRes")
    local ndStar = self._ndHide:getChildByName("ndStar")
    for i=1,STAR do
        local bg = ndStar:getChildByName("bg"..i)
        self._arrStar[i] = bg:getChildByName("start")
    end

    --unlock
    self._unLock = self._ndLeft:getChildByName("ndunLock")
    self._lbExp = self._unLock:getChildByName("bgExp"):getChildByName("lbExp")
    self._txtExp = self._unLock:getChildByName("bgExp"):getChildByName("txtExp")
    local btnGold = self._unLock:getChildByName("btnGold")
    local btnYB = self._unLock:getChildByName("btnYB")
    self._useGold = btnGold:getChildByName("txtUse")
    self._useYB = btnYB:getChildByName("txtUse")
    btnGold:addTouchEventListener(function(target,type)
        if type == 2 then
            SoundsFunc_playSounds(SoundsType.UNIVERSAL_BTN,false)
            zzc.YuanShenController:unLockMagic(self._curId,1)
        end
    end)
    btnYB:addTouchEventListener(function(target,type)
        if type == 2 then
            SoundsFunc_playSounds(SoundsType.UNIVERSAL_BTN,false)
            zzc.YuanShenController:unLockMagic(self._curId,2)
        end
    end)

    --pageView
    local ndPage = self._ndLeft:getChildByName("ndPage")
    self._pageView = ndPage:getChildByName("PageView")
    local cont = 0
    for i=1,2 do
        local panel = self._pageView:getChildByName("Panel_"..i)
        for j=1,3 do
            cont = cont + 1
            self._arrBtn[cont] = panel:getChildByName("smIcon"..j)
            self._arrState[cont] = self._arrBtn[cont]:getChildByName("txtState")
            self._arrTips[cont] = self._arrBtn[cont]:getChildByName("tips")
            if zzm.YuanShenModel._arrMagic[cont].isLock == 0 then
--                self._arrBtn[cont]:setTouchEnabled(false)
                self._arrBtn[cont]:setBright(false)
                self._arrState[cont]:setVisible(false)
            end
        end
    end
    
    self._lastBtn = self._arrBtn[1]
    if zzm.YuanShenModel._arrMagic[1].isLock == 1 then
        self:HideBtnForLight(1)
    end
    
    for k=1,6 do
        self._arrBtn[k]:addTouchEventListener(function(target,type)
            if type == 2 then
                SoundsFunc_playSounds(SoundsType.UNIVERSAL_BTN,false)
                local data = zzm.YuanShenModel._arrMagic[k]
                if zzm.YuanShenModel._arrMagic[k].isLock == 1 then
                    self._ndHide:setVisible(true)
                    self._unLock:setVisible(false)
                    self._curId = zzm.YuanShenModel._arrMagic[k].Id
                    self._curData = zzm.YuanShenModel._arrMagic[k]
                    self:HideBtnForLight(k)
                elseif zzm.YuanShenModel._arrMagic[k].isLock == 0 then
                    self._curId = zzm.YuanShenModel._arrMagic[k].Id
                    self._curData = zzm.YuanShenModel._arrMagic[k]
                    self._ndHide:setVisible(false)
                    self._unLock:setVisible(true)
                    self:HideBtnForLight()
                end
                self:changeMagicPro(data)
            end
        end)
    end
    self._curId = zzm.YuanShenModel._arrMagic[1].Id
    self._curData = zzm.YuanShenModel._arrMagic[1]

    local btnLeft = ndPage:getChildByName("btnLeft")
    local btnRight = ndPage:getChildByName("btnRight")
    btnLeft:addTouchEventListener(function(target,type)
        if type == 2 then
            SoundsFunc_playSounds(SoundsType.UNIVERSAL_BTN,false)
            local index = self._pageView:getCurPageIndex()
            self._pageView:scrollToPage(index-1)
        end
    end)
    btnRight:addTouchEventListener(function(target,type)
        if type == 2 then
            SoundsFunc_playSounds(SoundsType.UNIVERSAL_BTN,false)
            if 3 then
                local index = self._pageView:getCurPageIndex()
                self._pageView:scrollToPage(index+1)
            else

            end
        end
    end)

    local btnUp =  self._csb:getChildByName("btnUp")--self._ndHide:getChildByName("btnUp")
    btnUp:addTouchEventListener(function(target,type)
        if type == 2 then   
            SoundsFunc_playSounds(SoundsType.UPGRADE_MAGIC,false)
            zzc.YuanShenController:upGradeStar(self._curId)
        end
    end)
    self._txtUse = btnUp:getChildByName("txtUse")
    self._stoneIcon["401101"] = btnUp:getChildByName("spQS")
    self._stoneIcon["401201"] = btnUp:getChildByName("spKS")


    ---right
    --skill
    self._ndRight = self._csb:getChildByName("ndRight")
    local bgSkill = self._ndRight:getChildByName("bgSkill")
    self._SkillIcon = bgSkill:getChildByName("skillIcon")
    self._SkillLv = bgSkill:getChildByName("skillLv")

    --int
    local bgInt = self._ndRight:getChildByName("bgInt")
    self._txtTitle = bgInt:getChildByName("txtTitle")
    self._txtContent = bgInt:getChildByName("txtContent")

    --pro
    local ndPro = self._ndRight:getChildByName("ndPro")
    self._txtAtk = ndPro:getChildByName("txtAtk")
    self._txtDef = ndPro:getChildByName("txtDef")
    self._txtHp = ndPro:getChildByName("txtHp")
    self._txtGold = ndPro:getChildByName("txtGold")
    self._txtStone = ndPro:getChildByName("txtStone")
    self._spStone = ndPro:getChildByName("spStone")
    self._btnUpSkill = ndPro:getChildByName("btnUpSkill")
    self._btnUpSkill:addTouchEventListener(function(target,type)
        if type == 2 then
            SoundsFunc_playSounds(SoundsType.UNIVERSAL_BTN,false)
            if self._curData.isLock ~= 0 then
--                local up = require("src.game.yuanshen.view.ConsumeSkill"):create(self._curData)
--                self:addChild(up)
                zzc.YuanShenController:upGradeSkill(self._curData.skillId)
            else
                TipsFrame:create("法器尚未解锁")
            end
        end
    end)
    
    --技能伤害 ljw 2016.02.24
    self._SkillJc = ndPro:getChildByName("SkillNameBg"):getChildByName("JC"):getChildByName("JC");
    self._SkillNextJc = ndPro:getChildByName("SkillNameBg"):getChildByName("JC"):getChildByName("NextJC");
    self._SkillJCJiantou = ndPro:getChildByName("SkillNameBg"):getChildByName("JC"):getChildByName("skill_jiantou_2");
    self._SkillGJ = ndPro:getChildByName("SkillNameBg"):getChildByName("GJ"):getChildByName("GJ");
    self._SkillNextGJ = ndPro:getChildByName("SkillNameBg"):getChildByName("GJ"):getChildByName("NextGJ");
    self._SkillGJJiantou = ndPro:getChildByName("SkillNameBg"):getChildByName("GJ"):getChildByName("skill_jiantou_2_0");
    
    local btnSyn = self._ndRight:getChildByName("btnSyn")
    btnSyn:addTouchEventListener(function(target,type)
        if type == 2 then
            SoundsFunc_playSounds(SoundsType.OPEN_PAGE,false)
            require"src.game.yuanshen.view.SkillStone"
            local stone = SkillStone:create()
            self:addChild(stone)
        end
    end)

    
    self:upDateTips() --提示可解锁
    self:updateAllRes() --法器升星
    self:upDateUnLock(zzm.YuanShenModel._arrMagic[1]) --解锁过程状态
    self:changeMagicPro(zzm.YuanShenModel._arrMagic[1]) --切换法器
    self:updateConsumeSkill(zzm.YuanShenModel._arrMagic[1]) --技能升级
end

function YuanShenLayer:initEvent()
    dxyDispatcher_addEventListener("upGradeSkill",self,self.upGradeSkill)
    dxyDispatcher_addEventListener("upGradeStar",self,self.upGradeStar)
    dxyDispatcher_addEventListener("upDateBtnState",self,self.upDateBtnState)
    dxyDispatcher_addEventListener("upDateTips",self,self.upDateTips)
    dxyDispatcher_addEventListener("upDateUnLock",self,self.upDateUnLock)
    dxyDispatcher_addEventListener("YuanShenLayer_updateAllRes",self,self.updateAllRes)
end

function YuanShenLayer:removeEvent()
    dxyDispatcher_removeEventListener("upGradeSkill",self,self.upGradeSkill)
    dxyDispatcher_removeEventListener("upGradeStar",self,self.upGradeStar)
    dxyDispatcher_removeEventListener("upDateBtnState",self,self.upDateBtnState)
    dxyDispatcher_removeEventListener("upDateTips",self,self.upDateTips)
    dxyDispatcher_removeEventListener("upDateUnLock",self,self.upDateUnLock)
    dxyDispatcher_removeEventListener("YuanShenLayer_updateAllRes",self,self.updateAllRes)
end

function YuanShenLayer:isLock(id)
    for key, var in pairs(zzm.YuanShenModel._arrMagic) do
    	if var.Id == id then
    	   if var.isLock == 1 then
    	       return var.skillId
    	   else
               TipsFrame:create("法器尚未解锁")
               return nil
    	   end
    	end
    end
end

--改变法器图标、技能信息
function YuanShenLayer:changeMagicPro(data) 
    local skData = YuanShenConfig:getSkillPro(data["Id"])
    self._SkillIcon:setTexture(skData["Icon"])
    self._txtTitle:setString(skData["Name"])
    self._txtContent:setString(skData["Info"])

    local nameIcon = YuanShenConfig:getMagicName(data["Id"])
    self._name:setSpriteFrame(cc.SpriteFrameCache:getInstance():getSpriteFrame(PATH..nameIcon)) --名字Icon
    
    if data["isLock"] == 1 then
        local magicIcon = YuanShenConfig:getMagicIconBig(data["Id"])
        self._MagicIcon:setSpriteFrame(cc.SpriteFrameCache:getInstance():getSpriteFrame(PATH..magicIcon)) --大法器Icon
        if self._MagicIcon:getNumberOfRunningActions() == 0 then
            self._MagicIcon:runAction(self._forever)
        end
        self:upGradeSkill(data)
    elseif data["isLock"] == 0 then
        local darkIcon = YuanShenConfig:getMagicIconDark(data["Id"])
        self._MagicIcon:setSpriteFrame(cc.SpriteFrameCache:getInstance():getSpriteFrame(PATH..darkIcon))
        if self._MagicIcon:getNumberOfRunningActions() ~= 0 then
            self._MagicIcon:stopAction(self._forever)
            self._MagicIcon:setPosition(self._posx,self._posy)
        end
        self:upDateUnLock(data)
    end
    self:upGradeStar(data)
    self:updateConsumeSkill(data)
end

--升级技能
function YuanShenLayer:upGradeSkill(data) 
    self._SkillLv:setString("Lv:"..data["skillLv"] or 1)
    self:updateConsumeSkill(data)
end

--升星
function YuanShenLayer:upGradeStar(data)
    for i=1,9 do
        self._arrStar[i]:setVisible(false)
    end
    if data["Star"] then
        local upRes = YuanShenConfig:getUpStarNeed(data["Id"],data["Star"])
        self._txtUse:setString(upRes["GoodsNum"])
        self:stoneIconCtr(upRes.GoodsId)
        self._txtAtk:setString(data["Atk"])
        self._txtDef:setString(data["Def"])
        self._txtHp:setString(data["Hp"])
        for i=1,data["Star"] do
            self._arrStar[i]:setVisible(true)
        end
    else
        self._txtUse:setString(0)
        self._txtAtk:setString(0)
        self._txtDef:setString(0)
        self._txtHp:setString(0)
        for i=1,9 do
            self._arrStar[i]:setVisible(false)
        end
    end
end

--更新升星资源
function YuanShenLayer:updateAllRes()
    local QS = zzm.CharacterModel:getGoodsById(401101)
    local KS = zzm.CharacterModel:getGoodsById(401201)
    self._txtQS:setString(QS.count or 0)
    self._txtKS:setString(KS.count or 0)
    self:IndirectUpdateConsumeSkill()
end

--改变按钮状态
function YuanShenLayer:upDateBtnState(data)
    if data["var"]["isLock"] == 1 then
        self._arrBtn[data["key"]]:setTouchEnabled(true)
        self._arrBtn[data["key"]]:setBright(true)
        self._arrTips[data["key"]]:setVisible(false)
        self._unLock:setVisible(false)
        self._ndHide:setVisible(true)
        self:upGradeStar(data["var"])
        self:upGradeSkill(data["var"])
        self:changeMagicPro(data["var"])
        self:HideBtnForLight(data["key"])
    end
end

--显示提示Tips
function YuanShenLayer:upDateTips()
    for i=1,6 do
        if zzm.YuanShenModel._arrYuanShen["Lv"] >= YuanShenConfig:getMagicUnLock(zzm.YuanShenModel._arrMagic[i]["Id"])and
            zzm.YuanShenModel._arrMagic[i]["isLock"] == 0 then
            self._arrBtn[i]:setTouchEnabled(true)
            self._arrTips[i]:setVisible(true)
        elseif zzm.YuanShenModel._arrMagic[i]["isLock"] == 1 then
            self._arrBtn[i]:setTouchEnabled(true)
            self._arrBtn[i]:setBright(true)
            self._arrTips[i]:setVisible(false)
        end
    end
end

--显示解锁状态
function YuanShenLayer:upDateUnLock(data)
    if data["isLock"] == 0 then
        self._unLock:setVisible(true)
        self._ndHide:setVisible(false)
        local res = YuanShenConfig:getUnLockMagic(data["Id"])
        self._lbExp:setPercent(data["Exp"]/res["Exp"]*100)
        self._txtExp:setString(data["Exp"].."/"..res["Exp"])
        self._useGold:setString(res["Gold"])
        self._useYB:setString(res["Rmb"])
    end
end

--显示按钮高光
function YuanShenLayer:HideBtnForLight(i)
    if self._lastBtn then
        self._lastBtn:setVisible(true)
    end
    if i then
        self._arrBtn[i]:setVisible(false)
        self._lastBtn = self._arrBtn[i]
    end
end

function YuanShenLayer:stoneIconCtr(id)
    for key, var in pairs(self._stoneIcon) do
    	var:setVisible(false)
    end
    self._stoneIcon[""..id]:setVisible(true)
end

--间接更新技能石显示
function YuanShenLayer:IndirectUpdateConsumeSkill()
    for key, var in pairs(zzm.YuanShenModel._arrMagic) do
    	if var.Id == self._curId then
            self:updateConsumeSkill(var)
            break
    	end
    end
end

--元神技能升级
function YuanShenLayer:updateConsumeSkill(data)
    local config = YuanShenConfig:getUpSkillPro(data.Id,data.skillLv == nil and 0 or data.skillLv)
	self._spStone:setTexture("res/dxyCocosStudio/png/yuanshen/ks.png")

    self._SkillLv:setString("Lv:"..(data["skillLv"] or 1))

    if data.skillLv and data.skillLv >= YuanShenConfig:getMaxSkillLv() then
        self._txtGold:setString("0")
        self._txtStone:setString("0")
    else
        self._txtGold:setString(config.Gold)
        local max = zzm.CharacterModel:getGoodsById(config.ID)
        self._txtStone:setString(config.Num)
        
        --显示下一等级提示 ljw 2016.02.24
--        self._SkillJCJiantou:setVisible(true)
--        self._SkillJc:setVisible(true)
--        self._SkillGJJiantou:setVisible(true)
--        self._SkillNextGJ:setVisible(true)
--        
--        local bf_sonSkill = nil
--        local af_sonSkill = nil
--        local skillBase = nil
--        for key, var in pairs(zzm.YuanShenModel._arrMagic) do
--            if var.Id == data.Id then
--                local config = YuanShenConfig:getMagicById(var.Id)
--                bf_sonSkill = SkillConfig:getSkillByLv(config.SkillId,var.skillLv or 1)
--                af_sonSkill = SkillConfig:getSkillByLv(config.SkillId,(var.skillLv or 1)+1)
--                skillBase = SkillConfig:getSkillConfigById(config.SkillId)
--                break
--            end
--        end
--
--        self._SkillJc:setString(bf_sonSkill.SkillValue.BaseValue)
--        self._SkillNextJc:setString(af_sonSkill.SkillValue.BaseValue)
--        self._SkillGJ:setString(math.ceil(bf_sonSkill.SkillValue.AttrAddPercent*skillBase.SkillDamagetimes).. "%")
--        self._SkillNextGJ:setString(math.ceil(af_sonSkill.SkillValue.AttrAddPercent*skillBase.SkillDamagetimes).. "%")
    end
    
    self._SkillJCJiantou:setVisible(true)
    self._SkillJc:setVisible(true)
    self._SkillGJJiantou:setVisible(true)
    self._SkillNextGJ:setVisible(true)
    
    local bf_sonSkill = nil
    local af_sonSkill = nil
    local skillBase = nil
    for key, var in pairs(zzm.YuanShenModel._arrMagic) do
        if var.Id == data.Id then
            local config = YuanShenConfig:getMagicById(var.Id)
            bf_sonSkill = SkillConfig:getSkillByLv(config.SkillId,var.skillLv or 1)
            af_sonSkill = SkillConfig:getSkillByLv(config.SkillId,(var.skillLv or 1)+1)
            skillBase = SkillConfig:getSkillConfigById(config.SkillId)
            break
        end
    end

    self._SkillJc:setString(bf_sonSkill.SkillValue.BaseValue*skillBase.SkillDamagetimes)
    self._SkillNextJc:setString(af_sonSkill.SkillValue.BaseValue*skillBase.SkillDamagetimes)
    self._SkillGJ:setString(bf_sonSkill.SkillValue.AttrAddPercent*skillBase.SkillDamagetimes.. "%")
    self._SkillNextGJ:setString(af_sonSkill.SkillValue.AttrAddPercent*skillBase.SkillDamagetimes.. "%")
end

function YuanShenLayer:whenClose()
    if self._forever then
        self._forever:release()
    end
end