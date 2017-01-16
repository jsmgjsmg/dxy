NewsNode = NewsNode or class("NewsNode",function()
    return cc.Node:create()
end)

function NewsNode.create()
    local node = NewsNode.new()
    return node
end

function NewsNode:ctor()
    self._csbNode = nil
    
    self.isOpen = false
    
    self.ItemList = {}
    self:initUI()
    dxyExtendEvent(self)
end

function NewsNode:initUI()
	self._csbNode = cc.CSLoader:createNode("dxyCocosStudio/csd/ui/immortalfield/NewsNode.csb")
	self:addChild(self._csbNode)
	
	self.newsNode = self._csbNode:getChildByName("NewsNode")
    self.bigPanelNode = self.newsNode:getChildByName("BigPanelNode")
    self.bigPanel = self.bigPanelNode:getChildByName("ScrollView")
    self.bigPanel:setScrollBarEnabled(false)
    
    self.smallPanelNode = self.newsNode:getChildByName("SmallPanelNode")
    self.smallPanel = self.smallPanelNode:getChildByName("ScrollView")
    
    self.btn_add = self.newsNode:getChildByName("btnAdd")
    self.btn_reduce = self.newsNode:getChildByName("btnReduce")
    
    self._scrollHeight_Big = self.bigPanel:getContentSize().height
    self._scrollWidth_Big = self.bigPanel:getContentSize().width
    
    self._scrollHeight_Small = self.smallPanel:getContentSize().height
    self._scrollWidth_Small = self.smallPanel:getContentSize().width
    
    self:updateVisible(self.isOpen)
    
    local newsData = zzm.ImmortalFieldModel.newsData
    if newsData then
    	self:updateNewsItem(newsData)
    end
    
end

function NewsNode:updateNewsItem(newsData)
    require("game.tilemap.immortalfield.view.NewsItem")
    self.bigPanel:removeAllChildren()
	for i=1, #newsData do
		local newsItem = NewsItem:create()
		newsItem:update(newsData[i])
        self.bigPanel:addChild(newsItem)
        newsItem:setPosition(0,self._scrollHeight_Big)
        self.ItemList[i] = newsItem
        self._scrollHeight_Big = self._scrollHeight_Big + 50
        self.bigPanel:setInnerContainerSize(cc.size(self._scrollWidth_Big,self._scrollHeight_Big))
	end
	
    self.smallPanel:removeAllChildren()
    local oneNewsItem = NewsItem:create()
    oneNewsItem:update(newsData[1])
    self.smallPanel:addChild(oneNewsItem)
    oneNewsItem:setPosition(0,3)
--    self._scrollHeight_Small = self._scrollHeight_Small + 50
--    self.smallPanel:setInnerContainerSize(cc.size(self._scrollWidth_Small,self._scrollHeight_Small))
end


function NewsNode:removeEvent()
    dxyDispatcher_removeEventListener("NewsNode_updateItem",self,self.updateNewsItem)
end


function NewsNode:initEvent()
    
    dxyDispatcher_addEventListener("NewsNode_updateItem",self,self.updateNewsItem)
    
    if self.btn_add then
		self.btn_add:addTouchEventListener(function(target,type)
		     if (type == 2) then
--                self.panel:jumpToPercentVertical(-50/self.panel:getContentSize().height)
                self:updateVisible(true)
		     end
		end)
	end
	
    if self.btn_reduce then
        self.btn_reduce:addTouchEventListener(function(target,type)
            if (type == 2) then
--                self.panel:jumpToPercentVertical(50/self.panel:getContentSize().height)
                self:updateVisible(false)
            end
        end)
    end
end


function NewsNode:updateVisible(state)
	if state then
        self.bigPanelNode:setVisible(true)
        self.smallPanelNode:setVisible(false)
        self.btn_add:setVisible(false)
        self.btn_reduce:setVisible(true)
	else
        self.bigPanelNode:setVisible(false)
        self.smallPanelNode:setVisible(true)
        self.btn_add:setVisible(true)
        self.btn_reduce:setVisible(false)
	end
end



