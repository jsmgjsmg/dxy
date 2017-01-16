local RankingModel = class("RankingModel")

function RankingModel:ctor()
    self._arrRankLv = {}
    self._arrRankLv.List = {}
    
    self._arrRankPower = {}
    self._arrRankPower.List = {}
    
    self._arrRankGroup = {}
    self._arrRankGroup.List = {}
    self._arrRankGroup.Base = {}
    self._arrRankGroup.Member = {}

    self._arrRankPK = {}
    self._arrRankPK.List = {}
end
---LV------------------------------------------------------------
function RankingModel:initRankLv(data)
    table.insert(self._arrRankLv.List,data)
end

---Power------------------------------------------------------------
function RankingModel:initRankPower(data)
    table.insert(self._arrRankPower.List,data)
end

---Group------------------------------------------------------------
function RankingModel:initRankGroup(data)
    table.insert(self._arrRankGroup.List,data)
end

---PK------------------------------------------------------------
function RankingModel:initRankPK(data)
    table.insert(self._arrRankPK.List,data)
end

function RankingModel:initRankGroupBase(data)
    self._arrRankGroup.Base = data
    dxyDispatcher_dispatchEvent("Rank_baseHisMember")
end

function RankingModel:addHisMember(data)
    self._arrRankGroup.Member = data
    local function sort(t1,t2)
        if t1.root == t2.root then
            return t1.power > t2.power
        else
            return t1.root < t2.root
        end
    end
    table.sort(self._arrRankGroup.Member,sort)
    dxyDispatcher_dispatchEvent("Rank_addHisMember")
end

---sort-------------------------------------------------------------
function RankingModel:sort(data,key)
    table.sort(data,function(t1,t2) return t1[key] > t2[key] end)
end

function RankingModel:cut_sort(data,key)
    table.sort(data,function(t1,t2) return t1[key] < t2[key] end)
end

function RankingModel:clean()
    self._arrRankLv.List = {}
    self._arrRankPower.List = {}
    self._arrRankGroup.List = {}
    self._arrRankPK.List = {}
end

--sort
function RankingModel:sortRoot(data)
    local function sort(t1,t2)
        if t1.root == t2.root then
            return t1.power > t2.power
        else
            return t1.root < t2.root
        end
    end
    table.sort(data,sort)
end

return RankingModel