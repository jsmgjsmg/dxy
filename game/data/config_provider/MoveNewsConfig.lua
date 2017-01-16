--走马灯

MoveNewsConfig = {
    }

--播放时间
function MoveNewsConfig:getPlaySpeed()
    return luacf.MoveNews.MoveNewsConfig.BaseConfig.Base.Speed
end

--消息上限
function MoveNewsConfig:getNewsNumberMax()
	return luacf.MoveNews.MoveNewsConfig.BaseConfig.Base.NewsNumberMax
end

--返回走马灯data
function MoveNewsConfig:getNewsDataByType(type)
    for key, news in pairs(luacf.MoveNews.MoveNewsConfig.NewsConfig.News) do
		if news.Type == type then
			return news
		end
	end
	return false
end

function MoveNewsConfig:getNewsPlayNumByType(type)
    for key, news in pairs(luacf.MoveNews.MoveNewsConfig.NewsConfig.News) do
        if news.Type == type then
            return news.PlayNumber
        end
    end
    return false
end