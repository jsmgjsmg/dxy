local ItemStone = class("ItemStone",function()
    return ccui.Button:create("dxyCocosStudio/png/yuanshen/stone/bg.png","dxyCocosStudio/png/yuanshen/stone/bg.png","")
end)
local PATH = "dxyCocosStudio/png/yuanshen/stone/"

function ItemStone:ctor()
    self._data = nil
end

function ItemStone:create()
    local node = ItemStone:new()
    node:init()
    return node
end

function ItemStone:init()
    self._csb = cc.CSLoader:createNode("dxyCocosStudio/csd/ui/yuanshen/ItemStone.csb")
    local conSize = self:getContentSize()
    self._csb:setPosition(conSize.width/2,conSize.height/2)
    self:addChild(self._csb)
    
    self:setTouchEnabled(false)
    self:addTouchEventListener(function(target,type)
        if type == 2 then
            SoundsFunc_playSounds(SoundsType.OPEN_PAGE,false)
            if self._data then
                if self._data.Id == YuanShenConfig:getStoneLast(YuanShenConfig:getTypeById(self._data.Id)).ID then
                    dxyFloatMsg:show("已达到最高级")
                else
                    local _csb = require("src.game.yuanshen.view.StoneMsg"):create(self._data)
                    SceneManager:getCurrentScene():addChild(_csb)
                end
            end
        end
    end)
    
    self._SP = self._csb:getChildByName("SP")
    self._txtNum = self._csb:getChildByName("txtNum")
    self._SP:setVisible(false)
    self._txtNum:setVisible(false)
end

function ItemStone:update(data)
    self._data = data
    if self._data then
        self:setTouchEnabled(true)
        self._SP:setVisible(true)
        self._txtNum:setVisible(true)
--        self._SP:setTexture(PATH..self._data.config.Icon..".png")
        self._SP:setSpriteFrame(cc.SpriteFrameCache:getInstance():getSpriteFrame(PATH..self._data.config.Icon..".png"))
        self._txtNum:setString(self._data.count)
    else
        self._SP:setVisible(false)
        self._txtNum:setVisible(false)
        self:setTouchEnabled(false)
    end
end

return ItemStone