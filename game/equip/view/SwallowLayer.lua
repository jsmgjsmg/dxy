SwallowLayer = SwallowLayer or class("SwallowLayer",function()
    return cc.Node:create()
end)

function SwallowLayer:create()
    local node = SwallowLayer:new()
    return node
end

function SwallowLayer:ctor()
    self:initUI()
    --self:initEvent()
    
    dxyExtendEvent(self)
end

function SwallowLayer:setParent(parent)
    self._parent = parent
end

function SwallowLayer:initUI()
    self._csbNode = cc.CSLoader:getInstance():createNodeWithFlatBuffersFile("dxyCocosStudio/csd/ui/equip/SwallowNode.csb")
    self:addChild(self._csbNode)
    
    self.visibleSize = cc.Director:getInstance():getVisibleSize()
    self.origin = cc.Director:getInstance():getVisibleOrigin()
    
    local leftNode = self._csbNode:getChildByName("leftNode")
    self.btn_back = leftNode:getChildByName("Back")
    leftNode:setPosition(cc.p(-self.visibleSize.width / 2 + self.origin.x,self.visibleSize.height / 2 + self.origin.y))
    
--    self.btn_Recommend = self._csbNode:getChildByName("Recommend")
--    self.btn_Swallow = self._csbNode:getChildByName("Swallow")
    self.text_EquipName = self._csbNode:getChildByName("NameText")
    self.txt_strengthLv = self._csbNode:getChildByName("strengthenLevel")
    
    local node = self._csbNode:getChildByName("LevelNode")
    self.bar_exp = node:getChildByName("expBar")
    self.bar_expShadow = node:getChildByName("expBarShadow")
    self.txt_curExp = node:getChildByName("curExp")
    self.txt_afterExp = node:getChildByName("afterExp")
    self.txt_base = node:getChildByName("base")
    self.txt_advance = node:getChildByName("advanceTxt")
    self.txt_swallowCount = node:getChildByName("swallowCount")
    self.txt_expendGold = node:getChildByName("expendGold")
    
    --local listpanel = node:getChildByName("ListPanel")
    require("game.equip.view.EquipItem")
    self.list_Item = {}
--    for index=1, 8 do
--        --local itemNode = listpanel:getChildByName("Node_" .. index)
--        --if itemNode then
--            self.list_Item[index] = EquipItem:create()
--            self.list_Item[index]:retain()
--            self.list_Item[index]:update()
--            --itemNode:addChild(self.list_Item[index])
--        --end
--    end
    local itemNode = self._csbNode:getChildByName("EquipNode")
    itemNode:removeAllChildren()
    self.item_Equip = EquipItem:create()
    self.item_Equip:setTouchEnabled(false)
    --self.item_Equip:retain()
    itemNode:addChild(self.item_Equip)
    
    --self:updateEquipNode(zzm.CharacterModel:getEquipedBySubtype(zzm.CharacterModel:getCurItemData().config.TypeSub))
    
    self:changeItem()
end

function SwallowLayer:updateSwallowList(data) 	
--    for index=1, #self.list_Item do
--        if self.list_Item[index] then
----            if data then          	
----                self.list_Item[index]:update(data[index])
----            else
----                self.list_Item[index]:update()
----            end
--        end
--    end
    if data then
        self.list_Item = data
    else
        self.list_Item = {}
    end
    self:updateSwallowItem()
end

function SwallowLayer:updateEquipNode(data)
    if not data then
    	return
    end
    zzm.CharacterModel.swallowEquipData = data
    --self.text_EquipName:setString(data.conf)
    --self.text_Loading:setString(data.curExp.. "/" .. data.maxExp)
    --self.loadingBar
    self.item_Equip:update(data)
    self.text_EquipName:setString(data.config.Name)
    self.text_EquipName:setColor(Quality_Color[data.config.Quality])
    self.txt_expendGold:setString(0)
    self:updateSwallowItem()
end


function SwallowLayer:removeEvent()
    zzm.CharacterModel:setIsSwallow(false)
    dxyDispatcher_dispatchEvent(dxyEventType.Swallow_reSelected,{count = 4,goodsData = 0})
    dxyDispatcher_removeEventListener(dxyEventType.EquipStrengthen_SwallowBtn,self,self.swallowBtn)
    dxyDispatcher_removeEventListener(dxyEventType.EquipStrengthen_RecommendBtn,self,self.recommendBtn)
    
    dxyDispatcher_removeEventListener(dxyEventType.EquipStrengthen_SetItemIn,self,self.addItem)
--    dxyDispatcher_removeEventListener(dxyEventType.UserItem_DelItem,self,self.delItem)
    dxyDispatcher_removeEventListener(dxyEventType.EquipStrengthen_ResultBackj,self,self.changeItem)
    
end

function SwallowLayer:initEvent()

    zzm.CharacterModel:setIsSwallow(true)
    self:changeItem()
    
--    self:updateEquipNode(zzm.CharacterModel:getEquipedBySubtype(zzm.CharacterModel:getCurItemData().config.TypeSub))
    
    dxyDispatcher_addEventListener(dxyEventType.EquipStrengthen_SwallowBtn,self,self.swallowBtn)
    dxyDispatcher_addEventListener(dxyEventType.EquipStrengthen_RecommendBtn,self,self.recommendBtn)

    dxyDispatcher_addEventListener(dxyEventType.EquipStrengthen_SetItemIn,self,self.addItem)
--    dxyDispatcher_addEventListener(dxyEventType.UserItem_DelItem,self,self.delItem)
    dxyDispatcher_addEventListener(dxyEventType.EquipStrengthen_ResultBackj,self,self.changeItem)

    if(self.btn_back)then
        self.btn_back:addTouchEventListener(function(target,type)
            if(type==2 and self._parent)then
                SoundsFunc_playSounds(SoundsType.CLOSE_PAGE,false)
                self._parent:onSelectByType(CHARACTER_SUB_TYPE.ROLE_INFO)
                dxyDispatcher_dispatchEvent(dxyEventType.Backpack_Refresh)
                --self:updateSwallowList()
            end
        end)
    end
--    if(self.btn_Recommend)then
--        self.btn_Recommend:addTouchEventListener(function(target,type)
--            if(type==2)then
--                local list =  zzm.CharacterModel:getSwallowList()
--                if #list == 0 then
--                    TipsFrame:create("背包里没有可吞噬的装备!")
--                    return
--                end
--                self:updateSwallowList(list)
--            end
--        end)
--    end
--    if(self.btn_Swallow)then
--        self.btn_Swallow:addTouchEventListener(function(target,type)
--            if(type==2)then
--                --request server
--                local data = {}
--                data.subType = zzm.CharacterModel:getCurItemData().config.TypeSub
--                data.list = {}
--                for index = 1,8 do
--                    if self.list_Item[index].m_data then
--                        table.insert(data.list,#data.list + 1,self.list_Item[index].m_data.idx)
--                    end
--                end  
--                for key, var in ipairs(data.list) do
--	               print(key .. "   -- " .. var)
--                end           	
--                if #data.list == 0 then
--                    TipsFrame:create("请从背包放入需要吞噬的装备")
--                	return
--                end
--                zzc.CharacterController:request_SwallowEquip(data)
--            end
--        end)
--    end
end

function SwallowLayer:swallowBtn()
    --request server
    local data = {}
    data.subType = zzm.CharacterModel:getCurItemData().config.TypeSub
    data.list = {}
    for index = 1,#self.list_Item do
        if self.list_Item[index] then
            table.insert(data.list,#data.list + 1,self.list_Item[index].idx)
        end
    end  
    for key, var in ipairs(data.list) do
        print(key .. "   -- " .. var)
    end             
    if #data.list == 0 then
        TipsFrame:create("请从背包放入需要吞噬的准备")
        return
    end
    zzc.CharacterController:request_SwallowEquip(data)
--    zzm.TalkingDataModel:onEvent(EumEventId.EQUIP_STRENGTHEN,{equipId = self.item_Equip.m_data.config.Id})
end

function SwallowLayer:recommendBtn()
    local list = nil
    if #self.list_Item ~= 0 then
    	list = {}
        dxyDispatcher_dispatchEvent(dxyEventType.Swallow_reSelected,{count = 0,goodsData = 0})
    else
        list =  zzm.CharacterModel:getSwallowList()
        if #list == 0 then
            TipsFrame:create("背包里没有可吞噬的装备!")
            return
        end
        dxyDispatcher_dispatchEvent(dxyEventType.Swallow_reSelected,{count = 1,goodsData = 0})
    end
    self:updateSwallowList(list)
end

function SwallowLayer:changeItem(goods)
    if not goods then 	
        goods = zzm.CharacterModel:getEquipedBySubtype(zzm.CharacterModel:getCurItemData().config.TypeSub)
    end
    self:updateEquipNode(goods)
    self:updateSwallowList()
end

function SwallowLayer:addItem(goods)
    local index = self:getGoods(goods)
    if index == 0 then
        table.insert(self.list_Item,#self.list_Item+1,goods)
    else
        table.remove(self.list_Item,index)
    end
    self:updateSwallowItem()
end

function SwallowLayer:getGoods(goods)
    for index=1, #self.list_Item do
        if self.list_Item[index].idx == goods.idx then
            return index
        end
    end
    return 0
end

--function SwallowLayer:delItem(idx)
--    for index=1, 8 do
--        if self.list_Item[index].m_data then
--            if self.list_Item[index].m_data.idx == idx then
--                self.list_Item[index]:update()
--                return
--            end
--        end
--    end
--end

function SwallowLayer:updateSwallowItem()

    dxyDispatcher_dispatchEvent(dxyEventType.Swallow_reSelected,{count = 3,goodsData = self.item_Equip.m_data})

    local count = 0
    local swallowExp = 0
    local expendGold = 0
    for index = 1,#self.list_Item do
		if self.list_Item[index] then
			count = count + 1
            swallowExp = swallowExp + self.list_Item[index].exp_eat
            expendGold = expendGold + math.ceil(EquipStrengthenConfig:getBaseSpendGold(self.list_Item[index].config.Lv) * self.list_Item[index].exp_eat)
		end
	end
	
    if swallowExp > self.item_Equip.m_data.exp_max then
        expendGold = math.ceil(EquipStrengthenConfig:getBaseSpendGold(self.list_Item[#self.list_Item].config.Lv) * self.item_Equip.m_data.exp_max)
	end
    
	self.txt_swallowCount:setString(count)
    self.bar_exp:setPercent(self.item_Equip.m_data.exp / self.item_Equip.m_data.exp_uplv * 100)
    self.txt_curExp:setString(self.item_Equip.m_data.exp.."/"..self.item_Equip.m_data.exp_uplv)
    self.bar_expShadow:setPercent((self.item_Equip.m_data.exp + swallowExp) / self.item_Equip.m_data.exp_uplv * 100)
    self.txt_afterExp:setString((self.item_Equip.m_data.exp + swallowExp).."/"..self.item_Equip.m_data.exp_uplv)
    local enCAT = enCharacterAttrType
    self.txt_base:setString(enCAT:getTypeName(self.item_Equip.m_data.base_attr_t)..":+"..self.item_Equip.m_data.base_attr_v.."(+"..(self.item_Equip.m_data.base_attr_vf-self.item_Equip.m_data.base_attr_v)..")")
    
    local addAttr = 0
    if self.item_Equip.m_data.lv >= EquipStrengthenConfig:getLvMax() then
        addAttr = 0
    else
        addAttr = math.ceil(self.item_Equip.m_data.base_attr_v * EquipStrengthenConfig:getAttrPercent(self.item_Equip.m_data.lv + 1)) 
    end
    self.txt_advance:setString("+"..addAttr)
    
    self.txt_expendGold:setString(expendGold)
    
    self.txt_strengthLv:setString("+"..self.item_Equip.m_data.lv)
    
    --判断再加一件装备是否超过最大经验值
    if self.list_Item[#self.list_Item] and swallowExp - self.list_Item[#self.list_Item].exp_eat >= self.item_Equip.m_data.exp_max then
        dxyDispatcher_dispatchEvent(dxyEventType.Swallow_reSelected,{count = 2,goodsData = self.list_Item[#self.list_Item]})
        table.remove(self.list_Item)  
        self:updateSwallowItem()
    end
end

