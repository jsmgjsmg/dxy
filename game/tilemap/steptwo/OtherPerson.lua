OtherPerson = OtherPerson or class("OtherPerson",function()
    return cc.Node:create()
end)
require "game.tilemap.steptwo.FightEffect"

function OtherPerson:ctor()
    self.m_data = nil   
    self._oldData = {}
    self._hpBase = 0
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
    self:init()    
end

function OtherPerson:init()
    self._csb = cc.CSLoader:createNode("dxyCocosStudio/csd/ui/tilemap_test/MapModel.csb")
    self:addChild(self._csb)
    self._person = self._csb:getChildByName("model")
    self._lbHP = self._csb:getChildByName("lbHp")
    self._txtName = self._csb:getChildByName("txtName")
    self._spFind = self._csb:getChildByName("find")
    self._spFind:setVisible(false)
    self._ndFight = self._csb:getChildByName("ndFight")
    
    dxyExtendEvent(self)
    
    self._hpBase = SociatyWarTiledMapConfig:getWarBaseConfig("RecoverHp").Parameter / 100
end

function OtherPerson:initEvent()

end

function OtherPerson:removeEvent()
    self:whenClose()
end

function OtherPerson:update(data)
    self.m_data = data
    if self.m_data then --add/update
        self._txtName:enableOutline(cc.c3b(0,0,0),2) --边框
        self._txtName:setString(self.m_data.name)
    
        if not self._action then
            local OssatureConfig = HeroConfig:getOssatureById(self.m_data.pro)
            self._action = mc.SkeletonDataCash:getInstance():createWithCashName(OssatureConfig.Ossature)
            self._action:setMix("ready","move",0.2)
            self._action:setMix("move","ready",0.2)
            self._action:setAnimation(1,"ready", true)
            self._action:setAnchorPoint(0.5,0)
            self._action:setScale(0.4)
            self._person:addChild(self._action)
        end
        
        local newLayerPos = CMap:layerCoordForPosition(cc.p(self.m_data.posX,self.m_data.posY))
        if self._oldData.uid then --update
            if self.m_data.isFind == 1 then --是否在探索
                self:newFindEffect()
            elseif self.m_data.isFind == 0 then
                self:stopFinding()
            end
            
            self:fightState(self.m_data)
        
            if self.m_data.posX ~= self._oldData.posX or self.m_data.posY ~= self._oldData.posY then
                local oldLayerPos = CMap:layerCoordForPosition(cc.p(self._oldData.posX,self._oldData.posY))
            
                if math.abs(newLayerPos.x) > math.abs(oldLayerPos.x) then --方向
                    self._action:setScaleX(0.4)
                elseif math.abs(newLayerPos.x) < math.abs(oldLayerPos.x) then
                    self._action:setScaleX(-0.4)
                end
                
                self._action:setAnimation(1,"move", true)
                local actionMove = cc.Sequence:create(cc.MoveTo:create(1,cc.p(newLayerPos.x,newLayerPos.y)),
                     cc.CallFunc:create(function() 
                                            self._action:setAnimation(1,"ready", true) 
                                            for key, var in pairs(zzm.StepTwoModel._arrResource) do
                                            	if var.posX == self.m_data.posX and var.posY == self.m_data.posY then
                                                    zzm.StepTwoModel:delArrResource(var)
                                            	end
                                            end
                                        end))
                self:runAction(actionMove)
            end
        else --init/add
            self:setPosition(newLayerPos.x,newLayerPos.y)
            self:updateLBHp()
            self:fightState(self.m_data)
            if self.m_data.isFind == 1 then --是否在探索
                self:newFindEffect()
            elseif self.m_data.isFind == 0 then
                self:stopFinding()
            end
        end
    else --del
        if self._action then
            self._person:removeAllChildren()
            self._action = nil
            self:removeFromParent()
        end
    end
    if self.m_data then
        for key, var in pairs(self.m_data) do
        	self._oldData[key] = var
        end
    else
        self._oldData = {}
    end
end

--Hp
function OtherPerson:updateLBHp()
    local curHp = self.m_data and self.m_data.curHp or nil
    local maxHp = self.m_data and self.m_data.maxHp or nil
    if curHp and maxHp then
        if curHp == maxHp then return end
        curHp = curHp + maxHp * self._hpBase
        if curHp > maxHp then
            curHp = maxHp
        end
    else
        return
    end
    
    self.m_data.curHp = curHp
    local percent = curHp / maxHp * 100
    self._lbHP:setPercent(percent)
end

--探索
function OtherPerson:newFindEffect()
    self._spFind:setVisible(true)
    self.m_data.isFind = 0
    self._arrAction = {}
    for i=1,#self._arrFindPos do
        self._arrAction[i] = cc.MoveTo:create(0.15,self._arrFindPos[i])
    end
    local sequence = cc.Sequence:create(self._arrAction[1],self._arrAction[2],self._arrAction[3],self._arrAction[4],self._arrAction[5],
    self._arrAction[6],self._arrAction[7],self._arrAction[8])
    self._findEffect = cc.RepeatForever:create(sequence)
    self._spFind:runAction(self._findEffect)
    
    
    local endTimer = SociatyWarTiledMapConfig:getFindExpendTime(CMap:getGlobalGID(cc.p(self.m_data.posX,self.m_data.posY))).ExpendTime
    if self._findTimer then
        self._findTimer:stop()
        self._findTimer = nil
    end
    self._findTimer = require("game.utils.MyTimer").new()
    local function stopFind()
        endTimer = endTimer - 1
        if endTimer < 1 then
            self._findTimer:stop()
            self._findTimer = nil
            self:stopFinding()
        end
    end
    self._findTimer:start(1,stopFind)
end

function OtherPerson:stopFinding()
    self._spFind:setVisible(false)
    self._spFind:stopAllActions()
end

--战斗Icon
function OtherPerson:fightState(data)
    if data.isWar == 1 then --战斗中
        local effect = FightEffect:create()
        self._ndFight:removeAllChildren()
        self._ndFight:addChild(effect)
        self._spFind:setVisible(false)
    elseif data.isWar == 0 then --退出战斗状态
        self._ndFight:removeAllChildren()
        
--        self.fight_timer = require "game.utils.MyTimer"
--        local function fightTick()
--            local curTimer = os.time() - _G.DiffTimer 
--            if data.invincible < curTimer or data.invincible == 0 then
--                self._ndFight:removeAllChildren()
--                self.fight_timer:stop()
--                self.fight_timer = nil
--            end
--        end
--        self.fight_timer:start(1,fightTick)
    end
end

function OtherPerson:whenClose()
    if self.fight_timer then
        self.fight_timer:stop()
        self.fight_timer = nil
    end
    if self._action then
        self._person:removeAllChildren()
        self._action = nil
    end
    if self._findTimer then             
        self._findTimer:stop()
        self._findTimer = nil
    end
end