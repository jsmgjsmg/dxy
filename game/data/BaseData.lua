-- 具有属性类型和值
TypeAndValue = TypeAndValue or class("TypeAndValue")

function TypeAndValue:ctor()
    self.type = 0
    self.value = 0
end 

-- 具有当前值和最大值的数据
ProgressData = ProgressData or class("ProgressData")

function ProgressData:ctor()
    self.cur = 0
    self.max = 0
end 

EquipAttrSolt = EquipAttrSolt or class("EquipAttrSolt")

function EquipAttrSolt:ctor()
    self.index = 0
    self.type = 0
    self.value = 0
    self.quality = 0
end 

function EquipAttrSolt:readMsg(msg)
    self.index = msg:readByte()
    self.type = msg:readByte()
    self.type = self:goodsToCharacterAttrType(self.type)
    local enCAT = enCharacterAttrType
    self.value = enCharacterAttrType:readMsg(msg,self.type)
    self.quality = msg:readByte()
--    print("index: ".. self.index .. "  type:".. self.type .. "  value:".. self.value.." quality:"..self.quality)
end

function EquipAttrSolt:goodsToCharacterAttrType(goodAttrType)
    return goodAttrType + 11
end

-- 角色和装备公用的基础属性
-- 为装备时，hp，mp为数值
-- 为角色时，hp，mp为表包括当前值和最大值
BaseAttrData = BaseAttrData or class("BaseAttrData")

function BaseAttrData:ctor()
    self.atk = 0
    self.def = 0
    self.hp = 0
    self.mp = 0
    self.crit = 0
    self.critDmg = 0
end 

function BaseAttrData:readMsg(msg)
    local enCAT = enCharacterAttrType
    self["hp"] = enCAT:readMsg(msg,enCAT.HP)
    self["mp"] = enCAT:readMsg(msg,enCAT.MP)
    self["atk"] = enCAT:readMsg(msg,enCAT.ATK)
    self["def"] = enCAT:readMsg(msg,enCAT.DEF)
    self["crit"] = enCAT:readMsg(msg,enCAT.CRIT)
    self["critDmg"] = enCAT:readMsg(msg,enCAT.CRITDMG)
    print("hp: ".. self.hp .. "  mp:".. self.mp .. "  atk:".. self.atk.. "  def:".. self.def)
end

function BaseAttrData:getValueByType(type)
    local enCAT = enCharacterAttrType
    local value = nil
    if type == enCAT.HP then
    	value = self.hp
    elseif type == enCAT.MP then
        value = self.mp
    elseif type == enCAT.ATK then
        value = self.atk
    elseif type == enCAT.DEF then
        value = self.def
    elseif type == enCAT.CRIT then
        value = self.crit
    elseif type == enCAT.CRITDMG then
        value = self.critDmg
    else
    
    end
    return value
end

function BaseAttrData:setValueByType(type, value)
    local enCAT = enCharacterAttrType
    if type == enCAT.HP then
        self.hp = value
    elseif type == enCAT.MP then
        self.mp = value
    elseif type == enCAT.ATK then
        self.atk = value
    elseif type == enCAT.DEF then
        self.def = value
    elseif type == enCAT.CRIT then
        self.crit = value
    elseif type == enCAT.CRITDMG then
        self.critDmg = value
    else
    
    end
    --self[enCharacterAttrType:getAttrName(type)] = value
end

