ActivityConfig = ActivityConfig or class("ActivityConfig")

--function ActivityConfig:init()
--    self.AcLvConfig = {} --等级礼包==1
--    self.AcLoginConfig = {} --登录礼包==2
--    self.AcRechargeConfig = {} --累计充值==3
--    self.AcPKConfig = {} --竞技场挑战次数==4
--    self.AcWeekVipConfig = {} --VIP周礼包==5
--    self.AcVipGiftConfig = {} --VIP超值礼包==6
--    self.AcSalePriceConfig = {} --特价商城==7
--    self.AcMonthCardConfig = {} --月卡==8
--    self.AcSPMonthCard = {} --至尊月卡==9
--    self.AcServerConfig = {} --开服基金==10
--    self.AcWelfareConfig = {} --全民福利==11
--    self.AcExchangeGift = {} --兑换礼包 ==12
--    self.AcAllConsume = {} --累计消费==13
--    self.AcOnceRecharge = {} --单笔充值==14
--    self.AcOnceConsume = {}  --单笔消费==15
--    
----    LV = 1,
----    LOGIN = 2,
----    RECHARGE = 3,
----    PK = 4,
----    WEEKVIP = 5,
----    VIPGIFT = 6,
----    SALEPRICE = 7,
----    MONTHCARD = 8,
----    SPMONTHCARD = 9,
----    SERVER = 10,
----    WELFARE = 11,
--    
--    local taskConfig = luacf.Activity.ActivityConfig.TaskConfig.Task
--    for i=1,#taskConfig do
--        self:setConfigByType(taskConfig[i],taskConfig[i].Type)
--    end
--    
--    local dealConfig = luacf.Activity.ActivityConfig.DealConfig.Deal
--    for i=1,#dealConfig do
--        self:setConfigByType(dealConfig[i],dealConfig[i].Type)
--    end
--end
--
--function ActivityConfig:setConfigByType(var,type)
--    if type == ActivityType.LV then                 --1
--        table.insert(self.AcLvConfig,var)
--    elseif type == ActivityType.LOGIN then          --2
--        table.insert(self.AcLoginConfig,var)
--    elseif type == ActivityType.RECHARGE then       --3
--        table.insert(self.AcRechargeConfig,var)
--    elseif type == ActivityType.PK then             --4
--        table.insert(self.AcPKConfig,var)
--    elseif type == ActivityType.WEEKVIP then        --5
--        table.insert(self.AcWeekVipConfig,var)
--    elseif type == ActivityType.VIPGIFT then        --6
--        table.insert(self.AcVipGiftConfig,var)
--    elseif type == ActivityType.SALEPRICE then      --7
--        table.insert(self.AcSalePriceConfig,var)
--    elseif type == ActivityType.MONTHCARD then      --8
--        table.insert(self.AcMonthCardConfig,var)
--    elseif type == ActivityType.SPMONTHCARD then    --9
--        table.insert(self.AcSPMonthCard,var)
--    elseif type == ActivityType.SERVER then         --10
--        table.insert(self.AcServerConfig,var)
--    elseif type == ActivityType.WELFARE then        --11
--        table.insert(self.AcWelfareConfig,var)
--    elseif type == ActivityType.EXCHANGEGIFT then   --12
--        table.insert(self.AcExchangeGift,var)
--    elseif type == ActivityType.ALLCONSUME then   --13
--        table.insert(self.AcAllConsume,var)
--    elseif type == ActivityType.ONCERECHARGE then   --14
--        table.insert(self.AcOnceRecharge,var)
--    elseif type == ActivityType.ONCECONSUME then   --15
--        table.insert(self.AcOnceConsume,var)
--    end
--end
--
----获取等级礼包
--function ActivityConfig:getConfigByType(type,id)
--    if type == ActivityType.LV then
--        return self:getVar(self.AcLvConfig,id)
--    elseif type == ActivityType.LOGIN then
--        return self:getVar(self.AcLoginConfig,id)
--    elseif type == ActivityType.RECHARGE then
--        return self:getVar(self.AcRechargeConfig,id)
--    elseif type == ActivityType.PK then
--        return self:getVar(self.AcPKConfig,id)
--    elseif type == ActivityType.WEEKVIP then
--        return self:getVar(self.AcWeekVipConfig,id)
--    elseif type == ActivityType.VIPGIFT then
--        return self:getVar(self.AcVipGiftConfig,id)
--    elseif type == ActivityType.SALEPRICE then
--        return self:getVar(self.AcSalePriceConfig,id)
--    elseif type == ActivityType.MONTHCARD then
--        return self:getVar(self.AcMonthCardConfig,id)
--    elseif type == ActivityType.SPMONTHCARD then
--        return self:getVar(self.AcSPMonthCard,id)
--    elseif type == ActivityType.SERVER then
--        return self:getVar(self.AcServerConfig,id)
--    elseif type == ActivityType.WELFARE then
--        return self:getVar(self.AcWelfareConfig,id)
--    elseif type == ActivityType.EXCHANGEGIFT then
--        return self:getVar(self.AcExchangeGift,id)
--    elseif type == ActivityType.ALLCONSUME then   --13
--        return self:getVar(self.AcAllConsume,id)
--    elseif type == ActivityType.ONCERECHARGE then   --14
--        return self:getVar(self.AcOnceRecharge,id)
--    elseif type == ActivityType.ONCECONSUME then   --15
--        return self:getVar(self.AcOnceConsume,id)
--    end
--end
--
--function ActivityConfig:getVar(list,id)
--    for key, var in pairs(list) do
--    	if var.Id == id then
--    	   return var
--    	end
--    end
--end
--
----左边按钮
--function ActivityConfig:getFirstConfigByType(type)
--    if type == ActivityType.LV then
--        return self.AcLvConfig[1]
--    elseif type == ActivityType.LOGIN then
--        return self.AcLoginConfig[1]
--    elseif type == ActivityType.RECHARGE then
--        return self.AcRechargeConfig[1]
--    elseif type == ActivityType.PK then
--        return self.AcPKConfig[1]
--    elseif type == ActivityType.WEEKVIP then
--        return self.AcWeekVipConfig[1]
--    elseif type == ActivityType.VIPGIFT then
--        return self.AcVipGiftConfig[1]
--    elseif type == ActivityType.SALEPRICE then
--        return self.AcSalePriceConfig[1]
--    elseif type == ActivityType.MONTHCARD then
--        return self.AcMonthCardConfig[1]
--    elseif type == ActivityType.SPMONTHCARD then
--        return self.AcSPMonthCard[1]
--    elseif type == ActivityType.SERVER then
--        return self.AcServerConfig[1]
--    elseif type == ActivityType.WELFARE then
--        return self.AcWelfareConfig[1]
--    elseif type == ActivityType.EXCHANGEGIFT then
--        return self.AcExchangeGift[1]
--    elseif type == ActivityType.ALLCONSUME then   --13
--        return self.AcAllConsume[1]
--    elseif type == ActivityType.ONCERECHARGE then   --14
--        return self.AcOnceRecharge[1]
--    elseif type == ActivityType.ONCECONSUME then   --15
--        return self.AcOnceConsume[1]
--    end
--end

---NEW----------------------------------------------------------------------------
function ActivityConfig:isExistByType(type)
    local taskConfig = luacf.Activity.ActivityConfig.TaskConfig.Task
    for key, var in pairs(taskConfig) do
        if var.Type == type then
            return true
        end
    end
    local dealConfig = luacf.Activity.ActivityConfig.DealConfig.Deal
    for key, var in pairs(dealConfig) do
        if var.Type == type then
            return true
        end
    end
end

function ActivityConfig:getAcConfigById(id)
    local taskConfig = luacf.Activity.ActivityConfig.TaskConfig.Task
    for key, var in pairs(taskConfig) do
    	if var.Id == id then
    	    return var
    	end
    end
    local dealConfig = luacf.Activity.ActivityConfig.DealConfig.Deal
    for key, var in pairs(dealConfig) do
    	if var.Id == id then
    	    return var
    	end
    end
end

function ActivityConfig:getFirstConfigByType(type)
    local taskConfig = luacf.Activity.ActivityConfig.TaskConfig.Task
    for i=1,#taskConfig do
        if taskConfig[i].Type == type then
            return taskConfig[i]
        end
    end
    local dealConfig = luacf.Activity.ActivityConfig.DealConfig.Deal
    for j=1,#dealConfig do
        if dealConfig[j].Type == type then
            return dealConfig[j]
        end
    end
end