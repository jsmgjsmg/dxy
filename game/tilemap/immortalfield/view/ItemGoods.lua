ItemGoods = ItemGoods or class("ItemGoods",function()
    return cc.Node:create()
end)


function ItemGoods.create()
    local item = ItemGoods.new()
    return item
end


function ItemGoods:ctor()
    self._csb = nil
    --self:initUI()

end


function ItemGoods:initUI(csb)
    self._csb = csb
    --self._csb = cc.CSLoader:createNode("dxyCocosStudio/csd/ui/immortalfield/ItemGoods.csb")
    self:addChild(self._csb)

    self.node = self._csb:getChildByName("Panel")
--    self.node = self.panel:getChildByName("Panel")

    self.spColor = self.node:getChildByName("spColor")
    self.spGoods = self.node:getChildByName("spGoods")
    self.txtName = self.node:getChildByName("txtName")

end

local PATH = "res/dxyCocosStudio/png/equip/"
function ItemGoods:update(goods)

    if not goods then
        self.node:setVisible(false)
        return
    end
    self.m_data = goods
    if goods.type == DefineConst.CONST_AWARD_GOODS or --6
        goods.type == DefineConst.CONST_AWARD_CHIP or  --10
        goods.type == DefineConst.CONST_AWARD_RAND_EQUIP or --22
        goods.type == DefineConst.CONST_AWARD_RAND_MAGICSOUL or --23
        goods.type == DefineConst.CONST_AWARD_RAND_GODCHIP then --24

        local data = GoodsConfigProvider:findGoodsById(goods.id)
        self.spColor:loadTexture(PATH.."spiritQuality_"..data.Quality..".png")
        self.txtName:setString(goods.count)
        self.txtName:setColor(Quality_Color[data.Quality])
        local idZone = math.modf(goods.id/1000)
        if idZone == 202 then
            self.spGoods:loadTexture("GodGeneralsIcon/"..data.Icon..".png")
        else
            self.spGoods:loadTexture("Icon/"..data.Icon..".png")
        end
        
--        local data = GoodsConfigProvider:findGoodsById(goods.id)
--        self.spColor:setTexture(PATH.."spiritQuality_"..data.Quality..".png")
--        self.txtName:setString(goods.count)
--        self.txtName:setColor(Quality_Color[data.Quality])
--        if  goods.type == DefineConst.CONST_AWARD_CHIP or --10
--            goods.type == DefineConst.CONST_AWARD_RAND_GODCHIP then --24
--            self.spGoods:setTexture("GodGeneralsIcon/"..data.Icon..".png")
--        else
--            self.spGoods:setTexture("Icon/"..data.Icon..".png")
--        end
    else
        self.spGoods:loadTexture(zzd.TaskData.arrGoodsIcon[goods.type])
        self.spColor:loadTexture(PATH.."spiritQuality_1.png")
        self.txtName:setString(goods.count)
    end

end
