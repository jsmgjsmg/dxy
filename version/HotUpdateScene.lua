local gameWidth = 960
local gameHeight = 640
-- initialize director
local director = cc.Director:getInstance()
--turn on display FPS
--director:setDisplayStats(true)
--set FPS. the default value is 1.0/60 if you don't call this
director:setAnimationInterval(1.0 / 45)
director:getOpenGLView():setDesignResolutionSize(gameWidth, gameHeight, cc.ResolutionPolicy.FIXED_HEIGHT)

local function reloadModule( moduleName )

    package.loaded[moduleName] = nil

    return require(moduleName)
end

HotUpdateScene = HotUpdateScene or class("HotUpdateScene",function()
    return mc.HotUpdateScene:create()
end)

function HotUpdateScene.create()
    local scene = HotUpdateScene.new()
    return scene
end

function HotUpdateScene:ctor()
    
    self.visibleSize = cc.Director:getInstance():getVisibleSize()
    self.origin = cc.Director:getInstance():getVisibleOrigin()
    
	self:initLayer()
end

function HotUpdateScene:WhenClose()

end

function HotUpdateScene:dealMsg(msg)

end

function HotUpdateScene.goToNextScene()
	reloadModule("GameApp.lua")
	GameApp:startGame()
end