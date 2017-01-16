
SelectRoleLayer = SelectRoleLayer or class("SelectRoleLayer",function()
    return cc.Layer:create()
end)

function SelectRoleLayer.create()
    local layer = SelectRoleLayer.new()
    return layer
end

function SelectRoleLayer:ctor()
    self._csbNode = nil
    self._arrRole = {}
    self.m_dataList = nil
    
    self:initUI()
--    self:initEvent()
    
end

--  shi n ji tsu wa i tsu mo hi to tsu

function SelectRoleLayer:initUI()
    self._csbNode = cc.CSLoader:getInstance():createNodeWithFlatBuffersFile("dxyCocosStudio/csd/ui/login/SelectRoleLayer.csb")
    self:addChild(self._csbNode)
    
    self._timeLine = cc.CSLoader:createTimeline("dxyCocosStudio/csd/ui/login/SelectRoleLayer.csb")
    self._csbNode:runAction(self._timeLine)
    self._timeLine:gotoFrameAndPlay(0,true)
    
    self.visibleSize = cc.Director:getInstance():getVisibleSize()
    self.origin = cc.Director:getInstance():getVisibleOrigin()
    
    dxyExtendEvent(self)

    local backNode = self._csbNode:getChildByName("backNode")
    backNode:setPosition(cc.p(-self.visibleSize.width / 2 + self.origin.x,self.visibleSize.height / 2 + self.origin.y))
    self.btn_back = backNode:getChildByName("Back")
    
    self.btn_start = self._csbNode:getChildByName("EnterGame")
    
    local node = self._csbNode:getChildByName("RoleList")
    node:setPositionX(self.visibleSize.width / 2 + self.origin.x)
    self.listView = node:getChildByName("ListPanel"):getChildByName("ListView")
    self.btn_del = node:getChildByName("DeleteRole")
    self.btn_rec = node:getChildByName("RecoveryRole")
    self.btn_rec:setVisible(false)
    
    node = self._csbNode:getChildByName("RolePanel")
    self.RoleImage = node:getChildByName("RoleImage")
    self.leftShadow = node:getChildByName("leftShadow")
    self.rightShadow = node:getChildByName("rightShadow")
       
    self.roleInfoNode = self._csbNode:getChildByName("roleInfoNode")
    self.roleInfoNode:setPosition(cc.p(-self.visibleSize.width / 2 + self.origin.x,-self.visibleSize.height / 2 + self.origin.y))
    self.pic_name = self.roleInfoNode:getChildByName("namePic")
    self.txt_weapean = self.roleInfoNode:getChildByName("weapeanTxt")
    self.txt_point = self.roleInfoNode:getChildByName("pointTxt")
    self.txt_core = self.roleInfoNode:getChildByName("coreTxt")
    
    require("game.login.view.RoleInfoItem")

    self.listView:removeAllChildren()
    local roleData = zzm.LoginModel:getRoleData()
    local dataList = roleData.allList
    self.m_dataList = dataList
    for index=1,roleData._ALL_ROLE_COUNT do
        local item = RoleInfoItem.create()
        self.listView:pushBackCustomItem(item)
        item:setParent(self)
        item:update(dataList[index])
        self.selectRoleData = dataList[1]
        table.insert(self._arrRole,item)
        if index == 1 and dataList[index] then
            self:selectRole(dataList[index], item)
            self.selectItem:select()
        end
        if index == 1 and not dataList[index] then
        	self:setInfo(0)
        end
    end

end

--function SelectRoleLayer:initEvent()
--    dxyDispatcher_addEventListener("SelectRoleLayer_delRole",self,self.delRole)
--    dxyDispatcher_addEventListener("SelectRoleLayer_changeRole",self,self.changeRole)
--end

function SelectRoleLayer:removeEvent()
    dxyDispatcher_removeEventListener("SelectRoleLayer_delRole",self,self.delRole)
    dxyDispatcher_removeEventListener("SelectRoleLayer_changeRole",self,self.changeRole)
    dxyDispatcher_removeEventListener("SelectRoleLayer_changeState",self,self.changeState)
    
--    if self.action_1 then
--    	self.action_1:removeFromParent()
--    	self.action_1 = nil
--    end
--    
--    if self.action_2 then
--        self.action_2:removeFromParent()
--        self.action_2 = nil
--    end
    
end

function SelectRoleLayer:delRole(uid)
    for key, var in pairs(self._arrRole) do
        if var.m_data and var.m_data.uid == uid then
            var:update()
            var.m_data = nil
            break
        end
    end
end

function SelectRoleLayer:changeRole(data)
    for key, var in pairs(self._arrRole) do
        if var.m_data and var.m_data.uid == data.uid then
            var:update(data)
            break
        end
    end
end

function SelectRoleLayer:chooseOtherOne()
    local item = nil
    for key=1,#self._arrRole do
        if self._arrRole[key].m_data then
            item = self._arrRole[key]
    	    break
    	end
    end
    self:selectRole(self.m_dataList[1],item)
    if item then
        item:select()
        self:changeState(self.m_dataList[1].time_del)
    else
        self._arrRole[1]:select()
        self:createRole()
    end
end

function SelectRoleLayer:initEvent()
    if(self.btn_start)then
        self.btn_start:addTouchEventListener(function(target,type)
            if(type==2)then
                SoundsFunc_playSounds(SoundsType.OPEN_PAGE,false)
                --zzc.LoginController:enterMainScene(roleUid)
                if self.selectRoleData then
--                    for key, var in pairs(self._arrRole) do
--                        if var._myTimer then
--                            var._myTimer:stop()
--                        end
--                    end
                    self:stopTimer()
                    local selectRoleUid = self.selectRoleData.uid
                    zzm.LoginModel.loginData.curRoleData = self.selectRoleData
                    zzc.LoginController:request_enterMainScene({uid = selectRoleUid, lv = self.selectRoleData.lv})
                    zzm.TalkingDataModel:setAccount(selectRoleUid)
                    zzm.TalkingDataModel:setGameServer(zzm.LoginModel.loginServer.name)
                    
                    if _G.gSDKuc then                   	
                        local extData = "{\"roleId\":\""..self.selectRoleData.uid.."\",\"roleName\":\""..self.selectRoleData.name.."\",\"roleLevel\":"..self.selectRoleData.lv..",\"zoneId\":"..zzm.LoginModel.loginServer.csid..",\"zoneName\":\""..zzm.LoginModel.loginServer.name.."\"}"
                        SDKManagerLua.instance():submitExtendData("loginGameRole",extData)
                    elseif _G.gSDKoppo then
                        local extData = "{\"grade\":\""..self.selectRoleData.lv.."\",\"role\":\""..self.selectRoleData.name.."\",\"service\":\""..zzm.LoginModel.loginServer.name.."\"}"
                        SDKManagerLua.instance():submitExtendData("loginGameRole",extData)
					elseif _G.gSDK93damai then
                        local extData = zzm.LoginModel.loginServer.name..","..self.selectRoleData.name..","..self.selectRoleData.lv
                        SDKManagerLua.instance():submitExtendData("loginGameRole",extData)
                    end
                else
                    SoundsFunc_playSounds(SoundsType.FAILE_TO_USE,false)
                    TipsFrame:create("没有选择角色")
                    print("没有选择角色")
                end
            end
        end)
    end

    if(self.btn_back)then
        self.btn_back:addTouchEventListener(function(target,type)
            if(type==2)then
                SoundsFunc_playSounds(SoundsType.CLOSE_PAGE,false)
--                for key, var in pairs(self._arrRole) do
--                    if var._myTimer then
--                        var._myTimer:stop()
--                    end
--                end
                self:stopTimer()
                zzc.LoginController:enterLayer(LoginLayerType.StartLayer)
            end
        end)
    end
    
    if (self.btn_del) then
    	self.btn_del:addTouchEventListener(function(target,type)
    	   if type == 2 then
                SoundsFunc_playSounds(SoundsType.OPEN_PAGE,false)
--                TipsFrame:create("暂未开放删除角色功能")
                require "game.login.view.DeleteLayer"
                local _csb = DeleteLayer:create(self.selectRoleData)
                self:addChild(_csb)
    	   end
    	end)
    end
    
    self.btn_rec:addTouchEventListener(function(target,type)
        if type == 2 then
            SoundsFunc_playSounds(SoundsType.OPEN_PAGE,false)
            require "game.login.view.RecoveryLayer"
            local _csb = RecoveryLayer:create(self.selectRoleData)
            self:addChild(_csb)
        end
    end)
    
    
    dxyDispatcher_addEventListener("SelectRoleLayer_delRole",self,self.delRole)
    dxyDispatcher_addEventListener("SelectRoleLayer_changeRole",self,self.changeRole)
    dxyDispatcher_addEventListener("SelectRoleLayer_changeState",self,self.changeState)
    
end

function SelectRoleLayer:createRole()
    print("create Role")
    self:stopTimer()
    zzc.LoginController:enterLayer(LoginLayerType.CreateRoleLayer) 
end

function SelectRoleLayer:selectRole(data, item)
    print("-------------select Role")
    self.selectRoleData = data
    if self.selectRoleData then
        if self.selectItem then
        	self.selectItem:unSelect()
        end
        self.selectItem = item
        self.selectItem:select()
        if self.selectRoleData.time_del == 0 then
            self.btn_del:setVisible(true)
            self.btn_rec:setVisible(false)
            self.btn_start:setVisible(true)
        else
            self.btn_del:setVisible(false)
            self.btn_rec:setVisible(true)
            self.btn_start:setVisible(false)
        end
    end
    self:setInfo(self.selectRoleData.pro)
end

function SelectRoleLayer:changeState(time_del)
    if time_del == 0 then
        self.btn_del:setVisible(true)
        self.btn_rec:setVisible(false)
        self.btn_start:setVisible(true)
    else
        self.btn_del:setVisible(false)
        self.btn_rec:setVisible(true)
        self.btn_start:setVisible(false)
    end
end

function SelectRoleLayer:setInfo(type)
    self.RoleImage:removeAllChildren()
    if type == 0 then
        self.RoleImage:setVisible(false)
        self.leftShadow:setVisible(false)
        self.rightShadow:setVisible(false)

        self.pic_name:setVisible(false)

        self.roleInfoNode:setVisible(false)
        self.btn_del:setVisible(false)
        return
    end
	local data = HeroConfig:getValueById(type)
	
    local boneName_1 = data["CreateBone"]
    self.action_1 = mc.SkeletonDataCash:getInstance():createWithCashName(boneName_1)
--    self.action_1 = sp.SkeletonAnimation:create(boneName_1..".json", boneName_1..".atlas")
    self.action_1:addAnimation(1,"start", false)
    self.action_1:addAnimation(1,"ready", true)
    self.action_1:setPosition(0,0)
    self.RoleImage:addChild(self.action_1)
    
    local boneName_2 = data["BoneEffect"]
    self.action_2 = mc.SkeletonDataCash:getInstance():createWithCashName(boneName_2)
--    self.action_2 = sp.SkeletonAnimation:create(boneName_2..".json", boneName_2..".atlas")
    self.action_2:setBlendFunc({src = gl.SRC_ALPHA,dst = gl.ONE})
    self.action_2:addAnimation(1,"start", false)
    self.action_2:addAnimation(1,"ready", true)
    self.action_2:setPosition(0,0)
    self.action_1:addChild(self.action_2)

    self.pic_name:setTexture(data["NameIcon"])
    
    self.leftShadow:setTexture(data["BgLeft"])
    self.rightShadow:setTexture(data["BgRight"])
	
    self.txt_weapean:setString(data["Weapon"])
    self.txt_point:setString(data["Trait"])
    self.txt_core:setString(data["Core"])
    
    self:heroSound(data["Job"])
end

function SelectRoleLayer:heroSound(pro)
    if pro == 1 then
--        SoundsFunc_playSounds(SoundsType.XZ_SOUND,false)
        cc.SimpleAudioEngine:getInstance():playEffect(SoundsType.XZ_SOUND,false)
    elseif pro == 2 then
--        SoundsFunc_playSounds(SoundsType.HY_SOUND,false)
        cc.SimpleAudioEngine:getInstance():playEffect(SoundsType.HY_SOUND,false)
    elseif pro == 3 then
--        SoundsFunc_playSounds(SoundsType.LQ_SOUND,false)
        cc.SimpleAudioEngine:getInstance():playEffect(SoundsType.LQ_SOUND,false)
    end
end


---------------------------
--@param
--@return
function SelectRoleLayer:stopTimer()
     for key, var in pairs(self._arrRole) do
        if var._myTimer then
            var._myTimer:stop()
        end
    end
end
