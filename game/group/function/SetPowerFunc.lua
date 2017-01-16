SetPowerFunc = SetPowerFunc or class("SetPowerFunc",function()
    return cc.Node:create()
end)

function SetPowerFunc:ctor()
    self.visibleSize = cc.Director:getInstance():getVisibleSize()
    self.origin = cc.Director:getInstance():getVisibleOrigin()
end

function SetPowerFunc:create()
    local node = SetPowerFunc:new()
    node:init()
    return node
end 

function SetPowerFunc:init()
    self._csb = cc.CSLoader:createNode("res/dxyCocosStudio/csd/ui/groupfunc/SetPower.csb")
    self:addChild(self._csb)
    self._csb:setPosition(self.origin.x + self.visibleSize.width / 2, self.origin.y + self.visibleSize.height / 2)

    local bg = self._csb:getChildByName("Button_1")
    -- 拦截
    dxySwallowTouches(self,bg)
    
    local role = zzm.CharacterModel:getCharacterData()
    local enCAT = enCharacterAttrType
    local TCLEVEL = role:getValueByType(enCAT.TCLEVEL)
    
    self._txtLevel = self._csb:getChildByName("txtLevel")
    self._txtLevel:setString(zzm.GroupModel.curLevelSelect.Id)
    
    self._btnCut = self._csb:getChildByName("btnCut")
    self._btnAdd = self._csb:getChildByName("btnAdd")
    self._btnCut:addTouchEventListener(function(target,type)
        if type == 2 then
--            local txtLevel = self._txtLevel:getString() - 1
--            if txtLevel <= 0 then
--                return
--            end
--            self._txtLevel:setString(txtLevel)
        end
    end)
    self._btnAdd:addTouchEventListener(function(target,type)
        if type == 2 then
--            local txtLevel = self._txtLevel:getString() + 1
--            if txtLevel > GroupConfig:getSkyPagodaLen() or txtLevel > TCLEVEL + 1 then
--                return
--            end
--            self._txtLevel:setString(txtLevel)
        end
    end)
    
    local btnSend = self._csb:getChildByName("btnSend")
    btnSend:addTouchEventListener(function(target,type)
        if type == 2 then
            zzc.GroupController:sendTeamCopyAdd(tonumber(self._txtSlider:getString()),tonumber(self._txtLevel:getString()))
            dxyFloatMsg:show("已发送消息")
            self:removeFromParent()
            dxyDispatcher_dispatchEvent("TeamCopy_lockSV")
        end
    end)
    
    self._Slider = self._csb:getChildByName("Slider")
    self._txtSlider = self._csb:getChildByName("txtSlider")
    
    local role = zzm.CharacterModel:getCharacterData()
    local enCAT = enCharacterAttrType
    local power = role:getValueByType(enCAT.POWER)
    self._txtSlider:setString(power)
    
    local function SliderCallBack(target,type)
        self._percent = target:getPercent()
        local curPower = math.ceil(power * ((self._percent+50)/100))
        self._txtSlider:setString(curPower)
    end
    self._Slider:addEventListener(SliderCallBack)
end
