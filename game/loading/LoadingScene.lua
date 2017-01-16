
LoadingScene = LoadingScene or class("LoadingScene",function()
    return cc.Scene:create()
end)

function LoadingScene.create()
    local scene = LoadingScene.new()
    return scene
end

function LoadingScene:ctor()
    self.loadingTips = nil
    self.loadingBar = nil
    self.loadingPercent = nil
    
    self:initUI()
end

function LoadingScene:WhenClose()
	
	
end

function LoadingScene:initUI()
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
    
    mc.ResMgr:getInstance():releasedALLRes()
    
end

function LoadingScene:updateLoading(percent)
    if (percent >= 95) then
        percent = 95
    end
    self.loadingPercent:setString(percent.."%")
    self.loadingBar:setPercent(percent)
end

function LoadingScene:updateLoadingTips(tips)
	self.loadingTips:setString(tips)
end	
