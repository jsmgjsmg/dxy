require("game.equip.view.EquipItem")

BackpackLayer = BackpackLayer or class("BackpackLayer",function()
    return cc.Layer:create()
end)

PARAMETERS = {
    extra_width = 1.5,
    extra_height = 0,
    page_num = 3,
}

function BackpackLayer.create()
    local layer = BackpackLayer:new()
    return layer
end

function BackpackLayer:ctor()

    self.swallowNode = nil
    self.btn_swallow = ccui.Button
    self.btn_recommend = ccui.Button

    self.scrollView = cc.ScrollView
    self.btn_sell = ccui.Button

    self.itemList = {}

    self:initUI()

    dxyExtendEvent(self)
end

function BackpackLayer:initUI()
    local backpackLayer = cc.CSLoader:createNode("dxyCocosStudio/csd/ui/equip/backpackLayer.csb")
    self:addChild(backpackLayer)
    
    self.swallowNode = backpackLayer:getChildByName("swallowNode")
    self.btn_swallow = self.swallowNode:getChildByName("swallowBtn")
    self.btn_recommend = self.swallowNode:getChildByName("recommendBtn")
    
    self.btn_sell = backpackLayer:getChildByName("sellBtn")

    self.scrollView = backpackLayer:getChildByName("ScrollView")
    self.scrollView:setScrollBarEnabled(false)
    self.scrollView:setName("ScrollView")--BPscrollView/EquipItem/

    self:addEquipScrollView()
--    self:addBackpack()
    
    self:showSwallowBtn(false)

end

function BackpackLayer:showSwallowBtn(flag)
	if flag then
		self.swallowNode:setVisible(true)
        self.btn_sell:setVisible(false)
	else
        self.swallowNode:setVisible(false)
        self.btn_sell:setVisible(true)
	end
end

function BackpackLayer:removeEvent()
    
    dxyDispatcher_removeEventListener(dxyEventType.Backpack_Refresh,self,self.refreshItem)
    dxyDispatcher_removeEventListener(dxyEventType.Swallow_reSelected,self,self.swallowSelected)

    dxyDispatcher_removeEventListener(dxyEventType.UserItem_AddItem,self,self.addItem)
    dxyDispatcher_removeEventListener(dxyEventType.UserItem_DelItem,self,self.delItem)
    dxyDispatcher_removeEventListener(dxyEventType.UserItem_Replace,self,self.changeItem)
end


function BackpackLayer:initEvent()

    self:refreshItem()
    
    dxyDispatcher_addEventListener(dxyEventType.Backpack_Refresh,self,self.refreshItem)
    dxyDispatcher_addEventListener(dxyEventType.Swallow_reSelected,self,self.swallowSelected)

    dxyDispatcher_addEventListener(dxyEventType.UserItem_AddItem,self,self.addItem)
    dxyDispatcher_addEventListener(dxyEventType.UserItem_DelItem,self,self.delItem)
    dxyDispatcher_addEventListener(dxyEventType.UserItem_Replace,self,self.changeItem)
    
    self.btn_swallow:addTouchEventListener(function(target,type)
        if type == 2 then
            SoundsFunc_playSounds(SoundsType.UNIVERSAL_BTN,false)
        	dxyDispatcher_dispatchEvent(dxyEventType.EquipStrengthen_SwallowBtn)
        end
    end)
    
    self.btn_recommend:addTouchEventListener(function(target,type)
        if type == 2 then
            SoundsFunc_playSounds(SoundsType.UNIVERSAL_BTN,false)
            dxyDispatcher_dispatchEvent(dxyEventType.EquipStrengthen_RecommendBtn)
        end
    end)
    
    self.btn_sell:addTouchEventListener(function(target,type)
        if type == 2 then
            SoundsFunc_playSounds(SoundsType.UNIVERSAL_BTN,false)
            dxyDispatcher_dispatchEvent(dxyEventType.RoleView_OpenSubView,CHARACTER_SUB_TYPE.EQUIP_SELL)
        end
    end)
    
end

function BackpackLayer:addEquipScrollView()
    local item = nil
    local itemSize = nil
    local x,y = 0,0
    local index = 1
    local dataList = zzm.CharacterModel:getBackpackList()
    for i=AutocephalyValueConfig:getValueByContent("EquipListNum"),1,-1 do
        for j=1,AutocephalyValueConfig:getValueByContent("EquipRowNum") do
            item = EquipItem:create()
            item:update(dataList[index])
            item:isShowEquipSmelt()
            itemSize = item:getFrameSize()
            x = (itemSize.height / 2 + 1.0) * (2 * j - 1)
            y = (itemSize.width / 2 ) * (2 * i - 1)
            item:setPosition(cc.p(x,y))
            self.scrollView:addChild(item)
	        item:setName("EquipItem"..index)
            self.itemList[index] = item
            index = index + 1
        end
    end
    self.scrollView:setInnerContainerSize(cc.size((itemSize.width )*5,(itemSize.height)*AutocephalyValueConfig:getValueByContent("EquipListNum")))
end

function BackpackLayer:addBackpack()
    self._backPackTimer = self._backPackTimer or require("game.utils.MyTimer").new()
    local function tick()
        local item = nil
        local itemSize = nil
        local x,y = 0,0
        local index = 1
        local dataList = zzm.CharacterModel:getBackpackList()
        for i=AutocephalyValueConfig:getValueByContent("EquipListNum"),1,-1 do
            for j=1,AutocephalyValueConfig:getValueByContent("EquipRowNum") do
                item = EquipItem:create()
                item:update(dataList[index])
                item:isShowEquipSmelt()
                itemSize = item:getFrameSize()
                x = (itemSize.height / 2 + 1.0) * (2 * j - 1)
                y = (itemSize.width / 2 ) * (2 * i - 1)
                item:setPosition(cc.p(x,y))
                self.scrollView:addChild(item)
                item:setName("EquipItem"..index)
                self.itemList[index] = item
                index = index + 1
            end
        end
        self.scrollView:setInnerContainerSize(cc.size((itemSize.width )*5,(itemSize.height)*AutocephalyValueConfig:getValueByContent("EquipListNum")))
        
        if self._backPackTimer then
            self._backPackTimer:stop()
            self._backPackTimer = nil
        end
    end
    
    self._backPackTimer:start(1,tick)
end

function BackpackLayer:changeItem(goods)
--    for key, item in ipairs(self.itemList) do
--        if item.m_data and item.m_data.idx == goods.idx then
--            item:update(goods)
--            return
--        end
--    end
    self:refreshItem()
end

function BackpackLayer:addItem(goods)
--    for key, item in ipairs(self.itemList) do
--        if item.m_data == nil then
--            item:update(goods)
--            return
--        end
--    end
    self:refreshItem()
end

function BackpackLayer:delItem(idx)
--    for key, item in ipairs(self.itemList) do
--        if item.m_data and item.m_data.idx == idx then
--            item:update()
--            return
--        end
--    end
    self:refreshItem()
end

function BackpackLayer:refreshItem()
    local index = 1
    local dataList = zzm.CharacterModel:getBackpackList()
    for index=1,#self.itemList do
        self.itemList[index]:update(dataList[index])
        self.itemList[index]:isShowEquipSmelt()
    end
end

function BackpackLayer:swallowSelected(data)
    --data.count 0:取消所有选中    1:反向选择  2:单个选择 3:不可选 4:所有可选    data.goodsData:物品data
    local dataList = zzm.CharacterModel:getBackpackList()
    if data.count == 0 then
        for index=1,#dataList do
            if dataList[index]:getType() == 1 then          
                self.itemList[index]:initSelected(false)      
            end
        end  
    elseif data.count == 1 then
        for index=1,#dataList do
            if dataList[index]:getType() == 1 and dataList[index].lv == 0 and dataList[index].config.Lv <= zzm.CharacterModel.swallowEquipData.config.Lv then          
                self.itemList[index]:showSelected()      
            end
        end
    elseif data.count == 2 then
        for index=1,#dataList do
            if dataList[index]:getType() == 1 and dataList[index].idx == data.goodsData.idx then          
                self.itemList[index]:showSelected()      
            end
        end
    elseif data.count == 3 then
        for index=1,#dataList do
            if dataList[index]:getType() == 1 and dataList[index].config.Lv > data.goodsData.config.Lv then
                self.itemList[index]:setOptional(false)
        	end
        end
    elseif data.count == 4 then
        for index=1,#dataList do
        	if dataList[index]:getType() == 1 then
                self.itemList[index]:setOptional(true)
        	end
        end
    end
end
