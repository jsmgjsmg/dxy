local HarmRank = class("HarmRank",function()
    return cc.Node:create()
end)
local HEIGHT = 92

function HarmRank:ctor()
    self.visibleSize = cc.Director:getInstance():getVisibleSize()
    self.origin = cc.Director:getInstance():getVisibleOrigin()
end

function HarmRank:create()
    local node = HarmRank:new()
    node:init()
    return node
end

function HarmRank:init()
    self._csb = cc.CSLoader:createNode("res/dxyCocosStudio/csd/ui/worldboss/HarmRank.csb")
    self:addChild(self._csb)
    self._csb:setPosition(self.origin.x + self.visibleSize.width / 2, self.origin.y + self.visibleSize.height / 2)

    dxyExtendEvent(self)
    -- 拦截
    dxySwallowTouches(self)

    local btnBack = self._csb:getChildByName("btnBack")
    btnBack:addTouchEventListener(function(target,type)
        if type == 2 then
            SoundsFunc_playSounds(SoundsType.CLOSE_PAGE,false)
            self:removeFromParent()
        end
    end)
    
    self._SV = self._csb:getChildByName("ScrollView")
    self._SV:setScrollBarEnabled(false)

end

function HarmRank:initEvent()
    dxyDispatcher_addEventListener("HarmRank_addItem",self,self.addItem)
end

function HarmRank:removeEvent()
    dxyDispatcher_removeEventListener("HarmRank_addItem",self,self.addItem)
end

function HarmRank:addItem()
    local RANK = zzm.WorldBossModel.HurtRank
    
    local conSize = self._SV:getContentSize()
    local realH = #RANK * HEIGHT
    local lastH = conSize.height > realH and conSize.height or realH
    self._SV:setInnerContainerSize(cc.size(conSize.width,lastH))
    
    for i=1,#RANK do
        local data = {[1]=RANK[i],[2]=i}
        local boss = require ("src.game.worldboss.view.ItemBoss"):create(data)
        self._SV:addChild(boss)
        boss:setPosition(0,lastH-(i-1)*HEIGHT)
    end
end

return HarmRank