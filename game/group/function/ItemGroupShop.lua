ItemGroupShop = ItemGroupShop or class("ItemGroupShop",function()
    return cc.Node:create()
end)
local PATH = "res/dxyCocosStudio/png/equip/"

function ItemGroupShop:ctor()

end

function ItemGroupShop:create()
    local node = ItemGroupShop.new()
    node:init()
    return node
end

function ItemGroupShop:init()
    self._csb = cc.CSLoader:createNode("dxyCocosStudio/csd/ui/groupfunc/ItemGroupShop.csb")
    self:addChild(self._csb)
    
    self._spColor = self._csb:getChildByName("spColor")
    self._spGoods = self._csb:getChildByName("spGoods")
    self._txtNum = self._csb:getChildByName("txtNum")
    self._txtName = self._csb:getChildByName("txtName")
    self._spGold = self._csb:getChildByName("gold")
    self._txtGold = self._spGold:getChildByName("txtGold")
    self._spIntegral = self._csb:getChildByName("integral")
    self._tj = self._csb:getChildByName("TJ")
    self._txtIntegral = self._spIntegral:getChildByName("txtIntegral")
    self._btnBuy = self._csb:getChildByName("btnBuy")
    self._btnBuy:addTouchEventListener(function(target,type)
        if type == 2 then
            zzc.GroupController:getGroupShop(self.m_data.Box,self._curType)
        end 
    end)
end

function ItemGroupShop:update(data)
    self.m_data = data
    if not self.m_data then
        return
    end
    if  self.m_data.Type == DefineConst.CONST_AWARD_GOODS or --6
        self.m_data.Type == DefineConst.CONST_AWARD_CHIP or  --10
        self.m_data.Type == DefineConst.CONST_AWARD_RAND_EQUIP or --22
        self.m_data.Type == DefineConst.CONST_AWARD_RAND_MAGICSOUL or --23
        self.m_data.Type == DefineConst.CONST_AWARD_RAND_GODCHIP then --24
        local data = GoodsConfigProvider:findGoodsById(self.m_data.GoodsId)
        self._spColor:setTexture(PATH.."spiritQuality_"..data.Quality..".png")
        self._txtName:setString(data.Name)
        self._txtName:setColor(Quality_Color[data.Quality])
        if  self.m_data.Type == DefineConst.CONST_AWARD_CHIP or --10
            self.m_data.Type == DefineConst.CONST_AWARD_RAND_GODCHIP then --24
            self._spGoods:setTexture("GodGeneralsIcon/"..data.Icon..".png")
        else
            self._spGoods:setTexture("Icon/"..data.Icon..".png")
        end
    else
        self._spGoods:setTexture(zzd.TaskData.arrGoodsIcon[self.m_data.Type])
        self._spColor:setTexture(PATH.."spiritQuality_1.png")
        self._txtName:setString(zzd.TaskData.arrStrType[self.m_data.Type])
    end
    self._txtNum:setString(self.m_data.Num)
    
    if self.m_data.State == DefineConst.CONST_EXCHANGE_SHOP_UNCLAIMED then -- 兑换商店类型--未领取
        self._btnBuy:setTouchEnabled(true)
        if self.m_data.Discount < 100 then
            self._tj:setVisible(true)
        end
    elseif self.m_data.State == DefineConst.CONST_EXCHANGE_SHOP_HAVE_TO_RECEIVE then
        self._btnBuy:setTouchEnabled(false)
        self._btnBuy:setBright(false)
        self._btnBuy:setTitleText("已兑换")
        self._spGold:setVisible(false)
        self._spIntegral:setVisible(false)
        self._tj:setVisible(false)
    end
end

function ItemGroupShop:changeValue(type)
    self._curType = type
    if self.m_data.State == DefineConst.CONST_EXCHANGE_SHOP_HAVE_TO_RECEIVE then
        self._btnBuy:setTitleText("已兑换")
        self._btnBuy:setBright(false)
        self._spGold:setVisible(false)
        self._spIntegral:setVisible(false)
        return
    end
    if type == 1 then --元宝
        self._spGold:setVisible(true)
        self._spIntegral:setVisible(false)
        self._txtGold:setString(math.ceil(self.m_data.NeedYB*self.m_data.Discount/100))
    else
        self._spGold:setVisible(false)
        self._spIntegral:setVisible(true)
        self._txtIntegral:setString(math.ceil(self.m_data.NeedINT*self.m_data.Discount/100))
    end
    self._btnBuy:setTitleText("")
end