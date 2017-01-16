ItemBox = ItemBox or class("ItemBox",function()
    return cc.Node:create()
end)

function ItemBox:ctor()
    self._data = nil
end

function ItemBox:create(data)
    local node = ItemBox:new()
    node:init(data)
    return node
end

function ItemBox:init(data)
    self._csb = cc.CSLoader:createNode("res/dxyCocosStudio/csd/ui/general/ItemBox.csb")
    self:addChild(self._csb)
    
    self._spColour = self._csb:getChildByName("spColour")
    
    self._btn = ccui.Button:create()
    data[1]:addChild(self._btn,2)
    self._btn:setPosition(data[2],data[3])
    self._btn:setName("Fragment_"..data[4])
    
    self._num = ccui.Text:create()
    self._num:setAnchorPoint(1,0.5)
    self._num:setFontSize(14)
    self._num:setFontName("res/dxyCocosStudio/font/MicosoftBlack.ttf")
    self._btn:addChild(self._num)
    self._num:setPosition(80,-5)
    self._num:setVisible(false)
    
    self._btn:addTouchEventListener(function(target,type)
        if type == 2 then
            SoundsFunc_playSounds(SoundsType.OPEN_PAGE,false)
            require "src.game.general.view.FragmentMsg"
            local fragment = FragmentMsg:create(self._data)
            SceneManager:getCurrentScene():addChild(fragment)
        end
    end)
end

function ItemBox:upDate(data)
    self._data = data
    if self._data then
        local icon = GoodsConfigProvider:findGoodsById(data.Id).Icon
        self._btn:setVisible(true)
        self._spColour:setVisible(true)
        self._btn:loadTextureNormal("res/GodGeneralsIcon/"..icon..".png")
        self._btn:loadTexturePressed("res/GodGeneralsIcon/"..icon..".png")
        
        local colour = GodGeneralConfig:getMsgColour(data.Id,2).IconLittle
        self._spColour:setTexture("res/GodGeneralsIcon/"..colour)
        
        if self._data.Num then
            self._num:setVisible(true)
            local name = GodGeneralConfig:getNameByFID(data["Id"])
            self._num:setString(name.." "..self._data.Num)
        else
            self._num:setVisible(false)
            local name = GodGeneralConfig:getNameByGID(data["Id"])
            self._num:setString(name)
        end
        self._num:setColor(Quality_Color[self._data.Config.Quality])
    else
        self._btn:setVisible(false)
        self._num:setVisible(false)
        self._spColour:setVisible(false)
    end
end
