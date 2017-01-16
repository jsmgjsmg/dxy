local LotteryDrawModel = class("LotteryDrawModel")
LotteryDrawModel.__index = LotteryDrawModel

function LotteryDrawModel:ctor()
    self:initModel()
end

function LotteryDrawModel:initModel()
    self._MaxNum = 8
    self._OneRMB = 0
    self._TenRMB = 0
    self.freeChanceCount = 0
    self._rewardList = {}
    self._infoList = {}
    
    self._tenRewardList = {}
end

function LotteryDrawModel:setRMB(one, ten)
    self._OneRMB = one
    self._TenRMB = ten
end

function LotteryDrawModel:addInitReward(item)
    table.insert(self._rewardList, #self._rewardList + 1,item)
end

function LotteryDrawModel:getReward(idx)
    return self._rewardList[idx]
end

function LotteryDrawModel:addInitInfo(item)
    print("--------------------")
    print(item.type)
    print(item.value)
    print(item.num)
    table.insert(self._infoList, #self._infoList + 1,item)
end

function LotteryDrawModel:getInfo(type)
    local ret = {}
    for i=1, #self._infoList do
        local item = self._infoList[i]
        if item.subtype == type then
            table.insert(ret, #ret + 1,item)
    	end
    end
    return ret
end

function LotteryDrawModel:addTenReward(item)
    table.insert(self._tenRewardList, #self._tenRewardList + 1,item)
end

function LotteryDrawModel:getTenReward(idx)
    return self._tenRewardList[idx]
end

function LotteryDrawModel:addOneReward(idx)
    self._OneReward = self:getReward(idx)
end

function LotteryDrawModel:getCurrentItem()
    local data = self:getInfo(2)
    if #data >0 then
        return data[1]
	end
    return nil
end

return LotteryDrawModel