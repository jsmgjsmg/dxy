TowerItem = TowerItem or class("TowerItem",function()
	return cc.Layer:create()
end)

TowerType = {
    EXP = 7,
    FLOWER = 8,
    RENOWN = 9,
}

function TowerItem:create()
    local node = TowerItem:new()
    return node
end

function TowerItem:ctor()
	self._csb = nil
	
	self.isExpCD = true
    self.isFlowerCD = true
    self.isRenownCD = true
	
	self:initUI()
--	self:initEvent()
    dxyExtendEvent(self)
end

function TowerItem:initUI()
	self._csb = cc.CSLoader:createNode("dxyCocosStudio/csd/ui/tower/TowerItem.csb")
	self:addChild(self._csb)
	
    self._timeLine = cc.CSLoader:createTimeline("dxyCocosStudio/csd/ui/tower/TowerItem.csb")
    self._csb:runAction(self._timeLine)
    self._timeLine:gotoFrameAndPlay(0,true)
	
    self.expDarkNode = self._csb:getChildByName("expDarkNode")
    self.txt_expUnlock = self.expDarkNode:getChildByName("lockBg"):getChildByName("Text")
    self.flowerDarkNode = self._csb:getChildByName("flowerDarkNode")
    self.txt_flowerUnlock = self.flowerDarkNode:getChildByName("lockBg"):getChildByName("Text")
    self.renownDarkNode = self._csb:getChildByName("renownDarkNode")
    self.txt_renownUnlock = self.renownDarkNode:getChildByName("lockBg"):getChildByName("Text")
    
    self.btn_exp = self._csb:getChildByName("expNode"):getChildByName("startBtn")
    self.btn_flower = self._csb:getChildByName("flowerNode"):getChildByName("startBtn")
    self.btn_renown = self._csb:getChildByName("renownNode"):getChildByName("startBtn")
    
    self.txt_countExp = self._csb:getChildByName("expNode"):getChildByName("countBmf")
    self.txt_countExpDark = self.expDarkNode:getChildByName("countBmf")
    self.txt_countFlower = self._csb:getChildByName("flowerNode"):getChildByName("countBmf")
    self.txt_countFlowerDark = self.flowerDarkNode:getChildByName("countBmf")
    self.txt_countRenown = self._csb:getChildByName("renownNode"):getChildByName("countBmf")
    self.txt_countRenownDark = self.renownDarkNode:getChildByName("countBmf")
    
    self.middleNode = self._csb:getChildByName("middleNode")
    
    self.txt_expTime = self._csb:getChildByName("expNode"):getChildByName("cdTime")
    self.txt_expTime:setVisible(false)
    self.txt_flowerTime = self._csb:getChildByName("flowerNode"):getChildByName("cdTime")
    self.txt_flowerTime:setVisible(false)
    self.txt_renownTime = self._csb:getChildByName("renownNode"):getChildByName("cdTime")
    self.txt_renownTime:setVisible(false)
	
	zzc.TowerController:request_towerCD()
end

function TowerItem:updateValue()
    local role = zzm.CharacterModel:getCharacterData()
    local enCAT = enCharacterAttrType
    local lv = role:getValueByType(enCAT.LV)

    self.expCount = role:getValueByType(enCAT.TRAINEXPCOUNT)
    self.flowerCount = role:getValueByType(enCAT.TRAINFLOWERCOUNT)
    self.renownCount = role:getValueByType(enCAT.TRAINRENOWNCOUNT)

    local maxCount = AutocephalyValueConfig:getValueByContent("TrainNumber")

    self.txt_countExp:setString(self.expCount.."/"..maxCount)
    self.txt_countExpDark:setString(self.expCount.."/"..maxCount)
    self.txt_countFlower:setString(self.flowerCount.."/"..maxCount)
    self.txt_countFlowerDark:setString(self.flowerCount.."/"..maxCount)
    self.txt_countRenown:setString(self.renownCount.."/"..maxCount)
    self.txt_countRenownDark:setString(self.renownCount.."/"..maxCount)

    self.txt_expUnlock:setString(TowerConfig:getDataByType(TowerType.EXP).TrainDeblockingLV.."级解锁")
    self.txt_flowerUnlock:setString(TowerConfig:getDataByType(TowerType.FLOWER).TrainDeblockingLV.."级解锁")
    self.txt_renownUnlock:setString(TowerConfig:getDataByType(TowerType.RENOWN).TrainDeblockingLV.."级解锁")

    if lv >= TowerConfig:getDataByType(TowerType.EXP).TrainDeblockingLV then
        if self.isExpCD then
            self.btn_exp:setBright(false)
            self.btn_exp:setTouchEnabled(false)
            self.expDarkNode:setVisible(false)
        else
            self.btn_exp:setBright(true)
            self.btn_exp:setTouchEnabled(true)
            self.expDarkNode:setVisible(false)
        end
    else
        self.btn_exp:setBright(false)
        self.btn_exp:setTouchEnabled(false)
    end

    if lv >= TowerConfig:getDataByType(TowerType.FLOWER).TrainDeblockingLV then
        if self.isFlowerCD then
            self.btn_flower:setBright(false)
            self.btn_flower:setTouchEnabled(false)
            self.flowerDarkNode:setVisible(false)
        else
            self.btn_flower:setBright(true)
            self.btn_flower:setTouchEnabled(true)
            self.flowerDarkNode:setVisible(false)
        end
    else
        self.btn_flower:setBright(false)
        self.btn_flower:setTouchEnabled(false)
    end

    if lv >= TowerConfig:getDataByType(TowerType.RENOWN).TrainDeblockingLV then
        if self.isRenownCD then
            self.btn_renown:setBright(false)
            self.btn_renown:setTouchEnabled(false)
            self.renownDarkNode:setVisible(false)
        else
            self.btn_renown:setBright(true)
            self.btn_renown:setTouchEnabled(true)
            self.renownDarkNode:setVisible(false)
        end
    else
        self.btn_renown:setBright(false)
        self.btn_renown:setTouchEnabled(false)
    end
end

function TowerItem:updateTime(timeList)
	local expTime = timeList[1]
	local flowerTime = timeList[2]
	local renownTime = timeList[3]
	
	---经验副本
    if expTime > 0 then
        local overexpTime = expTime - (os.time() - _G.DiffTimer)
        if overexpTime > 0 then
            self.txt_expTime:setVisible(true)
            self.isExpCD = true
            self:updateValue()
            local showTime = (string.format("%02d",os.date("%H",overexpTime)-8))..":"..os.date("%M",overexpTime)..":"..os.date("%S",overexpTime)
            self.txt_expTime:setString(showTime)
            local sharedScheduler = cc.Director:getInstance():getScheduler()
            self._handleExp = self._handleExp or sharedScheduler:scheduleScriptFunc(function()
                overexpTime = overexpTime - 1
                local showTime = (string.format("%02d",os.date("%H",overexpTime)-8))..":"..os.date("%M",overexpTime)..":"..os.date("%S",overexpTime)
                self.txt_expTime:setString(showTime)
                if overexpTime <= 0 then
                    if(self._handleExp)then
                        cc.Director:getInstance():getScheduler():unscheduleScriptEntry(self._handleExp)
                        self._handleExp = nil
                        self.txt_expTime:setVisible(false)
                        self.isExpCD = false
                        self:updateValue()
                    end
                end
            end,1,false)
        else
            if self._handleExp then
                cc.Director:getInstance():getScheduler():unscheduleScriptEntry(self._handleExp)
                self._handleExp = nil
            end
            self.txt_expTime:setVisible(false)
            self.isExpCD = false
            self:updateValue()
        end
    elseif expTime == 0 then
        self.txt_expTime:setVisible(false)
        self.isExpCD = false
        self:updateValue()
    end
	
    ---鲜花副本
    if flowerTime > 0 then
        local overflowerTime = flowerTime - (os.time() - _G.DiffTimer)
        if overflowerTime > 0 then
            self.txt_flowerTime:setVisible(true)
            self.isFlowerCD = true
            self:updateValue()
            local showTime = (string.format("%02d",os.date("%H",overflowerTime)-8))..":"..os.date("%M",overflowerTime)..":"..os.date("%S",overflowerTime)
            self.txt_flowerTime:setString(showTime)
            local sharedScheduler = cc.Director:getInstance():getScheduler()
            self._handleFlower = self._handleFlower or sharedScheduler:scheduleScriptFunc(function()
                overflowerTime = overflowerTime - 1
                local showTime = (string.format("%02d",os.date("%H",overflowerTime)-8))..":"..os.date("%M",overflowerTime)..":"..os.date("%S",overflowerTime)
                self.txt_flowerTime:setString(showTime)
                if overflowerTime <= 0 then
                    if(self._handleFlower)then
                        cc.Director:getInstance():getScheduler():unscheduleScriptEntry(self._handleFlower)
                        self._handleFlower = nil
                        self.txt_flowerTime:setVisible(false)
                        self.isFlowerCD = false
                        self:updateValue()
                    end
                end
            end,1,false)
        else
            if self._handleFlower then
                cc.Director:getInstance():getScheduler():unscheduleScriptEntry(self._handleFlower)
                self._handleFlower = nil
            end
            self.txt_flowerTime:setVisible(false)
            self.isFlowerCD = false
            self:updateValue()
        end
    elseif flowerTime == 0 then
        self.txt_flowerTime:setVisible(false)
        self.isFlowerCD = false
        self:updateValue()
    end
    
    ---声望副本
    if renownTime > 0 then
        local overrenownTime = flowerTime - (os.time() - _G.DiffTimer)
        if overrenownTime > 0 then
            self.txt_renownTime:setVisible(true)
            self.isRenownCD = true
            self:updateValue()
            local showTime = (string.format("%02d",os.date("%H",overrenownTime)-8))..":"..os.date("%M",overrenownTime)..":"..os.date("%S",overrenownTime)
            self.txt_renownTime:setString(showTime)
            local sharedScheduler = cc.Director:getInstance():getScheduler()
            self._handleRenown = self._handleFlower or sharedScheduler:scheduleScriptFunc(function()
                overrenownTime = overrenownTime - 1
                local showTime = (string.format("%02d",os.date("%H",overrenownTime)-8))..":"..os.date("%M",overrenownTime)..":"..os.date("%S",overrenownTime)
                self.txt_renownTime:setString(showTime)
                if overrenownTime <= 0 then
                    if(self._handleRenown)then
                        cc.Director:getInstance():getScheduler():unscheduleScriptEntry(self._handleRenown)
                        self._handleRenown = nil
                        self.txt_renownTime:setVisible(false)
                        self.isRenownCD = false
                        self:updateValue()
                    end
                end
            end,1,false)
        else
            if self._handleRenown then
                cc.Director:getInstance():getScheduler():unscheduleScriptEntry(self._handleRenown)
                self._handleRenown = nil
            end
            self.txt_renownTime:setVisible(false)
            self.isRenownCD = false
            self:updateValue()
        end
    elseif flowerTime == 0 then
        self.txt_renownTime:setVisible(false)
        self.isRenownCD = false
        self:updateValue()
    end
end

function TowerItem:removeEvent()
    dxyDispatcher_removeEventListener("updateValue",self,self.updateValue)
    dxyDispatcher_removeEventListener("updateTowerTime",self,self.updateTime)
end

function TowerItem:initEvent()

    dxyDispatcher_addEventListener("updateValue",self,self.updateValue)
    dxyDispatcher_addEventListener("updateTowerTime",self,self.updateTime)

    self:updateValue()

    self.btn_exp:addTouchEventListener(function(target,type)
        if type == 2 then
            SoundsFunc_playSounds(SoundsType.UNIVERSAL_BTN,false)
            if self.expCount <= 0 then
                TipsFrame:create("次数已用完!")
                return
            end
            require("game.tower.view.TowerExpLayer")
            local layer = TowerExpLayer:create()
            self.middleNode:addChild(layer)
        end
    end)
    
    self.btn_flower:addTouchEventListener(function(target,type)
        if type == 2 then
            SoundsFunc_playSounds(SoundsType.UNIVERSAL_BTN,false)
            if self.flowerCount <= 0 then
            	TipsFrame:create("次数已用完!")
            	return
            end
            require("game.tower.view.TowerFlowerLayer")
            local layer = TowerFlowerLayer:create()
            self.middleNode:addChild(layer)
        end
    end)
    
    self.btn_renown:addTouchEventListener(function(target,type)
        if type == 2 then
            SoundsFunc_playSounds(SoundsType.UNIVERSAL_BTN,false)
            if self.renownCount <= 0 then
                TipsFrame:create("次数已用完!")
                return
            end
            require("game.tower.view.TowerRenownLayer")
            local layer = TowerRenownLayer:create()
            self.middleNode:addChild(layer)
        end
    end)
end