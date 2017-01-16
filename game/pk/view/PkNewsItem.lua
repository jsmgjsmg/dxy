PkNewsItem = PkNewsItem or class("PkNewsItem",function()
    local path_1 = "dxyCocosStudio/png/pk/newsItemBg.png"
    local path_2 = "dxyCocosStudio/png/pk/newsItemBg_1.png"
    return ccui.Button:create(path_1,path_2,path_1)
end)

function PkNewsItem:create()
    local node = PkNewsItem:new()
    return node
end

function PkNewsItem:ctor()
    self._csb = nil

    self:initUI()
    self:initEvent()
end

function PkNewsItem:initUI()
    self._csb = cc.CSLoader:createNode("dxyCocosStudio/csd/ui/pk/pkNewsItem.csb")
    self:addChild(self._csb)
end

function PkNewsItem:initEvent()

end

function PkNewsItem:update(data)
    self.m_data = data
end