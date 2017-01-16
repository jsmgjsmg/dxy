RegisterLayer = RegisterLayer or class("RegisterLayer",function()
    return cc.Layer:create()
end)

function RegisterLayer.create()
    local layer = RegisterLayer.new()
    return layer
end

function RegisterLayer:ctor()
    self._csbNode = nil
    self:initUI()
    dxyExtendEvent(self)
end

function RegisterLayer:initUI()
    self._csbNode = cc.CSLoader:getInstance():createNodeWithFlatBuffersFile("dxyCocosStudio/csd/ui/login/RegisterLayer.csb")
    self:addChild(self._csbNode)
    
    local node = self._csbNode:getChildByName("RegisterPanel")
    self.btn_back = node:getChildByName("BackLogin")
    self.btn_sure = node:getChildByName("SureRegister")
    self.btn_getIdentify = node:getChildByName("Identifying"):getChildByName("GetIdentifying")
    self.input_identify = node:getChildByName("Identifying"):getChildByName("TextField")
    --self.input_identify = node:getChildByName("Identifying"):getChildByName("linebg"):getChildByName("TextField")
    self.input_account = node:getChildByName("AccountNumber"):getChildByName("linebg"):getChildByName("TextField")
    self.input_password = node:getChildByName("Password"):getChildByName("linebg"):getChildByName("TextField")
    self.agreeAccept = node:getChildByName("AgreeAccept")
    self.agreeAccept_checkBox = self.agreeAccept:getChildByName("CheckBox")
    
    self.input_account:setMaxLength(12)
end

function RegisterLayer:removeEvent()
    dxyDispatcher_removeEventListener(dxyEventType.Login_UpdateIdentify,self,self.updataVerift)
end

function RegisterLayer:initEvent()
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
                SoundsFunc_playSounds(SoundsType.OPEN_PAGE,false)
                zzc.LoginController:httpRequest_SureRegister(data)
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
                zzc.LoginController:httpRequest_GetIdentify(account)
            end
        end)
    end
    
    if self.agreeAccept_checkBox then
    	self.agreeAccept_checkBox:addTouchEventListener(function(target,type)
    	    if type ==2 then
                SoundsFunc_playSounds(SoundsType.UNIVERSAL_BTN,false)
    	    end
    	end)
    end
    
end


function RegisterLayer:updataVerift(verify)
    self.input_identify:setString(verify)
end

function RegisterLayer:getIdentify()
    local accout = self.input_account:getString()

end

