GroupFunc = GroupFunc or class("GroupFunc",function()
    return cc.Layer:create()
end)

function GroupFunc:ctor()
    self.visibleSize = cc.Director:getInstance():getVisibleSize()
    self.origin = cc.Director:getInstance():getVisibleOrigin()
    self.visibleMember = {}
    self._lastPosX = 0
end

function GroupFunc:create()
    local node = GroupFunc:new()
    node:init()
    return node
end

function GroupFunc:init()
    self._csb = cc.CSLoader:createNode("GameScene/maps/XMCJ.csb")
    self:addChild(self._csb)
    local csbSize = self._csb:getContentSize()
    local rowGap = 1572 - self.visibleSize.width / 2
    self._csb:setPosition(-rowGap,0)
    
    dxyExtendEvent(self)
    --拦截
    dxySwallowTouches(self)
    
    local role = zzm.CharacterModel:getCharacterData()
    local enCAT = enCharacterAttrType
    self._uid = role:getValueByType(enCAT.UID)
    
    self._BgLayer = self._csb:getChildByName("BgLayer") 
    self._FarLayer = self._csb:getChildByName("FarLayer") 
    self._MidLayer = self._csb:getChildByName("MidLayer") 
    self._CloseLayer = self._csb:getChildByName("CloseLayer") 
    local ndFuncBtn = self._CloseLayer:getChildByName("ndFuncBtn")
    self._Node = self._CloseLayer:getChildByName("Node")

    local btnNPC2 = ndFuncBtn:getChildByName("btnNPC2")
    local btnRank = ndFuncBtn:getChildByName("btnRank")
    local btnMember = ndFuncBtn:getChildByName("btnMember")
    local btnMsg = ndFuncBtn:getChildByName("btnMsg")
    self.rectBtn = {
        [1] = btnNPC2,
        [2] = btnRank,
        [3] = btnMember,
        [4] = btnMsg,
    }
    
    btnNPC2:addTouchEventListener(function(target,type)
        if type == 2 then
            --祈福
			SoundsFunc_playSounds(SoundsType.OPEN_PAGE,false)
            zzc.GroupFuncCtrl:enterPrayNode()
        end
    end) 
    btnRank:addTouchEventListener(function(target,type)
        if type == 2 then
			SoundsFunc_playSounds(SoundsType.OPEN_PAGE,false)
            zzc.GroupFuncCtrl:enterTalent()
        end
    end)
    btnMember:addTouchEventListener(function(target,type)
        if type == 2 then
            --商店
			SoundsFunc_playSounds(SoundsType.OPEN_PAGE,false)
            zzc.GroupFuncCtrl:enterGroupShop()
        end
    end)
    btnMsg:addTouchEventListener(function(target,type)
        if type == 2 then
			SoundsFunc_playSounds(SoundsType.OPEN_PAGE,false)
            zzc.GroupController:showGroupListMember(true)
        end
    end)
    
    local function update(dt)
        if zzm.GroupModel.isMove then
            if zzm.GroupModel.Direction == 1 then
                self:moveForLeft(dt)
            elseif zzm.GroupModel.Direction == 2 then
                self:moveForRight(dt)
            end
        end
    end
    self:scheduleUpdateWithPriorityLua(update,0)
    self._moveSpeed = HeroConfig:getMoveSpeed()
    self._scene = SceneConfigProvider:getScenesConfig(20101)
    self._curPosX = -rowGap
    
---VisibleMember
    for i=1,#zzm.GroupModel.VisibleMember do
        local node = require("game.rolelayer.view.MemberNode"):create()
        self._CloseLayer:addChild(node)
        node:setData(zzm.GroupModel.VisibleMember[i])
        table.insert(self.visibleMember,node)
    end
    
--    self.m_timer = self.m_timer or require("game.utils.MyTimer").new()
--    local function tick()
--        zzc.GroupController:registerListenerMove(self._curPosX,60)
--    end
--    self._myGameServerTimer:start(2, tick)
end

function GroupFunc:initEvent()
    dxyDispatcher_addEventListener("GroupFunc_registerListenerMove",self,self.registerListenerMove)
    dxyDispatcher_addEventListener("GroupFunc_addMember",self,self.addMember)
    dxyDispatcher_addEventListener("GroupFunc_moveMember",self,self.moveMember)
    dxyDispatcher_addEventListener("GroupFunc_delMember",self,self.delMember)
end

function GroupFunc:removeEvent()
    dxyDispatcher_removeEventListener("GroupFunc_registerListenerMove",self,self.registerListenerMove)
    dxyDispatcher_removeEventListener("GroupFunc_addMember",self,self.addMember)
    dxyDispatcher_removeEventListener("GroupFunc_moveMember",self,self.moveMember)
    dxyDispatcher_removeEventListener("GroupFunc_delMember",self,self.delMember)
end

function GroupFunc:moveForLeft(dt)
    if zzc.GroupController:getLeadLayer():isMiddle(1) then
        local posBgLayerX = self._BgLayer:getPositionX()
        local posFarLayerX = self._FarLayer:getPositionX()
        local posMidLayerX = self._MidLayer:getPositionX()
        local posCloseLayerX = self._CloseLayer:getPositionX()
        local affter = self._curPosX + dt * self._moveSpeed.MoveSpeed
        if self:isBoundaryOfLeft(affter) then
            self._curPosX = affter
--            self._BgLayer:setPositionX(posBgLayerX - dt * self._moveSpeed.MoveSpeed * self._scene.BgLayerX/100)
            self._FarLayer:setPositionX(posFarLayerX + dt * self._moveSpeed.MoveSpeed * self._scene.FarLayerX/100)
            self._MidLayer:setPositionX(posMidLayerX + dt * self._moveSpeed.MoveSpeed * self._scene.MidLayerX/100)
            self._CloseLayer:setPositionX(posCloseLayerX + dt * self._moveSpeed.MoveSpeed * self._scene.CloseLayerX/100)
        else    
            dxyDispatcher_dispatchEvent("LeadLayer_moveForLeft",dt)
        end
    else
        dxyDispatcher_dispatchEvent("LeadLayer_moveForLeft",dt)
    end
end

function GroupFunc:moveForRight(dt)
    if zzc.GroupController:getLeadLayer():isMiddle(2) then
        local posBgLayerX = self._BgLayer:getPositionX()
        local posFarLayerX = self._FarLayer:getPositionX()
        local posMidLayerX = self._MidLayer:getPositionX()
        local posCloseLayerX = self._CloseLayer:getPositionX()
        local affter = self._curPosX - dt * self._moveSpeed.MoveSpeed
        if self:isBoundaryOfRight(affter) then
            self._curPosX = affter
--            self._BgLayer:setPositionX(posBgLayerX + dt * self._moveSpeed.MoveSpeed * self._scene.BgLayerX/100)
            self._FarLayer:setPositionX(posFarLayerX - dt * self._moveSpeed.MoveSpeed * self._scene.FarLayerX/100)
            self._MidLayer:setPositionX(posMidLayerX - dt * self._moveSpeed.MoveSpeed * self._scene.MidLayerX/100)
            self._CloseLayer:setPositionX(posCloseLayerX - dt * self._moveSpeed.MoveSpeed * self._scene.CloseLayerX/100)
        else
            dxyDispatcher_dispatchEvent("LeadLayer_moveForRight",dt)
        end
    else
        dxyDispatcher_dispatchEvent("LeadLayer_moveForRight",dt)
    end
end

function GroupFunc:isBoundaryOfLeft(s)
    if s <= 0 then
        return true
    else
        return false
    end
end

function GroupFunc:isBoundaryOfRight(s)
    if s + (-self.visibleSize.width) >= -self._scene.Width then
        return true
    else
        return false
    end
end

---可见成员Ctr
function GroupFunc:registerListenerMove(posx)
    local  pt = self._CloseLayer:convertToNodeSpace(posx)
    pt.x = cn:round(pt.x,0)
    if self._lastPosX == pt.x then
        return
    end
    self._lastPosX = pt.x
    zzc.GroupController:registerListenerMove(pt.x,60)
end

function GroupFunc:addMember(data)
    local node = require("game.rolelayer.view.MemberNode"):create()
    node:setData(data)
    table.insert(self.visibleMember,node)
    self._CloseLayer:addChild(node)
end

function GroupFunc:moveMember(data)
    for key, var in pairs(self.visibleMember) do
    	if var.m_data.Uid == data.Uid then
    	    var:Action(data)
    	end
    end
end

function GroupFunc:delMember(uid)
    for key, var in pairs(self.visibleMember) do
        if var.m_data.Uid == uid then
            self._CloseLayer:removeChild(var)
            table.remove(self.visibleMember,key)
        end
    end
end

function GroupFunc:BackFunc()
    self:addChild(self._csb)
end

function GroupFunc:checkRectContains(losPos)
    for key, var in pairs(self.rectBtn) do
        local toNode = var:convertToNodeSpace(losPos)
        local rectImage = cc.rect(0,0,var:getContentSize().width,var:getContentSize().height)
        if cc.rectContainsPoint(rectImage,toNode) then ---Image
            return false
        end
    end
    
    return true
end