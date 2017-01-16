local RankPK = class("RankPK",function()
    return cc.Node:create()
end)
local HEIGHT = 92

function RankPK:ctor()
    self.visibleSize = cc.Director:getInstance():getVisibleSize()
    self.origin = cc.Director:getInstance():getVisibleOrigin()
    self._arrItem = {}
    self._arrData = {}
end

function RankPK:create()
    local node = RankPK:new()
    node:init()
    return node
end

function RankPK:init()
    self._csb = cc.CSLoader:createNode("res/dxyCocosStudio/csd/ui/ranking/RankPK.csb")
    self:addChild(self._csb)
    self._csb:setPosition(self.origin.x + self.visibleSize.width / 2, self.origin.y + self.visibleSize.height / 2)

    dxyExtendEvent(self)

--    zzc.RankingController:getRankByPK()

    self._sv = self._csb:getChildByName("ScrollView")
    self._sv:setScrollBarEnabled(false)

end

function RankPK:initEvent()
    dxyDispatcher_addEventListener("RankPK_addItem",self,self.addItem)
    dxyDispatcher_addEventListener("RankPK_delItem",self,self.delItem)
    zzc.RankingController:getRankByPK()
end

function RankPK:removeEvent()
    dxyDispatcher_removeEventListener("RankPK_addItem",self,self.addItem)
    dxyDispatcher_removeEventListener("RankPK_delItem",self,self.delItem)
end

function RankPK:addItem()
    local conSize = self._sv:getContentSize()
    local Num = #zzm.RankingModel._arrRankPK.List
    local real = Num * HEIGHT
    local last = conSize.height > real and conSize.height or real
    self._sv:setInnerContainerSize(cc.size(conSize.width,last))
    for i=1,Num do
        local height = last-(i-1)*HEIGHT
        local data = zzm.RankingModel._arrRankPK.List[i]
        local item = require ("src.game.ranking.view.ItemPK"):create()
        item:update(data,i)
        self._sv:addChild(item,1)
        item:setPosition(0,height)
        table.insert(self._arrItem,item)
    end
    
    self:updateRank()
end

function RankPK:updateRank()
    local rank = nil
    for key, var in pairs(zzm.RankingModel._arrRankPK.List) do
        if var.Uid == _G.RoleData.Uid then
            rank = key
            break
        end
    end
    dxyDispatcher_dispatchEvent("RankingLayer_setRank",rank)
--    dxyWaitBack:close()
    LoadWaitSec:close()
end

return RankPK