local LoadingModel = class("LoadingModel")
LoadingModel.__index = LoadingModel

function LoadingModel:ctor()
    self.m_tipsList = {}
    self.m_imageList = {}
    self.m_textureList = {}
    self.m_CSBList = {}
    self.m_boneList = {}
    self._loadGodId = {}
    
    self.m_curIndex = 0
    self.m_allResources = 0
    
    self.loadExtraCallBack = nil
    
    self:initModel()
    
    self:resetModel()
end

function LoadingModel:initModel()
    self.m_tipsList = TipsConfigProvider:getTipsList()
end

function LoadingModel:resetModel()
    self.m_imageList = {}
    self.m_textureList = {}
    self.m_CSBList = {}
    self.m_boneList = {}
    self.m_curIndex = 0
    self.m_allResources = 0
    self.loadExtraCallBack = nil
end

function LoadingModel:setCopyData(data)
    self.m_copyData = data
end


function LoadingModel:resetLoadingData()
    self:resetModel()
    local copyId = self.m_copyData.chapterID
    local sceneId = self.m_copyData.sceneID
    self:loadSceneData(sceneId)
    self:loadMonsterData(sceneId)
    self:loadBone(sceneId)
    self.m_allResources = #self.m_imageList + #self.m_textureList + #self.m_CSBList
    self.m_BoneNum = #self.m_boneList
end

function LoadingModel:loadBone(sceneId)
    if sceneId == nil then
        print("Error Load Bone Error Scene Id , sceneId is nil !")
        return
    end
    mc.ResMgr:getInstance():collectBoneFile(sceneId)
    local bonePath = mc.ResMgr:getInstance():getOneBoneFile()
    local num = 1
    while bonePath do
        local temp = dxyStringSplit(bonePath, ".")
        self.m_boneList[num] = temp[1]
        print(num .. "  bonePath------" .. bonePath)
        num = num + 1
        bonePath = mc.ResMgr:getInstance():getOneBoneFile()
    end
    self:findGodRes()
end


function LoadingModel:addGodId(id)
    if id == nil or id == 0 then
    	return
    end
    if self._loadGodId == nil then
    	self._loadGodId = {}
    end
    array_addObject(self._loadGodId,id)
end

function LoadingModel:findGodRes()
    self:addGodId(_G.GeneralData.Current)
    local list = luacf.GodGenerals.GodGeneralsConfig.GodGeneralsGroup.GodGenerals
    for key, var in ipairs(list) do
        local index = array_findObject(self._loadGodId,var.Id)
        if index ~= 0 then
        	self:findGodModel(var.Model)
        end
--        if var.Quality >= 3 then
--            local name = var.Name
--            --print("find God Name  " .. name)
--            self:findGodModel(var.Model)
--        end
    end
end

function LoadingModel:findGodModel(id)
    if id == nil then
    	return
    end
    local list = luacf.Ossature.OssatureConfig.Ossature
    for key, var in ipairs(list) do
        if var.Id == id then
            array_addObject(self.m_imageList,var.Ossature)
            array_addObject(self.m_boneList,var.Ossature)
            return
        end
    end
    print("Error not find God Bone , id is :" .. id)
end

function LoadingModel:loadCSB(csbPath)
    if csbPath == nil then
        print("Error Load CSB Error Path , path is nil !")
    	return
    end
    print("LoadCSB Path: " .. csbPath)
    mc.ResMgr:getInstance():collectPlist(csbPath)
    local pilstPath = mc.ResMgr:getInstance():getOnePlist()
    local num = 1
    while pilstPath do
        local temp = dxyStringSplit(pilstPath, ".")
        self.m_textureList[num] = temp[1]
        print(num .. " Texture------" .. pilstPath)
        num = num + 1
        pilstPath = mc.ResMgr:getInstance():getOnePlist()
    end
    if num == 1 then
        print("Error Load CSB has not plist !")
    end
end

function LoadingModel:loadMonsterData(copyId)
    -- Monster
    local monsterIDs = self:findMonsterIDs(copyId)
    self:loadMonsterAnimation(monsterIDs)
    local aiIDs = self:findAIIDs(monsterIDs)
    self.skillIDs = {}
    self.animationIDs = {}
    self.bulletIDs = {}
    self:findSkillsByAI(aiIDs)
    self:findAllAnimationIDs()
end

function LoadingModel:findAllAnimationIDs()
    for key, var in ipairs(self.skillIDs) do
        self:findAnimationID(var)
    end
end

function LoadingModel:findAnimationID(skillID)
    local list = luacf.Skill.SkillConfig.SkillBase
    for key, var in ipairs(list) do
        if var.Id == skillID then
            local id = var.SonSkill.AnimationId
            print("find Animation ID OK " .. id)
            self:loadSkillAnimation(id)
            return
        end
    end
    print("find Animation ID Error skillID: " .. skillID)
end

function LoadingModel:loadSkillAnimation(animationId)
    
    if animationId ~=nil and array_findObject(self.animationIDs, animationId) == 0 then
        print("loadSkillAnimation AnimationID  " .. animationId)
        array_addObject(self.animationIDs,animationId)
        local animation = self:getSkillAnimation(animationId)
        if animation then
            if animation.SkillEntityConfig then
                local config1 = dxyConfig_toList(animation.SkillEntityConfig.SkillEntity)
                for key, var in ipairs(config1) do
                    print("Res1 ---> " .. var.Res)
                    array_addObject(self.m_imageList,var.Res)
                    self:loadSkillAnimation(id)
                end
            end
            if animation.SkillEffectEntityData then
                local config2 = dxyConfig_toList(animation.SkillEffectEntityData)
                for key, var in ipairs(config2) do
                    print("Res2 ---> " .. var.Res)
                    array_addObject(self.m_imageList,var.Res)
                end
            end
            if animation.SkillHitEffect then
                local config3 = dxyConfig_toList(animation.SkillHitEffect.HitEffect)
                for key, var in ipairs(config3) do
                    print("Res3 ---> " .. var.Res)
                    array_addObject(self.m_imageList,var.Res)
                end
            end
            if animation.BulletDataConfig then
                local config4 = dxyConfig_toList(animation.BulletDataConfig.BulletData)
                for key, var in ipairs(config4) do
                    print("BulletId ---> " .. var.BulletId)

                end
            end
        end
    end
end

function LoadingModel:loadBulletAnimation(bulletId)

    if bulletId ~=nil and array_findObject(self.bulletIDs, bulletId) == 0 then
        print("loadBulletAnimation bulletId  " .. bulletId)
        array_addObject(self.bulletIDs,bulletId)
        local bullet = self:getBulletAnimation(animationId)
        if bullet then
            if bullet.Res then
                print("Res1 ---> " .. bullet.Res)
                array_addObject(self.m_imageList,bullet.Res)
            end
            if bullet.SkillHitEffect then
                local config2 = dxyConfig_toList(bullet.SkillHitEffect.HitEffect)
                for key, var in ipairs(config2) do
                    print("Res2 ---> " .. var.Res)
                    array_addObject(self.m_imageList,var.Res)
                end
            end
            if bullet.SkillEffectEntityData then
                local config3 = dxyConfig_toList(bullet.SkillEffectEntityData)
                for key, var in ipairs(config3) do
                    print("Res3 ---> " .. var.Res)
                    array_addObject(self.m_imageList,var.Res)
                end
            end
            if bullet.SkillEntityConfig then
                local config4 = dxyConfig_toList(bullet.SkillEntityConfig.SkillEntity)
                for key, var in ipairs(config4) do
                    print("Res1 ---> " .. var.Res)
                    array_addObject(self.m_imageList,var.Res)
                    self:loadSkillAnimation(var.SkillId)
                end
            end
        end
    end
end

function LoadingModel:getBulletAnimation(bulletId)
    local list = luacf.Bullet.BulletConfig.Bullet
    for key, var in ipairs(list) do
        if var.BulletId == bulletId then
            return var
        end
    end
    print("getBulletAnimation Error bulletId: " .. bulletId)
end

function LoadingModel:getSkillAnimation(animationId)
    local list = luacf.SkillAnimation.SkillAnimationConfig.SkillAnimation
    for key, var in ipairs(list) do
        if var.Id == animationId then
            return var
        end
    end
    print("getSkillAnimation Error animationId: " .. animationId)
end

function LoadingModel:findAIIDs(monsterIDs)
    -- Monster AI
    local ret = {}
    if not monsterIDs then
        return ret
    end
    for key, var in ipairs(monsterIDs) do
        local monster = self:findMonster(var)
        print("AiID ---------->>> " .. monster.AiId)
        array_addObject(ret,monster.AiId)
    end
    return ret
end

function LoadingModel:findAI(aiID)
    print("findAI ---------- " .. aiID)
    local list = luacf.AIBehaviorTree.AIBehaviorTree.Tree
    for key, var in ipairs(list) do
        if var.Id == aiID then
            print("findAI OK " .. aiID)
            return var
        end
    end
end

function LoadingModel:findSkillsByAI(aiIDs)
    -- Monster Skill
    
    for key, var in ipairs(aiIDs) do
        local AI = self:findAI(var)
        self:findActionType11(AI)
    end
    --return ret
end

function LoadingModel:findActionType11(AI)
    if AI.Node then
        for key, var in ipairs(AI.Node) do
            if var.Node then
                self:findActionType11(var)
            else
                if var.ActionType and var.ActionType == 11 and var.StrParam1 and var.StrParam1 ~= "" then
                    print("find Skill ID ------:" .. var.StrParam1)
                    array_addObject(self.skillIDs,var.StrParam1)
                end
            end
        end
    end
end

function LoadingModel:loadSkillByAI(aiID)
    -- Monster Skill
    --local ret = {}
    local list = luacf.Ossature.OssatureConfig.Ossature
    for key, var in ipairs(monsterIDs) do
        local monster = self:findMonster(var)
        for key, var in ipairs(list) do
            if var.Id == monster.ResID then
                --array_addObject(ret,var.Ossature)
                array_addObject(self.m_imageList,var.Ossature)
                break
            end
        end
    end
    --return ret
end

function LoadingModel:loadMonsterAnimation(monsterIDs)
    -- Monster Animation
    --local ret = {}
    if not monsterIDs then
        return
    end 
    local list = luacf.Ossature.OssatureConfig.Ossature
    for key, var in ipairs(monsterIDs) do
        local monster = self:findMonster(var)
        for key, var in ipairs(list) do
            if var.Id == monster.ResID then
                --array_addObject(ret,var.Ossature)
                array_addObject(self.m_imageList,var.Ossature)
                break
            end
        end
    end
    --return ret
end

function LoadingModel:loadSceneData(sceneID)
    -- Map CSB
    local mapCsb = self:findMapCSB(sceneID)
    self:loadCSB(mapCsb)
--    mapCsb = "res/dxyCocosStudio/csd/ui/general/FragmentMsg.csb"
--    self:loadCSB(mapCsb)
end

function LoadingModel:findMonster(monsterId)
    print("findMonster --------MonsterId :" .. monsterId)
    local list = luacf.Monster.MonsterConfig.Monster
    for key, var in ipairs(list) do
        if var.Id == monsterId then
            return var
        end
    end
end

function LoadingModel:findCopy(copyId)
    print("findCopy --------copyId :" .. copyId)
    local list = luacf.Copy.CopyConfig.Scene
    for key, var in ipairs(list) do
        if var.Id == copyId then
            return var
        end
    end
end

function LoadingModel:findMonsterIDs(copyId)
    print("findMonster --------copyId :" .. copyId)
    local copy = self:findCopy(copyId)
    if copy == nil then
        print("No find Copy!!!")
        return
    end
    local monsterTrigger = copy.MonsterTrigger
    if monsterTrigger == nil then
        print("No find monsterTrigger!!!")
    	return
    end
    monsterTrigger = dxyConfig_toList(monsterTrigger)
    local ret = {}
    list = luacf.MonsterGroup.MonsterGroupConfig.MonsterGroup
    for key, var in ipairs(monsterTrigger) do
        local groupId = var.MonsterGroupId
        print("monsterTrigger MonsterGroupId --------> " .. groupId)
        for key, var in ipairs(list) do
            if var.Id == groupId then
                local monsters = dxyConfig_toList(var.Monstre)
                for key, var in ipairs(monsters) do
                    print("MonsterId -> " .. var.MonsterId)
                    --table.insert(ret,#ret+1,var.MonsterId)
                    array_addObject(ret,var.MonsterId)
                end
                break
            end
        end
    end
    return ret
end

function LoadingModel:findMapCSB(copyId)
    print("findMapCSB --------copyId :" .. copyId)
    local copy = self:findCopy(copyId)
    if copy == nil then
        print("No find Copy!!!")
        return
    end
    local sceneID = copy.SceneId
    local list = luacf.Scenes.ScenesConfig.Scenes
    for key, var in ipairs(list) do
        if var.ID == sceneID then
            print("CSB Path :" .. var.ResId)
            return var.ResId
        end
    end
    print("No find Map CSB!!! sceneID : " .. sceneID)
end

return LoadingModel


