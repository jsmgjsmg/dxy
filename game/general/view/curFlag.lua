curFlag = curFlag or class("curFlag",function()
    return cc.Node:create()
end)

function curFlag:ctor()

end

function curFlag:create()
    local node = curFlag:new()
    node:init()
    return node
end

function curFlag:init()
    self._csb = cc.CSLoader:createNode("res/dxyCocosStudio/csd/ui/general/curFlag.csb")
    self:addChild(self._csb)
end