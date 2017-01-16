
local FriendController = FriendController or class(" FriendController")



function FriendController:ctor()
    self.m_view = nil
    self.announcementItem = nil
    self._model = nil
    self:initController()
    self:registerListenner()
end 

function FriendController:initController()

    print("FriendController initController")
end

-- 打开副本信息界面
function FriendController:showCopyDetails(data)
    if self.m_copyDetails == nil then
        self.m_copyDetails = CopyDetails.create()
        self.m_copyDetails:retain()
    end
    self.m_copyDetails:update(data)
    local scene = SceneManager:getCurrentScene()
    scene:addChild(self.m_copyDetails)
end

-- 关闭副本信息界面
function FriendController:closeCopyDetails()
    if self.m_copyDetails ~= nil then
        local scene = SceneManager:getCurrentScene()
        scene:removeChild(self.m_copyDetails)
    end
end

-- 打开关卡选择界面
function FriendController:showLayer()
    if self.m_view == nil then
        self.m_view = CopySelectLayer.create()
        --self.m_view:retain()
    end
    local scene = SceneManager:getCurrentScene()
    scene:addChild(self.m_view)
end

-- 关闭关卡选择界面
function FriendController:closeLayer()
    if self.m_view ~= nil then
        --        local scene = SceneManager:getCurrentScene()
        --        scene:removeChild(self.m_view)
        self.m_view:removeFromParent()
        self.m_view = nil
    end
end

-----------------------------------------------------------------
--Network 
--
--initNetwork
function FriendController:registerListenner()
    _G.NetManagerLuaInst:registerListenner(NetEventType.Rec_Friend_FriendList,self)
    _G.NetManagerLuaInst:registerListenner(NetEventType.Rec_Friend_ApplyList,self)
    _G.NetManagerLuaInst:registerListenner(NetEventType.Rec_Friend_DeleteOK,self)
    _G.NetManagerLuaInst:registerListenner(NetEventType.Rec_Friend_SearchList,self)
    _G.NetManagerLuaInst:registerListenner(NetEventType.Rec_Friend_NewFriend,self)
    _G.NetManagerLuaInst:registerListenner(NetEventType.Rec_Friend_NewApplyFriend,self)
    _G.NetManagerLuaInst:registerListenner(NetEventType.Rec_Friend_GiftList,self)
    _G.NetManagerLuaInst:registerListenner(NetEventType.Rec_Friend_ApplyDelete,self)
    _G.NetManagerLuaInst:registerListenner(NetEventType.Rec_Friend_GiftUpdate,self)
end

function FriendController:unregisterListenner()
    _G.NetManagerLuaInst:unregisterListenner(NetEventType.Rec_Friend_FriendList,self)
    _G.NetManagerLuaInst:unregisterListenner(NetEventType.Rec_Friend_ApplyList,self)
    _G.NetManagerLuaInst:unregisterListenner(NetEventType.Rec_Friend_DeleteOK,self)
    _G.NetManagerLuaInst:unregisterListenner(NetEventType.Rec_Friend_SearchList,self)
    _G.NetManagerLuaInst:unregisterListenner(NetEventType.Rec_Friend_NewFriend,self)
    _G.NetManagerLuaInst:unregisterListenner(NetEventType.Rec_Friend_NewApplyFriend,self)
    _G.NetManagerLuaInst:unregisterListenner(NetEventType.Rec_Friend_GiftList,self)
    _G.NetManagerLuaInst:unregisterListenner(NetEventType.Rec_Friend_ApplyDelete,self)
    _G.NetManagerLuaInst:unregisterListenner(NetEventType.Rec_Friend_GiftUpdate,self)

end

-----------------------------------------------------------------
--Request
--
---- 请求搜索好友 
function FriendController:request_InitFriend()
    zzm.FriendModel:initModel()
    print("request_InitFriend  ")
    local msg = mc.packetData:createWritePacket(NetEventType.Req_Friend_InitFriend); --编写发送包
    mc.NetMannager:getInstance():sendMsg(msg); --发送 包
end

-- 请求添加好友 
function FriendController:request_AddFriend(uid)
    print("request_AddFriend  " .. uid)
    local msg = mc.packetData:createWritePacket(NetEventType.Req_Friend_AddFriend); --编写发送包
    msg:writeInt(uid)
    mc.NetMannager:getInstance():sendMsg(msg); --发送 包
end

-- 请求删除好友 
function FriendController:request_DeleteFriend(uid)
    print("request_DeleteFriend  " .. uid)
    local msg = mc.packetData:createWritePacket(NetEventType.Req_Friend_DeleteFriend); --编写发送包
    msg:writeInt(uid)
    mc.NetMannager:getInstance():sendMsg(msg); --发送 包
end

-- 请求搜索好友 
function FriendController:request_SearchFriend(name)
    local list = zzm.FriendModel:getFriendDataByType(FRIEND_LIST_TYPE.SearchList)
    list = {}

    print("request_SearchFriend  " .. name)
    local msg = mc.packetData:createWritePacket(NetEventType.Req_Friend_SearchFriend); --编写发送包
    msg:writeString(name)
    mc.NetMannager:getInstance():sendMsg(msg); --发送 包
end

-- 接受礼物
function FriendController:request_AcceptGift(giftID)
    print("request_AcceptGift  " .. giftID)
    local msg = mc.packetData:createWritePacket(NetEventType.Req_Friend_AcceptGift); --编写发送包
    msg:writeInt(giftID)
    mc.NetMannager:getInstance():sendMsg(msg); --发送 包
end

-- 好友申请处理
function FriendController:request_AcceptFriend(uid, type)
    print("request_AcceptFriend  " .. uid)
    local msg = mc.packetData:createWritePacket(NetEventType.Req_Friend_AcceptFriend); --编写发送包
    msg:writeInt(uid)
    msg:writeByte(type)
    mc.NetMannager:getInstance():sendMsg(msg); --发送 包
end

-- 赠送礼物 
function FriendController:request_GiveGift(uid,type)
    print("request_GiveGift  " .. uid)
    local msg = mc.packetData:createWritePacket(NetEventType.Req_Friend_GiveGift); --编写发送包
    msg:writeInt(uid)
    mc.NetMannager:getInstance():sendMsg(msg); --发送 包
    zzm.FriendModel:changeGift(uid,type)
end

-----------------------------------------------------------------
--Receive
function FriendController:dealMsg(msg)
    local cmdType = msg:getpacketCmdType()
    if cmdType == NetEventType.Rec_Friend_FriendList then
        local count = msg:readUshort()
        print("Rec_Friend_FriendList count:"..count)
        for index=1, count do
            local friend = zzd.FriendData.new()
            friend:readMsg(msg)
            local isGift = msg:readByte()
            friend:setGift(isGift)
            zzm.FriendModel:insertFriendData(FRIEND_LIST_TYPE.FriendList,friend)
        end
        dxyDispatcher_dispatchEvent(dxyEventType.Friend_List_Update, FRIEND_LIST_TYPE.FriendList)
    elseif cmdType == NetEventType.Rec_Friend_ApplyList then
        local count = msg:readUshort()
        print("Rec_Friend_ApplyList count:"..count)
        for index=1, count do
            local friend = zzd.FriendData.new()
            friend:readMsg(msg)
            zzm.FriendModel:insertFriendData(FRIEND_LIST_TYPE.ApplyList,friend)
            dxyDispatcher_dispatchEvent("FriendMainLayer_updateFriendRed",{type = 2, flag = true})--FRIEND_PANEL_TYPE.ApplyLayer
            dxyDispatcher_dispatchEvent("MainScene_updateFriendRedIcon",true)
            zzm.FriendModel.applyRed = true
        end
        dxyDispatcher_dispatchEvent(dxyEventType.Friend_List_Update, FRIEND_LIST_TYPE.ApplyList)
    elseif cmdType == NetEventType.Rec_Friend_DeleteOK then
        local uid = msg:readUint()
        zzm.FriendModel:deleteFriendData(FRIEND_LIST_TYPE.FriendList,uid)
        dxyDispatcher_dispatchEvent("FriendUpListPage_DeletItem",uid)
    elseif cmdType == NetEventType.Rec_Friend_SearchList then
        local count = msg:readUshort()
        print("Rec_Friend_SearchList count:"..count)
        for index=1, count do
            local friend = zzd.FriendData.new()
            friend:readMsg(msg)
            local isRepeatUid = false
            for key, var in pairs(zzm.FriendModel.friendList[FRIEND_LIST_TYPE.SearchList]) do
            	if var.uid == friend.uid then
            		isRepeatUid = true
            	end
            end
            if isRepeatUid == false then
            	zzm.FriendModel:insertFriendData(FRIEND_LIST_TYPE.SearchList,friend)
            end
            
        end
        dxyDispatcher_dispatchEvent(dxyEventType.Friend_List_Update, FRIEND_LIST_TYPE.SearchList)
    elseif cmdType == NetEventType.Rec_Friend_GiftList then
        local count = msg:readUshort()
        print("Rec_Friend_GiftList count:"..count)
        for index=1, count do
            local giftID = msg:readUint()
            local friend = zzd.FriendData.new()
            friend:readMsg(msg)
            friend:setGift(giftID)
            zzm.FriendModel:insertFriendData(FRIEND_LIST_TYPE.GiftList,friend)
            dxyDispatcher_dispatchEvent("FriendMainLayer_updateFriendRed",{type = 4, flag = true})--FRIEND_PANEL_TYPE.GiftLayer
            dxyDispatcher_dispatchEvent("MainScene_updateFriendRedIcon",true)
            zzm.FriendModel.giftRed = true
        end
    elseif cmdType == NetEventType.Rec_Friend_NewFriend then
        local friend = zzd.FriendData.new()
        friend:readMsg(msg)
        local giftID = msg:readByte()
        friend:setGift(giftID)
        zzm.FriendModel:insertFriendData(FRIEND_LIST_TYPE.FriendList,friend)
        
    elseif cmdType == NetEventType.Rec_Friend_NewApplyFriend then
        local friend = zzd.FriendData.new()
        friend:readMsg(msg)
        zzm.FriendModel:insertFriendData(FRIEND_LIST_TYPE.ApplyList,friend)
        dxyDispatcher_dispatchEvent(dxyEventType.Friend_List_Update, FRIEND_LIST_TYPE.ApplyList)
        dxyDispatcher_dispatchEvent("FriendMainLayer_updateFriendRed",{type = 2, flag = true})--FRIEND_PANEL_TYPE.ApplyLayer
        dxyDispatcher_dispatchEvent("MainScene_updateFriendRedIcon",true)
        zzm.FriendModel.applyRed = true
    elseif cmdType == NetEventType.Rec_Friend_ApplyDelete then
        local uid = msg:readUint()
        zzm.FriendModel:deleteFriendData(FRIEND_LIST_TYPE.ApplyList,uid)
        if zzm.FriendModel.friendList[FRIEND_LIST_TYPE.ApplyList] then
            if next(zzm.FriendModel.friendList[FRIEND_LIST_TYPE.ApplyList]) == nil then
                zzm.FriendModel.applyRed = false
            end
        end
        dxyDispatcher_dispatchEvent(dxyEventType.Friend_List_Update, FRIEND_LIST_TYPE.ApplyList)
    elseif cmdType == NetEventType.Rec_Friend_GiftUpdate then
        local giftID = msg:readUint()
        local friend = zzd.FriendData.new()
        friend:readMsg(msg)
        friend:setGift(giftID)
        zzm.FriendModel:insertFriendData(FRIEND_LIST_TYPE.ApplyList,friend)
        
--        zzm.FriendModel.giftRed = true
        dxyDispatcher_dispatchEvent(dxyEventType.Friend_List_Update, FRIEND_LIST_TYPE.GiftList)
    --接收副本结果返回
    end   
    -- 默认返回false ，表示不中断读取下一个msg
    return false

end



return FriendController

