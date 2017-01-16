
LoginLayer = LoginLayer or class("LoginLayer",function()
    return cc.Layer:create()
end)

function LoginLayer.create()
    local layer = LoginLayer.new()
    return layer
end

function LoginLayer:ctor()
    self._csbNode = nil
    self:initUI()
    self:initEvent()
end

function LoginLayer:initUI()
    self._csbNode = cc.CSLoader:getInstance():createNodeWithFlatBuffersFile("dxyCocosStudio/csd/ui/login/LoginLayer.csb")
    self:addChild(self._csbNode)
    
    local node = self._csbNode:getChildByName("LoginPanel")
    node:setVisible(_G._isLocal)
    self.btn_start = node:getChildByName("EnterGame")
    self.btn_register = node:getChildByName("RegisterAccount")
    self.input_account = node:getChildByName("AccountNumber"):getChildByName("linebg"):getChildByName("TextField")
    self.input_password = node:getChildByName("Password"):getChildByName("linebg"):getChildByName("TextField")
    self.check_isRemember = node:getChildByName("RememberPassword"):getChildByName("CheckBox")
    self.btn_forget = node:getChildByName("RememberPassword"):getChildByName("forgetBtn")
    self.btn_forget:setPressedActionEnabled(true)
    
    self.btn_change = node:getChildByName("changeBtn")
    self.txt_change = self.btn_change:getChildByName("changeTxt")
    if zzm.GlobalModel.type == 1 then
        self.txt_change:setString("内网")
    elseif zzm.GlobalModel.type == 2 then
        self.txt_change:setString("外网")
    end
    zzm.GlobalModel:getNetHead(zzm.GlobalModel.type)
    
	self.btn_change:setVisible(false) -- switch the btn
	if _G.gNetOrLocal then
		self.btn_change:setVisible(true) -- switch the btn
    end
	
    local data = zzm.LoginModel.loginData
    local IsRemember = cc.UserDefault:getInstance():getBoolForKey(UserDefaulKey.AccountIsRemember,false)
    local Account = ""
    local Password = ""
    if IsRemember then
        Account = cc.UserDefault:getInstance():getStringForKey(UserDefaulKey.Account,"")
        Password = cc.UserDefault:getInstance():getStringForKey(UserDefaulKey.Password,"")
    end
    self.check_isRemember:setSelected(IsRemember)
    self.input_account:setString(Account)
    self.input_password:setString(Password)
    
    local node = self._csbNode:getChildByName("Node")
    node:setVisible(not _G._isLocal)
    self.btn_ucstart = node:getChildByName("ucstartBtn")
end


function LoginLayer:initEvent()
    if(self.btn_start)then
        self.btn_start:addTouchEventListener(function(target,type)
            if(type==2)then
             --print("11111111")
                local data = {}
                data.Accout = self.input_account:getString()
                if data.Accout == nil or data.Accout == "" then
                    SoundsFunc_playSounds(SoundsType.FAILE_TO_USE,false)
                    TipsFrame:create("账号不能为空！")
                    return
                end
                data.Password = self.input_password:getString()
                if data.Password == nil or data.Password == "" then
                    SoundsFunc_playSounds(SoundsType.FAILE_TO_USE,false)
                    TipsFrame:create("密码不能为空！")
                    return
                end
                SoundsFunc_playSounds(SoundsType.OPEN_PAGE,false)
                data.isRemember = self.check_isRemember:isSelected()
                zzc.LoginController:httpRequest_LoginGame(data)
--                mc.UcSdkTool:getInstance():login()
--                SceneManager:httpRequest_LoginGame()
--                SDKManagerLua.instance():login()
            end
        end)
    end
    
    if(self.btn_register)then
        self.btn_register:addTouchEventListener(function(target,type)
            if(type==2)then
                SoundsFunc_playSounds(SoundsType.OPEN_PAGE,false)
                zzc.LoginController:enterLayer(LoginLayerType.RegisiterLayer)
            end
        end)
    end
    
    if self.btn_forget then
    	self.btn_forget:addTouchEventListener(function(target,type)
            if(type==2)then
                SoundsFunc_playSounds(SoundsType.OPEN_PAGE,false)
                zzc.LoginController:enterLayer(LoginLayerType.ResetPasswordLayer)
            end
        end)
    end
    
    if self.btn_change then
        self.btn_change:addTouchEventListener(function(target,type)
            if(type==2)then
                SoundsFunc_playSounds(SoundsType.UNIVERSAL_BTN,false)
                zzm.GlobalModel:changeNet()
                if zzm.GlobalModel.type == 1 then
                	self.txt_change:setString("内网")
                elseif zzm.GlobalModel.type == 2 then
                    self.txt_change:setString("外网")
                end
            end
        end)
    end
    
    if self.btn_ucstart then
        self.btn_ucstart:addTouchEventListener(function(target,type)
            if(type==2)then
                SoundsFunc_playSounds(SoundsType.OPEN_PAGE,false)
                SDKManagerLua.instance():login()
            end
        end)
    end
    
    if self.check_isRemember then
    	self.check_isRemember:addTouchEventListener(function(target,type)
    	    if type == 2 then
                SoundsFunc_playSounds(SoundsType.UNIVERSAL_BTN,false)
    	    end
    	end)
    end
end
