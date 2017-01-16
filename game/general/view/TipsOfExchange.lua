local TipsOfExchange = class("TipsOfExchange",function()
    return cc.Node:create()
end) 

function TipsOfExchange:ctor()
    self.visibleSize = cc.Director:getInstance():getVisibleSize()
    self.origin = cc.Director:getInstance():getVisibleOrigin()
end

function TipsOfExchange:create(data)
    local node = TipsOfExchange:new()
    node:init(data)
    return node
end

function TipsOfExchange:init(data)
    self._csb = cc.CSLoader:createNode("res/dxyCocosStudio/csd/ui/general/TipsOfExchange.csb")
    self:addChild(self._csb)
    self._csb:setPosition(self.origin.x + self.visibleSize.width / 2, self.origin.y + self.visibleSize.height / 2)

    local image = self._csb:getChildByName("Image")

    self._data = data

    -- 拦截
    dxySwallowTouches(self,image)
    
    self._base = GodGeneralConfig:getShopPrice(self._data.Quality)
--value    
    local role = zzm.CharacterModel:getCharacterData()
    local enCAT = enCharacterAttrType
    self._energySoul = role:getValueByType(enCAT.ENERGYSOUL)
    self._max = math.modf(self._energySoul / self._base)
    if self._max <= 0 then
        self._max = 1
    end
        
    local bgColor = self._csb:getChildByName("bgColor")
    local colour = GodGeneralConfig:getMsgColour(data.Id,1).IconLittle
    bgColor:setTexture("res/GodGeneralsIcon/"..colour)
    
    local spIcon = self._csb:getChildByName("spIcon")
    local icon = GoodsConfigProvider:findGoodsById(data.Id).Icon
    spIcon:setTexture("res/GodGeneralsIcon/"..icon..".png")
    
    local txtName = bgColor:getChildByName("txtName")
    txtName:setString(data.Name)
    txtName:setColor(Quality_Color[data.Quality])

    self._txtAll = self._csb:getChildByName("txtAll")
    local btnCut = self._csb:getChildByName("btnCut")
    local btnAdd = self._csb:getChildByName("btnAdd")
    self._num = 1
    local Max = 99
    self._textField = self._csb:getChildByName("TextField")
    self._textField:addEventListener(function(target,type)
        if type == 1 then
            self._num = tonumber(self._textField:getString())
            if self._num >= self._max then
                self._textField:setString(self._max)
                btnAdd:setTouchEnabled(false)
                btnAdd:setBright(false)
                btnCut:setTouchEnabled(true)
                btnCut:setBright(true)
            elseif self._num <= 0 then
                self._textField:setString(1)
                btnCut:setTouchEnabled(false)
                btnCut:setBright(false)
                btnAdd:setTouchEnabled(true)
                btnAdd:setBright(true)
            else
                btnCut:setTouchEnabled(true)
                btnCut:setBright(true)
                btnAdd:setTouchEnabled(true)
                btnAdd:setBright(true)
            end
            if self._num >= Max then
                self._textField:setString(Max)
            end
            self._num = self._textField:getString()
            self:CountRes(self._num)
        end
    end)

    btnCut:addTouchEventListener(function(target,type)
        if type == 2 then
            SoundsFunc_playSounds(SoundsType.UNIVERSAL_BTN,false)
            self._num = tonumber(self._textField:getString())
            if self._num - 1 <= 0 then
                btnCut:setTouchEnabled(false)
                btnCut:setBright(false)
            else
                self._num = self._num - 1
                if self._num == 1 then
                    btnCut:setTouchEnabled(false)
                    btnCut:setBright(false)
                end
                self._textField:setString(self._num)
                self:CountRes(self._num)
                btnAdd:setTouchEnabled(true)
                btnAdd:setBright(true)
            end
        end
    end)
    btnCut:setTouchEnabled(false)
    btnCut:setBright(false)

    btnAdd:addTouchEventListener(function(target,type)
        if type == 2 then
            SoundsFunc_playSounds(SoundsType.UNIVERSAL_BTN,false)
            self._num = tonumber(self._textField:getString())
            if self._num + 1 > Max then
                btnAdd:setTouchEnabled(false)
                btnAdd:setBright(false)
            else
                self._num = self._num + 1
                if self._num == Max then
                    btnAdd:setTouchEnabled(false)
                    btnAdd:setBright(false)
                end
                self._textField:setString(self._num)
                self:CountRes(self._num)
                btnCut:setTouchEnabled(true)
                btnCut:setBright(true)
            end
        end
    end)

    local btnSure = self._csb:getChildByName("btnSure")
    btnSure:addTouchEventListener(function(target,type)
        if type == 2 then
            SoundsFunc_playSounds(SoundsType.UNIVERSAL_BTN,false)
            self._num = self._textField:getString()
            if self._data.Quality == 5 then
                local vip = VipConfig:getVipByPrivilege(DefineConst.CONST_VIP_PRIVILEGE_TYPE_GODCHIP_GOLD_EXCHANGE)
                if vip <= _G.RoleData.VipLv then
                    zzc.GeneralController:ConvertFragment(self._data.ChipId,self._num)
                else
                    cn:TipsSchedule("需要 Vip"..vip.." 才能兑换")
                end
            else
                zzc.GeneralController:ConvertFragment(self._data.ChipId,self._num)
            end
            self:removeFromParent()
        end
    end)
    
    self:CountRes(1)
end

function TipsOfExchange:CountRes(num)
    local all = num * self._base
    self._txtAll:setString(all)
end

return TipsOfExchange
