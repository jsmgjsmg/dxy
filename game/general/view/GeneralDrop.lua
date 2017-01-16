GeneralDrop = GeneralDrop or class("GeneralDrop",function()
    return cc.Node:create()
end)

function GeneralDrop:ctor()
    self._data = nil
    self._arrDrop = {}
end

function GeneralDrop:create()
    local node = GeneralDrop:new()
    node:initDrop()
    return node
end

function GeneralDrop:initDrop()
    self._csb = cc.CSLoader:createNode("res/dxyCocosStudio/csd/ui/general/GeneralDrop.csb")
    self:addChild(self._csb)
    
    self._Goods = self._csb:getChildByName("bg"):getChildByName("goods")
    local ndDrop = self._csb:getChildByName("nd_drop")
    for i=1,6 do
        self._arrDrop[i] = ndDrop:getChildByName("drop"..i):getChildByName("btnDrop")
        self._arrDrop[i]:setVisible(false)
    end
end

function GeneralDrop:setGoodsDrop(data)
    self._data = data
    if self._data then
        self._Goods:loadTextureNormal()
        self._Goods:loadTexturePressed()
    else
        self._Goods:setVisible(false)
    end
end
