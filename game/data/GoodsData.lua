--单个物品数据结构
--config物品表数据，读表
--baseAttr物品基本属性数据，读表
--其他属性来至服务器或者计算得到

local GoodsData = GoodsData or class("GoodsData")

function GoodsData:ctor()
    self.config = nil
    self.baseAttr = nil
    self.goods_id = 0
    self.idx = 0
    self.count = 0
    self.isEquip = 0
    self.backpackType = 0
     
end 

--读表，计算部分属性
function GoodsData:init()
    self.config = GoodsConfigProvider:findGoodsById(self.goods_id)
    if self.config and self.config.BaseAttrID then
        print("---BaseAttrId: ".. self.config.BaseAttrID)
        self.baseAttr = GoodsConfigProvider:findBaseAttrById(self.config.BaseAttrID)
    end
end

--读取服务器下发数据
function GoodsData:readMsg(msg)
    self.goods_id = msg:readUint()
    self.idx = msg:readUshort()
--    self.count = msg:readUshort()
    self.count = msg:readUint()
    self.isEquip = msg:readByte()
    if self.isEquip == 1 then
        print("装备")
        self.type = msg:readByte()
        self.exp = msg:readUint()
        self.exp_uplv = msg:readUint()
        self.exp_eat = msg:readUint()
        self.lv = msg:readUshort()
        self.base_attr_t = msg:readByte()
        self.base_attr_t = EquipAttrSolt:goodsToCharacterAttrType(self.base_attr_t)
        self.base_attr_v = msg:readUint()
        self.base_attr_vf = msg:readUint()
        self.attr_count = msg:readUshort()
        self.attr_solt = {}
        print("强化等级:"..self.lv)
        print("当前强化经验:"..self.exp)
        print("当前强化所需经验:"..self.exp_uplv)
        print("被吞噬提供的经验:"..self.exp_eat)
        print("base_attr_t:"..self.base_attr_t)
        print("base_attr_v:"..self.base_attr_v)
        print("attr_count:"..self.attr_count)
        for index=1, self.attr_count do
        	local solt = EquipAttrSolt.new()
        	solt:readMsg(msg)
            table.insert(self.attr_solt,#self.attr_solt+1,solt)
        end
    elseif self.isEquip == 0 then --非物品
        self.type = msg:readUbyte()
--        if type == 4 then
--            local data = {}
--            data.Id = self.goods_id
--            data.Num = self.count
--            data.config = GoodsConfigProvider:findGoodsById(data.Id)
--            zzm.YuanShenModel:initStone(data)
--        end

    else
        print("Error isEquip")
    end
    self:init()
    print("goods_id: ".. self.goods_id .. "  index:".. self.idx .. "  count:".. self.count)
    if self.isEquip == 1 then
        self.exp_max = self:getMaxExp()
    end
end

--物品Icon
function GoodsData:getIcon()
    local path = "Icon/"
    if self.config.Icon == "String" or self.config.Icon == nil then
        path = path .. "props_yao.png"
    else
        path = path .. self.config.Icon .. ".png"
    end
    return path
end

--物品品质Icon
function GoodsData:getQualityIcon()
    local path = "dxyCocosStudio/png/equip/quality_"
	path = path..self.config.Quality..".png"
	return path
end

--器灵品质Icon
function GoodsData:getSpiritQualityIcon()
    local path = "dxyCocosStudio/png/equip/spiritQuality_"
    path = path..self.config.Quality..".png"
    return path
end

function GoodsData:getBaseType()
    if self.isEquip == 1 then
        return self.base_attr_t
    end
end

function GoodsData:getBaseValue()
    if self.isEquip == 1 then
        return self.base_attr_v
    end
end

--读取服务器下发数据
function GoodsData:getSubType()
    return self.config.TypeSub
end

function GoodsData:getType()
    return self.config.Type
end

--当前装备强化等级到满级强化所需的总经验
function GoodsData:getMaxExp()

    local maxLv = EquipStrengthenConfig:getLvMax()
    local needExp = 0
	local upLvExp = EquipStrengthenConfig:getBaseExp(self.config.Lv)
	local upLvRatio = EquipStrengthenConfig:getQualityUpRatio(self.config.Quality)
    local equipType = EquipStrengthenConfig:getEquipTypeRatio(self.config.TypeSub)
    local strengthenUpLvRatio = 0
    
    if (not upLvExp) or (not upLvRatio) or (not equipType) then
    	return 0
    end
    
    for index=self.lv + 1, maxLv do   	
        strengthenUpLvRatio = EquipStrengthenConfig:getUpLvRatio(index)
        needExp = needExp + math.ceil((upLvExp * upLvRatio * equipType * strengthenUpLvRatio))
    end
    
    needExp = needExp - self.exp
    
    return needExp
end

return GoodsData