ItemGroup = ItemGroup or class("ItemGroup",function()
    return cc.Node:create()
end)

function ItemGroup:ctor()
    self._data = {}
end

function ItemGroup:create(data)
    local node = ItemGroup:new()
    node:init(data)
    return node
end

function ItemGroup:init(data)
    self._csb = cc.CSLoader:createNode("res/dxyCocosStudio/csd/ui/group/ItemGroup.csb")
    self:addChild(self._csb)

    self._data = data
    
    local item = self._csb:getChildByName("item")
        
--btn
    local _btnView = item:getChildByName("btn_view")
    _btnView:addTouchEventListener(function(target,type)
        if type == 2 then
            SoundsFunc_playSounds(SoundsType.OPEN_PAGE,false)
            require "src.game.group.view.GroupMsg"
            local msg = GroupMsg:create(data)
            local scene = SceneManager:getCurrentScene()
            scene:addChild(msg)
        end
    end)
    
--pro
    local lvConfig = GroupConfig:getSociatyLv(data["Lv"])

    local group = item:getChildByName("group")
    group:setString(data["Name"])
    
    local head = item:getChildByName("bghead"):getChildByName("head")
    head:setTexture("HeroIcon/IconSquare_10"..data.Pro..".png")
    
    local name = item:getChildByName("name")
    name:setString(data["Master"])
    
    local lv = item:getChildByName("lv")
    lv:setString(data["Lv"])
    
    local num = item:getChildByName("num")
    num:setString(data["Num"])
    if data["Num"] >= lvConfig.MemberMax then
        num:setColor(cc.c3b(246,228,178))
    end

    local max = item:getChildByName("max")
    max:setString("/"..lvConfig.MemberMax)

end
