-- 协议号宏定义文件


DefineProto = {

	-- 系统
	PROTO_SYSTEM_TIME                                = 100,       -- 时间校正
	PROTO_SYSTEM_EROOR_CODE                          = 400,       -- 错误代码
	PROTO_SYSTEM_LOGIN_ELSEWHERE                     = 440,       -- 在别处登陆
	PROTO_SYSTEM_GET_LOGIC_NODE_ADDRESS              = 700,       -- 获取逻辑节点地址
	PROTO_SYSTEM_RETURN_LOGIC_NODE_ADDRESS_DATA      = 710,       -- 返回逻辑节点地址数据
	PROTO_SYSTEM_DEBUGGING_COMMAND                   = 800,       -- 调试命令
	PROTO_SYSTEM_STATE_UPDATE                        = 900,       -- 全局状态更新

	-- 角色
	PROTO_ROLE_LOGIN                                 = 1002,      -- 登陆
	PROTO_ROLE_LOGIN_SUCCEED                         = 1004,      -- 登陆成功
	PROTO_ROLE_ERROR_ACCOUNT                         = 1006,      -- 账号错误
	PROTO_ROLE_CREATE_ROLE_SUCCESSFUL                = 1008,      -- 创建角色成功
	PROTO_ROLE_REMOVE_ROLE                           = 1010,      -- 删除角色
	PROTO_ROLE_DELETE_ROLE_DATA_UPDATE               = 1012,      -- 删除角色数据更新
	PROTO_ROLE_UPDATE_DATA                           = 1020,      -- 更新数据
	PROTO_ROLE_LOGIN_INTO_THE_GAME_TO_RETURN_DATA    = 1022,      -- 登陆进入游戏返回数据
	PROTO_ROLE_UPDATE                                = 1024,      -- 属性更新
	PROTO_ROLE_REQUEST_TO_SEE_THE_ROLE_OF_PROPERTY   = 1026,      -- 请求查看角色属性
	PROTO_ROLE_ATTRIBUTE_DATA                        = 1028,      -- 角色属性数据
	PROTO_ROLE_LOGIN_ISSUED_OPEN_MODULE              = 1035,      -- 登陆下发开启模块
	PROTO_ROLE_NEW_FEATURE_LIST                      = 1038,      -- 新增功能列表
	PROTO_ROLE_UPDATE_BEGINNERS_GUIDE_ID             = 1040,      -- 更新新手引导id
	PROTO_ROLE_CHANGE_NAME                           = 1042,      -- 更改名字
	PROTO_ROLE_VIEW_PLAYER_INFORMATION               = 1045,      -- 查看玩家信息
	PROTO_ROLE_PLAYERS_RETURN_INFORMATION            = 1046,      -- 返回玩家信息
	PROTO_ROLE_CHECK_RANGKING                        = 1050,      -- 查看排名
	PROTO_ROLE_RETURN_RANKING                        = 1052,      -- 返回排名
	PROTO_ROLE_POWER_SUB                             = 1060,      -- 战斗力

	-- 物品
	PROTO_GOODS_REQUEST_BACKPACK                     = 2020,      -- 请求背包
	PROTO_GOODS_BACKPACKS_ALL_ITEMS                  = 2022,      -- 背包所有物品
	PROTO_GOODS_NEW_ITEMS                            = 2024,      -- 新增物品
	PROTO_GOODS_REMOVE_ITEMS                         = 2026,      -- 删除物品
	PROTO_GOODS_USE_ITEMS                            = 2028,      -- 穿戴装备/使用物品
	PROTO_GOODS_REMOVING_EQUIPMENT                   = 2030,      -- 卸下装备
	PROTO_GOODS_PHAGOCYTOSIS_EQUIPMENT               = 2032,      -- 吞噬装备
	PROTO_GOODS_EQUIPMENT_SWALLOWED_SUCCESS          = 2034,      -- 吞噬装备成功
	PROTO_GOODS_SMELTING_EQUIPMENT                   = 2036,      -- 熔炼装备
	PROTO_GOODS_SMELTING_EQUIPMENT_PROPERTY          = 2038,      -- 熔炼装备属性
	PROTO_GOODS_RECOVERY_SMELTING_EQUIPMENT          = 2040,      -- 恢复熔炼装备
	PROTO_GOODS_EQUIPMENT_MAGICSOUL                  = 2052,      -- 装备器灵
	PROTO_GOODS_UNLOAD_MAGICSOUL                     = 2054,      -- 卸下器灵
	PROTO_GOODS_DECOMPOSITION_MORE_MAGICSOUL         = 2056,      -- 分解多件器灵
	PROTO_GOODS_DECOMPOSITION_MAGICSOUL              = 2058,      -- 分解单件器灵
	PROTO_GOODS_ENHANCER_MAGICSOUL                   = 2060,      -- 强化器灵
	PROTO_GOODS_ENHANCER_MAGICSOUL_RESULTS           = 2062,      -- 强化器灵结果
	PROTO_GOODS_GET_ANIMA_COUNT                      = 2065,      -- 器灵分解获得灵气数量
	PROTO_GOODS_EQUIP_SELL                           = 2070,      -- 装备出售
	PROTO_GOODS_RETURN_EQUIP_SELL                    = 2075,      -- 返回装备出售
	PROTO_GOODS_EQUIP_MORE_SELL                      = 2080,      -- 多件装备出售

	-- 元神
	PROTO_YUAN_GOD_GET_YUAN_GOD_NATURE               = 3001,      -- 获取元神属性
	PROTO_YUAN_GOD_RETURN_YUAN_GOD_PROPERTY          = 3005,      -- 返回元神属性
	PROTO_YUAN_GOD_YUAN_GOD_PRACTICE                 = 3010,      -- 元神修炼
	PROTO_YUAN_GOD_RETURN_YUAN_GOD_PRACTICE          = 3015,      -- 返回元神修炼
	PROTO_YUAN_GOD_GET_MAGICITEM_NATURE              = 3020,      -- 获取法器属性
	PROTO_YUAN_GOD_RETURN_MAGICITEM_NATURE           = 3025,      -- 法器属性
	PROTO_YUAN_GOD_MAGICITEM_UNLOCK                  = 3030,      -- 法器解锁
	PROTO_YUAN_GOD_RETURN_MAGICITEM_UNLOCK           = 3035,      -- 返回法器解锁
	PROTO_YUAN_GOD_MAGICITEM_PRACTICE                = 3040,      -- 法器修炼
	PROTO_YUAN_GOD_SYNTHETIC_STONES                  = 3045,      -- 一键合成石头
	PROTO_YUAN_GOD_SKILLS_UPGRADING                  = 3050,      -- 技能升级
	PROTO_YUAN_GOD_A_COMPOUND_STONE                  = 3055,      -- 合成石头

	-- 任务
	PROTO_TASK_GET_TASK_LIST                         = 3501,      -- 获取任务列表
	PROTO_TASK_TASK_LIST                             = 3505,      -- 任务列表
	PROTO_TASK_NEWTASK_LIST                          = 3506,      -- 领取列表
	PROTO_TASK_FINISH_LOGIN_TASK                     = 3510,      -- 领取登陆任务奖励
	PROTO_TASK_RETURN_LOGIN_TASK_STATE               = 3515,      -- 返回登录任务状态
	PROTO_TASK_UPDATE_TASK_STATUS                    = 3520,      -- 更新任务状态
	PROTO_TASK_UNLOCK_TASK                           = 3525,      -- 解锁任务
	PROTO_TASK_FINISH_GROW_TASK                      = 3530,      -- 领取成长任务奖励
	PROTO_TASK_RETURN_GROW_TASK_STATE                = 3535,      -- 返回成长任务状态
	PROTO_TASK_FINISH_DAIRY_TASK                     = 3540,      -- 领取每日任务奖励
	PROTO_TASK_RETURN_DAIRY_TASK_STATE               = 3545,      -- 返回每日任务状态
	PROTO_TASK_FINISH_REWARD_TASK                    = 3550,      -- 领取奖励任务奖励
	PROTO_TASK_RETURN_REWARD_TASK_STATE              = 3555,      -- 返回奖励任务状态
	PROTO_TASK_RETROACTIVE                           = 3560,      -- 补签
	PROTO_TASK_FINISH_ATTENDANCE                     = 3566,      -- 领取全勤
	PROTO_TASK_ADD_NEWTASK                           = 3570,      -- 新增领取任务
	PROTO_TASK_FINISH_NEWTASK                        = 3575,      -- 领取新奖励
	PROTO_TASK_RETURN_FINISH_NEWTASK                 = 3580,      -- 返回新奖励状态
	PROTO_TASK_RETURN_LIVELY                         = 3585,      -- 返回活跃度宝箱
	PROTO_TASK_GET_LIVELY                            = 3590,      -- 领取活跃度宝箱
	PROTO_TASK_RETURN_LIVELY_ID                      = 3595,      -- 活跃度宝箱id

	-- 副本
	PROTO_COPY_GET_SCHEDULE_DATA                     = 4001,      -- 获取副本进度数据
	PROTO_COPY_RETURN_SCHEDULE_DATA                  = 4004,      -- 副本进度数据返回
	PROTO_COPY_RETURN_CHAPTEREWARD                   = 4005,      -- 副本章节奖励
	PROTO_COPY_ENTER_THE_COPY                        = 4006,      -- 进入副本
	PROTO_COPY_RETURN_COPY_TYPE                      = 4007,      -- 副本类型
	PROTO_COPY_RETURN_CLEARANCE_INTERFACE_REWARD_DATA= 4008,      -- 副本通关界面奖励
	PROTO_COPY_RETURN_COPY_DATA                      = 4009,      -- 副本数据
	PROTO_COPY_CLEARANCE_COPY                        = 4010,      -- 通关副本
	PROTO_COPY_RETURN_CLEARANCE_REWARD_DATA          = 4012,      -- 通关副本奖励数据
	PROTO_COPY_COPY_OPEN                             = 4014,      -- 副本开启
	PROTO_COPY_PICK_UP_BONUS_MONSTER_DROP            = 4030,      -- 拾取怪物掉落的奖励
	PROTO_COPY_MAGICSOUL_COPY_DATA                   = 4043,      -- 器灵副本数据
	PROTO_COPY_EXPLORER_MAGICSOUL_COPY               = 4046,      -- 探索器灵副本
	PROTO_COPY_UPDATE_MAGICSOUL_COPY_DATA            = 4048,      -- 更新器灵副本数据
	PROTO_COPY_MAGICSOUL_DROP_DATA                   = 4051,      -- 器灵副本掉落数据
	PROTO_COPY_PICKUP_MAGICSOUL_COPY_REWARD          = 4055,      -- 拾取器灵副本奖励
	PROTO_COPY_PICKUP_MAGICSOUL_COPY_PROGRESS_REQ    = 4056,      -- 请求器灵探索进度
	PROTO_COPY_PICKUP_MAGICSOUL_COPY_COUNT_DATA      = 4057,      -- 器灵副本可扫荡次数
	PROTO_COPY_PICKUP_MAGICSOUL_COPY_PROGRESS        = 4058,      -- 器灵探索进度数据(通关过)
	PROTO_COPY_CLEARANCE_MAGICSOUL_COPY              = 4060,      -- 通关器灵副本
	PROTO_COPY_CLEARANCE_MONEY_COPY                  = 4070,      -- 通关财神宝库
	PROTO_COPY_RETURN_CLEARANCE_MONEY_COPY           = 4075,      -- 通关财神宝库
	PROTO_COPY_FLOP                                  = 4080,      -- 翻牌
	PROTO_COPY_COPY_FAIL                             = 4085,      -- 通关失败
	PROTO_COPY_RETURN_COPY_FAIL                      = 4090,      -- 通关失败
	PROTO_COPY_GODWILL_COPY_CLEARANCE                = 4100,      -- 通关神将副本
	PROTO_COPY_RETURN_GODWILL_COPY_CLEARANCE         = 4105,      -- 通关神将副本
	PROTO_COPY_TRAIN_CLEARANCE_COPY                  = 4110,      -- 通关试炼塔
	PROTO_COPY_RETURN_TRAIN_CLEARANCE_COPY           = 4115,      -- 通关试炼塔
	PROTO_COPY_REFRESH_GODCOPY                       = 4120,      -- 刷新神将副本
	PROTO_COPY_RETURN_REFRESH_GODCOPY                = 4125,      -- 返回刷新神将副本
	PROTO_COPY_RESURGENCE                            = 4135,      -- 复活
	PROTO_COPY_COME_SOCIATY_SCENSE                   = 4138,      -- 进入仙门场景
	PROTO_COPY_NEW_IN_SOCIATY_SCENSE                 = 4140,      -- 新进入仙门场景
	PROTO_COPY_EXIT_SOCIATY_SCENSE                   = 4145,      -- 退出仙门场景
	PROTO_COPY_RETURN_EXIT_SOCIATY_SCENSE            = 4150,      -- 返回退出仙门场景
	PROTO_COPY_MOVE_SOCIATY_SCENSE                   = 4160,      -- 仙门场景移动
	PROTO_COPY_UPDATE_MOVE_SOCIATY_SCENSE            = 4165,      -- 更新仙门场景移动
	PROTO_COPY_GODCOPY_REWARD                        = 4170,      -- 神将副本奖励
	PROTO_COPY_GET_CHAPTEREWARD_REWARD               = 4175,      -- 领取宝箱奖励
	PROTO_COPY_CHAPTEREWARD_STATE                    = 4180,      -- 宝箱状态
	PROTO_COPY_COOLDOWN_REQ                          = 4190,      -- 请求副本冷却时间戳
	PROTO_COPY_COOLDOWN_DATA                         = 4192,      -- 副本冷却时间戳数据

	-- 仙女
	PROTO_FAIRY_GET_FAIRY_DATA                       = 4501,      -- 获取仙女数据
	PROTO_FAIRY_RETURNS_FAIRY_DATA                   = 4505,      -- 返回仙女数据
	PROTO_FAIRY_GIVE_FLOWERS                         = 4508,      -- 仙女送花
	PROTO_FAIRY_GIVE_FLOWERS_UPGRADE_RESULTS         = 4510,      -- 仙女送花升级结果
	PROTO_FAIRY_GIVE_FLOWERS_FAIL_RESULTS            = 4512,      -- 仙女送花失败结果
	PROTO_FAIRY_FAIRY_UNLOCK                         = 4515,      -- 仙女解锁
	PROTO_FAIRY_MIND_AND_BODY                        = 4520,      -- 仙女双修
	PROTO_FAIRY_REFRESH_FAIRY_MIND_AND_BODY          = 4525,      -- 刷新仙女双修
	PROTO_FAIRY_END_MIND_AND_BODY                    = 4528,      -- 结束双修
	PROTO_FAIRY_REFRESH_FAIRY_FATIGUE                = 4535,      -- 刷新仙女疲劳值
	PROTO_FAIRY_SKILL_UNLOCK                         = 4540,      -- 仙女技能解锁
	PROTO_FAIRY_TOTAL_PROPERTY                       = 4545,      -- 仙女总属性
	PROTO_FAIRY_EQUIP_SKILL                          = 4550,      -- 仙女装备技能
	PROTO_FAIRY_RETURN_EQUIP_SKILL                   = 4555,      -- 仙女返回装备技能

	-- 技能
	PROTO_SKILL_GET_SKILL_LIST                       = 5001,      -- 获取技能列表
	PROTO_SKILL_RETURN_SKILL_LIST                    = 5004,      -- 返回技能列表
	PROTO_SKILL_UNLOCK_SKILL                         = 5006,      -- 解锁技能
	PROTO_SKILL_UPGRADE_SKILL                        = 5008,      -- 升级技能
	PROTO_SKILL_GET_SKILL_CHAIN                      = 5011,      -- 获取技能链
	PROTO_SKILL_RETURN_SKILL_CHAIN                   = 5013,      -- 返回技能链
	PROTO_SKILL_PLACE_SKILL                          = 5016,      -- 放置技能in技能链
	PROTO_SKILL_UNLOCK_SKILL_CHAIN                   = 5018,      -- 解锁技能链
	PROTO_SKILL_DISCHARGE_SKILL                      = 5022,      -- 卸下技能

	-- 好友
	PROTO_FRIEND_FRIEND_REQUEST_DATA                 = 5504,      -- 打开好友面板请求数据
	PROTO_FRIEND_FRIENDS_DATA                        = 5510,      -- 好友数据
	PROTO_FRIEND_FRIENDS_APPLICATION_DATA            = 5520,      -- 好友申请数据
	PROTO_FRIEND_REQUEST_ADD_FRIEND                  = 5530,      -- 请求添加好友
	PROTO_FRIEND_REQUEST_REMOVAL_FRIENDS             = 5540,      -- 请求删除好友
	PROTO_FRIEND_DELETE_BUDDY_LIST_DATA              = 5542,      -- 删除好友列表数据
	PROTO_FRIEND_SEARCH_FRIENDS                      = 5550,      -- 搜索好友
	PROTO_FRIEND_SEARCH_RESULT                       = 5560,      -- 搜索结果
	PROTO_FRIEND_ADD_FRIENDS                         = 5570,      -- 新增好友
	PROTO_FRIEND_NEW_APPLICATION_INFORMATION         = 5580,      -- 新增申请信息
	PROTO_FRIEND_PHYSICAL_GIFT_LIST                  = 5590,      -- 体力赠送列表
	PROTO_FRIEND_AGREE_TO_ACCEPT_PHYSICAL            = 5600,      -- 同意接受体力
	PROTO_FRIEND_AUDIT_FRIEND_REQUESTS               = 5610,      -- 审核好友申请
	PROTO_FRIEND_GIVE_PHYSICAL                       = 5620,      -- 赠送体力给好友
	PROTO_FRIEND_REMOVE_APPLICATION_LIST_DATA        = 5630,      -- 删除申请列表数据
	PROTO_FRIEND_GIFT_LIST_UPDATE                    = 5640,      -- 礼物赠送列表更新

	-- vip/充值
	PROTO_RECHARGE_VIP_STATUS                        = 6001,      -- vip状态
	PROTO_RECHARGE_RECHARGE_LIST                     = 6004,      -- 充值列表
	PROTO_RECHARGE_RECHARGE                          = 6006,      -- 充值
	PROTO_RECHARGE_RETURN_RECHARGE                   = 6009,      -- 返回充值
	PROTO_RECHARGE_BUY_MONTHCARD                     = 6012,      -- 购买月卡
	PROTO_RECHARGE_RECEIVING_FIRST_PUNCH             = 6015,      -- 领取首冲
	PROTO_RECHARGE_RETURN_RECEIVING_FIRST_PUNCH      = 6018,      -- 返回领取首冲
	PROTO_RECHARGE_BUY_PHYSICAL                      = 6020,      -- 购买体力
	PROTO_RECHARGE_BUY_GODWILLPHYSICAL               = 6025,      -- 购买神将体力

	-- 聊天
	PROTO_CHAT_CHAT_MESSAGES                         = 6510,      -- 聊天消息
	PROTO_CHAT_SEND_MESSAGE                          = 6520,      -- 发送消息
	PROTO_CHAT_RECRUIT                               = 6530,      -- 招募
	PROTO_CHAT_RECRUITMENT_NFORMATION                = 6540,      -- 招募信息
	PROTO_CHAT_TROTTING_HORSE_LAMP                   = 6555,      -- 走马灯消息

	-- 神将
	PROTO_GODWILL_LOGIN_SEND_GODCHIP_LIST            = 7005,      -- 登陆下发神将碎片列表
	PROTO_GODWILL_LOGIN_SEND_GODWILL_LIST            = 7010,      -- 登陆下封神榜
	PROTO_GODWILL_ADD_GODCHIP                        = 7012,      -- 新增碎片
	PROTO_GODWILL_UPDATE_GODCHIP                     = 7013,      -- 更新碎片数量
	PROTO_GODWILL_EXCHANGE_GODCHIP_SUCCEED           = 7014,      -- 兑换成功
	PROTO_GODWILL_GODWILL_SYNTHESIZE                 = 7016,      -- 神将合成
	PROTO_GODWILL_ADD_GODWILL                        = 7019,      -- 新增神将
	PROTO_GODWILL_GODWILL_RISING_STAR                = 7021,      -- 神将升星
	PROTO_GODWILL_RETURN_GODWILL_RISING_STAR         = 7025,      -- 返回神将升星
	PROTO_GODWILL_SINGLE_DECOMPOSITION               = 7032,      -- 单件分解
	PROTO_GODWILL_MORE_DECOMPOSITION                 = 7034,      -- 多件分解
	PROTO_GODWILL_REMOVE_GODCHIP                     = 7036,      -- 删除碎片
	PROTO_GODWILL_EXCHANGE_GODCHIP                   = 7040,      -- 兑换碎片
	PROTO_GODWILL_REPLACE_PLAYED                     = 7042,      -- 更换出战神酱
	PROTO_GODWILL_RETURN_REPLACE_PLAYED              = 7045,      -- 返回更换出战神酱
	PROTO_GODWILL_REMOVING_GODWILL                   = 7050,      -- 卸下神将
	PROTO_GODWILL_RETURN_REMOVING_GODWILL            = 7052,      -- 卸下神将成功
	PROTO_GODWILL_SUCK_THE_SOUL                      = 7055,      -- 封神台吸魂
	PROTO_GODWILL_UPDATE_GODTAI                      = 7060,      -- 更新封神台
	PROTO_GODWILL_SUCK_THE_SOUL_CRIT_FEEDBACK        = 7065,      -- 封神台吸魂暴击反馈
	PROTO_GODWILL_LOGIN_SEND_GODTAI                  = 7068,      -- 登陆下发封神台
	PROTO_GODWILL_UPDATE_TOTAL_PROPERTY              = 7070,      -- 更新总属性
	PROTO_GODWILL_TOTAL_BONUSES_FOR_PLAYERS          = 7072,      -- 对玩家总属性加成
	PROTO_GODWILL_GODWILL_ATTRIBUTE_UPDATE           = 7075,      -- 更新神将属性
	PROTO_GODWILL_GODWILL_MOPUP                      = 7080,      -- 扫荡神将副本

	-- 仙门
	PROTO_SOCIATY_SOCIATY_DATA                       = 8001,      -- 仙门数据
	PROTO_SOCIATY_SOCIATY_MEMBER_DATA                = 8002,      -- 仙门人员数据
	PROTO_SOCIATY_REQUEST_MEMBER_DATA                = 8003,      -- 仙门请求人员数据
	PROTO_SOCIATY_CREATE_SOCIATY                     = 8005,      -- 创建仙门
	PROTO_SOCIATY_REQUEST_SOCIATY_LIST_PAGE          = 8006,      -- 请求仙门列表页
	PROTO_SOCIATY_RETURN_REQUEST_SOCIATY_LIST        = 8008,      -- 返回请求仙门列表
	PROTO_SOCIATY_SEARCH_SOCIATY                     = 8010,      -- 搜索仙门
	PROTO_SOCIATY_QUICK_ADDED                        = 8012,      -- 快速加入仙门
	PROTO_SOCIATY_EXIT_SOCIATY                       = 8015,      -- 退出仙门
	PROTO_SOCIATY_RETURN_EXIT_SOCIATY                = 8018,      -- 返回退出仙门
	PROTO_SOCIATY_SOCIATY_APPLICATION                = 8020,      -- 仙门申请
	PROTO_SOCIATY_SOCIATY_APPLICATION_LIST           = 8022,      -- 仙门申请
	PROTO_SOCIATY_RETURN_SOCIATY_APPLICATION         = 8025,      -- 返回仙门申请
	PROTO_SOCIATY_APPLICATION_PROCESSING             = 8028,      -- 申请处理
	PROTO_SOCIATY_NEW_MEMBERS                        = 8030,      -- 新增成员
	PROTO_SOCIATY_ALL_REFUSED                        = 8032,      -- 全部拒绝
	PROTO_SOCIATY_ALL_REFUSED_SUCCESS                = 8035,      -- 全部拒绝成功
	PROTO_SOCIATY_REFUSED_TREATMENT_SUCCESS          = 8038,      -- 拒绝申请处理成功
	PROTO_SOCIATY_EDIT_PURPOSES                      = 8042,      -- 编辑宗旨
	PROTO_SOCIATY_UPDATE_PURPOSES                    = 8045,      -- 更新宗旨
	PROTO_SOCIATY_POSITION_CHANGE                    = 8048,      -- 改变职务
	PROTO_SOCIATY_UPDATE_DUTIES                      = 8050,      -- 更新职务
	PROTO_SOCIATY_DISMISSAL_MEMBERS                  = 8053,      -- 解雇成员
	PROTO_SOCIATY_EVENT_INFORMATION                  = 8056,      -- 事件信息
	PROTO_SOCIATY_LOGIN_SEND_MSG                     = 8060,      -- 登陆下发事件信息
	PROTO_SOCIATY_VIEW_PERSONNEL_DATA                = 8063,      -- 查看仙门人员数据
	PROTO_SOCIATY_RETURN_VIEW_PERSONNEL_DATA         = 8065,      -- 返回查看仙门人员数据
	PROTO_SOCIATY_REQUEST_SOCIATY_LIST               = 8070,      -- 请求仙门列表
	PROTO_SOCIATY_UPDATE_MEMBERS_FIGHTING            = 8072,      -- 更新仙门新成员战斗力
	PROTO_SOCIATY_UPDATE_SOCIATY_FIGHTING            = 8075,      -- 更新仙门战斗力
	PROTO_SOCIATY_GET_SOCIATY_INFORMATION            = 8078,      -- 获取仙门信息
	PROTO_SOCIATY_RETURN_SOCIATY_INFORMATION         = 8080,      -- 返回获取仙门信息
	PROTO_SOCIATY_SOCIATY_PRAY                       = 8090,      -- 仙门祈福
	PROTO_SOCIATY_SOCIATY_RETURN_PRAY                = 8095,      -- 返回仙门祈福
	PROTO_SOCIATY_SOCIATY_UPDATE_BUILD               = 8100,      -- 更新仙门建设度
	PROTO_SOCIATY_GET_TALENT                         = 8104,      -- 获取天赋
	PROTO_SOCIATY_TALENT_XIULIAN                     = 8105,      -- 天赋修炼
	PROTO_SOCIATY_RETURN_TALENT                      = 8110,      -- 返回天赋
	PROTO_SOCIATY_REQUEST_SUCCEED                    = 8115,      -- 仙门申请成功
	PROTO_SOCIATY_PRAY_RANKING                       = 8120,      -- 仙门祈福排行榜
	PROTO_SOCIATY_RETURN_PRAY_RANKING                = 8125,      -- 祈福排行榜返回
	PROTO_SOCIATY_SET_FIGHTLIMIT                     = 8130,      -- 设置战斗力限制
	PROTO_SOCIATY_RETURN_FIGHTLIMIT                  = 8135,      -- 返回战斗力限制
	PROTO_SOCIATY_EXCHANGE_SHOP                      = 8140,      -- 仙门兑换商店
	PROTO_SOCIATY_EXCHANGE_GOODS                     = 8145,      -- 兑换商品
	PROTO_SOCIATY_RETURN_EXCHANGE_GOODS              = 8150,      -- 返回兑换商品
	PROTO_SOCIATY_UPDATE_INTEGRAL                    = 8155,      -- 更新积分

	-- 排行
	PROTO_RANKING_GET_LV_RANKING                     = 8501,      -- 获取等级排行
	PROTO_RANKING_GET_FIGHT_RANKING                  = 8502,      -- 获取战斗力排行
	PROTO_RANKING_GET_SOCIATY_RANKING                = 8503,      -- 获取仙门排行
	PROTO_RANKING_RETURN_LV_RANKING                  = 8506,      -- 返回等级排行
	PROTO_RANKING_RETURN_FIGHT_RANKING               = 8507,      -- 返回战斗力排行
	PROTO_RANKING_RETURN_SOCIATY_RANKING             = 8508,      -- 返回仙门排行

	-- 世界boss
	PROTO_WORLD_BOSS_ENTER_DATA                      = 9010,      -- 进入世界boss副本数据
	PROTO_WORLD_BOSS_HARM                            = 9020,      -- 玩家对boss造成伤害
	PROTO_WORLD_BOSS_BLOOD                           = 9030,      -- boss血量数据同步
	PROTO_WORLD_BOSS_KILL                            = 9040,      -- boss被击杀
	PROTO_WORLD_BOSS_ADD_BUFF                        = 9050,      -- 鼓舞士气
	PROTO_WORLD_BOSS_ROLE_ATTR                       = 9060,      -- 玩家战斗数据
	PROTO_WORLD_BOSS_BOSS_ATTR                       = 9070,      -- boss数据
	PROTO_WORLD_BOSS_HARM_REQ                        = 9080,      -- 请求界面伤害统计
	PROTO_WORLD_BOSS_HARM_DATA                       = 9082,      -- 界面伤害统计返回
	PROTO_WORLD_BOSS_HARM_REAL_TIME                  = 9090,      -- 实时伤害排行数据

	-- 竞技场
	PROTO_WAR_GET_WAR_DATA                           = 9501,      -- 获取竞技场数据
	PROTO_WAR_RETURN_WAR_DATA                        = 9502,      -- 返回竞技场数据
	PROTO_WAR_RETURN_CHALLENGE_MSG                   = 9506,      -- 返回挑战信息
	PROTO_WAR_RESULT                                 = 9510,      -- 结束
	PROTO_WAR_PK_RESULT                              = 9511,      -- 擂台战结束
	PROTO_WAR_RETURN_RESULT                          = 9512,      -- 返回结束
	PROTO_WAR_RETURN_PK_RESULT                       = 9513,      -- 擂台战返回结束
	PROTO_WAR_RETURN_PK_RESULT_OFFLINE               = 9514,      -- 擂台战返回结束(掉线)
	PROTO_WAR_GET_RANKINGLIST                        = 9515,      -- 获取竞技场排行榜
	PROTO_WAR_RETURN_RANKINGLIST                     = 9518,      -- 返回竞技场排行榜
	PROTO_WAR_BUY                                    = 9520,      -- 竞技场购买次数
	PROTO_WAR_PK_DATA_SELF_REQ                       = 9550,      -- 请求自身擂台战数据
	PROTO_WAR_PK_DATA_SELF_BACK                      = 9552,      -- 自身擂台数据返回
	PROTO_WAR_PK_MATCH                               = 9600,      -- 开始匹配(擂台战)
	PROTO_WAR_PK_MATCH_RESULT                        = 9602,      -- 匹配结果
	PROTO_WAR_PK_MATCH_CANCEL                        = 9604,      -- 取消匹配
	PROTO_WAR_PK_MATCH_CANCEL_OK                     = 9606,      -- 取消匹配成功
	PROTO_WAR_PK_MATCH_COUNT_BUY                     = 9610,      -- 购买擂台战匹配次数
	PROTO_WAR_PK_MATCH_COUNT_DATA                    = 9612,      -- 购买擂台战匹配次数结果
	PROTO_WAR_PK_BUY_COST_REQ                        = 9614,      -- 请求购买擂台战次数消耗
	PROTO_WAR_PK_BUY_COST_DATA                       = 9616,      -- 购买擂台战次数消耗元宝
	PROTO_WAR_PK_BEHAVIOUR                           = 9620,      -- 玩家行为数据
	PROTO_WAR_PK_BEHAVIOUR_BROADCAST                 = 9622,      -- 玩家行为广播数据
	PROTO_WAR_PK_LOAD_COMPLETE                       = 9630,      -- 擂台战加载完毕
	PROTO_WAR_PK_ALL_START                           = 9632,      -- 擂台战开始

	-- 招财
	PROTO_LUCKY_LOGIN_MSG                            = 10001,     -- 招财登陆下发
	PROTO_LUCKY_LUCKY                                = 10005,     -- 招财
	PROTO_LUCKY_RETURN_LUCKY                         = 10010,     -- 返回招财
	PROTO_LUCKY_LUCKY_BOX                            = 10015,     -- 招财宝箱
	PROTO_LUCKY_RETURN_LUCKY_BOX                     = 10020,     -- 返回招财宝箱

	-- 蟠桃
	PROTO_PEENTO_LOGIN_MSG                           = 10501,     -- 蟠桃登陆下发
	PROTO_PEENTO_PLUCKER                             = 10505,     -- 摘取蟠桃
	PROTO_PEENTO_RIPENER                             = 10510,     -- 催熟蟠桃
	PROTO_PEENTO_MOP_UP                              = 10515,     -- 扫荡
	PROTO_PEENTO_RETURN_MOP_UP                       = 10520,     -- 扫荡返回
	PROTO_PEENTO_GET                                 = 10525,     -- 领取扫荡奖励
	PROTO_PEENTO_ELITE_MOP_UP                        = 10530,     -- 精英本扫荡
	PROTO_PEENTO_RETURN_ELITE_MOP_UP                 = 10535,     -- 精英本扫荡返回

	-- 活动
	PROTO_ACTIVITY_LOGIN_MSG                         = 11001,     -- 登陆下发活动类型
	PROTO_ACTIVITY_GET_ACTIVITY                      = 11005,     -- 请求活动
	PROTO_ACTIVITY_RETURN_ACTIVITY                   = 11006,     -- 返回活动列表
	PROTO_ACTIVITY_GET_REWARD                        = 11010,     -- 获取奖励
	PROTO_ACTIVITY_RETURN_ACTIVITY_STATE             = 11012,     -- 返回奖励状态
	PROTO_ACTIVITY_EXCHANGE                          = 11015,     -- 兑换礼品
	PROTO_ACTIVITY_RETURN_EXCHANGE_AWARD             = 11016,     -- 返回兑换礼品奖励
	PROTO_ACTIVITY_TREASURE_CIRCLE_REQ               = 11100,     -- 请求秘宝转盘数据
	PROTO_ACTIVITY_TREASURE_CIRCLE_DATA              = 11102,     -- 秘宝转盘数据
	PROTO_ACTIVITY_TREASURE_RECORD_REQ               = 11104,     -- 请求秘宝幸运榜数据
	PROTO_ACTIVITY_TREASURE_RECORD_DATA              = 11106,     -- 秘宝获得记录数据
	PROTO_ACTIVITY_TREASURE_REQ                      = 11110,     -- 秘宝抽奖
	PROTO_ACTIVITY_TREASURE_RESULT                   = 11112,     -- 秘宝抽奖结果
	PROTO_ACTIVITY_TREASURE_FREE_COUNT               = 11114,     -- 秘宝免费次数

	-- 爬塔
	PROTO_CLIMBING_TOWER_CREATE_TEAM                 = 11501,     -- 创建队伍
	PROTO_CLIMBING_TOWER_TEAM                        = 11502,     -- 队伍数据
	PROTO_CLIMBING_TOWER_JOIN_TEAM                   = 11505,     -- 加入队伍
	PROTO_CLIMBING_TOWER_NEW_JOIN_TEAM               = 11506,     -- 新加入队伍
	PROTO_CLIMBING_TOWER_EXIT_TEAM                   = 11510,     -- 退出队伍
	PROTO_CLIMBING_TOWER_MEMBER_EXIT                 = 11511,     -- 队伍退出
	PROTO_CLIMBING_TOWER_RECRUITING_TEAM             = 11515,     -- 队伍招募
	PROTO_CLIMBING_TOWER_PREPARE                     = 11520,     -- 爬塔准备
	PROTO_CLIMBING_TOWER_RETURN_PREPARE              = 11525,     -- 返回准备状态
	PROTO_CLIMBING_TOWER_START_WAR                   = 11600,     -- 队长开始战斗仙门boss
	PROTO_CLIMBING_TOWER_ENTER_DATA                  = 11610,     -- 进入仙门boss场景数据
	PROTO_CLIMBING_TOWER_HARM_BOSS                   = 11620,     -- 玩家对boss造成伤害
	PROTO_CLIMBING_TOWER_BOSS_HP                     = 11630,     -- boss血量数据同步
	PROTO_CLIMBING_TOWER_KILL_BOSS                   = 11640,     -- boss被击杀
	PROTO_CLIMBING_TOWER_REWARD                      = 11650,     -- 击杀仙门boss奖励
	PROTO_CLIMBING_TOWER_START_COPY                  = 11655,     -- 开始爬塔副本
	PROTO_CLIMBING_TOWER_REVIVE                      = 11660,     -- 死亡复活
	PROTO_CLIMBING_TOWER_NEXT_VOTE                   = 11670,     -- 下一层表决
	PROTO_CLIMBING_TOWER_GET_START_WAR               = 11675,     -- 获取仙门boss场景数据

	-- 仙域争霸
	PROTO_SOCIATY_WAR_REGION_REQ                     = 12020,     -- 请求进入仙域争霸
	PROTO_SOCIATY_WAR_REGION_DATA                    = 12022,     -- 进入仙域争霸数据
	PROTO_SOCIATY_WAR_POSITION_DATA                  = 12024,     -- 仙域争霸坐标数据
	PROTO_SOCIATY_WAR_ROLE_UPDATE                    = 12026,     -- 玩家状态变化通知
	PROTO_SOCIATY_WAR_POSITION_UPDATE                = 12028,     -- 坐标点状态变化通知
	PROTO_SOCIATY_WAR_WALK_DATA_BROADCAST            = 12030,     -- 玩家进入视野范围数据
	PROTO_SOCIATY_WAR_WALK                           = 12040,     -- 玩家行走
	PROTO_SOCIATY_WAR_WALK_DATA                      = 12042,     -- 玩家行走数据
	PROTO_SOCIATY_WAR_REQUEST_DATA                   = 12050,     -- 请求仙域争霸界面数据
	PROTO_SOCIATY_WAR_BASE_DATA                      = 12052,     -- 仙域争霸界面数据
	PROTO_SOCIATY_WAR_CELL_DATA_REQ                  = 12060,     -- 请求当前单元格资源数据
	PROTO_SOCIATY_WAR_CELL_DATA                      = 12062,     -- 探索资源数据
	PROTO_SOCIATY_WAR_CELL_WAR                       = 12064,     -- 请求探索
	PROTO_SOCIATY_WAR_CELL_WAR_DATA                  = 12066,     -- 探索战斗数据
	PROTO_SOCIATY_WAR_CELL_IS_WAR                    = 12067,     -- 是否进入战斗
	PROTO_SOCIATY_WAR_CELL_WAR_RESULT                = 12068,     -- 战斗结果
	PROTO_SOCIATY_WAR_EXIT                           = 12070,     -- 退出仙域
	PROTO_SOCIATY_WAR_EXIT_BROADCAST                 = 12072,     -- 玩家退出仙域
	PROTO_SOCIATY_WAR_RUN_OUT                        = 12080,     -- 逃离战斗
	PROTO_SOCIATY_WAR_RUN_OUT_DATA                   = 12082,     -- 逃离返回
	PROTO_SOCIATY_WAR_MATCH_PK_RIVAL                 = 12084,     -- 匹配到对战玩家
	PROTO_SOCIATY_WAR_PK_LOADING_DATA                = 12086,     -- 仙域争霸玩家对战加载数据
	PROTO_SOCIATY_WAR_DROP_BAG_REQ                   = 12090,     -- 请求掉落资源背包数据
	PROTO_SOCIATY_WAR_DROP_BAG_DATA                  = 12092,     -- 掉落资源背包数据返回
	PROTO_SOCIATY_WAR_DROP_BAG_NEW                   = 12094,     -- 资源背包新增
	PROTO_SOCIATY_WAR_DROP_BAG_GET                   = 12096,     -- 领取资源背包
	PROTO_SOCIATY_WAR_LOAD_OK                        = 12100,     -- 玩家加载完成
	PROTO_SOCIATY_WAR_LOAD_OK_NOTICE                 = 12102,     -- 双方加载完成
	PROTO_SOCIATY_WAR_DATA_ACTION                    = 12104,     -- pk同步数据
	PROTO_SOCIATY_WAR_DATA_ACTION_NOTICE             = 12106,     -- pk同步数据
	PROTO_SOCIATY_WAR_PK_RESULT                      = 12110,     -- pk战斗结果
	PROTO_SOCIATY_WAR_PK_RESULT_BACK                 = 12112,     -- pk战斗结果返回
	PROTO_SOCIATY_WAR_CELL_REWARD                    = 12120,     -- 无怪物探索领取
	PROTO_SOCIATY_WAR_CELL_REWARD_OK                 = 12122,     -- 无怪物领取成功
	PROTO_SOCIATY_WAR_CELL_ENTER_LOAD_OK             = 12124,     -- 进入仙域争霸加载完成
	PROTO_SOCIATY_WAR_PK_PRE_NOTICE                  = 12126,     -- 匹配到对手信息数据
	PROTO_SOCIATY_WAR_UNIT_HP_DATA                   = 12128,     -- 玩家战斗单元血量数据
	PROTO_SOCIATY_WAR_DROP_DATA                      = 12130,     -- 地图散落资源数据
	PROTO_SOCIATY_WAR_OFFLINE_NOTICE                 = 12132,     -- 玩家对战掉线通知
	PROTO_SOCIATY_WAR_CANCEL_PK                      = 12134,     -- 玩家取消对战(战斗前)
	PROTO_SOCIATY_WAR_CANCEL_PK_NOTICE               = 12136,     -- 玩家取消对战(战斗前)通知

}