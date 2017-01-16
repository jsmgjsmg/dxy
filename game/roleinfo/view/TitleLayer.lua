require("game.roleinfo.view.TitleItem")
TitleLayer = TitleLayer or class("TitleLayer",function()
    return cc.Layer:create()
end)

function TitleLayer:create()
    local layer = TitleLayer:new()
    return layer
end

function TitleLayer:ctor()
    self.scrollView = nil
    self.btn_close = ccui.Button

    self.itemList = {}

    self:initUI()
    self:initEvent()
end

function TitleLayer:initUI()
    local titleLayer = cc.CSLoader:createNode("dxyCocosStudio/csd/ui/roleinfo/titleLayer.csb")
    self:addChild(titleLayer)

    self.scrollView = titleLayer:getChildByName("ScrollView")
    self.scrollView:setScrollBarEnabled(false)

    self.btn_close = titleLayer:getChildByName("closeBtn")

    self:addScrollView()
end

function TitleLayer:addScrollView()
    local item = nil
    local itemSize = nil
    local x,y = 0,0
    local index = 1
    for i=10,1,-1 do
        item = TitleItem:create()
        item:setAnchorPoint(cc.p(0,0))
        item:update()
        itemSize = item:getFrameSize()
        x = 0
        y = (itemSize.height) * (i - 1)
        item:setPosition(cc.p(x,y))
        self.scrollView:addChild(item)
        self.itemList[index] = item
        self.itemList[index].ckb_use:addTouchEventListener(function(target,type)
            if type == 2 then
                for var=1, 10 do
                    if index ~= var then
                        self.itemList[var]:setBtnState(false)
                    else
                        self.itemList[var]:setBtnState(true)
                    end
                end
            end
        end)
        index = index + 1
    end
    self.scrollView:setInnerContainerSize(cc.size(self.scrollView:getInnerContainerSize().width,(itemSize.height)*10))
end

function TitleLayer:initEvent()
    self.btn_close:addTouchEventListener(function(target,type)
        if type == ccui.TouchEventType.ended then
            UIManager:closeUI("titleLayer")
        end
    end)

    -- 拦截
    dxySwallowTouches(self)
end

function TitleLayer:WhenClose()
    self:removeFromParent()
end