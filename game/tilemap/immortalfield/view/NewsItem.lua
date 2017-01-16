NewsItem = NewsItem or class("NewsItem",function()
    return cc.Node:create()
end)

function NewsItem.create()
    local node = NewsItem.new()
    return node
end

function NewsItem:ctor()
    self._csbNode = nil
--    self.groupItem = {}
    self:initUI()
--    dxyExtendEvent(self)
end

function NewsItem:initUI()
	self._csbNode = cc.CSLoader:createNode("dxyCocosStudio/csd/ui/immortalfield/NewsItem.csb")
	self:addChild(self._csbNode)
	
    self.titleTxt = self._csbNode:getChildByName("titleName")
    self.newsTxt = self._csbNode:getChildByName("news") 
	
end

function NewsItem:update(data)
	if data then
		self.titleTxt:setString(data.event)
		self.newsTxt:setString(data.news)
	end
	
	if data == nil then
		return
	end
	
	if data.type == 1 then
		 self.titleTxt:setString("["..data[1].playerName.."] ["..data[1].groupName.."] ("..data.timeStamp..")")
		 self.newsTxt:setString("击杀了["..data[2].plsyerName.."] ["..data[2].groupName.."]")
    elseif data.type == 2 then
        self.titleTxt:setString("["..data[1].playerName.."] ["..data[1].groupName.."] ("..data.timeStamp..")")
        self.newsTxt:setString("从["..data[2].plsyerName.."]手中逃脱")
	elseif data.type == 3 then
        self.titleTxt:setString("["..data.playerName.."] ["..data.groupName.."] ("..data.timeStamp..")")
        self.newsTxt:setString("探索到了["..data.goodsName.."] x"..data.count)
	elseif data.type == 4 then
        self.titleTxt:setString("["..data.playerName.."] ["..data.groupName.."] ("..data.timeStamp..")")
        self.newsTxt:setString("击杀了["..data.plsyerName.."] ["..data.groupName.."]")
	end
end