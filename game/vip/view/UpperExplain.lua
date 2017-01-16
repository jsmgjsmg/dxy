local UpperExplain = class("UpperExplain",function()
    return cc.Node:create()
end)

function UpperExplain:ctor()
    self._arrText = {}
end

function UpperExplain:create(data)
    local node = UpperExplain:new()
    node:init(data)
    return node
end

function UpperExplain:init(data)
    self._csb = cc.CSLoader:createNode("dxyCocosStudio/csd/ui/vip/UpperExplain.csb")
    self:addChild(self._csb)
    local posX = 0
    for i=1,3 do
        self._arrText[i] = self._csb:getChildByName("Text"..i)
        if data["Explain"..i] and data["Explain"..i] ~= "" then
            self._arrText[i]:setString(data["Explain"..i])
            self._arrText[i]:setPositionX(posX)
            posX = posX + self._arrText[i]:getContentSize().width
        end
    end
end

return UpperExplain