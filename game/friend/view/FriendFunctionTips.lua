
FriendFunctionTips = FriendFunctionTips or class("FriendFunctionTips",function()
    return cc.Node:create()
end)

function FriendFunctionTips:ctor(msg)
    self.m_data = msg
    self:init(msg)
end

function FriendFunctionTips:init(msg)
    local tips = cc.CSLoader:createNode("dxyCocosStudio/csd/ui/friend/FriendFunctionTips.csb")
    SceneManager:getCurrentScene():addChild(self) 
    self:addChild(tips)

    self.visibleSize = cc.Director:getInstance():getVisibleSize()
    self.origin = cc.Director:getInstance():getVisibleOrigin()

    self:setPosition(self.origin.x + self.visibleSize.width/2 , self.origin.y + self.visibleSize.height/2)
    
    local node = tips:getChildByName("BG")
    self.chatBtn = node:getChildByName("Button_3")
    self.deleteBtn = node:getChildByName("Button_4")
    self.showInfoBtn = node:getChildByName("Button_1")
    self.addFriendBtn = node:getChildByName("Button_2")
    
    self.nameTxt = node:getChildByName("NameText")
    if self.nameTxt then   	
        self.nameTxt:setString(FriendFunctionTips.m_data.name)
    end

    if(self.chatBtn)then
        self.chatBtn:addTouchEventListener(function(target,type)
            if(type==2)then
                if FriendFunctionTips.m_data.uid ~= _G.RoleData.Uid then
                    zzc.ChatController:showLayer(EnumChannelType.Private, FriendFunctionTips.m_data.uid, FriendFunctionTips.m_data.name)
                    self:removeFromParent()
                    zzc.FriendController:closeLayer()
                    zzm.FriendModel.recentlyRed = false
                else
                    dxyFloatMsg:show("你选择的是自己！！！")
                    self:removeFromParent()
                end

            end
        end)
    end

    if(self.deleteBtn)then
        self.deleteBtn:addTouchEventListener(function(target,type)
            if(type==2)then
                if FriendFunctionTips.m_data.uid ~= _G.RoleData.Uid then
                    zzc.FriendController:request_DeleteFriend(FriendFunctionTips.m_data.uid)
                    self:removeFromParent()
                else
                    dxyFloatMsg:show("你选择的是自己！！！")
                    self:removeFromParent()
                end

            end
        end)
    end
    
    if(self.showInfoBtn)then
        self.showInfoBtn:addTouchEventListener(function(target,type)
            if(type==2)then
                if FriendFunctionTips.m_data.uid ~= _G.RoleData.Uid then
                    _G.RankData.Uid = FriendFunctionTips.m_data.uid
                    zzc.RoleinfoController:showLayer()
                    self:removeFromParent()
                    zzc.FriendController:closeLayer()
                else
                    dxyFloatMsg:show("你选择的是自己！！！")
                    self:removeFromParent()
                end
            end
        end)
    end
    
    if(self.addFriendBtn)then
        self.addFriendBtn:addTouchEventListener(function(target,type)
            if(type==2)then
                if FriendFunctionTips.m_data.uid ~= _G.RoleData.Uid then
                    zzc.FriendController:request_AddFriend(FriendFunctionTips.m_data.uid)
                    self:removeFromParent()
                else
                    dxyFloatMsg:show("你选择的是自己！！！")
                    self:removeFromParent()
                end

            end
        end)
    end

    -- 拦截
    dxySwallowTouches(self,node)
end

function FriendFunctionTips:create(msg)

    local Tips = FriendFunctionTips.new(msg)
    return Tips

end