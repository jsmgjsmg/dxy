local RankingData = class("RankingData")

function RankingData:ctor()
    self._nodePath = {
        [1] = "src/game/ranking/view/RankLv.lua",
        [2] = "src/game/ranking/view/RankPower.lua",
        [3] = "src/game/ranking/view/RankGroup.lua",
        [4] = "src/game/ranking/view/RankPK.lua",
    }
    
    self._arrCurRank = {
        [1] = "_arrRankLv",
        [2] = "_arrRankPower",
        [3] = "_arrRankGroup",
        [4] = "_arrRankPK",
    }
    
end

function RankingData:setPosition(sv,data)
    local HEIGHT = 92
    local len = #data
    local content = sv:getContentSize()
    local real = len * HEIGHT
    local last = content.height > real and content.height or real

    sv:setInnerContainerSize(cc.size(content.width,last))
    for i=1,len do
        data[i]:setPosition(0,last-(i-1)*HEIGHT)
    end
end

return RankingData