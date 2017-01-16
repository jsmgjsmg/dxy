
--更新列表配置文件
local manifest = "version/project.manifest"
--本地更新包存储目录
local storagePath = "version"
local savepath = cc.FileUtils:getInstance():getWritablePath() .. storagePath

local gameWidth = 960
local gameHeight = 640
-- initialize director
local director = cc.Director:getInstance()
--turn on display FPS
--director:setDisplayStats(true)
--set FPS. the default value is 1.0/60 if you don't call this
director:setAnimationInterval(1.0 / 45)
director:getOpenGLView():setDesignResolutionSize(gameWidth, gameHeight, cc.ResolutionPolicy.FIXED_HEIGHT)

local visibleSize = cc.Director:getInstance():getVisibleSize()
local origin = cc.Director:getInstance():getVisibleOrigin()

local HotUpdate = {}
HotUpdate.__index = HotUpdate

local function reloadModule( moduleName )

    package.loaded[moduleName] = nil

    return require(moduleName)
end

function HotUpdate.create()

    local layer  = cc.CSLoader:createNode("dxyCocosStudio/csd/scene/HotUpdateLayer.csb")
    layer:setPosition(cc.p(origin.x + visibleSize.width / 2,origin.y + visibleSize.height / 2))

    local am = nil

    local function onEnter()
    
        local loadingBar = layer:getChildByName("loadingNode"):getChildByName("LoadingBar")
        local loadingTips = layer:getChildByName("loadingNode"):getChildByName("LoadingTips")

        am = cc.AssetsManagerEx:create(manifest, savepath)
        am:retain()

        if not am:getLocalManifest():isLoaded() then
            print("Fail to update assets, step skipped.")
            reloadModule("GameApp.lua")
            GameApp:startGame() 
        else
            local function onUpdateEvent(event)
                local eventCode = event:getEventCode()
                if eventCode == cc.EventAssetsManagerEx.EventCode.ERROR_NO_LOCAL_MANIFEST then
                    print("No local manifest file found, skip assets update.")
                    reloadModule("GameApp.lua")
                    GameApp:startGame()                  
                elseif  eventCode == cc.EventAssetsManagerEx.EventCode.UPDATE_PROGRESSION then
                    local assetId = event:getAssetId()
                    local percent = event:getPercent()
                    local strInfo = ""

                    if assetId == cc.AssetsManagerExStatic.VERSION_ID then
                        strInfo = string.format("正在下载配置文件: %d%%", percent)
                    elseif assetId == cc.AssetsManagerExStatic.MANIFEST_ID then
                        strInfo = string.format("正在下载更新配置文件: %d%%", percent)
                    else
                        strInfo = string.format("正在下载更新文件: %d%%", percent)
                    end
                    loadingBar:setPercent(percent)
                    loadingTips:setString(strInfo)
                elseif eventCode == cc.EventAssetsManagerEx.EventCode.ERROR_DOWNLOAD_MANIFEST or 
                       eventCode == cc.EventAssetsManagerEx.EventCode.ERROR_PARSE_MANIFEST then
                    print("Fail to download manifest file, update skipped.")
                    reloadModule("GameApp.lua")
                    GameApp:startGame() 
                elseif eventCode == cc.EventAssetsManagerEx.EventCode.ALREADY_UP_TO_DATE or 
                       eventCode == cc.EventAssetsManagerEx.EventCode.UPDATE_FINISHED then
                        print("Update finished.")
                        reloadModule("GameApp.lua")
                        GameApp:startGame()
                        
                elseif eventCode == cc.EventAssetsManagerEx.EventCode.ERROR_UPDATING then
                        print("Asset ", event:getAssetId(), ", ", event:getMessage())
                        reloadModule("GameApp.lua")
                        GameApp:startGame()
                end
            end
            local listener = cc.EventListenerAssetsManagerEx:create(am,onUpdateEvent)
            cc.Director:getInstance():getEventDispatcher():addEventListenerWithFixedPriority(listener, 1)
            
            am:update()
        end
    end

    local function onNodeEvent(event)
        if "enter" == event then
            onEnter()
        elseif "exit" == event then
            am:release()
        end
    end
    layer:registerScriptHandler(onNodeEvent)

    return layer
end

function AssetsManagerExTestMain()
    local scene = cc.Scene:create()
    scene:addChild(HotUpdate.create())
    return scene
end

--启动更新
function HotUpdate.StartUpdate()

    if cc.Director:getInstance():getRunningScene() then
        cc.Director:getInstance():replaceScene(AssetsManagerExTestMain())
    else
        cc.Director:getInstance():runWithScene(AssetsManagerExTestMain())
    end
end

--启动下载
HotUpdate.StartUpdate()