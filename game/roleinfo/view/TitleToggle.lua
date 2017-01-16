
TitleToggle = TitleToggle or class("TitleToggle",function()
    local path = "dxyCocosStudio/png/roleinfo/newroleinfo/icon_1/in_frame.png"
    return ccui.Button:create(path,path,path)
end)

function TitleToggle:create()
    local node = TitleToggle:new()
    return node
end

function TitleToggle:ctor()
    self.equipFrame = nil
    self.pic_euqip = nil
    self:initUI()
    self:initEvent()
end

function TitleToggle:initUI()
    local _csb = cc.CSLoader:createNode("dxyCocosStudio/csd/ui/roleinfo/TitleToggle.csb")
    self:addChild(_csb)

    local x = self:getContentSize().width / 2
    local y = self:getContentSize().height / 2 

    _csb:setPosition(cc.p(x,y))

    self.icon = _csb:getChildByName("Icon")

end

function TitleToggle:setParent(parent)
    self._parent = parent
--    if self._parent then
--        self._parentX = self._parent:getPositionX()
--        self._width = self._parent:getContentSize().width
--    end
end

function TitleToggle:getItemSize()
    local size = self.icon:getContentSize()
    return size
end

function TitleToggle:initEvent()
    self:addTouchEventListener(function(target,type)
        if(type==2)then
            self._parent:scrollToPage(self.index - 1)
            --dxyDispatcher_dispatchEvent(dxyEventType.RoleInfo_OpenTypeView,self.index)
        end
    end)
end

function TitleToggle:update(data)
    local path = "dxyCocosStudio/png/roleinfo/titleIcon/"
    self.index = data
    self.icon:setTexture(path.."icon_"..self.index..".png")
    --self:adjustScrollView()
    --self.icon:setTexture(path.."icon_"..self.index..".png")
end

--function TitleToggle:getDistance()
--    return self.distance
--end

--function TitleToggle:adjustScrollView()
--    if self._parent then
--        local x = self._parent:getInnerContainer():getPositionX()
--        self.distance = self:getPositionX() + x - self._parent:getPositionX()
--        --print(self.index .. "distance----->" .. self.distance)
--        local p = (self._width/2 - math.abs(self.distance/2))/(self._width/2)
--        if p < 0.6 then
--        	p = 0.6
--        end
--        self:setScale(p)
--    end
--    
--end