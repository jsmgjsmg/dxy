
enFunctionType = {
    LingShan = "lingshan",
    ShiLianTa = "shilianta",
    ChuMo = "chumo",
    CaiShenBaoKu = "caishenbaoku",
    FengShenTai = "fengshentai",
    PaiHangBang = "paihangbang",
    XianMen = "xianmen",
    XianNv   = "xiannv",
    XianMenLianSai = "xianmenliansai",
    JingJiChang = "jingjichang",
    ZhuangBei = "zhuangbei",
    JiNeng = "jineng",
    YuanShen = "yuanshen",
    JiangLi = "jiangli",
    SaoDang = "SaoDang",
	ZuDui = "tongtianta",
	XianYu = "xianyu"
}

-- 背包类型
enBackpackType = {
    BACKPACK = 1,    -- 背包
    ROLE_EQUIP = 2,  -- 装备栏
    SPIRIT = 3,     --器灵
}

--物品类型
enGoodsType = {
    EQUIP = 1,  --装备
    SPIRIT = 3, --器灵
    MAGIC = 4,  --技能石
}

-- 角色属性类型枚举
enCharacterAttrType = {
--clint
    ["UID"] = 50,      -- 玩家唯一ID
    ["GODSOUL"] = 51,  -- 元神
    ["SPEED"] = 52, -- 移动速度
--server
    ["GOLD"] = 1,     -- 金钱
    ["RMB"] = 2,      -- 元宝
    ["POINT"] = 3,      -- 点券
    ["RENOWN"] = 4,   -- 声望
    ["ANIMA"] = 5,    -- 灵力
    ["SOUL"] = 6,     -- 斗魂
    ["FLOWER"] = 7,   -- 鲜花
    ["EXP"] = 8,      -- 角色经验
    ["NAME"] = 9,     -- 名字
    ["LV"] = 10,       -- 等级
    ["PRO"] = 11,      -- 职业
    ["HP"] = 12,      -- 生命
    ["MP"] = 13,      -- 魔法
    ["ATK"] = 14,     -- 攻击
    ["DEF"] = 15,     -- 防御
    ["CRIT"] = 16,    -- 暴击
    ["CRITDMG"] = 17, -- 暴击伤害
    ["ENERGYSOUL"] = 19,--精魄
    ["POWER"] = 20,     --战斗力
    ["EXPUP"] = 21,     --升级所需要经验
    ["AMULET"] = 22,    --护符
    ["MONEYCOUNT"] = 23,    --财神宝库副本次数
    ["PHYSICAL"] = 24,  --元力
    ["PHYSICALBUY"] = 25,  --购买元力次数
    ["TRAINEXPCOUNT"] = 26, --经验试练塔次数
    ["TRAINFLOWERCOUNT"] = 27,  --鲜花试练塔次数
    ["TRAINRENOWNCOUNT"] = 28,  --声望试练塔次数
    ["EXPLORE"] = 29,   --器灵免费探索次数
    ["WARCOUNT"] = 30,  --竞技场进入次数
    ["GNCOPYUD"] = 31,    --神将副本刷新次数
    ["GNCOPYCN"] = 32,    --神将副本体力
    ["GNCOPYDFC"] = 33,   --神将副本难度
    ["GNCOPYMST"] = 34,   --神将副本怪物组
    ["MONEYLAYER"] = 35,    --财神宝库层数
    ["GODPHYSICALBUY"] = 36,    --神将副本体力购买次数
    ["WARBUY"] = 37,        --竞技场购买次数
    ["TCCOUNT"] = 38,     --爬塔次数
    ["TCLEVEL"] = 39,      --爬塔层数

    -----------------------------------
    -- 对应属性CharacterData对应字段名字
    [50] = "uid",   
    [51] = "godsoul", 
    [52] = "moveSpeed", 
    
    [1] = "gold", 
    [2] = "rmb", 
    [3] = "point",
    [4] = "renown", 
    [5] = "anima", 
    [6] = "soul", 
    [7] = "flower", 
    [8] = "exp", 
    [9] = "name", 
    [10] = "lv", 
    [11] = "pro",
    [12] = "hp", 
    [13] = "mp",
    [14] = "atk", 
    [15] = "def", 
    [16] = "crit", 
    [17] = "critDmg", 
    [19] = "energysoul",
    [20] = "power",
    [21] = "expup",
    [22] = "amulet",
    [23] = "moneycount",
    [24] = "physical",
    [25] = "physicalbuy",
    [26] = "trainexpcount",
    [27] = "trainflowercount",
    [28] = "trainrenowncount",
    [29] = "explore",
    [30] = "warcount",
    [31] = "gncopyud",
    [32] = "gncopycn",
    [33] = "gncopydfc",
    [34] = "gncopymst",
    [35] = "moneylayer",
    [36] = "godphysicalbuy",
    [37] = "warbuy",
    [38] = "tccount",
    [39] = "tclevel",
    
    -----------------------------------
    -- 对应属性对应字段中文名字

    typeName = {
        [50] = "玩家唯一ID", 
        [51] = "元神", 
        [52] = "移动速度", 
        
        [8] = "经验", 
        [9] = "玩家名字", 
        [10] = "等级", 
        [11] = "职业", 
        [1] = "金钱", 
        [2] = "元宝", 
        [3] = "点券",
        [4] = "声望",
        [5] = "灵力", 
        [6] = "斗魂", 
        [7] = "鲜花", 
        [8] = "角色经验", 
        [9] = "名字", 
        [10] = "等级", 
        [11] = "职业",
        [12] = "生命", 
        [13] = "魔法", 
        [14] = "攻击", 
        [15] = "防御", 
        [16] = "暴击", 
        [17] = "暴击伤害",
        [19] = "精魄",
        [20] = "战斗力",
        [21] = "升级所需经验",
        [22] = "护符",
        [23] = "财神宝库副本次数",
        [24] = "体力",
        [25] = "购买体力次数",
        [26] = "经验试练塔次数",
        [27] = "鲜花试练塔次数",
        [28] = "声望试练塔次数",
        [29] = "器灵副本免费探索次数",
        [30] = "竞技场进入次数",
        [31] = "神将副本更新次数",
        [32] = "神将副本体力",
        [33] = "神将副本难度",
        [34] = "神将副本怪物组",
        [35] = "财神宝库层数",
        [36] = "神将副本体力购买次数",
        [37] = "竞技场购买次数",
        [38] = "爬塔次数",
        [39] = "爬塔层数",
    }
}

--书写更新时部分属性统一32位不能和角色数据下发公用
function enCharacterAttrType:readUpdateMsg(msg,type)
    local value = nil
    if type == self.NAME then
        value = msg:readString()
    else
        value = msg:readUint()
    end
    if value then
        print("Attr type:" .. self:getTypeName(type) .. "  value:".. value)
    end
    return value
end

function enCharacterAttrType:readMsg(msg,type)
    local value = nil
    if type == self.NAME then
    	value = msg:readString()
    elseif 
        type == self.UID or
        type == self.GOLD or
        type == self.RMB or
        type == self.HP or 
        type == self.MP or
        type == self.ATK or
        type == self.DEF or
        type == self.CRIT or
        type == self.CRITDMG or
        type == self.SOUL or
        type == self.ANIMA or
        type == self.GODSOUL or
        type == self.FLOWER or
        type == self.RENOWN or
        type == self.ENERGYSOUL or 
        type == self.EXP or
        type == self.EXPUP or
        type == self.POWER or
        type == self.AMULET or
        type == self.PHYSICAL or 
        type == self.GNCOPYMST or
        type == self.GNCOPYCN then
        value = msg:readUint()
    elseif
        type == self.LV or type == self.TCLEVEL then
        value = msg:readUshort()
    elseif 
        type == self.PRO or 
        type == self.MONEYCOUNT or 
        type == self.PHYSICALBUY or
        type == self.TRAINEXPCOUNT or
        type == self.TRAINFLOWERCOUNT or
        type == self.TRAINRENOWNCOUNT or
        type == self.EXPLORE or
        type == self.WARCOUNT or
        type == self.GNCOPYUD or 
        type == self.GNCOPYDFC or
        type == self.MONEYLAYER or
        type == self.GODPHYSICALBUY or
        type == self.WARBUY or 
        type == self.TCCOUNT then
        value = msg:readByte()
    else
        print("error type:" .. type)
    end
    if value then
        print("********************************************************")
        print("Attr type:" .. self:getTypeName(type) .. "  value:".. value)
    end
    return value
end

function enCharacterAttrType:getTypeName(type)
    if not self.typeName[type] then
        print("this type no name! :" .. type)
    end
    return self.typeName[type]
end

function enCharacterAttrType:getAttrName(type)
    if not self[type] then
        print("this type no name! :" .. type)
    end
    return self[type]
end

enGoodsAttrType = {
    ["HP"] = 1,      -- 生命
    ["MP"] = 2,      -- 魔法
    ["ATK"] = 3,     -- 攻击
    ["DEF"] = 4,     -- 防御
    ["CRIT"] = 5,    -- 暴击
    ["CRITDMG"] = 6, -- 暴击伤害
}

function enCharacterAttrType:getGoodsAttrKey(value)
    local key = ""
	table.foreach(enGoodsAttrType,function(i,v)
	   if v == value - 11 then
	   	   key = i
	   end
	end)
	return key
end