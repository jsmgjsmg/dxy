TitlePageItem = TitlePageItem or class("TitlePageItem",function()
    return cc.Layer:create()
end)

function TitlePageItem:create()
    local layer = TitlePageItem:new()
    return layer
end

function TitlePageItem:ctor()
    self._csb = nil

    self:initUI()
    --self:initEvent()
    dxyExtendEvent(self)
end

function TitlePageItem:initUI()
    self._csb = cc.CSLoader:createNode("dxyCocosStudio/csd/ui/roleinfo/TitlePageItem.csb")
    self:addChild(self._csb)

    self.pageView = self._csb:getChildByName("PageView")

    self.panelList = {}

    local panel = nil
    for index = 1, 7 do
        panel = self.pageView:getChildByName("Panel_"..index)
        self.panelList[index] = panel
    end

    local viewSize = self.pageView:getContentSize()

    local item = nil
    require("game.roleinfo.view.TitleToggle")
    self.itemList = {}
    for index=1, 7 do
        item = TitleToggle:create()
        local x = viewSize.width / 2
        local y = viewSize.height / 2
        item:setPosition(cc.p(x,y))
        item:setParent(self.pageView)
        item:update(index)
        self.itemList[index] = item

        self.panelList[index]:addChild(item)

        if index == 1 then
            item:setScale(1.0)
        else
            item:setScale(0.6)
        end
    end
end

function TitlePageItem:initEvent()
    self.pageView:addEventListener(function(target,type)
        if type == ccui.PageViewEventType.turning then
            local page = self.pageView:getCurPageIndex()
            dxyDispatcher_dispatchEvent(dxyEventType.RoleInfo_OpenTypeView,page + 1)

            for index=1, 7 do
                if index == page + 1 then
                    self.itemList[index]:runAction(cc.EaseSineOut:create(cc.ScaleTo:create(0.3,1)))
                else
                    self.itemList[index]:runAction(cc.EaseSineOut:create(cc.ScaleTo:create(0.3,0.6)))
                end
            end
        end
    end)
end

function TitlePageItem:removeEvent()
	
end