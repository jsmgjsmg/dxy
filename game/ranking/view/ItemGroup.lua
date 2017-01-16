local ItemGroup = class("ItemGroup",function()
    return ccui.Button:create("dxyCocosStudio/png/ranking/bg4.png","dxyCocosStudio/png/ranking/bg5.png","")
end)

function ItemGroup:ctor()

end

function ItemGroup:create()
    local node = ItemGroup:new()
    node:init()
    return node
end

function ItemGroup:init()
    self._csb = cc.CSLoader:createNode("res/dxyCocosStudio/csd/ui/ranking/ItemGroup.csb")
    local conSize = self:getContentSize()
    self._csb:setPosition(0,conSize.height)
    self:addChild(self._csb)
    self:setAnchorPoint(0,1)

    self:addTouchEventListener(function(target,type)
        if type == 2 then
            SoundsFunc_playSounds(SoundsType.OPEN_PAGE,false)
            local msg = require("src.game.ranking.view.GroupFS"):create(self._data)
            local scene = SceneManager:getCurrentScene()
            scene:addChild(msg)
        end
    end)
    
    self._txtNum = self._csb:getChildByName("bgNum"):getChildByName("txtNum")

    self._txtGroup = self._csb:getChildByName("txtGroup")

    self._txtName = self._csb:getChildByName("txtName")

    self._txtPro = self._csb:getChildByName("txtPro")

end

function ItemGroup:update(data,i)
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
    self._txtGroup:setString(self._data.Name)
    self._txtName:setString(self._data.Master)
    self._txtPro:setString(self._data.AllPower)

end

return ItemGroup