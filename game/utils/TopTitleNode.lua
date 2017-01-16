TopTitleNode = TopTitleNode or class("TopTitleNode",function()
    return cc.Node:create()
end)

function TopTitleNode:ctor()
    self.visibleSize = cc.Director:getInstance():getVisibleSize()
    self.origin = cc.Director:getInstance():getVisibleOrigin()
end

function TopTitleNode:create(parent,path,bool)
    local node = TopTitleNode:new()
    node:initTitle(parent,path,bool)
    return node
end

function TopTitleNode:initTitle(parent,path,bool)
    self._csb = cc.CSLoader:createNode("dxyCocosStudio/csd/ui/TopTitleNode.csb")
    self:addChild(self._csb)
    self._csb:setPosition(self.origin.x + self.visibleSize.width / 2, self.origin.y + self.visibleSize.height / 2)
    
    dxyExtendEvent(self)
    
    local Node = self._csb:getChildByName("Node")
    Node:setPosition(-(self.visibleSize.width / 2),self.visibleSize.height/2)
    
    local swallow = self._csb:getChildByName("swallow")
    swallow:setSwallowTouches(true)
    swallow:setPosition(0,self.visibleSize.height/2)
  
--返回按钮
    local _btnBack = Node:getChildByName("btn_back")
    _btnBack:addTouchEventListener(function(target,type)
        if type == 2 then
            SoundsFunc_playSounds(SoundsType.CLOSE_PAGE,false)
            self:removeFromParent()
            if parent.whenClose then
                parent:whenClose()
            end
            parent:removeFromParent()
        end
    end)

--标题    
    self._title = Node:getChildByName("title")
--    self._title:setTexture(path)
    self._title:setSpriteFrame(cc.SpriteFrameCache:getInstance():getSpriteFrame(path))
    
--titleData
    local _ndData = Node:getChildByName("nd_data")
    _ndData:setPositionX(self.visibleSize.width - 10)
    local posx,posy = _ndData:getPosition()
    require "src.game.utils.TopDataNode"
    local data = TopDataNode:create(bool)
    _ndData:addChild(data)
end

function TopTitleNode:initEvent()
    dxyDispatcher_addEventListener("TopTitleNode_changeTitle",self,self.changeTitle)
end

function TopTitleNode:removeEvent()
    dxyDispatcher_removeEventListener("TopTitleNode_changeTitle",self,self.changeTitle)
end

function TopTitleNode:changeTitle(path)
--    self._title:setTexture(path)
    self._title:setSpriteFrame(cc.SpriteFrameCache:getInstance():getSpriteFrame(path))
end