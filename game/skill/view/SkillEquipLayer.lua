
SkillEquipLayer = SkillEquipLayer or class("SkillEquipLayer",function()
    return cc.Layer:create()
end)

function SkillEquipLayer.create()
    local layer = SkillEquipLayer.new()
    return layer
end

function SkillEquipLayer:ctor()
    self._csbNode = nil
    
    self.data = nil
    self.id = nil
    
    self.skillName = nil
    self.cdTime = nil
    self.baseValue = nil
    self.addPercent = nil
    
    self:initUI()
    dxyExtendEvent(self)
    --屏蔽点击事件
    dxySwallowTouches(self)
end

function SkillEquipLayer:initUI()
    self._csbNode = cc.CSLoader:getInstance():createNodeWithFlatBuffersFile("dxyCocosStudio/csd/ui/skill/SkillEquipLayer.csb")
    self:addChild(self._csbNode)

    self.visibleSize = cc.Director:getInstance():getVisibleSize()
    self.origin = cc.Director:getInstance():getVisibleOrigin()
    local posX = self.origin.x + self.visibleSize.width/2
    local posY = self.origin.y + self.visibleSize.height/2
    self:setPosition(posX, posY)
    
    
    local downNode = self._csbNode:getChildByName("DownNode"):getChildByName("BtnBG")
    self.ckb_SkillBase = downNode:getChildByName("CheckBox_1")
    self.ckb_SkillSoul = downNode:getChildByName("CheckBox_2")
    
    self.baseNode = self._csbNode:getChildByName("BaseNode")
    
    require("game.skill.view.SkillWarfieldSlider")
    local node = SkillWarfieldSlider.create()
    --遮罩
    --create stencil
    self._stencil = cc.Sprite:create("res/dxyCocosStudio/png/skill/clipingnode.png")
    self._stencil:setAnchorPoint(cc.p(0,0))

    self._size = self._stencil:getContentSize()

    --create clippingNode
    self._clippingNode = cc.ClippingNode:create()
    self._clippingNode:setAnchorPoint(cc.p(0,0))
    --self._clippingNode:setAlphaThreshold(0)
    self._clippingNode:setPosition(- self._size.width / 2,55)
    self._clippingNode:setStencil(self._stencil)
    self._clippingNode:setInverted(false)

    --create show
    self._clippingNode:setName("ClippingNode")
    self._clippingNode:addChild(node)
    node:setPositionX(self._size.width / 2 - node.pageView:getContentSize().width / 2)
    self.baseNode:addChild(self._clippingNode)
    
    self.btn_back = self._csbNode:getChildByName("frame"):getChildByName("Button")
    local panel = self._csbNode:getChildByName("Panel")
    self.btn_equip = panel:getChildByName("Button")
    self.btn_unload = panel:getChildByName("unloadBtn")
    
    self.basePanel = panel:getChildByName("BasePanel")
    self.skillName = panel:getChildByName("SkillNameBg"):getChildByName("SkillName")
    
    self.skillDesc = self.basePanel:getChildByName("Desc")
    self.cdTime = self.basePanel:getChildByName("CD")
    self.mp = self.basePanel:getChildByName("MP")
    self.baseValue = self.basePanel:getChildByName("JC"):getChildByName("JC")
    self.addPercent = self.basePanel:getChildByName("GJ"):getChildByName("GJ")
    
    self.soulNode = self._csbNode:getChildByName("SoulNode")
    require("game.skill.view.SoulSkillWarfieldSlider")
    local node = SoulSkillWarfieldSlider.create()

    --遮罩
    --create stencil
    self._stencil = cc.Sprite:create("res/dxyCocosStudio/png/skill/clipingnode.png")
    self._stencil:setAnchorPoint(cc.p(0,0))

    self._size = self._stencil:getContentSize()

    --create clippingNode
    self._clippingNode = cc.ClippingNode:create()
    self._clippingNode:setAnchorPoint(cc.p(0,0))
    --self._clippingNode:setAlphaThreshold(0)
    self._clippingNode:setPosition(- self._size.width / 2,55)
    self._clippingNode:setStencil(self._stencil)
    self._clippingNode:setInverted(false)

    --create show
   
    self._clippingNode:addChild(node)
    node:setPositionX(self._size.width / 2 - node.pageView:getContentSize().width / 2)
    self.soulNode:addChild(self._clippingNode)
    
    self.soulskillName = panel:getChildByName("SkillNameBg"):getChildByName("SoulSkillName")
    self.soulPanel = panel:getChildByName("SoulPanel")
    self.soulskillDesc = self.soulPanel:getChildByName("Desc")
    self.soulcdTime = self.soulPanel:getChildByName("CD")
    self.soulmp = self.soulPanel:getChildByName("MP")
    self.soulbaseValue = self.soulPanel:getChildByName("JC"):getChildByName("JC")
    self.souladdPercent = self.soulPanel:getChildByName("GJ"):getChildByName("GJ")
    self:onSelectByType(SkillInfoType.BaseSkill) 
end

function SkillEquipLayer:WhenClose()
    self:removeFromParent()
end

function SkillEquipLayer:setInfo(data)
    if not data then
        return
    end
    
	self.skillName:setString(data.Name)
	self.skillDesc:setString(data.Info)
    self.cdTime:setString("CD时间:"..data.Cd.."秒")
    self.mp:setString("消耗法力:"..data.SonSkill.ConsumeMp)
	
    local lv = zzm.SkillModel:getSkillLvById(data.Id)
    local baseValue
    local addPercent
    
    if lv == 0 then
        baseValue = 0
        addPercent = 0
    else
        baseValue = SkillConfig:getSkillByLv(data.Id,lv).SkillValue.BaseValue * SkillConfig:getSkillConfigById(data.Id).SkillDamagetimes
        addPercent = SkillConfig:getSkillByLv(data.Id,lv).SkillValue.AttrAddPercent * SkillConfig:getSkillConfigById(data.Id).SkillDamagetimes
    end

    self.baseValue:setString(baseValue)
    self.addPercent:setString(addPercent.."%")
end

function SkillEquipLayer:setSoulInfo(data)
    if not data then
        return
    end

    self.soulskillName:setString(data.Name)
    self.soulskillDesc:setString(data.Info)
    self.soulcdTime:setString("CD时间:"..data.Cd.."秒")
    self.soulmp:setString("消耗法力:"..data.SonSkill.ConsumeMp)

    local lv = zzm.SkillModel:getSoulSkillLvById(data.Id)
    local baseValue
    local addPercent

    if lv == -1 then
        baseValue = 0
        addPercent = 0
    else
        baseValue = SkillConfig:getSkillByLv(data.Id,lv).SkillValue.BaseValue * SkillConfig:getSkillConfigById(data.Id).SkillDamagetimes
        addPercent = SkillConfig:getSkillByLv(data.Id,lv).SkillValue.AttrAddPercent * SkillConfig:getSkillConfigById(data.Id).SkillDamagetimes
    end



    self.soulbaseValue:setString(baseValue)
    self.souladdPercent:setString(addPercent.."%")
end

function SkillEquipLayer:removeEvent()
    dxyDispatcher_removeEventListener(dxyEventType.ctSkill_Info,self,self.setInfo)
    dxyDispatcher_removeEventListener(dxyEventType.SoulctSkill_Info,self,self.setSoulInfo)
    dxyDispatcher_removeEventListener(dxyEventType.Skill_AutoSelect,self,self.autoSelect)
--dxyDispatcher_removeEventListener(dxyEventType.Character_AttrUpdate,self,self.updateValue)
--dxyDispatcher_removeEventListener(dxyEventType.UserItemDelItem,self,self.onSelectByType)
end

function SkillEquipLayer:initEvent()
    dxyDispatcher_addEventListener(dxyEventType.ctSkill_Info,self,self.setInfo)
    dxyDispatcher_addEventListener(dxyEventType.SoulctSkill_Info,self,self.setSoulInfo)
    dxyDispatcher_addEventListener(dxyEventType.Skill_AutoSelect,self,self.autoSelect)
    --dxyDispatcher_addEventListener(dxyEventType.Character_AttrUpdate,self,self.updateValue)
    --dxyDispatcher_addEventListener(dxyEventType.UserItemDelItem,self,self.onSelectByType)
    
    local role = zzm.CharacterModel:getCharacterData()
    local enCAT = enCharacterAttrType
    
    dxyDispatcher_dispatchEvent(dxyEventType.ctSkill_Info,HeroSkill:getHeroBaseSkillList(role:getValueByType(enCAT.PRO))[1])
    dxyDispatcher_dispatchEvent(dxyEventType.SoulctSkill_Info,HeroSkill:getHeroSoulSkillList(role:getValueByType(enCAT.PRO))[1])

    if(self.btn_back)then
        self.btn_back:addTouchEventListener(function(target,type)
            if(type==2)then
                SoundsFunc_playSounds(SoundsType.CLOSE_PAGE,false)
                self:removeFromParent()
                --dxyDispatcher_dispatchEvent(dxyEventType.SkillLayer_Reset)
            end
        end)
    end
    
    if(self.btn_equip)then
        self.btn_equip:addTouchEventListener(function(target,type)
            if(type==2)then
                SoundsFunc_playSounds(SoundsType.USE_GOODS,false)
                if self.ckb_SkillBase:isSelected() then
                    zzc.SkillController:request_CTSkillAddSkill(self.id,self.data.idx,zzm.SkillModel:getCurSkill().Id)
                    zzm.TalkingDataModel:onEvent((EumEventId.CTSKILL_COUNT)..self.id,{})
                else                  
                    zzc.SkillController:request_CTSkillAddSkill(self.id,self.data.idx,zzm.SkillModel:getCurSoulSkill().Id)
                end
                if zzm.SkillModel:getCurSkill().DischargeSkillCondition == 2 then
                    dxyFloatMsg:show("该技能需要在空中释放")
                end
                self:removeFromParent()
                --dxyDispatcher_dispatchEvent(dxyEventType.SkillLayer_Reset)
            end
        end)
    end
    
    if self.btn_unload then
        self.btn_unload:addTouchEventListener(function(target,type)
            if(type==2)then
                zzc.SkillController:request_UnloadSkill(self.id,self.data.idx)
                self:removeFromParent()
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
end

function SkillEquipLayer:setData(data,id)
    self.data = data
	self.id = id
	
    self.btn_unload:setVisible(zzm.SkillModel:isLastSkill(self.id,self.data.idx))
	
    if self.data.skill_id == 0 then
        self.btn_unload:setVisible(false)
    end
	
end

function SkillEquipLayer:autoSelect()
	local skill_data = self:checkSkill(self.data.skill_id)
    self:onSelectByType(skill_data.type)
    
    self._mySubServerTimer = require("game.utils.MyTimer").new()
    local function tick()
        if skill_data.type == SkillInfoType.SoulSkill then
            dxyDispatcher_dispatchEvent(dxyEventType.soulSkill_Equiped,skill_data.index)
        end
        if skill_data.type == SkillInfoType.BaseSkill then
            dxyDispatcher_dispatchEvent(dxyEventType.baseSkill_Equiped,skill_data.index)
        end
        self._mySubServerTimer:stop()
    end
    self._mySubServerTimer:start(0.1, tick)
end

function SkillEquipLayer:checkSkill(skill_id)
    
    local data = {}
    data.type = 0   --技能类型
    data.index = 0  --技能在pageview上的位置
    
    if skill_id == 0 then
        data.type = 0
        data.index = 0
    	return data
    end
    
    local role = zzm.CharacterModel:getCharacterData()
    local enCAT = enCharacterAttrType
    
    local baseSkill = HeroSkill:getHeroBaseSkillList(role:getValueByType(enCAT.PRO))
    local soulSkill = HeroSkill:getHeroSoulSkillList(role:getValueByType(enCAT.PRO))
    
    for key, var in pairs(baseSkill) do
    	if var.Id == skill_id then
    	    data.type = 0
    	    data.index = key - 1
            return data
    	end
    end
    
    for key, var in pairs(soulSkill) do
        if var.Id == skill_id then
            data.type = 1
            data.index = key - 1
            return data
        end
    end
end

function SkillEquipLayer:backCallBack()
--    local accout = self.input_account:getString()
--    local password = self.input_password:getString()
--    local gameScene = LoadingController.new():getScene()
--    SceneManager:enterScene(gameScene, "LoadingScene")
end

function SkillEquipLayer:onSelectByType(type)
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

function SkillEquipLayer:updateInfo(type)
    self.basePanel:setVisible(false)
    self.baseNode:setVisible(false)
    self.soulPanel:setVisible(false)
    self.soulNode:setVisible(false)
    self.skillName:setVisible(false)
    self.soulskillName:setVisible(false)

    if type == SkillInfoType.BaseSkill then
        self.basePanel:setVisible(true)
        self.baseNode:setVisible(true)
        self.skillName:setVisible(true)
    elseif type == SkillInfoType.SoulSkill then
        self.soulPanel:setVisible(true)
        self.soulNode:setVisible(true)
        self.soulskillName:setVisible(true)
    end
end


