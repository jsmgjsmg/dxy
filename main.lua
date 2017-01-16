cc.FileUtils:getInstance():addSearchPath("src")
cc.FileUtils:getInstance():addSearchPath("res")

--print = release_print

-- CC_USE_DEPRECATED_API = true
require "cocos.init"
require("defineSDK")
--require("defineDebug")
--require("defineTestIn")
require("game.manager.SDKManager")
require("VersionOrg")

-- cclog
local cclog = function(...)
    print(string.format(...))
end

-- for CCLuaEngine traceback
function __G__TRACKBACK__(msg)

	-- bugly
	local message = msg
	-- bugly end
	
    cclog("----------------------------------------")
    cclog("LUA ERROR: " .. tostring(msg) .. "\n")
    cclog(debug.traceback())
    cclog("----------------------------------------")

	-- bugly
	buglyReportLuaException(message, debug.traceback())
	-- bugly end

    return msg
end

local function main()
    collectgarbage("collect")
    -- avoid memory leak
    collectgarbage("setpause", 100)
    collectgarbage("setstepmul", 5000)
    print(_G.package.path)
    --_G.package.path

	--_G.print = _G.release_print
	--print("print log ----------------------------------------------- print log")
	--release_print("print log r ----------------------------------------------- print log r")
    --运行平台
    local targetPlatform = cc.Application:getInstance():getTargetPlatform()
    if targetPlatform == cc.PLATFORM_OS_WINDOWS or targetPlatform == cc.PLATFORM_OS_MAC then   	
        _G._isLocal = true
    else
        _G._isLocal = false
    end
    
    _G._isLocal = true

    require("game/manager/SceneManager")
    require("game/manager/UIManager")
    require("version/HotUpdateScene")

   --if _G._isLocal then   	
        require("GameApp.lua")
        --GameApp:startGame()
        --require "version.HotUpdate"       --热更新开启
		


--		require("game/manager/SceneManager")
--    	require("game/manager/UIManager")
--		--require("version/HotUpdateScene")
--		--local HotUpdateScene = HotUpdateScene:create()
--		--SceneManager:enterScene(HotUpdateScene,"HotUpdateScene")

		require("game.LogoScene")
		local logoScene = LogoScene:create()
		SceneManager:enterScene(logoScene, "LogoScene")




    --else        
        --SDKManagerLua.instance():initCpp() --开启sdk初始化回调会使用热更新
    --end

    -- initialize director
    local director = cc.Director:getInstance()
    
    --turn on display FPS
    --director:setAnimationInterval(1.0 / 45)
    --director:setDisplayStats(true)
--    director:setDisplayStats(true)
    director:setDisplayStats(false)
    
    -- Set Design Resolution Size
    --local designSize = cc.size(960,640)
    --local resolutionPolicy = cc.ResolutionPolicy.FIXED_HEIGHT
    --director:getOpenGLView():setDesignResolutionSize(designSize.width,designSize.height,resolutionPolicy)
	
    --create scene 
    --local scene = require("GameScene")
    --local gameScene = scene.create()
    --gameScene:playBgMusic()
    
--	mc.XmlData:getInstance():initAllDatas()
	
--	require("game/manager/SceneManager")
--    require("game/manager/UIManager")
--	require("game.MainScene")

	
	--create scene
	--local mainScene = MainScene:create()
	
	--SceneManager:enterScene(mainScene,"MainScene")
	
--	require("GameScene")
--	local gameScene = GameScene.create()
--			
--    if cc.Director:getInstance():getRunningScene() then
--        cc.Director:getInstance():replaceScene(gameScene)
--    else
--        cc.Director:getInstance():runWithScene(gameScene)
--    end

end


local status, msg = xpcall(main, __G__TRACKBACK__)
if not status then
    error(msg)
end
