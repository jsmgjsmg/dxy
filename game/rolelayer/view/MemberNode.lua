local MemberNode = class("MemberNode",function()
    return cc.Node:create()
end)

function MemberNode:ctor()
    self._isMove = false
    self._curPosX = 1572
    self._curDirection = 1
end

function MemberNode:create()
    local node = MemberNode:new()
    node:init()
    return node
end

function MemberNode:init()
    self._csb = cc.CSLoader:createNode("dxyCocosStudio/csd/ui/rolelayer/MemberNode.csb")
    self:addChild(self._csb)
    self._moveSpeed = HeroConfig:getMoveSpeed()
    
    self._ndMember = self._csb:getChildByName("ndMember") 

--    local function update(dt)
--        if self._isMove then
--            local posX = self._ndMember:getPositionX()
--            if self._curDirection == 1 then
--                local affter = posX + dt * self._moveSpeed.MoveSpeed
--                if affter <= self._curPosX then
--                    self._ndMember:setPositionX(affter)
--                else
--                    self._isMove = false
--                    self._action:setAnimation(1,"ready", true)
--                end
--            elseif self._curDirection == -1 then
--                local affter = posX - dt * self._moveSpeed.MoveSpeed
--                if affter >= self._curPosX then
--                    self._ndMember:setPositionX(affter)
--                else
--                    self._isMove = false
--                    self._action:setAnimation(1,"ready", true)
--                end
--            end
--        end
--    end
--    self:scheduleUpdateWithPriorityLua(update,0)
end

function MemberNode:setData(data)
    self.m_data = data
    
    self.OssatureConfig = HeroConfig:getOssatureById(self.m_data.Pro)
    
    self._action = mc.SkeletonDataCash:getInstance():createWithCashName(self.OssatureConfig.Ossature)
    self._action:setAnimation(1,"ready", true)
    self._action:setAnchorPoint(0.5,0)
    self._action:setPosition(0,0)
    self._ndMember:addChild(self._action)
    
    local label = cc.Label:createWithTTF(self.m_data.Name,"dxyCocosStudio/font/MicosoftBlack.ttf",20)
    label:enableOutline(cc.c3b(0,0,0),2) --边框
    label:setAnchorPoint(cc.p(0.5, 0))  
    label:setPosition(cc.p(0,198))  
    self._ndMember:addChild(label)  
    
    self._ndMember:setPosition(self.m_data.PosX,self.m_data.PosY)
    self._curPosX = self.m_data.PosX
end

function MemberNode:Action(data)
    local function stopAllActions()
        self._ndMember:stopAllActions()
        self._action:setAnimation(1,"ready", true)
    end
    
    local abs = math.abs(self._curPosX - data.PosX)
    local pencent = abs / self._moveSpeed.MoveSpeed
    local moveBy = nil
    local timer = cn:round(1*pencent,1)
    if self._curPosX >= data.PosX then --左
        self._action:setScaleX(-1)
        self._action:setAnimation(1,"move", true)
        moveBy = cc.MoveBy:create(timer,cc.p(-abs,0))
    else                            --右
        self._action:setScaleX(1) 
        self._action:setAnimation(1,"move", true)
        moveBy = cc.MoveBy:create(timer,cc.p(abs,0))
    end
    self._curPosX = data.PosX
    
    local action = cc.Sequence:create(moveBy,cc.CallFunc:create(stopAllActions))
    self._ndMember:runAction(action)
end

return MemberNode
