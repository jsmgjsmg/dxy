
local LotteryDrawController = LotteryDrawController or class("LotteryDrawController")

function LotteryDrawController:ctor()
    self:initController()
    self:registerListenner()
end



function LotteryDrawController:initController()
    local MyTimer = require("game.utils.MyTimer")
    self.m_timer = self.m_timer or MyTimer.new()
    self.m_tipsTimer = self.m_tipsTimer or MyTimer.new()
    self.m_model = zzm.LoadingModel

    self.m_allResources = zzm.LoadingModel.m_allResources

    print("LotteryDrawController initController")
end

function LotteryDrawController:showLayer()
    local scene = SceneManager:getCurrentScene()
    if self.m_view == nil then
        require("game.lotterydraw.view.LotteryDrawLayer")
        self.m_view = LotteryDrawLayer:create()
        scene:addChild(self.m_view)
    else
        self.m_view:updateData()
    end
end

function LotteryDrawController:closeLayer()
    if self.m_view then
        --UIManager:closeUI("LotteryDrawLayer")
        self.m_view:WhenClose()
        self.m_view = nil
    end
end

function LotteryDrawController:showRewardLayer()
    local scene = SceneManager:getCurrentScene()
    if self.m_RewardView == nil then
        require("game.lotterydraw.view.LotteryDrawReward")
        self.m_RewardView = LotteryDrawReward:create()
        scene:addChild(self.m_RewardView)
    end
end

function LotteryDrawController:closeRewardLayer()
    if self.m_RewardView then
        --UIManager:closeUI("LotteryDrawLayer")
        self.m_RewardView:WhenClose()
        self.m_RewardView = nil
    end
end

function LotteryDrawController:request_EnterPanel()
    zzm.LotteryDrawModel._infoList = {}    
    self:request_GetInfoData(1)
    
    self:request_GetInfoData(2)
    
    local msg = mc.packetData:createWritePacket(NetEventType.Req_Lottery_GetData); --编写发送包
    mc.NetMannager:getInstance():sendMsg(msg); --发送 包
end

function LotteryDrawController:request_GetInfoData(infoType)
    local msg = mc.packetData:createWritePacket(NetEventType.Req_Lottery_GetInfoData); --编写发送包
    msg:writeByte(infoType)
    mc.NetMannager:getInstance():sendMsg(msg); --发送 包
end

function LotteryDrawController:request_GetReawerd(reawerdType)
    local msg = mc.packetData:createWritePacket(NetEventType.Req_Lottery_GetRawerd); --编写发送包
    msg:writeByte(reawerdType)
    mc.NetMannager:getInstance():sendMsg(msg); --发送 包
end


-----------------------------------------------------------------
--Network 
--
--initNetwork
function LotteryDrawController:registerListenner()
    _G.NetManagerLuaInst:registerListenner(NetEventType.Rec_Lottery_GetData,self)
    _G.NetManagerLuaInst:registerListenner(NetEventType.Rec_Lottery_GetInfoData,self)
    _G.NetManagerLuaInst:registerListenner(NetEventType.Rec_Lottery_GetRawerd,self)
    _G.NetManagerLuaInst:registerListenner(DefineProto.PROTO_ACTIVITY_TREASURE_FREE_COUNT,self)
end

function LotteryDrawController:unregisterListenner()
    _G.NetManagerLuaInst:unregisterListenner(NetEventType.Rec_Lottery_GetData,self)
    _G.NetManagerLuaInst:unregisterListenner(NetEventType.Rec_Lottery_GetInfoData,self)
    _G.NetManagerLuaInst:unregisterListenner(NetEventType.Rec_Lottery_GetRawerd,self)
    _G.NetManagerLuaInst:unregisterListenner(DefineProto.PROTO_ACTIVITY_TREASURE_FREE_COUNT,self)
end

-----------------------------------------------------------------
--Receive
function LotteryDrawController:dealMsg(msg)
    local cmdType = msg:getpacketCmdType() 
    -- 默认返回false ，表示不中断读取下一个msg
    if cmdType == NetEventType.Rec_Lottery_GetData then
        local onegod = msg:readInt()
        local tengod = msg:readInt()
        zzm.LotteryDrawModel:setRMB(onegod, tengod)
        
        local len = msg:readUshort()
        print("oneGod: ".. onegod .. "  tenGod: ".. tengod .. " Len： " ..len)
        zzm.LotteryDrawModel._rewardList = {}
        
        for var=1, len do
            local data = {}
            data.idx = msg:readByte()
            data.hight = msg:readByte()
            data.type = msg:readByte()
            data.value = msg:readInt()
            data.num = msg:readUshort()
            print("----------------".. var)
            print(data.type)
            print(data.value)
            print(data.num)
            zzm.LotteryDrawModel:addInitReward(data)
        end
        self:showLayer()
    elseif cmdType == NetEventType.Rec_Lottery_GetInfoData then
    
        
        local type = msg:readByte()
        print("type: " .. type)
        if type == 1 then
            local len = msg:readUshort()
            
            print("len: " .. len)
            for var=1, len do
                local data = {}
                data.subtype = 1
                data.seconds = msg:readInt()
                data.uid = msg:readInt()
                data.uname = msg:readString()
                print(data.seconds)
                print(data.uid)
                print(data.uname)
                data.type = msg:readByte()
                data.value = msg:readInt()
                data.num = msg:readUshort()
                zzm.LotteryDrawModel:addInitInfo(data)
            end
        elseif type == 2 then

            local count = msg:readUshort()
            print("count: " .. count)
            for var=1, count do
                local data = {}
                data.subtype =2
                data.seconds = msg:readInt()
                data.type = msg:readByte()
                data.value = msg:readInt()
                data.num = msg:readUshort()
                zzm.LotteryDrawModel:addInitInfo(data)
            end
        
        end
        
    elseif cmdType == NetEventType.Rec_Lottery_GetRawerd then
        local type = msg:readByte()
        if type == 1 then
            local idx = msg:readByte()
            zzm.LotteryDrawModel:addOneReward(idx)
            print("idx: " .. idx)
            dxyDispatcher_dispatchEvent("LotteryDrawLayer.startActionTwo", {index = idx, type = 1})
--            local data = zzm.LotteryDrawModel:getCurrentItem()
--            if data then
--                cn:TipsSchedule("获得了"..cn:GetRewardsInfo(data))
--            end
            
        elseif type == 2 then
        
            zzm.LotteryDrawModel._tenRewardList = {}
            local len = msg:readUshort()
            print("type: " .. type)
           
            print("len: " .. len)
            for var=1, len do
                local data = {}
                data.hight = msg:readByte()
                data.type = msg:readByte()
                data.value = msg:readInt()
                data.num = msg:readUshort()
                zzm.LotteryDrawModel:addTenReward(data)
            end
            dxyDispatcher_dispatchEvent("LotteryDrawLayer.startActionTwo", {index = 1, type = 2})
            --self:showRewardLayer()
        end
        
        --self:request_EnterPanel()
    elseif cmdType == DefineProto.PROTO_ACTIVITY_TREASURE_FREE_COUNT then
        zzm.LotteryDrawModel.freeChanceCount = msg:readUshort()
        dxyDispatcher_dispatchEvent("LotteryDrawLayer_updateBtnTxt")
        dxyDispatcher_dispatchEvent("MainScene_updateLotterDrawTips")
    end   
    return false
end


return LotteryDrawController
