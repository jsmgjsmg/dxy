MeltingLayer = MeltingLayer or class("MeltingLayer",function()
    return cc.Node:create()
end)

require("game.equip.view.AttributeNode")

function MeltingLayer.create()
    local node = MeltingLayer:new()
    return node
end

function MeltingLayer:ctor()
    self._csbNode = nil

    self.bg = nil

    self.leftNode = nil
    self.left_name = nil
    self.left_quality = nil
    self.left_Icon = nil
    self.left_strengthenLv = nil
    self.left_needLv = nil
    self.left_baseProperty = nil

    self.rightNode = nil
    self.right_name = nil
    self.right_quality = nil
    self.right_Icon = nil
    self.right_strengthenLv = nil
    self.right_needLv = nil
    self.right_baseProperty = nil

    self.left_attributeNode = {}
    self.right_attributeNode = {}

    self.btn_smelt = ccui.Button

    self.txt_cost = nil

    self.m_left_data = {}
    self.m_right_data = {}

    self.melting_data = {}  --发给服务器的数据
    
    self.canClose = true

    self:initUI()
    --self:initEvent()
    dxyExtendEvent(self)
end

function MeltingLayer:initUI()
    self._csbNode = cc.CSLoader:createNode("dxyCocosStudio/csd/ui/equip/smeltLayer.csb")
    self:addChild(self._csbNode)

    self.bg = self._csbNode:getChildByName("bg")

    self.leftNode = self._csbNode:getChildByName("leftNode")
    self.left_name = self.leftNode:getChildByName("name")
    self.left_quality = self.leftNode:getChildByName("Icon"):getChildByName("quality")
    self.left_Icon = self.leftNode:getChildByName("Icon"):getChildByName("Icon")
    self.left_strengthenLv = self.leftNode:getChildByName("strengthenLevel")
    self.left_needLv = self.leftNode:getChildByName("needLevelTxt")
    self.left_baseProperty = self.leftNode:getChildByName("basePropertyTxt")

    self.rightNode = self._csbNode:getChildByName("rightNode")
    self.right_name = self.rightNode:getChildByName("name")
    self.right_quality = self.rightNode:getChildByName("Icon"):getChildByName("quality")
    self.right_Icon = self.rightNode:getChildByName("Icon"):getChildByName("Icon")
    self.right_strengthenLv = self.rightNode:getChildByName("strengthenLevel")
    self.right_needLv = self.rightNode:getChildByName("needLevelTxt")
    self.right_baseProperty = self.rightNode:getChildByName("basePropertyTxt")

    self.btn_smelt = self._csbNode:getChildByName("smeltBtn")

    self.txt_cost = self._csbNode:getChildByName("costTxt")

    for index = 1,6 do
        local left_node = self.leftNode:getChildByName("attribute_"..index)
        if left_node then
            self.left_attributeNode[index] = AttributeNode:create()
            self.left_attributeNode[index]:update()
            --self.left_attributeNode[index]:retain()
            left_node:addChild(self.left_attributeNode[index])
        end

        local right_node = self.rightNode:getChildByName("attribute_"..index)
        if right_node then
            self.right_attributeNode[index] = AttributeNode:create()
            self.right_attributeNode[index]:update()
            --self.right_attributeNode[index]:retain()
            right_node:addChild(self.right_attributeNode[index])
        end
    end

end

function MeltingLayer:removeEvent()
    dxyDispatcher_removeEventListener(dxyEventType.EquipSmelting_Confirm,self,self.runAct)
    dxyDispatcher_removeEventListener(dxyEventType.EquipSmelting_Close,self,self.closeLayer)
end

function MeltingLayer:initEvent()

    dxyDispatcher_addEventListener(dxyEventType.EquipSmelting_Confirm,self,self.runAct)
    dxyDispatcher_addEventListener(dxyEventType.EquipSmelting_Close,self,self.closeLayer)

    self.btn_smelt:addTouchEventListener(function(target,type)
        if type == 2 then
            print("熔炼按钮")
            SoundsFunc_playSounds(SoundsType.UNIVERSAL_BTN,false)
            zzm.CharacterModel:setIsFloatRisePower(false)
            zzc.CharacterController:request_MeltingEquip(self.melting_data)
            zzm.TalkingDataModel:onEvent(EumEventId.EQUIP_MELTING,{equipId = self.m_left_data.config.Id})
            self.btn_smelt:setTouchEnabled(false)
            
            local role = zzm.CharacterModel:getCharacterData()
            local enCAT = enCharacterAttrType
            if role:getValueByType(enCAT.GOLD) >= self.cost then           	
                self.canClose = false
            end
        end
    end)


    -- 拦截
    --    dxySwallowTouches(self,self.bg)
    local function onTouchBegan(touch, event)
        return true
    end

    local function onTouchMoved(touch, event)
    end

    local function onTouchEnded(touch, event)
        local location = touch:getLocation()

        local point = self.bg:convertToNodeSpace(location)
        local rect = cc.rect(0,0,self.bg:getContentSize().width,self.bg:getContentSize().height)
        if cc.rectContainsPoint(rect,point) == false and self.canClose then
            if self._myTimer then
                self._myTimer:stop()
                self._myTimer = nil
            end
            self:removeFromParent()
        end
    end

    local listener = cc.EventListenerTouchOneByOne:create()
    listener:registerScriptHandler(onTouchBegan,cc.Handler.EVENT_TOUCH_BEGAN )
    listener:registerScriptHandler(onTouchMoved,cc.Handler.EVENT_TOUCH_MOVED )
    listener:registerScriptHandler(onTouchEnded,cc.Handler.EVENT_TOUCH_ENDED )
    local eventDispatcher = self:getEventDispatcher()
    eventDispatcher:addEventListenerWithSceneGraphPriority(listener, self)
    listener:setSwallowTouches(true)
end

function MeltingLayer:update(data)
    self:reset()

    self.m_right_data = data
    self.m_left_data = zzm.CharacterModel:getEquipedBySubtype(self.m_right_data.config.TypeSub)

    self.cost = math.ceil(EquipStrengthenConfig:getBaseDevourGold(self.m_right_data.config.Lv) * EquipStrengthenConfig:getQualityEatRatio(self.m_right_data.config.Quality) * EquipStrengthenConfig:getEquipTypeRatio(self.m_right_data.config.TypeSub))
    self.txt_cost:setString(self.cost)

    self.left_name:setString(self.m_left_data.config.Name)
    self.left_name:setColor(Quality_Color[self.m_left_data.config.Quality])
    self.left_quality:setTexture(self.m_left_data:getQualityIcon())
    self.left_Icon:setTexture(self.m_left_data:getIcon())
    self.left_strengthenLv:setString("+"..self.m_left_data.lv)
    self.left_needLv:setString("需求等级:"..self.m_left_data.config.Lv)
    local enCAT = enCharacterAttrType
    self.left_baseProperty:setString(("基础属性:"..enCAT:getTypeName(self.m_left_data.base_attr_t).."+"..self.m_left_data.base_attr_v))

    self.right_name:setString(self.m_right_data.config.Name)
    self.right_name:setColor(Quality_Color[self.m_right_data.config.Quality])
    self.right_quality:setTexture(self.m_right_data:getQualityIcon())
    self.right_Icon:setTexture(self.m_right_data:getIcon())
    self.right_strengthenLv:setString("+"..self.m_right_data.lv)
    self.right_needLv:setString("需求等级:"..self.m_right_data.config.Lv)
    self.right_baseProperty:setString(("基础属性:"..enCAT:getTypeName(self.m_right_data.base_attr_t).."+"..self.m_right_data.base_attr_v))

    self.melting_data.idx_attr = 0
    self.melting_data.idx_goods = self.m_right_data.idx

    if self.m_left_data.attr_count < 6 then
        self.left_attributeNode[self.m_left_data.attr_count + 1]:setFrameShow(true)
        self.melting_data.idx_attr = 0
    else
        self.left_attributeNode[1]:setFrameShow(true)
        self.melting_data.idx_attr = 1
    end

    for index = 1,self.m_left_data.attr_count + 1  do
        if index == 7 then
            break
        end
        if self.left_attributeNode[index] then
            self.left_attributeNode[index]:update(self.m_left_data.attr_solt[index])
            self.left_attributeNode[index]:setFrameTouch(true)
            self.left_attributeNode[index].btn_selectFrame:addTouchEventListener(function(target,type)
                if type == 2 then
                    print("点击属性"..index)
                    for var=1, 6 do
                        if var ~= index then
                            self.left_attributeNode[var]:setFrameShow(false)
                        else
                            self.left_attributeNode[var]:setFrameShow(true)
                            if var > self.m_left_data.attr_count then
                                self.melting_data.idx_attr = 0
                            else
                                self.melting_data.idx_attr = var
                            end
                            --保存熔炼装备的数据和属性槽索引
                            local tempData = {}
                            tempData.melt_left = self.m_left_data
                            tempData.melt_leftIdx = self.melting_data.idx_attr
                            tempData.melt_right = self.m_right_data
                            tempData.melt_rightIdx = 0
                            zzm.CharacterModel:setMeltingData(tempData)
                        end
                    end
                end
            end)
            --保存熔炼装备的数据和属性槽索引
            local tempData = {}
            tempData.melt_left = self.m_left_data
            tempData.melt_leftIdx = self.melting_data.idx_attr
            tempData.melt_right = self.m_right_data
            tempData.melt_rightIdx = 0
            zzm.CharacterModel:setMeltingData(tempData)
        end
    end

    for index = 1,self.m_right_data.attr_count do
        if self.right_attributeNode[index] then
            self.right_attributeNode[index]:update(self.m_right_data.attr_solt[index])
            self.right_attributeNode[index]:setFrameTouch(false)
        end
    end
end



function MeltingLayer:runAct()
    math.randomseed(os.time())
    self.curIndex = 1
    local count = 0
    local function tick()
        count = count + 1
        if count > 15 and self._myTimer then
            self._myTimer:stop()

            self.right_attributeNode[self.curIndex]:setFrameShow(false)
            self.right_attributeNode[zzm.CharacterModel:getMeltingData().melt_rightIdx]:setFrameShow(true)

            --self:removeFromParent()

            require("game.equip.view.MeltingConfirmLayer")
            MeltingConfirmLayer:create()
            zzm.CharacterModel:setIsFloatRisePower(true)
            

            return
        end
        self.right_attributeNode[self.curIndex]:setFrameShow(false)
        self.curIndex = math.random(1,self.m_right_data.attr_count)
        self.right_attributeNode[self.curIndex]:setFrameShow(true)
    end

    self._myTimer = self._myTimer or require("game.utils.MyTimer").new()
    self._myTimer:start(0.06, tick)

end

function MeltingLayer:closeLayer()
    if self._myTimer then
        self._myTimer:stop()
        self._myTimer = nil
    end
    self:removeFromParent()
end

function MeltingLayer:reset()
    for index=1, 6 do
        self.left_attributeNode[index]:setFrameShow(false)
        self.left_attributeNode[index]:setFrameTouch(false)
        self.left_attributeNode[index]:update()
        self.right_attributeNode[index]:setFrameShow(false)
        self.right_attributeNode[index]:setFrameTouch(false)
        self.right_attributeNode[index]:update()
    end
end

function MeltingLayer:WhenClose()

end