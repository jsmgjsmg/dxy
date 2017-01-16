--单个好友数据结构

local FriendData = FriendData or class("FriendData")

function FriendData:ctor()
    self.uid = 0
    self.name = ""
    self.pro = nil
    self.lv = 0
    self.times = 0
    self.power = 0
    self.gift = 0
end 

--读表，计算部分属性
function FriendData:init()

end

--读取服务器下发数据
function FriendData:readMsg(msg)
    self.uid = msg:readUint()
    self.name = msg:readString()
    self.pro = msg:readByte()
    self.lv = msg:readUshort()
    self.power = msg:readUint()
    self.times = msg:readUint()
    
    self:init()
    print("FriendData uid: ".. self.uid .. "  name:".. self.name .. "  lv:".. self.lv.. "  pro:".. self.pro.."  power:"..self.power)
end

function FriendData:getType()
    return self.config.Type
end

function FriendData:setGift(id)
    self.gift = id
end

return FriendData