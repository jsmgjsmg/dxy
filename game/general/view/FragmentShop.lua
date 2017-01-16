FragmentShop = FragmentShop or class("FragmentShop",function()
    return cc.Node:create()
end)
local HEIGHT = 130
local WIDTH = 107
local ROW = 5

function FragmentShop:ctor()
    self.visibleSize = cc.Director:getInstance():getVisibleSize()
    self.origin = cc.Director:getInstance():getVisibleOrigin()
end

function FragmentShop:create()
    local node = FragmentShop:new()
    node:initShop()
    return node
end

function FragmentShop:initShop()
    self._csb = cc.CSLoader:createNode("res/dxyCocosStudio/csd/ui/general/FragmentShop.csb")
    self:addChild(self._csb)
    self._csb:setPosition(self.origin.x + self.visibleSize.width / 2, self.origin.y + self.visibleSize.height / 2)

--    local swallow = self._csb:getChildByName("swallow")
--    swallow:setSwallowTouches(true)
    dxySwallowTouches(self)

    local _btnBack = self._csb:getChildByName("bgTop"):getChildByName("btn_back")
    _btnBack:addTouchEventListener(function(target,type)
        if type == 2 then
            SoundsFunc_playSounds(SoundsType.CLOSE_PAGE,false)
            self:removeFromParent()
        end
    end)

    self._SV = self._csb:getChildByName("bgTop"):getChildByName("ScrollView")
    self._SV:setScrollBarEnabled(false)
    local width = self._SV:getContentSize().width
    local svHeight = ROW * HEIGHT
    self._SV:setInnerContainerSize(cc.size(width,svHeight))
    local posx = 0
    local posy = 0
    local count = 0
    for i=1,ROW do
        posy = (i-1) * HEIGHT + 50
        for j=1,6 do
            posx = (j-1) * WIDTH + 50
            count = count + 1
            require "src.game.general.view.ItemFragmentShop"
            local data = {[1]=self._SV,[2]=posx,[3]=svHeight-posy,[4]=2}
            local item = ItemFragmentShop:create(data)
            item:upDateShop(GodGeneralConfig:getFragmentShopPro(count))
            self._SV:addChild(item,1)
            item:setPosition(posx,svHeight - posy)
        end
    end
end