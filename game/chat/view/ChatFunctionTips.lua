
ChatFunctionTips = ChatFunctionTips or class("ChatFunctionTips",function()
    return cc.Node:create()
end)

function ChatFunctionTips:ctor(msg)
    self.m_data = msg
    self:init(msg)
end

function ChatFunctionTips:init(msg)
    local tips = cc.CSLoader:getInstance():createNodeWithFlatBuffersFile("dxyCocosStudio/csd/ui/chat/ChatFunctionTips.csb")
    SceneManager:getCurrentScene():addChild(self) 
    self:addChild(tips)

    self.visibleSize = cc.Director:getInstance():getVisibleSize()
    self.origin = cc.Director:getInstance():getVisibleOrigin()

    self:setPosition(self.origin.x + self.visibleSize.width/2 , self.origin.y + self.visibleSize.height/2)
    
    local node = tips:getChildByName("BG")
    self.Btn1 = node:getChildByName("Button_1")
    self.Btn2 = node:getChildByName("Button_2")
    self.Btn3 = node:getChildByName("Button_3")
    self.titleText = node:getChildByName("NameText")
    local name = self.m_data.uname
    self.titleText:setString(name)

    -- 查看信息
    if(self.Btn1)then
        self.Btn1:addTouchEventListener(function(target,type)
            if(type==2)then
                _G.RankData.Uid = self.m_data.uid
                zzc.RoleinfoController:showLayer()
                self:removeFromParent()
            end
        end)
    end
    
    --添加好友
    if(self.Btn2)then
        self.Btn2:addTouchEventListener(function(target,type)
            if(type==2)then
                zzc.FriendController:request_AddFriend(self.m_data.uid)
                dxyFloatMsg:show("申请已发送！等待对方确认。")
                self:removeFromParent()
            end
        end)
    end

    --与他聊天
    if(self.Btn3)then
        self.Btn3:addTouchEventListener(function(target,type)
            if(type==2)then
                zzc.ChatController:switchPriveat(self.m_data.uid, self.m_data.uname)
                self:removeFromParent()
            end
        end)
    end
    -- 拦截
    dxySwallowTouches(self,node)
end

function ChatFunctionTips:create(msg)

    local Tips = ChatFunctionTips.new(msg)
    return Tips

end