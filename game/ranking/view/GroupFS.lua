local GroupFS = class("GroupFS",function()
    return cc.Node:create()
end)

function GroupFS:ctor()
    self.visibleSize = cc.Director:getInstance():getVisibleSize()
    self.origin = cc.Director:getInstance():getVisibleOrigin()
end

function GroupFS:create(data)
    local node = GroupFS:new()
    node:init(data)
    return node
end

function GroupFS:init(data)
    self._csb = cc.CSLoader:createNode("res/dxyCocosStudio/csd/ui/ranking/GroupFS.csb")
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
            zzc.RankingController:getGroupData(data.Id)
            zzc.RankingController:AskMemberList(data.Id)
            local fs = require("src/game/ranking/view/GroupMsg.lua"):create()
            SceneManager:getCurrentScene():addChild(fs)
            self:removeFromParent()
        end
    end)

    local btnJoin = self._csb:getChildByName("btnJoin")
    btnJoin:setPressedActionEnabled(true)
    btnJoin:addTouchEventListener(function(target,type)
        if type == 2 then
            SoundsFunc_playSounds(SoundsType.UNIVERSAL_BTN,false)
            if _G.GroupData.State == 1 then
                dxyFloatMsg:show("你已加入仙门")
            else
                zzc.GroupController:JoinGroup(data.Id)
--                dxyFloatMsg:show("已发送请请求")
            end
            self:removeFromParent()
        end
    end)

    local btnTalk = self._csb:getChildByName("btnTalk")   
    btnTalk:setPressedActionEnabled(true) 
    btnTalk:addTouchEventListener(function(target,type)
        if type == 2 then
            SoundsFunc_playSounds(SoundsType.OPEN_PAGE,false)
        end
    end)

end

return GroupFS