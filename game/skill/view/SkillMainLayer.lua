
SkillLayerType = {
    InfoLayer = 0,
    ContLayer = 1,
}

SkillMainLayer = SkillMainLayer or class("SkillMainLayer",function()
    return cc.Layer:create()
end)

function SkillMainLayer.create()
    local layer = SkillMainLayer.new()
    return layer
end

function SkillMainLayer:ctor()
    self._csbNode = nil

    self:initUI()
    dxyExtendEvent(self)
    --屏蔽点击事件
    dxySwallowTouches(self)
end

function SkillMainLayer:initUI()
    self._csbNode = cc.CSLoader:getInstance():createNodeWithFlatBuffersFile("dxyCocosStudio/csd/ui/skill/SkillMainLayer.csb")
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

    self.ckb_SkillInfo = backNode:getChildByName("CheckBox_2")
    self.ckb_SkillCont = backNode:getChildByName("CheckBox_1")
    
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

    require "game.skill.view.SkillInfoPage"
    require "game.skill.view.SkillContinuousPage"

    local pageSize = nil

    self.pageItem = {}
    local page = SkillInfoPage.create()
    self.pageView:insertPage(page,SkillLayerType.InfoLayer)
    --page:update(zzm.CopySelectModel:getChapterByIndex(SpiritLayerType.SpiritLayer))
    self.pageItem[SkillLayerType.InfoLayer] = page
    local page = SkillContinuousPage.create()
    self.pageView:insertPage(page,SkillLayerType.ContLayer)
    self.pageItem[SkillLayerType.ContLayer] = page
    self.pageView:setPosition(posX, posY)
    self.pageView:setContentSize(posX*2, posY*2)

    self:onSelectByType(SkillLayerType.InfoLayer)
end

function SkillMainLayer:WhenClose()
    self:removeFromParent()
--    zzc.SkillController:unregisterListenner()
end

function SkillMainLayer:removeEvent()
--dxyDispatcher_removeEventListener(dxyEventType.Character_AttrUpdate,self,self.updateValue)
--dxyDispatcher_removeEventListener(dxyEventType.UserItemDelItem,self,self.onSelectByType)
end

function SkillMainLayer:initEvent()

    --dxyDispatcher_addEventListener(dxyEventType.Character_AttrUpdate,self,self.updateValue)
    --dxyDispatcher_addEventListener(dxyEventType.UserItemDelItem,self,self.onSelectByType)

    if(self.btn_back)then
        self.btn_back:addTouchEventListener(function(target,type)
            if(type==2)then
                --self:removeFromParent()
                SoundsFunc_playSounds(SoundsType.CLOSE_PAGE,false)
                zzc.SkillController:closeLayer()
            end
        end)
    end
    if (self.ckb_SkillInfo) then
        self.ckb_SkillInfo:addEventListener(function(target,type)
            if type == ccui.CheckBoxEventType.selected then
                SoundsFunc_playSounds(SoundsType.UNIVERSAL_BTN,false)
                self:onSelectByType(SkillLayerType.InfoLayer)
            end
        end)
    end
    if (self.ckb_SkillCont) then
        self.ckb_SkillCont:addEventListener(function(target,type)
            if type == ccui.CheckBoxEventType.selected then
                SoundsFunc_playSounds(SoundsType.UNIVERSAL_BTN,false)
                self:onSelectByType(SkillLayerType.ContLayer)
            end
        end)
    end
    
    if (self.pageView) then
    	self.pageView:addEventListener(function(target,type)
    	   if type == ccui.PageViewEventType.turning then
                local page = self.pageView:getCurPageIndex()
                if page == SkillLayerType.InfoLayer then
                    self:onSelectByType(SkillLayerType.InfoLayer)
                elseif page == SkillLayerType.ContLayer then
                    self:onSelectByType(SkillLayerType.ContLayer)
    	   	   end
    	   end
    	end)
    end
end

function SkillMainLayer:onSelectByType(type)
    self.ckb_SkillInfo:setTouchEnabled(true)
    self.ckb_SkillCont:setTouchEnabled(true)

    self.ckb_SkillInfo:setSelected(false)
    self.ckb_SkillCont:setSelected(false)

    if type == SkillLayerType.ContLayer then
        self.ckb_SkillCont:setTouchEnabled(false)
        self.ckb_SkillCont:setSelected(true)
        --self.pageItem[SkillLayerType.InfoLayer]:removeChildEvent()
        self.pageView:scrollToPage(SkillLayerType.ContLayer)
    elseif type == SkillLayerType.InfoLayer then
        self.ckb_SkillInfo:setTouchEnabled(false)
        self.ckb_SkillInfo:setSelected(true)
        --self.pageItem[SkillLayerType.InfoLayer]:initChildEvent()
        self.pageView:scrollToPage(SkillLayerType.InfoLayer)
    end
    --print("-------------" .. type)
end


function SkillMainLayer:backCallBack()
--    local accout = self.input_account:getString()
--    local password = self.input_password:getString()
--    local gameScene = LoadingController.new():getScene()
--    SceneManager:enterScene(gameScene, "LoadingScene")
end
