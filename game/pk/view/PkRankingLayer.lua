PkRankingLayer = PkRankingLayer or class("PkRankingLayer",function()
	return cc.Layer:create()
end)

function PkRankingLayer:create()
    local layer = PkRankingLayer:new()
    return layer
end

function PkRankingLayer:ctor()
	self._csb = nil
	
	self.item_list = {}
	
	self:initUI()
	dxyExtendEvent(self)
end

function PkRankingLayer:initUI()
	self._csb = cc.CSLoader:createNode("dxyCocosStudio/csd/ui/pk/pkRankingLayer.csb")
	self:addChild(self._csb)
	
	self.btn_close = self._csb:getChildByName("closeBtn")
	
    local rankingBg = self._csb:getChildByName("rankingBg")
    self.scrollView = rankingBg:getChildByName("ScrollView")
    self.scrollView:setScrollBarEnabled(false)
    
	self:addScrollView()
	
	zzc.RankingController:getRankByPK()
	
end

function PkRankingLayer:addScrollView()
    require("game.pk.view.PkRankingItem")
    local item = nil
    local itemSize = nil
    local x,y = 0,0
    local index = 1
    
    for i=100,1,-1 do
        item = PkRankingItem:create()
        item:setAnchorPoint(cc.p(0,0))
        itemSize = item:getContentSize()
        x = 3
        y = itemSize.height * (i - 1)
        item:setPosition(cc.p(x,y))
        self.scrollView:addChild(item)
        self.item_list[index] = item
        index = index + 1
    end
    self.scrollView:setInnerContainerSize(cc.size(itemSize.width,itemSize.height * 100))
end

function PkRankingLayer:updateValue()
    local data = zzm.RankingModel._arrRankPK.List
    for index=1, #data do
    	self.item_list[index]:update(data[index])
    end
end

function PkRankingLayer:initEvent()
    
    dxyDispatcher_addEventListener(dxyEventType.Pk_Ranking_Upgrade,self,self.updateValue)

    self.btn_close:addTouchEventListener(function(target,type)
        if type == 2 then
            SoundsFunc_playSounds(SoundsType.CLOSE_PAGE,false)
        	self:removeFromParent()
        end
    end)

    -- 拦截
    dxySwallowTouches(self)
end

function PkRankingLayer:removeEvent()
    dxyDispatcher_removeEventListener(dxyEventType.Pk_Ranking_Upgrade,self,self.updateValue)
end