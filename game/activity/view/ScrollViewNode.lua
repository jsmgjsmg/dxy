ScrollViewNode = ScrollViewNode or class("ScrollViewNode",function()
    return cc.Node:create()
end)
local SPACE = 100

function ScrollViewNode:ctor()
    self._arrItem = {}
end

function ScrollViewNode:create() 
    local node = ScrollViewNode.new()
    node:init()
    return node
end

function ScrollViewNode:init()
    self._csb = cc.CSLoader:createNode("dxyCocosStudio/csd/ui/activity/ScrollViewNode.csb")
    self:addChild(self._csb)
    
    self._sv = self._csb:getChildByName("ScrollView")
    self._sv:setScrollBarEnabled(false)
end

function ScrollViewNode:update(data,type)
    local last = cn:setSVSize(self._sv,"height",#data,SPACE)
    for i=1,#data do
        self._arrItem[i] = _G[zzd.ActivityData.svRequire[type]]:create()
        self._arrItem[i]:update(data[i],type)
        self._sv:addChild(self._arrItem[i])
        self._arrItem[i]:setPosition(0,last-(i-1)*SPACE)
    end
end

function ScrollViewNode:changePro(data)
    for key, var in pairs(self._arrItem) do
    	if var.m_data.Id == data.Id then
            var:changePro(data)
    	    break
    	end
    end
end