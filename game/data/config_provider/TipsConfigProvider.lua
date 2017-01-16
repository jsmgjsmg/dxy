--数据提供器

TipsConfigProvider = {
    }

function TipsConfigProvider:getTipsList()
    return luacf.Tips.TipsConfig.Tips
end
