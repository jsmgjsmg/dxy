local RankGroup = class("RankGroup",function()
    return cc.Node:create()
end)
local HEIGHT = 92

function RankGroup:ctor()
    self.visibleSize = cc.Director:getInstance():getVisibleSize()
    self.origin = cc.Director:getInstance():getVisibleOrigin()
    self._arrItem = {}
    self._arrData = {}
    self._page = 1
end

function RankGroup:create()
    local node = RankGroup:new()
    node:init()
    return node
end

function RankGroup:init()
    self._csb = cc.CSLoader:createNode("res/dxyCocosStudio/csd/ui/ranking/RankGroup.csb")
    self:addChild(self._csb)
    self._csb:setPosition(self.origin.x + self.visibleSize.width / 2, self.origin.y + self.visibleSize.height / 2)

    dxyExtendEvent(self)

--    zzc.RankingController:getRankByGroup()

    self._sv = self._csb:getChildByName("ScrollView")
    self._sv:setScrollBarEnabled(false)

end

function RankGroup:initEvent()
    dxyDispatcher_addEventListener("RankGroup_addItem",self,self.addItem)
    dxyDispatcher_addEventListener("RankGroup_delItem",self,self.delItem)
    zzc.RankingController:getRankByGroup()
end

function RankGroup:removeEvent()
    dxyDispatcher_removeEventListener("RankGroup_addItem",self,self.addItem)
    dxyDispatcher_removeEventListener("RankGroup_delItem",self,self.delItem)
end

function RankGroup:addItem()
    local conSize = self._sv:getContentSize()
    local Num = #zzm.RankingModel._arrRankGroup.List
    local real = Num * HEIGHT
    local last = conSize.height > real and conSize.height or real
    self._sv:setInnerContainerSize(cc.size(conSize.width,last))
    for i=1,Num do
        local height = last-(i-1)*HEIGHT
        local data = zzm.RankingModel._arrRankGroup.List[i]
        local item = require ("src.game.ranking.view.ItemGroup"):create()
        item:update(data,i)
        self._sv:addChild(item,1)
        item:setPosition(0,height)
        table.insert(self._arrItem,item)
    end
    
    self:updateRank()
end

function RankGroup:updateRank()
    local rank = nil
    if _G.GroupData.State ~= 0 then
        local id = zzm.GroupModel.GroupData.Id
        for key, var in pairs(zzm.RankingModel._arrRankGroup.List) do
            if var.Id == id then
                rank = key
                break
            end
        end        
    end
    dxyDispatcher_dispatchEvent("RankingLayer_setRank",rank)
--    dxyWaitBack:close()
    LoadWaitSec:close()
end

return RankGroup