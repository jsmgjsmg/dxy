---
--@module CTSkillConfig
CTSkillConfig = CTSkillConfig or class("CTSkillConfig")

function CTSkillConfig:ctor()
    self._config = luacf.SkillChain.SkillChainConfig.SkillChain
end

---
--@function [parent=#CTSkillConfig] getCTSkillConfig
--@param self
function CTSkillConfig:getCTSkillConfig()
    return self._config
end

---
--@function [parent=#CTSkillConfig] getCTSkillById
--@param self
--@param id CTSkill_id
function CTSkillConfig:getCTSkillById(id)
    for i = 1 , #self._config do
        if i == id then
            return self._config[i]
        end
    end
    return nil
end

---
--@function [parent=#CTSkillConfig] getCTSkillByIdAndinx
--@param self
--@param id id 第几条技能链
--@param inx inx 第几个槽
function CTSkillConfig:getCTSkillByIdAndinx(id,inx)
    local tab = self:getCTSkillById(id).Skill
    for i = 1,#tab do
        if i == inx then
            return tab[i]
        end
    end
    return nil
end

return CTSkillConfig