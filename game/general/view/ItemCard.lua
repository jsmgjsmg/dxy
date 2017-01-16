ItemCard = ItemCard or class("ItemCard",function()
    return cc.Node:create()
end)

function ItemCard:ctor()
    self._data = nil
end

function ItemCard:create(data)
    local node = ItemCard:new()
    node:init(data)
    return node
end

function ItemCard:init(data)
    self._csb = cc.CSLoader:createNode("res/dxyCocosStudio/csd/ui/general/ItemCard.csb")
    self:addChild(self._csb)

    self._txtName = self._csb:getChildByName("txtName")
    local spColour = self._csb:getChildByName("spColour")

    if data[4] then
        self._btn = ccui.Button:create()
        data[1]:addChild(self._btn,2)
        local icon = GoodsConfigProvider:findGoodsById(data[4].Id).Icon
        self._btn:loadTextureNormal("res/GodGeneralsIcon/"..icon..".png")
        self._btn:loadTexturePressed("res/GodGeneralsIcon/"..icon..".png")
        self._btn:setPosition(data[2],data[3])
        self._btn:setBright(false)
        
        local colour = GodGeneralConfig:getMsgColour(data[4].Id,1).IconLittle
        spColour:setTexture("res/GodGeneralsIcon/"..colour)
        
        local has = false
        for key, var in pairs(zzm.GeneralModel.General.Card) do
            if var.Id == data[4].Id then
--                self._txtName:setColor(Quality_Color[data[4].Quality])
                has = true
                break
            else
                has = false
            end
        end
        
        if not has then
--            spColour:setColor(cc.c3b(80,80,80))
            self._txtName:setColor(cc.c3b(0,0,0))
        else
            self._txtName:setColor(Quality_Color[data[4].Quality])
        end
        
        
        
        
        spColour:setVisible(true)
	    self._btn:setName("Card_"..data[5])
    
        require "src.game.general.view.StarNode"
        self._starNode = StarNode:create()
        self._btn:addChild(self._starNode)
        self._starNode:setPosition(40.5,40.5)
        
        require "src.game.general.view.curFlag"
        self._curFlag = curFlag:create()
        self._btn:addChild(self._curFlag)
        self._curFlag:setPosition(40.5,40.5)
        self._curFlag:setVisible(false)
        
        self._txtName:setString(data[4].Name)
--        self._txtName:setColor(Quality_Color[data[4].Quality])

        self._btn:addTouchEventListener(function(target,type)
            if type == 2 then
                SoundsFunc_playSounds(SoundsType.OPEN_PAGE,false)
                require "src.game.general.view.GeneralMsg"
                local general = GeneralMsg:create(data[4])
                SceneManager:getCurrentScene():addChild(general)
            end
        end)
        
        for key, var in pairs(zzm.GeneralModel.General.Card) do
        	if var.Id == data[4].Id then
                self:upDate(var)
            end
        end
    else
        self._txtName:setVisible(false)
    end
end

function ItemCard:upDate(data)
    self._data = data
    if self._data then
        self._txtName:setVisible(true)
        local name = GodGeneralConfig:getNameByGID(data.Id)
        self._txtName:setString(name)
        self._txtName:setColor(Quality_Color[data.Quality])
        
--        local icon = GoodsConfigProvider:findGoodsById(data.Id).Icon
--        self._btn:loadTextureNormal("res/GodGeneralsIcon/"..icon..".png")
--        self._btn:loadTexturePressed("res/GodGeneralsIcon/"..icon..".png")
        self._btn:setBright(true)
        self._starNode:updateStar(data.Star)
        if data.isCur == 1 then
            self._curFlag:setVisible(true)
        else
            self._curFlag:setVisible(false)
        end
    end
end
