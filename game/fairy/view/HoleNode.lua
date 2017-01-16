HoleNode = HoleNode or class("HoleNode",function()
    return cc.Node:create()
end)

function HoleNode:ctor()
    self.visibleSize = cc.Director:getInstance():getVisibleSize()
    self.origin = cc.Director:getInstance():getVisibleOrigin()
    self._arrBtnHole = {}
    self._arrBflValue = {}
    self._arrObtain = {}
    self._arrTimer = {}
end

function HoleNode:create(data)
    local node = HoleNode:new()
    node:initNode(data)
    return node
end

function HoleNode:initNode(data)
    self._csb = cc.CSLoader:createNode("res/dxyCocosStudio/csd/ui/fairy/HoleNode.csb")
    self:addChild(self._csb)
    self._csb:setPosition(self.origin.x + self.visibleSize.width / 2, self.origin.y + self.visibleSize.height / 2)
    
    dxyExtendEvent(self)
    -- 拦截
    dxySwallowTouches(self)
    
    local swallow = self._csb:getChildByName("swallow")
    swallow:setContentSize(self.visibleSize.width,self.visibleSize.height)
    
    local _btnBack = self._csb:getChildByName("bgHole"):getChildByName("btn_back")
    _btnBack:addTouchEventListener(function(target,type)
        if type == 2 then
            SoundsFunc_playSounds(SoundsType.CLOSE_PAGE,false)
            self:removeFromParent()
        end
    end)
    
    self._HoldNum = FairyConfig:getHoleNum()
    
    local _ndHole = self._csb:getChildByName("nd_hole")
    for i=1,self._HoldNum do
        self._arrBtnHole[i] = _ndHole:getChildByName("btn_hole"..i)
        self._arrObtain[i] = self._arrBtnHole[i]:getChildByName("txtObtain")
        self._arrBflValue[i] = self._arrBtnHole[i]:getChildByName("bfl_value")
        self._arrTimer[i] = self._arrBtnHole[i]:getChildByName("txtTimer")
        local config = FairyConfig:getGoldByHole(data.Lv,i)
        self._arrObtain[i]:setString("经验: "..math.floor(config.Exp)) 
        self._arrBflValue[i]:setString(config.ExpGold)
        self._arrTimer[i]:setString("双休时间 "..(config.ExpAcquireTime/3600).." 小时")
        self._arrBtnHole[i]:addTouchEventListener(function(target,type)
            if type == 2 then
                SoundsFunc_playSounds(SoundsType.UNIVERSAL_BTN,false)
                zzc.FairyController:registerSendDoit(data["Id"],i)
            end
        end)
    end
end

function HoleNode:initEvent()
    dxyDispatcher_addEventListener("closeWin",self,self.closeWin)
end

function HoleNode:removeEvent()
    dxyDispatcher_removeEventListener("closeWin",self,self.closeWin)
end

function HoleNode:closeWin()
    self:removeFromParent()
end