---
--@module HeroSkill
HeroSkill = HeroSkill or class("HeroSkill")

function HeroSkill:ctor()
    self._config = {}
    self._config = luacf.HeroSkill.HeroSkillConfig.HeroSkill
end

---
--@function [parent=#HeroSkill] getHeroSkillConfig
--@param self
function HeroSkill:getHeroSkillConfig()
    return self._config
end

---
--@function [parent=#HeroSkill] getHeroSkillConfigByRole
--@param self
--@param type herotype_id 
function HeroSkill:getHeroSkillConfigByRole(type)
    for i = 1 ,#self._config do 
        if self._config[i].JobType == type then
            return self._config[i].SkillList
        end
    end
end

---
--@function [parent=#HeroSkill] getHeroBaseSkillList
--@param self
--@param type herotype_id
function HeroSkill:getHeroBaseSkillList(type)
    local heroSkill = {}
    local skillList = {}
    heroSkill = self:getHeroSkillConfigByRole(type)
    for i = 1,#heroSkill do
        if heroSkill[i].SkillType == 1 then	
            skillList[#skillList+1] = SkillConfig:getSkillConfigById(heroSkill[i].SkillId)
        end
    end
    return skillList
end

---
--@function [parent=#HeroSkill] getHeroSoulSkillList
--@param self
--@param type herotype_id
function HeroSkill:getHeroSoulSkillList(type)
    local heroSkill = {}
    local skillList = {}
    heroSkill = self:getHeroSkillConfigByRole(type)
    for i = 1,#heroSkill do
        if heroSkill[i].SkillType == 2 then 
            skillList[#skillList+1] = SkillConfig:getSkillConfigById(heroSkill[i].SkillId)
        end
    end
    return skillList
end

--获取基础技能位置ID
function HeroSkill:getHeroBaseSkillPos(type,skillId)
	local heroSkill = {}
    heroSkill = self:getHeroSkillConfigByRole(type)
    for key, var in pairs(heroSkill) do
    	if skillId == var.SkillId then
    		return key
    	end
    end
    return nil
end

return HeroSkill