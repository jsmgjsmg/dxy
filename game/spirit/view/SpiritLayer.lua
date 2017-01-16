
SpiritLayerType = {
    SpiritLayer = 0,
    SearchLayer = 1,
}

SpiritLayer = SpiritLayer or class("SpiritLayer",function()
    return cc.Layer:create()
end)

function SpiritLayer.create()
    local layer = SpiritLayer.new()
    return layer
end

function SpiritLayer:ctor()
    self._csbNode = nil

    self:initUI()
    dxyExtendEvent(self)
end

function SpiritLayer:initUI()
    self._csbNode = cc.CSLoader:createNode("dxyCocosStudio/csd/ui/spirit/SpiritsLayer.csb")
    self:addChild(self._csbNode)

    self.visibleSize = cc.Director:getInstance():getVisibleSize()
    self.origin = cc.Director:getInstance():getVisibleOrigin()

    local posX = self.origin.x + self.visibleSize.width/2
    local posY = self.origin.y + self.visibleSize.height/2

    self:setPosition(posX, posY)
    local titleNode = self._csbNode:getChildByName("TitleNode")
    titleNode:setPositionY(self.origin.y + self.visibleSize.height/2)
    
    local topBg = titleNode:getChildByName("BG")
    
    local backNode = self._csbNode:getChildByName("LeftNode")
    backNode:setPosition(cc.p(-self.visibleSize.width / 2 + self.origin.x,self.visibleSize.height / 2 + self.origin.y))
    self.btn_back = backNode:getChildByName("Back")
    
    self.ckb_Search = backNode:getChildByName("CheckBox_1")
    self.ckb_Spirit = backNode:getChildByName("CheckBox_2")
    
    self.searchTips = self.ckb_Search:getChildByName("redIcon")
    self.searchTips:setVisible(false)
    self:updateTips()
    
    local dataNode = self._csbNode:getChildByName("RightNode")
    dataNode:setPosition(cc.p(self.visibleSize.width / 2 + self.origin.x ,self.visibleSize.height / 2 + self.origin.y - 35))
    require "src.game.utils.TopDataNode"
    local data = TopDataNode:create()
    dataNode:addChild(data)

    local node = self._csbNode:getChildByName("Panel")
    node:setContentSize(self.visibleSize.width,self.visibleSize.height)

    self.pageView = node:getChildByName("PageView")


    --    self.btn_addManual = node:getChildByName("Manual"):getChildByName("Button")
    --    self.btn_startReward = node:getChildByName("Start"):getChildByName("Button")

    self.pageView:removeAllChildren()

    require("game.chapter.view.CopyPage")
    require("game.spirit.view.SpiritNode")
    
    local pageSize = nil
    
    local page = SpiritNode.create()
    self.pageView:insertPage(page,SpiritLayerType.SpiritLayer)
    --page:update(zzm.CopySelectModel:getChapterByIndex(SpiritLayerType.SpiritLayer))
    
    require "game/spirit/view/SpiritSerachLayer"
    local page = SpiritSerachLayer.create()
    self.pageView:insertPage(page,SpiritLayerType.SearchLayer)

    self.pageView:setPosition(posX, posY)
    self.pageView:setContentSize(posX*2, posY*2)
    
    self:onSelectByType(SpiritLayerType.SpiritLayer)
end

function SpiritLayer:WhenClose()
    self:removeFromParent()
    --zzc.SpiritController:unregisterListenner()
end

function SpiritLayer:removeEvent()
    --dxyDispatcher_removeEventListener(dxyEventType.Character_AttrUpdate,self,self.updateValue)
    --dxyDispatcher_removeEventListener(dxyEventType.UserItemDelItem,self,self.onSelectByType)
end

function SpiritLayer:initEvent()

    --dxyDispatcher_addEventListener(dxyEventType.Character_AttrUpdate,self,self.updateValue)
    --dxyDispatcher_addEventListener(dxyEventType.UserItemDelItem,self,self.onSelectByType)
    
    if(self.btn_back)then
        self.btn_back:addTouchEventListener(function(target,type)
            if(type==2)then
                SoundsFunc_playSounds(SoundsType.CLOSE_PAGE,false)
                zzc.SpiritController:closeLayer()
            end
        end)
    end
    if (self.ckb_Search) then
        self.ckb_Search:addEventListener(function(target,type)
            if type == ccui.CheckBoxEventType.selected then
                SoundsFunc_playSounds(SoundsType.OPEN_PAGE,false)
                self:onSelectByType(SpiritLayerType.SearchLayer)
            end
        end)
    end
    if (self.ckb_Spirit) then
        self.ckb_Spirit:addEventListener(function(target,type)
            if type == ccui.CheckBoxEventType.selected then
                SoundsFunc_playSounds(SoundsType.OPEN_PAGE,false)
                self:onSelectByType(SpiritLayerType.SpiritLayer)
            end
        end)
    end
    
    if self.pageView then
    	self.pageView:addEventListener(function(target,type)
    	   if type == ccui.PageViewEventType.turning then
                local page = self.pageView:getCurPageIndex()
                if page == SpiritLayerType.SpiritLayer then
                    self:onSelectByType(SpiritLayerType.SpiritLayer)
                elseif page == SpiritLayerType.SearchLayer then
                    self:onSelectByType(SpiritLayerType.SearchLayer)
                end
    	   end
    	end)   
    end
    
    -- 拦截
    dxySwallowTouches(self)
end

function SpiritLayer:onSelectByType(type)
    self.ckb_Search:setTouchEnabled(true)
    self.ckb_Spirit:setTouchEnabled(true)

    self.ckb_Search:setSelected(false)
    self.ckb_Spirit:setSelected(false)
    
    if type == SpiritLayerType.SpiritLayer then
        self.ckb_Spirit:setTouchEnabled(false)
        self.ckb_Spirit:setSelected(true)
        self.pageView:scrollToPage(SpiritLayerType.SpiritLayer)
    elseif type == SpiritLayerType.SearchLayer then
        self.ckb_Search:setTouchEnabled(false)
        self.ckb_Search:setSelected(true)
        self.pageView:scrollToPage(SpiritLayerType.SearchLayer)
        self.searchTips:setVisible(false)
    end
end


function SpiritLayer:backCallBack()
--    local accout = self.input_account:getString()
--    local password = self.input_password:getString()
--    local gameScene = LoadingController.new():getScene()
--    SceneManager:enterScene(gameScene, "LoadingScene")
end

function SpiritLayer:updateTips()
    local role = zzm.CharacterModel:getCharacterData()
    local enCAT = enCharacterAttrType
    local num = role:getValueByType(enCAT.EXPLORE)

    if num <= 0 then
        self.searchTips:setVisible(false)
    else
        self.searchTips:setVisible(true)
    end
end

function SpiritLayer:scrollToPage(page)
    if page == 0 then
        self.ckb_Search:setTouchEnabled(false)
        self.ckb_Spirit:setTouchEnabled(true)
    
        self.ckb_Search:setSelected(true)
        self.ckb_Spirit:setSelected(false)
    elseif page == 1 then
        self.ckb_Search:setTouchEnabled(true)
        self.ckb_Spirit:setTouchEnabled(false)
    
        self.ckb_Search:setSelected(false)
        self.ckb_Spirit:setSelected(true)
    end
    self.pageView:scrollToPage(page)
end

