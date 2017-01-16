
CHARACTER_SUB_TYPE = {
    MELTING = 1,
    SWALLOW = 2,
    ROLE_INFO = 3,
    BACKPACK = 4,
    EQUIP_DETAIL = 5,
    MELTING_CONFIRM = 6,
    EQUIP_SELL = 7,
}


CharacterPage = CharacterPage or class("CharacterPage",function()
    return cc.Layer:create()
end)

function CharacterPage.create()
    local layer = CharacterPage.new()
    return layer
end

function CharacterPage:ctor()
    self._csbNode = nil
    self._subLayer = {}
    self:initUI()
    dxyExtendEvent(self)
end

function CharacterPage:initUI()
    self._csbNode = cc.CSLoader:getInstance():createNodeWithFlatBuffersFile("dxyCocosStudio/csd/ui/equip/CharacterPage.csb")
    self:addChild(self._csbNode)
    
    self:setTouchEnabled(true)

    self.panel_Left = self._csbNode:getChildByName("LeftPanel")
    self.panel_Right = self._csbNode:getChildByName("RightPanel")
    self.panel_Mid = self._csbNode:getChildByName("MidPanel")
    
    require("game.equip.view.BackpackLayer")
    require("game.equip.view.RoleInfoLayer")
    require("game.equip.view.SwallowLayer")
    require("game.equip.view.MeltingLayer")
    require("game.equip.view.MeltingConfirmLayer")
    require("game.equip.view.EquipSell")
    
    self:onSelectByType(CHARACTER_SUB_TYPE.BACKPACK)
    --self:onSelectByType(CHARACTER_SUB_TYPE.SWALLOW)
    --self:onSelectByType(CHARACTER_SUB_TYPE.MELTING)
--    self:onSelectByType(CHARACTER_SUB_TYPE.ROLE_INFO)
    
end

function CharacterPage:setParent(parent)
	self.parent = parent
end

function CharacterPage:removeEvent()
    dxyDispatcher_removeEventListener(dxyEventType.RoleView_OpenSubView,self,self.onSelectByType)
    --dxyDispatcher_removeEventListener(dxyEventType.EquipSmelting_Confirm,self,self.openSmeltingConfirmLayer)
end


function CharacterPage:initEvent()
    self:onSelectByType(CHARACTER_SUB_TYPE.ROLE_INFO)
    dxyDispatcher_addEventListener(dxyEventType.RoleView_OpenSubView,self,self.onSelectByType)
    --dxyDispatcher_addEventListener(dxyEventType.EquipSmelting_Confirm,self,self.openSmeltingConfirmLayer)
end

--function CharacterPage:openSmeltingConfirmLayer(data)
--    self.panel_Mid:removeAllChildren()
--    if not self._subLayer[CHARACTER_SUB_TYPE.MELTING_CONFIRM] then
--        self._subLayer[CHARACTER_SUB_TYPE.MELTING_CONFIRM] = MeltingConfirmLayer.create()
--        self._subLayer[CHARACTER_SUB_TYPE.MELTING_CONFIRM]:retain()
--    end
--    self._subLayer[CHARACTER_SUB_TYPE.MELTING_CONFIRM]:update(data)
--    self.panel_Mid:addChild(self._subLayer[CHARACTER_SUB_TYPE.MELTING_CONFIRM])
--end

function CharacterPage:onSelectByType(type)
    print("------------------ : " .. type)  
    if type == CHARACTER_SUB_TYPE.BACKPACK then
        self.panel_Right:removeAllChildren()
        --if not self._subLayer[type] then
            self._subLayer[type] = BackpackLayer.create()
            --self._subLayer[type]:retain()
        --end
        self.panel_Right:addChild(self._subLayer[type])
    elseif type == CHARACTER_SUB_TYPE.MELTING then
        self.panel_Mid:removeAllChildren()
        --if not self._subLayer[type] then
            self._subLayer[type] = MeltingLayer.create()
            --self._subLayer[type]:retain()
            --self._subLayer[type]:setParent(self)
        --end
        print("------------------add ")
        self._subLayer[type]:update(zzm.CharacterModel:getCurItemData())
        self.panel_Mid:addChild(self._subLayer[type])
    elseif type == CHARACTER_SUB_TYPE.EQUIP_DETAIL then
        self.panel_Mid:removeAllChildren()
        --if not self._subLayer[type] then
            self._subLayer[type] = EquipDetail.create()
            --self._subLayer[type]:retain()
            --self._subLayer[type]:setParent(self)
        --end
        self._subLayer[type]:update(zzm.CharacterModel:getCurItemData())
        print("------------------add ")
        self.panel_Mid:addChild(self._subLayer[type])
    elseif type == CHARACTER_SUB_TYPE.EQUIP_SELL then
        self.panel_Mid:removeAllChildren()
        self._subLayer[type] = EquipSell.create()
        self.panel_Mid:addChild(self._subLayer[type])
    elseif type then
        self.panel_Left:removeAllChildren()
        if type == CHARACTER_SUB_TYPE.SWALLOW then
            --if not self._subLayer[type] then
                self._subLayer[type] = SwallowLayer.create()
                --self._subLayer[type]:retain()
                self._subLayer[type]:setParent(self)
            --end
            self._subLayer[CHARACTER_SUB_TYPE.BACKPACK]:showSwallowBtn(true)
            self.parent.title_bg:setVisible(false)
            self.parent.btn_back:setVisible(false)
        elseif type == CHARACTER_SUB_TYPE.ROLE_INFO then
            --if not self._subLayer[type] then
                self._subLayer[type] = RoleInfoLayer.create()
                --self._subLayer[type]:retain()
            --end
            --self._subLayer[type]:runTimeLine()
            self._subLayer[CHARACTER_SUB_TYPE.BACKPACK]:showSwallowBtn(false)
            self.parent.title_bg:setVisible(true)
            self.parent.btn_back:setVisible(true)
        end
        self.panel_Left:addChild(self._subLayer[type])
    else
    
    end
   
end


