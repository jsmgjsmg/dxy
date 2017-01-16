local director = cc.Director:getInstance()
director:setAnimationInterval(1.0 / 45)
director:getOpenGLView():setDesignResolutionSize(960, 640, cc.ResolutionPolicy.FIXED_HEIGHT)

LogoScene = LogoScene or class("LogoScene",function()
    return cc.Scene:create()
end)

function LogoScene.create()
    local scene = LogoScene.new()
    return scene
end

function LogoScene:ctor()
    self.visibleSize = cc.Director:getInstance():getVisibleSize()
    self.origin = cc.Director:getInstance():getVisibleOrigin()
    self.schedulerID = nil

    self._finishTimer = self._finishTimer or require("game.utils.MyTimer").new()
--    local logoID = 1
--    local logoData = SceneConfigProvider:getLogoData(logoID)
    local pathName = "Icon/logo.png"
    self.bg = cc.Sprite:create(pathName)
    local finishTimerCnt = 0
    local totalTime = 3
    --local totalTime = logoData.Time
    
    local function tick()
        finishTimerCnt = finishTimerCnt + 0.1
        if finishTimerCnt > totalTime then
            self._finishTimer:stop()
            self._finishTimer = nil
            
            local fadeOut = cc.FadeOut:create(1)
            
            local function fun(parameters)
                local targetPlatform = cc.Application:getInstance():getTargetPlatform()
                if targetPlatform == cc.PLATFORM_OS_WINDOWS or targetPlatform == cc.PLATFORM_OS_MAC then    
                    _G._isLocal = true
                else
                    _G._isLocal = false
                end

                if _G._isLocal then     
--                    require("game/manager/SceneManager")
--                    require("game/manager/UIManager")
--                    require("version/HotUpdateScene")
--                    local HotUpdateScene = HotUpdateScene:create()
--                    SceneManager:enterScene(HotUpdateScene,"HotUpdateScene")
                    --print("fuck aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa")
                    --SDKManagerLua.instance():initCpp()
                    require("GameApp.lua")
                    GameApp:startGame()

                    --zzm.CopySelectModel:insertCopyData(10001, 1)
                else        
                    SDKManagerLua.instance():initCpp() --开启sdk初始化回调会使用热更新
                end
            end
--			local targetPlatform = cc.Application:getInstance():getTargetPlatform()
--			if targetPlatform == cc.PLATFORM_OS_WINDOWS or targetPlatform == cc.PLATFORM_OS_MAC then   	
--				_G._isLocal = true
--			else
--				_G._isLocal = false
--			end
--			
--			if _G._isLocal then   	
--				require("game/manager/SceneManager")
--				require("game/manager/UIManager")
--				require("version/HotUpdateScene")
--				local HotUpdateScene = HotUpdateScene:create()
--				SceneManager:enterScene(HotUpdateScene,"HotUpdateScene")
--				--print("fuck aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa")
--				--SDKManagerLua.instance():initCpp()
--			else        
--				SDKManagerLua.instance():initCpp() --开启sdk初始化回调会使用热更新
--			end
            local callFun = cc.CallFunc:create(fun)
            local seq = cc.Sequence:create(fadeOut,callFun)
            self.bg:runAction(seq)
        end
    end
    self._finishTimer:start(0.1, tick)

    --local pathName = logoData.Path
--    local pathName = "dropIcon/chest_1.png"
--    self.bg = cc.Sprite:create(pathName)
--    if logoData.Type == 1 then  --logo类型
--        self.bg = cc.Sprite:create(pathName)
--        self:addChild(self.bg)
--        self.bg:setPosition(self.origin.x + self.visibleSize.width/2,self.origin.y + self.visibleSize.height/2)
--    else
--        self._csb = cc.CSLoader:createNode(pathName)
--        self:addChild(self._csb)
--        self._csb:setPosition(self.origin.x + self.visibleSize.width/2,self.origin.y + self.visibleSize.height/2)
--        self.bg = cc.CSLoader:createTimeline(pathName) 
--        self._csb:runAction(self.bg)
--        self.bg:gotoFrameAndPlay(0,true)
--    end
    
    self:addChild(self.bg)
    self.bg:setOpacity(0)
    self.bg:setPosition(self.origin.x + self.visibleSize.width/2,self.origin.y + self.visibleSize.height/2)
    local fadeIn = cc.FadeIn:create(2)
    self.bg:runAction(fadeIn)
    --self:initUI()

    --    self:initLayers()
    --    self:startGame()

    --self._csbResultNode = cc.CSLoader:getInstance():createNodeWithFlatBuffersFile("GameScene/GameResultWin.csb")
    --self:addChild(self._csbResultNode)

end
    
function LogoScene:WhenClose()

--    cc.SimpleAudioEngine:getInstance():stopMusic()
--    ccexp.AudioEngine:stopAll()
    
--    if self._finishTimer then
--        self._finishTimer:stop()
--        self._finishTimer = nil
--    end
	--require("game/common/dxyDataEventDispatcher")
	
end