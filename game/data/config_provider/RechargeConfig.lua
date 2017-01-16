local RechargeConfig = RechargeConfig or class("RechargeConfig")

function RechargeConfig:ctor()
    self._arrRecharge = {}
    self._arrRecharge[1] = self:getMonthCard()
    local list = luacf.Recharge.RechargeConfig.RechargeGroup.Recharge
    for i=2,#list+1 do
        self._arrRecharge[i] = list[i-1]
    end
end

---222------------------------------------------------------------------------------------
--function RechargeConfig:ctor2()
--    self._arrRecharge = {}
--    self._arrRecharge = self:getSpecialCard()
--    local list = luacf.Recharge.RechargeConfig.RechargeGroup.Recharge
--    for i=1,#list do
--        table.insert(self._arrRecharge,list[i])
--    end
--end
------------------------------------------------------------------------------------------

--获取首冲奖励
function RechargeConfig:getFirstGoods(num)
    local list = luacf.FirstPay.FirstPayConfig.Goods.FirstPayGoods[num]
    local data = {}
    data["str"] = zzd.RechargeData[list["Type"]]..cn:convert(list["Number"])
    data["Icon"] = list["Icon"]
    if list["Goods"] then
        data["Goods"] = GoodsConfigProvider:findGoodsById(list.Goods.Id)
        data["Num"] = list.Goods.Number
    end
    
    return data
end

--获取Demand
function RechargeConfig:getDemand()
    return luacf.FirstPay.FirstPayConfig.Demand.FirstPayDemand.Rmb
end

--月卡
function RechargeConfig:getMonthCard()
    return luacf.Recharge.RechargeConfig.MonthCardGroup.MonthCard
end

---222------------------------------------------------------------------------------------
--特殊卡
--function RechargeConfig:getSpecialCard()
--    return dxyConfig_toList(luacf.Recharge.RechargeConfig.MonthCardGroup.MonthCard)
--end
------------------------------------------------------------------------------------------

--通过Id获取item
function RechargeConfig:getRechargeById(id)
    for key, var in pairs(self._arrRecharge) do
    	if var.Id == id then
    	    return var
    	end
    end
end

--通过Key获取item
function RechargeConfig:getRechargeByKey(key)
    return self._arrRecharge[key]
end

--获取item长度
function RechargeConfig:getRechargeLen()
    return #self._arrRecharge
end

--首冲奖励列表
function RechargeConfig:getFirstList()
    return luacf.FirstPay.FirstPayConfig.Goods.FirstPayGoods
end

return RechargeConfig