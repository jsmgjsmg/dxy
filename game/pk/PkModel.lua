local PkModel = class("PkModel")
PkModel.__index = PkModel

function PkModel:ctor()
    self:initModel()
end

function PkModel:initModel()
    self.ranking = 0
    self.player_list = {}
    self.arrHisData = {}
    self.MatchData = {}
end

function PkModel:sortList()
    table.sort(self.player_list,self.compRule)
end

function PkModel.compRule(dataA,dataB)
	return dataA.ranking < dataB.ranking
end

function PkModel:initHisData(data)
    self.arrHisData = data
    dxyDispatcher_dispatchEvent("ArenaNode_changeHisData",self.arrHisData)
end

function PkModel:initMatchData(data)
    self.MatchData = data
    dxyDispatcher_dispatchEvent("ArenaNode_updateRewards")
end

return PkModel