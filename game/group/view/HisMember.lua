HisMember = HisMember or class("HisMember",function()
    return cc.Node:create()
end)

function HisMember:ctor()

end

function HisMember:create(data)
    local node = HisMember:new()
    node:init(data)
    return node
end

function HisMember:init(data)
    self._csb = cc.CSLoader:createNode("res/dxyCocosStudio/csd/ui/group/HisMember.csb")
    self:addChild(self._csb)

    self._data = data
    
    self._head = self._csb:getChildByName("bghead"):getChildByName("head")
    self._head:setTexture("HeroIcon/IconSquare_10"..data.pro..".png")
    
    self._name = self._csb:getChildByName("name")
    self._name:setString(data["name"])
    
    self._lv = self._csb:getChildByName("lv")
    self._lv:setString(data["lv"])
    
    self._root = self._csb:getChildByName("post")
    self._root:setString(zzd.GroupData[data["root"]])
    
    self._power = self._csb:getChildByName("power")
    self._power:setString(data["power"])
    
end