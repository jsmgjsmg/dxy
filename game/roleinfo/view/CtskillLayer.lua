CtskillLayer = CtskillLayer or class("CtskillLayer",function()
    return cc.Layer:create()
end)

function CtskillLayer:create()
    local layer = CtskillLayer:new()
    return layer
end

function CtskillLayer:ctor()
    self._csb = nil
    self._skillList = {}
    self._skillLock = {}
    self._skillunLock = {}
    self._skillNode = {}
    self._arrItem = {}
    
    self:initUI()
end



function CtskillLayer:initUI()
    self._csb = cc.CSLoader:createNode("dxyCocosStudio/csd/ui/roleinfo/ctskillLayer.csb")
    self:addChild(self._csb)

    dxyExtendEvent(self)

    self._scrollView = self._csb:getChildByName("ScrollView")
    self._scrollView:setScrollBarEnabled(false)

--    require("game.roleinfo.view.CtskillItem")
--    for index=1,3 do
--        self.ctskill_list[index] = {}
--        local skillNode = scrollView:getChildByName("Panel_"..index)
--        for id = 1,6 do
--            local skill = skillNode:getChildByName("Node_"..id)
--            if id > 1 then
--            	local locked_bridge = skillNode:getChildByName("locked_bridge_"..id)
--            	local unlock_bridge = skillNode:getChildByName("unlock_bridge_"..id)
--                if zzm.SkillModel:getCTSkillList()[index][id].is_unlock == 0 then
--            		locked_bridge:setVisible(true)
--                    unlock_bridge:setVisible(false)
--                else
--                    locked_bridge:setVisible(false)
--                    unlock_bridge:setVisible(true)
--            	end
--            end
--            
--            local item = CtskillItem:create()
--            item:update(zzm.SkillModel:getCTSkillList()[index][id])
--            skill:addChild(item)
--            self.ctskill_list[index][id] = item
--        end
--    end
    
    for i=1,3 do
        self._skillList[i] = {}
        self._skillLock[i] = {}
        self._skillunLock[i] = {}
        self._skillNode[i] = {}
        self._arrItem[i] = {}
        local Panel = self._scrollView:getChildByName("Panel_"..i)
        for j=1,6 do
            self._skillLock[i][j] = Panel:getChildByName("locked_bridge_"..j)
            self._skillunLock[i][j] = Panel:getChildByName("unlock_bridge_"..j)
            self._skillNode[i][j] = Panel:getChildByName("Node_"..j)
            require "src.game.roleinfo.view.CtskillItem"
            local Item = CtskillItem:create()
            self._skillNode[i][j]:addChild(Item)
            self._arrItem[i][j] = Item
        end
    end
    
    if _G.RankData.Uid == _G.RoleData.Uid then
        self:MinePro()
    else
        zzc.RoleinfoController:getDataWithPro(_G.RankData.Uid,2)
    end
end

function CtskillLayer:initEvent()
    dxyDispatcher_addEventListener("CtskillLayer_update",self,self.update)
end

function CtskillLayer:removeEvent()
    dxyDispatcher_removeEventListener("CtskillLayer_update",self,self.update)
end

function CtskillLayer:update()
    local SKILL = zzm.RoleinfoModel._arrRoleData.SKILL
    
    for i=1,#SKILL do
        for j=1,#SKILL[i] do
            self._arrItem[i][j]:update(SKILL[i][j])
            if j > 1 then
                if SKILL[i][j].is_unlock == 0 then
                    self._skillLock[i][j]:setVisible(true)
                    self._skillunLock[i][j]:setVisible(false)
                else
                    self._skillunLock[i][j]:setVisible(false)
                    self._skillunLock[i][j]:setVisible(true)
                end
            end
        end
    end
end

function CtskillLayer:MinePro()
    local SKILL = zzm.SkillModel:getCTSkillList()
    for i=1,#SKILL do
        for j=1,#SKILL[i] do
            self._arrItem[i][j]:update(SKILL[i][j])
            if j > 1 then
                if SKILL[i][j].is_unlock == 0 then
                    self._skillLock[i][j]:setVisible(true)
                    self._skillunLock[i][j]:setVisible(false)
                else
                    self._skillunLock[i][j]:setVisible(false)
                    self._skillunLock[i][j]:setVisible(true)
              end
            end
        end
    end
end