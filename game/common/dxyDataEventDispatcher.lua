--[[
require "game.common.dxyDataEventDispatcher"

local data = {
    prop1 = 1,
    prop2 = "sjgos",
}

function obj:fx(args)
	print("obj:fx prop1:" .. self.prop1 .. " prop2:" .. self.prop2 .. " args:" .. args)
end

local EventA = 1
dxyDispatcher_addEventListener(EventA, obj, obj.fx)
dxyDispatcher_dispatchEvent(EventA, {111,"AAA"})
dxyDispatcher_removeEventListener(EventA, obj, obj.fx)
dxyDispatcher_addEventListener(EventA, obj, obj.fx)
dxyDispatcher_dispatchEvent(EventA, {222,"BBB"})

--]]

local removeLock
local removeWait={}
dxyDataEventDispatcher = {
    list = {}
}
function dxyDispatcher_addEventListener(key, target, callBackFunc)
    if dxyDataEventDispatcher.list[key] == nil then
        dxyDataEventDispatcher.list[key] = { {target, callBackFunc} }
    else
        array_addObject(dxyDataEventDispatcher.list[key], {target, callBackFunc})
    end

end

function dxyDispatcher_dispatchEvent(key, args)
    if dxyDataEventDispatcher.list[key]==nil then
        return
    end
    removeLock=true
    local loop = #dxyDataEventDispatcher.list[key]
    local t, f
--    print(loop .. "-------------->" .. key)
    for i=1,loop,1 do
        t = dxyDataEventDispatcher.list[key][i][1] --self
        f = dxyDataEventDispatcher.list[key][i][2] --callback
        f(t, args)
    end
    for i=1,#removeWait,1 do
        table.remove(dxyDataEventDispatcher.list[removeWait[i][1]], removeWait[i][2])
    end
    while(#removeWait>0)do
        table.remove(removeWait)
    end
    removeLock=false
end

function dxyDispatcher_removeEventListener(key, target, callBackFunc)
    local loop = #dxyDataEventDispatcher.list[key]
    for i=loop,1,-1 do
        if dxyDataEventDispatcher.list[key][i][1]==target and dxyDataEventDispatcher.list[key][i][2]==callBackFunc then
            if removeLock then
                table.insert(removeWait, {key,i})
            else
                table.remove(dxyDataEventDispatcher.list[key], i)
            end
            return
        end
    end
end

function dxyDispatcher_resetAll()
	removeLock = false
	removeWait={}
	dxyDataEventDispatcher = {
		list = {}
	}
end