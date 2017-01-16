DropResource = DropResource or class("DropResource",function()
    return cc.Node:create()
end)

function DropResource:ctor()
    self.m_data = nil
    self.m_pos = nil
end

function DropResource:create()
    local node = DropResource:new()
    node:init()
    return node
end

function DropResource:init()
    self._dropResource = cc.CSLoader:createNode("dxyCocosStudio/csd/ui/tilemap_test/DropResource.csb")
    self:addChild(self._dropResource)
    self._dropImage = self._dropResource:getChildByName("Image")

    self._dropImage:setScale(0.5)
    
    local action1 = cc.MoveBy:create(0.8,cc.p(0,10))
    local action2 = cc.DelayTime:create(0.4)
    local action3 = cc.MoveBy:create(0.8,cc.p(0,-10))
    local action4 = cc.DelayTime:create(0.4)
    local sequence = cc.Sequence:create(action1,action2,action3,action4)
    local crepeat = cc.RepeatForever:create(sequence)
    
    self._dropImage:runAction(crepeat)
end

function DropResource:update(goods,pos)
    self.m_data = goods
    self.m_pos = pos
    if not self.m_data or not self.m_pos then return end
    if goods.type == 2 then --物品
        local idZone = math.modf(goods.value/1000)
        local config = GoodsConfigProvider:findGoodsById(goods.value)
        if idZone == 202 then--神将碎片
            self._dropImage:loadTexture("GodGeneralsIcon/"..config.Icon..".png")
        else --物品
            self._dropImage:loadTexture("Icon/"..config.Icon..".png")
        end
    else --数值
        self._dropImage:loadTexture(zzd.TaskData.arrGoodsIcon[goods.value])
    end
end
