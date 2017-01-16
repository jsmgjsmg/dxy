StartEffect = StartEffect or class("StartEffect",function()
    return cc.Node:create()
end)

function StartEffect:ctor()
    self._data = nil
    self.m_timer = nil
end

function StartEffect:create()
    local node = StartEffect:new()
    node:init()
    return node    
end

function StartEffect:init()
    self._csb = cc.CSLoader:createNode("dxyCocosStudio/csd/ui/tilemap_test/StartEffect.csb")
    self:addChild(self._csb)

    self._tl = cc.CSLoader:createTimeline("dxyCocosStudio/csd/ui/tilemap_test/StartEffect.csb")
    self._csb:runAction(self._tl)
    self._tl:gotoFrameAndPlay(0,true)
end

function StartEffect:update(pos)
    self._data = pos
    self:setPosition(CMap:layerCoordForPosition(pos))
    
--    local gid = CMap:getGlobalGID(pos)
--    local timer = SociatyWarTiledMapConfig:getFindExpendTime(gid)
--    if not timer then --不存在探索则不显示CD
--        self:setVisible(false)
--    end
    
--    for key, var in pairs(zzm.StepTwoModel._arrCDTimer) do
--    	if var.posX == pos.x and var.posY == pos.y then
--            self:haveCD(var)
--    	    break
--    	end
--    end
end

function StartEffect:haveCD(var)
    if self.m_timer then return end
        
    self._csb:setVisible(false)
    local endTimer = 0
    self.m_timer = require ("game.utils.MyTimer").new()
    local function tick()
        endTimer = var.endTimer - (os.time() - _G.DiffTimer)
        if endTimer <= 0 then
            self:stopTimer()
        end
    end
    self.m_timer:start(1,tick)
end

--function StartEffect:startTimer(var)
--    if self.m_timer then return end    
--    local endTimer = 0
--    self.m_timer = require "game.utils.MyTimer"
--    local function tick()
--        endTimer = os.time() - _G.DiffTimer
--        endTimer = endTimer - 1 
--        if endTimer <= 0 then
--            self:stopTimer()
--        end
--    end
--    self.m_timer:start(1,tick)
--end

function StartEffect:stopTimer()
    if self.m_timer then
        self.m_timer:stop()
        self.m_timer = nil
	    self._csb:setVisible(true)
    end
end

function StartEffect:whenClose()
    self:stopTimer()
end