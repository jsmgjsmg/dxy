
SoulSkillWarfieldSlider = SoulSkillWarfieldSlider or class("SoulSkillWarfieldSlider",function()
    return cc.Layer:create()
end)

function SoulSkillWarfieldSlider.create()
    local layer = SoulSkillWarfieldSlider.new()
    return layer
end

function SoulSkillWarfieldSlider:ctor()
    self._csbNode = nil
    self._typeLayer = {}
    self:initUI()
    --self:initEvent()
    dxyExtendEvent(self)
end



function SoulSkillWarfieldSlider:initUI()
    self._csbNode = cc.CSLoader:getInstance():createNodeWithFlatBuffersFile("dxyCocosStudio/csd/ui/skill/SkillWarfieldSlider.csb")
    self:addChild(self._csbNode)

    self.visibleSize = cc.Director:getInstance():getVisibleSize()
    self.origin = cc.Director:getInstance():getVisibleOrigin()

    local posX = self.origin.x + self.visibleSize.width/2
    local posY = self.origin.y + self.visibleSize.height/2

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
    for index=1, #HeroSkill:getHeroSoulSkillList(role:getValueByType(enCAT.PRO)) do
        item = SkillToggle:create()
        itemSize = item:getItemSize()
        local x = viewSize.width / 2
        local y = viewSize.height / 2
        item:setPosition(cc.p(x,y))
        item:setParent(self.pageView)
        item:setIndex(index)

        item:updateSoul(HeroSkill:getHeroSoulSkillList(role:getValueByType(enCAT.PRO))[index],self)
        item:setType(SKILL_TYPE.soulskill)
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

    self:onSelectByIndex(HeroSkill:getHeroSoulSkillList(role:getValueByType(enCAT.PRO))[1])

end

function SoulSkillWarfieldSlider:onSelectByIndex(type)
    print("------------------ : " .. type.Id)
    zzm.SkillModel:setCurSoulSkill(type)
    dxyDispatcher_dispatchEvent(dxyEventType.SoulSkill_Info,type)
    dxyDispatcher_dispatchEvent(dxyEventType.SoulctSkill_Info,type)
end

function SoulSkillWarfieldSlider:initEvent()

    dxyDispatcher_addEventListener(dxyEventType.SkillLayer_Reset,self,self.reset)
    dxyDispatcher_addEventListener(dxyEventType.soulSkill_Equiped,self,self.selectToPage)
    
    self.pageView:addEventListener(function(target,type)
        if type == ccui.PageViewEventType.turning then
            SoundsFunc_playSounds(SoundsType.UNIVERSAL_BTN,false)
            local page = self.pageView:getCurPageIndex()
            self:onSelectByIndex(self.itemList[page+1].data)
            if self.itemList[page+1].isLock then
                dxyDispatcher_dispatchEvent(dxyEventType.SoulSkill_Unlock)
            end
            local role = zzm.CharacterModel:getCharacterData()
            local enCAT = enCharacterAttrType
            for index=1, #HeroSkill:getHeroSoulSkillList(role:getValueByType(enCAT.PRO)) do
                if index == page + 1 then
                    self.itemList[index]:runLarger()
                    --self.itemList[index]:runAction(cc.EaseSineOut:create(cc.ScaleTo:create(0.3,1)))
                else
                    self.itemList[index]:runSmall()
                    --self.itemList[index]:runAction(cc.EaseSineOut:create(cc.ScaleTo:create(0.3,0.6)))
                end
            end
        end
    end)
end

function SoulSkillWarfieldSlider:removeEvent()
    dxyDispatcher_removeEventListener(dxyEventType.SkillLayer_Reset,self,self.reset)
    dxyDispatcher_removeEventListener(dxyEventType.soulSkill_Equiped,self,self.selectToPage)
end

function SoulSkillWarfieldSlider:reset() 
    self.pageView:scrollToPage(0)
end

function SoulSkillWarfieldSlider:selectToPage(index)
    self.pageView:scrollToPage(index)
end