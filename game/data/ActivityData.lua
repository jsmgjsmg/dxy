local ActivityData = class("ActivityData")
require("game.activity.view.ItemAcOnce")  --等级礼包
require("game.activity.view.ItemAcTotal")  --竞技场礼包
ActivityType = {
    LV = 1,             --等级
    LOGIN = 2,          --登录
    RECHARGE = 3,       --累计充值
    PK = 4,             --竞技场挑战次数
    WEEKVIP = 5,        --VIP周礼包
    VIPGIFT = 6,        --VIP超值礼包
    SALEPRICE = 7,      --特价商城
    MONTHCARD = 8,      --月卡
    SPMONTHCARD = 9,    --至尊月卡
    SERVER = 10,        --开服基金
    WELFARE = 11,       --全民祝福
    EXCHANGEGIFT = 12,  --礼包兑换
    ALLCONSUME = 13,    --累计消费
    ONCERECHARGE = 14,  --单笔充值
    ONCECONSUME = 15,   --单笔消费
}

function ActivityData:ctor()
    self.svType = {
        [1] = ActivityType.LV,
        [2] = ActivityType.LOGIN,
        [3] = ActivityType.RECHARGE,
        [4] = ActivityType.PK,
        [5] = ActivityType.VIPGIFT,
        [6] = ActivityType.SALEPRICE,
        [7] = ActivityType.ALLCONSUME,
        [8] = ActivityType.ONCERECHARGE,
        [9] = ActivityType.ONCECONSUME,
    }
    
    self.svRequire = {
        [1] = "ItemAcOnce", --单项
        [2] = "ItemAcOnce",
        [14]= "ItemAcOnce",
        [15]= "ItemAcOnce",
        [3] = "ItemAcTotal", --累计
        [4] = "ItemAcTotal",
        [13]= "ItemAcTotal",
    }
    
end

return ActivityData