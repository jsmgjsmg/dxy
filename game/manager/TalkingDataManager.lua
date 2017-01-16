local TalkingDataManager = TalkingDataManager or class("TalkingDataManager")

EumEventId = {
    EQUIP_STRENGTHEN = "装备强化",
    EQUIP_MELTING = "装备熔炼",
    EQUIP_SELL = "装备出售",
    SPIRIT_STRENGTHEN = "器灵强化",
    SPIRIT_RESOLVE = "器灵分解",
    YUANSHEN_TRAIN = "元神培养",
    MAGIC_UPGRADE = "法器升星",
    MAGIC_SKILL_UPGRADE = "法器技能升级",
    FAIRY_TRAIN = "仙女培养",
    FRAIRY_DOUBLEREPAIR = "仙女双修",
    GENERAL_STAGE_TARIN = "封神台培养",
    GENERAL_UPGRADE = "神将升星",
    GENERAL_FRAGMENT_RESOLVE = "神将碎片分解",
    GENERAL_FRAGMENT_EXCHANGE = "神将碎片兑换",
    PK_OPEN_COUNT = "竞技场打开次数",
    PK_DEKARON_COUNT = "竞技场挑战次数",
    SKILL_UPGRADE = "升级技能",
    CTSKILL_COUNT = "技能链",
}

function TalkingDataManager:ctor()
    self.targetPlatform = cc.Application:getInstance():getTargetPlatform()
end

--设置唯一ID
function TalkingDataManager:setAccount(account)
    if cc.PLATFORM_OS_ANDROID == self.targetPlatform then       
	   TDGAAccount:setAccount(account)
    end
end

--设置玩家显式姓名
function TalkingDataManager:setAccountName(name)
    if cc.PLATFORM_OS_ANDROID == self.targetPlatform then       
        TDGAAccount:setAccountName(name)
    end
end

--设置账户类型
function TalkingDataManager:setAccountType(type)
    if cc.PLATFORM_OS_ANDROID == self.targetPlatform then       
        TDGAAccount:setAccountType(type)
    end
end

--设置玩家等级
function TalkingDataManager:setLevel(lv)
    if cc.PLATFORM_OS_ANDROID == self.targetPlatform then       
        TDGAAccount:setLevel(lv)
    end
end

--设置玩家性别
function TalkingDataManager:setGender(gender)
    if cc.PLATFORM_OS_ANDROID == self.targetPlatform then       
        TDGAAccount:setGender(gender)
    end
end

--设置玩家年龄
function TalkingDataManager:setAge(age)
    if cc.PLATFORM_OS_ANDROID == self.targetPlatform then       
        TDGAAccount:setAge(age)
    end
end

--设置玩家登陆服务器
function TalkingDataManager:setGameServer(server)
    if cc.PLATFORM_OS_ANDROID == self.targetPlatform then       
        TDGAAccount:setGameServer(server)
    end
end

--任务关卡副本开启
function TalkingDataManager:onBegin(missionId)
    if cc.PLATFORM_OS_ANDROID == self.targetPlatform then       
        TDGAMission:onBegin(missionId)
    end
end

--任务关卡副本完成
function TalkingDataManager:onCompleted(missionId)
    if cc.PLATFORM_OS_ANDROID == self.targetPlatform then       
        TDGAMission:onCompleted(missionId)
    end
end

--任务关卡副本失败
function TalkingDataManager:onFailed(missionId,cause)
    if cc.PLATFORM_OS_ANDROID == self.targetPlatform then       
        TDGAMission:onFailed(missionId,cause)
    end
end

--自定义事件(实际用的是消费点的方法，单价设置为0)
function TalkingDataManager:onEvent(eventId,eventData)
    if cc.PLATFORM_OS_ANDROID == self.targetPlatform then       
        TDGAItem:onPurchase(eventId,1,0)
    end
end

return TalkingDataManager