local ItemBoss = class("ItemBoss",function()
    return cc.Node:create()
end)

function ItemBoss:ctor()

end

function ItemBoss:create(data)
    local node = ItemBoss:new()
    node:init(data)
    return node
end

function ItemBoss:init(data)
    self._csb = cc.CSLoader:createNode("res/dxyCocosStudio/csd/ui/worldboss/ItemBoss.csb")
    self:addChild(self._csb)
    
    local config = WorldBossConfig:getRewardByNum(data[2])
    
    local txtNum = self._csb:getChildByName("txtNum")
    if data[2] == 1 then
        txtNum:setString("1st")
    elseif data[2] == 2 then
        txtNum:setString("2nd")
    elseif data[2] == 3 then
        txtNum:setString("3rd")
    else
        txtNum:setString(data[2])
    end
    
    local spHead = self._csb:getChildByName("bgHead"):getChildByName("spHead")
    local hero = HeroConfig:getValueById(data[1].Pro)
    spHead:setTexture(hero.IconSquare)
    
    local txtName = self._csb:getChildByName("txtName")
    txtName:setString(data[1].Name)
    
    local txtOut = self._csb:getChildByName("txtOut")
    txtOut:setString(data[1].Harm)
    
    local txtRes = self._csb:getChildByName("txtRes")
    txtRes:setString(config.Renown)
end

return ItemBoss