local RankLv = class("RankLv",function()
    return cc.Node:create()
end)
local HEIGHT = 92

function RankLv:ctor()
    self.visibleSize = cc.Director:getInstance():getVisibleSize()
    self.origin = cc.Director:getInstance():getVisibleOrigin()
    self._arrItem = {}
    self._arrData = {}
    self._page = 1
end

function RankLv:create()
    local node = RankLv:new()
    node:init()
    return node
end

function RankLv:init()
    self._csb = cc.CSLoader:createNode("res/dxyCocosStudio/csd/ui/ranking/RankLv.csb")
    self:addChild(self._csb)
    self._csb:setPosition(self.origin.x + self.visibleSize.width / 2, self.origin.y + self.visibleSize.height / 2)

    dxyExtendEvent(self)

--    zzc.RankingController:getRankByLv()

    self._sv = self._csb:getChildByName("ScrollView")
    self._sv:setScrollBarEnabled(false)
end

function RankLv:initEvent()
    dxyDispatcher_addEventListener("RankLv_addItem",self,self.addItem)
    dxyDispatcher_addEventListener("RankLv_delItem",self,self.delItem)
    zzc.RankingController:getRankByLv()
end

function RankLv:removeEvent()
    dxyDispatcher_removeEventListener("RankLv_addItem",self,self.addItem)
    dxyDispatcher_removeEventListener("RankLv_delItem",self,self.delItem)
end

function RankLv:addItem()

    local conSize = self._sv:getContentSize()
    local Num = #zzm.RankingModel._arrRankLv.List
    local real = Num * HEIGHT
    local last = conSize.height > real and conSize.height or real
    self._sv:setInnerContainerSize(cc.size(conSize.width,last))
    for i=1,Num do
        local height = last-(i-1)*HEIGHT
        local data = zzm.RankingModel._arrRankLv.List[i]
        local item = require ("src.game.ranking.view.ItemLv"):create()
        item:update(data,i)
        self._sv:addChild(item,1)
        item:setPosition(0,height)
        table.insert(self._arrItem,item)
    end

    self:updateRank()
end

function RankLv:updateRank()
    local rank = nil
    for key, var in pairs(zzm.RankingModel._arrRankLv.List) do
        if var.Uid == _G.RoleData.Uid then
            rank = key
            break
        end
    end
    dxyDispatcher_dispatchEvent("RankingLayer_setRank",rank)
--    dxyWaitBack:close()
    LoadWaitSec:close()
end

function RankLv:delItem(uid)
    for key, var in pairs(self._arrItem) do
        if var._data.Uid == uid then
            table.remove(self._arrItem,key)
            zzd.RankingData:setPosition(self._sv,self._arrItem)
            break            
        end
    end
end

return RankLv