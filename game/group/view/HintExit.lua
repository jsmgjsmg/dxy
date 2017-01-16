HintExit = HintExit or class("HintExit",function()
    return cc.Node:create()
end)

function HintExit:ctor()
    self.visibleSize = cc.Director:getInstance():getVisibleSize()
    self.origin = cc.Director:getInstance():getVisibleOrigin()
end

function HintExit:create(txt)
    local node = HintExit:new()
    node:init(txt)
    return node
end

function HintExit:init(txt)
    self._csb = cc.CSLoader:createNode("dxyCocosStudio/csd/ui/group/HintMsg.csb")
    self:addChild(self._csb)
    self._csb:setPosition(self.origin.x + self.visibleSize.width / 2, self.origin.y + self.visibleSize.height / 2)

--pro
    local Content = self._csb:getChildByName("txt")
    Content:setString(txt)

    local _btnSure = self._csb:getChildByName("btn_sure")
    _btnSure:addTouchEventListener(function(target,type)
        if type == 2 then
            SoundsFunc_playSounds(SoundsType.UNIVERSAL_BTN,false)
            zzc.GroupController:exitGroupFunc()
            zzc.GroupController:ExitGroup()
            dxyDispatcher_dispatchEvent("LeadLayer_stopTimer")
            self:removeFromParent()
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