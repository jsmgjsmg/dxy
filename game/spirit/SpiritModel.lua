local SpiritModel = class("SpiritModel")
SpiritModel.__index = SpiritModel

function SpiritModel:ctor()
	self:initModel()
end

function SpiritModel:initModel()
	self.spirit_copy = {}
	self.spiritCopyPassData = {}   --已通关等级，难度副本
	
	self.spirit_type = 1
    self.useRmb = 0
    self.searchCount = 0
    self.spiritSweepCount = 0
	
	self.curSpiritDifficulty = 1   --当前难度
	self.curSpiritLv = 0           --当前等级
	self.curSpiritLvType = 1       --当前等级类型
end

function SpiritModel:updateCopy(data)
    for key, var in pairs(self.spirit_copy) do
		if data.idx == var.idx then
		  self.spirit_copy[key] = data
		end
	end
end

function SpiritModel:insertSpiritCopyPassData(data)
	self.spiritCopyPassData = data
end

--判断是否已通关
function SpiritModel:isClear()
    for key, var in pairs(self.spirit_copy) do
        if var.state == 0 then
            return false
        end
    end
    return true
end

--获取器灵分解基础倍率
function SpiritModel:getResolveBaseRate()
    local rate = MagicSoulConfigProvider:getResolveBaseRate()
	return rate
end

--通过等级获取器灵分解系数
function SpiritModel:findCoefficientByLv(lv)
	local coefficient = MagicSoulConfigProvider:findCoefficientByLv(lv)
	return coefficient
end

--通过品质获取器灵分解系数
function SpiritModel:findCoefficientByQuality(quality)
	local coefficient = MagicSoulConfigProvider:findCoefficientByQuality(quality)
	return coefficient
end

--获取器灵强化基础倍率
function SpiritModel:getStrengthBaseRote()
	local rate = MagicSoulConfigProvider:getStrengthBaseRote()
	return rate
end

--通过强化等级获取器灵强化系数
function SpiritModel:findCoefficientByStrengthLv(StrengthLv)
    local coefficient = MagicSoulConfigProvider:findCoefficientByStrengthLv(StrengthLv)
    return coefficient
end

--通过装备等级获取器灵强化系数
function SpiritModel:findCoefficientBySpiritLv(lv)
    local coefficient = MagicSoulConfigProvider:findCoefficientBySpiritLv(lv)
    return coefficient
end

--通过装备品质获取器灵强化系数
function SpiritModel:findCoefficientBySpiritQuality(Quality)
    local coefficient = MagicSoulConfigProvider:findCoefficientBySpiritQuality(Quality)
    return coefficient
end

--通过器灵品质获取器灵可强化最大等级
function SpiritModel:getMaxStrengthenLvByQuality(Quality)
	local maxLv = MagicSoulConfigProvider:getMaxStrengthLvByQuality(Quality)
	return maxLv
end

function SpiritModel:getNextLvAmulet(nextLv)
	local amulet = MagicSoulConfigProvider:getNextLvAmulet(nextLv)
	return amulet
end

function SpiritModel:getRandomScene()
    local list = MagicSoulConfigProvider:getAllScene()
    local ret = {}
    for var=1, 6 do
    	local index = math.random(1,#list)
    	print("Error Num:" .. #list)
    	table.insert(ret,#ret + 1,list[index])
    end
    return ret
end

return SpiritModel