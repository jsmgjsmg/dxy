VipConfig = VipConfig or class("VipConfig")

---获取特权-------------------------------------------------------------------------------------------------------------
function VipConfig:getPrivilegeByLv(lv)
    local list = luacf.Vip.VipConfig.Privilege.VipPrivilege
    for i,vip in pairs(list) do
        if vip.Lv == lv then
            return vip
        end
    end
end

--根据类型，vip等级获取加成
function VipConfig:getAppreciationByLvAndType(lv,type)
    local data = VipConfig:getPrivilegeByLv(lv)
    if not data then
    	return 0
    end
    for key, var in pairs(dxyConfig_toList(data.appreciation)) do
    	if var.Type == type then
    		return var.Parameter1
    	end
    end
    return 0
end

---获取vip等级数----------------------------------------------------------------------------------------------------------
function VipConfig:getVipLen()
    return #luacf.Vip.VipConfig.Demand.VipDemand
end

---等级所需金钱------------------------------------------------------------------------------------------------------------
function VipConfig:getRmbByLv(lv)
    if lv > self:getVipLen() then
        return 0
    else
        local list = luacf.Vip.VipConfig.Demand.VipDemand
        for i,vip in pairs(list) do
            if vip.Lv == lv then
                return vip.Rmb
            end
        end
    end
end

----获取倍率
function VipConfig:getRate()
    return luacf.Vip.VipConfig.Demand.Rate.Rate
end

---获取权限开放等级
function VipConfig:getVipByPrivilege(type)
    local list = luacf.Vip.VipConfig.Privilege.VipPrivilege
    for i=1,#list do
        for key, var in pairs(dxyConfig_toList(list[i]["function"])) do
        	if var.Type == type then
        	    return list[i].Lv
        	end
        end
    end
end