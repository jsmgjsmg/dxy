SpiritSerachLayer = SpiritSerachLayer or class("SpiritSerachLayer",function()
    return ccui.Layout:create()
end)

function SpiritSerachLayer:create()
    local node = SpiritSerachLayer:new()
    return node
end

function SpiritSerachLayer:ctor()

    self.difficulty = zzm.SpiritModel.curSpiritDifficulty
    self.lv = MagicSoulConfigProvider:getUnlockLvByType(zzm.SpiritModel.curSpiritLvType)

    self:initUI()
--    self:initEvent()

    dxyExtendEvent(self)
end

function SpiritSerachLayer:setParent(parent)
    self._parent = parent
end

function SpiritSerachLayer:initUI()
    self._csbNode = cc.CSLoader:getInstance():createNodeWithFlatBuffersFile("dxyCocosStudio/csd/ui/spirit/SpiritSearchLayer.csb")
    self:addChild(self._csbNode)
    self.visibleSize = cc.Director:getInstance():getVisibleSize()
    self.origin = cc.Director:getInstance():getVisibleOrigin()

    --加载动画
    self._action = cc.CSLoader:createTimeline("dxyCocosStudio/csd/ui/spirit/SpiritSearchLayer.csb")
    self._csbNode:runAction(self._action)

    --self._action:gotoFrameAndPlay(35,55,true)

    local posX = self.origin.x + self.visibleSize.width/2
    local posY = self.origin.y + self.visibleSize.height/2

    self._csbNode:setPosition(posX, posY)

    self.pageView = self._csbNode:getChildByName("PageView")
    local panel_1 = self.pageView:getChildByName("Panel_1")
    local panel_2 = self.pageView:getChildByName("Panel_2")
    self.lv_list = {}
    for index=1, 4 do
        self.lv_list[index] = panel_1:getChildByName("CheckBox_"..index)
    end
    for index=5, 8 do
        self.lv_list[index] = panel_2:getChildByName("CheckBox_"..index)
    end

    local btnNode = self._csbNode:getChildByName("Btn_Node")
    self.diff_list = {}
    for index=1, 3 do
        self.diff_list[index] = btnNode:getChildByName("CheckBox_"..index)
    end

    self.btn_left = self._csbNode:getChildByName("leftBtn")
    self.btn_right = self._csbNode:getChildByName("rightBtn")

    self.btn_search = self._csbNode:getChildByName("DownNode"):getChildByName("searchBtn")
    self.btn_quickSearch = self._csbNode:getChildByName("DownNode"):getChildByName("quickSearchBtn")
    --    local node = self._csbNode:getChildByName("sBG")
    --    self.btn_back = node:getChildByName("Back")
    self.info = self._csbNode:getChildByName("DownNode"):getChildByName("info")
    self.txt_count = self.info:getChildByName("countTxt")

    require("game.spirit.view.SpiritItem")
    local itemNode = self._csbNode:getChildByName("DownNode"):getChildByName("itemNode")
    local item = nil
    local spiritItem = nil
    self.list_Item = {}
    for index=1, 5 do
        item = itemNode:getChildByName("item_"..index)
        spiritItem = SpiritItem:create()
        spiritItem:update()
        spiritItem:setName("spiritCopyAward_"..index)
        item:addChild(spiritItem)
        self.list_Item[index] = spiritItem
    end

    self.searchInfo = self._csbNode:getChildByName("DownNode"):getChildByName("searchInfo")
    self.txt_gold = self.searchInfo:getChildByName("goldTxt")
    local quickSearchInfo = self._csbNode:getChildByName("DownNode"):getChildByName("quickSearchInfo")
    self.txt_rmb = quickSearchInfo:getChildByName("rmbTxt")
    
    self.sweepCount = quickSearchInfo:getChildByName("sweepCount")
    self.textTips = quickSearchInfo:getChildByName("Text")
    self.searchRmbTxt = self.btn_quickSearch:getChildByName("searchRmb")

    require "game.spirit.view.SpiritCopyMapLayer"

    self:selectLvType(zzm.SpiritModel.curSpiritLvType)
    self:selectDiffType(zzm.SpiritModel.curSpiritDifficulty)
    self:updateRmbtxt()
    self:setBtnRipeState()
end

function SpiritSerachLayer:updateSwallowList(data)
    for index=1, 5 do
        if self.list_Item[index] then
            self.list_Item[index]:update(data[index])
        end
    end
end

function SpiritSerachLayer:updateEquipNode(data)
    if not data then
        return
    end
    --self.text_EquipName:setString(data.conf)
    --self.text_Loading:setString(data.curExp.. "/" .. data.maxExp)
    --self.loadingBar
    self.item_Equip:update(data)
end

--function SpiritSerachLayer:initEvent()
--    dxyDispatcher_addEventListener("SpiritSerachLayer_updateRmbtxt",self,self.updateRmbtxt)
--end

function SpiritSerachLayer:removeEvent()
    dxyDispatcher_removeEventListener("SpiritSerachLayer_updateRmbtxt",self,self.updateRmbtxt)
end

function SpiritSerachLayer:initEvent()
    local role = zzm.CharacterModel:getCharacterData()
    local enCAT = enCharacterAttrType
    self.searchCount = role:getValueByType(enCAT.EXPLORE)
    if self.searchCount > 0 then
    	self.txt_count:setString(self.searchCount.."次")
        self.info:setVisible(true)
        self.searchInfo:setVisible(false)
    else
        self.info:setVisible(false)
        self.searchInfo:setVisible(true)
    end
    

    local lock = nil
    local unlock = nil

    for index=1, 8 do
        lock = self.lv_list[index]:getChildByName("lock")
        unlock = self.lv_list[index]:getChildByName("unlock")
        if role:getValueByType(enCAT.LV) >= MagicSoulConfigProvider:getUnlockLvByType(index) then
            lock:setVisible(false)
            unlock:setVisible(true)
            self.lv_list[index]:setBright(true)
            --self.lv_list[index]:setTouchEnabled(true)
        else
            lock:setVisible(true)
            unlock:setVisible(false)
            self.lv_list[index]:setBright(false)
            --self.lv_list[index]:setTouchEnabled(false)
        end
    end

    if(self.btn_search)then
        self.btn_search:addTouchEventListener(function(target,type)
            if(type==2)then
                SoundsFunc_playSounds(SoundsType.UNIVERSAL_BTN,false)
                --                if self.searchCount <= 0 then
                --                	TipsFrame:create("次数已用完!")
                --                	return
                --                end
                --打开地图界
--                local searchCount
--                if searchCount <= 0 then
--                	dxyFloatMsg:show("探索次数已用完")
--                	return
--                end
                zzm.SpiritModel.spirit_type = DefineConst.CONST_MAGICSOUL_COPY_TYPE_NORMAL
                local layer = SpiritCopyMapLayer.create()
                layer:update(self.difficulty,self.lv)
                self:addChild(layer)
--                local scene = SceneManager:getCurrentScene()
--                scene:addChild(layer)
                zzc.SpiritController:searchSpiritCopy(DefineConst.CONST_MAGICSOUL_COPY_TYPE_NORMAL,self.difficulty,self.lv)
            end
        end)
    end

    if(self.btn_quickSearch)then
        self.btn_quickSearch:addTouchEventListener(function(target,type)
            if(type==2)then
                SoundsFunc_playSounds(SoundsType.UNIVERSAL_BTN,false)
--                if _G.RoleData.VipLv < VipConfig:getVipByPrivilege(DefineConst.CONST_VIP_PRIVILEGE_TYPE_FAST_MAGICSOUL_COPY) then
--                	dxyFloatMsg:show("VIP权限不足")
--                	return
--                end
                if zzm.SpiritModel.spiritSweepCount <= 0 then
                	dxyFloatMsg:show("扫荡次数不足")
                	return
                end
                zzm.SpiritModel.spirit_type = DefineConst.CONST_MAGICSOUL_COPY_TYPE_FAST
--                local layer = SpiritCopyMapLayer.create()
--                layer:update(self.difficulty,self.lv)
--                local scene = SceneManager:getCurrentScene()
--                scene:addChild(layer)
                zzc.SpiritController:searchSpiritCopy(DefineConst.CONST_MAGICSOUL_COPY_TYPE_FAST,self.difficulty,self.lv)
            end
        end)
    end


    for index=1, 8 do
        self.lv_list[index]:addEventListener(function(target,type)
            if type == ccui.CheckBoxEventType.selected then
                SoundsFunc_playSounds(SoundsType.UNIVERSAL_BTN,false)
                self:selectLvType(index)
            end
        end)
    end

    for index=1, 3 do
        self.diff_list[index]:addEventListener(function(target,type)
            if type == ccui.CheckBoxEventType.selected then
                SoundsFunc_playSounds(SoundsType.UNIVERSAL_BTN,false)
                self:selectDiffType(index)
            end
        end)
    end

    self.btn_left:addTouchEventListener(function(target,type)
        if type == 2 then
            self.pageView:scrollToPage(0)
        end
    end)

    self.btn_right:addTouchEventListener(function(target,type)
        if type == 2 then
            self.pageView:scrollToPage(1)
        end
    end)
    
    dxyDispatcher_addEventListener("SpiritSerachLayer_updateRmbtxt",self,self.updateRmbtxt)

end

function SpiritSerachLayer:selectDiffType(diffType)
    self.difficulty = diffType

    for key, var in pairs(self.diff_list) do
        if key == diffType then
            self.diff_list[key]:setTouchEnabled(false)
        else
            self.diff_list[key]:setTouchEnabled(true)
            self.diff_list[key]:setSelected(false)
        end
    end
    self:setGoldAndRmb()
    self:setBtnRipeState()
end

function SpiritSerachLayer:selectLvType(lvType)

    self:setDrop(MagicSoulConfigProvider:getUnlockLvByType(lvType))

    local role = zzm.CharacterModel:getCharacterData()
    local enCAT = enCharacterAttrType

    self.lv = MagicSoulConfigProvider:getUnlockLvByType(lvType)
    for key, var in pairs(self.lv_list) do
        if key == lvType then
            self.lv_list[key]:setTouchEnabled(false)
        elseif role:getValueByType(enCAT.LV) >= MagicSoulConfigProvider:getUnlockLvByType(key) then
            self.lv_list[key]:setTouchEnabled(true)
            self.lv_list[key]:setSelected(false)
        else
            self.lv_list[key]:setTouchEnabled(false)
            self.lv_list[key]:setSelected(false)
        end
    end
    self:setGoldAndRmb()
    self:setBtnRipeState()
end

function SpiritSerachLayer:setGoldAndRmb()
    self.txt_gold:setString(MagicSoulConfigProvider:getAllCopyNeedGold(self.lv,self.difficulty))
    self.txt_rmb:setString(MagicSoulConfigProvider:getAllCopyNeedRmb(self.lv,self.difficulty))
    
--    local copy = MagicSoulConfigProvider:getSpiritCopyState(self.lv,self.difficulty)
--    if copy.state then
--        self.btn_quickSearch:setTouchEnabled(true)
--        self.btn_quickSearch:setBright(true)
--    else
--        self.btn_quickSearch:setTouchEnabled(false)
--        self.btn_quickSearch:setBright(false)
--    end
end

function SpiritSerachLayer:updateRmbtxt()
    if zzm.SpiritModel.useRmb <= 0 then
    	local rmb = MagicSoulConfigProvider:getRmbByCount(1)
    	self.searchRmbTxt:setString(rmb)
    else
        self.searchRmbTxt:setString(zzm.SpiritModel.useRmb)
    end
    
    if zzm.SpiritModel.spiritSweepCount > 0 then
        self.sweepCount:setString(zzm.SpiritModel.spiritSweepCount)
    else
        self.sweepCount:setString(0)
    end
    
end

function SpiritSerachLayer:setDrop(lv)
    local data = MagicSoulConfigProvider:getDropByLv(lv)
    
    if not data then
    	return
    end

    for index=1, #data do
        self.list_Item[index]:updateCopyData(GoodsConfigProvider:findGoodsById(data[index].Id))
    end

end

function SpiritSerachLayer:setBtnRipeState()
    local state = MagicSoulConfigProvider:getSpiritCopyStateByLvAndDiff(self.lv,self.difficulty)
    if state then
		self.btn_quickSearch:setTouchEnabled(true)
		self.btn_quickSearch:setBright(true)
        self.textTips:setVisible(false)
        self.sweepCount:setVisible(true)
	else
        self.btn_quickSearch:setTouchEnabled(false)
        self.btn_quickSearch:setBright(false)
        self.textTips:setVisible(true)
        self.sweepCount:setVisible(false)
	end
end


