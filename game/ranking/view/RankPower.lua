local RankPower = class("RankPower",function()
    return cc.Node:create()
end)
local HEIGHT = 92

function RankPower:ctor()
    self.visibleSize = cc.Director:getInstance():getVisibleSize()
    self.origin = cc.Director:getInstance():getVisibleOrigin()
    self._arrItem = {}
    self._arrData = {}
    self._page = 1
end

function RankPower:create()
    local node = RankPower:new()
    node:init()
    return node
end

function RankPower:init()
    self._csb = cc.CSLoader:createNode("res/dxyCocosStudio/csd/ui/ranking/RankPower.csb")
    self:addChild(self._csb)
    self._csb:setPosition(self.origin.x + self.visibleSize.width / 2, self.origin.y + self.visibleSize.height / 2)

    dxyExtendEvent(self)

--    zzc.RankingController:getRankByPower()

    self._sv = self._csb:getChildByName("ScrollView")
    self._sv:setScrollBarEnabled(false)

end

function RankPower:initEvent()
    dxyDispatcher_addEventListener("RankPower_addItem",self,self.addItem)
    dxyDispatcher_addEventListener("RankPower_delItem",self,self.delItem)
    zzc.RankingController:getRankByPower()
end

function RankPower:removeEvent()
    dxyDispatcher_removeEventListener("RankPower_addItem",self,self.addItem)
    dxyDispatcher_removeEventListener("RankPower_delItem",self,self.delItem)
end

function RankPower:addItem()
    local conSize = self._sv:getContentSize()
    local Num = #zzm.RankingModel._arrRankPower.List
    local real = Num * HEIGHT
    local last = conSize.height > real and conSize.height or real
    self._sv:setInnerContainerSize(cc.size(conSize.width,last))
    for i=1,Num do
        local height = last-(i-1)*HEIGHT
        local data = zzm.RankingModel._arrRankPower.List[i]
        local item = require ("src.game.ranking.view.ItemPower"):create()
        item:update(data,i)
        self._sv:addChild(item,1)
        item:setPosition(0,height)
        table.insert(self._arrItem,item)
    end
    
    self:updateRank()
end

function RankPower:updateRank()
    local rank = nil    
    for key, var in pairs(zzm.RankingModel._arrRankPower.List) do
        if var.Uid == _G.RoleData.Uid then
            rank = key
            break
        end
    end
    dxyDispatcher_dispatchEvent("RankingLayer_setRank",rank)
--    dxyWaitBack:close()
    LoadWaitSec:close()
end

return RankPower