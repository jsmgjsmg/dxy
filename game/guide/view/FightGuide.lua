 
   
FightGuide = FightGuide or class("FightGuide",function()
    return cc.Layer:create()
end)

function FightGuide.create()
    local layer = FightGuide.new()
    return layer
end

function FightGuide:ctor()
    self._csbNode = nil
    self._myDelayTimer = nil
    self:initUI()
    dxyExtendEvent(self)
end

function FightGuide:initUI()
    self._csbNode = cc.CSLoader:getInstance():createNodeWithFlatBuffersFile("res/dxyCocosStudio/csd/ui/guide/FightGuide.csb")
    self:addChild(self._csbNode)

    self.visibleSize = cc.Director:getInstance():getVisibleSize()
    self.origin = cc.Director:getInstance():getVisibleOrigin()

    --self.handType = self._csbNode:getChildByName("HandType")
    self.contentsBG = self._csbNode:getChildByName("StrBG")
    --self.arrowIcon = self.targetBtn:getChildByName("ArrowRight")
    
    self.action = cc.CSLoader:createTimeline("res/dxyCocosStudio/csd/ui/guide/FightGuide.csb") 
    self.action:retain()
    self.action:gotoFrameAndPlay(0,true) 
    
    --self._csbNode:runAction(self.action) 

    local contents = cc.Label:createWithTTF("","dxyCocosStudio/font/MicosoftBlack.ttf",20)
    contents:setDimensions(300,contents:getDimensions().height)
    contents:setAlignment(0)
    contents:setAnchorPoint(0,0)
    self.contentsBG:addChild(contents)
    self.contents = contents
end

function FightGuide:update(data)
    self.m_data = data 
    if self.m_data then
        local path = self.m_data.ButtonName
        self:setHandType()
        self:setLocalPos()
        self:setContentStr(self.m_data.TalkText)
        self:setEndType()
        self:setAIFlag(true)
        self._csbNode:runAction(self.action) 
    end
end

function FightGuide:setAIFlag(flag)
	
    if flag then
        if self.m_data.AiStop == 1 then
            SceneManager.m_curScene:setAIWork(false)
--			print("--------------------false")
        end
    else
        if self.m_data.AiStop == 2 then
            SceneManager.m_curScene:setAIWork(true)
--			print("--------------------true")
        end
    end
end

function FightGuide:setContentStr(str)
    self.contents:setString(str)
    local contentsHeight = self.contents:getContentSize().height
    self.contentsBG:setContentSize(400+60, contentsHeight+120)
    self.contents:setPosition(150,40)
end

function FightGuide:setHandType()
    if self.handType then
        self.handType:setVisible(false)
    end
    if self.m_data then
        if self.m_data.HandType == 0 then
	    self.handType = nil
        elseif self.m_data.HandType == 1 then
            self.handType = self._csbNode:getChildByName("HandType")
        elseif self.m_data.HandType == 2 then
            self.handType = self._csbNode:getChildByName("SkillType")
        elseif self.m_data.HandType == 3 then
            self.handType = self._csbNode:getChildByName("ClickType")
        elseif self.m_data.HandType == 4 then
            self.handType = self._csbNode:getChildByName("ClickType_2")
        elseif self.m_data.HandType == 5 then
            self.handType = self._csbNode:getChildByName("ClickType_3")
        elseif self.m_data.HandType == 6 then
            self.handType = self._csbNode:getChildByName("SkillType_1")
        elseif self.m_data.HandType == 7 then
            self.handType = self._csbNode:getChildByName("SkillType_2")
        elseif self.m_data.HandType == 8 then
            self.handType = self._csbNode:getChildByName("SkillType_3")
        elseif self.m_data.HandType == 9 then
            self.handType = self._csbNode:getChildByName("ClickType_4")
        else
	    self.handType = nil
        end
        
    end
end


function FightGuide:setLocalPos()
    local bgX = self.origin.x + self.visibleSize.width/2
    local bgY = self.origin.y + self.visibleSize.height/2
    local bgPos = dxyStringSplit(self.m_data.Direction, ",") --x,y
    local handPos = dxyStringSplit(self.m_data.Assemble, ",") --x,y
    --self.arrowIcon:setPosition(arrowX,arrowY)
    --self.contentsBG:setAnchorPoint(bgAX,bgAY)

    if self.handType then
        self.handType:setVisible(true)
        if self.m_data.Type == 3 then
            local path = self.m_data.ButtonName
            local btn = zzc.GuideController:findObjectInScene(path)
            if btn then
                print("-----------------------------update OK")
                local objpos = btn:convertToWorldSpace(cc.p(0,0))
                print("   objpos.x-----> " .. objpos.x .. "  objpos.y---->" .. objpos.y)
                local size = btn:getContentSize()
                self.handType:setPosition(objpos.x+size.width*0.5, objpos.y+size.height*0.5)
            end
        else
            self.handType:setPosition(handPos[1]*0.01*self.visibleSize.width,handPos[2]*0.01*self.visibleSize.height)
        end
    end
    self.contentsBG = self._csbNode:getChildByName("StrBG")
    self.contentsBG:setPosition(bgPos[1]*0.01*self.visibleSize.width,bgPos[2]*0.01*self.visibleSize.height)
end

function FightGuide:setEndType()
    local time = self.m_data.TalkFrameType
    if tonumber(time) <= 0 then
    	time = 0.1
    end
    if self.m_data.EndType == 1 or self.m_data.EndType == 6 then --click
        self:checkClicked(time)
    elseif self.m_data.EndType == 2 or self.m_data.EndType == 7 or self.m_data.EndType == 8 or self.m_data.EndType == 9 then --move
        self:delayAction(time)
        self:startCheckUseSkill()
    elseif self.m_data.EndType == 3 then --dead
        self:delayAction(time)
        SceneManager._FirstMonsterDead = false
        self._myGuideTimer = self._myGuideTimer or require("game.utils.MyTimer").new()
        local function tick()
            self:checkFirstMonsterDead()
        end
        self._myGuideTimer:start(0.5, tick)
    elseif self.m_data.EndType == 4 then --pos
        self:delayAction(time)
        self._myGuideTimer = self._myGuideTimer or require("game.utils.MyTimer").new()
        local function tick()
            self:checkPlayerPosX()
        end
        self._myGuideTimer:start(0.05, tick)
    elseif self.m_data.EndType == 5 then --pos
        self:delayAction(time)
		SceneManager._ComboMidle = false
        self._myGuideTimer = self._myGuideTimer or require("game.utils.MyTimer").new()
        local function tick()
            self:checkComboMidle()
        end
        self._myGuideTimer:start(0.05, tick)
--    elseif self.m_data.EndType == 6 then --pos
--        self:checkClicked(time)
    else
    
    end
end

function FightGuide:removeEvent()
    self:removeTimer()
end

function FightGuide:initEvent()

end


function FightGuide:delayAction(time)
    self._myDelayTimer = self._myDelayTimer or require("game.utils.MyTimer").new()
    self._delayAction = false
    local function tick()
        self._myDelayTimer:stop()
        self._myDelayTimer = nil
        self._delayAction = true
    end
    if time <= 0 then
    	time = 0.1
    end
    self._myDelayTimer:start(time*0.5, tick)
    -- 拦截
    local function onTouchBegan(touch, event) 
        if self._delayAction == false then
            return true
        end
        local pause = SceneManager.m_curScene:getIsControllerPause()
        if zzm.GuideModel._isCheckPos == true and pause == true then
            zzm.GuideModel._isCheckPos = false
            SceneManager.m_curScene:setIsControllerPause(false)
        end
        return false
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
    eventDispatcher:addEventListenerWithSceneGraphPriority(listener, self)
    listener:setSwallowTouches(true)
end


function FightGuide:checkClicked(time)
    -- 拦截
    self._myDelayTimer = self._myDelayTimer or require("game.utils.MyTimer").new()
    self._delayAction = false
    local function tick()
        self._myDelayTimer:stop()
        self._myDelayTimer = nil
        self._delayAction = true
    end
    self._myDelayTimer:start(time, tick)
    local function onTouchBegan(touch, event) 
        return true
    end

    local function onTouchMoved(touch, event)
    end

    local function onTouchEnded(touch, event)
        if self._delayAction == false then
            return true
        end

        if self.m_data.EndType == 6 and SceneManager._ComboMidle == true then
            SceneManager.m_curScene:setBattleParse(true)
        end
        print("-----------------> checkClicked Over")
        SceneManager.m_curScene:setIsControllerPause(false)
        --SceneManager.m_curScene:setAIWork(true)
        self:overGuide()
    end

    local listener = cc.EventListenerTouchOneByOne:create()
    listener:registerScriptHandler(onTouchBegan,cc.Handler.EVENT_TOUCH_BEGAN )
    listener:registerScriptHandler(onTouchMoved,cc.Handler.EVENT_TOUCH_MOVED )
    listener:registerScriptHandler(onTouchEnded,cc.Handler.EVENT_TOUCH_ENDED )
    local eventDispatcher = self:getEventDispatcher()
    eventDispatcher:addEventListenerWithSceneGraphPriority(listener, self)
    
    
	if self.m_data.EndType ~= 6 then
		listener:setSwallowTouches(true)        -- 拦截
        SceneManager.m_curScene:setIsControllerPause(true)
    end
    --eneManager.m_curScene:setIsControllerPause(true)
    --SceneManager.m_curScene:setAIWork(false)
end


function FightGuide:checkComboMidle()
    if SceneManager._ComboMidle == true then
        self._myGuideTimer:stop()
        self._myDelayTimer = self._myDelayTimer or require("game.utils.MyTimer").new()
        local function tick()
            self._myDelayTimer:stop()
            SceneManager.m_curScene:setBattleParse(false)
            print("-----------------> checkComboMidle Over")
            self:overGuide()
        end
        self._myDelayTimer:start(0.3, tick)
    end
end

function FightGuide:startCheckUseSkill()
    SceneManager._UseSkill = 0
    --SceneManager.m_curScene:setIsControllerPause(true)
	SceneManager.m_curScene:setIsNotPlayNomalAttack(true)
    --SceneManager.m_curScene:setAIWork(false)
    --SceneManager.m_curScene:setBattleParse(false)
	
	local function onTouchBegan(touch, event) 
        return true
    end

    local function onTouchEnded(touch, event)
        --print("-----------------> checkClicked Over")
        --SceneManager.m_curScene:setIsControllerPause(false)
        --self:overGuide()
    end

    local listener = cc.EventListenerTouchOneByOne:create()
    listener:registerScriptHandler(onTouchBegan,cc.Handler.EVENT_TOUCH_BEGAN )
    listener:registerScriptHandler(onTouchEnded,cc.Handler.EVENT_TOUCH_ENDED )
    local eventDispatcher = self:getEventDispatcher()
    eventDispatcher:addEventListenerWithSceneGraphPriority(listener, self)
    
    self._myGuideTimer = self._myGuideTimer or require("game.utils.MyTimer").new()
    local function tick()
        self:checkUseSkill()
    end
    self._myGuideTimer:start(0.5, tick)
end

function FightGuide:checkUseSkill()
    print("checkUseSkill----- " .. SceneManager._UseSkill)
    print(SceneManager._UseSkillOK)
    if SceneManager._UseSkillOK == true and SceneManager._UseSkill == self.m_data.EndType then
        --SceneManager.m_curScene:setIsControllerPause(false)
		SceneManager.m_curScene:setIsNotPlayNomalAttack(false)
        --SceneManager.m_curScene:setAIWork(true)
        --SceneManager.m_curScene:setBattleParse(true)
        print("-----------------> checkUseSkill Over")
        self:overGuide()
    end
end

function FightGuide:checkFirstMonsterDead()
    if SceneManager._FirstMonsterDead == true then
        print("-----------------> checkFirstMonsterDead Over")
        self:overGuide()
    end
end

function FightGuide:checkPlayerPosX()
    local posx= SceneManager.m_curScene:getPlayerPosX()
    if posx > self.m_data.FrameType then
        print("-----------------> checkPlayerPosX Over")
        SceneManager.m_curScene:setIsControllerPause(true)
        zzm.GuideModel._isCheckPos = true
        self:overGuide()
    end
end

function FightGuide:overGuide()
    self:removeTimer()
    if self.action then
        self.action:release()
        self.action = nil
    end
    self:setAIFlag(false)
    self:removeFromParent()
    dxyDispatcher_dispatchEvent(dxyEventType.NextNewPlayerGuide)
end

function FightGuide:removeTimer()
    if self._myGuideTimer then
        self._myGuideTimer:stop()
        self._myGuideTimer = nil
    end
    if self._myDelayTimer then
        self._myDelayTimer:stop()
        self._myDelayTimer = nil
    end
end

