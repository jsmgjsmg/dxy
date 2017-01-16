local GroupFuncCtrl = class("GroupFuncCtrl")

function GroupFuncCtrl:ctor()
--    self:registerListener()
    self._teamCopy = {}
end

function GroupFuncCtrl:registerListener()
    _G.NetManagerLuaInst:registerListenner()
end

function GroupFuncCtrl:unregisterListenner()
    _G.NetManagerLuaInst:unregisterListenner()
end

--show
--function GroupFuncCtrl:showLayer()
--    require("game.group.function.TeamCopy")
--    self._layer = TeamCopy:create()
--    local scene = SceneManager:getCurrentScene()
--    scene:addChild(self._layer)
--end

--PrayNode
function GroupFuncCtrl:enterPrayNode()
    require "game.group.function.PrayNode"
    local scene = SceneManager:getCurrentScene()
    self._paryNode = PrayNode:create()
    scene:addChild(self._paryNode)
end

function GroupFuncCtrl:removePrayNode()
    if self._paryNode then
        self._paryNode:removeFromParent()
        self._paryNode = nil
    end
end

function GroupFuncCtrl:enterGroupShop()
    require "game.group.function.GroupShop"
    local scene = SceneManager:getCurrentScene()
    self._groupShop = GroupShop:create()
    scene:addChild(self._groupShop)
end

function GroupFuncCtrl:exitGroupShop()
    if self._groupShop then
        self._groupShop:removeFromParent()
        self._groupShop = nil
    end
end

function GroupFuncCtrl:enterTalent()
    require("game.group.function.TalentNode")
    local scene = SceneManager:getCurrentScene()
    self._talent = TalentNode:create()
    scene:addChild(self._talent)
end

function GroupFuncCtrl:exitTalent()
    if self._talent then
        self._talent:removeFromParent()
        self._talent = nil
    end
end

function GroupFuncCtrl:enterTower()
    require("game.group.function.TeamCopy")
    local teamCopy = TeamCopy:create()
    table.insert(self._teamCopy,teamCopy)
    local scene = SceneManager:getCurrentScene()
    scene:addChild(self._teamCopy[#self._teamCopy])
    if zzc.ChatController:isOpening() then
        zzc.ChatController:closeLayer()
    end
    zzm.GroupModel.isEnterByGroup = true
end

function GroupFuncCtrl:exitTower()
    if self._teamCopy then
        for key, var in pairs(self._teamCopy) do
            var:removeFromParent()
        end
    end
    self._teamCopy = {}
    zzm.GroupModel.isEnterByGroup = false
end

function GroupFuncCtrl:cleanTowerLayer()
    self._teamCopy = {}
end

return GroupFuncCtrl