SetPower = SetPower or class("SetPower",function()
    return cc.Node:create()
end)

function SetPower:ctor()
    self.visibleSize = cc.Director:getInstance():getVisibleSize()
    self.origin = cc.Director:getInstance():getVisibleOrigin()
end

function SetPower:create()
    local node = SetPower:new()
    node:init()
    return node
end

function SetPower:init()
    self._csb = cc.CSLoader:createNode("dxyCocosStudio/csd/ui/group/SetPower.csb")
    self:addChild(self._csb)
    self._csb:setPosition(self.origin.x + self.visibleSize.width / 2, self.origin.y + self.visibleSize.height / 2)

    -- 拦截
    dxySwallowTouches(self)
    self.GroupData = zzm.GroupModel.GroupData
    
--editbox
    local bg = self._csb:getChildByName("bg")
    local test = bg:getChildByName("test")
    local size = test:getContentSize()
    local posx,posy = test:getPosition()
    self._input = ccui.EditBox:create(size,"dxyCocosStudio/png/group/TM.jpg")
    bg:addChild(self._input)
    self._input:setMaxLength(13)
    self._input:setPosition(posx, posy-2)      
    self._input:setText(self.GroupData.PowerLimit)      
    
    self._check = self._csb:getChildByName("check")
    if self.GroupData.Auto == 0 then
        self._check:setSelectedState(false)
    elseif self.GroupData.Auto == 1 then
        self._check:setSelectedState(true)
    end
    
--btn
    local _btnSure = self._csb:getChildByName("btn_sure")
    _btnSure:addTouchEventListener(function(target,type)
        if type == 2 then
            local str = self._input:getText()
            local isSelect = self._check:isSelected()
            SoundsFunc_playSounds(SoundsType.UNIVERSAL_BTN,false)
            if str ~= "" and str ~= nil then
                local auto = 0
                if isSelect then
                    auto = 1
                else
                    auto = 0
                end
                zzc.GroupController:setPowerLimit(tonumber(str),auto)
                self:removeFromParent()
            end
        end       
    end)
    local _btnCancel = self._csb:getChildByName("btn_cancel")
    _btnCancel:addTouchEventListener(function(target,type)
        if type == 2 then
            SoundsFunc_playSounds(SoundsType.CLOSE_PAGE,false)
            self:removeFromParent()
        end       
    end)
end