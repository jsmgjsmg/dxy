Editing = Editing or class("Editing",function()
    return cc.Node:create()
end)

function Editing:ctor()
    self.visibleSize = cc.Director:getInstance():getVisibleSize()
    self.origin = cc.Director:getInstance():getVisibleOrigin()
end

function Editing:create(txt)
    local node = Editing:new()
    node:init(txt)
    return node
end

function Editing:init(txt)
    self._csb = cc.CSLoader:createNode("dxyCocosStudio/csd/ui/group/Editing.csb")
    self:addChild(self._csb)
    self._csb:setPosition(self.origin.x + self.visibleSize.width / 2, self.origin.y + self.visibleSize.height / 2)

    -- 拦截
    dxySwallowTouches(self)
    
    self._input = self._csb:getChildByName("input")
    self._input:setString(txt)
    
--btn
    local btnBack = self._csb:getChildByName("bg"):getChildByName("btn_back")
    btnBack:addTouchEventListener(function(target,type)
        if type == 2 then
            SoundsFunc_playSounds(SoundsType.CLOSE_PAGE,false)
            self:removeFromParent()
        end
    end)
    
    local btnInput = self._csb:getChildByName("btn_input")
    btnInput:addTouchEventListener(function(target,type)
        if type == 2 then
            SoundsFunc_playSounds(SoundsType.UNIVERSAL_BTN,false)
            local input = self._input:getString()
            zzc.GroupController:EditTenet(input)
            self:removeFromParent()
        end
    end)
end