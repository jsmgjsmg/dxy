MainGroup = MainGroup or class("MainGroup",function()
    return cc.Node:create()
end)

function MainGroup:create()
    local node = MainGroup:new()
    node:init()
    return node
end

function MainGroup:init()
    self._csb = cc.CSLoader:createNode("dxyCocosStudio/csd/ui/group/MainGroup.csb")
    self._csb:setPosition(0,0)
    self:addChild(self._csb)

    dxyExtendEvent(self)
end

function MainGroup:initEvent()
    dxyDispatcher_addEventListener("MainGroup_changeLayer",self,self.changeLayer)
end

function MainGroup:removeEvent()
    dxyDispatcher_removeEventListener("MainGroup_changeLayer",self,self.changeLayer)
end

function MainGroup:changeLayer()
    if _G.GroupData.State == 1 then
        --成员
        zzc.GroupController:enterGroupFunc(1572,60)
    elseif _G.GroupData.State == 0 then
        --游民
        zzc.GroupController:showGroupListLayer()
    end 
end

function MainGroup:whenClose()
    zzc.GroupController:clean()
--    zzm.GroupModel:cleanMyMemberList()
end
