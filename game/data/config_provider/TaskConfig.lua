TaskConfig = TaskConfig or class("TaskConfig")
local Gold =  "铜钱"
local Rmb =   "元宝"
local Exp =   "经验"
local Power = "体力"
local Goods = "物品"

---奖励----------------------------------------------------------------------
function TaskConfig:getWantById(id)
    local list = luacf.Task.TaskConfig.WantedGroup.Wanted
    local arr = dxyConfig_toList(list)
    for i,want in pairs(arr) do
        if want.Id == id then
            return want
        end
    end
end

function TaskConfig:getRewardsById_Want(id)
    local list = luacf.Task.TaskConfig.WantedGroup.Wanted
    local arr = dxyConfig_toList(list)
    for i,want in pairs(arr) do
        if want.Id == id then
            return dxyConfig_toList(want.Rewards) 
        end
    end
end

function TaskConfig:findGoodsById(id)
    return GoodsConfigProvider:findGoodsById(id)
end

---特殊的-------------------------------------------------------------------
function TaskConfig:getSpecialGroup(type)
    local list =luacf.Task.TaskConfig.SpecialGroup.Task
    local arr = dxyConfig_toList(list)
    for key, var in pairs(arr) do
    	if var.Type == type then
    	    return var
    	end
    end
end

---成长----------------------------------------------------------------------
function TaskConfig:getGrowUpById(id)
    local list = luacf.Task.TaskConfig.GrowUpGroup.GrowUp
    local arr = dxyConfig_toList(list)
    for i,grow in pairs(arr) do
        if grow.Id == id then
            return grow
        end
    end
end

function TaskConfig:getRewardsById_GrowUp(id)
    local list = luacf.Task.TaskConfig.GrowUpGroup.GrowUp
    local arr = dxyConfig_toList(list)
    for i,grow in pairs(arr) do
        if grow.Id == id then
            return dxyConfig_toList(grow.Rewards)
        end
    end
end

---每日任务----------------------------------------------------------------------
function TaskConfig:getDailyById(id)
    local list = luacf.Task.TaskConfig.DailyGroup.Daily
    local arr = dxyConfig_toList(list)
    for i,daily in pairs(arr) do
        if daily.Id == id then
            return daily
        end
    end
end

function TaskConfig:getRewardsById_Day(id)
    local list = luacf.Task.TaskConfig.DailyGroup.Daily
    local arr = dxyConfig_toList(list)
    local arrReward = {}
    local arrPos = {}
    for i,day in pairs(arr) do
        if day.Id == id then
            return dxyConfig_toList(day.Rewards)
        end
    end
end

--获取活跃度上限
function TaskConfig:getLivelyMax()
    local list = luacf.Task.TaskConfig.DailyGroup.Daily
    local max = 0
    for key, var in pairs(list) do
        max = max + var.Lively
    end
    return max
end

function TaskConfig:getLivelyBox(id)
    local list = luacf.Task.TaskConfig.Lively.LivelyRewards
    for key, var in pairs(list) do
    	if var.Id == id then
    	    return var
    	end
    end
end

function TaskConfig:getLivelyBoxByKey(key)
    local list = luacf.Task.TaskConfig.Lively.LivelyRewards
    if list[key] then
        return list[key]
    end
end

function TaskConfig:getLivelyReawardById(id)
    local list = luacf.Task.TaskConfig.Lively.LivelyRewards
    for key, var in pairs(list) do
    	if var.Id == id then
            return dxyConfig_toList(var.Rewards)
    	end
    end
end

---每日登陆----------------------------------------------------------------------
function TaskConfig:getRewardByDay(day)
    local list = luacf.Task.TaskConfig.LoginGroup.Rewards
    local arr = dxyConfig_toList(list)
    for i,rew in pairs(arr) do
        if rew.Days == day then
            return rew
        end
    end
end

--获取
function TaskConfig:getLogin_Tips(day,cirt)
    local list = luacf.Task.TaskConfig.LoginGroup.Rewards
    local arr = dxyConfig_toList(list)
    for i,reward in pairs(arr) do
        if reward.Days == day then
            local strList = zzd.TaskData.arrStrType
            local str = ""
            if reward.Rewards.Type == 6 then
                local goods = GoodsConfigProvider:findGoodsById(reward.Rewards.Id)
                str = goods.Name.." ×"..reward.Rewards.Num
            else
                str = strList[reward.Rewards.Type].." ×"..reward.Rewards.Num * cirt
            end
            return str
        end
    end
end

--获取补签需要
function TaskConfig:getMakeUpNeed(time)
    local list = luacf.Task.TaskConfig.LoginGroup.FillCheck
    local arr = dxyConfig_toList(list)
    for key, var in pairs(arr) do
    	if var.Num == time + 1 then
    	    return var.Rmb
    	end
    end
end

--获取全勤奖励
function TaskConfig:getAllFinish()
    return luacf.Task.TaskConfig.LoginGroup.AllWork.Rewards
end