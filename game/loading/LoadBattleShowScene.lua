require("game.utils.GetIntPart")

LoadBattleShowScene = LoadBattleShowScene or class("LoadBattleShowScene",function()
    return cc.Scene:create()
end)

function LoadBattleShowScene.create()
    local scene = LoadBattleShowScene.new()
    return scene
end

function LoadBattleShowScene:ctor()
    self.loadingTips = nil
    self.loadingBar = nil
    self.loadingPercent = nil
    
	self._preLoadSceneName = nil
	
	self._mainSceneStep = 1
	
    self:initUI()
end

function LoadBattleShowScene:WhenClose()

	
end

function LoadBattleShowScene:initUI()
    self._csbGameSceneNode = cc.CSLoader:getInstance():createNodeWithFlatBuffersFile("dxyCocosStudio/csd/scene/LoadingScene.csb")
    self:addChild(self._csbGameSceneNode)
    
    self.visibleSize = cc.Director:getInstance():getVisibleSize()
    self.origin = cc.Director:getInstance():getVisibleOrigin()
    
    local node = self._csbGameSceneNode:getChildByName("LoadingNode")
    node:setPositionX(self.visibleSize.width / 2 + self.origin.x)
    self.loadingTips = node:getChildByName("LoadingTips")
    self.loadingBar = node:getChildByName("LoadingBar")
    self.loadingPercent = node:getChildByName("LoadingPercent")
    
    self.loadingBar:setPercent(0)
    self:updateLoading( 0 )
	
    mc.ResMgr:getInstance():releasedALLRes()
    
	--self.loadingTips:setVisible(false)
	math.randomseed(os.time())
	
	self._tipsList = TipsConfigProvider:getTipsList()
    local index = math.random(1,#self._tipsList)

    self:updateLoadingTips(self._tipsList[index].Content)

end

function LoadBattleShowScene:initPreLoad(sceneName,csbPath,customFun)
	
    self.customFun = customFun
	self.m_textureList = {}
	self.mBones = {}
	self._sceneName = sceneName
	math.randomseed(os.time()) 
	self._totalPercent = 85 + math.random(0,10)
	
	self._pngListIndex = 1
	
	mc.ResMgr:getInstance():collectPlist(csbPath)
    local pilstPath = mc.ResMgr:getInstance():getOnePlist()
    local num = 1
    --[[while pilstPath do
        --local temp = dxyStringSplit(pilstPath, ".")
        --self.m_textureList[num] = temp[1]
		self.m_textureList[num] = pilstPath..""
        print(num .. " Texture------ fuckming" .. pilstPath)
        num = num + 1
        pilstPath = mc.ResMgr:getInstance():getOnePlist()
    end]]
	table.insert(self.mBones,"images/hero/wukong")
	table.insert(self.mBones,"images/hero/huyao")
	table.insert(self.mBones,"images/hero/longqiang")
	table.insert(self.mBones,"images/Monster/tianbing")
	table.insert(self.mBones,"images/Monster/niutou")
	table.insert(self.mBones,"images/Boss/julingshen")
	table.insert(self.mBones,"images/Boss/yanwang")
	table.insert(self.mBones,"images/Monster/tianjiang")
	num = #self.mBones + 1
    if num == 1 then
        print("Attention , this CSB has no plist !")
    end
	
	local frameCache=cc.SpriteFrameCache:getInstance()
	local refself = self
	local tipCnt = 0
	-- timer
	local boneIndex = 1
	local skeletonDataCache= mc.SkeletonDataCash:getInstance()
    
	local function tick(dt)
	
		tipCnt = tipCnt + dt
		if tipCnt >= 1.15 then
			tipCnt = tipCnt - 1.15
			
			local index = math.random(1,#self._tipsList)
			self:updateLoadingTips(self._tipsList[index].Content)
		end
		
		if num == 1 then
			self:updateLoading(100)
			self:whenFinish()
		else
			local ra = math.random(1,3)
			ra = 1
			if ra == 1 then
				--if self._pngListIndex == num then
				if boneIndex == num then
					self:whenFinish()
				else 
					--print(string.format("loaded self.loadTexture[%d] : %s",self._pngListIndex,self.m_textureList[self._pngListIndex]))
					--frameCache:addSpriteFrames(self.m_textureList[self._pngListIndex])
					
					skeletonDataCache:addData(self.mBones[boneIndex])
					boneIndex = boneIndex + 1
					
					local pngPercentValue = self._totalPercent * self._pngListIndex / (num-1)
					pngPercentValue = GetIntPart(pngPercentValue)
					self:updateLoading( pngPercentValue )
					self._pngListIndex = self._pngListIndex + 1
				end
			end
			
		end
	end
	
	cc.Texture2D:setDefaultAlphaPixelFormat(8) -- 设置默认图片格式为 RGBA4444
	
	local MyTimer = require("game.utils.MyTimer")
	self.m_timer = self.m_timer or MyTimer.new()
    self.m_timer:start(0.03,tick)

end

function LoadBattleShowScene:updateLoading(percent)
    self.loadingPercent:setString(percent.."%")
    self.loadingBar:setPercent(percent)
end

function LoadBattleShowScene:updateLoadingTips(tips)
	self.loadingTips:setString(tips)
end	

function LoadBattleShowScene:whenFinish()

	cc.Texture2D:setDefaultAlphaPixelFormat(2) -- 设置默认图片格式为 RGBA8888

	--if (self._sceneName == "mainScene" or self._sceneName == "MainScene") then
	if true then
		if self._mainSceneStep == 1 then
			self._mainSceneStep = 2
			--zzc.CharacterController:getLayer()
			self:updateLoading(95)-- 100
		elseif self._mainSceneStep == 2 then
			self._mainSceneStep = 3
		elseif self._mainSceneStep == 3 then
		
			if self._sceneName == "LoginScene" then
				
				self.m_timer:stop()
				self.m_timer = nil
				
				if self.customFun then
					self.customFun()
				end
			
				------------------------------------------------------------------
				require("game.GameScene")
				local gameScene = GameScene.create()

				gameScene._startId = 0
				gameScene._gameSceneId = 80101 --90101
				gameScene:setChapterId(0)
				gameScene:setBattleSceneId(gameScene._gameSceneId)
				gameScene:setGameSceneType(15)
				gameScene:initLayers()
				gameScene:startGame()
				gameScene:setStartAndEndTalkId(0,0)
				
				SceneManager:enterScene(gameScene, "GameScene")
			end

                       
		end
		
	end
	
end	
