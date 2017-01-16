local ImmortalFieldModel = ImmortalFieldModel or class("ImmortalFieldModel")


function ImmortalFieldModel:ctor()
	self.groupData = {}
	self.rankData = {}
	self.newsData = {}
--	self.backRes = {}
	self.goodsData = {}
	self.searchData = {}
	self.sceneData = {}
	self.manorResData = {}
	self.occupyData = {}
	self.isBox = 0
	self.isShow = false
	
	
	self.fightRes = {}
	self.fightGoods = {}
end

function ImmortalFieldModel:showTips()
    if SceneManager.m_curSceneName ~= "ImmortalMainScene" then
		return
	end
	
    for index=1, #self.fightRes do
        cn:ShowSearchGoods(self.fightRes[index])
	end
	
    self.fightRes = {}
	
    for index=1, #self.fightGoods do
        cn:ShowSearchGoods(self.fightGoods[index])
	end
	
    self.fightGoods = {}
end

function ImmortalFieldModel:addGroupData(data)
	self.groupData = data
end

function ImmortalFieldModel:addRankData(data)
	self.rankData = data
end

function ImmortalFieldModel:addNewsData(data)
	self.newsData = data
--    table.sort(self.newsData,function(t1,t2) return t1.timestamp > t2.timestamp end)
end

--function ImmortalFieldModel:addGoodsData(data)
--	self.goodsData = data
--end

function ImmortalFieldModel:addSearchData(data)
	self.searchData = data
end

function ImmortalFieldModel:addSceneData(data)
	self.sceneData = data
end

function ImmortalFieldModel:addManorResData(data)
	self.manorResData = data
end

--function ImmortalFieldModel:insertRes(data)
----	self.backRes = data
--	table.insert(self.backRes,data)
--end

function ImmortalFieldModel:insertGoods(data)
--	self.goodsData = nil
	self.goodsData = data
end

function ImmortalFieldModel:addGoods(data)
    if not self.goodsData[1] then
        table.insert(self.goodsData,data)
        dxyDispatcher_dispatchEvent("GoodsGetLayer_addItem",data)
        return
    end
    if data.type == 6 then
        local idZone = math.modf(data.id/1000)
        if idZone == 202 then--神将碎片
            local isHave = false
            for k,v in ipairs(self.goodsData) do
                if v.type == data.type then
                    if v.id == data.id then
                    	isHave = true
                    end
                    
                end
            end
            if isHave then
                for key, var in ipairs(self.goodsData) do
                    if var.id == data.id then
                        var.count = var.count + data.count
                        dxyDispatcher_dispatchEvent("GoodsGetLayer_addData",data)
                        return
                    end
                end
            else
                table.insert(self.goodsData,data)
                dxyDispatcher_dispatchEvent("GoodsGetLayer_addItem",data)
                return
            end
        else--物品
           table.insert(self.goodsData,data)
            dxyDispatcher_dispatchEvent("GoodsGetLayer_addItem",data)
            return
        end
    else--资源
        local isHave = false
        for k,v in ipairs(self.goodsData) do
            if v.type == data.type then
                isHave = true
            end
        end
        
        if isHave then
            for key, var in ipairs(self.goodsData) do
                if var.type == data.type then
                    var.count = var.count + data.count
                    dxyDispatcher_dispatchEvent("GoodsGetLayer_addData",data)
                    return
                end
            end
        else
            table.insert(self.goodsData,data)
            dxyDispatcher_dispatchEvent("GoodsGetLayer_addItem",data)
            return
        end
    end
	
end

function ImmortalFieldModel:addOneNews(news)
	table.remove(self.newsData,#self.newsData)
	table.insert(self.newsData,1,news)
end



return ImmortalFieldModel


