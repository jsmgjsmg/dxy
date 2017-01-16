MineModel = MineModel or class("MineModel",function()
    return cc.Node:create()
end)

function MineModel:ctor()
    self.visibleSize = cc.Director:getInstance():getVisibleSize()
    self.origin = cc.Director:getInstance():getVisibleOrigin()
    self._lastTilePos = {}
    self._isMoving = false
    self._isDiGui = false
    self._touchTimeList = {}
    self._touchTime = 0
    self._isOutsideStop = false
    self._arrFindPos = {
        cc.p(1.5,117.5),
        cc.p(3,119),
        cc.p(1.5,120.5),
        cc.p(0,122),
        cc.p(-1.5,120.5),
        cc.p(-3,119),
        cc.p(-1.5,117.5),
        cc.p(0,116),
    }
end

function MineModel:create()
    local node = MineModel:new()
    node:init()
    return node    
end

function MineModel:init()
    self._csb = cc.CSLoader:createNode("dxyCocosStudio/csd/ui/tilemap_test/MapModel.csb")
    self:addChild(self._csb)
    
    dxyExtendEvent(self)
    zzm.StepTwoModel:setLastView(CMap:viewCan(2,cc.p(zzm.StepTwoModel:getMyData().posX,zzm.StepTwoModel:getMyData().posY)))
    
    self._hpBase = SociatyWarTiledMapConfig:getWarBaseConfig("RecoverHp").Parameter / 100
    
    self._role = zzm.CharacterModel:getCharacterData()
    self._enCAT = enCharacterAttrType
    local pro = self._role:getValueByType(self._enCAT.PRO)
    
    self._txtName = self._csb:getChildByName("txtName")
    self._txtName:enableOutline(cc.c3b(0,0,0),2)
    self._txtName:setTextColor(cc.c3b(255,200,0))
    self._txtName:setString(self._role:getValueByType(self._enCAT.NAME))
    
    self._spFind = self._csb:getChildByName("find")
    self._spFind:setVisible(false)
    
    self._lbHP = self._csb:getChildByName("lbHp")
    self._model = self._csb:getChildByName("model")
    self.OssatureConfig = HeroConfig:getOssatureById(pro)
    if not self._action then 
        self._action = mc.SkeletonDataCash:getInstance():createWithCashName(self.OssatureConfig.Ossature)
        self._action:setMix("ready","move",0.2)
        self._action:setMix("move","ready",0.2)
        self._action:setAnimation(1,"ready", true)
        self._action:setAnchorPoint(0.5,0)
        self._action:setScale(0.4)
        self._model:addChild(self._action)
    end
    
    self:setData(zzm.StepTwoModel:getMyData())
end

function MineModel:initEvent()
    dxyDispatcher_addEventListener("MineModel_updateLBHp",self,self.updateLBHp)
end

function MineModel:removeEvent()
    dxyDispatcher_removeEventListener("MineModel_updateLBHp",self,self.updateLBHp)
    self:whenClose()
end

function MineModel:setData(data)
    local layerPos = CMap:layerCoordForPosition(cc.p(data.posX,data.posY))
    self:setPosition(layerPos.x,layerPos.y)
    self:updateLBHp()
end

function MineModel:touchMove(pos)
    local curPos = {}
    curPos.x,curPos.y = self._model:getPosition()
    self:setPosition(curPos.x + pos.x,curPos.y + pos.y)
end

--行走
function MineModel:walkMove(tilePos)
    if self._role:getValueByType(self._enCAT.PHYSICAL) < 1 then --没体力
        self:stopTimer()
        self._action:setAnimation(1,"ready", true)
        cn:TipsSchedule("体力不足")
        dxyDispatcher_dispatchEvent("TileMapLayer_initLinePoint",{})
        return
    end

    if tilePos.x == self._lastTilePos.x and tilePos.y == self._lastTilePos.y then --相同位置
        if not self._isDiGui then --不是递归
            self._isDiGui = false
            return
        end
    end
    self._lastTilePos.x = tilePos.x
    self._lastTilePos.y = tilePos.y
    
    table.insert(self._touchTimeList,tilePos)

    local startPos = CMap:layerCoordForPosition(cc.p(zzm.StepTwoModel:getMyData().posX,zzm.StepTwoModel:getMyData().posY))
    local endPos = nil
    local lineList = {}
    lineList = tileMapGridTool.GetGridsToTargetPos(cc.p(zzm.StepTwoModel:getMyData().posX,zzm.StepTwoModel:getMyData().posY),tilePos)
    if not lineList[1] then
        print("Error: tileMapGridTool.GetGridsToTargetPos == nil")
        self:stopTimer()
        self._touchTimeList = {}
        self._action:setAnimation(1,"ready", true)
        dxyDispatcher_dispatchEvent("TileMapLayer_initLinePoint",{})
        return
    end
    
---第一步
    local function callBack1()
        local view = CMap:viewCan(2,lineList[1])
        zzm.StepTwoModel:checkAllThings(view)
        zzc.StepTwoController:sendNextPos(lineList[1],1)
        zzm.StepTwoModel:setMyData(lineList[1])
        self:delDropResource(lineList[1])
        dxyDispatcher_dispatchEvent("TileMapLayer_delLinePoint",lineList[1])
        self._isMoving = false
        
        if self._isOutsideStop then --外界影响暂停移动
            self:stopTimer()
            self._touchTimeList = {}
            self._action:setAnimation(1,"ready", true)
            self._isOutsideStop = false
        end
        
        ----------------------------------------------------------------
        if self._touchTimeList[2] then
            table.remove(self._touchTimeList,1)
            local temp = {}
            for key, var in pairs(self._touchTimeList[1]) do
            	temp[key] = var
            end
            table.remove(self._touchTimeList,1)
            self._isDiGui = true
            self:stopTimer()
            self:walkMove(temp)
            return
        end
        ----------------------------------------------------------------
        
        if 2 <= #lineList then --是否有下一步
            zzc.StepTwoController:sendNextPos(lineList[2],0)
        end
        if #lineList == 1 then --只有一步
            self._action:setAnimation(1,"ready", true)
            table.remove(self._touchTimeList,1)
        end
    end
    if not self._isMoving then
        dxyDispatcher_dispatchEvent("TileMapLayer_initLinePoint",lineList)
        endPos = CMap:layerCoordForPosition(lineList[1])
        local actionMove = cc.Sequence:create(cc.MoveTo:create(1,cc.p(endPos.x,endPos.y)),cc.CallFunc:create(callBack1))
        self:runAction(actionMove)
        
        zzc.StepTwoController:sendNextPos(lineList[1],0)
        self._action:setAnimation(1,"move", true)
        
        self._isMoving = true
        
        if math.abs(endPos.x) > math.abs(self:getPositionX()) then
            self._action:setScaleX(0.4)
        elseif math.abs(endPos.x) < math.abs(self:getPositionX()) then
            self._action:setScaleX(-0.4)
        end
    end
    

---第二步以上    
    self:stopTimer()
    self._walkTimer = require("game.utils.MyTimer").new()
    local time = 1
    local callTimer = 1
    local function tick()
        time = time + 1
        if time > #lineList then
            self:stopTimer()
            return
        end
        
        if self._isOutsideStop then --外界影响暂停移动
            self:stopTimer()
            self._touchTimeList = {}
            self._action:setAnimation(1,"ready", true)
            self._isOutsideStop = false
            return
        end
        
        local function callBack2()
            callTimer = callTimer + 1

            self._isMoving = false
            local view = CMap:viewCan(2,lineList[callTimer])
            zzm.StepTwoModel:checkAllThings(view)
            zzc.StepTwoController:sendNextPos(lineList[callTimer],1)
            zzm.StepTwoModel:setMyData(lineList[callTimer])
            self:delDropResource(lineList[callTimer])
            dxyDispatcher_dispatchEvent("TileMapLayer_delLinePoint",lineList[callTimer])
            
            --------------------------------------------------------
            if self._touchTimeList[2] then
                table.remove(self._touchTimeList,1)
                local temp = {}
                for key, var in pairs(self._touchTimeList[1]) do
                    temp[key] = var
                end
                table.remove(self._touchTimeList,1)
                self._isDiGui = true
                self:stopTimer()
                self:walkMove(temp)
                return
            end
            --------------------------------------------------------
            
            if callTimer+1 <= #lineList then --是否有下一步
                zzc.StepTwoController:sendNextPos(lineList[callTimer+1],0)
            end
            if callTimer == #lineList then --最后一步
                self._action:setAnimation(1,"ready", true)
                table.remove(self._touchTimeList,1)
            end
        end
        
        if self._role:getValueByType(self._enCAT.PHYSICAL) < 1 then --没体力
            self:stopTimer()
            self._touchTimeList = {}
            self._action:setAnimation(1,"ready", true)
            dxyDispatcher_dispatchEvent("TileMapLayer_initLinePoint",{})
            return
        end
        
        endPos = CMap:layerCoordForPosition(lineList[time])
        local actionMove = cc.Sequence:create(cc.MoveTo:create(1,cc.p(endPos.x,endPos.y)),cc.CallFunc:create(callBack2))
        self:runAction(actionMove)
        
        self._isMoving = true
        
        startPos = CMap:layerCoordForPosition(lineList[time-1])
        if math.abs(endPos.x) > math.abs(self:getPositionX()) then
            self._action:setScaleX(0.4)
        elseif math.abs(endPos.x) < math.abs(self:getPositionX()) then
            self._action:setScaleX(-0.4)
        end
    end
    self._walkTimer:start(1, tick)
end

function MineModel:newFindEffect()
    self._spFind:setVisible(true)
    self._arrAction = {}
    for i=1,#self._arrFindPos do
        self._arrAction[i] = cc.MoveTo:create(0.15,self._arrFindPos[i])
    end
    local sequence = cc.Sequence:create(self._arrAction[1],self._arrAction[2],self._arrAction[3],self._arrAction[4],self._arrAction[5],self._arrAction[6],self._arrAction[7],self._arrAction[8])
    self._findEffect = cc.RepeatForever:create(sequence)
    self._spFind:runAction(self._findEffect)
end

--探索
function MineModel:stopFinding()
    self._spFind:setVisible(false)
    self._spFind:stopAllActions()
end

function MineModel:updateLBHp()
    local curHp = zzm.StepTwoModel:getMyData().curHp
    local maxHp = zzm.StepTwoModel:getMyData().maxHp
    if curHp >= maxHp then return end
    if curHp and maxHp then
        curHp = curHp + maxHp * self._hpBase
        if curHp > maxHp then
            curHp = maxHp
        end
    else
        return
    end

    zzm.StepTwoModel:getMyData().curHp = curHp
    local percent = curHp / maxHp * 100
    self._lbHP:setPercent(percent)
end

function MineModel:stopTimer()
    if self._walkTimer then
        self._walkTimer:stop()
        self._walkTimer = nil
    end
    self._lastTilePos = {}
end

function MineModel:outsideStop()
    if self._walkTimer then
        self._isOutsideStop = true
    end
    dxyDispatcher_dispatchEvent("TileMapLayer_initLinePoint",{})
end

function MineModel:whenClose()
    if self._action then
        self._model:removeAllChildren()
        self._action = nil
    end
    self:stopTimer()
end

function MineModel:delDropResource(pos)
    for key, var in pairs(zzm.StepTwoModel._arrResource) do
        if var.posX == pos.x and var.posY == pos.y then
            zzm.StepTwoModel:delArrResource(var)
        end
    end
end