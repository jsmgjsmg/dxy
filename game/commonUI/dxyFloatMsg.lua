--[[
local msg = "提示信息"
dxyFloatMsg:show(msg)
dxyFloatMsg:show("提示信息")
--]]

dxyFloatMsg = dxyFloatMsg or class("dxyFloatMsg",function()
    return cc.Node:create()
end)

dxyFloatMsg.isOpen = true

function dxyFloatMsg:ctor()
    self._csbNode = nil
    self:initUI()
end

function dxyFloatMsg:initUI()
    self._csbNode = cc.CSLoader:getInstance():createNodeWithFlatBuffersFile("dxyCocosStudio/csd/ui/commonUI/FloatMsg.csb")
    self:addChild(self._csbNode)
    
    self.visibleSize = cc.Director:getInstance():getVisibleSize()
    self.origin = cc.Director:getInstance():getVisibleOrigin()

    self.bg = self._csbNode:getChildByName("Sprite")
    self.text = self._csbNode:getChildByName("Text")
end
    
function dxyFloatMsg:show(msg)
    if not msg then return end
    if dxyFloatMsg.isOpen == false then
    	return
    end
    local floatMsg = dxyFloatMsg.new()
    floatMsg:init(msg)
    SceneManager:getCurrentScene():addChild(floatMsg) 
end

function dxyFloatMsg:init(msg)
--    self.bg:setVisible(false)
    self.text:setString(msg)
    print(msg)
    
    local posX = self.origin.x + self.visibleSize.width/2
    local posYS = self.origin.y + self.visibleSize.height/2-100
    
    self:setPosition(posX, posYS)
    
 --   local action1 = cc.EaseSineOut:create(cc.MoveBy:create(0.8,cc.p(0,200)))
	local action1 = cc.MoveBy:create(1.25,cc.p(0,270))
    local action2 = cc.CallFunc:create(function() self:removeFromParent() end)
    --local action3 = cc.DelayTime:create(0.1)
    local sequence = cc.Sequence:create(action1, action2)
    self:runAction(sequence)
end