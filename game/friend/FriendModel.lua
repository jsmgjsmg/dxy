local FriendModel = class("FriendModel")
FriendModel.__index = FriendModel

FRIEND_LIST_TYPE =
{
    FriendList = 1,
    ApplyList = 2,
    SearchList = 3,
    GiftList = 4,
}

function FriendModel:ctor()
    self.friendList = {}
    self.redFriendList = {}
    
    self.applyRed = false
    self.recentlyRed = false
    self.giftRed = false
    
    self:initModel()
end

function FriendModel:initModel()
    self.friendList = {}
end

--server back
--插入好友到链表
function FriendModel:insertFriendData(listType,friend)
    if self.friendList[listType] == nil then
        self.friendList[listType] = {}
    end
    table.insert(self.friendList[listType],friend)
--    self.friendList[listType][friend.uid] = friend
    self:sortFriendList(listType)
end

--从好友链表删除数据
function FriendModel:deleteFriendData(listType,friend)
    if self.friendList[listType] == nil then
        self.friendList[listType] = {}
    end
    -- friend 为number时是好友UID
    if type(friend) == "number" then
        for key, var in pairs(self.friendList[listType]) do
        	if var.uid == friend then
                table.remove(self.friendList[listType],key)
        	end
        end
--        self.friendList[listType][friend] = nil
    else
        for key, var in pairs(self.friendList[listType]) do
            if var.uid == friend.uid then
                table.remove(self.friendList[listType],key)
            end
            
        end
--        self.friendList[listType][friend.uid] = nil
    end
end

--从好友链表删除数据
function FriendModel:getFriendDataByType(listType)
    if self.friendList[listType] == nil then
        self.friendList[listType] = {}
    end
    return self.friendList[listType]
end

--更改Gift
function FriendModel:changeGift(uid,type)
    for key, var in pairs(self.friendList[type]) do
        if uid == 0 then
            var.gift = 1 --已赠送
        else
            if var.uid == uid then
                var.gift = 1 --已赠送
            end
        end
	end
end

function FriendModel:sortFriendList(listType)
    if listType ~= FRIEND_LIST_TYPE.FriendList then
    	return
    end
    local function fun(t1,t2)
        if t1.power == t2.power then
            return t1.lv > t2.lv
        else
            return t1.power > t2.power
        end
    end
    table.sort(self.friendList[listType],fun)
end

function FriendModel:getRecentlyList()
	local chatData = zzm.ChatModel:getPriveteData()
    local friendRecentlyList = {}
	for key, var in pairs(chatData) do
        for key1, var1 in pairs(self.friendList[FRIEND_LIST_TYPE.FriendList]) do
            if var1.uid == var[1].special then
            	friendRecentlyList[key1] = var1
                friendRecentlyList[key1].times = var[#var].time
            end
            
		end
	end
    table.sort(friendRecentlyList,function(t1,t2) if t1 and t2 then return t1.times > t2.times end end)
    return friendRecentlyList
end

return FriendModel