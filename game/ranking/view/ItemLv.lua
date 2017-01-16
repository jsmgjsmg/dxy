local ItemLv = class("ItemLv",function()
    return ccui.Button:create("dxyCocosStudio/png/ranking/bg4.png","dxyCocosStudio/png/ranking/bg5.png","")
end)

function ItemLv:ctor()
    
end

function ItemLv:create()
    local node = ItemLv:new()
    node:init()
    return node
end

function ItemLv:init()
    self._csb = cc.CSLoader:createNode("res/dxyCocosStudio/csd/ui/ranking/ItemLv.csb")
    local conSize = self:getContentSize()
    self._csb:setPosition(0,conSize.height)
    self:addChild(self._csb)
    self:setAnchorPoint(0,1)

    self:addTouchEventListener(function(target,type)
        if type == 2 then
            SoundsFunc_playSounds(SoundsType.OPEN_PAGE,false)
            if self._data.Uid ~= _G.RoleData.Uid then
                local msg = require("src.game.ranking.view.PeopleFS"):create(self._data)
                local scene = SceneManager:getCurrentScene()
                scene:addChild(msg)
                _G.RankData.Uid = self._data.Uid
            end
        end
    end)
    
    self._txtNum = self._csb:getChildByName("bgNum"):getChildByName("txtNum")

    self._spHead = self._csb:getChildByName("bgHead"):getChildByName("spHead")
    
    self._txtName = self._csb:getChildByName("txtName")

    self._txtPro = self._csb:getChildByName("txtPro")

end

function ItemLv:update(data,i)
    self._data = data
    if i == 1 then
        self._txtNum:setString("1st")
    elseif i == 2 then
        self._txtNum:setString("2nd")
    
    elseif i == 3 then
        self._txtNum:setString("3rd")
    
    else
        self._txtNum:setString(i)
    end
    self._data = data
    self._txtName:setString(self._data.Name)
    self._txtPro:setString(self._data.Lv)
    local hero = HeroConfig:getValueById(data.Pro)
    self._spHead:setTexture(hero.IconSquare)
end

return ItemLv