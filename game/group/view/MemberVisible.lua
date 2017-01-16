local MemberVisible = class("MemberVisible",function()
    return cc.Node:create()
end)
local PATH = "dxyCocosStudio/png/group/"

function MemberVisible:ctor()
    self.visibleSize = cc.Director:getInstance():getVisibleSize()
    self.origin = cc.Director:getInstance():getVisibleOrigin()
end

function MemberVisible:create(bool)
    local node = MemberVisible:new()
    node:init(bool)
    return node
end

function MemberVisible:init(bool)
    self._csb = cc.CSLoader:createNode("dxyCocosStudio/csd/ui/TopTitleNode.csb")
    self:addChild(self._csb,2)
    self._csb:setPosition(self.origin.x + self.visibleSize.width / 2, self.origin.y + self.visibleSize.height / 2)
    
    -- 拦截
    dxySwallowTouches(self)
    
    local Node = self._csb:getChildByName("Node")
    Node:setPosition(-(self.visibleSize.width / 2),self.visibleSize.height/2)
    local _ndData = Node:getChildByName("nd_data")
    _ndData:setPositionX(self.visibleSize.width)
    local posx,posy = _ndData:getPosition()
    
    local swallow = self._csb:getChildByName("swallow")
    swallow:setSwallowTouches(true)
    swallow:setPosition(0,self.visibleSize.height/2)
    
    --标题    
    self._title = Node:getChildByName("title")
--    self._title:setTexture(PATH.."txt5.png")
    self._title:setSpriteFrame(cc.SpriteFrameCache:getInstance():getSpriteFrame(PATH.."txt5.png"))
    
--titleData
    require "src.game.utils.TopDataNode"
    local data = TopDataNode:create()
    _ndData:addChild(data)

--GroupLayer
    self._csbLayer = cc.CSLoader:createNode("dxyCocosStudio/csd/ui/group/GroupLayer.csb")
    self:addChild(self._csbLayer,1)
    self._csbLayer:setPosition(self.origin.x + self.visibleSize.width / 2, self.origin.y + self.visibleSize.height / 2)

    local swallowLayer = self._csbLayer:getChildByName("swallow")
    swallowLayer:setContentSize(self.visibleSize.width,self.visibleSize.height)

    --返回按钮
    local _btnBack = Node:getChildByName("btn_back")
    _btnBack:addTouchEventListener(function(target,type)
        if type == 2 then
            SoundsFunc_playSounds(SoundsType.CLOSE_PAGE,false)
--            zzm.GroupModel:cleanMyMemberList()
            self:removeFromParent()
        end
    end)

    if bool then
        require "src.game.group.view.FuncChoose"
        local list = FuncChoose:create()
        self:addChild(list,3)
    else
        require "src.game.group.view.GroupList"
        local list = GroupList:create()
        self:addChild(list,3)
    end
end

return MemberVisible