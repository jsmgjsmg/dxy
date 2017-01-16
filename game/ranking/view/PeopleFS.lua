local PeopleFS = class("PeopleFS",function()
    return cc.Node:create()
end)

function PeopleFS:ctor()
    self.visibleSize = cc.Director:getInstance():getVisibleSize()
    self.origin = cc.Director:getInstance():getVisibleOrigin()
end

function PeopleFS:create(data)
    local node = PeopleFS:new()
    node:init(data)
    return node
end

function PeopleFS:init(data)
    self._csb = cc.CSLoader:createNode("res/dxyCocosStudio/csd/ui/ranking/PeopleFS.csb")
    self:addChild(self._csb)
    self._csb:setPosition(self.origin.x + self.visibleSize.width / 2, self.origin.y + self.visibleSize.height / 2)

    
    local bg = self._csb:getChildByName("friend_tips_bg")
-- 拦截
    dxySwallowTouches(self,bg)
    
    local txtName = self._csb:getChildByName("txtName")
    txtName:setString(data.Name)

    local btnMsg = self._csb:getChildByName("btnMsg")
    btnMsg:setPressedActionEnabled(true)
    btnMsg:addTouchEventListener(function(target,type)
        if type == 2 then
            SoundsFunc_playSounds(SoundsType.OPEN_PAGE,false)
            _G.RankData.Uid = data.Uid
            zzc.RoleinfoController:showLayer()
            self:removeFromParent()
        end
    end)
    
    local btnAdd = self._csb:getChildByName("btnAdd")
    btnAdd:setPressedActionEnabled(true)
    btnAdd:addTouchEventListener(function(target,type)
        if type == 2 then
            SoundsFunc_playSounds(SoundsType.UNIVERSAL_BTN,false)
            zzc.FriendController:request_AddFriend(data.Uid)
            dxyFloatMsg:show("已发送请求")
            self:removeFromParent()
        end
    end)
    
    local btnTalk = self._csb:getChildByName("btnTalk") 
    btnTalk:setPressedActionEnabled(true)   
    btnTalk:addTouchEventListener(function(target,type)
        if type == 2 then
            zzc.ChatController:showLayer(EnumChannelType.Private, data.Uid, data.Name)
        end
    end)
end

return PeopleFS