--_G.NetHead = "http://dxy.7soul.com/Api/"                                         
--_G.NetHead = "http://dxy.vwoof.com/Api/"
--
--_G.g_acount_uuid = 0
--_G.g_acount_session_id = 0

NetManagerLua = NetManagerLua or class("NetManagerLua",{})

function NetManagerLua:ctor()
    self.listenerTable = {}
end

function NetManagerLua.create()
    local net = NetManagerLua.new()
    return net
end

_G.NetManagerLuaInst = _G.NetManagerLuaInst or NetManagerLua.create()

function NetManagerLua.instance()
    return _G.NetManagerLuaInst
end

function NetManagerLua:registerListenner(proId,reciver)
   if(self.listenerTable[proId] == nil) then
        self.listenerTable[proId] = {}
--        table.insert(self.listenerTable[proId], reciver)
--   else
--        table.insert(self.listenerTable[proId], reciver)
   end
   array_addObject(self.listenerTable[proId], reciver)
end

function NetManagerLua:unregisterListenner(proId,reciver)
   if self.listenerTable[proId] then
        array_removeObject(self.listenerTable[proId], reciver)
--        
--        local size = table.getn(self.listenerTable[proId])
--        for i=1 , size do
--            if self.listenerTable[proId][i] == reciver then
--                table.remove(self.listenerTable[proId],i)
--                break
--            end
--        end
   end
end



function NetManagerLua:dealAllMsg()
    local msg = mc.NetMannager:getInstance():getOneMsg() --获取消息
    while msg do
        local proId = msg:getCmd() --获取协议号（判断消息类型）
        print("~~~~~~~~~~~~~~~~~ proId ",proId)
        --print("Error ~~~~~~~~~~~~~~~~~ msg ",msg)
        
        dxyWaitBack:acceptNetProId(proId)
        
        local finalbool = false

        if self.listenerTable[proId] and table.getn(self.listenerTable[proId]) > 0 then
            local tableSize = table.getn(self.listenerTable[proId])
            
            for i=1,tableSize do
                local ret = self.listenerTable[proId][i]:dealMsg(msg)
                msg:resetCursor()
                if ret then
                    finalbool = true
                end
            end
        end
        
        if finalbool then break end
        
        msg = mc.NetMannager:getInstance():getOneMsg()
    end

end

function NetManagerLua:startUpdate()
    -- updateMsg
    local function tick()
        NetManagerLua.instance():dealAllMsg()
    end

    self._myTimer = self._myTimer or require("game.utils.MyTimer").new()
    self._myTimer:start(0.3, tick)
end

function NetManagerLua:stopUpdate()
    if self._myTimer then
	   self._myTimer:stop()
    end
end

