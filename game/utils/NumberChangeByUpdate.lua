NumberChangeByUpdate = NumberChangeByUpdate or class("NumberChangeByUpdate",function()
    return cc.Node:create()
end)

function NumberChangeByUpdate:create()
    local numberChangeByUpdate = NumberChangeByUpdate:new()
    return numberChangeByUpdate
end

function NumberChangeByUpdate:ctor()
    self._min = 0
    self._max = 1000
    self._curTime = 0
    self._totalTime = 2
    self._label = nil
end

function NumberChangeByUpdate:update()
    
    if self._curTime >= self._totalTime then return end
    
    self._curTime = self._curTime + self._dt
    
    if self._curTime > self._totalTime then
        self._curTime = self._totalTime
        self._label:setString(""..self._max)
    else
        local persent = self._curTime / self._totalTime
        local finanlNum = self._min + self._dis * persent
        self._label:setString(""..finanlNum)
    end
    
end

function NumberChangeByUpdate:init()
    
end

function NumberChangeByUpdate:initByPam(min,max,lable,time,dt)

    self._min = min
    self._max = max
    self._dis = max - min
    self._curTime = 0
    self._totalTime = time
    self._label = lable
    self._dt = dt
    
    self._label:setString(""..min)
    
    require "game.utils.GetIntPart"
    
    local function update()
        if self._curTime >= self._totalTime then return end

        local rate = math.random(900,1100)
        rate = rate / 1000
        
        self._curTime = self._curTime + self._dt * rate

        if self._curTime > self._totalTime then
            self._curTime = self._totalTime
            self._label:setString(""..self._max)
        else
            local persent = self._curTime / self._totalTime
            local finanlNum = self._min + self._dis * persent
            finanlNum = GetIntPart(finanlNum)
            print("finanl = "..finanlNum)
            self._label:setString(""..finanlNum)
        end
    end
    
    schedule(self,update,dt)
    
end