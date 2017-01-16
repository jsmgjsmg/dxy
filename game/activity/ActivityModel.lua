local ActivityModel = class("ActivityModel")

function ActivityModel:ctor()
    self.AcBtnList = {}
    self.ActivityList = {}
    
    self.AcLvData = {} --等级礼包==1
    self.AcLoginData = {} --登录礼包==2
    self.AcRechargeData = {} --累计充值==3
    self.AcPKData = {} --竞技场挑战次数==4
    self.AcWeekVipData = {} --VIP周礼包==5
    self.AcVipGiftData = {} --VIP超值礼包==6
    self.AcSalePriceData = {} --特价商城==7
    self.AcMonthCardData = {} --月卡==8
    self.AcSPMonthCard = {} --至尊月卡==9
    self.AcServerData = {} --开服基金==10
    self.AcWelfareData = {} --全民福利==11
    self.AcAllConsume = {} --累计消费==13
    self.AcOnceRecharge = {} --单笔充值==14
    self.AcOnceConsume = {}  --单笔消费==15
    
    self.isAcTips = true
end

--左边按钮
function ActivityModel:initBtnType(type)
    table.insert(self.AcBtnList,type)
end

--初始化
function ActivityModel:initAcByType(type,var)
    if type == ActivityType.LV then             --1
        table.insert(self.AcLvData,var)         
    elseif type == ActivityType.LOGIN then      --2
        table.insert(self.AcLoginData,var)
    elseif type == ActivityType.RECHARGE then   --3
        table.insert(self.AcRechargeData,var)
    elseif type == ActivityType.PK then         --4
        table.insert(self.AcPKData,var)
    elseif type == ActivityType.WEEKVIP then    --5
        table.insert(self.AcWeekVipData,var)
    elseif type == ActivityType.VIPGIFT then    --6
        table.insert(self.AcVipGiftData,var)
    elseif type == ActivityType.SALEPRICE then  --7
        table.insert(self.AcSalePriceData,var)
    elseif type == ActivityType.MONTHCARD then  --8
        table.insert(self.AcMonthCardData,var)
    elseif type == ActivityType.SPMONTHCARD then--9
        table.insert(self.AcSPMonthCard,var)
    elseif type == ActivityType.SERVER then     --10
        table.insert(self.AcServerData,var)
    elseif type == ActivityType.WELFARE then    --11
        table.insert(self.AcWelfareData,var)
    elseif type == ActivityType.ALLCONSUME then    --13
        table.insert(self.AcAllConsume,var)
    elseif type == ActivityType.ONCERECHARGE then    --14
        table.insert(self.AcOnceRecharge,var)    
    elseif type == ActivityType.ONCECONSUME then    --15
        table.insert(self.AcOnceConsume,var)    
    end
end

--统计
function ActivityModel:counttingAc(type)
    table.insert(self.ActivityList,type)
end

--sort
function ActivityModel:sortByType(type)
    local curList = nil
    if type == ActivityType.LV then
        curList = self.AcLvData
    elseif type == ActivityType.LOGIN then
        curList = self.AcLoginData
    elseif type == ActivityType.RECHARGE then
        curList = self.AcRechargeData
    elseif type == ActivityType.PK then
        curList = self.AcPKData
    elseif type == ActivityType.WEEKVIP then
        curList = self.AcWeekVipData
    elseif type == ActivityType.VIPGIFT then
        curList = self.AcVipGiftData
    elseif type == ActivityType.SALEPRICE then
        curList = self.AcSalePriceData
    elseif type == ActivityType.MONTHCARD then
        curList = self.AcMonthCardData
    elseif type == ActivityType.SPMONTHCARD then
        curList = self.AcSPMonthCard
    elseif type == ActivityType.SERVER then
        curList = self.AcServerData
    elseif type == ActivityType.WELFARE then
        curList = self.AcWelfareData
    elseif type == ActivityType.ALLCONSUME then    --13
        curList = self.AcAllConsume
    elseif type == ActivityType.ONCERECHARGE then    --14
        curList = self.AcOnceRecharge
    elseif type == ActivityType.ONCECONSUME then    --15
        curList = self.AcOnceConsume
    end
    if type ~= DefineConst.CONST_ACTIVITY_TYPE_EXCHANGE then
        table.sort(curList,function(t1,t2) return t1.Id<t2.Id end)
    end
    dxyDispatcher_dispatchEvent("ActivityNode_addScrollView",type)
end

--获取
function ActivityModel:getDataByType(type)
    if type == ActivityType.LV then
        return self.AcLvData
    elseif type == ActivityType.LOGIN then
        return self.AcLoginData
    elseif type == ActivityType.RECHARGE then
        return self.AcRechargeData
    elseif type == ActivityType.PK then
        return self.AcPKData
    elseif type == ActivityType.WEEKVIP then
        return self.AcWeekVipData
    elseif type == ActivityType.VIPGIFT then
        return self.AcVipGiftData
    elseif type == ActivityType.SALEPRICE then
        return self.AcSalePriceData
    elseif type == ActivityType.MONTHCARD then
        return self.AcMonthCardData
    elseif type == ActivityType.SPMONTHCARD then
        return self.AcSPMonthCard
    elseif type == ActivityType.SERVER then
        return self.AcServerData
    elseif type == ActivityType.WELFARE then
        return self.AcWelfareData
    elseif type == ActivityType.ALLCONSUME then    --13
        return self.AcAllConsume
    elseif type == ActivityType.ONCERECHARGE then    --14
        return self.AcOnceRecharge
    elseif type == ActivityType.ONCECONSUME then    --15
        return self.AcOnceConsume
    end
end

function ActivityModel:changeAcByType(data)
    local list = self:getDataByType(data.type)
    if not list then
        return
    end
    local arr = {}
    for key, var in pairs(list) do
    	if var.Id == data.id then
    	    var.State = data.state
            arr = {type = data.type,data = var}
            cn:showRewardsGet(var.Config.Rewards)
    	    break
    	end
    end
    dxyDispatcher_dispatchEvent("ActivityNode_changeActivity",arr)
end

function ActivityModel:whenClose()
    self.ActivityList = {}

    self.AcLvData = {} --等级礼包==1
    self.AcLoginData = {} --登录礼包==2
    self.AcRechargeData = {} --累计充值==3
    self.AcPKData = {} --竞技场挑战次数==4
    self.AcWeekVipData = {} --VIP周礼包==5
    self.AcVipGiftData = {} --VIP超值礼包==6
    self.AcSalePriceData = {} --特价商城==7
    self.AcMonthCardData = {} --月卡==8
    self.AcSPMonthCard = {} --至尊月卡==9
    self.AcServerData = {} --开服基金==10
    self.AcWelfareData = {} --全民福利==11
    self.ExChangeGift = {} --礼包兑换==12
    self.AcAllConsume = {} --累计消费==13
    self.AcOnceRecharge = {} --单笔充值==14
    self.AcOnceConsume = {}  --单笔消费==15
end

return ActivityModel