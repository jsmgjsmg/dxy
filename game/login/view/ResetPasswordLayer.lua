ResetPasswordLayer = ResetPasswordLayer or class("ResetPasswordLayer",function()
    return cc.Layer:create()
end)

function ResetPasswordLayer.create()
    local layer = ResetPasswordLayer.new()
    return layer
end

function ResetPasswordLayer:ctor()
    self._csbNode = nil
    self:initUI()
    dxyExtendEvent(self)
end

function ResetPasswordLayer:initUI()
    self._csbNode = cc.CSLoader:getInstance():createNodeWithFlatBuffersFile("dxyCocosStudio/csd/ui/login/ResetPasswordLayer.csb")
    self:addChild(self._csbNode)

    local node = self._csbNode:getChildByName("ResetPanel")
    self.btn_back = node:getChildByName("BackLogin")
    self.btn_sure = node:getChildByName("SureReset")
    self.btn_getIdentify = node:getChildByName("Identifying"):getChildByName("GetIdentifying")
    self.input_identify = node:getChildByName("Identifying"):getChildByName("TextField")
    self.input_account = node:getChildByName("AccountNumber"):getChildByName("linebg"):getChildByName("TextField")
    self.input_password = node:getChildByName("Password"):getChildByName("linebg"):getChildByName("TextField")

    self.input_account:setMaxLength(12)
end

function ResetPasswordLayer:removeEvent()
    dxyDispatcher_removeEventListener(dxyEventType.Login_UpdateIdentify,self,self.updataVerift)
end

function ResetPasswordLayer:initEvent()
    dxyDispatcher_addEventListener(dxyEventType.Login_UpdateIdentify,self,self.updataVerift)

    if(self.btn_back)then
        self.btn_back:addTouchEventListener(function(self,type)
            if(type==2)then
                SoundsFunc_playSounds(SoundsType.CLOSE_PAGE,false)
                zzc.LoginController:enterLayer(LoginLayerType.LoginLayer)
            end
        end)
    end

    if(self.btn_sure)then
        self.btn_sure:addTouchEventListener(function(tagrt,type)
            if(type==2)then
                local data = {}
                data.account = self.input_account:getString()
                data.password = self.input_password:getString()
                data.identify = self.input_identify:getString()
                if data.account == nil or data.account == "" then
                    SoundsFunc_playSounds(SoundsType.FAILE_TO_USE,false)
                    TipsFrame:create("账号不能为空！")
                    return
                end
                if data.password == nil or data.password == "" then
                    SoundsFunc_playSounds(SoundsType.FAILE_TO_USE,false)
                    TipsFrame:create("密码不能为空！")
                    return
                end
                if data.identify == nil or data.identify == "" then
                    SoundsFunc_playSounds(SoundsType.FAILE_TO_USE,false)
                    TipsFrame:create("验证码不能为空！")
                    return
                end
                SoundsFunc_playSounds(SoundsType.CLOSE_PAGE,false)
                zzc.LoginController:httpRequest_ResetPassword(data)
            end
        end)
    end

    if(self.btn_getIdentify)then
        self.btn_getIdentify:addTouchEventListener(function(tagrt,type)
            if(type==2)then
                local account = self.input_account:getString()
                if account == nil or account == "" then
                    SoundsFunc_playSounds(SoundsType.FAILE_TO_USE,false)
                    TipsFrame:create("请输入账号！")
                    return
                end
                SoundsFunc_playSounds(SoundsType.OPEN_PAGE,false)
                zzc.LoginController:httpRequest_GetPasswordIdentify(account)
            end
        end)
    end
end


function ResetPasswordLayer:updataVerift(verify)
    self.input_identify:setString(verify)
end

function ResetPasswordLayer:getIdentify()
    local accout = self.input_account:getString()

end

