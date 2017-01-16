
GuideMainLayer = GuideMainLayer or class("GuideMainLayer",function()
    return cc.Layer:create()
end)

function GuideMainLayer.create()
    local layer = GuideMainLayer.new()
    return layer
end

function GuideMainLayer:ctor()
    self._csbNode = nil
    self._curIndex = 1
    self._canClick = false
	self._startDely = false
	self._delyTime = 0
	zzm.GuideModel._isFightGuideOver = false
    require "src.game.guide.view.ButtonGuide"
    require "src.game.guide.view.FightGuide"
    self:initUI()
    dxyExtendEvent(self)
    --dxySwallowTouches(self)
end

function GuideMainLayer:initUI()
    self._csbNode = cc.CSLoader:getInstance():createNodeWithFlatBuffersFile("res/dxyCocosStudio/csd/ui/guide/GuideMainLayer.csb")
    self:addChild(self._csbNode)

    self.visibleSize = cc.Director:getInstance():getVisibleSize()
    self.origin = cc.Director:getInstance():getVisibleOrigin()

    local posX = self.origin.x + self.visibleSize.width/2
    local posY = self.origin.y + self.visibleSize.height/2

    self:setPosition(0, 0)
    
    local function onTouchBegan(touch, event) 
        return self._canClick
    end

    local listener = cc.EventListenerTouchOneByOne:create()
    listener:registerScriptHandler(onTouchBegan,cc.Handler.EVENT_TOUCH_BEGAN )
    local eventDispatcher = self:getEventDispatcher()
    eventDispatcher:addEventListenerWithSceneGraphPriority(listener, self)
    listener:setSwallowTouches(true)
	
	self._myCheckFightOverTimer = self._myCheckFightOverTimer or require("game.utils.MyTimer").new()
    local function tick()
        --dxyFloatMsg:show("--- " .. self._canClick )
		if self._canClick == true then
			self._startDely = true
		else
			self._startDely = false
			self._delyTime = 0
		end
		if self._startDely == true then
			self._delyTime = self._delyTime + 1
		else
			self._delyTime = 0
		end
		
		if self._delyTime > 2 then
			self._canClick = false
			self._startDely = false
			self._delyTime = 0
		end
		if SceneManager.m_curSceneName == "GameScene" and zzm.GuideModel._isFightGuideOver == true then
		    zzm.GuideModel._isFightGuideOver = false
			zzc.GuideController:request_GuideID_Update()
		end
    end
        
    local deleTime = 1
    self._myCheckFightOverTimer:start(deleTime, tick)
        
end

function GuideMainLayer:update()
    self.m_data = zzm.GuideModel:getCurrentGuide()
    if self.m_data then
	    self._curIndex = 1
        self.m_data.Guide = dxyConfig_toList(self.m_data.Guide)
        local data = self.m_data.Guide[self._curIndex]
        self:createGuide(data)
        if SceneManager.m_curSceneName == "mainScene" or SceneManager.m_curSceneName == "MainScene" then
            zzm.GuideModel._newOpenCopy = false
        end
    end
end

--下一步新手引导
function GuideMainLayer:nextGuide()
    zzm.TalkingDataModel:onCompleted("xs"..zzm.GuideModel._currentOKGuideID.."_"..self._curIndex)
    self._canClick = true
	self._startDely = false
	self._delyTime = 0
    --self:setZOrder(1)
    if self._curIndex < #self.m_data.Guide then
        local data = self.m_data.Guide[self._curIndex]
        if data.Type ~= 1 then
            self._canClick = false
        end
        self._curIndex = self._curIndex + 1
        local data = self.m_data.Guide[self._curIndex]
        self._myGuideTimer = self._myGuideTimer or require("game.utils.MyTimer").new()
        local function tick()
            if data then
                self:createGuide(data)
            end
        end
        
        local deleTime = 0.1
        if SceneManager.m_curSceneName == "mainScene" or SceneManager.m_curSceneName == "MainScene" then
            if data.NextTime ~= nil then
                deleTime = data.NextTime
            end
        elseif SceneManager.m_curSceneName == "GameScene" then
            deleTime = 0.05
        end
        self._myGuideTimer:start(deleTime, tick)
        
    else
        -- over
	   --dxyFloatMsg:show(" zzc.GuideController._isRunning = false")
        self:removeFromParent() 
        zzc.GuideController._nextGuideMask = false
        if self.m_data.StopTouch then
		    if self.m_data.StopTouch == 1 then
				zzc.GuideController._nextGuideMask = true
			end
        end

        zzm.GuideModel.startNewGuide = false
        zzc.GuideController._isRunning = false
        if SceneManager.m_curSceneName == "GameScene" then
		    SceneManager._EndTalk = false
        end
        zzm.GuideModel:setNextGuideID()
    end
end

--创建新手操作提示
function GuideMainLayer:createGuide(data)

    if data.Type == 1 then
    
---zAdd(返回主城按钮断开新手)---------------
--        if data.ButtonName == "BO_bg/BG_2" then
--            if self._myGuideTimer then
--                self._myGuideTimer:stop()
--                self._myGuideTimer = nil
--                zzm.GuideModel._isNeedToEnd = true
--                return
--            end
--        end
--        zzm.GuideModel._isNeedToEnd = false
-------------------------------------        
    
        local path = data.ButtonName
        local btn = zzc.GuideController:findObjectInScene(path) --查找按钮位置
        if btn then
            zzm.TalkingDataModel:onBegin("xs"..zzm.GuideModel._currentOKGuideID.."_"..self._curIndex)
            if data.EndFlag == 1 then
                zzc.GuideController:request_GuideID_Update()
            end
            print("-----------------------------next OK")
            --if self.m_Guide == nil then
                self.m_Guide = ButtonGuide.create()
                self._canClick = false
                --self.m_Guide:retain()
            --end
            
            local scene = SceneManager:getCurrentScene()
            scene:addChild(self.m_Guide)
            self.m_Guide:update(data)
            if self._myGuideTimer then
                self._myGuideTimer:stop()
                self._myGuideTimer = nil
            end
		else
			if data.EndFlag == 2 then
				self:nextGuide()
			end
        end
    elseif data.Type == 2 or data.Type == 3 then
        if SceneManager.m_curSceneName == "GameScene" then
            zzm.TalkingDataModel:onBegin("xs"..zzm.GuideModel._currentOKGuideID.."_"..self._curIndex)
            if data.EndFlag == 1 then
                zzc.GuideController:request_GuideID_Update()
            end
            if zzm.GuideModel._isFightGuideOver == true then
                zzm.GuideModel._isFightGuideOver = false
            end
            --if self.m_Guide == nil then
            self.m_Guide = FightGuide.create()
            self._canClick = false
            --self.m_Guide:retain()
            -- end
            local scene = SceneManager:getCurrentScene()
            scene:addChild(self.m_Guide)
            self.m_Guide:update(data)
        else
            self:nextGuide()
        end

        if self._myGuideTimer then
            self._myGuideTimer:stop()
            self._myGuideTimer = nil
        end
        if self._myCheckFightOverTimer then
            self._myCheckFightOverTimer:stop()
            self._myCheckFightOverTimer = nil
        end
    end
end

function GuideMainLayer:removeEvent()
    dxyDispatcher_removeEventListener(dxyEventType.NextNewPlayerGuide,self,self.nextGuide)
--    dxyFloatMsg:show(" zzc.GuideController._isRunning = false")
    if self.m_Guide then
        --self.m_Guide:release()
        self.m_Guide = nil
    end
	            if self._myGuideTimer then
                self._myGuideTimer:stop()
                self._myGuideTimer = nil
            end

end

function GuideMainLayer:initEvent()
    dxyDispatcher_addEventListener(dxyEventType.NextNewPlayerGuide,self,self.nextGuide)
    
end





