DestroyFragment = DestroyFragment or class("DestroyFragment",function()
    return cc.Node:create()
end) 

function DestroyFragment:ctor()
    self.visibleSize = cc.Director:getInstance():getVisibleSize()
    self.origin = cc.Director:getInstance():getVisibleOrigin()
end

function DestroyFragment:create(data)
    local node = DestroyFragment:new()
    node:init(data)
    return node
end

function DestroyFragment:init(data)
    self._csb = cc.CSLoader:createNode("res/dxyCocosStudio/csd/ui/general/DestroyFragment.csb")
    self:addChild(self._csb)
    self._csb:setPosition(self.origin.x + self.visibleSize.width / 2, self.origin.y + self.visibleSize.height / 2)

    local image = self._csb:getChildByName("Image")
    
    self._data = data
    
    -- 拦截
    dxySwallowTouches(self,image)
    
    self._txtAll = self._csb:getChildByName("txtAll")
    local btnCut = self._csb:getChildByName("btnCut")
    local btnAdd = self._csb:getChildByName("btnAdd")
    self._num = 1
    local Max = self._data["Num"]
    self._textField = self._csb:getChildByName("TextField")
    self._textField:addEventListener(function(target,type)
        if type == 1 then
            self._num = tonumber(self._textField:getString())
            if self._num >= Max then
                self._textField:setString(Max)
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
            zzc.GeneralController:DestroyThing(self._data["Id"],self._num)
            for index=1, self._num do
                zzm.TalkingDataModel:onEvent(EumEventId.GENERAL_FRAGMENT_RESOLVE,{})
            end
            self:removeFromParent()
        end
    end)
    
    local btnAll = self._csb:getChildByName("btnAll")
    btnAll:addTouchEventListener(function(target,type)
        if type == 2 then
            SoundsFunc_playSounds(SoundsType.UNIVERSAL_BTN,false)
            local num = self._data.Num
            zzc.GeneralController:DestroyThing(self._data["Id"],num)
            self:removeFromParent()
        end
    end)

    self:CountRes(1)
end

function DestroyFragment:CountRes(num)
    local base = GodGeneralConfig:FragmentDestroyNum(self._data.Id)
    local all = num * base
    self._txtAll:setString(all)
end
