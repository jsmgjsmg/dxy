CombatpreloadScene = CombatpreloadScene or class("CombatpreloadScene",function()
    return cc.Scene:create()
end)

CombatpreloadType = {
    pve = 1,
    pvp = 2
}

function CombatpreloadScene:create()
    local scene = CombatpreloadScene:new()
    return scene
end

function CombatpreloadScene:ctor()
    self._csb = nil
    self.loadingTips = nil
    self.m_curLoading = 0
    self.m_percent = 0

    self.m_plistCur = 1
    self.m_pngCur = 1
    self.m_boneCur = 1
    
    self.m_myPro = 0
    self.m_rivalPro = 0

    self:initUI()
end

function CombatpreloadScene:WhenClose()

end

function CombatpreloadScene:initUI()
    self._csb = cc.CSLoader:getInstance():createNodeWithFlatBuffersFile("dxyCocosStudio/csd/scene/LoadingScene.csb")
    self:addChild(self._csb)

    self.visibleSize = cc.Director:getInstance():getVisibleSize()
    self.origin = cc.Director:getInstance():getVisibleOrigin()

    local node = self._csb:getChildByName("LoadingNode")
    node:setPositionX(self.visibleSize.width / 2 + self.origin.x)
    self.loadingTips = node:getChildByName("LoadingTips")
    self.loadingBar = node:getChildByName("LoadingBar")
    self.loadingPercent = node:getChildByName("LoadingPercent")

    self:updateLoadingBar(0)

    mc.ResMgr:getInstance():releasedALLRes()

    self._tipsList = TipsConfigProvider:getTipsList()
    local index = math.random(1,#self._tipsList)

    self:updateLoadingTips(self._tipsList[index].Content)
end

--场景id   BOSSid   怪物列表   战斗类型    对手职业
function CombatpreloadScene:initPreLoad(sceneId,bossId,moList,type,rivalPro)
    self.m_textureList = {}
    self.m_imageList = {}
    math.randomseed(os.time())
    --    self._totalPercent = 85 + math.random(0,10)

    self.m_sceneId = sceneId
    if sceneId == 0 then
        self.m_sceneId = 10112
    end
    
    --战斗类型
    self.m_type = type
    
    local role = zzm.CharacterModel:getCharacterData()
    local enCAT = enCharacterAttrType
    self.m_myPro = role:getValueByType(enCAT.PRO)
    self.m_rivalPro = rivalPro

    self._pngListIndex = 1

    self:loadSceneData(self.m_sceneId)
    self:loadAllSkill(bossId,moList)
    self:loadBoneData(bossId,moList)

    self.m_allResources = #self.m_textureList + #self.m_imageList

    cc.Texture2D:setDefaultAlphaPixelFormat(8)

    local tipCnt = 0
    -- timer
    local function tick(dt)

        tipCnt = tipCnt + dt
        if tipCnt >= 1.15 then
            tipCnt = tipCnt - 1.15

            local index = math.random(1,#self._tipsList)
            self:updateLoadingTips(self._tipsList[index].Content)
        end

        local ra = math.random(1,3)

        if ra ~= 1 then
            if self.m_curLoading >= (self.m_allResources + self.m_BoneNum) then
                print("载入完成")
                self:finshLoading()
            else
                --                print("loadTexture")
                self:loadTexture()
                --                print("loadImage")
                --                self:loadImage()
                --                self:loadBone()
            end

        end

    end

    local MyTimer = require("game.utils.MyTimer")
    self.m_timer = self.m_timer or MyTimer.new()
    self.m_timer:start(0.03,tick)

end

function CombatpreloadScene:loadTexture()
    local frameCache=cc.SpriteFrameCache:getInstance()
    --加载Plist图片
    local loadingList = self.m_textureList

    if loadingList[self.m_plistCur]~= nil and loadingList[self.m_plistCur] ~= "" then
        frameCache:addSpriteFrames(loadingList[self.m_plistCur])
        print(string.format("loaded self.loadTexture[%d] : %s",self.m_plistCur,loadingList[self.m_plistCur]))
        self.m_plistCur = self.m_plistCur + 1
        self:updateLoading()
    else
        self:loadImage()
    end
    --    end
end

function CombatpreloadScene:loadImage()
    local skeletonDataCache= mc.SkeletonDataCash:getInstance()
    local loadingList = self.m_imageList

    if loadingList[self.m_pngCur]~= nil and loadingList[self.m_pngCur] ~= "" then
        if loadingList[self.m_pngCur] ~= 0 then
            skeletonDataCache:addData(loadingList[self.m_pngCur])
            print(string.format("loaded self.loadImage[%d] : %s",self.m_pngCur,loadingList[self.m_pngCur]))
        end
        self.m_pngCur = self.m_pngCur + 1
        self:updateLoading()
    else
        self:loadBone()
    end
    --    end
end

function CombatpreloadScene:loadBone()
    local skeletonDataCache= mc.SkeletonDataCash:getInstance()
    --加载Bone
    local loadingList = self.m_boneList

    if not loadingList[self.m_boneCur] then
        return
    end

    skeletonDataCache:addData(loadingList[self.m_boneCur])
    print("Load Bone index :" .. self.m_boneCur .. "  path: " ..loadingList[self.m_boneCur])
    self:updateLoading()

    self.m_boneCur = self.m_boneCur + 1
end

function CombatpreloadScene:updateLoading()
    self.m_curLoading = self.m_curLoading + 1
    print("loading-----------cur: ".. self.m_curLoading .. "    all :"..self.m_allResources .. "   bone:"..self.m_BoneNum)
    self.m_percent = math.floor(self.m_curLoading / (self.m_allResources + self.m_BoneNum) * 100)
    self:updateLoadingBar(self.m_percent)
end

function CombatpreloadScene:finshLoading()

    cc.Texture2D:setDefaultAlphaPixelFormat(2) -- 设置默认图片格式为 RGBA8888

    self.m_timer:stop()

    require("game.GameScene")
    local gameScene = GameScene.create()

    if self.m_type == CombatpreloadType.pve then
        gameScene._startId = 0
        gameScene._gameSceneId = self.m_sceneId --90101
        gameScene:setChapterId(0)
        gameScene:setBattleSceneId(gameScene._gameSceneId)
        gameScene:setGameSceneType(16)
        gameScene:initLayers()
        gameScene:startGame()
        gameScene:setStartAndEndTalkId(0,0)
    elseif self.m_type == CombatpreloadType.pvp then
        gameScene._startId = 0
        gameScene._gameSceneId = self.m_sceneId --90101
        gameScene:setChapterId(0)
        gameScene:setBattleSceneId(gameScene._gameSceneId)
        gameScene:setGameSceneType(17)
        gameScene:initLayers()
        gameScene:startGame()
        gameScene:setStartAndEndTalkId(0,0)
    end
    
    SceneManager:enterScene(gameScene, "GameScene")
end

--收集骨骼资源列表
function CombatpreloadScene:loadBoneData(bossId,moList)
    self.m_boneList = {}
    local data = nil
    for index=1, 3 do
        if index == self.m_myPro or index == self.m_rivalPro then       	
            data = HeroConfig:getOssatureById(index)
            array_addObject(self.m_boneList,data.Ossature)
        end
    end

    local monsterList = luacf.Monster.MonsterConfig.Monster
    local ossatureList = luacf.Ossature.OssatureConfig.Ossature

    if bossId and bossId ~= 0 then
        for key, var in pairs(monsterList) do
            if var.Id == bossId then
                for key2, var2 in pairs(ossatureList) do
                    if var2.Id == var.ResID then
                        array_addObject(self.m_boneList,var2.Ossature)
                        break
                    end
                end
                break
            end
        end
    end

    if moList and #moList ~= 0 then
        for index=1, #moList do
            for key, var in pairs(monsterList) do
                if var.Id == moList[index] then
                    for key2, var2 in pairs(ossatureList) do
                        if var2.Id == var.ResID then
                            array_addObject(self.m_boneList,var2.Ossature)
                            break
                        end
                    end
                    break
                end
            end
        end
    end

    self.m_BoneNum = #self.m_boneList
end

--收集技能资源列表
function CombatpreloadScene:loadAllSkill(bossId,moList)
    self.skillList = {}
    local oneHeroSkillList = {}
    local allHeroSkillList = luacf.HeroSkill.HeroSkillConfig.HeroSkill
    for index=1, #allHeroSkillList do
        if index == self.m_myPro or index == self.m_rivalPro then       	
            oneHeroSkillList = allHeroSkillList[index].SkillList
            self:findSkill(oneHeroSkillList)
        end
    end


    local monsterList = luacf.Monster.MonsterConfig.Monster
    local ossatureList = luacf.Ossature.OssatureConfig.Ossature

    if bossId and bossId ~= 0 then
        local bossAis = {}
        for key, var in pairs(monsterList) do
            if bossId == var.Id then
                array_addObject(bossAis,var.AiId)
            end
        end
        self:findSkillsByAI(bossAis)
    end

    if moList and #moList ~= 0 then
        local moAis = {}
        for index=1, #moList do
            for key, var in pairs(monsterList) do
                if var.Id == moList[index] then
                    array_addObject(moAis,var.AiId)
                end
            end
        end
        self:findSkillsByAI(moAis)
    end

    for index=1, #self.skillList do
        self:loadSkillAnimation(self.skillList[index])
    end

end

function CombatpreloadScene:findAI(aiID)
    print("findAI ---------- " .. aiID)
    local list = luacf.AIBehaviorTree.AIBehaviorTree.Tree
    for key, var in ipairs(list) do
        if var.Id == aiID then
            print("findAI OK " .. aiID)
            return var
        end
    end
end

function CombatpreloadScene:findSkillsByAI(aiIDs)
    -- Monster Skill

    for key, var in ipairs(aiIDs) do
        local AI = self:findAI(var)
        self:findActionType11(AI)
    end
    --return ret
end

function CombatpreloadScene:findActionType11(AI)
    if AI.Node then
        for key, var in ipairs(AI.Node) do
            if var.Node then
                self:findActionType11(var)
            else
                if var.ActionType and var.ActionType == 11 and var.StrParam1 and var.StrParam1 ~= "" then
                    print("find Skill ID ------:" .. var.StrParam1)
                    array_addObject(self.skillList,var.StrParam1)
                end
            end
        end
    end
end


function CombatpreloadScene:findSkill(skillList)
    for key, var in pairs(skillList) do
        array_addObject(self.skillList,var.SkillId)
    end
end

function CombatpreloadScene:getSkillAnimation(animationId)
    local list = luacf.SkillAnimation.SkillAnimationConfig.SkillAnimation
    for key, var in ipairs(list) do
        if var.Id == animationId then
            return var
        end
    end
    print("getSkillAnimation Error animationId: " .. animationId)
end

function CombatpreloadScene:loadSkillAnimation(animationId)
    if animationId ~=nil then
        print("loadSkillAnimation AnimationID  " .. animationId)
        --        array_addObject(self.animationIDs,animationId)
        local animation = self:getSkillAnimation(animationId)
        if animation then
            if animation.SkillEntityConfig then
                local config1 = dxyConfig_toList(animation.SkillEntityConfig.SkillEntity)
                for key, var in ipairs(config1) do
                    print("Res1 ---> " .. var.Res)
                    array_addObject(self.m_imageList,var.Res)
                    --                    self:loadSkillAnimation(id)
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

--收集场景资源列表
function CombatpreloadScene:loadSceneData(sceneId)
    -- Map CSB
    local mapCsb = self:findMapCSB(sceneId)
    self:loadCSB(mapCsb)
end

function CombatpreloadScene:findMapCSB(copyId)
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

function CombatpreloadScene:findCopy(copyId)
    print("findCopy --------copyId :" .. copyId)
    local list = luacf.Copy.CopyConfig.Scene
    for key, var in ipairs(list) do
        if var.Id == copyId then
            return var
        end
    end
end

function CombatpreloadScene:loadCSB(csbPath)
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

function CombatpreloadScene:updateLoadingBar(percent)
    if percent >= 95 then
        self.loadingPercent:setString("95%")
        self.loadingBar:setPercent(95)
        return
    end
    self.loadingPercent:setString(percent.."%")
    self.loadingBar:setPercent(percent)
end

function CombatpreloadScene:updateLoadingTips(tips)
    self.loadingTips:setString(tips)
end