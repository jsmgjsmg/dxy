TopDataNode = TopDataNode or class("TopDataNode",function()
    return cc.Node:create()
end)

function TopDataNode:ctor()

end

function TopDataNode:create(bool)
    local node = TopDataNode:new()
    node:initData(bool)
    return node
end

function TopDataNode:initData(bool)
    self._csb = cc.CSLoader:createNode("dxyCocosStudio/csd/ui/TopDataNode.csb")
    self:addChild(self._csb)
    
    dxyExtendEvent(self)
    
    local Node = self._csb:getChildByName("Node")
    self._btnAllGold = Node:getChildByName("btn_allGold")
    self._btnAllYB = Node:getChildByName("btn_allYB")
    self._btnAllYL= Node:getChildByName("btn_allYL")
    
    self._btnAllGold:addTouchEventListener(function(target,type)
        if type == 2 then
            SoundsFunc_playSounds(SoundsType.UNIVERSAL_BTN,false)
            zzc.RecruitMoneyController:showLayer()
        end
    end)
    
    self._btnAllYB:addTouchEventListener(function(target,type)
        if type == 2 then
            SoundsFunc_playSounds(SoundsType.UNIVERSAL_BTN,false)
            if not bool then
                -- bool==false
                if _G.RoleData.ALLRMB >= RechargeConfig:getDemand() and zzm.RechargeModel._isFirst >= 2 then
                    zzc.RechargeController:showLayer()
                else
                    zzc.RechargeController:showNode()
                end
            end
        end
    end)
    
    self._btnAllYL:addTouchEventListener(function(target,type)
        if type == 2 then
            SoundsFunc_playSounds(SoundsType.UNIVERSAL_BTN,false)
            zzc.PhysicalTipsController:showLayer()
        end
    end)
    
    
    self._txtAllGold = Node:getChildByName("txt_allGold")
    self._txtAllYB = Node:getChildByName("txt_allYB")
    self._txtAllYL = Node:getChildByName("txt_allYL")
    
    self:updateValue()
end

function TopDataNode:initEvent()
    dxyDispatcher_addEventListener("updateValue",self,self.updateValue)
    self:updateValue()
end

function TopDataNode:removeEvent()
    dxyDispatcher_removeEventListener("updateValue",self,self.updateValue)
end

function TopDataNode:updateValue()
    local role = zzm.CharacterModel:getCharacterData()
    local enCAT = enCharacterAttrType
    self._txtAllGold:setString(cn:convert(role:getValueByType(enCAT.GOLD)))
    self._txtAllYB:setString(role:getValueByType(enCAT.RMB))
    self._txtAllYL:setString(role:getValueByType(enCAT.PHYSICAL).."/"..PhysicalConfig:getBaseValue().Limit)
end