ResourceItem = ResourceItem or class("ResourceItem",function()
	return cc.Node:create()
end)


function ResourceItem.create()
	local item = ResourceItem.new()
	return item
end


function ResourceItem:ctor()
	self._csb = nil
	self:initUI()
	
end


function ResourceItem:initUI()
	self._csb = cc.CSLoader:createNode("dxyCocosStudio/csd/ui/immortalfield/ResourceItem.csb")
	self:addChild(self._csb)
	
	self.node = self._csb:getChildByName("Node")
	
    self.spColor = self.node:getChildByName("spColor")
    self.spGoods = self.node:getChildByName("spGoods")
    self.txtName = self.node:getChildByName("txtName")
	
end

local PATH = "res/dxyCocosStudio/png/equip/"
function ResourceItem:update(goods)

    if not goods then
    	self.node:setVisible(false)
    	return
    end
    if goods.Type == DefineConst.CONST_AWARD_GOODS or --6
        goods.Type == DefineConst.CONST_AWARD_CHIP or  --10
        goods.Type == DefineConst.CONST_AWARD_RAND_EQUIP or --22
        goods.Type == DefineConst.CONST_AWARD_RAND_MAGICSOUL or --23
        goods.Type == DefineConst.CONST_AWARD_RAND_GODCHIP then --24

        local data = GoodsConfigProvider:findGoodsById(goods.Id)
        self.spColor:setTexture(PATH.."spiritQuality_"..data.Quality..".png")
        self.txtName:setString(" + "..goods.Num)
        self.txtName:setColor(Quality_Color[data.Quality])
        if  goods.Type == DefineConst.CONST_AWARD_CHIP or --10
            goods.Type == DefineConst.CONST_AWARD_RAND_GODCHIP then --24
            self.spGoods:setTexture("GodGeneralsIcon/"..data.Icon..".png")
        else
            self.spGoods:setTexture("Icon/"..data.Icon..".png")
        end
    else
        self.spGoods:setTexture(zzd.TaskData.arrGoodsIcon[goods.Type])
        self.spColor:setTexture(PATH.."spiritQuality_1.png")
        self.txtName:setString(" + "..goods.Num)
    end

end
