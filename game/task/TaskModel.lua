local TaskModel = TaskModel or class("TaskModel")

function TaskModel:ctor()
    self.arrAward = {}
    
    self.arrGrowUp = {}
    
    self.arrEveryDate = {}
    
    self.arrLogin = {}
    
    self.nowDay = 0
    
    self.SpecialAward = {}
    
    self.arrLivelyData = {} 
end
---Award----------------------------------------------
function TaskModel:initAward(data)
    if TaskConfig:getWantById(data.Id) then
        table.insert(self.arrAward,data)
        self:RankTask(self.arrAward)
    end
end

function TaskModel:cut_arrAward(id)
    if self:isNil(self.arrAward,id) then
        return
    end
    local reward = nil
    for i=1,#self.arrAward do
        if self.arrAward[i]["Id"] == id then
            reward = dxyConfig_toList(self.arrAward[i].Config.Rewards)
            table.remove(self.arrAward,i)
            break
        end
    end
--    local reward = TaskConfig:getRewardsById_Want(id)
    cn:showRewardsGet(reward)
    dxyDispatcher_dispatchEvent("TaskNode_delAward",id)
    dxyDispatcher_dispatchEvent("updateAwardTips")
    dxyDispatcher_dispatchEvent("MainScene_updateTaskTips")
end

function TaskModel:add_arrAward(data)
    if not data.Config then
        return 
    end
    table.insert(self.arrAward,data)
    self:RankTask(self.arrAward)
    dxyDispatcher_dispatchEvent("TaskNode_addAward",data)
    dxyDispatcher_dispatchEvent("updateAwardTips")
    dxyDispatcher_dispatchEvent("MainScene_updateTaskTips")
end

function TaskModel:change_arrAward(id,state)
    if self:isNil(self.arrAward,id) then
        return
    end
    for i,award in pairs(self.arrAward) do 
        if award["Id"] == id then
            award["State"] = state
            break
        end
    end
    self:RankTask(self.arrAward)
    dxyDispatcher_dispatchEvent("TaskNode_changeAward")
    dxyDispatcher_dispatchEvent("updateAwardTips")
    dxyDispatcher_dispatchEvent("MainScene_updateTaskTips")
end

---SpecialAward
function TaskModel:initSpecialAward(data)
    table.insert(self.SpecialAward,data)
end

function TaskModel:cutSpecialAward(data)
    if self:isNil(self.SpecialAward,data.Id) then
        return
    end
    for key, var in pairs(self.SpecialAward) do
    	if var.Id == data.Id then
    	    if data.State == 2 then
                cn:showRewardsGet(var.Reward)
                table.remove(self.SpecialAward,key)
                dxyDispatcher_dispatchEvent("TaskNode_delSpecialAward",data.Id)
                dxyDispatcher_dispatchEvent("updateAwardTips")
                dxyDispatcher_dispatchEvent("MainScene_updateTaskTips")
                break
    	    end
    	end
    end
end

function TaskModel:addSpecialAward(data)
    table.insert(self.SpecialAward,data)
    dxyDispatcher_dispatchEvent("TaskNode_addSpecialAward",data)
    dxyDispatcher_dispatchEvent("updateAwardTips")
    dxyDispatcher_dispatchEvent("MainScene_updateTaskTips")
end

---sort--------------------------------------------------------
function TaskModel:RankTask(list)
    local function CoupleofSort(t1,t2)
        if t1.State == t2.State then
            if t1.Config.Rank == t2.Config.Rank then 
                return t1.Id < t2.Id
            else
                return t1.Config.Rank > t2.Config.Rank
            end
        else
            return t1.State > t2.State
        end
    end
    table.sort(list,CoupleofSort)
end


--if goodsA.config.Lv == goodsB.config.Lv then
--    if goodsA.config.Quality == goodsB.config.Quality then     
--        return goodsA.config.TypeSub < goodsB.config.TypeSub
--    else      
--        return goodsA.config.Quality > goodsB.config.Quality
--    end
--else
--    return goodsA.config.Lv > goodsB.config.Lv
--end

---GrowUp---------------------------------------------------
function TaskModel:initGrowUp(data)
    if not TaskConfig:getGrowUpById(data.Id) then
        return 
    end
    table.insert(self.arrGrowUp,data)
    self:RankTask(self.arrGrowUp)
end

function TaskModel:cut_arrGrowUp(id)
    if self:isNil(self.arrGrowUp,id) then
        return
    end
--    local reward = TaskConfig:getRewardsById_GrowUp(id)
    local reward = nil
    for i=1,#self.arrGrowUp do
        if self.arrGrowUp[i]["Id"] == id then
            reward = dxyConfig_toList(self.arrGrowUp[i].Config.Rewards)
            table.remove(self.arrGrowUp,i)
            break
        end
    end
    cn:showRewardsGet(reward)
    dxyDispatcher_dispatchEvent("TaskNode_delGrowUp",id)
    dxyDispatcher_dispatchEvent("updateGrowUpTips")
    dxyDispatcher_dispatchEvent("MainScene_updateTaskTips")
end

function TaskModel:add_arrGrowUp(data)
    if not data.Config then
        return
    end
    table.insert(self.arrGrowUp,data)
    self:RankTask(self.arrGrowUp)
    dxyDispatcher_dispatchEvent("TaskNode_addGrowUp",data)
    dxyDispatcher_dispatchEvent("updateGrowUpTips")
    dxyDispatcher_dispatchEvent("MainScene_updateTaskTips")
end

function TaskModel:change_arrGrowUp(id,state)
    if self:isNil(self.arrGrowUp,id) then
        return
    end
    for i,grow in pairs(self.arrGrowUp) do 
        if grow["Id"] == id then
            grow["State"] = state
            break
        end
    end
    self:RankTask(self.arrGrowUp)
    dxyDispatcher_dispatchEvent("TaskNode_changeGrowUp")
    dxyDispatcher_dispatchEvent("updateGrowUpTips")
    dxyDispatcher_dispatchEvent("MainScene_updateTaskTips")
end

---EveryDate--------------------------------------------------
function TaskModel:initEveryDate(data)
    if not TaskConfig:getDailyById(data.Id) then
        return
    end
    table.insert(self.arrEveryDate,data)
    self:RankTask(self.arrEveryDate)
end

function TaskModel:cut_arrEveryDate(id)
    if self:isNil(self.arrEveryDate,id) then
        return
    end
--    local reward = TaskConfig:getRewardsById_Day(id)
    local reward = nil
    for i=1,#self.arrEveryDate do
        if self.arrEveryDate[i]["Id"] == id then
            reward = dxyConfig_toList(self.arrEveryDate[i].Config.Rewards)
            table.remove(self.arrEveryDate,i)
            break
        end
    end
    cn:showRewardsGet(reward)
    dxyDispatcher_dispatchEvent("TaskNode_delEveryDate",id)
    dxyDispatcher_dispatchEvent("updateEveryDateTips")
    dxyDispatcher_dispatchEvent("MainScene_updateTaskTips")
end

function TaskModel:add_arrEveryDate(data)
    if data.Config then
        table.insert(self.arrEveryDate,data)
        self:RankTask(self.arrEveryDate)
        dxyDispatcher_dispatchEvent("TaskNode_addEveryDate",data)
        dxyDispatcher_dispatchEvent("updateEveryDateTips")
        dxyDispatcher_dispatchEvent("MainScene_updateTaskTips")
    end
end

function TaskModel:change_arrEveryDate(id,state)
    if self:isNil(self.arrEveryDate,id) then
        return
    end
    for i,every in pairs(self.arrEveryDate) do 
        if every["Id"] == id then
            every["State"] = state
            break
        end
    end
    self:RankTask(self.arrEveryDate)
    dxyDispatcher_dispatchEvent("TaskNode_changeEveryDate")
    dxyDispatcher_dispatchEvent("updateEveryDateTips")
    dxyDispatcher_dispatchEvent("MainScene_updateTaskTips")
end

function TaskModel:initLivelyData(data)
    self.arrLivelyData = data
    table.sort(self.arrLivelyData.Box,function(t1,t2) return t1.Id < t2.Id end)
    dxyDispatcher_dispatchEvent("TaskNode_updateLively",self.arrLivelyData)
end

---Login--------------------------------------------------
function TaskModel:initLogin(data)
    self.arrLogin = data
end

function TaskModel:changeLogin(data)
    self.arrLogin = data
--    dxyDispatcher_dispatchEvent("EventLoginSV")
    
    dxyDispatcher_dispatchEvent("ItemLogin_changeItem")
    dxyDispatcher_dispatchEvent("updateLoginTips")
    dxyDispatcher_dispatchEvent("MainScene_updateTaskTips")
end

function TaskModel:LoginShowGet(day,crit)
    local str = TaskConfig:getLogin_Tips(day,crit)
    if crit > 1 then
        require "src.game.yuanshen.view.TipsCrit"
        local scene = SceneManager:getCurrentScene()           
        local _csb = TipsCrit:create()
        scene:addChild(_csb)
    end
    dxyFloatMsg:show(str)
end

function TaskModel:LoginShowAllFinish()
    local rewards = dxyConfig_toList(TaskConfig:getAllFinish())
    local str = "" 
    for i=1,#rewards do
        local goods = GoodsConfigProvider:findGoodsById(rewards[i].Id)
        str = str..goods.Name.." ×"..rewards[i].Num.."\n"
    end
    if str ~= "" then
        dxyFloatMsg:show(str)
    end
    dxyDispatcher_dispatchEvent("ItemLogin_updateExtra")
    dxyDispatcher_dispatchEvent("updateLoginTips")
    dxyDispatcher_dispatchEvent("MainScene_updateTaskTips")
end

---TIPS-----------------------------------------------------------
function TaskModel:checkTaskTips()
    local bool = false
    for i=1,#self.arrAward do
        if self.arrAward[i].State == 1 then
            bool = true
            return bool
        end
    end
    
    for i=1,#self.arrGrowUp do
        if self.arrGrowUp[i].State == 1 then
            bool = true
            return bool
        end
    end
    
    for i=1,#self.arrEveryDate do
        if self.arrEveryDate[i].State == 1 then
            bool = true
            return bool
        end
    end
    
    if zzm.TaskModel.arrLogin.State == 1 then
        bool = true
        return bool
    end

    if zzm.TaskModel.arrLogin.AllFinish == 1 then
        bool = true
        return bool
    end
    
    return bool
end

---tips
function TaskModel:showTaskRewards(rewards)
    for key, var in pairs(rewards) do
        if var.Type == 6 then
            local str = ""
--            local goods = GoodsConfigProvider:findGoodsById(var.Id)
--            str = goods.Name.." ×"..var.Num
            local goods = GoodsConfigProvider:findGoodsById(var.Num)
            str = goods.Name.." ×1"
            cn:TipsSchedule(str)
        else
            local str = ""
            str = zzd.TaskData.arrStrType[var.Type].." ×"..var.Num
            cn:TipsSchedule(str)
        end
    end
end

function TaskModel:showTaskRewardsSP(rewards)
    for key, var in pairs(rewards) do
        if var.Type == 6 then
            local str = ""
            local goods = GoodsConfigProvider:findGoodsById(var.Num)
            str = goods.Name.." ×1"
            cn:TipsSchedule(str)
        else
            local str = ""
            str = zzd.TaskData.arrStrType[var.Type].." ×"..var.Num
            cn:TipsSchedule(str)
        end
    end
end

---isNil
function TaskModel:isNil(list,id) 
    for key, var in pairs(list) do
    	if var.Id == id then
    	    return false
    	end
    end
    return true
end

return TaskModel