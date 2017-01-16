
GameApp = {}

GameScreenFactors = 
{
	standard_width  = 960,
	standard_height = 640,
}

function GameApp:initRequireAll()
    require("defineDebug")
    require("defineTestIn")
    require "defineVersion"
    require "game.common.UserDefaultManager"
    require("game.manager.NetManager")
    require "game.utils.dxyCommon"
    require "lua_config.LuaConfig"
    require "game.data.init"
    require "game.common.init"
	--require "game.GameScene"
	require "game.manager.UIManager"
	require "game.manager.SceneManager"
    require "json"
    require "game.manager.TipsFrame"
    require("game.commonUI.CustomTips")
    require ("game.initMC").new()
	require ("game.manager.SDKManager")
	
	-- 预加载角色
	local data = HeroConfig:getConfig()
    for key, var in pairs(data) do
        mc.SkeletonDataCash:getInstance():addData(var["CreateBone"],false)
        mc.SkeletonDataCash:getInstance():addData(var["BoneEffect"],false)
    end
	-- end
	
    SoundsFunc_addSoundFrames()
    SoundsInit.new()
    
    require "game.commonUI.dxyFloatMsg"
    require "game.commonUI.dxyWaitBack"
    require "game.commonUI.LoadWait"
    require "game.commonUI.LoadWaitSec"
    require "game.commonUI.SwallowAllTouches"
    require "game.utils.UpGradeEffect"
--    require "game.error.ErrorPro"
    require "src.game.utils.convertNum"
    require("game.manager.TalkingDataManager").new()
    --require("game.MainScene")
    require "game.tilemap.steptwo.CommonMap"
    require "game.utils.tileMapGrid"
    require "game.commonUI.OneBtnTips"    
end

function GameApp:initDefalutSetting()
    -- initialize director
    local director = cc.Director:getInstance()

    --turn on display FPS
    --director:setDisplayStats(true)

    --set FPS. the default value is 1.0/60 if you don't call this
    director:setAnimationInterval(1.0 / 45)

    --director:getOpenGLView():setDesignResolutionSize(480, 320, 1)
    --director:getOpenGLView():setDesignResolutionSize(960, 640, 4)
    director:getOpenGLView():setDesignResolutionSize(GameScreenFactors.standard_width, GameScreenFactors.standard_height, cc.ResolutionPolicy.FIXED_HEIGHT)
end

--reset all datas in the last game, use it while you logout current user
--only reset datas, actually we don't need remove the listners
function GameApp:resetGame()

end

function GameApp:startGame()
	
    local path = cc.FileUtils:getInstance():getSearchPaths()[1]
    local m_package_path = _G.package.path
    _G.package.path = string.format("%s?.lua;%s", path, m_package_path)
	path = cc.FileUtils:getInstance():getSearchPaths()[3]
	m_package_path = _G.package.path
	_G.package.path = string.format("%s?.lua;%s", path, m_package_path)
    print(_G.package.path)
	
    mc.XmlData:getInstance():initAllDatas()
    mc.NetMannager:getInstance():reDispatchMsgToCpp(4009)
    mc.NetMannager:getInstance():reDispatchMsgToCpp(4051)
    mc.NetMannager:getInstance():reDispatchMsgToCpp(9506)
    mc.NetMannager:getInstance():reDispatchMsgToCpp(9010)
    mc.NetMannager:getInstance():reDispatchMsgToCpp(9030)
    mc.NetMannager:getInstance():reDispatchMsgToCpp(9040)
    mc.NetMannager:getInstance():reDispatchMsgToCpp(9060)
    mc.NetMannager:getInstance():reDispatchMsgToCpp(9070)
    mc.NetMannager:getInstance():reDispatchMsgToCpp(9090)
	mc.NetMannager:getInstance():reDispatchMsgToCpp(11610)
    mc.NetMannager:getInstance():reDispatchMsgToCpp(11630)
    mc.NetMannager:getInstance():reDispatchMsgToCpp(11640)
   --mc.NetMannager:getInstance():reDispatchMsgToCpp(11650)
	mc.NetMannager:getInstance():reDispatchMsgToCpp(9622)
	mc.NetMannager:getInstance():reDispatchMsgToCpp(9632)
	mc.NetMannager:getInstance():reDispatchMsgToCpp(12066)
	mc.NetMannager:getInstance():reDispatchMsgToCpp(12102)
	mc.NetMannager:getInstance():reDispatchMsgToCpp(12106)
	mc.NetMannager:getInstance():reDispatchMsgToCpp(12132)
    --mc.GameUpdater:getInstance():initSingle()
	self:initDefalutSetting()
	self:initRequireAll()	
	_G.MyData = {}
	
    --mc.GameUpdater:getInstance():initSingle()
    
--    mc.UcSdkTool:getInstance():uc_sdk_init()
    
--    if zzm.GlobalModel.isLocal then    	
--        local gameScene = zzc.LoginController:getScene()
--        SceneManager:enterScene(gameScene, "LoginScene")
--    else
--        mc.UcSdkTool:getInstance():uc_sdk_init()
--    end

-- org
    local gameScene = zzc.LoginController:getScene()
    zzc.LoginController.enterMainScene(1)
    --SceneManager:enterScene(gameScene, "LoginScene")
    
    SDKManagerLua.instance():login()
	
	--require("game.LogoScene")
    --local logoScene = LogoScene:create()
    --SceneManager:enterScene(logoScene, "LogoScene")
-- end
	
	
	
	
--	mc.ClickBackTool:getInstance():getClickBackLayer()
	
    --require("game.LogoScene")
    --local logoScene = LogoScene:create()
    --SceneManager:enterScene(logoScene, "LogoScene")
    
    --require("game.MainScene")
--    local mainScene = MainScene:create()
--    SceneManager:enterScene(mainScene, "mainScene")
--    zzc.LoginController:enterMainScene()

--    require("game.MainSceneTest")
--    local mainScene = MainSceneTest:create()
--    SceneManager:enterScene(mainScene, "mainScene")
end




