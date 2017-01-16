SKILL_TYPE = {
    skill = 1,      --技能
    ctskill = 2,    --连招
    soulskill = 3,  --元神技能
}

SkillToggle = SkillToggle or class("SkillToggle",function()
    local path = "dxyCocosStudio/png/skill/new/skill_icon.png"
    return ccui.Button:create(path,path,path)
end)

function SkillToggle:create()
    local node = SkillToggle:new()
    --node:setName("SkillToggle")
    return node
end

function SkillToggle:ctor()

    self._csb = nil

    self.visibleSize = cc.Director:getInstance():getVisibleSize()
    self.origin = cc.Director:getInstance():getVisibleOrigin()

    self.equipFrame = nil
    self.pic_euqip = nil

    self.type = nil

    self.isLock = true

    self.bg_lock = nil
    self.bg_unlock = nil
    self.icon_lock = nil
    self.icon_unlock = nil
    self.lock_lock = nil
    self.lock_unlock = nil

    self.name = nil
    self.lv = nil

    self:initUI()
    --self:initEvent()
    dxyExtendEvent(self)
end

function SkillToggle:initUI()
    --local _csb = cc.CSLoader:createNode("dxyCocosStudio/csd/ui/skill/SkillToggle.csb")
    self._csb = cc.CSLoader:createNode("dxyCocosStudio/csd/ui/skill/SkillCItem.csb")
    self:addChild(self._csb)
    
    self._timeLine = cc.CSLoader:createTimeline("dxyCocosStudio/csd/ui/skill/SkillCItem.csb")
    self._csb:runAction(self._timeLine)
    self._timeLine:gotoFrameAndPlay(0,true)
    self._timeLine:setTimeSpeed(0.3)

    local x = self:getContentSize().width / 2
    local y = self:getContentSize().height / 2

    self._csb:setPosition(cc.p(x,y))

    self.icon = self._csb:getChildByName("Button")

    self.bg_lock = self._csb:getChildByName("BG_2")
    self.bg_unlock = self._csb:getChildByName("BG_1")
    self.icon_lock = self._csb:getChildByName("Icon_2")
    self.icon_unlock = self._csb:getChildByName("Icon_1")
    self.lock_lock = self._csb:getChildByName("Lock_2")
    self.lock_unlock = self._csb:getChildByName("Lock_1")

    self.name = self._csb:getChildByName("Text_1")
    self.lv = self._csb:getChildByName("Text_2")
    self.goldIcon = self.lv:getChildByName("gold")
    self.goldIcon:setVisible(false)
    
    self.action = self._csb:getChildByName("action")

    self.action:setVisible(false)
    
    self.redIcon = self._csb:getChildByName("redIcon")
    self.redIcon:setVisible(false)
end

function SkillToggle:runLarger()
    self.action:setVisible(true)
	local action = cc.RepeatForever:create(cc.Spawn:create(cc.ScaleTo:create(0.1,1),cc.TargetedAction:create(self.action,cc.RotateBy:create(1,20))))
	self:runAction(action)
end

function SkillToggle:runSmall()
    self.action:setVisible(false)
    local function stopCallBack()
        self:stopAllActions()
    end
    local action = cc.Sequence:create(cc.ScaleTo:create(0.1,0.6),cc.CallFunc:create(stopCallBack))
    
    self:runAction(action)
end

function SkillToggle:setParent(parent)
    self._parent = parent
    --    if self._parent then
    --        self._parentX = self._parent:getPositionX()
    --        self._width = self._parent:getContentSize().width
    --    end
end

function SkillToggle:setType(type)
    self.type = type
end

function SkillToggle:getItemSize()
    local size = self.icon:getContentSize()
    return size
end

function SkillToggle:setIndex(idx)
    self.idx = idx
end

function SkillToggle:initEvent()

    dxyDispatcher_addEventListener(dxyEventType.Skill_Layer,self,self.autoUpdateSkill)
    dxyDispatcher_addEventListener(dxyEventType.ctSkill_Layer,self,self.autoUpdatectSkill)
    dxyDispatcher_addEventListener("skill_upgrade",self,self.talkingDataSend)

    self:addTouchEventListener(function(target,type)
        if(type==2)then
            if self.delegate and self.type == SKILL_TYPE.skill then
                self.delegate:onSelectByIndex(self.data)
                if self.isLock then
                    dxyDispatcher_dispatchEvent(dxyEventType.Skill_Unlock)
                end
                self._parent:scrollToPage(self.idx - 1)
            end
            if self.delegate and self.type == SKILL_TYPE.soulskill then
                self.delegate:onSelectByIndex(self.data)
                if self.isLock then
                    dxyDispatcher_dispatchEvent(dxyEventType.SoulSkill_Unlock)
                end
                self._parent:scrollToPage(self.idx - 1)
            end
            if self.delegate and self.type == SKILL_TYPE.ctskill then
                SoundsFunc_playSounds(SoundsType.UNIVERSAL_BTN,false)
                if self.isLock then
                    zzc.SkillController:request_CTSkillDeblock(self.id,self.data.idx)
--                    require("game.skill.view.SkillCUnlock")
--                    local unlock = SkillCUnlock:create()
--                    local data = {}
--                    data.id = self.id
--                    data.idx = self.data.idx
--                    unlock:update(data)
--                    SceneManager:getCurrentScene():addChild(unlock)
--                    unlock:setPosition(self.origin.x+self.visibleSize.width/2,self.origin.y+self.visibleSize.height/2)
                else
                    self.delegate:onSelectByIndex(self.data,self.id)
                end

            end
        end
    end)
end

function SkillToggle:removeEvent()
    dxyDispatcher_removeEventListener(dxyEventType.Skill_Layer,self,self.autoUpdateSkill)
    dxyDispatcher_removeEventListener(dxyEventType.ctSkill_Layer,self,self.autoUpdatectSkill)
    dxyDispatcher_removeEventListener("skill_upgrade",self,self.talkingDataSend)
end

function SkillToggle:talkingDataSend(skillId)
    if self.data.Id == skillId then 	
        zzm.TalkingDataModel:onEvent((EumEventId.SKILL_UPGRADE)..self.idx,{})
    end
end


--连招更新
function SkillToggle:setSkill(data,id,del)
    self.data = data
    self.id = id
    self.delegate = del

    if self.data.is_unlock == 0 then
        self.bg_lock:setVisible(true)
        self.bg_unlock:setVisible(false)
        self.icon_lock:setVisible(false)
        self.icon_unlock:setVisible(false)
        self.lock_lock:setVisible(true)
        self.lock_unlock:setVisible(false)
        self.name:setVisible(false)
        self.lv:setVisible(false)
        self.isLock = true
        if self.data.idx > 1 then
            self.delegate.lock_list[self.id][self.data.idx]["locked"]:setVisible(true)
            self.delegate.lock_list[self.id][self.data.idx]["unlock"]:setVisible(false)
        end
        
        --解锁技能槽提示
        local role = zzm.CharacterModel:getCharacterData()
        local enCAT = enCharacterAttrType
        local roleGold = role:getValueByType(enCAT.GOLD)
        local roleLv = role:getValueByType(enCAT.LV)       
        local unlockLv = CTSkillConfig:getCTSkillByIdAndinx(self.id,self.data.idx).SkillDeblockingLv
        local unlockGold = CTSkillConfig:getCTSkillByIdAndinx(self.id,self.data.idx).SkillDeblockingGold
        if roleLv >= unlockLv then
            self.goldIcon:setVisible(true)
            self.lv:setVisible(true)
            self.lv:setString(unlockGold.."解锁")
        else
            self.lv:setVisible(true)
            self.lv:setString("LV:"..unlockLv.."可解锁")
        end
    elseif self.data.is_unlock == 1 then
        self.bg_lock:setVisible(false)
        self.bg_unlock:setVisible(true)
        self.icon_lock:setVisible(false)
        self.icon_unlock:setVisible(false)
        self.lock_lock:setVisible(false)
        self.lock_unlock:setVisible(false)
        self.isLock = false
        if self.data.idx > 1 then
            self.delegate.lock_list[self.id][self.data.idx]["locked"]:setVisible(false)
            self.delegate.lock_list[self.id][self.data.idx]["unlock"]:setVisible(true)
        end
        if self.data.skill_id == 0 then
            self.name:setVisible(false)
            self.lv:setVisible(false)
            self.name:setString("")
            self.lv:setString("")
        else
            self.icon_unlock:setVisible(true)
            self.icon_unlock:setTexture(SkillConfig:getSkillConfigById(self.data.skill_id).Icon)
            self.name:setVisible(false)
            self.name:setString(SkillConfig:getSkillConfigById(self.data.skill_id).Name)
            self.lv:setVisible(false)
            self.lv:setString("LV."..zzm.SkillModel:getSkillLvById(self.data.skill_id))
        end
    end

end

--技能更新
function SkillToggle:update(data, del)
    self.data = data
    self.delegate = del
    --self:adjustScrollView()

    local unlockList = zzm.SkillModel:getSkillList()

    self.icon_unlock:setTexture(self.data.Icon)
    self.icon_lock:setTexture(self.data.LockIcon)

    if #unlockList == 0 then
        self.bg_lock:setVisible(true)
        self.bg_unlock:setVisible(false)
        self.icon_lock:setVisible(true)
        self.icon_unlock:setVisible(false)
        self.lock_lock:setVisible(true)
        self.lock_unlock:setVisible(false)
        self.name:setVisible(false)
        self.lv:setVisible(false)
        self.isLock = true
    end

    for key, var in pairs(unlockList) do
        if var.id == self.data.Id then
            self.bg_lock:setVisible(false)
            self.bg_unlock:setVisible(true)
            self.icon_lock:setVisible(false)
            self.icon_unlock:setVisible(true)
            self.lock_lock:setVisible(false)
            self.lock_unlock:setVisible(false)
            self.name:setVisible(false)
            self.lv:setVisible(true)
            self.lv:setString("LV."..zzm.SkillModel:getSkillLvById(self.data.Id))
            self.isLock = false
            return
        end
    end
    self.bg_lock:setVisible(true)
    self.bg_unlock:setVisible(false)
    self.icon_lock:setVisible(true)
    self.icon_unlock:setVisible(false)
    self.lock_lock:setVisible(true)
    self.lock_unlock:setVisible(false)
    self.name:setVisible(false)
    self.lv:setVisible(false)
    self.isLock = true
end

--法器技能更新
function SkillToggle:updateSoul(data,del)
    self.data = data
    self.delegate = del

    self.icon_unlock:setTexture(self.data.Icon)
    self.icon_lock:setTexture(self.data.LockIcon)

    if zzm.SkillModel:getSoulSkillUnlock(self.data.Id) then
        self.bg_lock:setVisible(false)
        self.bg_unlock:setVisible(true)
        self.icon_lock:setVisible(false)
        self.icon_unlock:setVisible(true)
        self.lock_lock:setVisible(false)
        self.lock_unlock:setVisible(false)
        self.name:setVisible(false)
        self.lv:setVisible(true)
        self.lv:setString("LV."..zzm.SkillModel:getSoulSkillLvById(self.data.Id))
        self.isLock = false
    else
        self.bg_lock:setVisible(true)
        self.bg_unlock:setVisible(false)
        self.icon_lock:setVisible(true)
        self.icon_unlock:setVisible(false)
        self.lock_lock:setVisible(true)
        self.lock_unlock:setVisible(false)
        self.name:setVisible(false)
        self.lv:setVisible(false)
        self.isLock = true
    end
end

--更新技能函数
function SkillToggle:autoUpdateSkill(data)
    if self.type == SKILL_TYPE.skill then
        for key, var in pairs(data) do
            if self.data and var.id == self.data.Id then
                self:update(SkillConfig:getSkillConfigById(var.id),self.delegate)
                return
            end
        end
    end
end

--更新连招函数
function SkillToggle:autoUpdatectSkill(data)
    if self.type == SKILL_TYPE.ctskill then
        for key_1, var_1 in pairs(data) do
            for key_2, var_2 in pairs(var_1) do
                if self.data and key_1 == self.id and var_2.idx == self.data.idx then
                    self:setSkill(var_2,key_1,self.delegate)
                    return
                end
            end
        end
    end
end

function SkillToggle:getDistance()
    return self.distance
end

function SkillToggle:adjustScrollView()
    if self._parent then
    --        local x = self._parent:getInnerContainer():getPositionX()
    --        self.distance = self:getPositionX() + x - self._parent:getPositionX()
    --        --print( "distance----->" .. self.distance)
    --        local p = (self._width/2 -2* math.abs(self.distance/2))/(self._width/2)
    --        if p < 0.5 then
    --            p = 0.5
    --        end
    --        self:setScale(p)
    --        for index=1, 6 do
    --            local x = self.delegate.panelList[index]:getPositionX()
    --            if x == 0 then
    --                self:setScale(1.0)
    --        	else
    --                self:setScale(0.6)
    --        	end
    --        end

    end

end