local RankingController = class("RankingController")
local NUM = 0

function RankingController:ctor()
    self:registerListener() 
end

function RankingController:registerListener()
--    Rec_Rank_GetLv = 8506,          --接收等级排行
--    Rec_Rank_GetPower = 8507,       --接收战力排行
--    Rec_Rank_GetGroup = 8508,       --接收仙门排行
    _G.NetManagerLuaInst:registerListenner(NetEventType.Rec_Rank_GetLv,self)
    _G.NetManagerLuaInst:registerListenner(NetEventType.Rec_Rank_GetPower,self)
    _G.NetManagerLuaInst:registerListenner(NetEventType.Rec_Rank_GetGroup,self)
    _G.NetManagerLuaInst:registerListenner(NetEventType.Rec_Rank_GroupData,self)
    _G.NetManagerLuaInst:registerListenner(NetEventType.Rec_Group_AskMemberList,self)
    _G.NetManagerLuaInst:registerListenner(DefineProto.PROTO_WAR_RETURN_RANKINGLIST,self)
end

function RankingController:unregisterListenner()
    _G.NetManagerLuaInst:unregisterListenner(NetEventType.Rec_Rank_GetLv,self)
    _G.NetManagerLuaInst:unregisterListenner(NetEventType.Rec_Rank_GetPower,self)
    _G.NetManagerLuaInst:unregisterListenner(NetEventType.Rec_Rank_GetGroup,self)
    _G.NetManagerLuaInst:unregisterListenner(NetEventType.Rec_Rank_GroupData,self)
    _G.NetManagerLuaInst:unregisterListenner(NetEventType.Rec_Group_AskMemberList,self)
    _G.NetManagerLuaInst:unregisterListenner(DefineProto.PROTO_WAR_RETURN_RANKINGLIST,self)
end

---发送消息------------------------------------------------------------
function RankingController:getRankByLv()
    local _strMsg = mc.packetData:createWritePacket(NetEventType.Req_Rank_GetLv)
    mc.NetMannager:getInstance():sendMsg(_strMsg)
    print("~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~send: "..NetEventType.Req_Rank_GetLv)
end

function RankingController:getRankByPower()
    local _strMsg = mc.packetData:createWritePacket(NetEventType.Req_Rank_GetPower)
    mc.NetMannager:getInstance():sendMsg(_strMsg)
    print("~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~send: "..NetEventType.Req_Rank_GetPower)
end

function RankingController:getRankByGroup()
    local _strMsg = mc.packetData:createWritePacket(NetEventType.Req_Rank_GetGroup)
    mc.NetMannager:getInstance():sendMsg(_strMsg)
    print("~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~send: "..NetEventType.Req_Rank_GetGroup)
end

function RankingController:getRankByPK()
    local _strMsg = mc.packetData:createWritePacket(DefineProto.PROTO_WAR_GET_RANKINGLIST)
    mc.NetMannager:getInstance():sendMsg(_strMsg)
    print("~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~send: "..DefineProto.PROTO_WAR_GET_RANKINGLIST)
end

function RankingController:getGroupData(id)
    local _strMsg = mc.packetData:createWritePacket(NetEventType.Req_Rank_GroupData)
    _strMsg:writeInt(id)
    mc.NetMannager:getInstance():sendMsg(_strMsg)
    print("~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~send: "..NetEventType.Req_Rank_GroupData.." id:"..id)
end

--请求仙门成员
function RankingController:AskMemberList(id)
    local _strMsg = mc.packetData:createWritePacket(NetEventType.Req_Group_AskMemberList)
    _strMsg:writeInt(id)
    mc.NetMannager:getInstance():sendMsg(_strMsg)
    print("~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~send: "..NetEventType.Req_Group_AskMemberList.." id "..id)
end

---接收消息------------------------------------------------------------
function RankingController:dealMsg(msg)
    local cmd = msg:getCmd()
    if cmd == NetEventType.Rec_Rank_GetLv then --8506(LV)
        local len = msg:readUbyte()
        print("8506------------------: "..len)
        for i=1,len do 
            local data = {}
            data.Uid = msg:readUint()
            data.Name = msg:readString()
            data.Lv = msg:readUint()
            data.Pro = msg:readUbyte()
            zzm.RankingModel:initRankLv(data)
        end
        zzm.RankingModel:sort(zzm.RankingModel._arrRankLv.List,"Lv")
        dxyDispatcher_dispatchEvent("RankLv_addItem")
        
    elseif cmd == NetEventType.Rec_Rank_GetPower then --8507(Power)
        local len = msg:readUbyte()
        for i=1,len do
            local data = {}
            data.Uid = msg:readUint()
            data.Name = msg:readString()
            data.Power = msg:readUint()
            data.Pro = msg:readUbyte()
            zzm.RankingModel:initRankPower(data)
        end
        zzm.RankingModel:sort(zzm.RankingModel._arrRankPower.List,"Power")
        dxyDispatcher_dispatchEvent("RankPower_addItem")
    
    elseif cmd == NetEventType.Rec_Rank_GetGroup then --8508(Group)
        local len = msg:readUbyte()
        for i=1,len do
            local data = {}
            data.Id = msg:readUint()
            data.Name = msg:readString()
            data.MasterUid = msg:readUint()
            data.Master = msg:readString()
            data.AllPower = msg:readUint()
            zzm.RankingModel:initRankGroup(data)
        end
        zzm.RankingModel:sort(zzm.RankingModel._arrRankGroup.List,"AllPower")
        dxyDispatcher_dispatchEvent("RankGroup_addItem")
        
    elseif cmd == DefineProto.PROTO_WAR_RETURN_RANKINGLIST then --9518(PK)
        zzm.RankingModel._arrRankPK.List = {}
        local len = msg:readUbyte()
        for i=1,len do
            local data = {}
            data.Type = msg:readUbyte()
            data.Uid = msg:readUint()
            data.Name = msg:readString()
            data.Lv = msg:readUint()
            data.Pro = msg:readUbyte()
            data.Rank = msg:readUint()
            data.Reward = msg:readUint()
            zzm.RankingModel:initRankPK(data)
        end
        zzm.RankingModel:cut_sort(zzm.RankingModel._arrRankPK.List,"Rank")
        dxyDispatcher_dispatchEvent("RankPK_addItem")
        dxyDispatcher_dispatchEvent(dxyEventType.Pk_Ranking_Upgrade)
    
    elseif cmd == NetEventType.Rec_Rank_GroupData then --8080（仙门基本信息）
        local data = {}
        data.Id = msg:readUint()
        data.Name = msg:readString()
        data.Master = msg:readString()
        data.Pro = msg:readUbyte()
        data.Lv = msg:readUbyte()
        data.Auto = msg:readUbyte()
        data.Num = msg:readUbyte()
        data.Tenet = msg:readString()
        data.PowerLimit = msg:readUint()
        zzm.RankingModel:initRankGroupBase(data)
        
    elseif cmd == NetEventType.Rec_Group_AskMemberList then --8065(仙门成员)
        local data = {}
        data["num"] = msg:readUbyte()
        for i=1,data["num"] do
            data[i] = {}
            data[i]["uid"] = msg:readUint()
            data[i]["name"] = msg:readString()
            data[i]["lv"] = msg:readUshort()
            data[i]["pro"] = msg:readUbyte()
            data[i]["root"] = msg:readUbyte()
            data[i]["power"] = msg:readUint()
            data[i]["time"] = msg:readUint()
        end
--        zzm.RankingModel:sortRoot(data)
        zzm.RankingModel:addHisMember(data)
        
    end
end

return RankingController