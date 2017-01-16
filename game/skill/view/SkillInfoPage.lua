
SkillInfoType = {
    BaseSkill = 0,
    SoulSkill = 1,
}

SkillOperateType = {
    Button = 1,
    Slide = 2,
}

SkillInfoPage = SkillInfoPage or class("SkillInfoPage",function()
    return ccui.Layout:create()
end)

function SkillInfoPage:create()
    local node = SkillInfoPage:new()
    return node
end

function SkillInfoPage:ctor()
    self:initUI()
    --self:initEvent()

    dxyExtendEvent(self)
end

function SkillInfoPage:setParent(parent)
    self._parent = parent
end

function SkillInfoPage:initUI()
    self._csbNode = cc.CSLoader:getInstance():createNodeWithFlatBuffersFile("dxyCocosStudio/csd/ui/skill/SkillInfoPage.csb")
    self:addChild(self._csbNode)
    self.visibleSize = cc.Director:getInstance():getVisibleSize()
    self.origin = cc.Director:getInstance():getVisibleOrigin()

    local posX = self.origin.x + self.visibleSize.width/2
    local posY = self.origin.y + self.visibleSize.height/2

    self._csbNode:setPosition(posX, posY)
    
    self.baseNode = self._csbNode:getChildByName("BaseNode")

    require("game.skill.view.SkillWarfieldSlider")
    local node = SkillWarfieldSlider.create()
    --node:setPosition(posX, posY)
       
    --create stencil
    self._stencil = cc.Sprite:create("dxyCocosStudio/png/skill/clipingnode.png")
    self._stencil:setAnchorPoint(cc.p(0,0))

    self._size = self._stencil:getContentSize()

    --create clippingNode
    self._clippingNode = cc.ClippingNode:create()
    self._clippingNode:setAnchorPoint(cc.p(0,0))
    --self._clippingNode:setAlphaThreshold(0)
    self._clippingNode:setPosition( - self._size.width / 2,85)
    self._clippingNode:setStencil(self._stencil)
    self._clippingNode:setInverted(false)
--    node:addChild(self._clippingNode)

    --create show
    self._clippingNode:addChild(node)
    node:setPositionX(self._size.width / 2 - node.pageView:getContentSize().width / 2)
    self.baseNode:addChild(self._clippingNode) 

    local downNode = self._csbNode:getChildByName("DownNode"):getChildByName("BtnBG")
    self.ckb_SkillBase = downNode:getChildByName("CheckBox_1")
    self.ckb_SkillSoul = downNode:getChildByName("CheckBox_2")
    
    downNode = self._csbNode:getChildByName("DownNode"):getChildByName("TypeBtnBG")
    self.ckb_buttonOperate = downNode:getChildByName("CheckBox_1")
    self.ckb_slideOperate = downNode:getChildByName("CheckBox_2")
    self:onSelectOperateType(_G.gOperationType)
    
    self.btn_skillShow = self._csbNode:getChildByName("DownNode"):getChildByName("SkillshowBtn")
    
    local panel = self._csbNode:getChildByName("Panel")

    self.basePanel = panel:getChildByName("BasePanel")
    self.btn_upgrade = self.basePanel:getChildByName("Button_6")
    self.btn_unlock = self.basePanel:getChildByName("Button_7")

    self.txt_upgrade = self.basePanel:getChildByName("JC_Copy")
    
    self.skillDesc = self.basePanel:getChildByName("Desc")

    self.skillname = panel:getChildByName("SkillNameBg"):getChildByName("SkillName")
    self.cdtime = self.basePanel:getChildByName("CD")
    self.mp = self.basePanel:getChildByName("MP")
    self.upgradeGold = self.basePanel:getChildByName("Gold")
    self.upgradeLv = self.basePanel:getChildByName("LV")
    self.upgradeRmb = self.basePanel:getChildByName("Rmb")
    self.baseValue_1 = self.basePanel:getChildByName("JC"):getChildByName("JC")
    self.baseValue_2 = self.basePanel:getChildByName("JC"):getChildByName("JC"):getChildByName("JC")
    self.addPercent_1 = self.basePanel:getChildByName("GJ"):getChildByName("GJ")
    self.addPercent_2 = self.basePanel:getChildByName("GJ"):getChildByName("GJ"):getChildByName("GJ")
    
    
    
    self.soulNode = self._csbNode:getChildByName("SoulNode")
    
    require("game.skill.view.SoulSkillWarfieldSlider")
    local node = SoulSkillWarfieldSlider.create()

    --create stencil
    self._stencil = cc.Sprite:create("dxyCocosStudio/png/skill/clipingnode.png")
    self._stencil:setAnchorPoint(cc.p(0,0))

    self._size = self._stencil:getContentSize()

    --create clippingNode
    self._clippingNode = cc.ClippingNode:create()
    self._clippingNode:setAnchorPoint(cc.p(0,0))
    self._clippingNode:setPosition( - self._size.width / 2,85)
    self._clippingNode:setStencil(self._stencil)
    self._clippingNode:setInverted(false)

    --create show
    self._clippingNode:addChild(node)
    node:setPositionX(self._size.width / 2 - node.pageView:getContentSize().width / 2)
    self.soulNode:addChild(self._clippingNode) 
    
    self.soulPanel = panel:getChildByName("SoulPanel")
    
    self.btn_soulupgrade = self.soulPanel:getChildByName("Button_6")
    self.btn_soulunlock = self.soulPanel:getChildByName("Button_7")

    

    self.soulskillDesc = self.soulPanel:getChildByName("Desc")

    self.soulskillname = panel:getChildByName("SkillNameBg"):getChildByName("SoulSkillName")
    self.soulcdtime = self.soulPanel:getChildByName("CD")
    self.soulmp = self.soulPanel:getChildByName("MP")
    self.soulbaseValue_1 = self.soulPanel:getChildByName("JC"):getChildByName("JC")
    self.soulbaseValue_2 = self.soulPanel:getChildByName("JC"):getChildByName("JC"):getChildByName("JC")
    self.souladdPercent_1 = self.soulPanel:getChildByName("GJ"):getChildByName("GJ")
    self.souladdPercent_2 = self.soulPanel:getChildByName("GJ"):getChildByName("GJ"):getChildByName("GJ")

    self:onSelectByType(SkillInfoType.BaseSkill)
end

function SkillInfoPage:updateSwallowList(data)
    for index=1, 8 do
        if self.list_Item[index] then
            self.list_Item[index]:update(data[index])
        end
    end
end

function SkillInfoPage:updateEquipNode(data)
    if not data then
        return
    end
    --self.text_EquipName:setString(data.conf)
    --self.text_Loading:setString(data.curExp.. "/" .. data.maxExp)
    --self.loadingBar
    self.item_Equip:update(data)
end

function SkillInfoPage:setInfo(data)
    if not data then
        return
    end

    self.txt_upgrade:setString("升级条件:")
    self.btn_upgrade:setVisible(true)
    self.btn_unlock:setVisible(false)

    self.skillname:setString(data.Name)
    self.skillDesc:setString(data.Info)
    self.cdtime:setString("CD时间:"..data.Cd.."秒")
    self.mp:setString("消耗法力:"..data.SonSkill.ConsumeMp)

    local lv = zzm.SkillModel:getSkillLvById(data.Id)
    local upGold
    local upLv
    local upRmb
    local upBase_1
    local upAddPercent_1
    if lv == 0 then
        upBase_1 = 0
        upAddPercent_1 = 0
    else
        upBase_1 = SkillConfig:getSkillByLv(data.Id,lv).SkillValue.BaseValue * SkillConfig:getSkillConfigById(data.Id).SkillDamagetimes
        upAddPercent_1 = SkillConfig:getSkillByLv(data.Id,lv).SkillValue.AttrAddPercent * SkillConfig:getSkillConfigById(data.Id).SkillDamagetimes
    end
    local upBase_2
    local upAddPercent_2
    local lvMax = #SkillConfig:getSkillConfigById(data.Id).SonSkill.SkillLv
    if lv >= lvMax then
        upGold = 0
        upLv = 0
        upRmb = 0
        upBase_2 = upBase_1
        upAddPercent_2 = upAddPercent_1
    else
        upGold = SkillConfig:getSkillByLv(data.Id,lv+1).DeblockingGold
        upLv = SkillConfig:getSkillByLv(data.Id,lv+1).DeblockingLv
        upRmb = SkillConfig:getSkillByLv(data.Id,lv+1).DeblockingRmb
        upBase_2 = SkillConfig:getSkillByLv(data.Id,lv+1).SkillValue.BaseValue * SkillConfig:getSkillConfigById(data.Id).SkillDamagetimes
        upAddPercent_2 = SkillConfig:getSkillByLv(data.Id,lv+1).SkillValue.AttrAddPercent * SkillConfig:getSkillConfigById(data.Id).SkillDamagetimes
    end
    self.upgradeGold:setString(upGold)
    self.upgradeLv:setString(upLv)
    self.upgradeRmb:setString(upRmb)
    self.baseValue_1:setString(upBase_1)
    self.baseValue_2:setString(upBase_2)
    self.addPercent_1:setString(upAddPercent_1.."%")
    self.addPercent_2:setString(upAddPercent_2.."%")

end

function SkillInfoPage:setSoulInfo(data)
    if not data then
        return
    end
    
    self.btn_soulunlock:setVisible(not zzm.SkillModel:getSoulSkillUnlock(data.Id))
    self.btn_soulupgrade:setVisible(zzm.SkillModel:getSoulSkillUnlock(data.Id))
    
    self.soulskillname:setString(data.Name)
    self.soulskillDesc:setString(data.Info)
    self.soulcdtime:setString("CD时间:"..data.Cd.."秒")
    self.soulmp:setString("消耗法力:"..data.SonSkill.ConsumeMp)
    
    local lv = zzm.SkillModel:getSoulSkillLvById(data.Id)
    local upBase_1
    local upAddPercent_1
    if lv == -1 then
        upBase_1 = 0
        upAddPercent_1 = 0
    else
        upBase_1 = SkillConfig:getSkillByLv(data.Id,lv).SkillValue.BaseValue * SkillConfig:getSkillConfigById(data.Id).SkillDamagetimes
        upAddPercent_1 = SkillConfig:getSkillByLv(data.Id,lv).SkillValue.AttrAddPercent * SkillConfig:getSkillConfigById(data.Id).SkillDamagetimes
    end
    local upBase_2
    local upAddPercent_2
    local lvMax = #SkillConfig:getSkillConfigById(data.Id).SonSkill.SkillLv
    if lv >= lvMax then
        upBase_2 = upBase_1
        upAddPercent_2 = upAddPercent_1
    else
        upBase_2 = SkillConfig:getSkillByLv(data.Id,lv+1).SkillValue.BaseValue * SkillConfig:getSkillConfigById(data.Id).SkillDamagetimes
        upAddPercent_2 = SkillConfig:getSkillByLv(data.Id,lv+1).SkillValue.AttrAddPercent * SkillConfig:getSkillConfigById(data.Id).SkillDamagetimes
    end
    self.soulbaseValue_1:setString(upBase_1)
    self.soulbaseValue_2:setString(upBase_2)
    self.souladdPercent_1:setString(upAddPercent_1.."%")
    self.souladdPercent_2:setString(upAddPercent_2.."%")
end

function SkillInfoPage:skillUnlock()
    self.txt_upgrade:setString("解锁条件:")
    self.btn_unlock:setVisible(true)
    self.btn_upgrade:setVisible(false)
end

function SkillInfoPage:soulskillUnlock()
    self.btn_soulunlock:setVisible(true)
    self.btn_soulupgrade:setVisible(false)
end


function SkillInfoPage:removeEvent()
    dxyDispatcher_removeEventListener(dxyEventType.Skill_Info,self,self.setInfo)
    dxyDispatcher_removeEventListener(dxyEventType.SoulSkill_Info,self,self.setSoulInfo)
    dxyDispatcher_removeEventListener(dxyEventType.Skill_Unlock,self,self.skillUnlock)
    dxyDispatcher_removeEventListener(dxyEventType.SoulSkill_Unlock,self,self.soulskillUnlock)
end

function SkillInfoPage:initEvent()

    dxyDispatcher_addEventListener(dxyEventType.Skill_Info,self,self.setInfo)
    dxyDispatcher_addEventListener(dxyEventType.SoulSkill_Info,self,self.setSoulInfo)
    dxyDispatcher_addEventListener(dxyEventType.Skill_Unlock,self,self.skillUnlock)
    dxyDispatcher_addEventListener(dxyEventType.SoulSkill_Unlock,self,self.soulskillUnlock)
    
    local role = zzm.CharacterModel:getCharacterData()
    local enCAT = enCharacterAttrType
    
    dxyDispatcher_dispatchEvent(dxyEventType.Skill_Info,HeroSkill:getHeroBaseSkillList(role:getValueByType(enCAT.PRO))[1])
    dxyDispatcher_dispatchEvent(dxyEventType.SoulSkill_Info,HeroSkill:getHeroSoulSkillList(role:getValueByType(enCAT.PRO))[1])


    --基础技能升级
    if (self.btn_upgrade) then
        self.btn_upgrade:addTouchEventListener(function(target,type)
            if type == 2 then
                SoundsFunc_playSounds(SoundsType.UNIVERSAL_BTN,false)
                zzc.SkillController:request_UpgradeSkill(zzm.SkillModel:getCurSkill().Id)
                dxyDispatcher_dispatchEvent("skill_upgrade",zzm.SkillModel:getCurSkill().Id)
            end
        end)
    end

    --基础技能解锁
    if (self.btn_unlock) then
        self.btn_unlock:addTouchEventListener(function(target,type)
            if type == 2 then
                SoundsFunc_playSounds(SoundsType.DEBLOCKING,false)
                zzc.SkillController:request_DeblockSkill(zzm.SkillModel:getCurSkill().Id)
            end
        end)
    end
    
    --法器技能升级
    if (self.btn_soulupgrade) then
        self.btn_soulupgrade:addTouchEventListener(function(target,type)
            if type == 2 then
                SoundsFunc_playSounds(SoundsType.UNIVERSAL_BTN,false)
                if zzc.GuideController:checkFunctionTips(enFunctionType.YuanShen) == false then
                    return
                end
                zzc.SkillController:closeLayer()
                zzc.YuanShenController:showLayer()
                dxyDispatcher_dispatchEvent("YSInitLayer_scrollToPage",1)
            end
        end)
    end
    
    --法器技能解锁
    if (self.btn_soulunlock) then
        self.btn_soulunlock:addTouchEventListener(function(target,type)
            if type == 2 then
                SoundsFunc_playSounds(SoundsType.UNIVERSAL_BTN,false)
                if zzc.GuideController:checkFunctionTips(enFunctionType.YuanShen) == false then
                    return
                end
                zzc.SkillController:closeLayer()
                zzc.YuanShenController:showLayer()
                dxyDispatcher_dispatchEvent("YSInitLayer_scrollToPage",1)
            end
        end)
    end

    if(self.btn_back)then
        self.btn_back:addTouchEventListener(function(target,type)
            if(type==2 and self._parent)then
                self._parent:onSelectByType(CHARACTER_SUB_TYPE.ROLE_INFO)
            end
        end)
    end

    if (self.ckb_SkillBase) then
        self.ckb_SkillBase:addEventListener(function(target,type)
            if type == ccui.CheckBoxEventType.selected then
                SoundsFunc_playSounds(SoundsType.UNIVERSAL_BTN,false)
                self:onSelectByType(SkillInfoType.BaseSkill)
            end
        end)
    end
    if (self.ckb_SkillSoul) then
        self.ckb_SkillSoul:addEventListener(function(target,type)
            if type == ccui.CheckBoxEventType.selected then
                SoundsFunc_playSounds(SoundsType.UNIVERSAL_BTN,false)
                self:onSelectByType(SkillInfoType.SoulSkill)
            end
        end)
    end
    
    if (self.ckb_slideOperate) then
        self.ckb_slideOperate:addEventListener(function(target,type)
            if type == ccui.CheckBoxEventType.selected then
                SoundsFunc_playSounds(SoundsType.UNIVERSAL_BTN,false)
                self:onSelectOperateType(SkillOperateType.Slide)
            end
        end)
    end
    if (self.ckb_buttonOperate) then
        self.ckb_buttonOperate:addEventListener(function(target,type)
            if type == ccui.CheckBoxEventType.selected then
                SoundsFunc_playSounds(SoundsType.UNIVERSAL_BTN,false)
                self:onSelectOperateType(SkillOperateType.Button)
            end
        end)
    end
    
    if self.btn_skillShow then
        self.btn_skillShow:addTouchEventListener(function(target,type)
    	   if type == 2 then
                zzc.SkillController:closeLayer()
                require("game.loading.LoadBattleShowScene")
                local lbss = LoadBattleShowScene.create()
                lbss:initPreLoad("LoginScene","GameScene/maps/YWC.csb",function()
                    local i = 0
                end)
                SceneManager:enterScene(lbss, "LoadBattleShowScene")
    	   end
    	end)   
    end
end

function SkillInfoPage:onSelectOperateType(type)

    self.ckb_buttonOperate:setTouchEnabled(true)
    self.ckb_slideOperate:setTouchEnabled(true)
    self.ckb_buttonOperate:setSelected(false)
    self.ckb_slideOperate:setSelected(false)

    if type == SkillOperateType.Button then
        self.ckb_buttonOperate:setTouchEnabled(false)
        self.ckb_buttonOperate:setSelected(true)
	elseif type == SkillOperateType.Slide then
        self.ckb_slideOperate:setTouchEnabled(false)
        self.ckb_slideOperate:setSelected(true)
	end
	
	zzm.SkillModel:saveOperationType(type)
	
end

function SkillInfoPage:onSelectByType(type)
    self.ckb_SkillBase:setTouchEnabled(true)
    self.ckb_SkillSoul:setTouchEnabled(true)
    self.ckb_SkillBase:setSelected(false)
    self.ckb_SkillSoul:setSelected(false)

    if type == SkillInfoType.BaseSkill then
        self.ckb_SkillBase:setTouchEnabled(false)
        self.ckb_SkillBase:setSelected(true)
    elseif type == SkillInfoType.SoulSkill then
        self.ckb_SkillSoul:setTouchEnabled(false)
        self.ckb_SkillSoul:setSelected(true)
    end

    self:updateInfo(type)
end

function SkillInfoPage:updateInfo(type)
    self.basePanel:setVisible(false)
    self.baseNode:setVisible(false)
    self.soulPanel:setVisible(false)
    self.soulNode:setVisible(false)
    self.skillname:setVisible(false)
    self.soulskillname:setVisible(false)
    
    if type == SkillInfoType.BaseSkill then
        self.basePanel:setVisible(true)
        self.baseNode:setVisible(true)
        self.skillname:setVisible(true)
    elseif type == SkillInfoType.SoulSkill then
        self.soulPanel:setVisible(true)
        self.soulNode:setVisible(true)
        self.soulskillname:setVisible(true)
    end
end
