LeadLayer = LeadLayer or class("LeadLayer",function()
    return cc.Layer:create()
end)
local LEFT = 1
local RIGHT = 2
local BEGIN = 0
local END = 2

function LeadLayer:ctor()
    self.winSize = cc.Director:getInstance():getVisibleSize()
    
    self._leftLock = true
    self._rightLock = true
    
    self._outLock = true
    self._intLock = true
    
    self.m_timer = nil
end

function LeadLayer:create()
    local layer = LeadLayer:new()
    layer:init()
    return layer
end

function LeadLayer:init()
    self._csb = cc.CSLoader:createNode("dxyCocosStudio/csd/ui/rolelayer/LeadLayer.csb")
    self:addChild(self._csb)
    local csbSize = self._csb:getContentSize()
    local rowGap = (self.winSize.width - csbSize.width) / 2
    local listGap = (self.winSize.height - csbSize.height) / 2
    self._csb:setPosition(0,0)
    
    dxyExtendEvent(self)
    
    self._ndRole = self._csb:getChildByName("ndRole")
    self._ndRole:setPositionX(self.winSize.width/2)
    
    local role = zzm.CharacterModel:getCharacterData()
    local enCAT = enCharacterAttrType
    self.OssatureConfig = HeroConfig:getOssatureById(role:getValueByType(enCAT.PRO))
    
    self._moveSpeed = HeroConfig:getMoveSpeed()
    
    self._action = mc.SkeletonDataCash:getInstance():createWithCashName(self.OssatureConfig.Ossature)
    self._action:setAnimation(1,"ready", true)
    self._action:setAnchorPoint(0.5,0)
    self._action:setPosition(0,0)
    self._ndRole:addChild(self._action)
    
    local label = cc.Label:createWithTTF(role:getValueByType(enCAT.NAME),"dxyCocosStudio/font/MicosoftBlack.ttf",20)
    label:enableOutline(cc.c3b(0,0,0),2)
    label:setTextColor(cc.c3b(255,200,0))
    label:setAnchorPoint(cc.p(0.5, 0))  
    label:setPosition(cc.p(0,198))  
    self._ndRole:addChild(label)  
    
    local ndUpRight = self._csb:getChildByName("ndUpRight")
    ndUpRight:setPosition(self.winSize.width,self.winSize.height)
    local ndData = ndUpRight:getChildByName("ndData")
    require "game.utils.TopDataNode"
    local data = TopDataNode:create()
    ndData:addChild(data)
    
    local ndLeft = self._csb:getChildByName("ndLeft")
    ndLeft:setPosition(0,0)

    local btnLeft = ndLeft:getChildByName("btnLeft")
    local btnRight = ndLeft:getChildByName("btnRight")
    btnLeft:addTouchEventListener(function(target,type)
        self:moveAt(type,LEFT)
    end)
    btnRight:addTouchEventListener(function(target,type)
        self:moveAt(type,RIGHT)
    end)
    
--RECT  
    self._Image = ndLeft:getChildByName("Image")
    self._LeftN = ndLeft:getChildByName("LeftN")
    self._LeftD = ndLeft:getChildByName("LeftD")
    self._RightN = ndLeft:getChildByName("RightN")
    self._RightD = ndLeft:getChildByName("RightD")
    
    local ndBtn = self._csb:getChildByName("ndBtn")
    ndBtn:setPosition(0,self.winSize.height)
    local btnBack = ndBtn:getChildByName("btnBack")
    btnBack:addTouchEventListener(function(target,type)
        if type == 2 then
			SoundsFunc_playSounds(SoundsType.CLOSE_PAGE,false)
            self:stopTimer()
            zzc.GroupController:closeLayer()
            zzc.GroupController:exitGroupFunc()
            zzm.GroupModel:cleanVisibleMenber()
        end
    end)
    
    local btnExit = ndBtn:getChildByName("btnExit")
    btnExit:addTouchEventListener(function(target,type)
        if type == 2 then
			SoundsFunc_playSounds(SoundsType.CLOSE_PAGE,false)
            self:stopTimer()
            zzc.GroupController:exitGroupFunc()
            zzc.GroupController:ExitGroup()
        end
    end)
    
    local function onTouchBegan(touch, event)
--        self.ctrl_timer = self.m_timer or require("game.utils.MyTimer").new()
--        local function tick()
    
    
            local LoPos = touch:getLocation()
            local toNode = self._Image:convertToNodeSpace(LoPos)
            local rectImage = cc.rect(0,0,self._Image:getContentSize().width,self._Image:getContentSize().height)
            if cc.rectContainsPoint(rectImage,toNode) then ---Image
                local rectLeft = cc.rect(0,0,self._Image:getContentSize().width / 2,self._Image:getContentSize().height)
                if cc.rectContainsPoint(rectLeft,toNode) then  ---Left
                    self._LeftN:setVisible(false)
                    self._LeftD:setVisible(true)
                    self._RightN:setVisible(true)
                    self._RightD:setVisible(false)
                    self:moveAt(BEGIN,LEFT)
                end
    
                local rectRight = cc.rect(self._Image:getContentSize().width / 2,0,self._Image:getContentSize().width / 2,self._Image:getContentSize().height)
                if cc.rectContainsPoint(rectRight,toNode) then  ---Right
                    self._LeftN:setVisible(true)
                    self._LeftD:setVisible(false)
                    self._RightN:setVisible(false)
                    self._RightD:setVisible(true)
                    self:moveAt(BEGIN,RIGHT)
                end
            else
                self._LeftN:setVisible(true)
                self._LeftD:setVisible(false)
                self._RightN:setVisible(true)
                self._RightD:setVisible(false)
                
                if LoPos.x <= self.winSize.width/2 then
                    self:moveAt(BEGIN,LEFT)
                else
                    self:moveAt(BEGIN,RIGHT)
                end
--                self._moveLock = true
--                return true
            end
            self._moveLock = true
            
            if LoPos.x < 350 and LoPos.y < 180  then
                return true
            else
--                return false
                local bool = zzc.GroupController:getFuncLayer():checkRectContains(LoPos)
                if not bool then
                    self:moveAt(END)
                end 
                return bool
                --判断是否在按钮上，   
                --在     return false
                --不在 return true
            end 
            
            
--        end
--        self.ctrl_timer:start(0.5, tick)
    end

    local function onTouchMoved(touch, event)
--        self:stopCtrlTimer()
        
    
        local LoPos = touch:getLocation()
        local toNode = self._Image:convertToNodeSpace(LoPos)
        local rectImage = cc.rect(0,0,self._Image:getContentSize().width,self._Image:getContentSize().height)
        if cc.rectContainsPoint(rectImage,toNode) then ---Image
            local rectLeft = cc.rect(0,0,self._Image:getContentSize().width / 2,self._Image:getContentSize().height)
            if cc.rectContainsPoint(rectLeft,toNode) then  ---Left
                if self._intLock then
                    self._LeftN:setVisible(false)
                    self._LeftD:setVisible(true)
                    self._RightN:setVisible(true)
                    self._RightD:setVisible(false)
                    if self._leftLock then
                        self:moveAt(BEGIN,LEFT)
                        self._leftLock = false
                        self._rightLock = true
                    end
                    self._outLock = false
                    self._intLock = true
                else
                    self:moveAt(END)
                end
            end

            local rectRight = cc.rect(self._Image:getContentSize().width / 2,0,self._Image:getContentSize().width / 2,self._Image:getContentSize().height)
            if cc.rectContainsPoint(rectRight,toNode) then  ---Right
                if self._intLock then
                    self._LeftN:setVisible(true)
                    self._LeftD:setVisible(false)
                    self._RightN:setVisible(false)
                    self._RightD:setVisible(true)
                    if self._rightLock then
                        self:moveAt(BEGIN,RIGHT)
                        self._rightLock = false
                        self._leftLock = true
                    end
                    self._outLock = false
                    self._intLock = true
                else
                    self:moveAt(END)
                end
            end
        else  ---点击屏幕位置
            self._LeftN:setVisible(true)
            self._LeftD:setVisible(false)
            self._RightN:setVisible(true)
            self._RightD:setVisible(false)
            
            if self._outLock then
                if LoPos.x <= self.winSize.width/2 then
                    if self._leftLock then
                        self:moveAt(BEGIN,LEFT)
                        self._leftLock = false
                        self._rightLock = true
                    end
                else
                    if self._rightLock then 
                        self:moveAt(BEGIN,RIGHT)
                        self._rightLock = false
                        self._leftLock = true
                    end
                end
                self._outLock = true
                self._intLock = false 
            else
                self:moveAt(END)
            end
        end
    end

    local function onTouchEnded(touch, event)
--        self:stopCtrlTimer()
    
        self:moveAt(END)
        self._LeftN:setVisible(true)
        self._LeftD:setVisible(false)
        self._RightN:setVisible(true)
        self._RightD:setVisible(false)
        self._leftLock = true
        self._rightLock = true
        self._outLock = true
        self._intLock = true
    end

    local listener = cc.EventListenerTouchOneByOne:create()
    listener:registerScriptHandler(onTouchBegan,cc.Handler.EVENT_TOUCH_BEGAN )
    listener:registerScriptHandler(onTouchMoved,cc.Handler.EVENT_TOUCH_MOVED )
    listener:registerScriptHandler(onTouchEnded,cc.Handler.EVENT_TOUCH_ENDED )
    local eventDispatcher = self:getEventDispatcher()
    eventDispatcher:addEventListenerWithSceneGraphPriority(listener, self)
    listener:setSwallowTouches(true)
    
    
    self.m_timer = self.m_timer or require("game.utils.MyTimer").new()
    local function tick()
        local data = self._ndRole:convertToWorldSpace(cc.p(0,0))
        dxyDispatcher_dispatchEvent("GroupFunc_registerListenerMove",data)
    end
    self.m_timer:start(1, tick)
    
    
    -----------------------------------------------------------------------------------------
    
    local Node_1 = self._csb:getChildByName("Node_1")
    local insert = Node_1:getChildByName("TextField")
    local btnJoin = Node_1:getChildByName("btnJoin")
    btnJoin:addTouchEventListener(function(target,type)
        if type == 2 then
            local id = tonumber(insert:getString())
            zzc.GroupController:JoinTeamTower(id)
        end
    end)
end

function LeadLayer:initEvent()
    dxyDispatcher_addEventListener("LeadLayer_moveForLeft",self,self.moveForLeft)
    dxyDispatcher_addEventListener("LeadLayer_moveForRight",self,self.moveForRight)
    dxyDispatcher_addEventListener("LeadLayer_stopTimer",self,self.stopTimer)
end

function LeadLayer:removeEvent()
    dxyDispatcher_removeEventListener("LeadLayer_moveForLeft",self,self.moveForLeft)
    dxyDispatcher_removeEventListener("LeadLayer_moveForRight",self,self.moveForRight)
    dxyDispatcher_removeEventListener("LeadLayer_stopTimer",self,self.stopTimer)
    self:stopTimer()
end

function LeadLayer:moveAt(type,dir)
    if type == BEGIN then
        zzm.GroupModel.isMove = true
        zzm.GroupModel.Direction = dir
        self._action:setAnimation(1,"move", true)
        if dir == LEFT then
            self._action:setScaleX(-1)
        elseif dir == RIGHT then
            self._action:setScaleX(1)
        end
    elseif type == END then
        zzm.GroupModel.isMove = false
        self._action:setAnimation(1,"ready", true)

--        local data = self._ndRole:convertToWorldSpace(cc.p(0,0))
--        dxyDispatcher_dispatchEvent("GroupFunc_registerListenerMove",data)
    end
end

function LeadLayer:isMiddle(dir)
    local posX = self._ndRole:getPositionX()
    if dir == LEFT then
        if posX <= self.winSize.width/2 then
            return true
        else
            return false
        end
    elseif dir == RIGHT then
        if posX >= self.winSize.width/2 then
            return true
        else
            return false
        end
    end
end

function LeadLayer:moveForLeft(dt)
    local posX = self._ndRole:getPositionX()
    local affter = posX - dt * self._moveSpeed.MoveSpeed
    if self:isBoundaryOfLeft(affter) then
        self._ndRole:setPositionX(affter)
    end
end

function LeadLayer:moveForRight(dt)
    local posX = self._ndRole:getPositionX()
    local affter = posX + dt * self._moveSpeed.MoveSpeed
    if self:isBoundaryOfRight(affter) then
        self._ndRole:setPositionX(affter)
    end
end

function LeadLayer:isBoundaryOfLeft(s)
    if s >= 226 then
        return true
    else
        return false
    end
end

function LeadLayer:isBoundaryOfRight(s)
    if s <= self.winSize.width - self.OssatureConfig.HurtX/2 then
        return true
    else
        return false
    end
end

function LeadLayer:stopTimer()
    if self.m_timer then
        self.m_timer:stop()
        self.m_timer = nil
    end
end

function LeadLayer:stopCtrlTimer()
    if self.ctrl_timer then
        self.ctrl_timer:stop()
        self.ctrl_timer = nil
    end
end