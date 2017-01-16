
GameScene = GameScene or class("GameScene",function()
    return mc.BattleScene:create()
end)

function GameScene.create()
    local scene = GameScene.new()
    return scene
end

function GameScene:setGameSceneId(id)
    self._gameSceneId = id
end

function GameScene:onBattleShowReturnBtn()
	--if self._returnSelectRole then
	if _G.MyData.returnBattleShowType == 1 then
		local loginScene = zzc.LoginController:getScene()
		SceneManager:enterScene(loginScene, "LoginScene")
		loginScene:enterLayer(LoginLayerType.CreateRoleLayer)
	else
        require("game.loading.PreLoadScene")
        local preLoadScene = PreLoadScene.create()
        preLoadScene:initPreLoad("MainScene","dxyCocosStudio/csd/scene/MainScene_new.csb",function()
            zzc.SkillController:showLayer()
        end)
        SceneManager:enterScene(preLoadScene, "PreLoadScene")
	end
end

function GameScene:ctor()

	local battleShowStep = cc.UserDefault:getInstance():getIntegerForKey("BattleShowStep",0)
	if battleShowStep == 0 then
		battleShowStep = 1
		cc.UserDefault:getInstance():setIntegerForKey("BattleShowStep",1)
		self._returnSelectRole = true
	end
	-- cc.UserDefault:getInstance():setIntegerForKey("BattleShowStep",0)
	
    zzc.MarqueeController:startTimer()
    self.visibleSize = cc.Director:getInstance():getVisibleSize()
    self.origin = cc.Director:getInstance():getVisibleOrigin()
    self.schedulerID = nil

    SceneManager._CopyTimesIn = false
    SceneManager._HaveUseHp = false
    SceneManager._HaveHalfMaxHp = false

    self._onlyOneClickFlag = false
    
    zzc.GuideController._isRunning = false
    zzm.GuideModel._isNoTalk = false
    SceneManager._EndTalk = false

---战斗中新手开启检测 标②
    self._myGuideTimer = self._myGuideTimer or require("game.utils.MyTimer").new()
    local function tick()
        local flag = zzc.GuideController:checkNewGuide()
        if flag then
            self._myGuideTimer:stop()
            self._myGuideTimer = nil
        end
    end
    self._myGuideTimer:start(0.5, tick)





    dxyExtendEvent(self)



    --self:initUI()

    --    self:initLayers()
    --    self:startGame()

    --self._csbResultNode = cc.CSLoader:getInstance():createNodeWithFlatBuffersFile("GameScene/GameResultWin.csb")
    --self:addChild(self._csbResultNode)
--    
--    -- updateMsg
--    local function updateMsgTimer(dt)
--
--        --        self:setAIWork(false)
--        --        self:setUpdateWork(false)
--
--        if mc.NetMannager:getInstance():checkDisConnect() == true then
--            local loginScene = zzc.LoginController:getScene()
--
--            local lastMsg = mc.NetMannager:getInstance():getLastMsg()
--
--            self:WhenGameEnd()
--            print("check Game Network is Not Connect ......2")
--            SceneManager:enterScene(loginScene,"loginScene")
--            if lastMsg ~= nil and lastMsg:getCmd() == 440 then
--                UIManager:showTipsFrame("你的账号已在别处登陆")
--            else
----                UIManager:showTipsFrame("网络已断开")
--                TipsFrame:create("网络已断开")
--            end
--
--            mc.NetMannager:getInstance():realEndConnect()
--
--
--
--            return
--        end
--
--        NetManagerLua.instance():dealAllMsg()
--    end
--
--    self._msgTimerID = cc.Director:getInstance():getScheduler():scheduleScriptFunc(updateMsgTimer, 0.05, false)

    -- msg
    _G.NetManagerLuaInst:registerListenner(4012,self)
    _G.NetManagerLuaInst:registerListenner(4075,self)
    _G.NetManagerLuaInst:registerListenner(4090,self)
    _G.NetManagerLuaInst:registerListenner(4105,self)
    _G.NetManagerLuaInst:registerListenner(4115,self)
    _G.NetManagerLuaInst:registerListenner(9512,self)
    _G.NetManagerLuaInst:registerListenner(4048,self)
	_G.NetManagerLuaInst:registerListenner(900,self)
	_G.NetManagerLuaInst:registerListenner(11650,self)
	_G.NetManagerLuaInst:registerListenner(9513,self)
	_G.NetManagerLuaInst:registerListenner(9514,self)
	_G.NetManagerLuaInst:registerListenner(12112,self)
    --

    local gameResultTimeCunt = -1
    local function tick(dt)

        if gameResultTimeCunt >= 0 then
            gameResultTimeCunt = gameResultTimeCunt + dt
        end


        if self:isWantToReturnCity() then
            if self.schedulerID then
                cc.Director:getInstance():getScheduler():unscheduleScriptEntry(self.schedulerID)
            end
            self.schedulerID = nil

            self:WhenGameEnd()
--            local mainScene = MainScene:create()
--            SceneManager:enterScene(mainScene, "mainScene")
            require("game.loading.PreLoadScene")
            local preLoadScene = PreLoadScene.create()
            preLoadScene:initPreLoad("MainScene","dxyCocosStudio/csd/scene/MainScene_new.csb")
            SceneManager:enterScene(preLoadScene, "PreLoadScene")
            
            if true then return end
        end

        if SceneManager._GameEndMark ~= nil then
            SceneManager._GameEndMark = nil
            print(self._gameSceneId)
            local sType = self:getGameSceneType()
            print("通关类型:"..sType)
            if sType == DefineConst.CONST_COPY_TYPE_NORMAL or sType == DefineConst.CONST_COPY_TYPE_ELITE or sType == DefineConst.CONST_COPY_TYPE_BOSS then  --普通副本
                local start = self:getStart()
                if (self._gameSceneId .. "") == "10101" or (self._gameSceneId .. "") == "10201" or (self._gameSceneId .. "") == "10302" or (self._gameSceneId .. "") == "20302" then
                    start = 3
                end
                local msg = mc.packetData:createWritePacket(4010); --编写发送包
                msg:writeUint(self._gameSceneId)
                msg:writeByte(start)
                mc.NetMannager:getInstance():sendMsg(msg); --发送 包
            elseif sType == DefineConst.CONST_COPY_TYPE_MONEY then  --财神副本
                local msg = mc.packetData:createWritePacket(4070); --编写发送包
                print("所花费时间:"..SceneManager._ClearTimes)
                msg:writeUint(SceneManager._ClearTimes)
                mc.NetMannager:getInstance():sendMsg(msg); --发送 包
            elseif sType == DefineConst.CONST_COPY_TYPE_TRAIN_EXP or sType == DefineConst.CONST_COPY_TYPE_TRAIN_FLOWER or sType == DefineConst.CONST_COPY_TYPE_TRAIN_RENOWN then
                local msg = mc.packetData:createWritePacket(4110); --编写发送包
                msg:writeByte(sType)
                mc.NetMannager:getInstance():sendMsg(msg); --发送 包
            elseif sType == DefineConst.CONST_COPY_TYPE_WAR then    --竞技场
                local msg = mc.packetData:createWritePacket(9510); --编写发送包
                msg:writeByte(1)
                mc.NetMannager:getInstance():sendMsg(msg); --发送 包
			elseif sType == 14 then    --pk
                local msg = mc.packetData:createWritePacket(9511); --编写发送包
                msg:writeByte(1)
                mc.NetMannager:getInstance():sendMsg(msg); --发送 包
            elseif sType == DefineConst.CONST_COPY_TYPE_WORLD_BOSS then
                self:openBattleOverOp()
            elseif sType == DefineConst.CONST_COPY_TYPE_MAGICSOUL then  --器灵副本
                local msg = mc.packetData:createWritePacket(4060); --编写发送包
                mc.NetMannager:getInstance():sendMsg(msg); --发送 包
            end
            
            if self.schedulerID then
                cc.Director:getInstance():getScheduler():unscheduleScriptEntry(self.schedulerID)
            end
            self.schedulerID = nil

            if true then return end

            gameResultTimeCunt = 0

            self._csbResultNode = cc.CSLoader:getInstance():createNodeWithFlatBuffersFile("GameScene/GameResultWin.csb")
            self:addChild(self._csbResultNode)
            self._csbResultNode:setPosition(self.origin.x + self.visibleSize.width/2,self.origin.y + self.visibleSize.height/2)

            --界面效果

            -- 闪烁
            local continueTxt = self._csbResultNode:getChildByName("continueTxt")

            local blinkAction = cc.Blink:create(1.5,1)
            local repeatAction = cc.RepeatForever:create(blinkAction)
            continueTxt:runAction(repeatAction)
            -- 星星
            local lightStar1 = self._csbResultNode:getChildByName("lightStar1")
            local lightStar2 = self._csbResultNode:getChildByName("lightStar2")
            local lightStar3 = self._csbResultNode:getChildByName("lightStar3")
            local starTable = {lightStar1,lightStar2,lightStar3}

            starTable[1]:setVisible(false)
            starTable[2]:setVisible(false)
            starTable[3]:setVisible(false)

            local starNum = 3

            for i=1,starNum do
                starTable[i]:setVisible(true)
                starTable[i]:setScale(0.01)
                --local action = cc.Sequence:create(cc.DelayTime:create(0.5 * (i-1) + 0.2),cc.EaseBackOut:create(cc.ScaleTo:create(1.2,1)))
                local action = cc.Sequence:create(cc.DelayTime:create(0.25 * (i-1) + 0.1),cc.EaseBackOut:create(cc.ScaleTo:create(0.6,1)))
                starTable[i]:runAction(action)
            end

            -- 数字
            require "game/utils/NumberChangeByUpdate.lua"
            local rewardText = self._csbResultNode:getChildByName("rewardTxt")
            local expIcon = rewardText:getChildByName("expStar")
            local expValue = expIcon:getChildByName("expValue")
            local coperIcon = rewardText:getChildByName("coper")
            local coperValue = coperIcon:getChildByName("coperValue")
            math.randomseed(os.clock())
            local v1 = math.random(2000,3999)
            local v2 = math.random(5000,7999)

            --            expValue:setString(""..v1)
            --            coperValue:setString(""..v2)
            local expNode = NumberChangeByUpdate:create()
            expNode:initByPam(0,v1,expValue,1.25,0.05)
            self:addChild(expNode)

            local coperNode = NumberChangeByUpdate:create()
            coperNode:initByPam(0,v2,coperValue,1.25,0.05)
            self:addChild(coperNode)

            -- 拦截
            local function onTouchBegan(touch, event)

                return true
            end

            local function onTouchMoved(touch, event)

            end


            local function onTouchEnded(touch, event)
                --self:WhenGameEnd()
                --local mainScene = MainScene:create()
                --SceneManager:enterScene(mainScene, "mainScene")
                --if true then return end

                if gameResultTimeCunt < 2 then return end -- 1.5

                self:openBattleOverOp()

                self._csbResultNode:removeFromParent()

            end

            local listener = cc.EventListenerTouchOneByOne:create()
            listener:registerScriptHandler(onTouchBegan,cc.Handler.EVENT_TOUCH_BEGAN )
            listener:registerScriptHandler(onTouchMoved,cc.Handler.EVENT_TOUCH_MOVED )
            listener:registerScriptHandler(onTouchEnded,cc.Handler.EVENT_TOUCH_ENDED )
            local eventDispatcher = self:getEventDispatcher()
            eventDispatcher:addEventListenerWithSceneGraphPriority(listener, self._csbResultNode)
            listener:setSwallowTouches(true)


            --cc.Director:getInstance():getScheduler():unscheduleScriptEntry(self.schedulerID)
        end

    end

    self.schedulerID = cc.Director:getInstance():getScheduler():scheduleScriptFunc(tick, 0, false)
end

function GameScene:initEvent()
    dxyDispatcher_addEventListener("GameScene_TeamCopyState",self,self.updatTeamCopyState)
end

function GameScene:removeEvent()
    dxyDispatcher_removeEventListener("GameScene_TeamCopyState",self,self.updatTeamCopyState)
end

function GameScene:getStart()
    local start = 1
    if self._startId ~= nil then
        local startList = SceneConfigProvider:getStartDataById(self._startId)
        for i=1, #startList do
            local data = startList[i]
            if data.Type == 1 then
                --default 1
            end
            if data.Type == 3 then
                if SceneManager._CopyTimesIn == true then
                    start=start+1
                    print("Lua SceneManager._CopyTimesIn + 1 = "..start)
                end
            end
            if data.Type == 2 then
                if SceneManager._HaveUseHp == false then
                    start=start+1
                    print("Lua SceneManager._HaveUseHp + 1 = "..start)
                end
            end
            if data.Type == 4 then
                if SceneManager._HaveHalfMaxHp == true then
                    start=start+1
                    print("Lua SceneManager._HaveHalfMaxHp + 1 = "..start)
                end
            end
        end
    end

    self._startId = nil
    SceneManager._CopyTimesIn = false
    SceneManager._HaveUseHp = false
    SceneManager._HaveHalfMaxHp = false
    return start
end

function GameScene:playBgMusic()
    local bgMusicPath = cc.FileUtils:getInstance():fullPathForFilename("background.mp3")
    cc.SimpleAudioEngine:getInstance():playMusic(bgMusicPath, true)
    local effectPath = cc.FileUtils:getInstance():fullPathForFilename("effect1.wav")
    cc.SimpleAudioEngine:getInstance():preloadEffect(effectPath)
end

function GameScene:initUI()
    self._csbGameSceneNode = cc.CSLoader:getInstance():createNodeWithFlatBuffersFile("GameScene.csb")

    self:addChild(self._csbGameSceneNode)
    local testBtn = self._csbGameSceneNode:getChildByName("testBtn")

    local function testBtnTouchCallback(sender,eventType)
        print(sender:getTag())
        if eventType == ccui.TouchEventType.began then
            print("按下按钮")
        elseif eventType == ccui.TouchEventType.moved then
            print("按下按钮移动")
        elseif eventType == ccui.TouchEventType.ended then
            print("放开按钮")
        elseif eventType == ccui.TouchEventType.canceled then
            print("取消点击")
        end
    end

    testBtn:addTouchEventListener(testBtnTouchCallback)
    

end

--function GameScene:stopGuideTimer()
--    if self._myGuideTimer then
--        self._myGuideTimer:stop()
--        self._myGuideTimer = nil
--    end
--end

function GameScene:WhenClose()
    if zzc.MarqueeController._myTimer then
       zzc.MarqueeController:closeTimer()
    end
    
    if self._groupTimer then
    	self._groupTimer:stop()
    	self._groupTimer = nil
    end
    
    if self._myGuideTimer then
        self._myGuideTimer:stop()
        self._myGuideTimer = nil
    end

    if  self._msgTimerID then
        cc.Director:getInstance():getScheduler():unscheduleScriptEntry(self._msgTimerID)
    end
    if self._resultByCSchedulerID then
        cc.Director:getInstance():getScheduler():unscheduleScriptEntry(self._resultByCSchedulerID)
    end
    if self._resultSchedulerID then
        cc.Director:getInstance():getScheduler():unscheduleScriptEntry(self._resultSchedulerID)
    end
    if self.schedulerID then
        cc.Director:getInstance():getScheduler():unscheduleScriptEntry(self.schedulerID)
    end
    _G.NetManagerLuaInst:unregisterListenner(400,self)
    _G.NetManagerLuaInst:unregisterListenner(440,self)
    _G.NetManagerLuaInst:unregisterListenner(4012,self)
    _G.NetManagerLuaInst:unregisterListenner(4075,self)
    _G.NetManagerLuaInst:unregisterListenner(4090,self)
    _G.NetManagerLuaInst:unregisterListenner(4105,self)
    _G.NetManagerLuaInst:unregisterListenner(4115,self)
    _G.NetManagerLuaInst:unregisterListenner(9512,self)
    _G.NetManagerLuaInst:unregisterListenner(4048,self)
	_G.NetManagerLuaInst:unregisterListenner(900,self)
    _G.NetManagerLuaInst:unregisterListenner(11650,self)
	_G.NetManagerLuaInst:unregisterListenner(9513,self)
	_G.NetManagerLuaInst:unregisterListenner(9514,self)
	_G.NetManagerLuaInst:unregisterListenner(12112,self)
    --mc.ResMgr:getInstance():releasedALLRes()
	self:WhenGameEnd()
end

function GameScene:dealMsg(msg)
    if msg:getCmd() == 400 then
        local code = msg:readUshort()
        print("Scene 网络消息错误，错误代码  "..code)
        if code == 290 then TipsFrame:create("code 290") end
    elseif msg:getCmd() == 440 then

        --local loginScene = LoginInterface:create()
        --loginScene:forceDisConnect()
        --UIManager:showTipsFrame("你的帐户在别处登陆了")
        --SceneManager:enterScene(loginScene,"loginScene")

        return true

    elseif msg:getCmd() == 4002 then

    elseif msg:getCmd() == 4012 then
        self:showGameResult(msg)
    elseif msg:getCmd() == 4075 then
        self:showCornucopiaResult(msg)
    elseif msg:getCmd() == 4090 then
		--zzm.GuideModel._isFightGuideOver = true
        self:showGameLoseLayer(msg)
    elseif msg:getCmd() == 4105 then
		zzm.GuideModel._isFightGuideOver = true
        self:showGeneralResult(msg)
    elseif msg:getCmd() == 4115 then
        self:showTowerResult(msg)
    elseif msg:getCmd() == 9512 then
        self:showPkResult(msg)
    elseif msg:getCmd() == 4048 then
        self:showSpiritCopyResult(msg)
	elseif msg:getCmd() == 900 then
		local msgtype = msg:readUbyte()
		local msgValue = msg:readUbyte()
		if msgtype == DefineConst.CONST_STATE_TYPE_WORLD_BOSS and msgValue == DefineConst.CONST_STATE_VALUE_WORLD_BOSS_END then
			self:setWorldBossEnd()
		end
	elseif msg:getCmd() == 11650 then
	    self:showGroupBackLayer(msg)
	elseif msg:getCmd() == 9513 then
--        self._csbResultNode = cc.CSLoader:getInstance():createNodeWithFlatBuffersFile("dxyCocosStudio/csd/ui/pk/ltResultLayer.csb")
--        self:addChild(self._csbResultNode)
--        self._csbResultNode:setPosition(self.origin.x + self.visibleSize.width/2,self.origin.y + self.visibleSize.height/2)
--        
--        local txtTitle =  self._csbResultNode:getChildByName("Text")
--        local txtGold =  self._csbResultNode:getChildByName("txtGold")
--        local txtRenown = self._csbResultNode:getChildByName("txtRenown")
	
--	    local result = msg:readUbyte()
--	    local gold = msg:readUint()
--	    local renown = msg:readUint()
	    
        self:dealWithArenaEnd(msg)
	    
--	    if result == 1 then --win
--			txtTitle:setString("战斗胜利")
--	    elseif result == 2 then --lose
--			txtTitle:setString("战斗失败")
--	    end
--		
--		txtGold:setString(gold)
--        txtRenown:setString(renown)
--	
--		local btn_confirm = self._csbResultNode:getChildByName("confirmBtn")
--		btn_confirm:addTouchEventListener(function(target,type)
--			if type == 2 then
--				SoundsFunc_playSounds(SoundsType.UNIVERSAL_BTN,false)
--				if self._onlyOneClickFlag then
--					return
--				end
--				self._onlyOneClickFlag = true
--				self:WhenGameEnd()
--                require("game.loading.PreLoadScene")
--                local preLoadScene = PreLoadScene.create()
--                preLoadScene:initPreLoad("MainScene","dxyCocosStudio/csd/scene/MainScene_new.csb",function()
--                    local layer = zzc.PkController:showLayer()
--                    layer:scrollToPage(1)
--                end)
--                SceneManager:enterScene(preLoadScene, "PreLoadScene")
--			end
--		end)
		
	elseif msg:getCmd() == 9514 then
--        local result = msg:readUbyte()
--        local gold = msg:readUint()
--        local renown = msg:readUint()
        self:dealWithArenaEnd(msg)
        cn:TipsSchedule("对方已退出战斗")
    elseif msg:getCmd() == 12112 then
        local timeCnt = 0
        local function tick(dt)
            timeCnt = timeCnt + dt
            if timeCnt >= 3 then
                SwallowAllTouches:close()
            	self.m_outTimer:stop()
                zzc.StepTwoController:register_inScene()
                require("game.loading.TilemappreloadScene")
                local scene = TilemappreloadScene:create()
                scene:initPreLoad("dxyCocosStudio/csd/ui/immortalfield/ImmortalMainLyer.csb")
                SceneManager:enterScene(scene, "TilemappreloadScene")
            end
        end
    
        SwallowAllTouches:show()
        
        local MyTimer = require("game.utils.MyTimer")
        self.m_outTimer = self.m_outTimer or MyTimer.new()
        self.m_outTimer:start(0.05,tick)
    end
	
end

function GameScene:dealWithArenaEnd(msg)
    self._csbResultNode = cc.CSLoader:getInstance():createNodeWithFlatBuffersFile("dxyCocosStudio/csd/ui/pk/ltResultLayer.csb")
    self:addChild(self._csbResultNode)
    self._csbResultNode:setPosition(self.origin.x + self.visibleSize.width/2,self.origin.y + self.visibleSize.height/2)

    local txtTitle =  self._csbResultNode:getChildByName("Text")
    local txtGold =  self._csbResultNode:getChildByName("txtGold")
    local txtRenown = self._csbResultNode:getChildByName("txtRenown")

    local result = msg:readUbyte()
    local gold = msg:readUint()
    local renown = msg:readUint()

    if result == 1 then --win
        txtTitle:setString("战斗胜利")
    elseif result == 2 then --lose
        txtTitle:setString("战斗失败")
    end

    txtGold:setString(gold)
    txtRenown:setString(renown)

    local btn_confirm = self._csbResultNode:getChildByName("confirmBtn")
    btn_confirm:addTouchEventListener(function(target,type)
        if type == 2 then
            SoundsFunc_playSounds(SoundsType.UNIVERSAL_BTN,false)
            if self._onlyOneClickFlag then
                return
            end
            self._onlyOneClickFlag = true
            self:WhenGameEnd()
            require("game.loading.PreLoadScene")
            local preLoadScene = PreLoadScene.create()
            preLoadScene:initPreLoad("MainScene","dxyCocosStudio/csd/scene/MainScene_new.csb",function()
                local layer = zzc.PkController:showLayer()
                layer:scrollToPage(1)
            end)
            SceneManager:enterScene(preLoadScene, "PreLoadScene")
        end
    end) 
end

--器灵副本通关界面
function GameScene:showSpiritCopyResult(msg)
	local data = {}
	data.idx = msg:readUbyte()
	data.copy_id = msg:readUint()
	data.state = msg:readUbyte()
	
	zzm.SpiritModel:updateCopy(data)
	
    zzm.TalkingDataModel:onCompleted("ql_"..zzm.SpiritModel.curSpiritLvType.."_"..zzm.SpiritModel.curSpiritDifficulty)
	
    print("通关器灵id:"..data.idx.."副本:"..data.copy_id.." 状态:"..data.state)
    
    self.returnCityOptionLayer = cc.CSLoader:getInstance():createNodeWithFlatBuffersFile("GameScene/ReturnCityOptionLayer.csb")
    self:addChild(self.returnCityOptionLayer)
    local node = self.returnCityOptionLayer:getChildByName("BO_bg")

    local posX = self.origin.x + self.visibleSize.width
    local posY = self.origin.y + self.visibleSize.height
    node:setPosition(posX, posY)
    
--    local function btnCallBack(target,type)
--    	if type == 2 then
--            SoundsFunc_playSounds(SoundsType.CLOSE_PAGE)
--            UIManager:closeUI("CustomTips")
--            if self._onlyOneClickFlag then
--                return
--            end
--            self._onlyOneClickFlag = true
--            self:WhenGameEnd()
----            local mainScene = MainScene:create()
----            SceneManager:enterScene(mainScene, "mainScene")
--            require("game.loading.PreLoadScene")
--            local preLoadScene = PreLoadScene.create()
--            preLoadScene:initPreLoad("MainScene","dxyCocosStudio/csd/scene/MainScene_new.csb")
--            SceneManager:enterScene(preLoadScene, "PreLoadScene")
--            
--            zzc.SpiritController:showLayer()
--            zzc.SpiritController:OpenCopyLayer()
--    	end
--    end

    local returnCityBtn = node:getChildByName("returnCityBtn")
    local function returnCityBtnTouchCallback(sender,eventType)
        if eventType == ccui.TouchEventType.began then
        elseif eventType == ccui.TouchEventType.moved then
        elseif eventType == ccui.TouchEventType.ended then
            
--            if not zzm.SpiritModel:isClear() then
--                SoundsFunc_playSounds(SoundsType.CLOSE_PAGE,false)
--                local layer = CustomTips:create()
--                layer:update("是否放弃本轮?",btnCallBack)
--                return
--            end
            
            if self._onlyOneClickFlag then
                SoundsFunc_playSounds(SoundsType.CLOSE_PAGE,false)
                return
            end
            SoundsFunc_playSounds(SoundsType.CLOSE_PAGE,false)
            self._onlyOneClickFlag = true
            self:WhenGameEnd()

--            local mainScene = MainScene:create()
--            SceneManager:enterScene(mainScene, "mainScene")
            require("game.loading.PreLoadScene")
            local preLoadScene = PreLoadScene.create()
            preLoadScene:initPreLoad("MainScene","dxyCocosStudio/csd/scene/MainScene_new.csb",function()
                zzc.SpiritController:showLayer()
                zzc.SpiritController:OpenCopyLayer()
            end)
            SceneManager:enterScene(preLoadScene, "PreLoadScene")
            
--            zzc.SpiritController:showLayer()
--            zzc.SpiritController:OpenCopyLayer()
        elseif eventType == ccui.TouchEventType.canceled then
        end
    end
    returnCityBtn:addTouchEventListener(returnCityBtnTouchCallback)
    
    local selectCopyBtn = node:getChildByName("SelectCopy")
    local function selectCopyBtnTouchCallback(sender,eventType)
        if eventType == ccui.TouchEventType.began then
        elseif eventType == ccui.TouchEventType.moved then
        elseif eventType == ccui.TouchEventType.ended then
            if zzm.SpiritModel:isClear() then
                SoundsFunc_playSounds(SoundsType.UNIVERSAL_BTN,false)
                dxyFloatMsg:show("所有房间已探索完毕")
                return
            end
            if self._onlyOneClickFlag then
                return
            end
            SoundsFunc_playSounds(SoundsType.CLOSE_PAGE,false)
            self._onlyOneClickFlag = true
            self:WhenGameEnd()
--            local mainScene = MainScene:create()
--            SceneManager:enterScene(mainScene, "mainScene")
            require("game.loading.PreLoadScene")
            local preLoadScene = PreLoadScene.create()
            preLoadScene:initPreLoad("MainScene","dxyCocosStudio/csd/scene/MainScene_new.csb",function()
                zzc.SpiritController:showLayer()
                zzc.SpiritController:secondOpenCopyLayer()
            end)
            SceneManager:enterScene(preLoadScene, "PreLoadScene")
            
--            zzc.SpiritController:showLayer()
--            zzc.SpiritController:secondOpenCopyLayer()
        elseif eventType == ccui.TouchEventType.canceled then
        end
    end
    selectCopyBtn:addTouchEventListener(selectCopyBtnTouchCallback)

    local backBattleBtn = node:getChildByName("BackBattle")
	backBattleBtn:setVisible(false)
end

--竞技场结算界面
function GameScene:showPkResult(msg)
	local result = msg:readUbyte()
	local ranking = msg:readUint()
	local gold = msg:readUint()
	
	print("获得金钱:"..gold)
		
    self._csbResultNode = cc.CSLoader:getInstance():createNodeWithFlatBuffersFile("dxyCocosStudio/csd/ui/pk/pkResultLayer.csb")
    self:addChild(self._csbResultNode)
    self._csbResultNode:setPosition(self.origin.x + self.visibleSize.width/2,self.origin.y + self.visibleSize.height/2)
    
    local btn_confirm = self._csbResultNode:getChildByName("confirmBtn")
    btn_confirm:addTouchEventListener(function(target,type)
        if type == 2 then
            SoundsFunc_playSounds(SoundsType.UNIVERSAL_BTN,false)
            if self._onlyOneClickFlag then
                return
            end
            self._onlyOneClickFlag = true
            self:WhenGameEnd()

--            local mainScene = MainScene:create()
--            SceneManager:enterScene(mainScene, "mainScene")
            require("game.loading.PreLoadScene")
            local preLoadScene = PreLoadScene.create()
            preLoadScene:initPreLoad("MainScene","dxyCocosStudio/csd/scene/MainScene_new.csb",function()
                zzc.PkController:showLayer()
            end)
            SceneManager:enterScene(preLoadScene, "PreLoadScene")
            
--            zzc.PkController:showLayer()
        end
    end)
    
    local txt_result = self._csbResultNode:getChildByName("Text")
    if result == DefineConst.CONST_COPY_RESULT_WIN then
        txt_result:setString("战斗胜利,获得铜钱"..gold..",排名升至"..ranking)       
    elseif result == DefineConst.CONST_COPY_RESULT_FAIL then
        txt_result:setString("战斗失败,获得铜钱"..gold..",排名不变")
    end
    
    -- 拦截
    local function onTouchBegan(touch, event)

        return true
    end

    local function onTouchMoved(touch, event)

    end


    local function onTouchEnded(touch, event)

    end

    local listener = cc.EventListenerTouchOneByOne:create()
    listener:registerScriptHandler(onTouchBegan,cc.Handler.EVENT_TOUCH_BEGAN )
    listener:registerScriptHandler(onTouchMoved,cc.Handler.EVENT_TOUCH_MOVED )
    listener:registerScriptHandler(onTouchEnded,cc.Handler.EVENT_TOUCH_ENDED )
    local eventDispatcher = self:getEventDispatcher()
    eventDispatcher:addEventListenerWithSceneGraphPriority(listener, self._csbResultNode)
    listener:setSwallowTouches(true)
end

--试练塔结算界面
function GameScene:showTowerResult(msg)
    zzm.TowerModel:resetClickedCount()
    
    local count = msg:readByte()
    print("可翻牌次数:"..count)
    zzm.TowerModel.clickCount = count
    
	local len = msg:readByte()
	print("奖励类型个数:"..len)
	
	local award = 0
	local copyType = 0
	local awardType = 0
    for index=1, len do
		local type = msg:readByte()
		print("奖励类型为:"..type)
		if type == DefineConst.CONST_AWARD_EXP then
		    copyType = DefineConst.CONST_COPY_TYPE_TRAIN_EXP
            awardType = DefineConst.CONST_VIP_PRIVILEGE_TYPE_GROUNDS_EXP_TURNOVER
            zzm.TalkingDataModel:onCompleted(TowerConfig:getDataByType(copyType).ScenesId.."_"..zzm.TowerModel.expId)
		elseif type == DefineConst.CONST_AWARD_FLOWER then
            copyType = DefineConst.CONST_COPY_TYPE_TRAIN_FLOWER
            awardType = DefineConst.CONST_VIP_PRIVILEGE_TYPE_GROUNDS_FLOWER_TURNOVER
            zzm.TalkingDataModel:onCompleted(TowerConfig:getDataByType(copyType).ScenesId.."_"..zzm.TowerModel.flowerId)
		elseif type == DefineConst.CONST_AWARD_RENOWN then
            copyType = DefineConst.CONST_COPY_TYPE_TRAIN_RENOWN
            awardType = DefineConst.CONST_VIP_PRIVILEGE_TYPE_GROUNDS_RENOWN_TURNOVER
            zzm.TalkingDataModel:onCompleted(TowerConfig:getDataByType(copyType).ScenesId.."_"..zzm.TowerModel.renownId)
		end
		print("试练塔类型为:"..copyType)
		award = msg:readInt()
		print("通关获得奖励:"..award)
	end
	
    local freeCard = msg:readByte()
    for var=1, freeCard do
        local id = msg:readByte()
        local value = msg:readInt()
        print("id:"..id.."value:"..value)
        local data = {}
        data.id = id
        data.value = value
        zzm.TowerModel.card_list[id] = data
    end
    local chargeCard = msg:readByte()
    for var=1, chargeCard do
        local id = msg:readByte()
        local value = msg:readInt()
        print("id:"..id.."value:"..value)
        local data = {}
        data.id = id
        data.value = value
        zzm.TowerModel.card_list[id] = data
    end
    
    self._csbResultNode = cc.CSLoader:getInstance():createNodeWithFlatBuffersFile("dxyCocosStudio/csd/ui/cornucopia/cornucopiaWin.csb")
    self:addChild(self._csbResultNode)
    self._csbResultNode:setPosition(self.origin.x + self.visibleSize.width/2,self.origin.y + self.visibleSize.height/2)
    
    local awardNode = self._csbResultNode:getChildByName("awardNode")
    awardNode:setVisible(true)
    local icon = awardNode:getChildByName("Icon")
    local txt_award = awardNode:getChildByName("awardTxt")
    
    txt_award:setString(award)
    
    local path = "dxyCocosStudio/png/tower/"
    if copyType == DefineConst.CONST_COPY_TYPE_TRAIN_EXP then
        icon:setTexture(path.."expS_light.png")
    elseif copyType == DefineConst.CONST_COPY_TYPE_TRAIN_FLOWER then
        icon:setTexture(path.."flowerS_light.png")
    elseif copyType == DefineConst.CONST_COPY_TYPE_TRAIN_RENOWN then
        icon:setTexture(path.."prestigeS_light.png")
    end

    self.list_item = {}

    local item = nil
    local node = nil
    require("game.tower.view.TowerWinItem")
    for index=1, 8 do
        node = self._csbResultNode:getChildByName("Node_"..index)
        item = TowerWinItem:create()
        item:setParent(self,index,copyType,awardType)
        item:update()
        node:addChild(item)
        self.list_item[index] = item
        if index > 4 then
            item:setTouchEnabled(false)
        end
    end
    
    self.txt_time = self._csbResultNode:getChildByName("bg"):getChildByName("timeTxt")
    math.randomseed(os.time())
    self._myTimer = self._myTimer or require("game.utils.MyTimer").new()
    local time = tonumber(MoneySceneConfig:getBaseValueByKey("CardTime"))
    self.txt_time:setString(time)
    local function tick()
        if time > 0 then
            time = time - 1
            self.txt_time:setString(time)
        else
            self.txt_time:setVisible(false)
            self._myTimer:stop()
            
            for index=1, 8 do
                self.list_item[index].timeOut = true
                self.list_item[index]:setTouchEnabled(false)
            end

            local num = math.random(1,freeCard)

            self.list_item[num]:turnCard()
            if self.list_item[num].idx > 4 then
                zzm.TowerModel.clickedCount = zzm.TowerModel.clickedCount + 1
                for index=5, 8 do
                    self.list_item[index]:update()
                end
            end
            table.insert(zzm.TowerModel.clicked_card,zzm.TowerModel.card_list[self.list_item[num].idx].id)
            
            self.list_item[num]:runTimeLine()
        end
    end
    self._myTimer:start(1.0, tick)

    self.cornucopiaBtn = self._csbResultNode:getChildByName("confirmBtn")
    self.cornucopiaBtn:setTouchEnabled(false)
    self.cornucopiaBtn:addTouchEventListener(function(target,type)
        if type == 2 then
            if self._myTimer then
                self._myTimer:stop()
            end
            self.cornucopiaBtn:setTouchEnabled(false)
            local clickedCount = #zzm.TowerModel.clicked_card
            print("翻了"..clickedCount.."次牌")
            for key, var in pairs(zzm.TowerModel.clicked_card) do
                print("发送ID:"..var)
            end
            local msg = mc.packetData:createWritePacket(4080); --编写发送包
            msg:writeByte(clickedCount)
            for key, var in pairs(zzm.TowerModel.clicked_card) do
                msg:writeByte(var)
            end
            mc.NetMannager:getInstance():sendMsg(msg); --发送 包

            if self._onlyOneClickFlag then
                return
            end
            self._onlyOneClickFlag = true
            self:WhenGameEnd()

--            local mainScene = MainScene:create()
--            SceneManager:enterScene(mainScene, "mainScene")
            require("game.loading.PreLoadScene")
            local preLoadScene = PreLoadScene.create()
            preLoadScene:initPreLoad("MainScene","dxyCocosStudio/csd/scene/MainScene_new.csb",function()
                zzc.TowerController:showLayer()
            end)
            SceneManager:enterScene(preLoadScene, "PreLoadScene")
            
--            zzc.TowerController:showLayer()
        end
    end)
    
    -- 拦截
    local function onTouchBegan(touch, event)

        return true
    end

    local function onTouchMoved(touch, event)

    end


    local function onTouchEnded(touch, event)

    end

    local listener = cc.EventListenerTouchOneByOne:create()
    listener:registerScriptHandler(onTouchBegan,cc.Handler.EVENT_TOUCH_BEGAN )
    listener:registerScriptHandler(onTouchMoved,cc.Handler.EVENT_TOUCH_MOVED )
    listener:registerScriptHandler(onTouchEnded,cc.Handler.EVENT_TOUCH_ENDED )
    local eventDispatcher = self:getEventDispatcher()
    eventDispatcher:addEventListenerWithSceneGraphPriority(listener, self._csbResultNode)
    listener:setSwallowTouches(true)
end

--神将胜利界面
function GameScene:showGeneralResult(msg)

    local len = msg:readByte()
    print("奖励类型个数:"..len)
    local chipId = 0
    local soul = 0
    for index=1, len do
    	local type = msg:readByte()
    	if type == DefineConst.CONST_AWARD_SOUL then
    	   soul = msg:readInt()
    	elseif type == DefineConst.CONST_AWARD_CHIP then
           chipId = msg:readInt()
    	end
    end
    print("获得斗魂数:"..soul)
    print("获得神将碎片ID："..chipId)

    self._csbResultNode = cc.CSLoader:getInstance():createNodeWithFlatBuffersFile("GameScene/GeneralResultWin.csb")
    self:addChild(self._csbResultNode)
    self._csbResultNode:setPosition(self.origin.x + self.visibleSize.width/2,self.origin.y + self.visibleSize.height/2)
    
    local txt_general = self._csbResultNode:getChildByName("rewardNode"):getChildByName("generalTxt")
    local headFrame = self._csbResultNode:getChildByName("rewardNode"):getChildByName("headFrame")
    local generalHead = self._csbResultNode:getChildByName("rewardNode"):getChildByName("generalHead")
    local txt_soul = self._csbResultNode:getChildByName("rewardNode"):getChildByName("soulTxt")
    local txt_generalName = generalHead:getChildByName("generalName")
    
    local chipData = GoodsConfigProvider:findGoodsById(chipId)
    txt_generalName:setString(chipData.Name)
    txt_generalName:setColor(Quality_Color[chipData.Quality])
    
    txt_general:setString(1)
    txt_soul:setString(soul)
    
    local colour = GodGeneralConfig:getMsgColour(chipId,2).IconLittle
    headFrame:setTexture("res/GodGeneralsIcon/"..colour)

    
    local path = "res/GodGeneralsIcon/"..GoodsConfigProvider:findGoodsById(chipId).Icon..".png"
    generalHead:setTexture(path)
    
    self._generalNode = self._csbResultNode:getChildByName("generalNode")
    local Ossature = GodGeneralConfig:getGeneralModel(chipId,2)
    local action = mc.SkeletonDataCash:getInstance():createWithCashName(Ossature)
    action:setAnimation(1,"ready", true)
    action:setAnchorPoint(0.5,0)
    action:setPosition(0,0)
    self._generalNode:addChild(action)
    
    local btn_quit = self._csbResultNode:getChildByName("quitBtn")
    btn_quit:addTouchEventListener(function(target,type)
        if type == 2 then
            if self._onlyOneClickFlag then
                return
            end
            self._onlyOneClickFlag = true
            self._generalNode:removeFromParentAndCleanup()
            self:WhenGameEnd()

--            local mainScene = MainScene:create()
--            SceneManager:enterScene(mainScene, "mainScene")
            require("game.loading.PreLoadScene")
            local preLoadScene = PreLoadScene.create()
            preLoadScene:initPreLoad("MainScene","dxyCocosStudio/csd/scene/MainScene_new.csb",function()
                local layer = zzc.GeneralController:showLayer()
                layer:scrollToPage(1)
            end)
            SceneManager:enterScene(preLoadScene, "PreLoadScene")
            
--            local layer = zzc.GeneralController:showLayer()
--            layer:scrollToPage(1)
        end
    end)
    
--    local btn_again = self._csbResultNode:getChildByName("againBtn")
--    btn_again:addTouchEventListener(function(target,type)
--        if type == 2 then
--            self._generalNode:removeFromParentAndCleanup()
--            self:WhenGameEnd()
--            zzc.LoadingController:setCopyData({copyType = DefineConst.CONST_COPY_TYPE_GODWILL,chapterID = 1, startTalkID = 0, endTalkID = 0, sceneID = 10106, param1 = 0})
--            zzc.LoadingController:enterScene(SceneType.LoadingScene)
--            zzc.LoadingController:setDelegate2(
--                {target = self, 
--                    func = function (data)
--                        zzc.LoadingController:enterScene(SceneType.CopyScene)
--                    end,
--                    data = self.m_data})
--        end
--    end)

end

--失败界面
function GameScene:showGameLoseLayer(msg)
    self._csbResultNode = cc.CSLoader:getInstance():createNodeWithFlatBuffersFile("GameScene/GameResultLose.csb")
    self:addChild(self._csbResultNode)
    self._csbResultNode:setPosition(self.origin.x + self.visibleSize.width/2,self.origin.y + self.visibleSize.height/2)

    local btn_backCity = self._csbResultNode:getChildByName("backCityBtn")
    btn_backCity:addTouchEventListener(function(target,type)
        if type == 2 then
            if self._onlyOneClickFlag then
                return
            end
            self._onlyOneClickFlag = true
            self:WhenGameEnd()

--            local mainScene = MainScene:create()
--            SceneManager:enterScene(mainScene, "mainScene")
            require("game.loading.PreLoadScene")
            local preLoadScene = PreLoadScene.create()
            preLoadScene:initPreLoad("MainScene","dxyCocosStudio/csd/scene/MainScene_new.csb")
            SceneManager:enterScene(preLoadScene, "PreLoadScene")
        end
    end)
end

--财神宝库副本
function GameScene:showCornucopiaResult(msg)
    zzm.CornucopiaModel:resetClickedCount()
    
    zzm.TalkingDataModel:onCompleted(MoneySceneConfig:getBaseValueByKey("SceneId"))

    local count = msg:readByte()
    local freeCard = msg:readByte()
    for var=1, freeCard do
        local id = msg:readByte()
        local value = msg:readInt()
        print("id:"..id.."value:"..value)
        local data = {}
        data.id = id
        data.value = value
        zzm.CornucopiaModel.card_list[id] = data
    end
    local chargeCard = msg:readByte()
    for var=1, chargeCard do
        local id = msg:readByte()
        local value = msg:readInt()
        print("id:"..id.."value:"..value)
        local data = {}
        data.id = id
        data.value = value
        zzm.CornucopiaModel.card_list[id] = data
    end

    print("可翻牌次数:"..count)
    zzm.CornucopiaModel.clickCount = count

    self._csbResultNode = cc.CSLoader:getInstance():createNodeWithFlatBuffersFile("dxyCocosStudio/csd/ui/cornucopia/cornucopiaWin.csb")
    self:addChild(self._csbResultNode)
    self._csbResultNode:setPosition(self.origin.x + self.visibleSize.width/2,self.origin.y + self.visibleSize.height/2)

    self.list_item = {}

    local item = nil
    local node = nil
    require("game.cornucopia.view.CornucopiaWinItem")
    for index=1, 8 do
        node = self._csbResultNode:getChildByName("Node_"..index)
        item = CornucopiaWinItem:create()
        item:setParent(self,index)
        item:update()
        node:addChild(item)
        self.list_item[index] = item
        if index > 4 then
            item:setTouchEnabled(false)
        end
    end

    self.txt_time = self._csbResultNode:getChildByName("bg"):getChildByName("timeTxt")
    math.randomseed(os.time())
    self._myTimer = self._myTimer or require("game.utils.MyTimer").new()
    local time = tonumber(MoneySceneConfig:getBaseValueByKey("CardTime"))
    self.txt_time:setString(time)
    local function tick()
        if time > 0 then
            time = time - 1
            self.txt_time:setString(time)
        else
            self.txt_time:setVisible(false)
            self._myTimer:stop()
            
            for index=1, 8 do
                self.list_item[index].timeOut = true
                self.list_item[index]:setTouchEnabled(false)
            end

            local num = math.random(1,freeCard)

            self.list_item[num]:turnCard()
            if self.list_item[num].idx > 4 then
                zzm.CornucopiaModel.clickedCount = zzm.CornucopiaModel.clickedCount + 1
                for index=5, 8 do
                    self.list_item[index]:update()
                end
            end
            table.insert(zzm.CornucopiaModel.clicked_card,zzm.CornucopiaModel.card_list[self.list_item[num].idx].id)

            self.list_item[num]:runTimeLine()
            
        end
    end
    self._myTimer:start(1.0, tick)

    self.cornucopiaBtn = self._csbResultNode:getChildByName("confirmBtn")
    self.cornucopiaBtn:setTouchEnabled(false)
    self.cornucopiaBtn:addTouchEventListener(function(target,type)
        if type == 2 then
            if self._myTimer then
                self._myTimer:stop()
            end
            self.cornucopiaBtn:setTouchEnabled(false)
            local clickedCount = #zzm.CornucopiaModel.clicked_card
            print("翻了"..clickedCount.."次牌")
            for key, var in pairs(zzm.CornucopiaModel.clicked_card) do
                print("发送ID:"..var)
            end
            local msg = mc.packetData:createWritePacket(4080); --编写发送包
            msg:writeByte(clickedCount)
            for key, var in pairs(zzm.CornucopiaModel.clicked_card) do
                msg:writeByte(var)
            end
            mc.NetMannager:getInstance():sendMsg(msg); --发送 包

            if self._onlyOneClickFlag then
                return
            end
            self._onlyOneClickFlag = true
            self:WhenGameEnd()

--            local mainScene = MainScene:create()
--            SceneManager:enterScene(mainScene, "mainScene")
            require("game.loading.PreLoadScene")
            local preLoadScene = PreLoadScene.create()
            preLoadScene:initPreLoad("MainScene","dxyCocosStudio/csd/scene/MainScene_new.csb",function()
                zzc.CornucopiaController:showLayer()
            end)
            SceneManager:enterScene(preLoadScene, "PreLoadScene")
            
--            zzc.CornucopiaController:showLayer()
        end
    end)

    -- 拦截
    local function onTouchBegan(touch, event)

        return true
    end

    local function onTouchMoved(touch, event)

    end


    local function onTouchEnded(touch, event)

    end

    local listener = cc.EventListenerTouchOneByOne:create()
    listener:registerScriptHandler(onTouchBegan,cc.Handler.EVENT_TOUCH_BEGAN )
    listener:registerScriptHandler(onTouchMoved,cc.Handler.EVENT_TOUCH_MOVED )
    listener:registerScriptHandler(onTouchEnded,cc.Handler.EVENT_TOUCH_ENDED )
    local eventDispatcher = self:getEventDispatcher()
    eventDispatcher:addEventListenerWithSceneGraphPriority(listener, self._csbResultNode)
    listener:setSwallowTouches(true)
end

function GameScene:showGameResult(msg)

	if self._showGameResultMark == nil then
		self._showGameResultMark = true
	else
		return
	end

    --接收通关副本奖励数据
    self._msg = {}
    self._msg.type = msg:readByte()
    self._msg.star = msg:readByte()
    self._msg.exp = msg:readUint()
    self._msg.gold = msg:readUint()
    self._msg.renown = msg:readUint()
    local sgt = self:getGameSceneType()
    if self._msg.type == 1 then
    	self._msg.firstexp = msg:readUint()
     self._msg.firstgold = msg:readUint()
     self._msg.firstrenown = msg:readUint()
    end
     
    print("通关类型:"..self._msg.type.."  评价星星数:"..self._msg.star.."   获得经验:"..self._msg.exp.."  获得金币:"..self._msg.gold.."  获得声望:"..self._msg.renown)

    zzm.TalkingDataModel:onCompleted(zzm.CopySelectModel.curCopyData.config.Id)

    if self:getEndTalkId() ~= 0 then

        --        self._msg = {}
        --        self._msg.exp = msg:readUint()
        --        self._msg.copper = msg:readUint()
        self:showGameResultUIByC(msg)
        self:startEndTalk()

        return
    end

    --
    local gameResultTimeCunt = 0

    local function tick(dt)

        gameResultTimeCunt = gameResultTimeCunt + dt

    end

    self._resultSchedulerID = cc.Director:getInstance():getScheduler():scheduleScriptFunc(tick, 0, false)

    --

    self._csbResultNode = cc.CSLoader:getInstance():createNodeWithFlatBuffersFile("GameScene/GameResultWin.csb")
    self:addChild(self._csbResultNode)
    self._csbResultNode:setPosition(self.origin.x + self.visibleSize.width/2,self.origin.y + self.visibleSize.height/2)

    --界面效果

    -- 闪烁
    local continueTxt = self._csbResultNode:getChildByName("continueTxt")

    local blinkAction = cc.Blink:create(1.5,1)
    local repeatAction = cc.RepeatForever:create(blinkAction)
    continueTxt:runAction(repeatAction)
    -- 星星
    local lightStar1 = self._csbResultNode:getChildByName("lightStar1")
    local lightStar2 = self._csbResultNode:getChildByName("lightStar2")
    local lightStar3 = self._csbResultNode:getChildByName("lightStar3")
    local starTable = {lightStar1,lightStar2,lightStar3}

    starTable[1]:setVisible(false)
    starTable[2]:setVisible(false)
    starTable[3]:setVisible(false)

    local starNum = self._msg.star
	for i=1,starNum do
	   -- starTable[i]:setVisible(true)
		starTable[i]:setScale(20)
		
		local function callBack()
			starTable[i]:setVisible(true)
		end
		--local action = cc.Sequence:create(cc.DelayTime:create(0.5 * (i-1) + 0.2),cc.EaseBackOut:create(cc.ScaleTo:create(1.2,1)))
		--local action = cc.Sequence:create(cc.DelayTime:create(0.5 * (i-1) + 0.25),cc.CallFunc:create(callBack),cc.EaseBackOut:create(cc.ScaleTo:create(0.2,1)))
        local function callBack2()
            SoundsFunc_playSounds(SoundsType.SOUND_STAR,false)
        end
        local action = cc.Sequence:create(cc.DelayTime:create(0.3 * (i-1) + 0.25),cc.CallFunc:create(callBack),cc.ScaleTo:create(0.15,1),cc.DelayTime:create(0.05),cc.CallFunc:create(callBack2))
		starTable[i]:runAction(action)
	end

    -- 数字
    require "game/utils/NumberChangeByUpdate.lua"
    local rewardText = self._csbResultNode:getChildByName("rewardTxt")

    local expIcon = rewardText:getChildByName("expStar")
    local expValue = expIcon:getChildByName("expValue")
    local coperIcon = rewardText:getChildByName("coper")
    local coperValue = coperIcon:getChildByName("coperValue")
    local renownIcon = rewardText:getChildByName("renownIcon")
    local renownValue = renownIcon:getChildByName("renownValue")

    local firstRewardText = self._csbResultNode:getChildByName("firstRewardTxt")

    local firstExpIcon = firstRewardText:getChildByName("firstExpIcon")
    local firstExpValue = firstExpIcon:getChildByName("firstExpValue")
    local firstRenownIcon = firstRewardText:getChildByName("firstRenownIcon")
    local firstRenownValue = firstRenownIcon:getChildByName("firstRenownValue")
    local firstCoper = firstRewardText:getChildByName("firstCoper")
    local firstCoperValue = firstCoper:getChildByName("firstCoperValue")
    
    
    local battleReward = self._csbResultNode:getChildByName("battleReward")
    
    local expIcon_0 = battleReward:getChildByName("expStar_0")
    local expValue_0 = expIcon_0:getChildByName("expValue_0")
    local coperIcon_0 = battleReward:getChildByName("coper_0")
    local coperValue_0 = coperIcon_0:getChildByName("coperValue_0")
    local renownIcon_0 = battleReward:getChildByName("renownIcon_0")
    local renownValue_0 = renownIcon_0:getChildByName("renownValue_0")

    
    --    math.randomseed(os.clock())
    --    local v1 = math.random(2000,3999)
    --    local v2 = math.random(5000,7999)
    if self._msg.type == 1 then
       

        local firstExp = self._msg.firstexp
        local firstRenown = self._msg.firstrenown
        local firstGold = self._msg.firstgold

        local firstExpNode = NumberChangeByUpdate:create()
        firstExpNode:initByPam(0,firstExp,firstExpValue,1.25,0.05)
        self:addChild(firstExpNode)

        local firstRenownNode = NumberChangeByUpdate:create()
        firstRenownNode:initByPam(0,firstRenown,firstRenownValue,1.25,0.05)
        self:addChild(firstRenownNode)

        local firstCoperNode = NumberChangeByUpdate:create()
        firstCoperNode:initByPam(0,firstGold,firstCoperValue,1.25,0.05)
        self:addChild(firstCoperNode)

    end

    local exp = self._msg.exp
    local renown = self._msg.renown
    local gold = self._msg.gold
    
    local exp_0 = self._msg.exp
    local renown_0 = self._msg.renown
    local gold_0 = self._msg.gold

    --            expValue:setString(""..v1)
    --            coperValue:setString(""..v2)
    local expNode = NumberChangeByUpdate:create()
    expNode:initByPam(0,exp,expValue,1.25,0.05)
    self:addChild(expNode)

    local renownNode = NumberChangeByUpdate:create()
    renownNode:initByPam(0,renown,renownValue,1.25,0.05)
    self:addChild(renownNode)

    local coperNode = NumberChangeByUpdate:create()
    coperNode:initByPam(0,gold,coperValue,1.25,0.05)
    self:addChild(coperNode)
    
    local expNode_0 = NumberChangeByUpdate:create()
    expNode_0:initByPam(0,exp_0,expValue_0,1.25,0.05)
    self:addChild(expNode_0)

    local renownNode_0 = NumberChangeByUpdate:create()
    renownNode_0:initByPam(0,renown_0,renownValue_0,1.25,0.05)
    self:addChild(renownNode_0)

    local coperNode_0 = NumberChangeByUpdate:create()
    coperNode_0:initByPam(0,gold_0,coperValue_0,1.25,0.05)
    self:addChild(coperNode_0)


    if self._msg.type == 2 then
        firstRewardText:setVisible(false)
        rewardText:setVisible(false)
        if sgt == 2 then
            expIcon_0:setVisible(false)
           
        else
            renownIcon_0:setVisible(false)
            
        end
    else 
        battleReward:setVisible(false)
        if sgt == 2 then
            expIcon:setVisible(false)
            firstExpIcon:setVisible(false)
        else
            renownIcon:setVisible(false)
            firstRenownIcon:setVisible(false)
        end

    end

    -- 拦截
    local function onTouchBegan(touch, event)

        return true
    end

    local function onTouchMoved(touch, event)

    end


    local function onTouchEnded(touch, event)

        if gameResultTimeCunt < 1.5 then return end

        self:openBattleOverOp()

        self._csbResultNode:removeFromParent()

    end

    local listener = cc.EventListenerTouchOneByOne:create()
    listener:registerScriptHandler(onTouchBegan,cc.Handler.EVENT_TOUCH_BEGAN )
    listener:registerScriptHandler(onTouchMoved,cc.Handler.EVENT_TOUCH_MOVED )
    listener:registerScriptHandler(onTouchEnded,cc.Handler.EVENT_TOUCH_ENDED )
    local eventDispatcher = self:getEventDispatcher()
    eventDispatcher:addEventListenerWithSceneGraphPriority(listener, self._csbResultNode)
    listener:setSwallowTouches(true)

end


function GameScene:openBattleOverOp()

    self.returnCityOptionLayer = cc.CSLoader:getInstance():createNodeWithFlatBuffersFile("GameScene/ReturnCityOptionLayer.csb")
    self:addChild(self.returnCityOptionLayer)
    local node = self.returnCityOptionLayer:getChildByName("BO_bg")

    local posX = self.origin.x + self.visibleSize.width
    local posY = self.origin.y + self.visibleSize.height
    node:setPosition(posX, posY)

---zAdd(返回主城按钮再次打开新手)---------------
--    if zzm.GuideModel._isNeedToEnd then
--        self.m_data = zzm.GuideModel:getCurrentGuide()
--        print("ButtonName "..dxyConfig_toList(self.m_data.Guide)[#self.m_data.Guide].ButtonName..".....................")
--        zzc.GuideController.m_GuideLayer:createGuide(self.m_data.Guide[#self.m_data.Guide])
--    end
--------------------------------------

    local returnCityBtn = node:getChildByName("returnCityBtn")
    local function returnCityBtnTouchCallback(sender,eventType)
        if eventType == ccui.TouchEventType.began then
        elseif eventType == ccui.TouchEventType.moved then
        elseif eventType == ccui.TouchEventType.ended then
            SoundsFunc_playSounds(SoundsType.CLOSE_PAGE)
            if self._onlyOneClickFlag then
                return
            end
            self._onlyOneClickFlag = true
            self:WhenGameEnd()

--            local mainScene = MainScene:create()
--            SceneManager:enterScene(mainScene, "mainScene")
            require("game.loading.PreLoadScene")
            local preLoadScene = PreLoadScene.create()
            preLoadScene:initPreLoad("MainScene","dxyCocosStudio/csd/scene/MainScene_new.csb")
            SceneManager:enterScene(preLoadScene, "PreLoadScene")
            
        elseif eventType == ccui.TouchEventType.canceled then
        end
    end
    returnCityBtn:addTouchEventListener(returnCityBtnTouchCallback)

    local selectCopyBtn = node:getChildByName("SelectCopy")
    local function selectCopyBtnTouchCallback(sender,eventType)
        if eventType == ccui.TouchEventType.began then
        elseif eventType == ccui.TouchEventType.moved then
        elseif eventType == ccui.TouchEventType.ended then
            SoundsFunc_playSounds(SoundsType.CLOSE_PAGE)
            if self._onlyOneClickFlag then
                return
            end
            self._onlyOneClickFlag = true
            self:WhenGameEnd()

--            local mainScene = MainScene:create()
--            SceneManager:enterScene(mainScene, "mainScene")
            require("game.loading.PreLoadScene")
            local preLoadScene = PreLoadScene.create()
            preLoadScene:initPreLoad("MainScene","dxyCocosStudio/csd/scene/MainScene_new.csb",function()
                zzc.CopySelectController:showLayer()
            end)
            SceneManager:enterScene(preLoadScene, "PreLoadScene")
            
--            zzc.CopySelectController:showLayer()
        elseif eventType == ccui.TouchEventType.canceled then
        end
    end
    selectCopyBtn:addTouchEventListener(selectCopyBtnTouchCallback)

    local backBattleBtn = node:getChildByName("BackBattle")
    local function backBattleBtnTouchCallback(sender,eventType)
        if eventType == ccui.TouchEventType.began then
        elseif eventType == ccui.TouchEventType.moved then
        elseif eventType == ccui.TouchEventType.ended then
            SoundsFunc_playSounds(SoundsType.CLOSE_PAGE)
            if self._onlyOneClickFlag then
                return
            end
            self._onlyOneClickFlag = true
            self:WhenGameEnd()
            zzc.LoadingController:enterScene(SceneType.LoadingScene)
            zzc.LoadingController:setDelegate2(zzc.CopySelectController.delegate)
        elseif eventType == ccui.TouchEventType.canceled then
        end
    end
    backBattleBtn:addTouchEventListener(backBattleBtnTouchCallback)
    
    if zzc.GuideController._isRunning == true then
    	selectCopyBtn:setTouchEnabled(false)
    	backBattleBtn:setTouchEnabled(false)
    end

end

function GameScene:showGameResultUIByC(msg)

    --self._msg
--    self._msg = {}
--    self._msg.type = msg:readByte()
--    self._msg.star = msg:readByte()
--    self._msg.exp = msg:readUint()
--    self._msg.gold = msg:readUint()
--    self._msg.renown = msg:readUint()
--    firstexp
--    firstgold
--    firstrenown
    
    local sgt = self:getGameSceneType()
    local gameResultTimeCunt = -1
    local function tick(dt)

        if gameResultTimeCunt >= 0 then
            gameResultTimeCunt = gameResultTimeCunt + dt
        end

        if SceneManager._GameEndMark ~= nil then
            SceneManager._GameEndMark = nil

            gameResultTimeCunt = 0

            self._csbResultNode = cc.CSLoader:getInstance():createNodeWithFlatBuffersFile("GameScene/GameResultWin.csb")
            self:addChild(self._csbResultNode)
            self._csbResultNode:setPosition(self.origin.x + self.visibleSize.width/2,self.origin.y + self.visibleSize.height/2)

            --界面效果

            -- 闪烁
            local continueTxt = self._csbResultNode:getChildByName("continueTxt")

            local blinkAction = cc.Blink:create(1.5,1)
            local repeatAction = cc.RepeatForever:create(blinkAction)
            continueTxt:runAction(repeatAction)
            -- 星星
            local lightStar1 = self._csbResultNode:getChildByName("lightStar1")
            local lightStar2 = self._csbResultNode:getChildByName("lightStar2")
            local lightStar3 = self._csbResultNode:getChildByName("lightStar3")
            local starTable = {lightStar1,lightStar2,lightStar3}

            starTable[1]:setVisible(false)
            starTable[2]:setVisible(false)
            starTable[3]:setVisible(false)

            local starNum = self._msg.star

            for i=1,starNum do
               -- starTable[i]:setVisible(true)
                starTable[i]:setScale(20)
				
				local function callBack()
					starTable[i]:setVisible(true)
				end
                --local action = cc.Sequence:create(cc.DelayTime:create(0.5 * (i-1) + 0.2),cc.EaseBackOut:create(cc.ScaleTo:create(1.2,1)))
                --local action = cc.Sequence:create(cc.DelayTime:create(0.5 * (i-1) + 0.25),cc.CallFunc:create(callBack),cc.EaseBackOut:create(cc.ScaleTo:create(0.2,1)))
                local function callBack2()
                    SoundsFunc_playSounds(SoundsType.SOUND_STAR,false)
                end
                local action = cc.Sequence:create(cc.DelayTime:create(0.3 * (i-1) + 0.25),cc.CallFunc:create(callBack),cc.ScaleTo:create(0.15,1),cc.DelayTime:create(0.05),cc.CallFunc:create(callBack2))
                starTable[i]:runAction(action)
            end

            -- 数字
            require "game/utils/NumberChangeByUpdate.lua"
            local rewardText = self._csbResultNode:getChildByName("rewardTxt")

            local expIcon = rewardText:getChildByName("expStar")
            local expValue = expIcon:getChildByName("expValue")
            local coperIcon = rewardText:getChildByName("coper")
            local coperValue = coperIcon:getChildByName("coperValue")
            local renownIcon = rewardText:getChildByName("renownIcon")
            local renownValue = renownIcon:getChildByName("renownValue")

            local firstRewardText = self._csbResultNode:getChildByName("firstRewardTxt")

            local firstExpIcon = firstRewardText:getChildByName("firstExpIcon")
            local firstExpValue = firstExpIcon:getChildByName("firstExpValue")
            local firstRenownIcon = firstRewardText:getChildByName("firstRenownIcon")
            local firstRenownValue = firstRenownIcon:getChildByName("firstRenownValue")
            local firstCoper = firstRewardText:getChildByName("firstCoper")
            local firstCoperValue = firstCoper:getChildByName("firstCoperValue")

            local battleReward = self._csbResultNode:getChildByName("battleReward")

            local expIcon_0 = battleReward:getChildByName("expStar_0")
            local expValue_0 = expIcon_0:getChildByName("expValue_0")
            local coperIcon_0 = battleReward:getChildByName("coper_0")
            local coperValue_0 = coperIcon_0:getChildByName("coperValue_0")
            local renownIcon_0 = battleReward:getChildByName("renownIcon_0")
            local renownValue_0 = renownIcon_0:getChildByName("renownValue_0")


            --    math.randomseed(os.clock())
            --    local v1 = math.random(2000,3999)
            --    local v2 = math.random(5000,7999)
            if self._msg.type == 1 then


                local firstExp = self._msg.firstexp
                local firstRenown = self._msg.firstrenown
                local firstGold = self._msg.firstgold

                local firstExpNode = NumberChangeByUpdate:create()
                firstExpNode:initByPam(0,firstExp,firstExpValue,1.25,0.05)
                self:addChild(firstExpNode)

                local firstRenownNode = NumberChangeByUpdate:create()
                firstRenownNode:initByPam(0,firstRenown,firstRenownValue,1.25,0.05)
                self:addChild(firstRenownNode)

                local firstCoperNode = NumberChangeByUpdate:create()
                firstCoperNode:initByPam(0,firstGold,firstCoperValue,1.25,0.05)
                self:addChild(firstCoperNode)

            end

            local exp = self._msg.exp
            local renown = self._msg.renown
            local gold = self._msg.gold

            local exp_0 = self._msg.exp
            local renown_0 = self._msg.renown
            local gold_0 = self._msg.gold

            --            expValue:setString(""..v1)
            --            coperValue:setString(""..v2)
            local expNode = NumberChangeByUpdate:create()
            expNode:initByPam(0,exp,expValue,1.25,0.05)
            self:addChild(expNode)

            local renownNode = NumberChangeByUpdate:create()
            renownNode:initByPam(0,renown,renownValue,1.25,0.05)
            self:addChild(renownNode)

            local coperNode = NumberChangeByUpdate:create()
            coperNode:initByPam(0,gold,coperValue,1.25,0.05)
            self:addChild(coperNode)

            local expNode_0 = NumberChangeByUpdate:create()
            expNode_0:initByPam(0,exp_0,expValue_0,1.25,0.05)
            self:addChild(expNode_0)

            local renownNode_0 = NumberChangeByUpdate:create()
            renownNode_0:initByPam(0,renown_0,renownValue_0,1.25,0.05)
            self:addChild(renownNode_0)

            local coperNode_0 = NumberChangeByUpdate:create()
            coperNode_0:initByPam(0,gold_0,coperValue_0,1.25,0.05)
            self:addChild(coperNode_0)


            if self._msg.type == 2 then
                firstRewardText:setVisible(false)
                rewardText:setVisible(false)
                if sgt == 2 then
                    expIcon_0:setVisible(false)

                else
                    renownIcon_0:setVisible(false)

                end
            else 
                battleReward:setVisible(false)
                if sgt == 2 then
                    expIcon:setVisible(false)
                    firstExpIcon:setVisible(false)
                else
                    renownIcon:setVisible(false)
                    firstRenownIcon:setVisible(false)
                end

            end

            -- 拦截
            local function onTouchBegan(touch, event)

                return true
            end

            local function onTouchMoved(touch, event)

            end


            local function onTouchEnded(touch, event)
                --self:WhenGameEnd()
                --local mainScene = MainScene:create()
                --SceneManager:enterScene(mainScene, "mainScene")
                --if true then return end

                if gameResultTimeCunt < 2 then return end -- 1.5

                self:openBattleOverOp()

                self._csbResultNode:removeFromParent()

            end

            local listener = cc.EventListenerTouchOneByOne:create()
            listener:registerScriptHandler(onTouchBegan,cc.Handler.EVENT_TOUCH_BEGAN )
            listener:registerScriptHandler(onTouchMoved,cc.Handler.EVENT_TOUCH_MOVED )
            listener:registerScriptHandler(onTouchEnded,cc.Handler.EVENT_TOUCH_ENDED )
            local eventDispatcher = self:getEventDispatcher()
            eventDispatcher:addEventListenerWithSceneGraphPriority(listener, self._csbResultNode)
            listener:setSwallowTouches(true)
        end

    end

    self._resultByCSchedulerID = cc.Director:getInstance():getScheduler():scheduleScriptFunc(tick, 0, false)
end

--爬塔胜利界面
function GameScene:showGroupBackLayer(msg)
    local origin = cc.Director:getInstance():getVisibleOrigin()
    local visibleSize = cc.Director:getInstance():getVisibleSize()
    self._csbGroupWinLayer = cc.CSLoader:getInstance():createNodeWithFlatBuffersFile("dxyCocosStudio/csd/ui/groupfunc/GroupEndLayer.csb")
    SceneManager:getCurrentScene():addChild(self._csbGroupWinLayer)
    self._csbGroupWinLayer:setPosition(origin.x + visibleSize.width/2,origin.y + visibleSize.height/2)
    
    self.btn_next = self._csbGroupWinLayer:getChildByName("btn_next")
    self.btn_sure = self._csbGroupWinLayer:getChildByName("btn_sure")
    self.countDown = self._csbGroupWinLayer:getChildByName("countDown")
    self.lvNum = self._csbGroupWinLayer:getChildByName("lvNum")
    self.lvNum:setString(zzm.GroupModel.curLevelSelect.Name)
    
    self.rankNode = {}

    for k = 1, 3 do 
        self.rankNode[k] = {}
        self.rankNode[k].Node = self._csbGroupWinLayer:getChildByName("rankNode"..k)
        self.rankNode[k].Node:setVisible(false)
        self.rankNode[k].Rank = self.rankNode[k].Node:getChildByName("ranking")
        self.rankNode[k].Name = self.rankNode[k].Node:getChildByName("name")
        self.rankNode[k].HurtValue = self.rankNode[k].Node:getChildByName("hurtValue")
        self.rankNode[k].Percent = self.rankNode[k].Node:getChildByName("percent")
        self.rankNode[k].HeadIcon = self.rankNode[k].Node:getChildByName("headIcon")
        self.rankNode[k].Ready = self.rankNode[k].Node:getChildByName("ready")
        
        for j=1,3 do
            self.rankNode[k][j] = {}
            self.rankNode[k][j].spColor = self.rankNode[k].Node:getChildByName("spColor_"..j)
            self.rankNode[k][j].spGoods = self.rankNode[k].Node:getChildByName("spGoods_"..j)
            self.rankNode[k][j].txtNum = self.rankNode[k].Node:getChildByName("txtNum_"..j)
            self.rankNode[k][j].txtName = self.rankNode[k].Node:getChildByName("txtName_"..j)
        end
    end
     
--接收奖励
    self.playerNum = msg:readUshort()
    self.rankData = {}
    for i = 1, self.playerNum do
        self.rankData[i] = {}
        self.rankData[i].Rank = msg:readUbyte()
        self.rankData[i].Uid = msg:readUint()
        self.rankData[i].Name = msg:readString()
        self.rankData[i].Pro = msg:readUbyte()
        self.rankData[i].HurtValue = msg:readUint()
        self.rankData[i].CurrCount = msg:readUshort()
        for k = 1, self.rankData[i].CurrCount do
            self.rankData[i][k] = {}
            self.rankData[i][k].Type = msg:readUbyte()
            self.rankData[i][k].Num = msg:readUint()
        end
    end
    local function rangeSort(t1,t2)
        return t1.HurtValue > t2.HurtValue
        end
    table.sort(self.rankData,rangeSort)
    self:setUIData()
    --总伤害
    local allHurt = 0
    for i = 1,self.playerNum do
        allHurt = self.rankData[i].HurtValue + allHurt
    end
    
    --伤害百分比
    local hurtPercent = 0
    if self.playerNum > 1 then
    	for i=1, self.playerNum - 1 do
            local percent = math.floor(self.rankData[i].HurtValue/allHurt*100)
            self.rankNode[i].Percent:setString("("..math.floor(percent).."%"..")")
            hurtPercent = hurtPercent + percent
    	end
        local lastPercent =  100 - hurtPercent
        self.rankNode[self.playerNum].Percent:setString("("..lastPercent.."%"..")")
    else
       for i = 1, self.playerNum do
        local percent = math.floor(self.rankData[i].HurtValue/allHurt*100)
         self.rankNode[i].Percent:setString("("..percent.."%"..")")
       end
    end
    

    self.btn_sure:addTouchEventListener(function(target,type)
        if type == 2 then
--            self:WhenGameEnd()
            SoundsFunc_playSounds(SoundsType.UNIVERSAL_BTN,false)
            if self._groupTimer then
            	self._groupTimer:stop()
            	self._groupTimer = nil
            end
            self:WhenGameEnd()
            local msg = mc.packetData:createWritePacket(11670); --编写发送包
            msg:writeByte(0) --确定
            mc.NetMannager:getInstance():sendMsg(msg); --发送 包
            print("send -----------------------11670  0")
        end
    end)
    
    self.btn_next:addTouchEventListener(function(target,type)
        if type == 2 then
--            btn_next:setTouchEnabled(false)
--            btn_next:setBright(false)
            self.btn_sure:setTouchEnabled(false)
            self.btn_sure:setBright(false)
            SoundsFunc_playSounds(SoundsType.UNIVERSAL_BTN,false)
            local isNext = GroupConfig:getSkyPagodaByPageById(zzm.GroupModel.curLevelSelect.Id + 1)
            if not isNext then
                dxyFloatMsg:show("已到达最高层数")
                return
            end 
            
            local msg = mc.packetData:createWritePacket(11670); --编写发送包
            msg:writeByte(1) -- 下一层
            mc.NetMannager:getInstance():sendMsg(msg); --发送 包
            print("send -----------------------11670  1")
        end
    end)
    
    self:countDownTime()
--    self:setLvNum()
end

local PATH = "res/dxyCocosStudio/png/equip/"
function GameScene:setUIData()
    for j=1,self.playerNum do
        self.rankNode[j].Node:setVisible(true)
        for i=1,#self.rankData[j] do 
            if self.rankNode[j][i] and self.rankData[j][i] then
                self.rankNode[j][i].spGoods:setVisible(true)
                self.rankNode[j][i].spColor:setVisible(true)
                self.rankNode[j][i].txtName:setVisible(true)
                self.rankNode[j][i].txtNum:setVisible(true)
                if  self.rankData[j][i].Type == DefineConst.CONST_AWARD_GOODS then --6

                else
                    self.rankNode[j][i].spGoods:setTexture(zzd.TaskData.arrGoodsIcon[self.rankData[j][i].Type])
                    self.rankNode[j][i].spColor:setTexture(PATH.."spiritQuality_1.png")
                    self.rankNode[j][i].txtName:setString(zzd.TaskData.arrStrType[self.rankData[j][i].Type])
                end
                self.rankNode[j][i].txtNum:setString(self.rankData[j][i].Num)
            end
        end
        self.rankNode[j].Name:setString(self.rankData[j].Name)
        self.rankNode[j].HurtValue:setString(self.rankData[j].HurtValue)
        local hero = HeroConfig:getValueById(self.rankData[j].Pro)["IconSquare"]
        self.rankNode[j].HeadIcon:setTexture(hero)
    end
end

function GameScene:countDownTime()
    
    self._groupTimer = self._groupTimer or require("game.utils.MyTimer").new()
    local time = SkyPagodaConfig:getCountDownTime()
    self.countDown:setString(time.."秒")
    local function tick()
        if time > 0 then
            time = time - 1
            self.countDown:setString(time.."秒")
        else
            
            self.countDown:setVisible(false)
            if self._groupTimer then
            	self._groupTimer:stop()
                self._groupTimer = nil
            end
            self:WhenGameEnd()
            local msg = mc.packetData:createWritePacket(11670); --编写发送包
            msg:writeByte(0) --确定
            mc.NetMannager:getInstance():sendMsg(msg); --发送 包
            print("send ---------------------------11670  0")
        end
    end
    self._groupTimer:start(1.0, tick)
end



function GameScene:updatTeamCopyState(data)
    if SceneManager.m_curSceneName == "GameScene" then
        for key, var in pairs(self.rankData) do
            if var.Uid == data.Uid then
              if self.rankNode[key].Ready then  
                if data.State == DefineConst.CONST_CLIMBING_TOWER_IS_PREPARE then --已准备
                    self.rankNode[key].Ready:setVisible(true)
                else
                    self.rankNode[key].Ready:setVisible(false)
                end
                
                if data.Uid == _G.RoleData.Uid then
                    self.btn_next:setTouchEnabled(false)
                    self.btn_next:setBright(false)
                    
                end
                break
              end
            end
        end
    end
end

function GameScene:setBattleParse(flag)
    self:setAIWork(flag)
    self:setUpdateWork(flag)
end

--组队爬塔结束
--function GameScene:whenTeamCopyOff()
--    local mainScene = MainScene:create()
--    SceneManager:enterScene(mainScene, "mainScene")
--    if zzm.GroupModel:isCaptain() then --是否队长
--        zzc.GroupController:enterGroupFunc(1572,60)
--    else
--        zzc.GroupFuncCtrl:enterTower()
--    end
--end