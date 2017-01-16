local ChatModel = class("ChatModel")
ChatModel.__index = ChatModel

EnumChannelType = 
{
    World = 1,
    Faction = 2,
    Private = 3,
    Team = 4,
    System = 5,
    AddFaction = 6,
    AddTeam = 7,
    
    
}

function ChatModel:ctor()
    self:initModel()
end

function ChatModel:initModel()
    self._MaxMessageNum = 100
    self._chatList = {}
    self.RedChatList = {}
end

function ChatModel:addMessage(message)
    if message == nil or message.channel == nil then
    	return
    end
    
    local ret = nil
    if self._chatList[message.channel] == nil then
        self._chatList[message.channel] = {}
    end
    
    if message.channel == EnumChannelType.Private then
        if self._chatList[message.channel][message.special] == nil then
            self._chatList[message.channel][message.special] = {}
    	end
        ret = self._chatList[message.channel][message.special]
        local isRed = false
        if zzm.FriendModel.friendList[1] then
            for key, var in pairs(zzm.FriendModel.friendList[1]) do--FRIEND_LIST_TYPE.FriendList
                if var.uid == message.special then
                    isRed = true
            end
            end
        end
        if isRed then
            dxyDispatcher_dispatchEvent("FriendMainLayer_updateFriendRed",{type = 3, flag = true})-- recently
            dxyDispatcher_dispatchEvent("MainScene_updateFriendRedIcon",true)
            zzm.FriendModel.recentlyRed = true
        end
    else
        if message.channel == EnumChannelType.AddFaction then
            message.channel = EnumChannelType.World
            message.subType = 1 --世界内仙门招募
            local str = dxyStringSplit(message.specialname,"#") 
            message.power = str[1]
            message.specialname = str[2]
            message.factionName = message.message
            message.message = "                       " .. "诚邀你加入，让我们一起雄霸天下吧！！！"
        elseif message.channel == EnumChannelType.AddTeam then
            message.channel = EnumChannelType.World
            message.subType = 2 --仙门内组队招募
            message.power = message.specialname
            message.factionName = message.message
            message.message = "[".. message.uname .. "] :我正在爬塔攻击第" .. message.factionName .. "层BOSS，请求协助！！！"
        end
        if self._chatList[message.channel] == nil then
            self._chatList[message.channel] = {}
        end
        ret = self._chatList[message.channel]
    end
    if ret == nil then
    	return
    end
    if #ret >= self._MaxMessageNum then
        table.remove(ret,1)
    end
    table.insert(ret,#ret+1,message)
    print(message.channel)
    print(message.special)
    print(message.specialname)
    print(message.uid)
    print(message.uname)
    print(message.message)
    print(message.time)
    dxyDispatcher_dispatchEvent("dxyEventType.Chat_Add_Message",message)
    dxyDispatcher_dispatchEvent("MainScene_updateChatRedIcon", true)
    dxyDispatcher_dispatchEvent("ChatMainLayer_updateRedPoint", {type = message.channel, flag = true})
    self.RedChat = true
    self.RedChatList[message.channel] = true
    
end

function ChatModel:getMessageByChannel(channelType)
    if self._chatList[channelType] == nil then
    	return {}
    end
    return self._chatList[channelType]
end

function ChatModel:getMessageByUID(uid)
    if self._chatList[EnumChannelType.Private] == nil then
    	return {}
    end
    if self._chatList[EnumChannelType.Private][uid] == nil then
        return {}
    end
    return self._chatList[EnumChannelType.Private][uid]
end

function ChatModel:getPriveteData()
    if self._chatList[EnumChannelType.Private] == nil then
        return {}
    end
    return self._chatList[EnumChannelType.Private]
end

function ChatModel:getPriveteRoleName(uid)
    local message = self:getMessageByUID(uid)
    if message[1] ~= nil then
        return message[1].specialname
    end
    return uid
end

return ChatModel