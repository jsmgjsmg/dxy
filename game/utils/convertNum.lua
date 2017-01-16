cn = cn or class("cn")
cn._arrTips = {}

--万
function cn:convert(num)
    local int,point = nil
    if num / 10000 >= 1 then
        int,point = math.modf(num/10000)
        return int.."万"
    else
        return num
    end
end

--数据插入
function cn:readPro(msg,type,data)
    local pro = msg:readUint()
    if type == 1 then
        data["Hp"] = pro
    elseif type == 2 then
        data["Mp"] = pro
    elseif type == 3 then
        data["Atk"] = pro
    elseif type == 4 then
        data["Def"] = pro
    elseif type == 5 then
        data["Crit"] = pro
    elseif type == 6 then
        data["CritPer"] = pro
    elseif type == 7 then
        data["Speed"] = pro
    end
end

--插入事件（仙门“事件”消息读取）
function cn:readThing(msg,type,data)
    if type == 1 or type == 2 then --加入、退出
        local name = msg:readString()
        local time = os.date("%Y/%m/%d",msg:readUint())
        table.insert(data,name)
        table.insert(data,time)
    elseif type == 3 then --升级
        local lv = msg:readUbyte()
        local time = os.date("%Y/%m/%d",msg:readUint())
        table.insert(data,lv)
        table.insert(data,time)
    elseif type == 4 then --任命
        local name = msg:readString()
        local type = msg:readUbyte()
        local root = zzd.GroupData[type]
        local time = os.date("%Y/%m/%d",msg:readUint())
        table.insert(data,name)
        table.insert(data,root)
        table.insert(data,time)
    end
end

--四舍五入(值，保留位数)
function cn:round(num,point)
    if point > 0 then
        local temp = num * (10^point)
        local int,short = math.modf(temp)
        if short >= 0.5 then
            int = int + 1
        end
        int = int / (10^point)
        return int
    elseif point == 0 then
        local int,short = math.modf(num)
        if short >= 0.5 then
            int = int + 1
        end
        return int
    else
        return 0
    end
end

--判断表是否为空
--function cn:isNilList(list)
--    local num = 0
--    table.foreach(list,function(key,value)
--        if key then
--            num = num + 1
--            return false
--        end
--    end)
--    return true
--end

--服务器时间转换
function cn:DiffTimer(server)
--_G.ServerTimer
    local client = os.time()
    local value = client - server
    _G.DiffTimer = value
end

--时间转换
function cn:cgTime(time)
    local curTime = os.time()
    local result = curTime - time
    local min = result / 60
    min = math.floor(min)
    if min >= 60 then
        local hour = min / 60
        hour = math.floor(hour)
        if hour >= 24 then
            local day = hour / 24
            day = math.floor(day)
            return day.."天前"
        end
        return hour.."小时前"
    else
        return min.."分钟前"
    end
end

--日时间(时:分)
function cn:TimeForDay(timer)
    local cur = timer / 3600
    local int,float = math.modf(cur)
    float = 60 * float
    
    return int..":"..float
end

--天时分秒
function cn:DHMS(timer)
    local day,hour,min,sec = 0
    day = math.modf(timer/86400)
    hour = math.modf(timer%86400/3600)
    min = math.modf(timer%86400%3600/60)
    sec = math.modf(timer%86400%3600%60)

    local str = ""
    if day <= 1 then
        day = 0 
    end    
    if hour <= 1 then
        hour = 0
    end
    if min <= 1 then
        min = 0
    end
    if sec <= 0 then
        sec = 0
    end
    
    return string.format("%02d",day).."天"..string.format("%02d",hour).."小时"..string.format("%02d",min).."分"..string.format("%02d",sec).."秒"
end

--当前 年.月.日
function cn:toMD(times)
    local h = os.date("%X",times)
    return h
end

--当前 年.月.日
function cn:curYMD()
    local curTimer = os.time()
    local y = os.date("%Y",curTimer)
    local m = os.date("%m",curTimer)
    local d = os.date("%d",curTimer)
    return y,m,d
end

--事件转换（仙门“事件”数据拼接）
function cn:cgThing(data)
    local _data = data
    local type = _data["type"]
    local str = GroupConfig:getStr(type)
    local len = #_data
    local last = str
    local num = 0
    for i=1,len-1 do
        local symbol = "{"..i.."}"
        last,num = string.gsub(last,symbol,_data[i])
--        zzd.GoodsData[]
    end
    return _data[len].." "..last
end

--二月
function cn:February(year)
    local bool = true
    if year % 4 == 0 then
        if year % 100 == 0 then
            if year % 400 == 0 then
                bool = true
            else
                bool = false
            end
        else
            bool = true
        end
    else
        bool = false
    end
    
    if bool then
        return 29
    else
        return 28
    end
end

--仙域探索物品飄字
function cn:ShowSearchGoods(goods)
    local str = ""
    if goods.type == 6 then
        local Goods = GoodsConfigProvider:findGoodsById(goods.id)
        str = "探索到："..Goods.Name.." X"..goods.count
    else
        str = "探索到："..zzd.TaskData.arrStrType[goods.type].." X"..goods.count
    end
    cn:TipsSchedule(str)
end

--仙域领取物品飄字
function cn:ShowGetSearchGoods(goods)
    if not zzm.ImmortalFieldModel.isShow then
    	return
    end
    local str = ""
    if goods.type == 6 then
        local Goods = GoodsConfigProvider:findGoodsById(goods.id)
        str = "获得："..Goods.Name.." X"..goods.count
    else
        str = "获得："..zzd.TaskData.arrStrType[goods.type].." X"..goods.count
    end
    cn:TipsSchedule(str)
end


--显示获取物品
function cn:GetRewardsInfo(reward)
    local str = ""
    if reward.type == 6 or reward.type == 10 or reward.type == 22 or reward.type == 23 or reward.type == 24   then
        local goods = GoodsConfigProvider:findGoodsById(reward.value)
        str = goods.Name.." X"..reward.num
    else
        str = zzd.TaskData.arrStrType[reward.type].." X"..reward.value
    end
    return str
end

--显示获取物品（飘字）整表传入
function cn:showRewardsGet(reward)
    local rewards = dxyConfig_toList(reward)
    for key, var in pairs(rewards) do
        if var.Type == 6 or var.Type == 10 then
            local str = ""
            local goods = GoodsConfigProvider:findGoodsById(var.Id)
            str = goods.Name.." ×"..var.Num
            cn:TipsSchedule(str)
        else
            local str = ""
            str = zzd.TaskData.arrStrType[var.Type].." ×"..var.Num
            cn:TipsSchedule(str)
        end
    end
end

--提示延迟
function cn:TipsSchedule(tips)
    table.insert(self._arrTips,tips)
    local stopTimer = 3
    if not self._myTimer then
        self._myTimer = self._myTimer or require("game.utils.MyTimer").new()
        local function tick()
            stopTimer = stopTimer - 0.1
            if stopTimer <= 0 then
                self._myTimer:stop()
                self._myTimer = nil
                self._arrTips = {}
                return 
            end
            if self._arrTips[1] then
                dxyFloatMsg:show(self._arrTips[1])
                table.remove(self._arrTips,1)
            else
                self._myTimer:stop()
                self._myTimer = nil
            end
        end
        self._myTimer:start(0.25, tick)
    end
end

--removeNet
function cn:removeAllNetController()
    for key, var in pairs(zzc) do
        if key ~= "LoginController" then
            if zzc[key].unregisterListenner then
                zzc[key]:unregisterListenner()
        	end
    	end
    end
end

---设置SV大小(target,type,num,space)
function cn:setSVSize(target,type,num,space)
    local conSize = target:getContentSize()
    local real = num * space
    local last = 0
    if type == "height" then
        last = conSize.height > real and conSize.height or real
        target:setInnerContainerSize(cc.size(conSize.width,last))
    elseif type == "width" then
        last = conSize.width > real and conSize.width or real
        target:setInnerContainerSize(cc.size(last,conSize.height))
    end
    return last
end

---拆分字符串(神他妈只限英文字符/数字)
function cn:SeparateOfStr(str,list)
    local Str = str
    local len = string.len(Str)
    local prolen = #list
    local arr = {}
    local curPos = 1
    for i=1,prolen do
        local idx = string.find(Str,list[i])
        arr[i] = string.sub(Str,curPos,idx)
        curPos = idx + 1
    end
    if curPos <= len then
        table.insert(arr,string.sub(Str,curPos))
    end
    return arr
end

--检测字符
function cn:CheckSpecialChar(str,list)
    for i=1,#dxyConfig_toList(list) do
        local is = string.find(str,list[i])
        if is then
            return true
        end
    end
    return false
end