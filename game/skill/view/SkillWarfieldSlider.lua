
SkillWarfieldSlider = SkillWarfieldSlider or class("SkillWarfieldSlider",function()
    return cc.Layer:create()
        --setStartAndEndTalkId
end)

function SkillWarfieldSlider.create()
    local layer = SkillWarfieldSlider.new()
    return layer
end

function SkillWarfieldSlider:ctor()
    self._csbNode = nil
    self._typeLayer = {}
    self:setName("SkillWarfieldSlider")
    self:initUI()
    --self:initEvent()
    dxyExtendEvent(self)
end



function SkillWarfieldSlider:initUI()
    self._csbNode = cc.CSLoader:getInstance():createNodeWithFlatBuffersFile("dxyCocosStudio/csd/ui/skill/SkillWarfieldSlider.csb")
    self:addChild(self._csbNode)
    
    PARAMETERS = {
        extra_width = 1.5,
        extra_height = 0,
        page_num = 3,
    }

    --self.typeNode = self._csbNode:getChildByName("typeNode")

    self.visibleSize = cc.Director:getInstance():getVisibleSize()
    self.origin = cc.Director:getInstance():getVisibleOrigin()

    local posX = self.origin.x + self.visibleSize.width/2
    local posY = self.origin.y + self.visibleSize.height/2

    --self:setPosition(posX, posY)

    --    self.scrollView = self._csbNode:getChildByName("Panel"):getChildByName("ScrollView")
    --self.containerPanel = self._csbNode:getChildByName("Panel")

    self.pageView = self._csbNode:getChildByName("PageView")
    if zzc.GuideController._isRunning == true then
        self.pageView:setTouchEnabled(false)
    else
        self.pageView:setTouchEnabled(true)
    end

    self.panelList = {}

    local panel = nil
    for index = 1, 6 do
        panel = self.pageView:getChildByName("Panel_"..index)
        self.panelList[index] = panel
    end

    local viewSize = self.pageView:getContentSize()

    local item = nil
    local itemSize = nil
    require("game.skill.view.SkillToggle")
    self.itemList = {}
    local role = zzm.CharacterModel:getCharacterData()
    local enCAT = enCharacterAttrType
    for index=1, #HeroSkill:getHeroBaseSkillList(role:getValueByType(enCAT.PRO)) do
        item = SkillToggle:create()
        itemSize = item:getItemSize()
        local x = viewSize.width / 2
        local y = viewSize.height / 2
        item:setPosition(cc.p(x,y))
        item:setParent(self.pageView)
        item:setIndex(index)
        --item:update(SkillConfig:getSkillConfig()[index], self)

        --        local role = zzm.CharacterModel:getCharacterData()
        --        local enCAT = enCharacterAttrType

        item:update(HeroSkill:getHeroBaseSkillList(role:getValueByType(enCAT.PRO))[index],self)
        item:setType(SKILL_TYPE.skill)
        self.itemList[index] = item

        self.panelList[index]:addChild(item)

        if index == 1 then
            --item:setScale(1.0)
            item:runLarger()
        else
            item:setScale(0.6)
        end

    end
    
    self.pageView:setCustomScrollThreshold(itemSize.width * 0.1)

    --    local viewSize = self.scrollView:getContentSize()
    --
    --    local item = nil
    --    local itemSize = nil
    --    require("game.skill.view.SkillToggle")
    --    self.itemList = {}
    --    for index=1, 6 do
    --        item = SkillToggle:create()
    --        itemSize = item:getItemSize()
    --        local x = viewSize.width / 2 + (itemSize.width + PARAMETERS.extra_width) * (index - 1)
    --        local y = viewSize.height / 2 + PARAMETERS.extra_height
    --        item:setPosition(cc.p(x,y))
    --        item:setParent(self.scrollView)
    --        --item:update(SkillConfig:getSkillConfig()[index], self)
    --
    --        local role = zzm.CharacterModel:getCharacterData()
    --        local enCAT = enCharacterAttrType
    --
    --        item:update(HeroSkill:getHeoSkillList(role:getValueByType(enCAT.PRO))[index],self)
    --        item:setType(SKILL_TYPE.skill)
    --        self.itemList[index] = item
    --        local srollInnerWidth = viewSize.width + (itemSize.width + PARAMETERS.extra_width) * (index - 1)
    --        self.scrollView:setInnerContainerSize(cc.size(srollInnerWidth, self.scrollView:getContentSize().height))
    --        --self.scrollView:setTouchEnabled(false)
    --        self.scrollView:addChild(item)
    --    end
    --
    --
    --
    --    local function tick()
    --        if self.isScrolling then
    --            self.isScrolling = false
    --        else
    --            self._myTimer:stop()
    --            local dis = 56.5
    --            local retDis = 0
    --            for index=1, 6 do
    --                if dis > self.itemList[index]:getDistance() and -dis < self.itemList[index]:getDistance() then
    --                    --                    dis = math.abs(self.itemList[index]:getDistance())
    --                    --                    retDis = self.itemList[index]:getDistance()
    --                    retDis = self.itemList[index]:getDistance()
    --                end
    --            end
    --            local x = self.scrollView:getInnerContainer():getPositionX()
    --            print("retDis:" .. retDis .. " posx: " .. x)
    --            self.scrollView:getInnerContainer():setPositionX(x+retDis)
    --            --            local _offset = self.scrollView:getContentOffset()
    --            --            self.scrollView:setContentOffset(cc.p(dis+_offset.x,0))
    --            print("------->>>"..self.scrollView:getInnerContainer():getPositionX())
    --        end
    --    end
    --    --local MyTimer = require("game.utils.MyTimer")
    --    self._myTimer = self._myTimer or require("game.utils.MyTimer").new()
    --    --self._myTimer:start(0.1, tick)
    --
    --    self.m_start = self.scrollView:getInnerContainer():getPositionX()
    --
    --    self.scrollView:addEventListener(function (target, type)
    ----        print(type)
    --
    --        if type == 4 then
    --            self.isScrolling = true
    --            if self._myTimer:isIdle() then
    --            --self._myTimer:start(0.1, tick)
    --            end
    --
    --            for index=1, 6 do
    --                self.itemList[index]:adjustScrollView()
    --            end
    --        end
    --    end)
    --
    --
    --


    self:onSelectByIndex(HeroSkill:getHeroBaseSkillList(role:getValueByType(enCAT.PRO))[1])

end

function SkillWarfieldSlider:playEffect(skillId)
    local role = zzm.CharacterModel:getCharacterData()
    local enCAT = enCharacterAttrType
    local posId = HeroSkill:getHeroBaseSkillPos(role:getValueByType(enCAT.PRO),skillId)
    
    if not posId then
    	return
    end
    
    require("game.skill.view.SkillEffect")
    local effect = SkillEffect:create()
    local iconSize = self.itemList[posId]:getItemSize()
    self.itemList[posId]:addChild(effect)
    effect:setPosition(cc.p(iconSize.width / 2,iconSize.height / 2))
end

function SkillWarfieldSlider:onSelectByIndex(type)
    print("------------------ : " .. type.Id)
    zzm.SkillModel:setCurSkill(type)
    dxyDispatcher_dispatchEvent(dxyEventType.Skill_Info,type)
    dxyDispatcher_dispatchEvent(dxyEventType.ctSkill_Info,type)
end

function SkillWarfieldSlider:initEvent()

    self:updateSkillState()

    dxyDispatcher_addEventListener(dxyEventType.SkillLayer_Reset,self,self.reset)
    dxyDispatcher_addEventListener(dxyEventType.baseSkill_Equiped,self,self.selectToPage)
    dxyDispatcher_addEventListener(dxyEventType.Skill_Unlock_Effect,self,self.playEffect)
    dxyDispatcher_addEventListener(dxyEventType.Skill_Update_Effect,self,self.playEffect)
    dxyDispatcher_addEventListener("UpdateAllSkill",self,self.updateSkillState)

    self.pageView:addEventListener(function(target,type)
        if type == ccui.PageViewEventType.turning then
            SoundsFunc_playSounds(SoundsType.UNIVERSAL_BTN,false)
            local page = self.pageView:getCurPageIndex()
            self:onSelectByIndex(self.itemList[page+1].data)
            if self.itemList[page+1].isLock then
                dxyDispatcher_dispatchEvent(dxyEventType.Skill_Unlock)
            end
            
            local role = zzm.CharacterModel:getCharacterData()
            local enCAT = enCharacterAttrType
            for index=1, #HeroSkill:getHeroBaseSkillList(role:getValueByType(enCAT.PRO)) do
                if index == page + 1 then
                    self.itemList[index]:runLarger()
--                    self.itemList[index]:runAction(cc.EaseSineOut:create(cc.ScaleTo:create(0.3,1)))
                else
                    self.itemList[index]:runSmall()
--                    self.itemList[index]:runAction(cc.EaseSineOut:create(cc.ScaleTo:create(0.3,0.6)))
                end
            end
        end
    end)
end

function SkillWarfieldSlider:removeEvent()
    dxyDispatcher_removeEventListener(dxyEventType.SkillLayer_Reset,self,self.reset)
    dxyDispatcher_removeEventListener(dxyEventType.baseSkill_Equiped,self,self.selectToPage)
    dxyDispatcher_removeEventListener(dxyEventType.Skill_Unlock_Effect,self,self.playEffect)
    dxyDispatcher_removeEventListener(dxyEventType.Skill_Update_Effect,self,self.playEffect)
    dxyDispatcher_removeEventListener("UpdateAllSkill",self,self.updateSkillState)
end

function SkillWarfieldSlider:reset()
    self.pageView:scrollToPage(0)
end

function SkillWarfieldSlider:selectToPage(index)
    local page = self.pageView:getCurPageIndex()
    if page ~= index then   	
        self.pageView:scrollToPage(index)
    end
end

function SkillWarfieldSlider:updateSkillState()
	local skillList = zzm.SkillModel:getSkillIsTips()
    for index = 1, #self.itemList do
        self.itemList[index].redIcon:setVisible(false)
        for var=1, #skillList do
            if self.itemList[index].data.Id == skillList[var] then
				self.itemList[index].redIcon:setVisible(true)
				break
			end
		end		
	end
end

