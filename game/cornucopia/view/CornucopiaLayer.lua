CornucopiaLayer = CornucopiaLayer or class("CornucopiaLayer",function()
    return cc.Layer:create()
end)

function CornucopiaLayer:create()
    local layer = CornucopiaLayer:new()
    return layer
end

function CornucopiaLayer:ctor()
    self._csb = nil
    self.isCD = true

    self:initUI()
    --	self:initEvent()
    dxyExtendEvent(self)
end

function CornucopiaLayer:initUI()
    self._csb = cc.CSLoader:createNode("dxyCocosStudio/csd/ui/cornucopia/cornucopiaLayer.csb")
    self:addChild(self._csb)

    self._timeLine = cc.CSLoader:createTimeline("dxyCocosStudio/csd/ui/cornucopia/cornucopiaLayer.csb")
    self._csb:runAction(self._timeLine)
    self._timeLine:gotoFrameAndPlay(0,true)

    local bg = self._csb:getChildByName("bg")
    self.btn_close = bg:getChildByName("closeBtn")
    self.btn_enter = bg:getChildByName("enterBtn")
    self.txt_count = bg:getChildByName("count")

    local infoNode = bg:getChildByName("infoNode")
    self.txt_now = infoNode:getChildByName("nowTxt")
    self.txt_nowNeed = infoNode:getChildByName("nowNeedTxt")
    self.txt_nowGold = infoNode:getChildByName("nowGoldTxt")
    self.txt_next = infoNode:getChildByName("nextTxt")
    self.txt_nextNeed = infoNode:getChildByName("nextNeedTxt")
    self.txt_nextGold = infoNode:getChildByName("nextGoldTxt")

    self.txt_cdTime = bg:getChildByName("cdTime")
    self.txt_cdTime:setVisible(false)

    zzc.CornucopiaController:request_cornucopiaCD()
end

function CornucopiaLayer:updateValue()
    local role = zzm.CharacterModel:getCharacterData()
    local enCAT = enCharacterAttrType
    self.txt_count:setString(role:getValueByType(enCAT.MONEYCOUNT))
    self.txt_now:setString(role:getValueByType(enCAT.MONEYLAYER).."层")
    self.txt_nowNeed:setString("(需要等级"..MoneySceneConfig:getLvByLayer(role:getValueByType(enCAT.MONEYLAYER))..")")
    self.txt_nowGold:setString(MoneySceneConfig:getMinGold(role:getValueByType(enCAT.MONEYLAYER)).." - "..MoneySceneConfig:getMaxGold(role:getValueByType(enCAT.MONEYLAYER)))
    self.txt_next:setString((role:getValueByType(enCAT.MONEYLAYER) + 1).."层")
    self.txt_nextNeed:setString("(需要等级"..MoneySceneConfig:getLvByLayer(role:getValueByType(enCAT.MONEYLAYER) + 1)..")")
    self.txt_nextGold:setString(MoneySceneConfig:getMinGold(role:getValueByType(enCAT.MONEYLAYER) + 1).." - "..MoneySceneConfig:getMaxGold(role:getValueByType(enCAT.MONEYLAYER) + 1))

    if self.isCD then
        self.btn_enter:setTouchEnabled(false)
        self.btn_enter:setBright(false)
    else
        if role:getValueByType(enCAT.MONEYCOUNT) <= 0 then
            self.btn_enter:setTouchEnabled(false)
            self.btn_enter:setBright(false)
        else
            self.btn_enter:setTouchEnabled(true)
            self.btn_enter:setBright(true)
        end
    end
end

function CornucopiaLayer:updateTime(time)
    if time > 0 then
        local overTime = time - (os.time()-_G.DiffTimer)
        if overTime > 0 then
            self.txt_cdTime:setVisible(true)
            self.isCD = true
            self:updateValue()
            local showTime = (string.format("%02d",os.date("%H",overTime)-8))..":"..os.date("%M",overTime)..":"..os.date("%S",overTime)
            self.txt_cdTime:setString(showTime)
            local sharedScheduler = cc.Director:getInstance():getScheduler()
            self._handle = self._handle or sharedScheduler:scheduleScriptFunc(function()
                overTime = overTime - 1
                local showTime = (string.format("%02d",os.date("%H",overTime)-8))..":"..os.date("%M",overTime)..":"..os.date("%S",overTime)
                self.txt_cdTime:setString(showTime)
                if overTime <= 0 then
                    if(self._handle)then
                        cc.Director:getInstance():getScheduler():unscheduleScriptEntry(self._handle)
                        self._handle = nil
                        self.txt_cdTime:setVisible(false)
                        self.isCD = false
                        self:updateValue()
                    end
                end
            end,1,false)
        else
            if self._handle then
                cc.Director:getInstance():getScheduler():unscheduleScriptEntry(self._handle)
                self._handle = nil
            end
            self.txt_cdTime:setVisible(false)
            self.isCD = false
            self:updateValue()
        end
    elseif time == 0 then
        self.txt_cdTime:setVisible(false)
        self.isCD = false
        self:updateValue()
    end
end

function CornucopiaLayer:removeEvent()
    dxyDispatcher_removeEventListener("updateValue",self,self.updateValue)
    dxyDispatcher_removeEventListener("updateTime",self,self.updateTime)
end

function CornucopiaLayer:initEvent()

    dxyDispatcher_addEventListener("updateValue",self,self.updateValue)
    dxyDispatcher_addEventListener("updateTime",self,self.updateTime)

    self:updateValue()

    self.btn_close:addTouchEventListener(function(target,type)
        if type == 2 then
            SoundsFunc_playSounds(SoundsType.CLOSE_PAGE,false)
            zzc.CornucopiaController:closeLayer()
        end
    end)

    self.btn_enter:addTouchEventListener(function(target,type)
        if type == 2 then
            SoundsFunc_playSounds(SoundsType.UNIVERSAL_BTN,false)
            zzm.TalkingDataModel:onBegin(MoneySceneConfig:getBaseValueByKey("SceneId"))
            zzc.CornucopiaController:closeLayer()
            zzc.LoadingController:setCopyData({copyType = DefineConst.CONST_COPY_TYPE_MONEY,chapterID = 0, startTalkID = 0, endTalkID = 0, sceneID = MoneySceneConfig:getBaseValueByKey("SceneId"), param1 = 0})
            zzc.LoadingController:enterScene(SceneType.LoadingScene)
            zzc.LoadingController:setDelegate2(
                {target = self,
                    func = function (data)
                        --zzc.LoadingController:setCopyData({chapterID = self.m_data.chpaterID, startTalkID = self.m_data.startTalkID, endTalkID = self.m_data.endTalkID, sceneID = self.m_data.config.Id})
                        zzc.LoadingController:enterScene(SceneType.CopyScene)
                    end,data = self.m_data})
        end
    end)


    -- 拦截
    dxySwallowTouches(self)
end

function CornucopiaLayer:WhenClose()
    if(self._handle)then
        cc.Director:getInstance():getScheduler():unscheduleScriptEntry(self._handle)
        self._handle = nil
    end
    self:removeFromParent()
end
