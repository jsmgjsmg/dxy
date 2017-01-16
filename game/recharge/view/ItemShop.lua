ItemShop = ItemShop or class("ItemShop",function()
    return ccui.Button:create("res/dxyCocosStudio/png/recharge/bg1.png","res/dxyCocosStudio/png/recharge/bg3.png","")
end)
local PATH = "res/Icon/"

function ItemShop:ctor()
    self._data = nil
end

function ItemShop:create()
    local node = ItemShop:new()
    node:init()
    return node
end

function ItemShop:init()
    self._csb = cc.CSLoader:createNode("res/dxyCocosStudio/csd/ui/recharge/ItemShop.csb")
    self:setAnchorPoint(0,1)
    self:addChild(self._csb)
    local conSize = self:getContentSize()
    self._csb:setPosition(0,conSize.height)

--icon
    self._icon = self._csb:getChildByName("icon")

--推荐
    self._recom = self._csb:getChildByName("recom")
    self._txtTitle = self._csb:getChildByName("txtTitle")
    self._txtUp = self._csb:getChildByName("txtUp")
    self._txtDown = self._csb:getChildByName("txtDown")
    self._upIcon = self._csb:getChildByName("upIcon")
    self._downIcon = self._csb:getChildByName("downIcon")
    
    if _G.gSDK93damai or _G.gSDK93damai185 then
    	self._txtDown:setVisible(false)
    else
        self._txtDown:setVisible(true)
    end
    
--btn
    local btnBuy = self._csb:getChildByName("btnBuy")
    btnBuy:addTouchEventListener(function(target,type)
        if type == 2 then
            SoundsFunc_playSounds(SoundsType.UNIVERSAL_BTN,false)
--            if self._data["Id"] == RechargeConfig:getMonthCard().Id then
--                zzc.RechargeController:MonthCard(self._data["Id"])
--            else
--                zzc.RechargeController:Recharge(self._data["Id"])
--            end
            local virtualCurrencyAmount = 0 --购买可以获得的元宝
--            if self._data["Id"] == RechargeConfig:getMonthCard().Id then
--                virtualCurrencyAmount = tonumber(self._data["Sycee"]) * tonumber(self._data["Day"])
--            else
--                virtualCurrencyAmount = tonumber(self._data["Sycee"]) + tonumber(self._data["DonateSycee"])
--                for i=1,#zzm.RechargeModel._arrRecList do
--                    if zzm.RechargeModel._arrRecList[i]["Id"] == self._data["Id"] and zzm.RechargeModel._arrRecList[i]["Num"] >= self._data["Count"] then
--                        virtualCurrencyAmount = tonumber(self._data["Sycee"])
--                    end
--                end
--            end
            
            if _G.gSDKcgamebt then           	
                local role = zzm.CharacterModel:getCharacterData()
                local enCAT = enCharacterAttrType
                SDKManagerLua.instance():pay(tonumber(self._data["Rmb"]),zzm.LoginModel.loginServer.sid,role:getValueByType(enCAT.UID),self._data["Id"],tostring(virtualCurrencyAmount))
            elseif _G.gSDKhuawei then
                local role = zzm.CharacterModel:getCharacterData()
                local enCAT = enCharacterAttrType
                local customField = role:getValueByType(enCAT.UID) .."-".. zzm.LoginModel.loginServer.sid .."-".. self._data["Id"]
                local jsonStr = "{\"productName\":\""..self._data["GoodsName"].."\",\"productDesc\":\""..self._data["Content"].."\"}"
                SDKManagerLua.instance():pay(tonumber(self._data["Rmb"]),0,customField,jsonStr,tostring(virtualCurrencyAmount))
            elseif _G.gSDKoppo then
                local role = zzm.CharacterModel:getCharacterData()
                local enCAT = enCharacterAttrType
				local customField = role:getValueByType(enCAT.UID) .."-".. zzm.LoginModel.loginServer.sid .."-".. self._data["Id"]
                SDKManagerLua.instance():pay(tonumber(self._data["Rmb"]),0,self._data["GoodsName"],customField,tostring(virtualCurrencyAmount))
            elseif _G.gSDK360 then
                local role = zzm.CharacterModel:getCharacterData()
                local enCAT = enCharacterAttrType
                local jsonStr = "{\"productName\":\""..self._data["GoodsName"].."\",\"productId\":\""..self._data["Id"].."\",\"roleId\":\""..role:getValueByType(enCAT.UID).."\",\"serverId\":\""..zzm.LoginModel.loginServer.sid.."\"}"
                SDKManagerLua.instance():pay(tonumber(self._data["Rmb"]),0,role:getValueByType(enCAT.NAME),jsonStr,tostring(virtualCurrencyAmount))
            elseif _G.gSDKbaidu then
                local role = zzm.CharacterModel:getCharacterData()
                local enCAT = enCharacterAttrType
                local customField = role:getValueByType(enCAT.UID) .."-".. zzm.LoginModel.loginServer.sid .."-".. self._data["Id"]
                SDKManagerLua.instance():pay(tonumber(self._data["Rmb"]),0,self._data["GoodsName"],customField,tostring(virtualCurrencyAmount))
            elseif _G.gSDKxiaomi then
                local role = zzm.CharacterModel:getCharacterData()
                local enCAT = enCharacterAttrType
                local customField = role:getValueByType(enCAT.UID) .."-".. zzm.LoginModel.loginServer.sid .."-".. self._data["Id"]
                
                local sociaty = ""
                if _G.GroupData.State == 1 then
                    sociaty = zzm.GroupModel.GroupData["Name"]
                end
                local splitField = role:getValueByType(enCAT.RMB).."-".._G.RoleData.VipLv.."-"..role:getValueByType(enCAT.LV).."-"..sociaty.."-"..role:getValueByType(enCAT.NAME).."-"..role:getValueByType(enCAT.UID).."-"..zzm.LoginModel.loginServer.name
                SDKManagerLua.instance():pay(tonumber(self._data["Rmb"]),0,splitField,customField,tostring(virtualCurrencyAmount))
            elseif _G.gSDKuc then
                local role = zzm.CharacterModel:getCharacterData()
                local enCAT = enCharacterAttrType
                local customField = role:getValueByType(enCAT.UID) .."-".. zzm.LoginModel.loginServer.sid .."-".. self._data["Id"]
                local splitField = ""
                SDKManagerLua.instance():pay(tonumber(self._data["Rmb"]),0,splitField,customField,tostring(virtualCurrencyAmount))
			 elseif _G.gSDK93damai then           	
                local role = zzm.CharacterModel:getCharacterData()
                local enCAT = enCharacterAttrType
				local ext2 =  self._data["Id"] --.."_"..self._data["Content"]
                --SDKManagerLua.instance():pay(tonumber(self._data["Rmb"]),zzm.LoginModel.loginServer.sid,role:getValueByType(enCAT.UID),self._data["Id"],tostring(virtualCurrencyAmount))
				SDKManagerLua.instance():pay(tonumber(self._data["Rmb"]),zzm.LoginModel.loginServer.sid,role:getValueByType(enCAT.UID),self._data["GoodsName"],ext2)
			elseif _G.gSDK93damai185 then           	
                local role = zzm.CharacterModel:getCharacterData()
                local enCAT = enCharacterAttrType
				local ext2 =  self._data["Id"]
                --SDKManagerLua.instance():pay(tonumber(self._data["Rmb"]),zzm.LoginModel.loginServer.sid,role:getValueByType(enCAT.UID),self._data["Id"],tostring(virtualCurrencyAmount))
				SDKManagerLua.instance():pay(tonumber(self._data["Rmb"]),zzm.LoginModel.loginServer.csid,role:getValueByType(enCAT.UID),zzm.LoginModel.loginData.curRoleData.name,ext2)
            elseif _G.gSDKhuoshu then
                local role = zzm.CharacterModel:getCharacterData()
                local enCAT = enCharacterAttrType
                local customField = role:getValueByType(enCAT.UID) .."-".. zzm.LoginModel.loginServer.sid .."-".. self._data["Id"]
                local splitField = role:getValueByType(enCAT.UID).."-"..zzm.LoginModel.loginServer.sid.."-"..self._data["GoodsName"].."-"..self._data["Content"]
                SDKManagerLua.instance():pay(tonumber(self._data["Rmb"]),0,splitField,customField,tostring(virtualCurrencyAmount))
			elseif _G.gSDKAoyou then           	
                local role = zzm.CharacterModel:getCharacterData()
                local enCAT = enCharacterAttrType
				local ext2 =  self._data["Id"]
                --SDKManagerLua.instance():pay(tonumber(self._data["Rmb"]),zzm.LoginModel.loginServer.sid,role:getValueByType(enCAT.UID),self._data["Id"],tostring(virtualCurrencyAmount))
				SDKManagerLua.instance():pay(tonumber(self._data["Rmb"]),zzm.LoginModel.loginServer.sid,role:getValueByType(enCAT.UID),zzm.LoginModel.loginData.curRoleData.name,ext2)
            end
        end
    end)   
    
    self._txtYB = btnBuy:getChildByName("txtYB")
end

function ItemShop:setData(data)
    self._data = data
    if self._data["Id"] == RechargeConfig:getMonthCard().Id then
        self._txtUp:setPositionX(102)
        self._txtDown:setPositionX(84)
    end
    self._icon:setTexture(PATH..self._data["Icon"])
    local title = self._data["GoodsName"] == nil and self._data["Sycee"] or self._data["GoodsName"]
    self._txtTitle:setString(title)

    if self._data["RecommendIcon"] == 2 then
        self._recom:setVisible(false)
    end

    local txtUp = self._data["Content1"] or ""
    local last,num = string.gsub(txtUp,"*","")
    self._txtUp:setString(last)
    if num > 0 then
        local width = self._txtUp:getContentSize().width / 2
        local posx,posy = self._txtUp:getPosition()
        posx = posx + width
        self._upIcon:setVisible(true)
        self._upIcon:setPosition(posx,posy)
    end
    
    local txtDown = self._data["Content2"] or ""
    local last,num = string.gsub(txtDown,"*","")
    self._txtDown:setString(last)
    if num > 0 then
        local width = self._txtDown:getContentSize().width / 2
        local posx,posy = self._txtDown:getPosition()
        posx = posx + width
        self._downIcon:setVisible(true)
        self._downIcon:setPosition(posx,posy)
    end
    
    self._txtYB:setString(self._data["Rmb"])
    
    for i=1,#zzm.RechargeModel._arrRecList do
        if zzm.RechargeModel._arrRecList[i]["Id"] == self._data["Id"] and self._data["Count"] and
            zzm.RechargeModel._arrRecList[i]["Num"] >= self._data["Count"] then
--            self._txtUp:setString("")
            
            local txtUp = self._data["Content3"] or ""
            local last,num = string.gsub(txtUp,"*","")
            self._txtUp:setString(last)
            if num > 0 then
                local width = self._txtUp:getContentSize().width / 2
                local posx,posy = self._txtUp:getPosition()
                posx = posx + width
                self._upIcon:setVisible(true)
                self._upIcon:setPosition(posx,posy)
            else
                self._upIcon:setVisible(false)
            end
            
            self._txtDown:setString("")
            self._recom:setVisible(false)
--            self._upIcon:setVisible(false)
            self._downIcon:setVisible(false)
        end
    end
	
	if self._downIcon:isVisible() then
		self._txtDown:setVisible(true)
	end
end
