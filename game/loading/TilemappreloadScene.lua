TilemappreloadScene = TilemappreloadScene or class("TilemappreloadScene",function()
    return cc.Scene:create()
end)

function TilemappreloadScene:create()
    local scene = TilemappreloadScene:new()
    return scene
end

function TilemappreloadScene:ctor()
    self._csb = nil
    self.loadingTips = nil
    self.m_curLoading = 0
    self.m_percent = 0

    self.m_plistCur = 1
    self.m_pngCur = 1
    self.m_boneCur = 1
    
    self:initUI()
end

function TilemappreloadScene:WhenClose()

end

function TilemappreloadScene:initUI()
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

function TilemappreloadScene:initPreLoad(csbPath)
    self.m_textureList = {}
    self.m_imageList = {}
    math.randomseed(os.time())
    --    self._totalPercent = 85 + math.random(0,10)

    self._pngListIndex = 1

    self:loadSceneData(csbPath)
--    self:loadAllSkill()
    self:loadPngData()
    self:loadBoneData()

    self.m_allResources = #self.m_textureList + #self.m_imageList

    cc.Texture2D:setDefaultAlphaPixelFormat(8)
--    print("loadTexture")
--    self:loadTexture()
--    print("loadImage")
--    self:loadImage()

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

function TilemappreloadScene:loadTexture()
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
end

function TilemappreloadScene:loadImage()
    local textureCache=cc.Director:getInstance():getTextureCache()
    local loadingList = self.m_imageList
    
    if loadingList[self.m_pngCur]~= nil and loadingList[self.m_pngCur] ~= "" then
        if loadingList[self.m_pngCur] ~= 0 then         
            textureCache:addImage(loadingList[self.m_pngCur])
            print(string.format("loaded self.loadImage[%d] : %s",self.m_pngCur,loadingList[self.m_pngCur]))
        end
        self.m_pngCur = self.m_pngCur + 1
        self:updateLoading()
    else
        self:loadBone()
    end
end

function TilemappreloadScene:loadBone()
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

function TilemappreloadScene:updateLoading()
    self.m_curLoading = self.m_curLoading + 1
    print("loading-----------cur: ".. self.m_curLoading .. "    all :"..self.m_allResources .. "   bone:"..self.m_BoneNum)
    self.m_percent = math.floor(self.m_curLoading / (self.m_allResources + self.m_BoneNum) * 100)
    self:updateLoadingBar(self.m_percent)
end

function TilemappreloadScene:finshLoading()

    cc.Texture2D:setDefaultAlphaPixelFormat(2) -- 设置默认图片格式为 RGBA8888
    
    if zzc.StepTwoController._haveData then   	
        self.m_timer:stop()
        require("game.tilemap.immortalfield.view.ImmortalMainLayer")
        local scene = ImmortalMainLayer:create()
        SceneManager:enterScene(scene, "ImmortalMainScene")
        zzm.ImmortalFieldModel:showTips()
    end

end

--收集骨骼资源列表
function TilemappreloadScene:loadBoneData()
    self.m_boneList = {}
    local data = nil
    for index=1, 3 do
        data = HeroConfig:getOssatureById(index)
        array_addObject(self.m_boneList,data.Ossature)
    end
    self.m_BoneNum = #self.m_boneList
end

--收集png资源列表
function TilemappreloadScene:loadPngData()
    array_addObject(self.m_imageList,"dxyCocosStudio/csd/ui/tilemap_tmx/base.png")
    array_addObject(self.m_imageList,"dxyCocosStudio/csd/ui/tilemap_tmx/city.png")
    array_addObject(self.m_imageList,"dxyCocosStudio/csd/ui/tilemap_tmx/cloud.png")
    array_addObject(self.m_imageList,"dxyCocosStudio/csd/ui/tilemap_tmx/object.png")
end

--收集场景资源列表
function TilemappreloadScene:loadSceneData(mapCsb)
    -- Map CSB
--    local mapCsb = self:findMapCSB(sceneId)
    self:loadCSB(mapCsb)
end

function TilemappreloadScene:loadCSB(csbPath)
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

function TilemappreloadScene:updateLoadingBar(percent)
    self.loadingPercent:setString(percent.."%")
    self.loadingBar:setPercent(percent)
end

function TilemappreloadScene:updateLoadingTips(tips)
    self.loadingTips:setString(tips)
end