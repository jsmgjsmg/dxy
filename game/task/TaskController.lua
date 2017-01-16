local TaskController = TaskController or class("TaskController")

function TaskController:ctor()
    self:registerListener()
    self._isFirst = true
end

------- 注册/删除消息
function TaskController:registerListener()
    _G.NetManagerLuaInst:registerListenner(NetEventType.Rec_Task_InitTask,self)
    _G.NetManagerLuaInst:registerListenner(NetEventType.Rec_Task_GetLogin,self)
    _G.NetManagerLuaInst:registerListenner(NetEventType.Rec_Task_FinishTask,self)
    _G.NetManagerLuaInst:registerListenner(NetEventType.Rec_Task_UpDateEvent,self)
    _G.NetManagerLuaInst:registerListenner(NetEventType.Rec_Task_GetGrowUp,self)
    _G.NetManagerLuaInst:registerListenner(NetEventType.Rec_Task_GetEveryDate,self)
    _G.NetManagerLuaInst:registerListenner(NetEventType.Rec_Task_GetAward,self)
    _G.NetManagerLuaInst:registerListenner(DefineProto.PROTO_TASK_RETURN_FINISH_NEWTASK,self)
    _G.NetManagerLuaInst:registerListenner(DefineProto.PROTO_TASK_NEWTASK_LIST,self)
    _G.NetManagerLuaInst:registerListenner(DefineProto.PROTO_TASK_ADD_NEWTASK,self)
    _G.NetManagerLuaInst:registerListenner(DefineProto.PROTO_TASK_RETURN_LIVELY,self)
    _G.NetManagerLuaInst:registerListenner(DefineProto.PROTO_TASK_RETURN_LIVELY_ID,self)
end 

function TaskController:unregisterListenner()
    _G.NetManagerLuaInst:unregisterListenner(NetEventType.Rec_Task_InitTask,self)
    _G.NetManagerLuaInst:unregisterListenner(NetEventType.Rec_Task_GetLogin,self)
    _G.NetManagerLuaInst:unregisterListenner(NetEventType.Rec_Task_FinishTask,self)
    _G.NetManagerLuaInst:unregisterListenner(NetEventType.Rec_Task_UpDateEvent,self)
    _G.NetManagerLuaInst:unregisterListenner(NetEventType.Rec_Task_GetGrowUp,self)
    _G.NetManagerLuaInst:unregisterListenner(NetEventType.Rec_Task_GetEveryDate,self)
    _G.NetManagerLuaInst:unregisterListenner(NetEventType.Rec_Task_GetAward,self)
    _G.NetManagerLuaInst:unregisterListenner(DefineProto.PROTO_TASK_RETURN_FINISH_NEWTASK,self)
    _G.NetManagerLuaInst:unregisterListenner(DefineProto.PROTO_TASK_NEWTASK_LIST,self)
    _G.NetManagerLuaInst:unregisterListenner(DefineProto.PROTO_TASK_ADD_NEWTASK,self)
    _G.NetManagerLuaInst:unregisterListenner(DefineProto.PROTO_TASK_RETURN_LIVELY,self)
    _G.NetManagerLuaInst:unregisterListenner(DefineProto.PROTO_TASK_RETURN_LIVELY_ID,self)
end 

function TaskController:showLayer()
    require "game.task.view.TaskNode"
    self._layer = TaskNode.new()
    local scene = SceneManager:getCurrentScene()
    scene:addChild(self._layer)
    zzm.CharacterModel.isTipsToGoods = false
end

function TaskController:closeLayer()
    if self._layer then
        self._layer:removeFromParent()
        self._layer = nil
    end
    zzm.CharacterModel.isTipsToGoods = true
end

---发送消息-------------------------------------------------------------------
--初始化所有任务
--function TaskController:registerInitTask()
--    local _strMsg = mc.packetData:createWritePacket(NetEventType.Req_Task_InitTask)
--    mc.NetMannager:getInstance():sendMsg(_strMsg)
--    print("send: "..NetEventType.Req_Task_InitTask)
--end

--领取奖励任务奖励
function TaskController:registerGetAwardDate(id)
    local _strMsg = mc.packetData:createWritePacket(NetEventType.Req_Task_GetAward)
    _strMsg:writeInt(id)
    mc.NetMannager:getInstance():sendMsg(_strMsg)
    print("~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~send: "..NetEventType.Req_Task_GetAward.." id:"..id)
end

--领取特别任务
function TaskController:registerGetSpecialAward(id)
    local _strMsg = mc.packetData:createWritePacket(DefineProto.PROTO_TASK_FINISH_NEWTASK)
    _strMsg:writeInt(id)
    mc.NetMannager:getInstance():sendMsg(_strMsg)
    print("~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~send: "..DefineProto.PROTO_TASK_FINISH_NEWTASK.." id:"..id)
end

--领取每天登陆奖励
function TaskController:registerGetLogin()
    local _strMsg = mc.packetData:createWritePacket(NetEventType.Req_Task_GetLogin)
    mc.NetMannager:getInstance():sendMsg(_strMsg)
    print("~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~send: "..NetEventType.Req_Task_GetLogin)
end

--领取每天任务
function TaskController:registerGetEveryDate(id)
    local _strMsg = mc.packetData:createWritePacket(NetEventType.Req_Task_GetEveryDate)
    _strMsg:writeInt(id)
    mc.NetMannager:getInstance():sendMsg(_strMsg)
    print("~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~send: "..NetEventType.Req_Task_GetEveryDate.." id:"..id)
end

--领取成长奖励
function TaskController:registerGetGrowUp(id)
    local _strMsg = mc.packetData:createWritePacket(NetEventType.Req_Task_GetGrowUp)
    _strMsg:writeInt(id)
    mc.NetMannager:getInstance():sendMsg(_strMsg)
    print("~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~send: "..NetEventType.Req_Task_GetGrowUp.." id:"..id)
end

--领取全勤
function TaskController:registerGetAllFinish()
    local _strMsg = mc.packetData:createWritePacket(NetEventType.Req_Task_AllFinish)
    mc.NetMannager:getInstance():sendMsg(_strMsg)
    print("~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~send: "..NetEventType.Req_Task_AllFinish)
end

--补签
function TaskController:MakeUp()
    local _strMsg = mc.packetData:createWritePacket(NetEventType.Req_Task_MakeUp)
    mc.NetMannager:getInstance():sendMsg(_strMsg)
    print("~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~send: "..NetEventType.Req_Task_MakeUp)
end

--领取活跃度奖励
function TaskController:getLively(id)
    local _strMsg = mc.packetData:createWritePacket(DefineProto.PROTO_TASK_GET_LIVELY)
    _strMsg:writeInt(id)
    mc.NetMannager:getInstance():sendMsg(_strMsg)
    print("~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~send: "..DefineProto.PROTO_TASK_GET_LIVELY.." id "..id)
end

-------接收消息-------------------------------------------------------------------
function TaskController:dealMsg(msg)
    local cmd = msg:getCmd()
    if cmd == NetEventType.Rec_Task_InitTask then --3505(初始化所有任务)
        --每天登陆
        local Login = {}
        Login.Day = msg:readUbyte()
        Login.State = msg:readUbyte()
        Login.Finish = msg:readUbyte()
        Login.Start = msg:readUbyte()
        Login.AllFinish = msg:readUbyte()
        zzm.TaskModel:initLogin(Login)
        
        --每日任务
        zzm.GroupModel.arrEveryDate = {}
        local len = msg:readUbyte()
        for i=1,len do
            local EveryDate = {}
            EveryDate.Id = msg:readUint()
            EveryDate.State = msg:readUbyte()
            EveryDate.Config = TaskConfig:getDailyById(EveryDate.Id) or nil
            zzm.TaskModel:initEveryDate(EveryDate)
        end
        
        --成长任务
        zzm.GroupModel.arrGrowUp = {}
        local len = msg:readUbyte()
        for i=1,len do
            local GrowUp = {}
            GrowUp.Id = msg:readUint()
            GrowUp.State = msg:readUbyte()
            GrowUp.Config = TaskConfig:getGrowUpById(GrowUp.Id) or nil
            zzm.TaskModel:initGrowUp(GrowUp)
        end 
        
        --奖励任务
        zzm.GroupModel.arrAward = {}
        local len = msg:readUbyte()
        for i=1,len do
            local Award = {}
            Award.Id = msg:readUint()
            Award.State = msg:readUbyte()
            Award.Config = TaskConfig:getWantById(Award.Id) or nil
            zzm.TaskModel:initAward(Award)
        end
        
    elseif cmd == NetEventType.Rec_Task_GetLogin then --3515(接收签到任务/补签)
        local Login = {}
        Login.Day = msg:readUbyte()
        Login.State = msg:readUbyte()
        Login.Finish = msg:readUbyte()
        Login.Start = msg:readUbyte()
        Login.AllFinish = msg:readUbyte()
        Login.Crit = msg:readUbyte()
        if Login.AllFinish == 2 then
            zzm.TaskModel:LoginShowAllFinish()
        else
            zzm.TaskModel:LoginShowGet(Login.Day,Login.Crit)
        end
        zzm.TaskModel:changeLogin(Login)
    
    elseif cmd == NetEventType.Rec_Task_FinishTask then --3520(完成任务，可领取奖励)
        local type = msg:readUbyte()
        local id = msg:readUint()
        local state = msg:readUbyte()
        if type == 2 then
            zzm.TaskModel:change_arrEveryDate(id,state) --每日任务
        elseif type == 3 then
            zzm.TaskModel:change_arrGrowUp(id,state) --成长任务
        elseif type == 4 then
            zzm.TaskModel:change_arrAward(id,state) --奖励
        end
        print("**********************************************************NetEventType.Rec_Task_FinishTask "..type)
    
    elseif cmd == NetEventType.Rec_Task_UpDateEvent then --3525(新增任务)
        local type = msg:readUbyte()
        local id = msg:readUint()
        local state = msg:readUbyte()
        if type == 2 then
            local EveryDate = {}
            EveryDate.Id = id
            EveryDate.State = state
            EveryDate.Config = TaskConfig:getDailyById(EveryDate.Id) or nil
            zzm.TaskModel:add_arrEveryDate(EveryDate) --每日任务
        elseif type == 3 then
            local GrowUp = {}
            GrowUp.Id = id
            GrowUp.State = state
            GrowUp.Config = TaskConfig:getGrowUpById(GrowUp.Id) or nil
            zzm.TaskModel:add_arrGrowUp(GrowUp) --成长任务
        elseif type == 4 then
            local Award = {}
            Award.Id = id
            Award.State = state
            Award.Config = TaskConfig:getWantById(Award.Id) or nil
            zzm.TaskModel:add_arrAward(Award) --奖励
        end
    
    elseif cmd == NetEventType.Rec_Task_GetGrowUp then --3535(成长领取)
        local id = msg:readUint()
        local state = msg:readUbyte()
        if state == 2 then
            zzm.TaskModel:cut_arrGrowUp(id)
        else
            print("Error  3535")
        end
        
    elseif cmd == NetEventType.Rec_Task_GetEveryDate then --3545(每日领取)
        local id = msg:readUint()
        local state = msg:readUbyte()
        if state == 2 then
            zzm.TaskModel:cut_arrEveryDate(id)
        else
            print("Error  3545")
        end
        
    elseif cmd == NetEventType.Rec_Task_GetAward then --3555(奖励领取)
        local id = msg:readUint()
        local state = msg:readUbyte()
        if state == 2 then
            zzm.TaskModel:cut_arrAward(id)
        else
            print("Error  3555")
        end
        
    elseif cmd == DefineProto.PROTO_TASK_NEWTASK_LIST then --3506(初始特别的奖励)
        local len = msg:readUbyte()
        for i=1,len do
            local data = {}
            data.Id = msg:readUint()
            data.Type = msg:readUbyte()
            data.SecType = msg:readUbyte()
            data.State = msg:readUbyte()
            local len2 = msg:readUbyte()
            data.Reward = {}
            for j=1,len2 do
                local list = {}
                list.Type = msg:readUbyte()
                if list.Type == 6 or list.Type == 10 then
                    list.Id = msg:readUint()
                end
                list.Num = msg:readUint()
                table.insert(data.Reward,list)
            end
            zzm.TaskModel:initSpecialAward(data)
        end
        
    elseif cmd == DefineProto.PROTO_TASK_RETURN_FINISH_NEWTASK then --3580(返回特别的奖励)
        local data = {}
        data.Id = msg:readUint()
        data.State = msg:readUbyte()
        zzm.TaskModel:cutSpecialAward(data)
        
    elseif cmd == DefineProto.PROTO_TASK_ADD_NEWTASK then --3570(新增特别的奖励)        
        local data = {}
        data.Id = msg:readUint()
        data.Type = msg:readUbyte()
        data.SecType = msg:readUbyte()
        data.State = msg:readUbyte()
        local len2 = msg:readUbyte()
        data.Reward = {}
        for j=1,len2 do
            local list = {}
            list.Type = msg:readUbyte()
            if list.Type == 6 or list.Type == 10 then
                list.Id = msg:readUint()
            end
            list.Num = msg:readUint()
            table.insert(data.Reward,list)
        end
        zzm.TaskModel:addSpecialAward(data)
        
    elseif cmd == DefineProto.PROTO_TASK_RETURN_LIVELY then --3585(初始每日活跃)
        local data = {}
        data.Lively = msg:readUshort()
        local len = msg:readUbyte()
        data.Box = {}
        for i=1,len do
            data.Box[i] = {}
            data.Box[i].Id = msg:readUint()
            data.Box[i].State = msg:readUbyte()
        end
        zzm.TaskModel:initLivelyData(data)
    
    elseif cmd == DefineProto.PROTO_TASK_RETURN_LIVELY_ID then --3595(领取活跃奖励) 
        local id = msg:readUint()
        local config = TaskConfig:getLivelyBox(id)
        cn:showRewardsGet(config.Rewards)
    
    end
end

return TaskController