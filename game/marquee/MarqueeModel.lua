local MarqueeModel = MarqueeModel or class("MarqueeModel")

function MarqueeModel:ctor()
	self.newsTable = {}
--	self.newsNum = nil
end


function MarqueeModel:dealTable(type,playNum,priority,news,time)
    
    local data = {}
    data.Type = type
    data.PlayNumber = playNum
    data.Priority = priority
    data.News = news
    data.Time = time
    
    local newsNum = table.getn(self.newsTable)+1

    local newsNumMax = MoveNewsConfig:getNewsNumberMax()
    if newsNum <= newsNumMax then
        table.insert(self.newsTable,newsNum,data)
--        self.newsTable[newsNum].Type = type
--        self.newsTable[newsNum].News = news
--        self.newsTable[newsNum].Time = time
--        self.newsTable[newsNum].Priority = newsData.Priority
        local function rangeSort(t1,t2)
            if t1.Priority == t2.Priority then
                return t1.Time < t2.Time
            else
                return t1.Priority < t2.Priority
            end
        end
        table.sort(self.newsTable,rangeSort)

    else
        local lastNews = self.newsTable[newsNumMax]
        local sameNum = 0
        for j = 1, #self.newsTable do
        	if lastNews.Priority ==self.newsTable[j].Priority then
        		sameNum = sameNum+1
        	end
        end
        
        --删除旧消息
        if sameNum<=1 then
            table.remove(self.newsTable,newsNumMax)
        else
            table.remove(self.newsTable,newsNumMax-sameNum+1)
        end
        
        --重新排序
        table.insert(self.newsTable,data)
        local function rangeSort(t1,t2)
            if t1.Priority == t2.Priority then
                return t1.Time < t2.Time
            else
                return t1.Priority < t2.Priority
            end
        end
        table.sort(self.newsTable,rangeSort)
    end


end
return MarqueeModel