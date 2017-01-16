
local LoadingController = LoadingController or class("LoadingController")

SceneType = {
    MainScene = 0,
    CopyScene = 1,
    LoadingScene = 2,
}

function LoadingController:ctor()
    self:resetController()
    self:initController()
    self:registerListenner()
    self.delegate = {target = nil, func = nil, data = nil}
end

function LoadingController:setDelegate(target, func, data)
    self.delegate.target = target
    self.delegate.func = func
    self.delegate.data = data
    zzc.CopySelectController:setDelegate(target, func, data)
end

function LoadingController:setDelegate2(delegate)
    self.delegate = delegate
    zzc.CopySelectController:setDelegate2(delegate)
end

function LoadingController:resetController()
    self.m_view = nil
    self.All_Num = 3
    self.m_percent = 0
    self.m_curLoading = 0
    self.m_curIndex = 0
end

function LoadingController:initController()
    local MyTimer = require("game.utils.MyTimer")
    self.m_timer = self.m_timer or MyTimer.new()
    self.m_tipsTimer = self.m_tipsTimer or MyTimer.new()
    self.m_model = zzm.LoadingModel
    
    self.m_allResources = zzm.LoadingModel.m_allResources
    
    print("LoadingController initController")
end

function LoadingController:loading()
--    local textureCache=cc.Director:getInstance():getTextureCache()
--    textureCache:removeAllTextures()
--    local frameCache=cc.SpriteFrameCache:getInstance()
--    frameCache:removeUnusedSpriteFrames()
--    if self.m_copyData then
--        self.m_model:resetModelData(self.m_copyData.sceneID)
--    end
    zzm.LoadingModel:resetLoadingData()
    
    self.m_allResources = zzm.LoadingModel.m_allResources
    self.m_BoneNum = zzm.LoadingModel.m_BoneNum
    
    print(self.m_BoneNum .. " Num <--- Bone allResources--> Num: " .. self.m_allResources)
    
    cc.Texture2D:setDefaultAlphaPixelFormat(8)
    print("loadTexture")
    self:loadTexture()
    print("loadImage")
    self:loadImage()
    print("loadCSB")
    self:loadCSB()
    
    if self.m_allResources == 0 then
        self.m_timer = self.m_timer or MyTimer.new()
        self.m_timer:start(0.05,function()
                                    self.m_allResources = 100 
                                    self:updateLoading()
--                                    self.m_timer:stop() 
--                                    self.m_timer = nil 
                                    self:finshLoading() 
                                    end)
    end
end


function LoadingController:loadImage()
    local textureCache = cc.Director:getInstance():getTextureCache()
    local curIndex = 0
    local loadingList = zzm.LoadingModel.m_imageList
    function callBack (texture)
        curIndex = curIndex + 1
        print(string.format("loaded self.loadImage[%d] : %s",curIndex,loadingList[curIndex]))
        self:updateLoading()
        self:finshLoading()
    end
    
    for index=1, #loadingList do
        if loadingList[index]~= nil and loadingList[index] ~= "" then
            textureCache:addImageAsync(loadingList[index]..".png",callBack)
        end
    end
end

function LoadingController:loadTexture()
    local textureCache=cc.Director:getInstance():getTextureCache()
    local frameCache=cc.SpriteFrameCache:getInstance()
    --加载Plist图片
    local curIndex = 0
    local loadingList = zzm.LoadingModel.m_textureList
    
    function callBack (texture)
        curIndex = curIndex + 1
        print(string.format("loaded self.loadTexture[%d] : %s",curIndex,loadingList[curIndex]))
        frameCache:addSpriteFrames(loadingList[curIndex]..".plist")
        self:updateLoading()
        self:finshLoading()
    end

    for index=1,#loadingList do
        textureCache:addImageAsync(loadingList[index]..".png",callBack)
    end
end

function LoadingController:loadCSB()

end

function LoadingController:loadBone()
    local skeletonDataCache= mc.SkeletonDataCash:getInstance()
    --加载Bone
    local loadingList = zzm.LoadingModel.m_boneList
    if self.m_curIndex >= #loadingList then
    	return
    end
    self.m_curIndex = self.m_curIndex + 1
    skeletonDataCache:addData(loadingList[self.m_curIndex])
    print("Load Bone index :" .. self.m_curIndex .. "  path: " ..loadingList[self.m_curIndex])
end




function LoadingController:updateLoading()
    self.m_curLoading = self.m_curLoading + 1
    print("loading-----------cur: ".. self.m_curLoading .. "    all :"..self.m_allResources .. "   bone:"..self.m_BoneNum)
    self.m_percent = math.floor(self.m_curLoading / (self.m_allResources+self.m_BoneNum) * 100)
    if self.m_view and self.m_view.updateLoading then
        self.m_view:updateLoading(self.m_percent)
    end
   
end


function LoadingController:setGotoSceneType(sceneType)
    self.m_gotoSceneType = sceneType
end

function LoadingController:setCopyData(data)
    self.m_copyData = data
    zzm.LoadingModel:setCopyData(data)
end

function LoadingController:finshLoading()
    if self.m_curLoading == self.m_allResources then
        self.m_timer:stop()
        self.m_curIndex = 0
        self.m_timer:start(0.05,function()
            --add res
            self:loadBone()
            self:updateLoading()
            self:finshLoading() 
        end)
--    elseif self.m_curLoading == (self.m_allResources + self.m_BoneNum) then
--        self.m_timer:stop()
--        self.m_tipsTimer:stop()
--        self:updateLoading()
--        self:finshLoading() 
    elseif self.m_curLoading > (self.m_allResources + self.m_BoneNum) then
        cc.Texture2D:setDefaultAlphaPixelFormat(2)
        self.m_timer:stop()
        self.m_tipsTimer:stop()
        if self.m_view then
            self.m_view:updateLoading(100)
        end
        self:resetController()
        self:enterScene()
        if self.delegate and self.delegate.target and self.delegate.func then
            self.delegate.func(self.delegate.target, self.delegate.data)
            self.delegate = {target = nil, func = nil, data = nil}
        end
    end
end

function LoadingController:enterScene(sceneType)
    
    if sceneType then
        self.m_gotoSceneType = sceneType
    end
    print("------------->  ", self.m_gotoSceneType)
    print("loading enter scene")
    if self.m_gotoSceneType == SceneType.MainScene then
        --cc.Director:getInstance():getActionManager():removeAllActions()
        
--        require("game.MainScene")
--        local gameScene = MainScene.create()
--        SceneManager:enterScene(gameScene, "MainScene")
        require("game.loading.PreLoadScene")
        local preLoadScene = PreLoadScene.create()
        preLoadScene:initPreLoad("MainScene","dxyCocosStudio/csd/scene/MainScene_new.csb")
        SceneManager:enterScene(preLoadScene, "PreLoadScene")
    elseif self.m_gotoSceneType == SceneType.CopyScene then

        self:enterGameScene()
--        local chapterID = self.m_copyData.chapterID
--        local sceneID = self.m_copyData.sceneID
--        local copyType = self.m_copyData.copyType
--        local param1 = self.m_copyData.param1
--        print(sceneID)
--        print(chapterID)
--        zzc.CopySelectController:request_EnterCopyScene(copyType,chapterID, sceneID,param1)
    elseif self.m_gotoSceneType == SceneType.LoadingScene then
        local chapterID = 0
        local sceneID = 0
        local copyType = 0
        local param1 = 0
        chapterID = self.m_copyData.chapterID
        sceneID = self.m_copyData.sceneID
        copyType = self.m_copyData.copyType
        param1 = self.m_copyData.param1
        print(sceneID)
        print(chapterID)
        print(param1)
--        dxyWaitBack:show()
        zzc.CopySelectController:request_EnterCopyScene(copyType,chapterID, sceneID,param1)
--        local loadingScene = self:getScene()
--        SceneManager:enterScene(loadingScene, "LoadingScene")
    else
        print("goto scene type error!")
    end
end

function LoadingController:randomTips()
    local tipsList = zzm.LoadingModel.m_tipsList
    local index = math.random(1,#tipsList)
    if self.m_view and self.m_view.updateLoadingTips then
        self.m_view:updateLoadingTips(tipsList[index].Content)
    end
    
end

function LoadingController:getScene(sceneType)
    self.m_gotoSceneType = sceneType
    if self.m_view == nil then
        require("game.loading.LoadingScene")
        self.m_view = LoadingScene.create()
		self:randomTips()
    end
    
    self.m_tipsTimer:start(0.5, function ()
    	self:randomTips()
    end)
    
--    local chapterID = self.m_copyData.chapterID
--    local sceneID = self.m_copyData.sceneID
--    local copyType = self.m_copyData.copyType
--    local param1 = self.m_copyData.param1
--    print(sceneID)
--    print(chapterID)
--    zzc.CopySelectController:request_EnterCopyScene(copyType,chapterID, sceneID,param1)
    self:loading()
    
    return self.m_view
end

function LoadingController:enterGameScene()
    require("game.GameScene")
    local gameScene = GameScene.create()
    --        gameScene:setStartAndEndTalkId(1001,1002)
    --        gameScene._gameSceneId = 10001
    local startTalk = self.m_copyData.startTalkID
    local endTalk = self.m_copyData.endTalkID
    local chapterID = self.m_copyData.chapterID
    local sceneID = self.m_copyData.sceneID
    local copyType = self.m_copyData.copyType
    print(startTalk)
    print(endTalk)
    print(sceneID)
    print(chapterID)
    
    zzm.GuideModel._isNoTalk = false
    if startTalk == 0 then
    	zzm.GuideModel._isNoTalk = true
    end
    gameScene._startId = self.m_copyData.startId
    gameScene._gameSceneId = sceneID
    gameScene:setChapterId(chapterID)
    gameScene:setBattleSceneId(sceneID)
    gameScene:setGameSceneType(copyType)
    gameScene:initLayers()
    gameScene:startGame()
    gameScene:setStartAndEndTalkId(startTalk,endTalk)
    zzm.GuideModel._currentCopyId = sceneID
    --zzc.CopySelectController:request_EnterCopyScene(0,chapterID, sceneID)
    SceneManager:enterScene(gameScene, "GameScene")

end
    
-----------------------------------------------------------------
--Network 
--
--initNetwork
function LoadingController:registerListenner()
    _G.NetManagerLuaInst:registerListenner(NetEventType.Rec_Copy_EnterCopy_Return,self)
--    _G.NetManagerLuaInst:registerListenner(11610,self)
end

function LoadingController:unregisterListenner()
    _G.NetManagerLuaInst:unregisterListenner(NetEventType.Rec_Copy_EnterCopy_Return,self)
--    _G.NetManagerLuaInst:unregisterListenner(11610,self)
end

-----------------------------------------------------------------
--Receive
function LoadingController:dealMsg(msg)
    local cmdType = msg:getpacketCmdType() 
    -- 默认返回false ，表示不中断读取下一个msg
    if cmdType == NetEventType.Rec_Copy_EnterCopy_Return then
        local type = msg:readByte()
        local god = msg:readInt()
        zzm.LoadingModel:addGodId(god)
        --self:loading()
        --self:enterGameScene()
        print("Copy Type : " .. type)
        dxyWaitBack:close()
        local loadingScene = self:getScene()
        SceneManager:enterScene(loadingScene, "LoadingScene")
        print("GetMsg~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~4007")
        --接收副本结果返回
        if zzm.GroupModel.isEnterByGroup then
            zzm.GroupModel.isInTheTeam = true
        end
        zzc.GroupFuncCtrl:cleanTowerLayer()
    
--    elseif cmdType == 11610 then
--        print("GetMsg~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~11610")
--    
    end   
    return false
end


return LoadingController
