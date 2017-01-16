
NewFunctionLayer = NewFunctionLayer or class("NewFunctionLayer",function()
    return cc.Layer:create()
end)

function NewFunctionLayer.create()
    local layer = NewFunctionLayer.new()
    return layer
end

function NewFunctionLayer:ctor()
    self._csbNode = nil
    self.itemList = {}
    self._moveTimes = 3.8
    self._canClick = false
    self:initUI()
--    dxyExtendEvent(self)
--    dxySwallowTouches(self)
end

function NewFunctionLayer:initUI()
    self._csbNode = cc.CSLoader:getInstance():createNodeWithFlatBuffersFile("res/dxyCocosStudio/csd/ui/guide/NewFunctionMainLayer.csb")
    self:addChild(self._csbNode)
    
    self.contents = self._csbNode:getChildByName("Node")
    self.contents:setVisible(false)
    
    require "game.guide.view.NewFunctionEffect"
    self.visibleSize = cc.Director:getInstance():getVisibleSize()
    self.origin = cc.Director:getInstance():getVisibleOrigin()

    local posX = self.origin.x + self.visibleSize.width/2
    local posY = self.origin.y + self.visibleSize.height/2
    
    self.itemWidth = 60

    self:setPosition(posX, posY)
    


    local function onTouchBegan(touch, event) 
        return true
    end

    local function onTouchMoved(touch, event)
    end

    local function onTouchEnded(touch, event)
        if self._canClick then
            self._canClick = false
            self.contents:setVisible(false)
            --move
            self:moveFunction()
        end
    end

    local listener = cc.EventListenerTouchOneByOne:create()
    listener:registerScriptHandler(onTouchBegan,cc.Handler.EVENT_TOUCH_BEGAN )
    listener:registerScriptHandler(onTouchMoved,cc.Handler.EVENT_TOUCH_MOVED )
    listener:registerScriptHandler(onTouchEnded,cc.Handler.EVENT_TOUCH_ENDED )
    local eventDispatcher = self:getEventDispatcher()
    eventDispatcher:addEventListenerWithSceneGraphPriority(listener, self)
    listener:setSwallowTouches(true)
end

--function CopySelectLayer:removeEvent()
--
--end
--
--function CopySelectLayer:initEvent()
--
--end

function NewFunctionLayer:updateData()
    self.m_data = zzm.GuideModel.openNewFunction
    self.openFuncCount = #self.m_data
    self.maxFuncCount = self.openFuncCount
    if self.openFuncCount > 0 then
        self._myTimer = self._myTimer or require("game.utils.MyTimer").new()
        local function tick()
            self:showFunction(self.openFuncCount)
            self.openFuncCount = self.openFuncCount -1
            if self.openFuncCount <= 0 then
            	self._myTimer:stop()
            	
            	self._canClick = true
            	self.contents:setVisible(true)
            	--move
                --self:moveFunction()
            end
        end
        self._myTimer:start(1, tick)
    end

end

function NewFunctionLayer:showFunction(index)
    local funcId = self.m_data[index]
    if funcId then
        local data = zzm.GuideModel:getFunctionTipsById(funcId)
        if data then
            SceneManager.m_curScene:autoMove(data.ButtonName)
        end
        self.itemList[index] = NewFunctionEffect.create()
        self:addChild(self.itemList[index])
        if funcId == 2 then --奖励Icon
            self.itemList[index]:setjiangliIcon(data)
        else
            self.itemList[index]:setData(data)
        end
        
        if self.maxFuncCount == 2 then
            if index == 1 then
                self.itemList[index]:setPositionX(self.itemWidth)
            else
                self.itemList[index]:setPositionX(-self.itemWidth)
            end
        end
    end
end

function NewFunctionLayer:moveFunction()
    for index=1, #self.itemList do
        local funcId = self.m_data[index]
        local obj = zzc.GuideController:getFuncObj(funcId)
        local target = self.itemList[index]
        if target and obj then
        	local objpos = obj:convertToWorldSpace(cc.p(0,0))
            local tarpos = target:convertToNodeSpace(objpos)
            local size = obj:getContentSize()
            tarpos.x = tarpos.x + size.width*0.5
            tarpos.y = tarpos.y + size.height*0.5
            local action1 = cc.EaseSineInOut:create(cc.MoveBy:create(self._moveTimes*0.5,tarpos))
            local action2 = cc.CallFunc:create(function() target:removeFromParent()  target = nil end)
            local action3 = cc.CallFunc:create(function() cn:showRewardsGet(dxyConfig_toList(NewFunctionConfig:getNewFuncRewards(funcId).Rewards))end)
            local sequence = cc.Sequence:create(action1, action2 ,action3)
            target:runAction(sequence)
        end
    end
    
    self._myTimer = self._myTimer or require("game.utils.MyTimer").new()
    local function tick()
        self:removeFromParent()
        self._myTimer:stop()
        self._myTimer = nil
        zzc.GuideController:showNewFunction()
        zzc.GuideController._nextGuideMask = true
        zzc.GuideController._isRunning = false
        zzm.GuideModel.startNewGuide = true
        zzm.GuideModel.openNewFunction = {}
        
    end
    self._myTimer:start(self._moveTimes*0.5+0.1, tick)
end




