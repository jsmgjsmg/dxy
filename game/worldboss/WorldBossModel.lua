local WorldBossModel = class("WorldBossModel")

function WorldBossModel:ctor()
    self.State = nil
end

function WorldBossModel:initState(state)
    self.State = state
    self.HurtRank = {}
end

function WorldBossModel:initRank(data)
    table.insert(self.HurtRank,data)
end

function WorldBossModel:sort(list)
    table.sort(self.HurtRank,function(c1,c2) return c1.Harm > c2.Harm end)
end

return WorldBossModel