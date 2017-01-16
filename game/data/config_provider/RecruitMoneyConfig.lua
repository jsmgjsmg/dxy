--招财进宝配置表
RecruitMoneyConfig = {
}

--获取初始金币
function RecruitMoneyConfig:getBaseGold()
	local item = luacf.RecruitMoney.RecruitMoneyConfig.InitialGold.InitialGold
	return item
end

--根据等级获取金币的倍率
function RecruitMoneyConfig:getScaleByLv(lv)
    local list = luacf.RecruitMoney.RecruitMoneyConfig.Scale.Scale 
    for index=1, #list do
    	if list[index].Lv >= lv then
    		return list[index].Scale
    	end
    end
    return nil
end

--获取第几次需要的元宝
function RecruitMoneyConfig:getNeedRmb(count)
    local list = luacf.RecruitMoney.RecruitMoneyConfig.time.time 
    for key, var in pairs(list) do
        if var.Count == count then
            return var.Sycee
        end
    end
    return nil
end

--根据宝箱ID获取开启的条件
function RecruitMoneyConfig:getBoxOpenById(id)
    local list = luacf.RecruitMoney.RecruitMoneyConfig.Box.Box
    for key, var in pairs(list) do
    	if var.Id == id then
    		return var.condition
    	end
    end
    return nil
end