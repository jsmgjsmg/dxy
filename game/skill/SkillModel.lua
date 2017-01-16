local SkillModel = class("SkillModel")
SkillModel.__index = SkillModel

function SkillModel:ctor()
    self:initModel()
end

function SkillModel:initModel()
    self.curSkill = {}
    self.curSoulSkill = {}
    self.skillList = {}     --技能列表
    self.ctSkillList = {}   --连招列表
    
    _G.gOperationType = cc.UserDefault:getInstance():getIntegerForKey(UserDefaulKey.OperationType,2)
end

function SkillModel:saveOperationType(type)
    cc.UserDefault:getInstance():setIntegerForKey(UserDefaulKey.OperationType,type)
    cc.UserDefault:getInstance():flush()
    
    _G.gOperationType = type
end

----
--技能列表
function SkillModel:setSkillList(list)
    for i = 1 , #self.skillList do
        if self.skillList[i].id == list.id then
            if self.skillList[i].lv < list.lv then
                dxyDispatcher_dispatchEvent(dxyEventType.Skill_Update_Effect,list.id)           	
            end
            self.skillList[i].lv = list.lv
            return
        end
    end
    self.skillList[#self.skillList+1] = list
    dxyDispatcher_dispatchEvent(dxyEventType.Skill_Unlock_Effect,list.id)
    return
end

function SkillModel:getSkillList()
    return self.skillList
end

--根据技能ID获取技能技能等级
function SkillModel:getSkillLvById(id)
    for key, var in pairs(self.skillList) do
        if var.id == id then
            return var.lv
        end
    end
    return 0
end

--根据技能ID获取技能是否解锁
function SkillModel:getSkillUnlock(skill_id)
    for key, var in pairs(self.skillList) do
        if var.id == skill_id then
            return true
        end
    end
    return false
end

--获取是否有技能可以升级或者解锁
function SkillModel:getSkillIsTips()
    local skillUpgradeList = {}
	local role = zzm.CharacterModel:getCharacterData()
	if next(role) == nil then
        return skillUpgradeList
	end
    local enCAT = enCharacterAttrType
    local curLv = role:getValueByType(enCAT.LV)
    local nextSkillData = nil
    local skillList = HeroSkill:getHeroBaseSkillList(role:getValueByType(enCAT.PRO))
    for skillKey, skillVar in pairs(skillList) do
        for unlockKey, unlockVar in pairs(self.skillList) do
            if skillVar.Id == unlockVar.id then
                nextSkillData = SkillConfig:getSkillByLv(skillVar.Id,unlockVar.lv+1)
                if not nextSkillData then
                	break
                end
                if curLv >= nextSkillData.DeblockingLv then
                    table.insert(skillUpgradeList,#skillUpgradeList + 1,skillVar.Id)                   
                else                    
                end
                break
            elseif not self:getSkillUnlock(skillVar.Id) then
                if curLv >= SkillConfig:getSkillByLv(skillVar.Id,1).DeblockingLv then
                    table.insert(skillUpgradeList,#skillUpgradeList + 1,skillVar.Id)                  
                else                   
                end
                break
    		end
    	end
    end
    return skillUpgradeList
end

----
--连招列表
function SkillModel:setCTSkillList(list)
    self.ctSkillList = list
end

function SkillModel:getCTSkillList()
    return self.ctSkillList
end

--判断技能槽是否播放解锁特效
function SkillModel:isUnlockCTSkillList(list,chainId,idx)
    if not self.ctSkillList[chainId] then
		return
	end
	
    if self.ctSkillList[chainId][idx].is_unlock == 0 and list.is_unlock == 1 then
        dxyDispatcher_dispatchEvent(dxyEventType.ctSkill_Unlock_Effect,{chainId = chainId,idx = idx})
	end
	
end

--判断选中技能槽是否是技能链的最后一个技能槽
function SkillModel:isLastSkill(chainId,idx)
    local list = self.ctSkillList[chainId]

    for key, var in pairs(list) do
        if var.idx == idx + 1 then
            if var.is_unlock == 1 and var.skill_id ~= 0 then
                return false
            end
        end
    end
    return true
end

----
--当前选中的技能
function SkillModel:setCurSkill(data)
    self.curSkill = data
end

function SkillModel:getCurSkill()
    return self.curSkill
end

----
--当前选中的法器技能
function SkillModel:setCurSoulSkill(data)
    self.curSoulSkill = data
end

function SkillModel:getCurSoulSkill()
    return self.curSoulSkill
end

--根据法器技能ID获取该技能是否解锁
function SkillModel:getSoulSkillUnlock(skill_id)
    local list = zzm.YuanShenModel:getMagic()
    for key, var in pairs(list) do
        if var.isLock == 1 then
            if var.skillId == skill_id then
                return true
            end
        end
    end
    return false
end

--根据法器技能ID获取技能等级
function SkillModel:getSoulSkillLvById(skill_id)
    local list = zzm.YuanShenModel:getMagic()
    for key, var in pairs(list) do
        if var.isLock == 1 then
            if var.skillId == skill_id then
                return var.skillLv
            end
        end
    end
    return -1
end

return SkillModel