GroupLayer = GroupLayer or class("GroupLayer",function()
    return cc.Layer:create()
end)
local PATH = "dxyCocosStudio/png/group/"

function GroupLayer:ctor()
    self.visibleSize = cc.Director:getInstance():getVisibleSize()
    self.origin = cc.Director:getInstance():getVisibleOrigin()
--权限(1.门主,2.长老,3.护法,4.成员)    
--    _G.GroupData.Root = 1
--状态(1.成员,2.游客)
--    _G.GroupData.State = 1
end

function GroupLayer:create()
    local layer = GroupLayer:new()
    layer:init()
    return layer
end

function GroupLayer:init()
    self._csb = cc.CSLoader:createNode("dxyCocosStudio/csd/ui/group/GroupLayer.csb")
    self:addChild(self._csb)
    self._csb:setPosition(self.origin.x + self.visibleSize.width / 2, self.origin.y + self.visibleSize.height / 2)
    
    local swallow = self._csb:getChildByName("swallow")
    swallow:setContentSize(self.visibleSize.width,self.visibleSize.height)
        
    -- 拦截
    dxySwallowTouches(self)
    
    local parent = zzc.GroupController:getLayer()
    
--top
    require "src.game.utils.TopTitleNode"
    local node = TopTitleNode:create(parent,PATH.."txt5.png")
    self:addChild(node,2)

    require "src.game.group.view.GroupList"
    local list = GroupList:create()
    self:addChild(list,1)
end

--function GroupLayer:whenClose()
--    zzm.GroupModel:cleanMyMemberList()
--end

