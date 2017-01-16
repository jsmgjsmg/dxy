local TipsMakeUp = class("TipsMakeUp",function()
    return cc.Node:create()
end)

function TipsMakeUp:ctor()
    self.visibleSize = cc.Director:getInstance():getVisibleSize()
    self.origin = cc.Director:getInstance():getVisibleOrigin()
end

function TipsMakeUp:create()
    local node = TipsMakeUp:new()
    node:init()
    return node
end

function TipsMakeUp:init()
    self._csb = cc.CSLoader:createNode("res/dxyCocosStudio/csd/ui/task/TipsMakeUp.csb")
    self:addChild(self._csb)
    self._csb:setPosition(self.origin.x + self.visibleSize.width / 2, self.origin.y + self.visibleSize.height / 2)

-- 拦截
    dxySwallowTouches(self)
    
    local txtTips = self._csb:getChildByName("tipBG"):getChildByName("txtTips")
    
    local btnSure = self._csb:getChildByName("btn_sure")
    local btnCancel = self._csb:getChildByName("btn_cancel")
    
    local data = zzm.TaskModel.arrLogin
    local need = TaskConfig:getMakeUpNeed(data.Finish)
    txtTips:setString("×"..need)
    
    btnSure:addTouchEventListener(function(target,type)
        if type == 2 then
            SoundsFunc_playSounds(SoundsType.UNIVERSAL_BTN,false)
            zzc.TaskController:MakeUp()
            self:removeFromParent()    
        end
    end)
    
    btnCancel:addTouchEventListener(function(target,type)
        if type == 2 then
            SoundsFunc_playSounds(SoundsType.UNIVERSAL_BTN,false)
            self:removeFromParent()    
        end
    end)
end

return TipsMakeUp