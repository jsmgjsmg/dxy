GoodsGetLayer = GoodsGetLayer or class("GoodsGetLayer",function()
    return cc.Layer:create()
end)

local HEIGHT = 100
local WIDTH = 100
local ROW = 9 

function GoodsGetLayer.create()
    local layer = GoodsGetLayer.new()
    return layer
end

function GoodsGetLayer:ctor()
    self._csbNode = nil
    self._arrBoxItem = {}
    self:initUI()
    dxyExtendEvent(self)
    dxySwallowTouches(self)--拦截
end

function GoodsGetLayer:initUI()
    self._csbNode = cc.CSLoader:getInstance():createNodeWithFlatBuffersFile("dxyCocosStudio/csd/ui/immortalfield/GoodsGetLayer.csb")
    self:addChild(self._csbNode)
    
    self.visibleSize = cc.Director:getInstance():getVisibleSize()
    self.origin = cc.Director:getInstance():getVisibleOrigin()
    local posX = self.origin.x + self.visibleSize.width/2
    local posY = self.origin.y + self.visibleSize.height/2

    self._csbNode:setPosition(posX, posY)
    
    self.btn_back = self._csbNode:getChildByName("btnBack")
    self.panel = self._csbNode:getChildByName("Panel")
    self.btn_get = self._csbNode:getChildByName("BtnGet")
    
    local goodsData = zzm.ImmortalFieldModel.goodsData
    self:addGoodsItem(goodsData)
end

function GoodsGetLayer:removeEvent()
    dxyDispatcher_removeEventListener("GoodsGetLayer_updateItem",self,self.updateItem)
    dxyDispatcher_removeEventListener("GoodsGetLayer_addItem",self,self.addItem)
    dxyDispatcher_removeEventListener("GoodsGetLayer_addData",self,self.addData)
end

function GoodsGetLayer:initEvent()
    dxyDispatcher_addEventListener("GoodsGetLayer_updateItem",self,self.updateItem)
    dxyDispatcher_addEventListener("GoodsGetLayer_addItem",self,self.addItem)
    dxyDispatcher_addEventListener("GoodsGetLayer_addData",self,self.addData)
    if self.btn_back then
        self.btn_back:addTouchEventListener(function(target,type)
            if (type == 2) then
                zzc.ImmortalFieldController:exitGoodsGetLayer()
            end
        end)
    end
    
    if self.btn_get then
        self.btn_get:addTouchEventListener(function(target,type)
            if (type == 2) then
                if self.state_btn then
                	zzc.ImmortalFieldController:request_GoodsGet()
                    zzc.ImmortalFieldController:exitGoodsGetLayer()
                    zzm.ImmortalFieldModel.isShow = true
                else
                    dxyFloatMsg:show("退出仙域后才能领取")
                end
            end
        end)
    end
end

function GoodsGetLayer:addGoodsItem(data)
    local posx = 0
    local posy = 0
    local count = 0
    self.panel:setScrollBarEnabled(false)
    local svWidth = self.panel:getContentSize().width
    local svHeight = ROW * HEIGHT
    self.panel:setInnerContainerSize(cc.size(svWidth,svHeight))
    require "game.tilemap.immortalfield.view.ItemGoods"
    
    local copyCsb = cc.CSLoader:createNode("dxyCocosStudio/csd/ui/immortalfield/ItemGoods.csb")
    local copyUnit = copyCsb:getChildByName("Panel")
    
    for i=1,9 do --列
        posy = (i-1) * HEIGHT + 60
        for j=1,8 do --行
            posx = (j-1) * WIDTH + 75
            
            local item = ItemGoods:create()
            local unit = copyUnit:clone()
            item:initUI(unit)
            
            count = count + 1
            self._arrBoxItem[count] = item
            self._arrBoxItem[count]:update(data[count])
            self.panel:addChild(self._arrBoxItem[count],1)
            self._arrBoxItem[count]:setPosition(posx,svHeight - posy)
        end
    end
end

function GoodsGetLayer:updateItem()
	local count = 0
	for i = 1, 9 do
		for j = 1, 8 do
            count = count + 1
            self._arrBoxItem[count]:update(zzm.ImmortalFieldModel.goodsData[count])
		end
	end
end

function GoodsGetLayer:addItem(data)
    for key, var in ipairs(self._arrBoxItem) do
		if var.m_data == nil then
			var:update(data)
		end
	end
end

function GoodsGetLayer:addData(data)
    for key, var in ipairs(self._arrBoxItem) do
        if var.m_data then
            if data.id and data.type == 6 then
                if var.m_data.id and var.m_data.id == data.id then
                    var:update(data)
                end
            else
                if var.m_data.type == data.type then
                    var:update(data)
                end
            end
        end
    end
end

function GoodsGetLayer:setBtn_get(state)
    self.state_btn = state
--    self.btn_get:setBright(state)
--    self.btn_get:setTouchEnabled(state) 
end