local CharacterData = CharacterData or class("CharacterData")
_G.gMainPlayerPro = 0

function CharacterData:ctor()
    self.config = nil
    self.uid = 0      -- 玩家唯一ID
    self.name = "no Nmae" -- 名字
    self.exp = 0      -- 角色经验
    self.expup = 0    -- 升级需要的经验
    self.lv = 1       -- 等级
    self.power = 0    -- 战力
    self.pro = 0      -- 职业
    self.gold = 0     -- 金钱
    self.rmb = 0      -- 元宝
    self.renown = 0   -- 声望
    self.soul = 0     -- 元神
    self.anima = 0    -- 灵力
    self.godsoul = 0  -- 斗魂
    self.flower = 0   -- 鲜花
    self.moveSpeed = 0 -- 移动速度
    self.baseAttr = BaseAttrData.new()   -- 基础属性
    self.equipList = {}  -- 角色已装备列表
    self.spiritData = nil   --角色已装备器灵
    self:init()
end 

function CharacterData:init()
    print("CharacterData init")
end

function CharacterData:readMsg(msg)
    local enCAT = enCharacterAttrType
    self.uid = enCAT:readMsg(msg,enCAT.UID)
    self.name = enCAT:readMsg(msg,enCAT.NAME)
    self.pro = enCAT:readMsg(msg,enCAT.PRO)
    _G.gMainPlayerPro = self.pro
    self.lv = enCAT:readMsg(msg,enCAT.LV)
    _G.gMainPlayerLv = self.lv
    self.exp = enCAT:readMsg(msg,enCAT.EXP)
    self.expup = enCAT:readMsg(msg,enCAT.EXPUP)
    self.power = enCAT:readMsg(msg,enCAT.POWER)
    self.baseAttr:readMsg(msg)
    self.equipList = {}
    local equipCount = msg:readUshort()
    print("equipCount: " .. equipCount)
    for var=1, equipCount do
        local goods = zzd.GoodsData.new()
        goods.backpackType = enBackpackType.ROLE_EQUIP
        goods:readMsg(msg)
        self.equipList[goods.config.TypeSub] = goods
    end
    local spiritCount = msg:readUshort()
    print("spiritCount:"..spiritCount)
    if spiritCount == 1 then
        local goods = zzd.GoodsData.new()
        goods.backpackType = enBackpackType.SPIRIT
        goods:readMsg(msg)
        self.spiritData = goods
    end
    self:init()
    print("uid: ".. self.uid .. "  name:".. self.name .. "  lv:".. self.lv)
    zzm.TalkingDataModel:setAccountName(self.name)
    zzm.TalkingDataModel:setLevel(self.lv)
    zzm.GroupModel:saveRoleInfo()
end

function CharacterData:getValueByType(type)
    print(enCharacterAttrType:getAttrName(type))
    local enCAT = enCharacterAttrType
    local value = nil
    if  type == enCAT.HP or
        type == enCAT.MP or
        type == enCAT.ATK or
        type == enCAT.DEF or
        type == enCAT.CRIT or
        type == enCAT.CRITDMG then
        value = self.baseAttr[enCAT:getAttrName(type)]
    else
        value = self[enCAT:getAttrName(type)]
    end
    print(value)
    return value
end

function CharacterData:setValueByType(type, value)
    print("======================================" .. type)
    local enCAT = enCharacterAttrType
    if  type == enCAT.HP or
        type == enCAT.MP or
        type == enCAT.ATK or
        type == enCAT.DEF or
        type == enCAT.CRIT or
        type == enCAT.CRITDMG then
        self.baseAttr[enCAT:getAttrName(type)] = value
        --self.baseAttr:setValueByType(type, value)
    else
        self[enCAT:getAttrName(type)] = value
    end
    
    if type == enCAT.LV then
        _G.gMainPlayerLv = value
    end
end

return CharacterData