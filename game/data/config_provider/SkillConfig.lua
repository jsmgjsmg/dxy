---
--@module SkillConfig
SkillConfig = SkillConfig or class("SkillConfig")

function SkillConfig:ctor()
    self._config = luacf.Skill.SkillConfig.SkillBase
end

---
--@function [parent=#SkillConfig] getSkillConfig
--@param self
function SkillConfig:getSkillConfig()
    return self._config
end

---
--@function [parent=#SkillConfig] getSkillConfigById
--@param self
--@param skill_id number
function SkillConfig:getSkillConfigById(skill_id)
    if skill_id == nil then return end
    for i=1 , #self._config do
        if self._config[i].Id == skill_id then
            return self._config[i]
        end
    end
end

---
--@function [parent=#SkillConfig] getNextLvSkill
--@param self
--@param id id
--@param lv number
function SkillConfig:getNextLvSkill(id,lv)
    local _data = self:getSkillConfigById(id)
    local lvdata = _data.SonSkill.SkillLv
    for i = 1 , #lvdata do
        if lvdata[i].Lv == lv then
            return lvdata[i+1]
        end 
    end
    return nil
end

---
--@function [parent=#SkillConfig] getSkillByLv
--@param self
--@param id id
--@param lv number
function SkillConfig:getSkillByLv(id,lv)
    local _data = self:getSkillConfigById(id)
    local lvdata = dxyConfig_toList(_data.SonSkill.SkillLv)
    local curLv = lv or 1
    local maxLv = 0
    for key, var in pairs(lvdata) do
    	if var.Lv > maxLv then
    	   maxLv = var.Lv
    	end
    end
    curLv = curLv > maxLv and maxLv or curLv
    for i = 1 , #lvdata do
        if lvdata[i].Lv == curLv then
            return lvdata[i]
        end 
    end
    return nil
end

return SkillConfig