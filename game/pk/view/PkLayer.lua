PkLayer = PkLayer or class("PkLayer",function()
    return cc.Layer:create()
end)
require "src.game.pk.view.PkNode"
require "src.game.pk.view.ArenaNode"

--require("game.pk.view.PkItem")

function PkLayer:create()
    local layer = PkLayer:new()
    return layer
end

function PkLayer:ctor()
    self._csb = nil

--    self.itemList = {}

    self:initUI()
    dxyExtendEvent(self)
    -- 拦截
    dxySwallowTouches(self)
end

function PkLayer:initUI()
    self._csb = cc.CSLoader:createNode("dxyCocosStudio/csd/ui/pk/pkLayer.csb")
    self:addChild(self._csb)

    self.visibleSize = cc.Director:getInstance():getVisibleSize()
    self.origin = cc.Director:getInstance():getVisibleOrigin()
    
    local backNode = self._csb:getChildByName("backNode")
    backNode:setPosition(cc.p(-self.visibleSize.width / 2 +self.origin.x,self.visibleSize.height / 2 +self.origin.y))
    self.btn_back = backNode:getChildByName("backBtn")
    self._btnFunc1 = backNode:getChildByName("btnFunc1")
    self._btnFunc2 = backNode:getChildByName("btnFunc2")
    self._btnFunc1:setTouchEnabled(false)
    self._btnFunc1:setBright(false)
    self._btnFunc1:addTouchEventListener(function(target,type)
        if type == 2 then
            self._btnFunc1:setTouchEnabled(false)
            self._btnFunc1:setBright(false)
            self._btnFunc2:setTouchEnabled(true)
            self._btnFunc2:setBright(true)
            self._pageView:scrollToPage(0)
        end
    end)
    self._btnFunc2:addTouchEventListener(function(target,type)
        if type == 2 then
            self._btnFunc1:setTouchEnabled(true)
            self._btnFunc1:setBright(true)
            self._btnFunc2:setTouchEnabled(false)
            self._btnFunc2:setBright(false)
            self._pageView:scrollToPage(1)
        end
    end)
    
    
    local topBg = self._csb:getChildByName("topBg")
    
    local dataNode = self._csb:getChildByName("dataNode")
    dataNode:setPosition(cc.p(self.visibleSize.width / 2 + self.origin.x ,self.visibleSize.height / 2 + self.origin.y - 35))
    require "src.game.utils.TopDataNode"
    local data = TopDataNode:create()
    dataNode:addChild(data)
    
    self.btn_back:addTouchEventListener(function(target,type)
        if type == 2 then
            SoundsFunc_playSounds(SoundsType.CLOSE_PAGE,false)
            zzc.PkController:closeLayer()
        end
    end)
    
--pageView    
    self._pageView = self._csb:getChildByName("PageView")
    self._pageView:setContentSize(self.visibleSize.width,self.visibleSize.height)
--    self._pageView:setPosition(self.origin.x + self.visibleSize.width / 2, self.origin.y + self.visibleSize.height / 2)
    self._pageView:setPosition(0,0)

    self._node1 = PkNode:create()
    self._pageView:addPage(self._node1)

    self._node2 = ArenaNode:create()
    self._pageView:addPage(self._node2)

    self._pageView:scrollToPage(0)
    

--    local leftNode = self._csb:getChildByName("leftNode")
--    self.txt_count = leftNode:getChildByName("countTxt")
--    self.btn_ranking = leftNode:getChildByName("rankingBtn")
--    self.btn_news = leftNode:getChildByName("newsBtn")
--    self.btn_news:setTouchEnabled(false)
--    self.btn_ranking:setPressedActionEnabled(true)
--    self.btn_news:setPressedActionEnabled(true)
--    self.btn_add = leftNode:getChildByName("addBtn")
--    self.roleNode = leftNode:getChildByName("roleNode")
--    self.pic_role = self.roleNode:getChildByName("rolePic")
--    local nameBg = leftNode:getChildByName("nameBg")
--    self.txt_name = nameBg:getChildByName("nameTxt")
--    self.txt_lv = nameBg:getChildByName("lvTxt")
--    self.txt_power = nameBg:getChildByName("powerTxt")
--    self.txt_ranking = nameBg:getChildByName("rankingTxt")
--    
--    local rewardNode = leftNode:getChildByName("rewardNode")
--    self.txt_gold = rewardNode:getChildByName("copperTxt")
--    self.txt_rmb = rewardNode:getChildByName("goldTxt")
--    self.txt_renown = rewardNode:getChildByName("renownTxt")
--
--    local rightNode = self._csb:getChildByName("rightNode")
--    self._panel = rightNode:getChildByName("dekaronPanel")
--    
--    self.middleNode = self._csb:getChildByName("middleNode")
--    
--    self:addPanel()
--    
--    local role = zzm.CharacterModel:getCharacterData()
--    local enCAT = enCharacterAttrType
--    self.pic_role:setTexture(HeroConfig:getValueById(role:getValueByType(enCAT.PRO))["BgLing"])
--    
--    zzc.PkController:getPkData()
--    
--    zzm.TalkingDataModel:onEvent(EumEventId.PK_OPEN_COUNT,{})
end

function PkLayer:scrollToPage(page)
    if page == 0 then
        self._btnFunc1:setTouchEnabled(true)
        self._btnFunc1:setBright(true)
        self._btnFunc2:setTouchEnabled(false)
        self._btnFunc2:setBright(false)
    elseif page == 1 then
        self._btnFunc1:setTouchEnabled(true)
        self._btnFunc1:setBright(true)
        self._btnFunc2:setTouchEnabled(false)
        self._btnFunc2:setBright(false)
    end
    self._pageView:scrollToPage(page)
end

--function PkLayer:addPanel()
--    local item = nil
--    local itemSize = nil
--    local x,y = 0,0
--    local index = 1
--    for i=5,1,-1 do
--        item = PkItem:create()
--        item:setName("pkItem_"..index)
--        item:setParent(self)
--        itemSize = item:getFrameSize()
--        x = 8
--        y = (itemSize.height + 6) * (i - 1)
--        item:setPosition(cc.p(x,y))
--        self._panel:addChild(item)
--        self.itemList[index] = item
--        index = index + 1
--    end
--end
--
--function PkLayer:initEvent()
--
--    dxyDispatcher_addEventListener(dxyEventType.Pk_Data_Upgrade,self,self.updateValue)
--    dxyDispatcher_addEventListener(dxyEventType.Character_AttrUpdate,self,self.updateData)
--    
--    self:updateData()
--
--    self.btn_back:addTouchEventListener(function(target,type)
--        if type == 2 then
--            SoundsFunc_playSounds(SoundsType.CLOSE_PAGE,false)
--            zzc.PkController:closeLayer()
--        end
--    end)
--    
--    self.btn_ranking:addTouchEventListener(function(target,type)
--        if type == 2 then
--            SoundsFunc_playSounds(SoundsType.OPEN_PAGE,false)
--        	require("game.pk.view.PkRankingLayer")
--        	local layer = PkRankingLayer:create()
--        	self.middleNode:addChild(layer)
--        end
--    end)
--    
--    self.btn_news:addTouchEventListener(function(target,type)
--        if type == 2 then
--            SoundsFunc_playSounds(SoundsType.OPEN_PAGE,false)
--            require("game.pk.view.PkNewsLayer")
--            local layer = PkNewsLayer:create()
--            self.middleNode:addChild(layer)
--        end
--    end)
--    
--    self.btn_add:addTouchEventListener(function(target,type)
--        if type == 2 then
--            SoundsFunc_playSounds(SoundsType.OPEN_PAGE,false)
--            if self.buyCount >= #PkConfig:getBuyCountData() then
--            	dxyFloatMsg:show("已到购买上限")
--            	return
--            end
--            
--            local function callBack(target,type)
--                if type == 2 then
--                    SoundsFunc_playSounds(SoundsType.UNIVERSAL_BTN,false)
--                    UIManager:closeUI("CustomTips")
--                    zzc.PkController:request_buyCount()
--                end
--            end
--            local layer = CustomTips:create()
--            local text = "是否花费"..PkConfig:getRmbByCount(self.buyCount + 1).."元宝购买挑战次数?"
--            layer:update(text,callBack)
--        end
--    end)
--
--    -- 拦截
--    dxySwallowTouches(self)
--end
--
--function PkLayer:removeEvent()
--    dxyDispatcher_removeEventListener(dxyEventType.Pk_Data_Upgrade,self,self.updateValue)
--    dxyDispatcher_removeEventListener(dxyEventType.Character_AttrUpdate,self,self.updateData)
--end
--
--function PkLayer:updateData()
--    local role = zzm.CharacterModel:getCharacterData()
--    local enCAT = enCharacterAttrType
--    
--    self.count = role:getValueByType(enCAT.WARCOUNT)
--    self.buyCount = role:getValueByType(enCAT.WARBUY)
--
--    self.txt_name:setString(role:getValueByType(enCAT.NAME))
--    self.txt_lv:setString("LV."..role:getValueByType(enCAT.LV))
--    self.txt_power:setString(role:getValueByType(enCAT.POWER))
--    self.txt_ranking:setString("第"..zzm.PkModel.ranking.."名")
--    self.txt_count:setString(self.count)
--end
--
--function PkLayer:updateValue()
--	for index=1, #zzm.PkModel.player_list do
--		self.itemList[index]:update(zzm.PkModel.player_list[index])
--	end
--    self.txt_ranking:setString("第"..zzm.PkModel.ranking.."名")
--    self:setReward()
--end
--
--function PkLayer:setReward()
--    local data = PkConfig:getRewardByRanking(zzm.PkModel.ranking)
--    self.txt_gold:setString(data.Gold)
--    self.txt_rmb:setString(data.Rmb)
--    self.txt_renown:setString(data.Renown)
--end

function PkLayer:WhenClose()
    self:removeFromParent()
end