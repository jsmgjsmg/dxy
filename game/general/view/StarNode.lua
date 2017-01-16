StarNode = StarNode or class("StarNode",function()
    return cc.Node:create()
end)

function StarNode:ctor()
    self._arrStar = {}
end

function StarNode:create()
    local node = StarNode:new()
    node:init()
    return node
end

function StarNode:init()
    self._csb = cc.CSLoader:createNode("res/dxyCocosStudio/csd/ui/general/StarNode.csb")
    self:addChild(self._csb)
    
    self._ndStar = self._csb:getChildByName("ndStar")
    for i=1,5 do
        self._arrStar[i] = self._ndStar:getChildByName("bg"..i):getChildByName("start")
    end
end

function StarNode:updateStar(star)
    if star then
        self._ndStar:setVisible(true)
        for i=1,star do
            self._arrStar[i]:setVisible(true)
        end
    else
        self._ndStar:setVisible(false)
    end
end