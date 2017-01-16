ItemFirstGoods = ItemFirstGoods or class("ItemFirstGoods",function()
    return cc.Node:create()
end)
local PATH = "res/dxyCocosStudio"

function ItemFirstGoods:ctor()

end

function ItemFirstGoods:create(i)
    local node = ItemFirstGoods:new()
    node:init(i)
    return node
end

function ItemFirstGoods:init(i)
    self._csb = cc.CSLoader:createNode("res/dxyCocosStudio/csd/ui/recharge/ItemFirstGoods.csb")
    self:addChild(self._csb)

    local BG = self._csb:getChildByName("BG")
    local spGoods = BG:getChildByName("spGoods")
    local txtGoods = BG:getChildByName("txtGoods")
    
    local tl = cc.CSLoader:createTimeline("dxyCocosStudio/csd/ui/recharge/ItemFirstGoods.csb") 
    self._csb:runAction(tl) 
    tl:gotoFrameAndPlay(0,true) 
    
    local goods = RechargeConfig:getFirstGoods(i)
    txtGoods:setString(goods["str"])
    spGoods:setTexture("res/Icon/"..goods["Icon"])
    if goods["Goods"] then
        txtGoods:setString(goods["Goods"].Name.."×"..goods["Num"])
    end
end
