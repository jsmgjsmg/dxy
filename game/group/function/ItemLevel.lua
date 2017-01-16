ItemLevel = ItemLevel or class("ItemLevel",function()
    return ccui.Layout:create()
end)
local CB_NUM = 9

function ItemLevel:ctor()
    self.arrCheckBox = {}
end

function ItemLevel:create()
    local node = ItemLevel.new()
    node:init()
    return node
end

function ItemLevel:init()
    self._csb = cc.CSLoader:createNode("dxyCocosStudio/csd/ui/groupfunc/ItemLevel.csb")
    self:addChild(self._csb)
    
    self.ScrollView = self._csb:getChildByName("ScrollView")
    for i=1,CB_NUM do
        self.arrCheckBox[i] = self.ScrollView:getChildByName("CheckBox_"..i)
        self.arrCheckBox[i]:addEventListener(function(target,type)
            
        end)
    end
    
end

