
ButtonGuide = ButtonGuide or class("ButtonGuide",function()
    return cc.Layer:create()
end)

function ButtonGuide.create()
    local layer = ButtonGuide.new()
    return layer
end

function ButtonGuide:ctor()
    self._csbNode = nil
    self:initUI()
    
end

function ButtonGuide:initUI()
    self._csbNode = cc.CSLoader:getInstance():createNodeWithFlatBuffersFile("res/dxyCocosStudio/csd/ui/guide/ButtonGuide.csb")
    self:addChild(self._csbNode)

    self.visibleSize = cc.Director:getInstance():getVisibleSize()
    self.origin = cc.Director:getInstance():getVisibleOrigin()
    
    self.targetBtn = self._csbNode:getChildByName("Button")
    self.clickButton = self._csbNode:getChildByName("ClickButton")
    self.contentsBG = self._csbNode:getChildByName("StrBG")
    self.arrowIcon = self.targetBtn:getChildByName("ArrowRight")
	self.animNode = self.targetBtn:getChildByName("AnimNode")
	
	self.action = cc.CSLoader:createTimeline("res/dxyCocosStudio/csd/ui/guide/ButtonGuide.csb") 
    self.action:retain()
    self.action:gotoFrameAndPlay(0,true) 
    
    local contents = cc.Label:createWithTTF("","dxyCocosStudio/font/MicosoftBlack.ttf",20)
    contents:setDimensions(300,contents:getDimensions().height)
    contents:setAlignment(0)
    contents:setAnchorPoint(0,0)
    --contents:setString("g6sah4sa5hg46ash7s6h5dx3j4")
    self.contentsBG:addChild(contents)
    --contents:setPosition(15,20)

--    local contentsHeight = contents:getContentSize().height
--    self.contentsBG:setContentSize(300+30, contentsHeight+30)
    --self.titleBG:setPositionY(itemHeight-5)
    
    self.contents = contents

--    local posX = self.origin.x + self.visibleSize.width/2
--    local posY = self.origin.y + self.visibleSize.height/2
--
--    self:setPosition(0, 0)

    if not(SceneManager.m_curSceneName == "GameScene") then
    -- 拦截
    local function onTouchBegan(touch, event) 
        if self.clickButton then
            local location = touch:getLocation()
            local point = self.clickButton:convertToNodeSpace(location)
            local rect = cc.rect(0,0,self.clickButton:getContentSize().width,self.clickButton:getContentSize().height)
            if cc.rectContainsPoint(rect,point) == false then
                return true
            end
            return false
        end
    end

    local listener = cc.EventListenerTouchOneByOne:create()
    listener:registerScriptHandler(onTouchBegan,cc.Handler.EVENT_TOUCH_BEGAN )
    local eventDispatcher = self:getEventDispatcher()
    eventDispatcher:addEventListenerWithSceneGraphPriority(listener, self)
    listener:setSwallowTouches(true)
    end
    
    
    local function onTouchBegan(touch, event) 
        if self.clickButton then
            local location = touch:getLocation()
            local point = self.clickButton:convertToNodeSpace(location)
            local rect = cc.rect(0,0,self.clickButton:getContentSize().width,self.clickButton:getContentSize().height)
            if cc.rectContainsPoint(rect,point) then
                self._mClickInRect = true
            end
        end
        return true
    end

    local function onTouchMoved(touch, event)
    end

    local function onTouchEnded(touch, event)
        if self.clickButton then
            local location = touch:getLocation()
            local point = self.clickButton:convertToNodeSpace(location)
            local rect = cc.rect(0,0,self.clickButton:getContentSize().width,self.clickButton:getContentSize().height)
            if cc.rectContainsPoint(rect,point) and self._mClickInRect then
                self:removeFromParent()
			    if self.action then
					self.action:release()
					self.action = nil
				end
                -- next
                dxyDispatcher_dispatchEvent(dxyEventType.NextNewPlayerGuide)
            end
        end
        self._mClickInRect = false
    end

    local listener = cc.EventListenerTouchOneByOne:create()
    listener:registerScriptHandler(onTouchBegan,cc.Handler.EVENT_TOUCH_BEGAN )
    listener:registerScriptHandler(onTouchMoved,cc.Handler.EVENT_TOUCH_MOVED )
    listener:registerScriptHandler(onTouchEnded,cc.Handler.EVENT_TOUCH_ENDED )
    local eventDispatcher = self:getEventDispatcher()
    eventDispatcher:addEventListenerWithSceneGraphPriority(listener, self.clickButton)
end

function ButtonGuide:update(data)
    self.m_data = data 
    if self.m_data then
        local path = self.m_data.ButtonName
        local btn = zzc.GuideController:findObjectInScene(path)
        if btn then
            --print("-----------------------------update OK")
            local objpos = btn:convertToWorldSpace(cc.p(0,0))
            print("   objpos.x-----> " .. objpos.x .. "  objpos.y---->" .. objpos.y)
            local tarpos = self.targetBtn:convertToNodeSpace(objpos)
            print("   tarpos.x-----> " .. tarpos.x .. "  tarpos.y---->" .. tarpos.y)
			local size = btn:getContentSize()
			if path == "fightNode/fightBtn" then
				print("fightNode/fightBtn ----------------------------------------------------------------------- fightNode/fightBtn")
				size.height = size.height * 1.3
				size.width = size.width * 1.3
			end
            self.targetBtn:setPosition(objpos.x+size.width*0.5, objpos.y+size.height*0.5)
			self.animNode:setPosition(size.width*0.5, size.height*0.5)
	        self.clickButton:setPosition(objpos.x+size.width*0.5, objpos.y+size.height*0.5)
			if not(SceneManager.m_curSceneName == "GameScene") then
				self.clickButton:setContentSize(cc.size(size.width*0.8,size.height*0.8))
			else
				self.clickButton:setContentSize(cc.size(size.width,size.height))
			end
            self.targetBtn:setContentSize(cc.size(size.width+20,size.height+20))
            --local order = self.clickButton:getGlobalZOrder() +100
            --btn:setGlobalZOrder(order)
            --self.clickButton:setGlobalZOrder(order+1)
            self:setContentStr(self.m_data.TalkText)
            self:setLocalPos()
			self._csbNode:runAction(self.action) 
            zzc.GuideController._nextGuideMask = false
        end

    end
end

function ButtonGuide:setContentStr(str)
    self.contents:setString(str)
    local contentsHeight = self.contents:getContentSize().height
    self.contentsBG:setContentSize(300+50, contentsHeight+120)
    self.contents:setPosition(150,40)
end

function ButtonGuide:setLocalPos()
--    local d = self.m_data.Direction -- 1234
--    local a = self.m_data.Assemble -- 123
--    local posX = self.origin.x + self.visibleSize.width/2
--    local posY = self.origin.y + self.visibleSize.height/2
    local bgPos = dxyStringSplit(self.m_data.Direction, ",") --x,y
	if bgPos[1] == nil then
		bgPos[1] = 50
	end
	if bgPos[2] == nil then
		bgPos[2] = 75
	end
    
    local objpos = self.contentsBG:convertToWorldSpace(cc.p(0,0))
    self.contentsBG:setPosition(bgPos[1]*0.01*self.visibleSize.width,bgPos[2]*0.01*self.visibleSize.height)
    self.arrowIcon:setVisible(false)
    
--    self.contentsBG:setPosition(bgX,bgY)
--    local btnSize = self.targetBtn:getContentSize()
--    local arrowSize = self.arrowIcon:getContentSize()
--    local strBgSize = self.contentsBG:getContentSize()
--    local arrowX = 0
--    local bgX = 0
--    local arrowY = 0
--    local bgY = 0
--    local bgAX = 0
--    local bgAY = 0
--    if d == 1 then
--	    arrowX = (btnSize.width)*0.5
--        bgX = (a-1)*(btnSize.width)*0.5
--        arrowY = btnSize.height-20+(arrowSize.height-20)*0.5
--        bgY = btnSize.height-20+arrowSize.height-20-20+100
--        bgAX = (a-1)*0.5
--        bgAY = 0
--    elseif d == 2 then
--        arrowX = (btnSize.width)*0.5
--        bgX = (a-1)*(btnSize.width)*0.5
--        arrowY = (-arrowSize.height+40)*0.5
--        bgY = -arrowSize.height+30+20-100
--        bgAX = (a-1)*0.5
--        bgAY = 1
--        self.arrowIcon:setRotation(90)
--    elseif d == 3 then
--        arrowX = -(arrowSize.width-40)*0.5
--        bgX = -(arrowSize.width-40)
--        arrowY = btnSize.height*0.5
--        bgY = btnSize.height*0.5
--        bgAX = 1
--        bgAY = 0.5
--        self.arrowIcon:setRotation(180)
--    else
--        arrowX = btnSize.width+(arrowSize.width-40)*0.5
--        bgX = btnSize.width+(arrowSize.width-40)
--        arrowY = btnSize.height*0.5
--        bgY = btnSize.height*0.5
--        bgAX = 0
--        bgAY = 0.5
--        self.arrowIcon:setRotation(0)
--    end
--    self.arrowIcon:setPosition(arrowX,arrowY)
--	  self.arrowIcon:setVisible(false)
--    self.contentsBG:setAnchorPoint(bgAX,bgAY)
--    self.contentsBG:setPosition(bgX,bgY)
end

function ButtonGuide:removeEvent()

end

function ButtonGuide:initEvent()
    if(self.btn_back)then
        self.btn_back:addTouchEventListener(function(target,type)
            if(type==2)then
                zzc.CopySelectController:closeLayer()
            end
        end)
    end
    if(self.btn_addManual)then
        self.btn_addManual:addTouchEventListener(function(target,type)
            if(type==2)then

            end
        end)
    end
    if(self.btn_startReward)then
        self.btn_startReward:addTouchEventListener(function(target,type)
            if(type==2)then

            end
        end)
    end
end

function ButtonGuide:backCallBack()
--    local accout = self.input_account:getString()
--    local password = self.input_password:getString()
--    local gameScene = LoadingController.new():getScene()
--    SceneManager:enterScene(gameScene, "LoadingScene")
end


