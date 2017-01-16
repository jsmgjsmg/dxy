local ChatController = ChatController or class("ChatController")

function ChatController:ctor()
    self.m_view = nil
    self._model = nil
    self.visibleSize = cc.Director:getInstance():getVisibleSize()
    self.origin = cc.Director:getInstance():getVisibleOrigin()
    self:registerListenner()
    self:initController()
end

function ChatController:initController()
    
    print("ChatController initController")
end

function ChatController:getLayer()
    if self.m_view == nil then
        require("game.chat.view.ChatMainLayer")
        self.m_view = ChatMainLayer:create()
    end
    return self.m_view
end

function ChatController:showLayer(type, p1, p2)
    local scene = SceneManager:getCurrentScene()
    local layer = self:getLayer()
    UIManager:addUI(layer, "ChatMainLayer")
    scene:addChild(layer)
    layer:onSelectByType(type, p1, p2)
    --self:getLayer():setPosition(self.origin.x + self.visibleSize.width / 2,self.origin.y + self.visibleSize.height / 2)
end

function ChatController:switchPriveat(uid, name)
    local layer = self:getLayer()
    layer:onSelectByType(EnumChannelType.Private, uid, name)
end

function ChatController:checkMessage(message)
    local list = luacf.Sensitive.SensitiveConfig.Sensitive.SensitiveName
    for key, var in pairs(list) do
        local data = string.find(message,var.SensitiveWords)
        if data ~= nil then
        	return true
        end
    end
    return false
end

function ChatController:closeLayer()
    if self.m_view then
        UIManager:closeUI("ChatMainLayer")
        self.m_view = nil
    end
end

function ChatController:isOpening()
    if self.m_view then
        return true
    end
    return false
end





-----------------------------------------------------------------
--Network 
--
--initNetwork
function ChatController:registerListenner()
    print(NetEventType.Rec_Chat_MessageItem)
    print(NetEventType.Rec_Chat__InitMessage)
    _G.NetManagerLuaInst:registerListenner(NetEventType.Rec_Chat_MessageItem,self)
    _G.NetManagerLuaInst:registerListenner(6550,self)
end

function ChatController:unregisterListenner()
    _G.NetManagerLuaInst:unregisterListenner(NetEventType.Rec_Chat_MessageItem,self)
    _G.NetManagerLuaInst:unregisterListenner(6550,self)
end

-----------------------------------------------------------------
--Receive
--

function ChatController:request_SendMessage(data)
    print("request_SendMessage message: " .. data.message)
    local msg = mc.packetData:createWritePacket(NetEventType.Req_Chat_SendMessage); --编写发送包
    msg:writeByte(data.channel)
    msg:writeInt(data.uid)
    msg:writeString(data.message)
    mc.NetMannager:getInstance():sendMsg(msg); --发送 包
end
--
function ChatController:dealMsg(msg)
    local cmdType = msg:getpacketCmdType() 
    if cmdType == NetEventType.Rec_Chat_MessageItem then
        self:readOneMessage(msg)
    elseif cmdType == 6550 then
        local len = msg:readUshort()
        for var=1, len do
            self:readOneMessage(msg)
        end
     end
    -- 默认返回false ，表示不中断读取下一个msg
    return false
end

function ChatController:readOneMessage(msg)
    local message = {}
    message.channel = msg:readByte()
    message.special = msg:readUint()
    message.specialname = msg:readString()
    message.uid = msg:readUint()
    message.uname = msg:readString()
    message.message = msg:readString()
    message.time = msg:readUint()
    zzm.ChatModel:addMessage(message)
end

return ChatController