
RoleInfoItem = RoleInfoItem or class("RoleInfoItem",function()
    return ccui.Layout:create()
end)

function RoleInfoItem.create()
    local node = RoleInfoItem.new()
    return node
end

function RoleInfoItem:ctor()
    self._csbNode = nil
    self:initUI()
end

function RoleInfoItem:initUI()
    self._csbNode = cc.CSLoader:createNode("dxyCocosStudio/csd/ui/login/RoleInfoItem.csb")
    self:addChild(self._csbNode)
    
    self._timeLine = cc.CSLoader:createTimeline("dxyCocosStudio/csd/ui/login/RoleInfoItem.csb")
    self._csbNode:runAction(self._timeLine)
    self._timeLine:gotoFrameAndPlay(0,true)

    self:setContentSize(cc.size(self._csbNode:getContentSize().width,self._csbNode:getContentSize().height))
    self:setAnchorPoint(cc.p(0,0))
    self:setTouchEnabled(true)
  
    self.createText = self._csbNode:getChildByName("Text")
    self.panel_RoleInfo = self._csbNode:getChildByName("RolePanel")
    self.image_Head = self._csbNode:getChildByName("Head")
    self.btn_item = self._csbNode:getChildByName("CheckBox") --CheckBox
    
    self.text_Pro = self.panel_RoleInfo:getChildByName("Pro")
    self.text_Name = self.panel_RoleInfo:getChildByName("Name")
    self.text_Lv = self.panel_RoleInfo:getChildByName("LV")
    self.text_Times = self.panel_RoleInfo:getChildByName("Times")
    --self.btn_item:setTouchEnabled(true)
    
    self.effectNode = self._csbNode:getChildByName("effectNode")
end

function RoleInfoItem:setParent(parent)
    self.m_parent = parent
end

function RoleInfoItem:unSelect()
    self.btn_item:setSelected(false)
    self.btn_item:setTouchEnabled(true)
    self.effectNode:setVisible(false)
end

function RoleInfoItem:select()
    self.btn_item:setSelected(true)
    self.btn_item:setTouchEnabled(false)
    self.effectNode:setVisible(true)
end

function RoleInfoItem:update(data)
    self.m_data = data
    self.effectNode:setVisible(false)
    if not self.m_data then
    	self.panel_RoleInfo:setVisible(false)
    	self.image_Head:setVisible(false)
        self.createText:setVisible(true)
        self.btn_item:addEventListener(function(target,type)
            if type == ccui.CheckBoxEventType.selected then         	
                SoundsFunc_playSounds(SoundsType.OPEN_PAGE,false)
                self.m_parent:createRole()
            end
        end)
        if self._myTimer then
            self._myTimer:stop()
        end
    else
        self.panel_RoleInfo:setVisible(true)
        self.text_Pro:setString(HeroConfig:getValueById(self.m_data.pro)["Name"])
        self.image_Head:setVisible(true)
        --self.image_Head:setTexture(HeroConfig:getValueById(self.m_data.pro)["SelectLing"])
        self.createText:setVisible(false)
        self.btn_item:addEventListener(function(target,type)
            if type == ccui.CheckBoxEventType.selected then       	
                SoundsFunc_playSounds(SoundsType.UNIVERSAL_BTN,false)
                self.m_parent:selectRole(self.m_data, self)
            end
        end)
        if self.m_data.time_del == 0 then
            self.text_Times:setVisible(false)
            if self._myTimer then
                self._myTimer:stop()
            end
            self.image_Head:setTexture(HeroConfig:getValueById(self.m_data.pro)["SelectLing"])
        else
            self.text_Times:setVisible(true)
            self.image_Head:setTexture(HeroConfig:getValueById(self.m_data.pro)["SelectDark"])
            local clientTimer = os.time() - _G.DiffTimer
            if clientTimer < self.m_data.time_del then
                local cut = self.m_data.time_del - clientTimer
                self.text_Times:setString(cn:DHMS(cut))
                self._myTimer = self._myTimer or require("game.utils.MyTimer").new()
                local function tick()                    
                    if cut > 0 then
                        cut = cut - 1
                        self.text_Times:setString(cn:DHMS(cut))
                    else
                        self.text_Times:setVisible(false)
                        self._myTimer:stop()
                        zzm.LoginModel:delRole(self.m_data.uid)
                        self.m_parent:chooseOtherOne()
                    end
                end
                self._myTimer:start(1.0, tick)
            else
                zzm.LoginModel:delRole(self.m_data.uid)
                self.text_Times:setVisible(false)
            end
        end
        self.text_Name:setString(self.m_data.name)
        self.text_Lv:setString("LV."..self.m_data.lv)
    end
end