local UnderExplain = class("UnderExplain",function()
    return cc.Node:create()
end)

function UnderExplain:ctor()
    self._arrText = {}
end

function UnderExplain:create(data,j)
    local node = UnderExplain:new()
    node:init(data,j)
    return node
end

function UnderExplain:init(data,j)
    self._csb = cc.CSLoader:createNode("dxyCocosStudio/csd/ui/vip/UnderExplain.csb")
    self:addChild(self._csb)
    
    local txtNum = self._csb:getChildByName("txtNum")
    txtNum:setString(j.."、")
    
    local posX = 41
    for i=1,2 do
        self._arrText[i] = self._csb:getChildByName("Text"..i)
        if data["Explain"..i] and data["Explain"..i] ~= "" then
            self._arrText[i]:setString(data["Explain"..i])
            self._arrText[i]:setPositionX(posX)
            posX = posX + self._arrText[i]:getContentSize().width
        end
    end
end

return UnderExplain