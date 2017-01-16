
NewFunctionEffect = NewFunctionEffect or class("NewFunctionEffect",function()
    return cc.Layer:create()
end)

function NewFunctionEffect.create()
    local layer = NewFunctionEffect.new()
    return layer
end

function NewFunctionEffect:ctor()
    self._csbNode = nil
    self:initUI()
end

function NewFunctionEffect:initUI()
    self._csbNode = cc.CSLoader:getInstance():createNodeWithFlatBuffersFile("res/dxyCocosStudio/csd/ui/guide/NewFunctionLayer.csb")
    self:addChild(self._csbNode)
    
    self.Icon = self._csbNode :getChildByName("FunctionNode"):getChildByName("Icon")
    self.jiangliIcon = self._csbNode :getChildByName("FunctionNode"):getChildByName("jiangliIcon")
end

function NewFunctionEffect:setData(data)
    self.m_data = data
    if self.m_data and self.Icon then
        self.Icon:loadTexture(self.m_data.OpenIcon)
        self.jiangliIcon:setVisible(false)
    end
end

function NewFunctionEffect:setjiangliIcon(data)
    self.m_data = data
    if self.m_data and self.jiangliIcon then
        self.jiangliIcon:loadTexture(self.m_data.OpenIcon)
        self.Icon:setVisible(false)
    end
end



