ItemAskFor = ItemAskFor or class("ItemAskFor",function()
    return cc.Node:create()
end)

function ItemAskFor:ctor()

end

function ItemAskFor:create(sv)
    local node = ItemAskFor:new()
    node:init(sv)
    return node
end

function ItemAskFor:init(sv)
    self._csb = cc.CSLoader:createNode("res/dxyCocosStudio/csd/ui/group/ItemAskFor.csb")
    self:addChild(self._csb)

--btn
    self._agree = self._csb:getChildByName("agree")
    self._refuse = self._csb:getChildByName("refuse")
    self._agree:addTouchEventListener(function(target,type)
        if type == 2 then
            SoundsFunc_playSounds(SoundsType.UNIVERSAL_BTN,false)
            if GroupConfig:getRoot(zzm.GroupModel:getRoot(_G.RoleData.Uid))["PermitEnter"] then
                zzc.GroupController:AnswerJoin(self._data["Id"],1)
            else
                TipsFrame:create("你的权限不足")
            end
        end
    end)
    self._refuse:addTouchEventListener(function(target,type)
        if type == 2 then
            SoundsFunc_playSounds(SoundsType.UNIVERSAL_BTN,false)
            if GroupConfig:getRoot(zzm.GroupModel:getRoot(_G.RoleData.Uid))["PermitEnter"] then
                zzc.GroupController:AnswerJoin(self._data["Id"],0)
            else
                TipsFrame:create("你的权限不足")
            end
        end
    end)
    
--pro
    self._head = self._csb:getChildByName("bghead"):getChildByName("head")

    self._name = self._csb:getChildByName("name")
    
    self._lv = self._csb:getChildByName("lv")
    
    self._power = self._csb:getChildByName("power")
    
end

function ItemAskFor:setData(data)
    self._data = data
    self._head:setTexture("HeroIcon/IconSquare_10"..data.Pro..".png")
    self._name:setString(data["Name"])
    self._lv:setString(data["Lv"])
    self._power:setString(data["Power"])
end
