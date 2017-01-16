ItemFragmentShop = ItemFragmentShop or class("ItemFragmentShop",function()
    return cc.Node:create()
end)

function ItemFragmentShop:ctor()
    self._data = nil
end

function ItemFragmentShop:create(data)
    local node = ItemFragmentShop:new()
    node:init(data)
    return node
end

function ItemFragmentShop:init(data)
    self._csb = cc.CSLoader:createNode("res/dxyCocosStudio/csd/ui/general/ItemShop.csb")
    self:addChild(self._csb)

    self._txtNum = self._csb:getChildByName("txt_num")
    self._delCkb = self._csb:getChildByName("delCkb")
    self._txtBlue = self._csb:getChildByName("blue")
    self._spColor = self._csb:getChildByName("spColor")

    self._btn = ccui.Button:create()
    data[1]:addChild(self._btn,2)
    self._btn:setPosition(data[2],data[3])

    self._btn:addTouchEventListener(function(target,type)
        if type == 2 then
            SoundsFunc_playSounds(SoundsType.OPEN_PAGE,false)
            if self._data then
                local tips = require ("src.game.general.view.TipsOfExchange"):create(self._data)
                SceneManager:getCurrentScene():addChild(tips)
            end
        end
    end)
end

function ItemFragmentShop:upDateShop(data)
    self._data = data
    if self._data then
        self._btn:setVisible(true)
        local icon = GoodsConfigProvider:findGoodsById(self._data.Id).Icon
        self._btn:loadTextureNormal("res/GodGeneralsIcon/"..icon..".png")
        self._btn:loadTexturePressed("res/GodGeneralsIcon/"..icon..".png")
        
        local colour = GodGeneralConfig:getMsgColour(self._data.Id,1).IconLittle
        self._spColor:setTexture("res/GodGeneralsIcon/"..colour)
--        self._btn:loadTextureNormal("res/Icon/equip_kuzi.png")
--        self._btn:loadTexturePressed("res/Icon/equip_kuzi.png")
        self._txtNum:setString(GodGeneralConfig:getShopPrice(self._data["Quality"]))
    else
        self:Hide()
    end
end

function ItemFragmentShop:Hide()
    self._txtNum:setVisible(false)
    self._delCkb:setVisible(false)
    self._txtBlue:setVisible(false)
    self._spColor:setVisible(false)
end