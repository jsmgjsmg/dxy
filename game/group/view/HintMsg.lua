HintMsg = HintMsg or class("HintMsg",function()
    return cc.Node:create()
end)

function HintMsg:ctor()
    self.visibleSize = cc.Director:getInstance():getVisibleSize()
    self.origin = cc.Director:getInstance():getVisibleOrigin()
end

function HintMsg:create(data)
    local node = HintMsg:new()
    node:init(data)
    return node
end

function HintMsg:init(data)
    self._csb = cc.CSLoader:createNode("dxyCocosStudio/csd/ui/group/HintMsg.csb")
    self:addChild(self._csb)
    self._csb:setPosition(self.origin.x + self.visibleSize.width / 2, self.origin.y + self.visibleSize.height / 2)

    -- 拦截
    dxySwallowTouches(self)

--pro
    local Content = self._csb:getChildByName("txt")
    Content:setString(data[3])
        
    local _btnSure = self._csb:getChildByName("btn_sure")
    _btnSure:addTouchEventListener(function(target,type)
        if type == 2 then
            SoundsFunc_playSounds(SoundsType.UNIVERSAL_BTN,false)
            zzc.GroupController:ChangeRoot(data[1],data[2])
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