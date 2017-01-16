
LoginLayerType = LoginLayerType or {
    LoginLayer = 1,
    StartLayer = 2,
    RegisiterLayer = 3,
    DeleteLayer = 4,
    RecoveryLayer = 5,
    SeclectServerLayer = 6,
    SeclectRoleLayer = 7,
    CreateRoleLayer = 8,
    ResetPasswordLayer = 9,
}

LoginScene = LoadingScene or class("LoginScene",function()
    return cc.Scene:create()
end)

function LoginScene.create()
    local scene = LoginScene.new()
    return scene
end

function LoginScene:ctor()
    self.visibleSize = cc.Director:getInstance():getVisibleSize()
    self.origin = cc.Director:getInstance():getVisibleOrigin()
    self._csbNode = nil
--    local cc = cc.Sprite:create("fuck.png")
--    self:addChild(cc)
    self._layerList = {}
    
    self._versionLabel = nil
    
    self:initUI()
    
--    _G.isEffect = "on"
end

function LoginScene:WhenClose()
--    zzc.LoginController:unregisterListenner()
end

function LoginScene:initUI()
    self._csbNode = cc.CSLoader:getInstance():createNodeWithFlatBuffersFile("dxyCocosStudio/csd/scene/LoginScene.csb")
    self:addChild(self._csbNode)
    
    local verNode = self._csbNode:getChildByName("verNode")
    verNode:setPosition(cc.p(self.origin.x,self.origin.y))

    self._versionLabel = verNode:getChildByName("Version")

    require "defineVersion"    
    self._versionLabel:setString("版本号: " .. _G.gVersion)
    
    require "game.login.view.LoginLayer"
    require "game.login.view.RegisterLayer"
    require "game.login.view.StartLayer"
    require "game.login.view.CreateRoleLayer"
    require "game.login.view.SelectRoleLayer"
    require "game.login.view.ServerListLayer"
    require("game.login.view.ResetPasswordLayer")
   
    zzc.LoginController:registerListenner()
end

function LoginScene:setVersion(versionstr)
    self._versionLabel:setString(versionstr)
end

function LoginScene:enterLayer(layerType)

    local posX = self.origin.x + self.visibleSize.width/2
    local posY = self.origin.y + self.visibleSize.height/2

    self:closeLayer()
    print("2222222---".. layerType)
    if layerType == LoginLayerType.LoginLayer then
        if self._layerList[LoginLayerType.LoginLayer] == nil then
            self._layerList[LoginLayerType.LoginLayer] = LoginLayer.create()
            self:addChild(self._layerList[LoginLayerType.LoginLayer])
        end
    elseif layerType == LoginLayerType.StartLayer then
        if self._layerList[LoginLayerType.StartLayer] == nil then
            self._layerList[LoginLayerType.StartLayer] = StartLayer.create()
            self:addChild(self._layerList[LoginLayerType.StartLayer])   
        end
    elseif layerType == LoginLayerType.RegisiterLayer then
        if self._layerList[LoginLayerType.RegisiterLayer] == nil then
            self._layerList[LoginLayerType.RegisiterLayer] = RegisterLayer.create()
            self:addChild(self._layerList[LoginLayerType.RegisiterLayer])
        end
    elseif layerType == LoginLayerType.DeleteLayer then
    
    elseif layerType == LoginLayerType.RecoveryLayer then
    
    elseif layerType == LoginLayerType.SeclectServerLayer then
        if self._layerList[LoginLayerType.SeclectServerLayer] == nil then
            self._layerList[LoginLayerType.SeclectServerLayer] = ServerListLayer.create()
            self:addChild(self._layerList[LoginLayerType.SeclectServerLayer])
        end
    elseif layerType == LoginLayerType.SeclectRoleLayer then
        if self._layerList[LoginLayerType.SeclectRoleLayer] == nil then
            self._layerList[LoginLayerType.SeclectRoleLayer] = SelectRoleLayer.create()
            self:addChild(self._layerList[LoginLayerType.SeclectRoleLayer])
        end
    elseif layerType == LoginLayerType.CreateRoleLayer then
        if self._layerList[LoginLayerType.CreateRoleLayer] == nil then
            self._layerList[LoginLayerType.CreateRoleLayer] = CreateRoleLayer.create()
            self:addChild(self._layerList[LoginLayerType.CreateRoleLayer])
        end
    elseif layerType == LoginLayerType.ResetPasswordLayer then
        if self._layerList[LoginLayerType.ResetPasswordLayer] == nil then
            self._layerList[LoginLayerType.ResetPasswordLayer] = ResetPasswordLayer.create()
            self:addChild(self._layerList[LoginLayerType.ResetPasswordLayer])
        end
    else
    
    end
    self._layerList[layerType]:setPosition(posX, posY)
end

function LoginScene:closeLayer(layerType)
    for index, layer in pairs(self._layerList) do
        if self._layerList[index] ~= nil then
            print("removeChild")
            self:removeChild(self._layerList[index])
            self._layerList[index] = nil
        end
    end
end

function LoginScene:removeChildFunc(child)
    self.login:setVisible(true)
    self:removeChild(child,true)
end



