-- 常量或枚举宏定义文件


DefineConst = {

	-- 角色相关
	CONST_ROLE_POWER_FACTOR_ATK                      = 1,         -- 计算战斗力攻击参数
	CONST_ROLE_POWER_FACTOR_DEF                      = 2,         -- 计算战斗力防御参数
	CONST_ROLE_POWER_FACTOR_HP                       = 0.2,       -- 计算战斗力气血参数
	CONST_ROLE_POWER_TO_ATK                          = 3,         -- 计算战斗力转攻击参数
	CONST_ROLE_POWER_TO_DEF                          = 6,         -- 计算战斗力转防御参数
	CONST_ROLE_POWER_TO_HP1                          = 6,         -- 计算战斗力转气血参数1
	CONST_ROLE_POWER_TO_HP2                          = 10,        -- 计算战斗力转气血参数2
	CONST_POSITIVE                                   = 0,         -- 正数
	CONST_NEGATIVE                                   = 1,         -- 负数

	-- 服务器状态
	CONST_SERV_STATE_MAINTAIN                        = 0,         -- 服务器状态--维护
	CONST_SERV_STATE_NORMAL                          = 1,         -- 服务器状态--正常
	CONST_SERV_STATE_HOT                             = 2,         -- 服务器状态--火爆
	CONST_SERV_STATE_CROWD                           = 3,         -- 服务器状态--拥挤
	CONST_SERV_STATE_COUNT_HOT                       = 500,       -- 服务器状态人数上限--火爆
	CONST_SERV_STATE_COUNT_CROWD                     = 2000,      -- 服务器状态人数上限--拥挤

	-- 全局状态定义
	CONST_STATE_TYPE_WORLD_BOSS                      = 1,         -- 状态类型--世界boss
	CONST_STATE_TYPE_SOCIATY_WAR                     = 2,         -- 状态类型--仙域争霸
	CONST_STATE_VALUE_COMMON_END                     = 0,         -- 状态值--通用--关闭
	CONST_STATE_VALUE_COMMON_START                   = 1,         -- 状态值--通用--开启
	CONST_STATE_VALUE_WORLD_BOSS_END                 = 0,         -- 状态值--世界boss--关闭
	CONST_STATE_VALUE_WORLD_BOSS_START               = 1,         -- 状态值--世界boss--开启
	CONST_STATE_VALUE_WORLD_BOSS_WAR                 = 2,         -- 状态值--世界boss--战斗

	-- 货币类型
	CONST_CURRENCY_GOLD                              = 1,         -- 货币类型--金币
	CONST_CURRENCY_RMB                               = 2,         -- 货币类型--元宝
	CONST_CURRENCY_POINT                             = 3,         -- 货币类型--点券
	CONST_CURRENCY_RENOWN                            = 4,         -- 货币类型--声望
	CONST_CURRENCY_ANIMA                             = 5,         -- 货币类型--灵力
	CONST_CURRENCY_SOUL                              = 6,         -- 货币类型--斗魂
	CONST_CURRENCY_FLOWER                            = 7,         -- 货币类型--鲜花
	CONST_CURRENCY_EXP                               = 8,         -- 货币类型--经验
	CONST_FIELD_UNAME                                = 9,         -- 属性字段类型--名字
	CONST_FIELD_LV                                   = 10,        -- 属性字段类型--等级
	CONST_FIELD_PRO                                  = 11,        -- 属性字段类型--职业
	CONST_FIELD_HP                                   = 12,        -- 属性字段类型--HP
	CONST_FIELD_MP                                   = 13,        -- 属性字段类型--MP
	CONST_FIELD_ATTACK                               = 14,        -- 属性字段类型--攻击
	CONST_FIELD_DEFEND                               = 15,        -- 属性字段类型--防御
	CONST_FIELD_CRIT                                 = 16,        -- 属性字段类型--暴击
	CONST_FIELD_CRIT_ODDS                            = 17,        -- 属性字段类型--暴击几率
	CONST_FIELD_SPEED                                = 18,        -- 属性字段类型--速度
	CONST_CURRENCY_SPIRIT                            = 19,        -- 货币类型--精魄
	CONST_FIELD_POWER                                = 20,        -- 属性字段类型--战斗力
	CONST_FIELD_EXPN                                 = 21,        -- 属性字段类型--当前升级所需要的经验值
	CONST_CURRENCY_AMULET                            = 22,        -- 货币类型--护符
	CONST_FIELD_MONEYCOUNT                           = 23,        -- 属性字段类型--财神宝库次数
	CONST_CURRENCY_PHYSICAL                          = 24,        -- 货币类型--体力
	CONST_FIELD_PHYSICALBUY                          = 25,        -- 属性字段类型--购买体力次数
	CONST_FIELD_TRAINEXP_COUNT                       = 26,        -- 属性字段类型--经验试练塔次数
	CONST_FIELD_TRAINFLOWER_COUNT                    = 27,        -- 属性字段类型--鲜花试练塔次数
	CONST_FIELD_TRAINRENOWN_COUNT                    = 28,        -- 属性字段类型--声望试练塔次数
	CONST_FIELD_EXPLORE                              = 29,        -- 属性字段类型--器灵副本免费次数
	CONST_FIELD_WAR_COUNT                            = 30,        -- 属性字段类型--竞技场进入次数
	CONST_FIELD_GODREFRESH                           = 31,        -- 属性字段类型--神将副本刷新次数
	CONST_CURRENCY_GODPHYSICAL                       = 32,        -- 属性字段类型--神将副本体力
	CONST_FIELD_GODDIFFICULTY                        = 33,        -- 属性字段类型--神将副本难度
	CONST_FIELD_GODMONSTERGROUP                      = 34,        -- 属性字段类型--神将副本怪物组
	CONST_FIELD_MONEYLAYER                           = 35,        -- 属性字段类型--财神宝库层数
	CONST_FIELD_GODPHYSICALBUY                       = 36,        -- 属性字段类型--神将副本体力购买次数
	CONST_FIELD_WAR_BUY                              = 37,        -- 属性字段类型--竞技场购买次数
	CONST_FIELD_CLIMBINGTOWERCOUNT                   = 38,        -- 属性字段类型--爬塔次数
	CONST_FIELD_CLIMBINGTOWERLAYER                   = 39,        -- 属性字段类型--爬塔层数
	CONST_FIELD_LIVELY                               = 40,        -- 属性字段类型--活跃度

	-- Buff类型
	CONST_BUFF_ATK                                   = 1,         -- Buff类型--攻击
	CONST_BUFF_DEF                                   = 2,         -- Buff类型--防御
	CONST_BUFF_HP                                    = 3,         -- Buff类型--气血
	CONST_BUFF_MP                                    = 4,         -- Buff类型--法力
	CONST_BUFF_CRIT_ODDS                             = 5,         -- Buff类型--暴击几率
	CONST_BUFF_CRIT                                  = 6,         -- Buff类型--暴伤
	CONST_BUFF_SPEED                                 = 7,         -- Buff类型--移动速度

	-- 创建角色类型
	CONST_ROLE_COUNT_MAX                             = 4,         -- 拥有角色数量上限

	-- 元神系统
	CONST_YUAN_GOD_PRACTICE_ONE                      = 1,         -- 元神单次修炼
	CONST_YUAN_GOD_PRACTICE_TEN                      = 10,        -- 元神修炼10次
	CONST_YUAN_GOD_SPALLATION                        = 2,         -- 元神蜕变
	CONST_YUAN_GOD_INIT_LV                           = 1,         -- 元神初始等级
	CONST_YUAN_GOD_MAX_LV                            = 100,       -- 元神满级等级
	CONST_YUAN_GOD_MAGICITEM_INIT_STAR               = 1,         -- 元神法器初始星数
	CONST_YUAN_GOD_MAGICITEM_MAX_STAR                = 9,         -- 元神法器满级星数
	CONST_YUAN_GOD_UNLOCK                            = 1,         -- 元神法器解锁
	CONST_YUAN_GOD_LOCK                              = 0,         -- 元神法器锁定
	CONST_YUAN_GOD_INITID                            = 1,         -- 元神法器初始id
	CONST_YUAN_GOD_A_COMPOUND_STONE                  = 0,         -- 单个合成
	CONST_YUAN_GOD_MORE_COMPOUND_STONE               = 1,         -- 多个合成

	-- 容器类型
	CONST_CONTAINER_TYPE_BAG                         = 1,         -- 容器类型--背包
	CONST_CONTAINER_TYPE_EQUIP                       = 2,         -- 容器类型--装备栏
	CONST_CONTAINER_TYPE_MAGICSOUL                   = 3,         -- 容器类型--器灵
	CONST_MAGIC_TYPESUB_PRACTICE_MATERIAL            = 1,         -- 法器子类型--法器进阶材料
	CONST_MAGIC_TYPESUB_SKILL_MATERIAL               = 2,         -- 法器子类型--法器技能升级材料

	-- 物品大类
	CONST_GOODS_TYPE_EQUIP                           = 1,         -- 物品大类--装备
	CONST_GOODS_TYPE_CHIP                            = 2,         -- 物品大类--碎片
	CONST_GOODS_TYPE_MAGICSOUL                       = 3,         -- 物品大类--器灵
	CONST_GOODS_TYPE_MAGIC                           = 4,         -- 物品大类--法器

	-- 装备类型
	CONST_EQUIP_TYPESUB_WEAPON                       = 1,         -- 装备类型--武器
	CONST_EQUIP_TYPESUB_RING                         = 2,         -- 装备类型--戒指
	CONST_EQUIP_TYPESUB_HELMET                       = 3,         -- 装备类型--头盔
	CONST_EQUIP_TYPESUB_NECKLACE                     = 4,         -- 装备类型--项链
	CONST_EQUIP_TYPESUB_CLOTHES                      = 5,         -- 装备类型--衣服
	CONST_EQUIP_TYPESUB_SHOE                         = 6,         -- 装备类型--鞋子
	CONST_EQUIP_TYPESUB_MAGICSOUL                    = 9,         -- 装备类型--器灵

	-- 装备吞噬
	CONST_EQUIP_EAT_MAX                              = 8,         -- 单次吞噬装备最大数量

	-- 物品品质
	CONST_EQUIP_QUALITY_WHITE                        = 1,         -- 品阶--白
	CONST_EQUIP_QUALITY_GREEN                        = 2,         -- 品阶--绿
	CONST_EQUIP_QUALITY_BLUE                         = 3,         -- 品阶--蓝
	CONST_EQUIP_QUALITY_PURPLE                       = 4,         -- 品阶--紫
	CONST_EQUIP_QUALITY_GOLDEN                       = 5,         -- 品阶--金

	-- 属性类型
	CONST_ATTR_TYPE_HP                               = 1,         -- 属性类型--HP
	CONST_ATTR_TYPE_MP                               = 2,         -- 属性类型--MP
	CONST_ATTR_TYPE_ATTACK                           = 3,         -- 属性类型--攻击
	CONST_ATTR_TYPE_DEFEND                           = 4,         -- 属性类型--防御
	CONST_ATTR_TYPE_CRIT                             = 5,         -- 属性类型--暴击
	CONST_ATTR_TYPE_ODDS                             = 6,         -- 属性类型--暴击几率
	CONST_ATTR_TYPE_SPEED                            = 7,         -- 属性类型--速度

	-- 强化等级上限
	CONST_QUALITY_BLUE_STRENGTHENLV                  = 5,         -- 品阶--蓝强化等级上限
	CONST_QUALITY_PURPLE_STRENGTHENLV                = 10,        -- 品阶--紫强化等级上限
	CONST_QUALITY_GOLDEN_STRENGTHENLV                = 15,        -- 品阶--金强化等级上限

	-- 任务时间
	CONST_TASK_TIME_MONDAY                           = 1,         -- 任务时间星期一
	CONST_TASK_TIME_TUESDAY                          = 2,         -- 任务时间星期二
	CONST_TASK_TIME_WEDNESDAY                        = 3,         -- 任务时间星期三
	CONST_TASK_TIME_THURSDAY                         = 4,         -- 任务时间星期四
	CONST_TASK_TIME_FRIDAY                           = 5,         -- 任务时间星期五
	CONST_TASK_TIME_SATRDAY                          = 6,         -- 任务时间星期六
	CONST_TASK_TIME_SUNDAY                           = 7,         -- 任务时间星期七

	-- 任务类型
	CONST_TASK_TYPE_LOGIN                            = 1,         -- 任务类型登陆任务
	CONST_TASK_TYPE_DAIRY                            = 2,         -- 任务类型每日任务
	CONST_TASK_TYPE_GROWUP                           = 3,         -- 任务类型成长任务
	CONST_TASK_TYPE_WANTED                           = 4,         -- 任务类型奖励任务
	CONST_TASK_TYPE_NEW                              = 5,         -- 任务类型新任务
	CONST_TASK_TYPE_ATTENDANCE_BONUS                 = 6,         -- 任务类型全勤任务

	-- 支线剧情任务
	CONST_TASK_TYPE_BRANCH                           = 0,         -- 任务类型分支任务
	CONST_TASK_TYPE_STORY                            = 1,         -- 任务类型剧情任务

	-- 任务状态
	CONST_TASK_STATE_UNFINISHED                      = 0,         -- 任务状态未完成
	CONST_TASK_STATE_REWARDS                         = 1,         -- 任务状态领取奖励
	CONST_TASK_STATE_FINISH                          = 2,         -- 任务状态已完成

	-- 任务条件
	CONST_TASK_CONDITION_TIME                        = 1,         -- 任务条件类型时间
	CONST_TASK_CONDITION_VIPLV                       = 2,         -- 任务条件类型vip等级
	CONST_TASK_CONDITION_RANKING                     = 3,         -- 任务条件类型演武场排名
	CONST_TASK_CONDITION_MAINTAIN                    = 4,         -- 任务条件类型维护
	CONST_TASK_CONDITION_NEWSERVER                   = 5,         -- 任务条件类型新服
	CONST_TASK_CONDITION_MONTHCARD                   = 6,         -- 任务条件类型月卡
	CONST_TASK_CONDITION_ROLELV                      = 7,         -- 任务条件类型角色等级
	CONST_TASK_CONDITION_DUPLICATE                   = 8,         -- 任务条件类型副本
	CONST_TASK_CONDITION_YUANGODLV                   = 9,         -- 任务条件类型元神等级
	CONST_TASK_CONDITION_FAIRY                       = 10,        -- 任务条件类型仙女
	CONST_TASK_CONDITION_GODWILL                     = 11,        -- 任务条件类型神将
	CONST_TASK_CONDITION_MOPUP                       = 12,        -- 任务条件类型扫荡
	CONST_TASK_CONDITION_LUCKY                       = 13,        -- 任务条件类型招财
	CONST_TASK_CONDITION_BUYTILI                     = 14,        -- 任务条件类型购买体力
	CONST_TASK_CONDITION_CURRENCY_GOLD               = 15,        -- 任务条件类型货币金币
	CONST_TASK_CONDITION_CURRENCY_RENOWN             = 16,        -- 任务条件类型货币声望
	CONST_TASK_CONDITION_RECHARGE                    = 17,        -- 任务条件类型充值
	CONST_TASK_CONDITION_SKILL_UNLOCK                = 18,        -- 任务条件类型技能解锁
	CONST_TASK_CONDITION_SKILL_CHAIM                 = 19,        -- 任务条件类型技能链
	CONST_TASK_CONDITION_EQUIP_EQUIP                 = 20,        -- 任务条件类型装备上的装备
	CONST_TASK_CONDITION_EQUIP_INTENSIFY             = 21,        -- 任务条件类型装备强化
	CONST_TASK_CONDITION_MAGICITEM_UNLOCK            = 22,        -- 任务条件类型法器解锁
	CONST_TASK_CONDITION_MAGICITEM_SKILL_LV          = 23,        -- 任务条件类型法器技能等级
	CONST_TASK_CONDITION_YUANGOD_PRACTICE            = 24,        -- 任务条件类型元神修炼
	CONST_TASK_CONDITION_MAGICSOUL_EQUIP             = 25,        -- 任务条件类型器灵装备
	CONST_TASK_CONDITION_MAGICSOUL_INTENSIFY         = 26,        -- 任务条件类型器灵强化
	CONST_TASK_CONDITION_MAGICSOUL_COPY_NORMAL       = 27,        -- 任务条件类型器灵普通探索
	CONST_TASK_CONDITION_MAGICSOUL_COPY_FAST         = 28,        -- 任务条件类型器灵快速探索
	CONST_TASK_CONDITION_FAIRY_INTENSIFY             = 29,        -- 任务条件类型仙女强化
	CONST_TASK_CONDITION_GODWILL_SYNTH               = 30,        -- 任务条件类型神将合成
	CONST_TASK_CONDITION_GODWILL_REFRESH             = 31,        -- 任务条件类型神将刷新
	CONST_TASK_CONDITION_WAR_COUNT                   = 32,        -- 任务条件类型竞技次数
	CONST_TASK_CONDITION_NEW_MODULE_OPEN             = 33,        -- 任务条件类型新功能开启
	CONST_TASK_CONDITION_OPERATOR_DUPLICATE          = 34,        -- 任务条件类型运营通关副本
	CONST_TASK_CONDITION_OPERATOR_TIME               = 35,        -- 任务条件类型运营时间
	CONST_TASK_CONDITION_OPERATOR_LV                 = 36,        -- 任务条件类型运营等级
	CONST_TASK_CONDITION_OPERATOR_SKILL_UNLOCK       = 37,        -- 任务条件类型运营技能解锁
	CONST_TASK_CONDITION_OPERATOR_EQUIP_EQUIP        = 38,        -- 任务条件类型运营装备上的装备
	CONST_TASK_CONDITION_OPERATOR_MAGICSOUL_EQUIP    = 39,        -- 任务条件类型运营器灵装备
	CONST_TASK_CONDITION_OPERATOR_FAIRY              = 40,        -- 任务条件类型运营仙女
	CONST_TASK_CONDITION_WORLDBOSS                   = 41,        -- 任务条件类型时间BOSS
	CONST_TASK_CONDITION_WAR_EVERYDAY_REWARD         = 42,        -- 任务条件类型竞技场每日奖励
	CONST_TASK_CONDITION_GODWILL_COPY                = 43,        -- 任务条件类型挑战神将副本
	CONST_TASK_CONDITION_WAR_PK                      = 44,        -- 任务条件类型擂台战
	CONST_TASK_CONDITION_GODWILL_SYNTH_COUNT         = 45,        -- 任务条件类型封神台吸魂次数

	-- 仙女系统
	CONST_FAIRY_INIT_LV                              = 0,         -- 仙女初始等级

	-- 仙女洞府
	CONST_FAIRY_HOTEL_TYPE_NORMAL                    = 1,         -- 仙女洞府类型--普通洞府
	CONST_FAIRY_HOTEL_TYPE_MEDIUM                    = 2,         -- 仙女洞府类型--中级洞府
	CONST_FAIRY_HOTEL_TYPE_LUXURY                    = 3,         -- 仙女洞府类型--豪华洞府

	-- 仙女疲劳
	CONST_FAIRY_UPDATE_END                           = 0,         -- 仙女疲劳更新类型0
	CONST_FAIRY_UPDATE_NOT_STARTED                   = 1,         -- 仙女疲劳更新类型1
	CONST_FAIRY_UPDATE_ING                           = 2,         -- 仙女疲劳更新类型2

	-- 技能系统
	CONST_SKILL_BAG_IDX_MAX                          = 8,         -- 技能链容量
	CONST_SKILL_BAG_MAX                              = 3,         -- 技能链数量

	-- 技能解锁
	CONST_SKILL_IS_UNLOCK                            = 1,         -- 技能已解锁
	CONST_SKILL_NOUNLOCK                             = 0,         -- 技能未解锁

	-- vip系统
	CONST_VIP_PRIVILEGE_TYPE_GROUNDS_EXP_ADD         = 1,         -- vip特权类型--试炼场试炼经验加成
	CONST_VIP_PRIVILEGE_TYPE_MONEY_GOLD_ADD          = 2,         -- vip特权类型--财神宝库铜钱加成
	CONST_VIP_PRIVILEGE_TYPE_GROUNDS_FLOWER_ADD      = 3,         -- vip特权类型--试练塔鲜花加成
	CONST_VIP_PRIVILEGE_TYPE_GROUNDS_RENOWN_ADD      = 4,         -- vip特权类型--试练塔声望加成
	CONST_VIP_PRIVILEGE_TYPE_YUANGOD_ADD             = 5,         -- vip特权类型--元神修炼加成
	CONST_VIP_PRIVILEGE_TYPE_GROUNDS_EXP_TURNOVER    = 6,         -- vip特权类型--试练塔经验翻牌次数加成
	CONST_VIP_PRIVILEGE_TYPE_GROUNDS_FLOWER_TURNOVER = 7,         -- vip特权类型--试练塔鲜花翻牌次数加成
	CONST_VIP_PRIVILEGE_TYPE_GROUNDS_RENOWN_TURNOVER = 8,         -- vip特权类型--试练塔声望翻牌次数加成
	CONST_VIP_PRIVILEGE_TYPE_MONEY_TURNOVER          = 9,         -- vip特权类型--财神宝库翻牌
	CONST_VIP_PRIVILEGE_TYPE_TILI_BUY                = 10,        -- vip特权类型--体力
	CONST_VIP_PRIVILEGE_TYPE_PEENTO_BUY              = 11,        -- vip特权类型--蟠桃购买
	CONST_VIP_PRIVILEGE_TYPE_LUCKY_ADD               = 12,        -- vip特权类型--招财次数增加
	CONST_VIP_PRIVILEGE_TYPE_OPEN_TEN_LUCKY          = 13,        -- vip特权类型--开启十次招财
	CONST_VIP_PRIVILEGE_TYPE_WAR_BUY                 = 14,        -- vip特权类型--演武场购买战斗次数
	CONST_VIP_PRIVILEGE_TYPE_WAR_FIGHT_COUNT         = 15,        -- vip特权类型--演武场额外挑战
	CONST_VIP_PRIVILEGE_TYPE_OPEN_WAR_BUY            = 16,        -- vip特权类型--开放演武场购买
	CONST_VIP_PRIVILEGE_TYPE_FAIRY_RMB_YAPYUM        = 17,        -- vip特权类型--仙女元宝双修
	CONST_VIP_PRIVILEGE_TYPE_FAST_MAGICSOUL_COPY     = 18,        -- vip特权类型--器灵副本快速探索
	CONST_VIP_PRIVILEGE_TYPE_OPEN_SOCIATY            = 19,        -- vip特权类型--开放仙门
	CONST_VIP_PRIVILEGE_TYPE_KILL_DEVIL_AUTO_REVIVE  = 20,        -- vip特权类型--讨伐魔头自动复活
	CONST_VIP_PRIVILEGE_TYPE_KILL_DEVIL_ON_HOOK      = 21,        -- vip特权类型--讨伐魔头挂机
	CONST_VIP_PRIVILEGE_TYPE_KILL_DEVIL_INSPIRE      = 22,        -- vip特权类型--讨伐魔头鼓舞
	CONST_VIP_PRIVILEGE_TYPE_GIVE_GOODS              = 23,        -- vip特权类型--赠送道具
	CONST_VIP_PRIVILEGE_TYPE_GODCHIP_GOLD_EXCHANGE   = 24,        -- vip特权类型--神将金色碎片兑换
	CONST_VIP_PRIVILEGE_TYPE_GODCHIP                 = 25,        -- vip特权类型--神将碎片
	CONST_VIP_PRIVILEGE_TYPE_YUANLI                  = 26,        -- vip特权类型--原力
	CONST_VIP_PRIVILEGE_TYPE_WAR_BUY_PK              = 27,        -- vip特权类型--擂台战次数购买
	CONST_VIP_PRIVILEGE_TYPE_WAR_PK_OPEN             = 28,        -- vip特权类型--开放擂台战
	CONST_VIP_PRIVILEGE_TYPE_MAGICSOUL_COPY_OPEN     = 29,        -- vip特权类型--开放器灵扫荡
	CONST_VIP_PRIVILEGE_TYPE_MAGICSOUL_COPY_COUNT    = 30,        -- vip特权类型--器灵扫荡次数

	-- vip更新类型
	CONST_VIP_PRIVILEGE_UPDATETYPE_UPGRADE           = 1,         -- vip更新类型--升级
	CONST_VIP_PRIVILEGE_UPDATETYPE_DAIRY             = 2,         -- vip更新类型--每日

	-- 开启与关闭
	CONST_OPEN                                       = 1,         -- 开启
	CONST_CLOSE                                      = 0,         -- 关闭

	-- 神将系统
	CONST_GOODS_TYPE_GODWILL                         = 2,         -- 物品类型--神将

	-- 神将类型
	CONST_GODWILL_TYPE_GODWILL                       = 1,         -- 神将类型--神将
	CONST_GODWILL_TYPE_CHIP                          = 2,         -- 神将类型--碎片

	-- 神将星数等级
	CONST_GODWILL_INIT_STAR                          = 1,         -- 神将初始星数等级
	CONST_GODWILL_MAX_STAR                           = 5,         -- 神将满级星数等级

	-- 神将品阶
	CONST_GODWILL_QUALITY_BLUE                       = 3,         -- 品阶--蓝
	CONST_GODWILL_QUALITY_PURPLE                     = 4,         -- 品阶--紫
	CONST_GODWILL_QUALITY_GOLDEN                     = 5,         -- 品阶--金

	-- 神将出战
	CONST_IS_FIGHT                                   = 1,         -- 有出战
	CONST_NOT_FIGHT                                  = 0,         -- 没有出战

	-- 封神台等级
	CONST_GODTAI_INIT_LV                             = 1,         -- 封神台初始等级
	CONST_GODTAI_MAX_LV                              = 100,       -- 封神台满级等级

	-- 好友系统
	CONST_FRIEND_COUNT_MAX                           = 30,        -- 好友数量上限
	CONST_FRIEND_GIFT_STRENGTH                       = 5,         -- 默认赠送的体力

	-- 聊天系统
	CONST_CHAT_CHANNEL_WORLD                         = 1,         -- 聊天频道--世界
	CONST_CHAT_CHANNEL_SOCIATY                       = 2,         -- 聊天频道--仙门
	CONST_CHAT_CHANNEL_PRIVATE                       = 3,         -- 聊天频道--私人
	CONST_CHAT_CHANNEL_GROUP                         = 4,         -- 聊天频道--组队
	CONST_CHAT_CHANNEL_SYSTEM                        = 5,         -- 聊天频道--系统
	CONST_CHAT_CHANNEL_RECRUIT                       = 6,         -- 聊天频道--招募仙门
	CONST_CHAT_CHANNEL_RECRUITING_TEAM               = 7,         -- 聊天频道--招募组队

	-- 聊天类型
	CONST_CHAT_CHANNEL_TYPE_CHAT                     = 1,         -- 聊天类型--聊天
	CONST_CHAT_CHANNEL_TYPE_RECRUIT                  = 2,         -- 聊天类型--招募

	-- 限制发言
	CONST_CHAT_WORLD_LIMIT_TIME                      = 10,        -- 世界聊天--限制发言(秒)

	-- 怪物
	CONST_MONSTER_TYPE_NORMAL                        = 1,         -- 怪物类型--小怪
	CONST_MONSTER_TYPE_BOSS                          = 2,         -- 怪物类型--boss
	CONST_MONSTER_BASE_TYPE_ATK                      = 1,         -- 怪物基础类型--攻击型
	CONST_MONSTER_BASE_TYPE_DEF                      = 2,         -- 怪物基础类型--防御型
	CONST_MONSTER_BASE_TYPE_BOSS                     = 3,         -- 怪物基础类型--BOSS型

	-- 器灵副本
	CONST_MAGICSOUL_COPY_NORMAL_NUM                  = 6,         -- 器灵副本--普通探索次数
	CONST_MAGICSOUL_COPY_FAST_NUM                    = 2,         -- 器灵副本--快速探索次数

	-- 探索类型
	CONST_MAGICSOUL_COPY_TYPE_NORMAL                 = 1,         -- 器灵副本--普通探索
	CONST_MAGICSOUL_COPY_TYPE_FAST                   = 2,         -- 器灵副本--快速探索

	-- 最后副本
	CONST_MAGICSOUL_COPY_LAST_COPY                   = 1,         -- 器灵副本--最后副本

	-- 仙门
	CONST_SOCIATY_POSITION_MAINDOOR                  = 1,         -- 仙门职位--门主
	CONST_SOCIATY_POSITION_ELDER                     = 2,         -- 仙门职位--长老
	CONST_SOCIATY_POSITION_STARFLEX                  = 3,         -- 仙门职位--执事堂主
	CONST_SOCIATY_POSITION_MEMBER                    = 4,         -- 仙门职位--普通成员

	-- 仙门列表
	CONST_SOCIATY_PAGE_INIT_PAGE                     = 1,         -- 仙门列表--初始页数
	CONST_SOCIATY_PAGE_CUT_OUT                       = 5,         -- 仙门列表--截取数量

	-- 仙门自动加入
	CONST_SOCIATY_AUTOJOIN_TURE                      = 1,         -- 仙门自动加入--开启
	CONST_SOCIATY_AUTOJOIN_FALSE                     = 0,         -- 仙门自动加入--关闭

	-- 仙门消息类型
	CONST_SOCIATY_MSG_TYPE_UNKNOWN                   = 0,         -- 仙门消息类型--测试类型
	CONST_SOCIATY_MSG_TYPE_JOIN                      = 1,         -- 仙门消息类型--加入仙门
	CONST_SOCIATY_MSG_TYPE_EXIT                      = 2,         -- 仙门消息类型--退出仙门
	CONST_SOCIATY_MSG_TYPE_UPGRATE                   = 3,         -- 仙门消息类型--仙门升级
	CONST_SOCIATY_MSG_TYPE_APPOINT                   = 4,         -- 仙门消息类型--仙门任命

	-- 仙门处理类型
	CONST_SOCIATY_DISPOSE_TYPE_RATIFY                = 1,         -- 仙门处理类型--批准
	CONST_SOCIATY_DISPOSE_TYPE_REFUSE                = 0,         -- 仙门处理类型--拒绝

	-- 仙门执行类型
	CONST_SOCIATY_EXECUTE_TYPE_DISMISSSOCIATY        = 1,         -- 仙门执行类型--解散门派
	CONST_SOCIATY_EXECUTE_TYPE_TENET                 = 2,         -- 仙门执行类型--编辑宗旨
	CONST_SOCIATY_EXECUTE_TYPE_RECRUITNEWS           = 3,         -- 仙门执行类型--编辑招募
	CONST_SOCIATY_EXECUTE_TYPE_PERMITENTER           = 4,         -- 仙门执行类型--准许申请
	CONST_SOCIATY_EXECUTE_TYPE_DISMISSMEMBER         = 5,         -- 仙门执行类型--解雇成员
	CONST_SOCIATY_EXECUTE_TYPE_APPOINTJOB            = 6,         -- 仙门执行类型--任命职位

	-- 招财
	CONST_LUCKY_ONE_LUCKY                            = 0,         -- 单次招财
	CONST_LUCKY_TEN_LUCKY                            = 1,         -- 十次招财
	CONST_LUCKY_BOX_STATE_UNFINISHED                 = 0,         -- 宝箱状态未完成
	CONST_LUCKY_BOX_STATE_REWARDS                    = 1,         -- 宝箱状态领取奖励
	CONST_LUCKY_BOX_STATE_FINISH                     = 2,         -- 宝箱状态已完成

	-- 奖励
	CONST_AWARD_GOLD                                 = 1,         -- 奖励类型--金币
	CONST_AWARD_RMB                                  = 2,         -- 奖励类型--元宝
	CONST_AWARD_EXP                                  = 3,         -- 奖励类型--经验
	CONST_AWARD_RENOWN                               = 4,         -- 奖励类型--声望
	CONST_AWARD_ANIMA                                = 5,         -- 奖励类型--灵力
	CONST_AWARD_GOODS                                = 6,         -- 奖励类型--物品
	CONST_AWARD_AMULET                               = 7,         -- 奖励类型--护符
	CONST_AWARD_SOUL                                 = 8,         -- 奖励类型--斗魂
	CONST_AWARD_SPIRIT                               = 9,         -- 奖励类型--精魄
	CONST_AWARD_CHIP                                 = 10,        -- 奖励类型--碎片
	CONST_AWARD_FLOWER                               = 11,        -- 奖励类型--鲜花
	CONST_AWARD_POWER                                = 12,        -- 奖励类型--体力
	CONST_AWARD_THREE_YEAR_PEENTO                    = 13,        -- 奖励类型--三千年桃子
	CONST_AWARD_FIVE_YEAR_PEENTO                     = 14,        -- 奖励类型--五千年桃子
	CONST_AWARD_NINE_YEAR_PEENTO                     = 15,        -- 奖励类型--九千年桃子
	CONST_AWARD_QIAN_STONE                           = 16,        -- 奖励类型--乾石
	CONST_AWARD_KUN_STONE                            = 17,        -- 奖励类型--坤石
	CONST_AWARD_YUANLI                               = 18,        -- 奖励类型--元力
	CONST_AWARD_SOCIATY_EXP                          = 19,        -- 奖励类型--仙门经验
	CONST_AWARD_SOCIATY_CONTRIBUTION                 = 20,        -- 奖励类型--仙门贡献
	CONST_AWARD_SOCIATY_INTEGRAL                     = 21,        -- 奖励类型--仙门积分
	CONST_AWARD_RAND_EQUIP                           = 22,        -- 奖励类型--装备随机
	CONST_AWARD_RAND_MAGICSOUL                       = 23,        -- 奖励类型--器灵随机
	CONST_AWARD_RAND_GODCHIP                         = 24,        -- 奖励类型--神将碎片随机

	-- 游戏统计日志模块
	CONST_LOGS_MODULE_FAIRY                          = 1,         -- 统计模块类型--仙女
	CONST_LOGS_MODULE_GODW_WILL                      = 2,         -- 统计模块类型--神将
	CONST_LOGS_MODULE_SKILL                          = 3,         -- 统计模块类型--技能
	CONST_LOGS_MODULE_YUAN_GOD                       = 4,         -- 统计模块类型--元神
	CONST_LOGS_MODULE_OTHER                          = 5,         -- 统计模块类型--其他
	CONST_LOGS_MODULE_COPY                           = 6,         -- 统计模块类型--副本
	CONST_LOGS_MODULE_FRIEND                         = 7,         -- 统计模块类型--朋友
	CONST_LOGS_MODULE_MAGICSOUL                      = 8,         -- 统计模块类型--器灵
	CONST_LOGS_MODULE_RECHARGE                       = 9,         -- 统计模块类型--充值
	CONST_LOGS_MODULE_TASK                           = 10,        -- 统计模块类型--任务
	CONST_LOGS_MODULE_EQUIP                          = 11,        -- 统计模块类型--装备
	CONST_LOGS_MODULE_WAR                            = 12,        -- 统计模块类型--竞技场
	CONST_LOGS_MODULE_GM                             = 13,        -- 统计模块类型--后台GM修改
	CONST_LOGS_MODULE_LUCKY                          = 14,        -- 统计模块类型--招财
	CONST_LOGS_MODULE_PEENTO                         = 15,        -- 统计模块类型--蟠桃
	CONST_LOGS_MODULE_ACTIVITY                       = 16,        -- 统计模块类型--活动
	CONST_LOGS_MODULE_SOCIATY                        = 17,        -- 统计模块类型--仙门

	-- 游戏统计日志模块分类定义

	-- 统计日志模块--仙女
	CONST_LOGS_FUN_FAIRY_GIVE_FLOWER                 = 1,         -- 统计函数类型--仙女送花
	CONST_LOGS_FUN_FAIRY_YAP_YUM                     = 2,         -- 统计函数类型--仙女双修

	-- 统计日志模块--神将
	CONST_LOGS_FUN_GODW_WILL_CONVER_CHIP             = 1,         -- 统计函数类型--兑换碎片
	CONST_LOGS_FUN_GODW_WILL_SYNTH_GODWILL           = 2,         -- 统计函数类型--合成神将
	CONST_LOGS_FUN_GODW_WILL_GODWILL_UP_STAR         = 3,         -- 统计函数类型--神将升星
	CONST_LOGS_FUN_GODW_WILL_RESOLVE                 = 4,         -- 统计函数类型--神将/碎片单个分解
	CONST_LOGS_FUN_GODW_WILL_RESOLVE_MOVE            = 5,         -- 统计函数类型--神将/碎片多件分解
	CONST_LOGS_FUN_GODW_WILL_GODTAI_ERODE            = 6,         -- 统计函数类型--封神台吸魂

	-- 统计日志模块--元神
	CONST_LOGS_FUN_YUAN_GOD_MAGICITEM_UNLOCK         = 1,         -- 统计函数类型--法器解锁
	CONST_LOGS_FUN_YUAN_GOD_MAGICITEM_PRACTICE       = 2,         -- 统计函数类型--法器进阶
	CONST_LOGS_FUN_YUAN_GOD_SKILLSTONE_COMPOUND      = 3,         -- 统计函数类型--技能石一键合成
	CONST_LOGS_FUN_YUAN_GOD_SKILL_UPGRADE            = 4,         -- 统计函数类型--法器技能升级
	CONST_LOGS_FUN_YUAN_GOD_YUAN_GOD_PRACTICE        = 5,         -- 统计函数类型--元神修炼

	-- 统计日志模块--其他
	CONST_LOGS_FUN_OTHER_GM                          = 1,         -- 统计函数类型--GM命令
	CONST_LOGS_FUN_OTHER_SYSTEM_GIFT                 = 2,         -- 统计函数类型--系统赠送
	CONST_LOGS_FUN_OTHER_RENAME                      = 3,         -- 统计函数类型--改名
	CONST_LOGS_FUN_OTHER_GIFT_RECV                   = 1,         -- 统计函数类型--领取礼物
	CONST_LOGS_FUN_OTHER_GM_GIFT                     = 5,         -- 统计函数类型--gm赠送

	-- 统计日志模块--副本
	CONST_LOGS_FUN_COPY_WAR_OVER                     = 1,         -- 统计函数类型--副本结算
	CONST_LOGS_FUN_COPY_PICK_REWARD                  = 2,         -- 统计函数类型--拾取副本物品
	CONST_LOGS_FUN_COPY_MAGICSOUL_COPY_PICK_REWARD   = 3,         -- 统计函数类型--拾取器灵副本物品
	CONST_LOGS_FUN_COPY_MAGICSOUL_EXPLORE            = 4,         -- 统计函数类型--器灵探索
	CONST_LOGS_FUN_COPY_MONEY_TURNOVER               = 5,         -- 统计函数类型--翻牌
	CONST_LOGS_FUN_COPY_MONEY_COPY_WAR_OVER          = 6,         -- 统计函数类型--财神宝库通关
	CONST_LOGS_FUN_COPY_TRAIN_WAR_OVER               = 7,         -- 统计函数类型--试练塔通关
	CONST_LOGS_FUN_COPY_REFRESH_GODWILL              = 8,         -- 统计函数类型--刷新神将副本
	CONST_LOGS_FUN_COPY_GODWILL_COPY_EXPEND          = 9,         -- 统计函数类型--神将副本消耗
	CONST_LOGS_FUN_COPY_REVIVE                       = 10,        -- 统计函数类型--复活
	CONST_LOGS_FUN_COPY_WAR                          = 11,        -- 统计函数类型--请求副本
	CONST_LOGS_FUN_COPY_GODWILL_WAR_OVER             = 12,        -- 统计函数类型--神将副本通关
	CONST_LOGS_FUN_COPY_OPEN_MODULE_REWARD           = 13,        -- 统计函数类型--开启新功能奖励

	-- 统计日志模块--器灵
	CONST_LOGS_FUN_MAGICSOUL_RESOLVE                 = 1,         -- 统计函数类型--分解器灵
	CONST_LOGS_FUN_MAGICSOUL_STRENGTHEN              = 2,         -- 统计函数类型--器灵强化

	-- 统计日志模块--充值
	CONST_LOGS_FUN_RECHARGE_RECHARGE                 = 1,         -- 统计函数类型--充值
	CONST_LOGS_FUN_RECHARGE_BUY_PHYSICAL             = 2,         -- 统计函数类型--购买体力

	-- 统计日志模块--任务
	CONST_LOGS_FUN_TASK_GIFT                         = 1,         -- 统计函数类型--任务奖励
	CONST_LOGS_FUN_TASK_FILL_CHECK                   = 2,         -- 统计函数类型--补签

	-- 统计日志模块--装备
	CONST_LOGS_FUN_EQUIP_EAT                         = 1,         -- 统计函数类型--吞噬装备
	CONST_LOGS_FUN_EQUIP_WASH                        = 2,         -- 统计函数类型--装备熔炼
	CONST_LOGS_FUN_EQUIP_WASH_RESUME                 = 3,         -- 统计函数类型--熔炼恢复
	CONST_LOGS_FUN_EQUIP_SELL_EQUIP                  = 4,         -- 统计函数类型--装备出售

	-- 统计日志模块--技能
	CONST_LOGS_FUN_SKILL_UNLOCK                      = 1,         -- 统计函数类型--技能解锁
	CONST_LOGS_FUN_SKILL_UPGRADE                     = 2,         -- 统计函数类型--升级技能
	CONST_LOGS_FUN_SKILL_UNLOCK_SKILL_CHAIN          = 3,         -- 统计函数类型--升级技能

	-- 统计日志模块--仙门
	CONST_LOGS_FUN_SOCIATY_CREATE                    = 1,         -- 统计函数类型--创建仙门
	CONST_LOGS_FUN_SOCIATY_WAR_CELL                  = 2,         -- 统计函数类型--仙域争霸探索

	-- 排行统计
	CONST_RANKING_PAGE_INIT_PAGE                     = 1,         -- 排名列表--初始页数
	CONST_RANKING_PAGE_CUT_OUT                       = 20,        -- 排名列表--截取数量

	-- 竞技场统计
	CONST_WAR_RESULT                                 = 1,         -- 统计函数类型--结算

	-- 统计函数类型--招财
	CONST_LOGS_LUCKY                                 = 1,         -- 统计函数类型--招财
	CONST_LOGS_LUCKY_BOX                             = 2,         -- 统计函数类型--招财宝箱

	-- 统计函数类型--蟠桃
	CONST_LOGS_GET_MOP_UP_REWARD                     = 1,         -- 统计函数类型--获取扫荡奖励
	CONST_LOGS_PEENTO_RIPENER                        = 2,         -- 统计函数类型--蟠桃催熟
	CONST_LOGS_PEENTO_ELITE_MOP_UP                   = 3,         -- 统计函数类型--精英本扫荡
	CONST_LOGS_PEENTO_SELL_GOODS                     = 4,         -- 统计函数类型--出售装备

	-- 统计函数类型--竞技场
	CONST_LOGS_WAR_BUY_COUNT                         = 1,         -- 统计函数类型--购买竞技场次数
	CONST_LOGS_WAR_BUY_COUNT_PK                      = 2,         -- 统计函数类型--购买擂台战次数
	CONST_LOGS_WAR_PK_REWARD                         = 3,         -- 统计函数类型--擂台战奖励

	-- 统计函数类型--活动
	CONST_LOGS_FUN_ACTIVITY_REWARD                   = 1,         -- 统计函数类型--活动奖励
	CONST_LOGS_FUN_ACTIVITY_EXCHANGE                 = 2,         -- 统计函数类型--兑换礼包
	CONST_LOGS_FUN_ACTIVITY_TREASURE                 = 3,         -- 统计函数类型--秘宝转盘

	-- 副本类型
	CONST_COPY_TYPE_NORMAL                           = 1,         -- 副本类型--普通副本
	CONST_COPY_TYPE_ELITE                            = 2,         -- 副本类型--精英副本
	CONST_COPY_TYPE_BOSS                             = 3,         -- 副本类型--Boss副本
	CONST_COPY_TYPE_MONEY                            = 4,         -- 副本类型--财神宝库
	CONST_COPY_TYPE_MAGICSOUL                        = 5,         -- 副本类型--器灵副本	
	CONST_COPY_TYPE_GODWILL                          = 6,         -- 副本类型--神将副本
	CONST_COPY_TYPE_TRAIN_EXP                        = 7,         -- 副本类型--试练塔经验副本
	CONST_COPY_TYPE_TRAIN_FLOWER                     = 8,         -- 副本类型--试练塔鲜花副本
	CONST_COPY_TYPE_TRAIN_RENOWN                     = 9,         -- 副本类型--试练塔声望副本
	CONST_COPY_TYPE_WORLD_BOSS                       = 10,        -- 副本类型--世界boss
	CONST_COPY_TYPE_WAR                              = 11,        -- 副本类型--竞技场
	CONST_COPY_TYPE_SOCIATY_SCENE                    = 12,        -- 副本类型--仙门场景
	CONST_COPY_TYPE_SOCIATY_SCENE_BOSS               = 13,        -- 副本类型--仙门组队爬塔
	CONST_COPY_TYPE_WAR_PK                           = 14,        -- 副本类型--擂台战
	CONST_COPY_FREE                                  = 1,         -- 副本--免费副本
	CONST_COPY_RMB                                   = 2,         -- 副本--付费副本
	CONST_COPY_RESULT_WIN                            = 1,         -- 副本结果--胜利
	CONST_COPY_RESULT_FAIL                           = 2,         -- 副本结果--失败
	CONST_COPY_DIFFICULTY_EASY                       = 1,         -- 副本难度--简单
	CONST_COPY_DIFFICULTY_MEDIUM                     = 2,         -- 副本难度--中等
	CONST_COPY_DIFFICULTY_DIFFICULTY                 = 3,         -- 副本难度--困哪
	CONST_COPY_FIRST                                 = 1,         -- 副本通关--首次通关
	CONST_COPY_PASSED                                = 2,         -- 副本通关--已通关

	-- 副本掉落类型定义
	CONST_COPY_DROP_TYPE_GOODS                       = 1,         -- 掉落类型--物品
	CONST_COPY_DROP_TYPE_GOLD                        = 2,         -- 掉落类型--金币

	-- 玩家数据类型统计
	CONST_ROLE_DATA_TYPE_BASE                        = 0,         -- 玩家数据类型--基础
	CONST_ROLE_DATA_TYPE_EQUIP                       = 1,         -- 玩家数据类型--装备
	CONST_ROLE_DATA_TYPE_SKILLCHAIN                  = 2,         -- 玩家数据类型--连招
	CONST_ROLE_DATA_TYPE_MAGICSOUL                   = 3,         -- 玩家数据类型--器灵
	CONST_ROLE_DATA_TYPE_YUANGOD                     = 4,         -- 玩家数据类型--元神
	CONST_ROLE_DATA_TYPE_MAGICITEM                   = 5,         -- 玩家数据类型--法器
	CONST_ROLE_DATA_TYPE_FAIRY                       = 6,         -- 玩家数据类型--仙女
	CONST_ROLE_DATA_TYPE_GODWILL                     = 7,         -- 玩家数据类型--神将
	CONST_ROLE_DATA_TYPE_OTHER                       = 8,         -- 玩家数据类型--其他

	-- 战斗单元相关定义
	CONST_WAR_UNIT_TYPE_PLAYER                       = 1,         -- 战斗单元类型--玩家
	CONST_WAR_UNIT_TYPE_MONSTER                      = 2,         -- 战斗单元类型--怪物
	CONST_WAR_UNIT_TYPE_GODWILL                      = 3,         -- 战斗单元类型--神将

	-- 蟠桃
	CONST_PEENTO_TYPE_THREE_THOUSAND_YEARS           = 1,         -- 蟠桃类型--三千年蟠桃
	CONST_PEENTO_TYPE_SIX_THOUSAND_YEARS             = 2,         -- 蟠桃类型--六千年蟠桃
	CONST_PEENTO_TYPE_NINE_THOUSAND_YEARS            = 3,         -- 蟠桃类型--九千年蟠桃

	-- 活动类型
	CONST_ACTIVITY_TYPE_LV_ACTIVITY                  = 1,         -- 活动类型--等级礼包
	CONST_ACTIVITY_TYPE_LOGIN_ACTIVITY               = 2,         -- 活动类型--登陆礼包
	CONST_ACTIVITY_TYPE_AMASS_RECHANGE_ACTIVITY      = 3,         -- 活动类型--累积充值
	CONST_ACTIVITY_TYPE_WAR_FIGHT_ACTIVITY           = 4,         -- 活动类型--竞技场挑战礼包
	CONST_ACTIVITY_TYPE_VIP_WEEK_ACTIVITY            = 5,         -- 活动类型--VIP周礼包
	CONST_ACTIVITY_TYPE_OVERBALANCE_ACTIVITY         = 6,         -- 活动类型--VIP超值礼包
	CONST_ACTIVITY_TYPE_OVERBALANCE_SHOP             = 7,         -- 活动类型--特价商店
	CONST_ACTIVITY_TYPE_MONTH_CARD                   = 8,         -- 活动类型--月卡
	CONST_ACTIVITY_TYPE_SUPREMACY_MONTH_CARD         = 9,         -- 活动类型--至尊月卡
	CONST_ACTIVITY_TYPE_OPEN_SERVER                  = 10,        -- 活动类型--开服基金
	CONST_ACTIVITY_TYPE_ALL_PLAYER_WELFARE           = 11,        -- 活动类型--全民福利
	CONST_ACTIVITY_TYPE_AMASS_RMB                    = 13,        -- 活动类型--累积消费
	CONST_ACTIVITY_TYPE_ONE_RECHARGE                 = 14,        -- 活动类型--单笔充值
	CONST_ACTIVITY_TYPE_ONE_CONSUME                  = 15,        -- 活动类型--单笔消费
	CONST_ACTIVITY_TYPE_EXCHANGE                     = 250,       -- 活动类型--兑换礼包
	CONST_ACTIVITY_TREASURE_TYPE_ONE                 = 1,         -- 秘宝转盘类型--单抽
	CONST_ACTIVITY_TREASURE_TYPE_TEN                 = 2,         -- 秘宝转盘类型--十连抽

	-- 爬塔
	CONST_CLIMBING_TOWER_TEAM_CAPTAIN                = 1,         -- 爬塔队员类型--队长
	CONST_CLIMBING_TOWER_TEAM_MEMBER                 = 2,         -- 爬塔队员类型--队员
	CONST_CLIMBING_TOWER_NOT_PREPARE                 = 0,         -- 爬塔状态类型--未准备
	CONST_CLIMBING_TOWER_IS_PREPARE                  = 1,         -- 爬塔状态类型--已准备

	-- 走马灯
	CONST_TROTTING_HORSE_LAMP_SYSTEM_ANNOUNCEMENT    = 1,         -- 走马灯类型--系统公告
	CONST_TROTTING_HORSE_LAMP_WORLD_BOSS_OPEN        = 2,         -- 走马灯类型--世界boss开启
	CONST_TROTTING_HORSE_LAMP_SOCIATY_CHAMPION       = 3,         -- 走马灯类型--仙门联赛冠军
	CONST_TROTTING_HORSE_LAMP_SOCIATY_LVUP           = 4,         -- 走马灯类型--仙门等级上升
	CONST_TROTTING_HORSE_LAMP_WAR_FIRST              = 5,         -- 走马灯类型--竞技场第一
	CONST_TROTTING_HORSE_LAMP_FAIRY_LV_MAX           = 6,         -- 走马灯类型--仙女等级Max
	CONST_TROTTING_HORSE_LAMP_MAX_GODWILL            = 7,         -- 走马灯类型--神将等级满级
	CONST_TROTTING_HORSE_LAMP_GET_GOLDEN_GODWILL     = 8,         -- 走马灯类型--获取金色神将
	CONST_TROTTING_HORSE_LAMP_GOLDEN_MAGICSOUL_INTENSIFY= 9,         -- 走马灯类型--金色器灵强化+11以上
	CONST_TROTTING_HORSE_LAMP_GET_GOLDEN_MAGICSOUL   = 10,        -- 走马灯类型--获得金色器灵
	CONST_TROTTING_HORSE_LAMP_EQUIP_LV_MAX           = 11,        -- 走马灯类型--装备强化满级
	CONST_TROTTING_HORSE_LAMP_LOTTERY                = 12,        -- 走马灯类型--抽奖
	CONST_TROTTING_HORSE_LAMP_SERVER                 = 0,         -- 走马灯发送类型--后端执行
	CONST_TROTTING_HORSE_LAMP_CLIENT                 = 1,         -- 走马灯发送类型--前端执行

	-- 兑换商店
	CONST_EXCHANGE_SHOP_UNCLAIMED                    = 0,         -- 兑换商店类型--未领取
	CONST_EXCHANGE_SHOP_HAVE_TO_RECEIVE              = 1,         -- 兑换商店类型--已领取

	-- 次数保存
	CONST_COUNT_SAVE_TYPE_TASK                       = 1,         -- 次数保存类型--任务

	-- 仙域争霸
	CONST_SOCIATY_WAR_POSITION_X                     = 50,        -- 地图最大坐标x
	CONST_SOCIATY_WAR_POSITION_Y                     = 50,        -- 地图最大坐标y
	CONST_SOCIATY_WAR_SIDE_TOP                       = 1,         -- 方向--上
	CONST_SOCIATY_WAR_SIDE_TOP_RIGHT                 = 2,         -- 方向--右上
	CONST_SOCIATY_WAR_SIDE_RIGHT                     = 3,         -- 方向--右
	CONST_SOCIATY_WAR_SIDE_BOTTOM_RIGHT              = 4,         -- 方向--右下
	CONST_SOCIATY_WAR_SIDE_BOTTOM                    = 5,         -- 方向--下
	CONST_SOCIATY_WAR_SIDE_BOTTOM_LEFT               = 6,         -- 方向--左下
	CONST_SOCIATY_WAR_SIDE_LEFT                      = 7,         -- 方向--左
	CONST_SOCIATY_WAR_SIDE_TOP_LEFT                  = 8,         -- 方向--左上

}