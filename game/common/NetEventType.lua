
NetEventType = {
--System model type
    Rec_Error_Code = 400,     -- 错误代码
    Rec_Other_Login = 440,    -- 在其他地方登录
    
    Req_Login_Logic_Server = 700, -- 请求逻辑服务器
    Rec_Login_Logic_Server = 710, -- 返回逻辑服务器
--User model type
    --Login
    Req_Login_Server = 1002,    -- 请求登录服务器
    Rec_Login_Server = 1004,    -- 登录服务器返回
    
    Req_Login_DelRole = 1010,    -- 请求登录服务器
    Rec_Login_DelRole = 1012,    -- 登录服务器返回
    
    Req_Create_Role = 1006,     -- 请求创建角色
    Rec_Create_Role = 1008,     -- 成功创建角色

    Req_Enter_Game = 1020,      -- 请求进入游戏
    Rec_Enter_Game = 1022,      -- 成功进入游戏
    
    -- Role Attribute
    Req_Look_RoleAttr = 1026,
    Rec_Look_RoleAttr_Back = 1028,
    Rec_RoleAttr_Update = 1024, -- 角色属性更新
    
    Rec_NewFunction_Init = 1035, -- 新功能开启登录
    Rec_NewFunction_Add = 1038,  -- 新功能开启新增
    Req_GuideGroup_Update = 1040, --
    
    Req_Role_Rename = 1042, --请求改名字
    
    Req_Role_GetDate = 1045, --请求角色信息
    
    Rec_Role_GetDate = 1046, --接收角色信息
    
    --BackPack
    Req_Role_Backpack = 2020,   -- 请求背包物品
    Rec_Backpack_Back = 2022,   -- 返回背包物品
    Rec_Backpack_Add = 2024,    -- 新增或更新背包物品
    Rec_Backpack_Del = 2026,    -- 删除背包物品
    
    --Spirit
    Req_Spirit_UseItem = 2052,  --请求装备器灵
    Req_Spirit_CastSpirit = 2054,   --请求卸下器灵 
    Req_Spirit_Resolve = 2056,  --请求分解器灵
    Req_Spirit_oneResolve = 2058,   --请求分解单件器灵
    Req_Spirit_Strengthen = 2060,   --请求强化器灵
    Rec_Spirit_Strengthen_Result = 2062,    --接受器灵强化结果
    Rec_Spirit_Resolve_Result = 2065,   --接收器灵分解获得的灵气

---Req @param 发送协议号    
---Rec @param 接收协议号
    Req_YuanShen_InitYuanGod = 3001,    -- 请求初始化元神
    Req_YuanShen_YuanGodUp = 3010,      -- 请求元神升级
    Req_YuanShen_MagicType = 3020,      -- 请求法器类型
    Req_YuanShen_MagicUnLock = 3030,    -- 请求法器解锁
    Req_YuanShen_MagicUp = 3040,        -- 请求法器升级
    Req_YuanShen_SkillUp = 3050,        -- 请求技能升级
    Req_YuanShen_Merger = 3045,         -- 请求技能石合成
    
    Rec_YuanShen_InitYuanGod = 3005,    -- 接收初始化元神
    Rec_YuanShen_YuanGodUp = 3015,      -- 接收元神升级属性
    Rec_YuanShen_MagicType = 3025,      -- 接收法器类型属性
    Rec_YuanShen_MagicUnLock = 3035,    -- 接收法器解锁结果
    
    Req_Backpack_UseItem = 2028,   -- 请求使用物品
    Req_Backpack_CastEquip = 2030,   -- 请求脱装备
    
    Req_Swallow_Equip = 2032,   --请求吞噬装备
    Rec_Swallow_Succeed = 2034, --接收吞噬成功结果
    
    Req_Melting_Equip = 2036,               --请求熔炼装备
    Rec_Melting_EquipAttr = 2038,           --接收熔炼装备属性
    Req_Melting_RecoverAttr = 2040,         --请求恢复原来的属性
    
    Req_Task_InitTask = 3501,    --请求任务初始化
    Req_Task_GetLogin = 3510,    --请求获取登陆奖励
    Req_Task_GetGrowUp = 3530,   --请求成长任务奖励
    Req_Task_GetEveryDate = 3540,--请求每日任务奖励
    Req_Task_GetAward = 3550,    --请求奖励任务奖励
    Req_Task_AllFinish = 3566,    --请求全勤奖励
    Req_Task_MakeUp = 3560,       --请求补签
    
    Rec_Task_InitTask = 3505,     --接收任务初始化
    Rec_Task_GetLogin = 3515,     --接收获取登陆奖励
    Rec_Task_FinishTask = 3520,   --完成任务(可领取奖励)
    Rec_Task_UpDateEvent = 3525,  --任务更新
    Rec_Task_GetGrowUp = 3535,    --接收成长任务奖励
    Rec_Task_GetEveryDate = 3545, --接收每日任务奖励
    Rec_Task_GetAward = 3555,     --接收奖励任务奖励
    
    Req_Copy_OpenList = 4001,          --请求已开启副本链表
    Rec_Copy_OpenList = 4004,          --接收副本链表数据
    Req_Copy_EnterCopy = 4006,         --请求进入副本
    Rec_Copy_EnterCopy_Return = 4007,      --进入确认
    Rec_Copy_ResultReward = 4012,      --副本奖励返回
    Rec_Copy_BoxReward = 4005,   --副本宝箱
    Rec_Copy_BoxRewardItem = 4180,   --副本宝箱Item
    Req_Copy_GetBoxReward = 4175,   --副本宝箱
    
    
    Req_Fairy_InitFairy = 4501,    --请求初始化仙女
    Req_Fairy_GiveFlowers = 4508,    --请求送花
    Req_Fairy_SendDoit = 4520,      --请求双修
    
    Rec_Fairy_InitFairy = 4505,        --接收初始化仙女
    Rec_Fairy_GiveFlowersSucc = 4510,  --接收升级成功
    Rec_Fairy_GiveFlowersFail = 4512,  --接收升级失败
    Rec_Fairy_unLockFairy = 4515,      --接收仙女解锁
    Rec_Fairy_unLockFairySkill = 4540, --接收仙女技能解锁
    Rec_Fairy_AllFairyPro = 4545,      --接收仙总属性加成
    Rec_Fairy_SendDoit = 4525,         --接收双修
    Rec_Fairy_overDoit = 4528,         --接收双修结束
    Rec_Fairy_upDateFV = 4535,         --接收疲劳刷新
    
    Req_Friend_InitFriend = 5504,    -- 请求好友数据
    Rec_Friend_FriendList = 5510,     --好友数据初始化
    Rec_Friend_ApplyList = 5520,    --申请好友列表初始化
    Req_Friend_AddFriend = 5530,    --请求添加好友
    Req_Friend_DeleteFriend = 5540,    --请求删除好友
    Rec_Friend_DeleteOK = 5542,     --删除好友成功
    Req_Friend_SearchFriend = 5550,    --请求搜索好友
    Rec_Friend_SearchList = 5560,     --搜索好友返回
    Rec_Friend_NewFriend = 5570,    --新增好友数据
    Rec_Friend_NewApplyFriend = 5580,     --新增申请好友数据
    Rec_Friend_GiftList = 5590,      --好友礼品数据数据
    Req_Friend_AcceptGift = 5600,     --接受好友礼品
    Req_Friend_AcceptFriend = 5610,     --接受好友0:拒绝|1:同意
    Req_Friend_GiveGift = 5620,     --赠送体力给好友
    Rec_Friend_ApplyDelete = 5630,     --删除申请列表数据
    Rec_Friend_GiftUpdate = 5640,     --礼物列表更新
    
    
    Req_Skill_List = 5001 , --   请求发送技能列表
    Rec_Skill_List = 5004 ,    -- 接受技能列表
    Req_Deblock_Skill = 5006 , --   请求解锁技能
    Req_Upgrade_Skill = 5008 , --   请求升级技能
    
    Req_CTSkill_List = 5011 , --   请求发送技能链列表
    Rec_CTSkill_List = 5013 , --   接受技能链列表
    Req_CTSkill_AddSkill = 5016 , --   请求放置技能到技能链
    Req_CTSkill_Deblock = 5018 , --   请求解锁技能链
    
    Req_Buy_Physical = 6020,    --购买体力
    
    
    Rec_Chat_MessageItem = 6510 ,
    Req_Chat_SendMessage = 6520 ,
    Rec_Chat_InitMessage = 6550 ,

---神将    
    Req_General_Merger = 7016,   --请求神将合并
    Req_General_UpGradeStar = 7021,   --请求神将升星
    Req_General_DestroyOne = 7032,  --请求单件分解
    Req_General_DestroyMore = 7034, --请求多选分解
    Req_General_ConvertFragment = 7040, --请求兑换碎片
    Req_General_FightGeneral = 7042, --请求神将出战
    Req_General_PutDownGeneral = 7050, --请求卸下神将
    Req_General_AddSoul = 7055,        --请求神台吸魂
    
    Rec_General_InitStage = 7068,      --接收初始化神台
    Rec_General_InitFragment = 7005,   --接收初始化碎片
    Rec_General_InitGeneral = 7010,    --接收初始化神将
    Rec_General_AddFragment = 7012,    --接收新增碎片
    Rec_General_UpDateFragment = 7013, --接收碎片更新
    Rec_General_ConvertFragment = 7014, --接收兑换碎片
    Rec_General_AddGeneral = 7019,     --接收新增神将
    Rec_General_UpGradeStar = 7025,    --接收神将升星
    Rec_General_DestroyGeneral = 7028,  --接收神将分解
    Rec_General_DestroyFragment = 7036, --接收碎片分解
    Rec_General_FightGeneral = 7045,   --接收神将出战
    Rec_General_PutDownGeneral = 7052,   --接收神将休息
    Rec_General_AddSoul = 7060,         --接收神台吸魂
    Rec_General_AllPro = 7070,          --接收封神总属性
    Rec_General_ToPlayer = 7072,         --接收封神对角色属性
    Rec_General_UpDateGeneral = 7075,    --接收更新神将属性
    Rec_General_Tips = 7065,             --接收吸魂暴击
    
---仙门
    Req_Group_CreateGroup = 8005,      --请求创建仙门
    Req_Group_GroupList = 8006,        --请求仙门列表
    Req_Group_FindGroup = 8010,        --请求搜索仙门
    Req_Group_AutoJoin = 8012,         --请求快速加入
    Req_Group_ExitGroup = 8015,        --请求退出仙门
    Req_Group_JoinGroup = 8020,        --请求加入仙门
    Req_Group_AnswerJoin = 8028,       --请求加入处理
    Req_Group_ResufeAll = 8032,        --请求全部拒绝
    Req_Group_EditTenet = 8042,        --请求更改宗旨
    Req_Group_ChangeRoot = 8048,       --请求改变职位
    Req_Group_DelectMember = 8053,     --请求解雇成员
    Req_Group_AskMemberList = 8063,    --请求仙门成员
    
    Rec_Group_InitGroup = 8001,        --接收仙门数据初始化
    Rec_Group_InitMember = 8002,       --接收仙门成员
    Rec_Group_GroupList = 8008,        --接收仙门列表
    Rec_Group_ExitGroup = 8018,        --接收退出仙门
    Rec_Group_JoinGroup = 8022,        --接收申请消息列表
    Rec_Group_JoinOne = 8025,          --接收单个申请消息
    Rec_Group_AnswerJoin = 8038,       --接收加入处理
    Rec_Group_ResufeAll = 8035,        --全部拒绝成功
    Rec_Group_AddMember = 8030,        --接收新增成员
    Rec_Group_EditTenet = 8045,        --接收更改宗旨
    Rec_Group_ChangeRoot = 8050,       --接收改变职位
    Rec_Group_AddThing = 8056,         --接收新增事件
    Rec_Group_InitThing = 8060,        --初始化事件
    Rec_Group_AskMemberList = 8065,    --接收仙门成员
    Rec_Group_FindGroup = 8070,        --接收搜索仙门
    Rec_Group_UpdatePower = 8072,      --接收成员战力更新

--充值
    Req_Rec_Recharge = 6006,       --请求购买
    Req_Rec_MonthCard = 6012,      --请求购买月卡
    Req_Rec_GetFirstPay = 6015,    --请求领取首冲奖励

    Rec_Rec_InitState = 6001,      --接收vip状态
    Rec_Rec_InitRecList = 6004,    --接收已购买
    Rec_Rec_Recharge = 6009,       --接收购买
    Rec_Rec_GetFirstPay = 6018,    --接收领取奖励
    
--排行榜
    Req_Rank_GetLv = 8501,          --请求等级排行
    Req_Rank_GetPower = 8502,       --请求战力排行
    Req_Rank_GetGroup = 8503,       --请求仙门排行
    Req_Rank_GroupData = 8078,      --请求仙门信息
        
    Rec_Rank_GetLv = 8506,          --接收等级排行
    Rec_Rank_GetPower = 8507,       --接收战力排行
    Rec_Rank_GetGroup = 8508,       --接收仙门排行
    Rec_Rank_GroupData = 8080,      --接收仙门信息
    
--竞技场
    Req_Pk_GetData = 9501,          --请求获取竞技场数据
    Rec_Pk_GetData = 9502,          --接收竞技场数据
    
    Req_Lottery_GetData = 11100,          --请求
    Rec_Lottery_GetData = 11102,          --接收
    Req_Lottery_GetInfoData = 11104,          --请求
    Rec_Lottery_GetInfoData = 11106,          --接收
    Req_Lottery_GetRawerd = 11110,          --请求
    Rec_Lottery_GetRawerd = 11112,          --接收
    
}
