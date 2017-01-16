
--CHARACTER_PANEL_TYPE = {
--    SKILL = 1,
--    EQUIP = 2,
--    CONTINUOUSSKILL = 3,
--}
ROLE_INFO_TYPE = {
    EQUIP = 1,
    MOVES = 2,
    SPIRIT = 3,
    YUANSHEN = 4,
    MAGIC = 5,
    FAIRY = 6,
    GOD = 7,
}

TitleWarfieldSlider = TitleWarfieldSlider or class("TitleWarfieldSlider",function()
    return cc.Layer:create()
end)

function TitleWarfieldSlider.create()
    local layer = TitleWarfieldSlider.new()
    return layer
end

function TitleWarfieldSlider:ctor()
    self._arrInfoTitle = {
        [1] = "EquipinfoLayer",
        [2] = "CtskillLayer",
        [3] = "SpiritInfoLayer",
        [4] = "YuanshenInfoLayer",
        [5] = "MagicInfoLayer",
        [6] = "FairyInfoLayer",
        [7] = "GeneralInfoLayer",
    }
    self._arrInfoItem = {}

    self._csbNode = nil
    self._typeLayer = {}
    self:initUI()
    dxyExtendEvent(self)
end

function TitleWarfieldSlider:initUI()
    self._csbNode = cc.CSLoader:getInstance():createNodeWithFlatBuffersFile("dxyCocosStudio/csd/ui/roleinfo/TitleWarfieldSlider.csb")
    self:addChild(self._csbNode)
    
    self.typeNode = self._csbNode:getChildByName("typeNode")
    
    self.visibleSize = cc.Director:getInstance():getVisibleSize()
    self.origin = cc.Director:getInstance():getVisibleOrigin()
    
    local posX = self.origin.x + self.visibleSize.width/2
    local posY = self.origin.y + self.visibleSize.height/2
    
    self.panel = self._csbNode:getChildByName("BG"):getChildByName("Panel")
    
    require("game.roleinfo.view.TitlePageItem")
    local node = TitlePageItem:create()
    
    --create stencil
    self._stencil = cc.Sprite:create("dxyCocosStudio/png/roleinfo/titleClipping.png")
    self._stencil:setAnchorPoint(cc.p(0,0))

    self._size = self._stencil:getContentSize()

    --create clippingNode
    self._clippingNode = cc.ClippingNode:create()
    self._clippingNode:setAnchorPoint(cc.p(0,0))
    --self._clippingNode:setAlphaThreshold(0)
    self._clippingNode:setPosition(0,0)
    self._clippingNode:setStencil(self._stencil)
    self._clippingNode:setInverted(false)

    --create show
    self._clippingNode:addChild(node)
    node:setPositionX(self._size.width / 2 - node.pageView:getContentSize().width / 2)
    self.panel:addChild(self._clippingNode) 

    --self:setPosition(posX, posY)
    
--    self.pageView = self._csbNode:getChildByName("BG"):getChildByName("Panel"):getChildByName("PageView")
--
--    self.panelList = {}
--
--    local panel = nil
--    for index = 1, 7 do
--        panel = self.pageView:getChildByName("Panel_"..index)
--        self.panelList[index] = panel
--    end
--    
----    self.scrollView = self._csbNode:getChildByName("BG"):getChildByName("Panel"):getChildByName("ScrollView")
----    self.containerPanel = self.scrollView:getChildByName("Panel")
--    
--    local viewSize = self.pageView:getContentSize()
--    
--    local item = nil
--    require("game.roleinfo.view.TitleToggle")
--    self.itemList = {}
--    for index=1, 7 do
--        item = TitleToggle:create()
--        local x = viewSize.width / 2
--        local y = viewSize.height / 2
--        item:setPosition(cc.p(x,y))
--        item:setParent(self.pageView)
--        item:update(index)
--        self.itemList[index] = item
--
--        self.panelList[index]:addChild(item)
--        
--        if index == 1 then
--            item:setScale(1.0)
--        else
--            item:setScale(0.6)
--        end
--    end
    
    require("game.roleinfo.view.EquipinfoLayer")
    require("game.roleinfo.view.CtskillLayer")
    require("game.roleinfo.view.SpiritInfoLayer")
    require("game.roleinfo.view.YuanshenInfoLayer")
    require("game.roleinfo.view.FairyInfoLayer")
    require("game.roleinfo.view.MagicInfoLayer")
    require("game.roleinfo.view.GeneralInfoLayer")
    self:onSelectByType(ROLE_INFO_TYPE.EQUIP)
    
end


function TitleWarfieldSlider:removeEvent()
    dxyDispatcher_removeEventListener(dxyEventType.RoleInfo_OpenTypeView,self,self.onSelectByType)

end


function TitleWarfieldSlider:initEvent()

    dxyDispatcher_addEventListener(dxyEventType.RoleInfo_OpenTypeView,self,self.onSelectByType) 
    
--    self.pageView:addEventListener(function(target,type)
    --        if type == ccui.PageViewEventType.turning then
    --            local page = self.pageView:getCurPageIndex()
--            self:onSelectByType(page + 1)
--            
--            for index=1, 7 do
--                local x = self.panelList[index]:getPositionX()
--                if x > -100 and x < 100 then
--                    self.itemList[index]:runAction(cc.ScaleTo:create(0.1,1))
--                else
--                    self.itemList[index]:runAction(cc.ScaleTo:create(0.1,0.6))
--                end
--            end
--        end
--    end) 
end

function TitleWarfieldSlider:onSelectByType(type)
    print("------------------ : " .. type)
--    self.typeNode:removeAllChildren()
--    if type == ROLE_INFO_TYPE.EQUIP then
    --    	--if not self._typeLayer[type] then
--    		self._typeLayer[type] = EquipinfoLayer:create()
--    		--self._typeLayer[type]:retain()
    --    	--end
    --    	self.typeNode:addChild(self._typeLayer[type])
--    elseif type == ROLE_INFO_TYPE.MOVES then
--        --if not self._typeLayer[type] then
--            self._typeLayer[type] = CtskillLayer:create()
--            --self._typeLayer[type]:retain()
--        --end
--        self.typeNode:addChild(self._typeLayer[type])
--    elseif type == ROLE_INFO_TYPE.GOD then
--        --if not self._typeLayer[type] then
--            self._typeLayer[type] = GeneralInfoLayer:create()
--            --self._typeLayer[type]:retain()
--        --end
--        self.typeNode:addChild(self._typeLayer[type])
--    elseif type == ROLE_INFO_TYPE.MAGIC then
--        --if not self._typeLayer[type] then
--            self._typeLayer[type] = MagicInfoLayer:create()
--            --self._typeLayer[type]:retain()
--        --end
--        self.typeNode:addChild(self._typeLayer[type])
--    elseif type == ROLE_INFO_TYPE.FAIRY then
--        --if not self._typeLayer[type] then
--            self._typeLayer[type] = FairyInfoLayer:create()
--            --self._typeLayer[type]:retain()
--        --end
--        self.typeNode:addChild(self._typeLayer[type])
--    elseif type == ROLE_INFO_TYPE.SPIRIT then
--        --if not self._typeLayer[type] then
--            self._typeLayer[type] = SpiritInfoLayer:create()
--            --self._typeLayer[type]:retain()
--        --end
--        self.typeNode:addChild(self._typeLayer[type])
--    elseif type == ROLE_INFO_TYPE.YUANSHEN then
--        --if not self._typeLayer[type] then
--            self._typeLayer[type] = YuanshenInfoLayer:create()
--            --self._typeLayer[type]:retain()
--        --end
--        self.typeNode:addChild(self._typeLayer[type])
--    end

    for i=1,7 do
        if i == type then
            if self._arrInfoItem[i] then
                self._arrInfoItem[i]:setVisible(true)
            else
                self._arrInfoItem[i] = _G[self._arrInfoTitle[i]]:create()
                self.typeNode:addChild(self._arrInfoItem[i])
            end
        else
            if self._arrInfoItem[i] then
                self._arrInfoItem[i]:setVisible(false)
            end
        end
    end
end

--
--function TitleWarfieldSlider:adjustScrollView(offset)
--    if offset > 0 then
--        self._curPage = self._curPage - 1
--    elseif offset <0 then
--        self._curPage = self._curPage + 1
--    end
--
--    if self._curPage < 0 then
--        self._curPage = 0
--    elseif self._curPage > 2 then
--        self._curPage = 2   
--    end
--
--    local adjustPoint = cc.p(-self.viewSize.width * self._curPage,0)
--    self.scrollView:setContentOffsetInDuration(adjustPoint,0.1)
--    self:setPointPic(self._curPage)
--end
--
--function TitleWarfieldSlider:WhenClose()
--    self:removeFromParent()
--end
--
--function TitleWarfieldSlider:onSelectByType(type)
--    self.ckb_Skill:setTouchEnabled(true)
--    self.ckb_Equip:setTouchEnabled(true)
--    self.ckb_ContinuousSkill:setTouchEnabled(true)
--
--    self.ckb_Skill:setSelected(false)
--    self.ckb_Equip:setSelected(false)
--    self.ckb_ContinuousSkill:setSelected(false)
--    if type == CHARACTER_PANEL_TYPE.SKILL then
--        dxyFloatMsg:show("敬请期待，技能模块！")
--        return
--    elseif type == CHARACTER_PANEL_TYPE.CONTINUOUSSKILL then
--        dxyFloatMsg:show("敬请期待，连招模块！")
--        return
--    end
--
--    self.containerPanel:removeAllChildren()
--
--    if type == CHARACTER_PANEL_TYPE.SKILL then
--        self.ckb_Skill:setTouchEnabled(false)
--        self.ckb_Skill:setSelected(true)
--    elseif type == CHARACTER_PANEL_TYPE.EQUIP then
--        self.ckb_Equip:setTouchEnabled(false)
--        self.ckb_Equip:setSelected(true)
--        local page = CharacterPage.create()
--        self.containerPanel:addChild(page)
--    elseif type == CHARACTER_PANEL_TYPE.CONTINUOUSSKILL then
--        self.ckb_ContinuousSkill:setTouchEnabled(false)
--        self.ckb_ContinuousSkill:setSelected(true)
--    end
--end
--
--function TitleWarfieldSlider:updateValue(data)
--    local type = data.type
--    if type == enCharacterAttrType.GOLD then
--        self.text_Gold:setString(data.value)
--    elseif type == enCharacterAttrType.LV then
--        self.text_Level:setString(data.value)
--    elseif type == enCharacterAttrType.RMB then
--        self.text_RMB:setString(data.value)
--    else
--
--    end
--end

