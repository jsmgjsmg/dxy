
SpiritCopyMapLayer = SpiritCopyMapLayer or class("SpiritCopyMapLayer",function()
    return cc.Layer:create()
end)

function SpiritCopyMapLayer.create()
    local node = SpiritCopyMapLayer.new()
    return node
end

function SpiritCopyMapLayer:ctor()
    self._csbNode = nil
    self:initUI()
    --self:initEvent()
    dxyExtendEvent(self)
end

function SpiritCopyMapLayer:initUI()
    self._csbNode = cc.CSLoader:createNode("dxyCocosStudio/csd/ui/spirit/SpiritCopyMapLayer.csb")
    self:addChild(self._csbNode)

    self.visibleSize = cc.Director:getInstance():getVisibleSize()
    self.origin = cc.Director:getInstance():getVisibleOrigin()

    local posX = self.origin.x + self.visibleSize.width/2
    local posY = self.origin.y + self.visibleSize.height/2

    self._csbNode:setPosition(posX, posY)
    
    local topBg = self._csbNode:getChildByName("BG")
    self.btn_close = topBg:getChildByName("closeBtn")
    self.txt_name = topBg:getChildByName("name")
    self.btn_award = topBg:getChildByName("awardBtn")
    
    self.normalNode = self._csbNode:getChildByName("normalNode")  
    self.normal_node_list = {}
    for index=1, 6 do
        local node = self.normalNode:getChildByName("Node_"..index)
        self.normal_node_list[index] = node 
    end
    
    self.fastNode = self._csbNode:getChildByName("fastNode")
    self.fast_node_list = {}
    for index=1, 2 do
        local node = self.fastNode:getChildByName("Node_"..index)
        self.fast_node_list[index] = node
    end

    require("game.spirit.view.SpiritCopyItem")
    --self:update(1)
end

function SpiritCopyMapLayer:initEvent()

    dxyDispatcher_addEventListener(dxyEventType.Spirit_Copy_Update,self,self.updateValue)
    
    if(self.btn_close)then
        self.btn_close:addTouchEventListener(function(target,type)
            if(type==2)then
                SoundsFunc_playSounds(SoundsType.CLOSE_PAGE,false)
				self:removeFromParent()
--                layer.text:setString("是否放弃本轮?")
--                layer.btn_ok:addTouchEventListener(function(target,type)
--                    if type == 2 then     
--                        layer:removeFromParent()           	
--                        self:removeFromParent()
--                    end
--                end)
            end
        end)
    end
    
    if(self.btn_award)then
        self.btn_award:addTouchEventListener(function(target,type)
            if(type==2)then
                
            end
        end)
    end
    
    -- 拦截
    dxySwallowTouches(self)
end

function SpiritCopyMapLayer:removeEvent()
    dxyDispatcher_removeEventListener(dxyEventType.Spirit_Copy_Update,self,self.updateValue)
end

function SpiritCopyMapLayer:update(diff,lv)
    self.diffLV = diff
    self.lv = lv
    if self.diffLV == nil and self.lv == nil then
        return
    end
    
    zzm.SpiritModel.curSpiritDifficulty = self.diffLV
    zzm.SpiritModel.curSpiritLv = self.lv
    zzm.SpiritModel.curSpiritLvType = MagicSoulConfigProvider:getTypeByUnlockLv(self.lv)
    
    self.txt_name:setString(MagicSoulConfigProvider:getCopyNameByLv(self.lv))
    
    -- data 为章节难度
    self.item_list = {}
    
    local copyNum = 0
    
    if zzm.SpiritModel.spirit_type == DefineConst.CONST_MAGICSOUL_COPY_TYPE_NORMAL then
        self.normalNode:setVisible(true)
        self.fastNode:setVisible(false)
    	copyNum = 6
        for index=1,copyNum do
            local item = SpiritCopyItem.create()
            item:update(self.diffLV)
            self.normal_node_list[index]:addChild(item)
            item:setName("spiritCopy_"..index)
            self.item_list[index] = item
        end
    elseif zzm.SpiritModel.spirit_type == DefineConst.CONST_MAGICSOUL_COPY_TYPE_FAST then
    	copyNum = 2
        self.normalNode:setVisible(false)
        self.fastNode:setVisible(true)
        for index=1,copyNum do
            local item = SpiritCopyItem.create()
            item:update(self.diffLV)
            self.fast_node_list[index]:addChild(item)
            item:setName("spiritCopy_"..index)
            self.item_list[index] = item
        end
    end

--    local copyList = zzm.SpiritModel:getRandomScene()
--    print("Error num: ".. #copyList)
--    for index=1,copyNum do
--        local item = SpiritCopyItem.create()
--        item:update(self.diffLV)
--        self.normal_node_list[index]:addChild(item)
--        item:setName("spiritCopy_"..index)
--        self.item_list[index] = item
--    end

end

function SpiritCopyMapLayer:getPageSize()
    return self.copyBG:getContentSize() 
end

function SpiritCopyMapLayer:updateValue()
	print("开始更新数据")
    local data = zzm.SpiritModel.spirit_copy
    for index=1, #data do
    	 self.item_list[index]:setConfig(data[index])
    end
end




