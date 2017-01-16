TileMapLayer = TileMapLayer or class("TileMapLayer",function()
    return cc.Layer:create()
end)
require "game.tilemap.steptwo.MineModel"
require "game.tilemap.steptwo.OtherPerson"
require "game.tilemap.steptwo.FightEffect"
require "game.tilemap.steptwo.StartEffect"
require "game.tilemap.steptwo.DropResource"
require "game.tilemap.steptwo.LinePoint"

function TileMapLayer:ctor()
    self.visibleSize = cc.Director:getInstance():getVisibleSize()
    self.origin = cc.Director:getInstance():getVisibleOrigin()
    self._tileSize = {}
    self._mapSize = {}
    self._arrPerson = {}
    self._arrCDEffect = {}
    self._arrDropResource = {}
    self._arrLinePoint = {}
    self._touchLock = false
end

function TileMapLayer:create()
    local layer = TileMapLayer:new()
    layer:init()
    return layer
end

function TileMapLayer:init()
    self._tileMap = cc.TMXTiledMap:create("dxyCocosStudio/csd/ui/tilemap_tmx/map.tmx")
    self:addChild(self._tileMap)
    CMap:init(self._tileMap)
    
    dxyExtendEvent(self)
    
    self._tileMap:setPosition(CMap.MetaMin.x,CMap.MetaMin.y)
    
--    self._dropResource = cc.CSLoader:createNode("dxyCocosStudio/csd/ui/tilemap_test/DropResource.csb")
--    self._dropImage = self._dropResource:getChildByName("Image")

--    self._linePoint = cc.CSLoader:createNode("dxyCocosStudio/csd/ui/tilemap_test/LinePoint.csb")
--    self._pointImage = self._linePoint:getChildByName("Image")
    
    self._mineModel = MineModel:create()
    self._tileMap:addChild(self._mineModel,100)
    
    local list = CMap:viewCan(2,cc.p(zzm.StepTwoModel:getMyData().posX,zzm.StepTwoModel:getMyData().posY))
    
    self._tileSize = self._tileMap:getTileSize()
    self._mapSize = self._tileMap:getMapSize()
    
    local function onTouchBegan(touch, event) 
        self._beginLocation = touch:getLocation()
        return true
    end
    local function onTouchMoved(touch, event)
        self._disMove = touch:getDelta()
        local curPosition = {}
        curPosition.x,curPosition.y = self._tileMap:getPosition()
        curPosition.x = curPosition.x + self._disMove.x
        curPosition.y = curPosition.y + self._disMove.y
        
        if curPosition.x > CMap.MetaMin.x then    
            curPosition.x = CMap.MetaMin.x
        end
        if curPosition.x < CMap.MetaMax.x then
            curPosition.x = CMap.MetaMax.x
        end
        if curPosition.y > CMap.MetaMin.y then
            curPosition.y = CMap.MetaMin.y
        end
        if curPosition.y < CMap.MetaMax.y then
            curPosition.y = CMap.MetaMax.y
        end
        self._tileMap:setPosition(curPosition.x,curPosition.y)
--        zzc.TilemapController:getLayer():setViewPos(self._disMove)
    end
    local function onTouchEnded(touch, event)
        local endLocation = touch:getLocation()
        local diffPos = {x=endLocation.x - self._beginLocation.x,y=endLocation.y - self._beginLocation.y}
        if math.abs(diffPos.x) > 5 or math.abs(diffPos.y) > 5 then --滑动
            return
        else --点击
            local location = touch:getLocation()
            local offset = {}
            offset.x,offset.y = self._tileMap:getPosition()
            offset.x = location.x - offset.x
            offset.y = location.y - offset.y
            local tileCoord = CMap:tileCoordForPosition(offset)
            if tileCoord.x < 1 or tileCoord.x > CMap._mapSize.width-2 or tileCoord.y < 3 or tileCoord.y > CMap._mapSize.height-3 then --点解位置限制
                cn:TipsSchedule("无效位置")
            else
                if not self._touchLock then
                    self._mineModel:walkMove(tileCoord)
                    self._touchLock = true
                    
                    self._touchTimer = self._touchTimer or require("game.utils.MyTimer").new()
                    local function tick()
                        self._touchLock = false
                        self._touchTimer:stop()
                        self._touchTimer = nil
                    end
                    self._touchTimer:start(0.5,tick)
                end
            end
        end
    end
   
    local listener = cc.EventListenerTouchOneByOne:create()
    listener:registerScriptHandler(onTouchBegan,cc.Handler.EVENT_TOUCH_BEGAN )
    listener:registerScriptHandler(onTouchMoved,cc.Handler.EVENT_TOUCH_MOVED )
    listener:registerScriptHandler(onTouchEnded,cc.Handler.EVENT_TOUCH_ENDED )
    local eventDispatcher = self:getEventDispatcher()
    eventDispatcher:addEventListenerWithSceneGraphPriority(listener, self)
    listener:setSwallowTouches(true)
    
--其他玩家    
    for key, var in pairs(zzm.StepTwoModel.allPlayerData) do
        self:addPerson(var)
    end
    
--hp恢复timer    
    self.hp_timer = require("game.utils.MyTimer").new()
    local function hpTick()
        self._mineModel:updateLBHp()
        for key, var in pairs(self._arrPerson) do
        	var:updateLBHp()
        end
    end
    self.hp_timer:start(1,hpTick)
    
    self:initCDEffect()
    self:initDropResource(zzm.StepTwoModel._arrResource)
    self:setCurView(1)
end

function TileMapLayer:initEvent()
    dxyDispatcher_addEventListener("TileMapLayer_addPerson",self,self.addPerson)
    dxyDispatcher_addEventListener("TileMapLayer_delPerson",self,self.delPerson)
    dxyDispatcher_addEventListener("TileMapLayer_updatePerson",self,self.updatePerson)
    
    dxyDispatcher_addEventListener("TileMapLayer_addCDEffect",self,self.addCDEffect)   
    dxyDispatcher_addEventListener("TileMapLayer_delCDEffect",self,self.delCDEffect)
    dxyDispatcher_addEventListener("TileMapLayer_updateCDEffect",self,self.updateCDEffect)
    
    dxyDispatcher_addEventListener("TileMapLayer_addDropResource",self,self.addDropResource)
    dxyDispatcher_addEventListener("TileMapLayer_delDropResource",self,self.delDropResource)
    
    dxyDispatcher_addEventListener("TileMapLayer_OtherNewFind",self,self.OtherNewFind)
    
    dxyDispatcher_addEventListener("TileMapLayer_initLinePoint",self,self.initLinePoint)
    dxyDispatcher_addEventListener("TileMapLayer_delLinePoint",self,self.delLinePoint)
end

function TileMapLayer:removeEvent()
    dxyDispatcher_removeEventListener("TileMapLayer_addPerson",self,self.addPerson)
    dxyDispatcher_removeEventListener("TileMapLayer_delPerson",self,self.delPerson)
    dxyDispatcher_removeEventListener("TileMapLayer_updatePerson",self,self.updatePerson)
    
    dxyDispatcher_removeEventListener("TileMapLayer_addCDEffect",self,self.addCDEffect)
    dxyDispatcher_removeEventListener("TileMapLayer_delCDEffect",self,self.delCDEffect)
    dxyDispatcher_removeEventListener("TileMapLayer_updateCDEffect",self,self.updateCDEffect)
    
    dxyDispatcher_removeEventListener("TileMapLayer_addDropResource",self,self.addDropResource)
    dxyDispatcher_removeEventListener("TileMapLayer_delDropResource",self,self.delDropResource)
    
    dxyDispatcher_removeEventListener("TileMapLayer_OtherNewFind",self,self.OtherNewFind)
    
    dxyDispatcher_removeEventListener("TileMapLayer_initLinePoint",self,self.initLinePoint)
    dxyDispatcher_removeEventListener("TileMapLayer_delLinePoint",self,self.delLinePoint)
end

--看回当前视角
function TileMapLayer:setCurView(n)
    local newViewPos = {}
    local oldViewPos = {}
    local modelPos = {}
    oldViewPos.x,oldViewPos.y = self._tileMap:getPosition()
    modelPos.x,modelPos.y = self._mineModel:getPosition()
    ---x
    if modelPos.x - self.visibleSize.width/2 < math.abs(CMap.MetaMin.x) then --最小x边界
        newViewPos.x = CMap.MetaMin.x
    elseif modelPos.x - self.visibleSize.width/2 > math.abs(CMap.MetaMax.x) then --最大x边界
        newViewPos.x = CMap.MetaMax.x
    else
        newViewPos.x = -(modelPos.x - self.visibleSize.width/2)
    end
    
    ---y
    if modelPos.y - self.visibleSize.height/2 < math.abs(CMap.MetaMin.y) then --最小Y边界
        newViewPos.y = CMap.MetaMin.y
    elseif modelPos.y - self.visibleSize.height/2 > math.abs(CMap.MetaMax.y) then --最大y边界
        newViewPos.y = CMap.MetaMax.y
    else 
        newViewPos.y = -(modelPos.y - self.visibleSize.height/2)
    end
    
    local allAction = nil
    if n == 1 then --通知服务器进入场景完成
        local function ready()
            zzc.StepTwoController:register_readyScene()
        end
        local action1 = cc.EaseSineOut:create(cc.MoveTo:create(0.5,cc.p(newViewPos.x , newViewPos.y)))
        local action2 = cc.CallFunc:create(ready)
        allAction = cc.Sequence:create(action1,action2)
    else    
        allAction = cc.EaseSineOut:create(cc.MoveTo:create(0.5,cc.p(newViewPos.x , newViewPos.y)))
    end
    self._tileMap:runAction(allAction)
end

---otherPlayers
--新增其他玩家
function TileMapLayer:addPerson(data)
    local person = OtherPerson.new()
    person:update(data)
    self._tileMap:addChild(person,99)
    table.insert(self._arrPerson,person)
end
--删除其他玩家
function TileMapLayer:delPerson(uid)
    for key, var in pairs(self._arrPerson) do
        if var.m_data.uid == uid then
    	    var:update()
    	    table.remove(self._arrPerson,key)
    	    break
    	end
    end
end
--更新其他玩家
function TileMapLayer:updatePerson(data)
    for key, var in pairs(self._arrPerson) do
        if var.m_data.uid == data.uid then
            var:update(data)
            break
        end
    end
end

---路线图标
--init
function TileMapLayer:initLinePoint(line)
    for key1, var1 in pairs(self._arrLinePoint) do
    	if var1 then
    	    var1:removeFromParent()
    	end
    end
    self._arrLinePoint = {}
    for i=1,#line do
        local point = LinePoint:create()
        point:update(line[i])
        self._tileMap:addChild(point,97)
        table.insert(self._arrLinePoint,point)
    end
end
--del
function TileMapLayer:delLinePoint(pos)
    for key, var in pairs(self._arrLinePoint) do
    	if var.m_pos.x == pos.x and var.m_pos.y == pos.y then
    	    var:removeFromParent()
            table.remove(self._arrLinePoint,key)
            break
    	end
    end
end

---CD特效
--init
function TileMapLayer:initCDEffect()
    local view = CMap:viewCan(2,cc.p(zzm.StepTwoModel:getMyData().posX,zzm.StepTwoModel:getMyData().posY))
    for i=1,#view do
        local gid = CMap:getGlobalGID(view[i])
        local timer = SociatyWarTiledMapConfig:getFindExpendTime(gid).ExploreCd
        if timer then --不存在探索则不显示CD
            local effect = StartEffect:create()
            effect:update(view[i])
            self._tileMap:addChild(effect,97)
            table.insert(self._arrCDEffect,effect)

            for key, var in pairs(zzm.StepTwoModel._arrCDTimer) do
                if var.posX == view[i].x and var.posY == view[i].y then
                    effect:haveCD(var)
                    break
                end
            end
        end
    end
end
--add
function TileMapLayer:addCDEffect(data)
    local effect = StartEffect:create()
    effect:update(data)
    self._tileMap:addChild(effect,97)
    table.insert(self._arrCDEffect,effect)
end
--del
function TileMapLayer:delCDEffect(data)
    for key, var in pairs(self._arrCDEffect) do
    	if var._data.x == data.x and var._data.y == data.y then
    	    var:whenClose()
    	    var:removeFromParent()
    	    table.remove(self._arrCDEffect,key)
    	    break
    	end
    end
end
--存在CD
function TileMapLayer:updateCDEffect(data)
--    local endTimer = 0
--    local function check()
--        endTimer = endTimer + 0.3
--        if endTimer > 1.5 then
--    	    self.m_checkTimer:stop()
--    	    self.m_checkTimer = nil
--        end
        for key, var in pairs(self._arrCDEffect) do
            if var._data.x == data.posX and var._data.y == data.posY then
        	    var:haveCD(data)
--        	    self.m_checkTimer:stop()
--        	    self.m_checkTimer = nil
        	    break
        	end
        end
--    end
--    
--    self.m_checkTimer = require("game.utils.MyTimer").new()
--    self.m_checkTimer:start(0.3,check)
end

---资源掉落
--init
function TileMapLayer:initDropResource(data)
    for i=1,#data do
        for j=1,#data[i].goods do
            local drop = DropResource:create()
            drop:update(data[i].goods[j],cc.p(data[i].posX,data[i].posY))
            drop:setPosition(CMap:layerCoordForPosition(cc.p(data[i].posX,data[i].posY)))
            self._tileMap:addChild(drop,98)
            table.insert(self._arrDropResource,drop)
        end
    end
end
--add
function TileMapLayer:addDropResource(data)
    for j=1,#data.goods do
        local drop = DropResource:create()
        drop:update(data.goods[j],cc.p(data.posX,data.posY))
        drop:setPosition(CMap:layerCoordForPosition(cc.p(data.posX,data.posY)))
        self._tileMap:addChild(drop,98)
        table.insert(self._arrDropResource,drop)
    end
end
--del
function TileMapLayer:delDropResource(data)
    local keyList = {}
    for key, var in pairs(self._arrDropResource) do
    	if var.m_pos.x == data.posX and var.m_pos.y == data.posY then
    	    var:removeFromParent()
            table.insert(keyList,key)
    	end
    end
    
    for i=1, #keyList do
        table.remove(self._arrDropResource,keyList[i]-i+1)
    end
end

function TileMapLayer:whenClose()

    self._mineModel:whenClose()
    if self._arrPerson[1] then
        for key, var in pairs(self._arrPerson) do
        	if var.m_data then
        	   var:whenClose()
        	   var:removeFromParent()
    	    end
        end
    end
    
    if self.hp_timer then
        self.hp_timer:stop()
        self.hp_timer = nil
    end
    
    if self.m_checkTimer then
        self.m_checkTimer:stop()
        self.m_checkTimer = nil
    end
    
    for key, var in pairs(self._arrCDEffect) do
    	var:whenClose()
    end
    
    zzm.StepTwoModel:whenClose()
    zzc.StepTwoController._haveData = false
    zzc.StepTwoController:closeTileLayer()
end
