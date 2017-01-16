SkillContinuousPage = SkillContinuousPage or class("SkillContinuousPage",function()
    return ccui.Layout:create()
end)

function SkillContinuousPage:create()
    local node = SkillContinuousPage:new()
    return node
end

function SkillContinuousPage:ctor()
    self:initUI()
--    self:initEvent()

    dxyExtendEvent(self)
end

function SkillContinuousPage:setParent(parent)
    self._parent = parent
end

function SkillContinuousPage:initUI()
    self._csbNode = cc.CSLoader:getInstance():createNodeWithFlatBuffersFile("dxyCocosStudio/csd/ui/skill/SkillContinuousPage.csb")
    self:addChild(self._csbNode)
    self.visibleSize = cc.Director:getInstance():getVisibleSize()
    self.origin = cc.Director:getInstance():getVisibleOrigin()

    local posX = self.origin.x + self.visibleSize.width/2
    local posY = self.origin.y + self.visibleSize.height/2

    self._csbNode:setPosition(posX, posY)

    local node = self._csbNode:getChildByName("Panel")

    self.skillNode = {}
    self.lock_list = {}
    for index=1, 3 do
        self.skillNode[index] = {}
        self.lock_list[index] = {}
        local skillNode = node:getChildByName("Panel_" .. index)
        for id=1, 4 do
            local skill = skillNode:getChildByName("Node_" .. id)
            self.lock_list[index][id] = {}
            if id > 1 then
                local locked_bridge = skillNode:getChildByName("locked_bridge_"..id)
                local unlock_bridge = skillNode:getChildByName("unlock_bridge_"..id)
                if zzm.SkillModel:getCTSkillList()[index][id].is_unlock == 0 then
                    locked_bridge:setVisible(true)
                    unlock_bridge:setVisible(false)
                else
                    locked_bridge:setVisible(false)
                    unlock_bridge:setVisible(true)
                end
                self.lock_list[index][id]["locked"] = locked_bridge
                self.lock_list[index][id]["unlock"] = unlock_bridge
            else
                self.lock_list[index][id]["locked"] = nil
                self.lock_list[index][id]["unlock"] = nil
            end
            
            local item = SkillToggle:create()
            item:setScale(0.7)
            item:setSkill(zzm.SkillModel:getCTSkillList()[index][id],index, self)
            item:setType(SKILL_TYPE.ctskill)
            skill:addChild(item)
	    	item:setName("Skill..index..id")
	    print("------------------------------------> " .. index .. id)
            self.skillNode[index][id] = item
        end
    end

    self.helpButton = self._csbNode:getChildByName("DownNode"):getChildByName("Button")
    require "game.skill.view.SkillEquipLayer"
end

function SkillContinuousPage:onSelectByIndex(data,id)
    --dxyFloatMsg:show("open Equip Skill Panel!")
    local layer = SkillEquipLayer.create()
    layer:setData(data,id)
    local scene = SceneManager:getCurrentScene()
    scene:addChild(layer)

    self._mySubServerTimer = self._mySubServerTimer or require("game.utils.MyTimer").new()
    local function tick()
        dxyDispatcher_dispatchEvent(dxyEventType.Skill_AutoSelect)
        self._mySubServerTimer:stop()
    end
    self._mySubServerTimer:start(0.1, tick)
end

function SkillContinuousPage:unlockEffect(data)
    require("game.skill.view.SkillEffect")
    local effect = SkillEffect:create()
    local iconSize = self.skillNode[data.chainId][data.idx]:getItemSize()
    self.skillNode[data.chainId][data.idx]:addChild(effect)
    effect:setPosition(cc.p(iconSize.width / 2,iconSize.height / 2))
end

function SkillContinuousPage:removeEvent()
    dxyDispatcher_removeEventListener(dxyEventType.ctSkill_Unlock_Effect,self,self.unlockEffect)
end

function SkillContinuousPage:initEvent()

    dxyDispatcher_addEventListener(dxyEventType.ctSkill_Unlock_Effect,self,self.unlockEffect)
    
    if(self.helpButton)then
        self.helpButton:addTouchEventListener(function(target,type)
            if(type==2)then
                --打开地图界
                dxyFloatMsg:show("Skill Help Info!" .. type)
            end
        end)
    end
end



