LayOut = LayOut or class("LayOut",function()
    return ccui.Layout:create()
end)
local ITEM = 30
local TOP = 30

function LayOut:ctor()
    self._topNote = {}
    self._conNote = {}
    self.allHeight = 0
    self.topHeight = TOP
end

function LayOut:create(data)
    local layout = LayOut:new()
    layout:initLayout(data)
    return layout
end

function LayOut:initLayout(data) -- data[1] = size, data[2] = i
    self._sv = ccui.ScrollView:create()
    self._sv:setScrollBarEnabled(false)
    self._sv:setContentSize(cc.size(data[1].width,data[1].height))
    self._sv:setAnchorPoint(0,0)
    self._sv:setPosition(0,0)
    self._sv:setBounceEnabled(true)
    
    local node = cc.Node:create()
    node:addChild(self._sv)
    self:addChild(node)
    
    self._note = VipNoteConfig:getVipNote(data[2])
    
---isUpperExplain  top
    local isUpper = self:isUpperExplain()
    if isUpper and isUpper ~= 0 then
        for i=1,isUpper do
            self._topNote[i] = require("game.vip.view.UpperExplain"):create(self._note.upperExplain[i])
            self._sv:addChild(self._topNote[i])
            self.topHeight = self.topHeight + ITEM
        end
        self.topHeight = self.topHeight + 20
    end
    
---isUnderExplain  middle
    local isUnder = self:isUnderExplain()
    if isUnder and isUnder ~= 0 then
        for j=1,isUnder do
            self._conNote[j] = require("game.vip.view.UnderExplain"):create(self._note.underExplain[j],j)
            self._sv:addChild(self._conNote[j])
        end
    end
    
    local conSize = self._sv:getContentSize()
    local real = ITEM * isUnder + self.topHeight
    local last = conSize.height > real and conSize.height or real
    self._sv:setInnerContainerSize(cc.size(conSize.width,last))
    
    for i=1,isUpper do
        self._topNote[i]:setPosition(0,last-(i-1)*ITEM-TOP)
    end
    for j=1,isUnder do
        self._conNote[j]:setPosition(0,last-self.topHeight-(j-1)*ITEM)
    end
end

function LayOut:isUpperExplain()
    if #self._note.upperExplain and #self._note.upperExplain ~= 0 then
        return #self._note.upperExplain
    else
        return 0
    end
end

function LayOut:isUnderExplain()
    if #self._note.underExplain and #self._note.underExplain ~= 0 then
        return #self._note.underExplain
    else
        return 0
    end
end

function LayOut:jumpToTop()
    self._sv:jumpToTop()
end