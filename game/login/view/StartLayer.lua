StartLayer = StartLayer or class("StartLayer",function()
    return cc.Layer:create()
end)

function StartLayer.create()
    local layer = StartLayer.new()
    return layer
end

function StartLayer:ctor()
    self._csbNode = nil

    self:initUI()
    dxyExtendEvent(self)
    zzc.LoginController:httpRequest_SeversList()
end

function StartLayer:initUI()
    self._csbNode = cc.CSLoader:getInstance():createNodeWithFlatBuffersFile("dxyCocosStudio/csd/ui/login/StartLayer.csb")
    self:addChild(self._csbNode)
    
    self.visibleSize = cc.Director:getInstance():getVisibleSize()
    self.origin = cc.Director:getInstance():getVisibleOrigin()
    
    local node = self._csbNode:getChildByName("StartPanel")
    self.btn_StartGame = node:getChildByName("StartGame")
    self.btn_SwitchAccount = node:getChildByName("SwitchAccount")
    self.btn_SwitchAccount:setPosition(cc.p(self.visibleSize.width / 2 + self.origin.x,self.visibleSize.height / 2 + self.origin.y))
    self.btn_SwitchServer = node:getChildByName("SwitchServer")
    self.text_LastServer = self.btn_SwitchServer:getChildByName("LastServer")
end

function StartLayer:removeEvent()
    dxyDispatcher_removeEventListener(dxyEventType.Login_UpdateLastServer,self,self.updateLasterServer)
    zzm.AnnouncementModel._isInStartLayer = false
end

function StartLayer:initEvent()
    dxyDispatcher_addEventListener(dxyEventType.Login_UpdateLastServer,self,self.updateLasterServer)

    if(self.btn_StartGame)then
        self.btn_StartGame:addTouchEventListener(function(target,type)
            if(type==2)then
                SoundsFunc_playSounds(SoundsType.OPEN_PAGE,false)
                --zzc.LoginController:createOrSelectRole()
                --zzc.CopySelectController:showLayer()
                --zzc.AnnouncementController:showLayer()
                
                local lastServer = zzc.LoginController:getLastServer()
                --local lastServer = zzm.LoginModel:getServerById(2)
                local t1 = os.time()
                local t2 = tonumber(lastServer.open_time) 
                if t1 < t2 then
                    local yy = os.date("%Y",t2) .. "年"
                    local mm = os.date("%m",t2) .. "月"
                    local dd = os.date("%d",t2) .. "日"
                    local time = os.date("%X",t2)
                    dxyFloatMsg:show("该服开启时间 " .. yy .. mm .. dd .. time)
                    return
                end
                    
                zzc.LoginController:connectServerSecond(lastServer)
                zzm.LoginModel.loginServer = lastServer
            end
        end)
    end
    
    if(self.btn_SwitchAccount)then
        self.btn_SwitchAccount:addTouchEventListener(function(self,type)
            if(type==2)then
                SoundsFunc_playSounds(SoundsType.OPEN_PAGE,false)
                SDKManagerLua.instance():logout()
                zzc.LoginController:enterLayer(LoginLayerType.LoginLayer)
            end
        end)
    end
    
    if(self.btn_SwitchServer)then
        self.btn_SwitchServer:addTouchEventListener(function(self,type)
            if(type==2)then
                if #zzm.LoginModel.serverData.allList ~= 0 then              	
                    SoundsFunc_playSounds(SoundsType.OPEN_PAGE,false)
                    zzc.LoginController:enterLayer(LoginLayerType.SeclectServerLayer)
                end
            end
        end)
    end
    SoundsFunc_playSounds(SoundsType.OPEN_PAGE,false)
    zzc.AnnouncementController:enterMainScene()
end

function StartLayer:updateLasterServer(server)
    if server then
        self.text_LastServer:setString("上次登录：" .. server.name)
    end
end

function StartLayer:setVersion(versionstr)
    self._versionLabel:setString(versionstr)
end

