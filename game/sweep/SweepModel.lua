local SweepModel = class("SweepModel")
SweepModel.__index = SweepModel

function SweepModel:ctor()
    self:initModel()
end

function SweepModel:initModel()
    self.treeNum = 0    --树上的蟠桃
    self.limit = 0      --库存上限
    self.ripedCount = 0 --已催熟次数
    self.ripeCount = 0  --可催熟次数
    self.ripeTime = 0   --成熟时间
    
    self.sendNum = 0    --发送的桃子数

    self.peach_list = {}
    self.award_list = {}    --普通副本扫荡奖励
    
    
    self.award_elite_list = {}  --精英副本扫荡奖励
    self.eliteCopyId = 0      --当前扫荡的精英副本ID
	
	self.isLoginSend = true --是否登录下发
end

function SweepModel:getPeachNum()
    local count = 0
    for key, var in pairs(self.peach_list) do
       count = count + var.count
    end
    return count
end

function SweepModel:findPeachNumByType(type)
    for key, var in pairs(self.peach_list) do
        if var.type == type then
            return var.count
        end
    end
    return 0
end

function SweepModel:getAllExp()
    local exp = 0
    for index=1, #self.award_list do
        exp = exp + self.award_list[index].exp
    end

    return exp
end

function SweepModel:getAllGold()
    local gold = 0
    for index=1, #self.award_list do
        gold = gold + self.award_list[index].gold
    end

    return gold
end

--领取时判断背包是否空间不够
function SweepModel:isLackOfSpace()
    local backPack = zzm.CharacterModel:getBackpackList()

    local remainSpace = AutocephalyValueConfig:getValueByContent("EquipListNum") * AutocephalyValueConfig:getValueByContent("EquipRowNum") - #backPack

    local euqipData = {}

    for index=1, #self.award_list do
        for init=1, #self.award_list[index].equip do
            table.insert(euqipData,self.award_list[index].equip[init])
        end
    end
    
    return remainSpace >= #euqipData

end

return SweepModel