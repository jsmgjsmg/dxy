GeneralRank = GeneralRank or class("GeneralRank",function()
    return ccui.Layout:create()
end)
local HEIGHT = 97
local WIDTH = 97
local ROW = 12 

function GeneralRank:ctor()
    self.visibleSize = cc.Director:getInstance():getVisibleSize()
    self.origin = cc.Director:getInstance():getVisibleOrigin()
    self._arrBoxItem = {}
    self._arrStar = {}
    self._arrSkill = {}
    self._arrDrop = {}
end

function GeneralRank:create()
    local node = GeneralRank:new()
    node:initNode()
    return node
end

function GeneralRank:initNode()
    self._csb = cc.CSLoader:createNode("res/dxyCocosStudio/csd/ui/general/GeneralRank.csb")
    self:addChild(self._csb)
    self.visibleSize = cc.Director:getInstance():getVisibleSize()
    self.origin = cc.Director:getInstance():getVisibleOrigin()
    local posX = self.origin.x + self.visibleSize.width/2
    local posY = self.origin.y + self.visibleSize.height/2
    self._csb:setPosition(posX,posY)
    
    dxyExtendEvent(self)
    
    local ndStage = self._csb:getChildByName("nd_stage")
    
--Res
    self._txtPhy = ndStage:getChildByName("physical"):getChildByName("txtPhy")
    self._Golden = ndStage:getChildByName("yellow"):getChildByName("txt_yellow")
    self._Blue = ndStage:getChildByName("blue"):getChildByName("txt_blue")
    
    local btnPhy = ndStage:getChildByName("physical"):getChildByName("btnPhy")
    btnPhy:addTouchEventListener(function(target,type)
        if type == 2 then
            SoundsFunc_playSounds(SoundsType.UNIVERSAL_BTN,false)
            zzc.PhysicalTipsController:showGodLayer()
        end
    end)
    self:RankRes()
    
    self._sprite = ndStage:getChildByName("Sprite")
    self._ndModel = self._sprite:getChildByName("ndModel")
    self._txtName = self._sprite:getChildByName("txtName")
    self._txtDff = self._sprite:getChildByName("txtDff")
    
    --btnChange
    local btnChange = ndStage:getChildByName("btn_change")
    self._txtSur = btnChange:getChildByName("txt_sur")
    btnChange:addTouchEventListener(function(target,type)
        if type == 2 then
            SoundsFunc_playSounds(SoundsType.UNIVERSAL_BTN,false)
            zzc.GeneralController:UpDateCopy()
        end
    end)

    self._Text = btnChange:getChildByName("Text")
    self._txtRmb = self._Text:getChildByName("txtRmb")
    
    local nsDrop = self._csb:getChildByName("nd_drop")
    for i=1,6 do
        self._arrDrop[i] = nsDrop:getChildByName("drop"..i):getChildByName("btnDrop")
        self._arrDrop[i]:addTouchEventListener(function(target,type)
            if type == 2 then

            end
        end)
    end
    
    
    --挑战
    local btnFight = ndStage:getChildByName("btn_fight")
    btnFight:addTouchEventListener(function(target,type)
        if type == 2 then
            SoundsFunc_playSounds(SoundsType.UNIVERSAL_BTN,false)
            if self._role:getValueByType(self._enCAT.GNCOPYCN) >= self._need then
                self:enterGeneralCopy(self._GNCopyDFC)
            else
                dxyFloatMsg:show("体力不足")
            end
        end
    end)
    self._txtCN = btnFight:getChildByName("txtCN")
    
    --扫荡
    local btnRipe = ndStage:getChildByName("btn_ripe")
    btnRipe:addTouchEventListener(function(target,type)
        if type == 2 then
            SoundsFunc_playSounds(SoundsType.UNIVERSAL_BTN,false)
            if self._role:getValueByType(self._enCAT.RMB) < self.rmb_need then
                dxyFloatMsg:show("元宝不足")
                return
            end
            if self._role:getValueByType(self._enCAT.GNCOPYCN) < self._need then
                dxyFloatMsg:show("体力不足")
                zzc.PhysicalTipsController:showGodLayer()
                return
            end
            zzc.SweepController:request_generalSweep()
        end  
    end)
    
    self._txtRipe = btnRipe:getChildByName("txtCN")
    
--ndMsg    
    local _ndMsg = self._csb:getChildByName("nd_msg")
    
    
--ndBox    
    local ndBox = self._csb:getChildByName("nd_box")
    self._sv = ndBox:getChildByName("ScrollView")
    self._sv:setScrollBarEnabled(false)
    local width = self._sv:getContentSize().width
    local svHeight = ROW * HEIGHT
    self._sv:setInnerContainerSize(cc.size(width,svHeight))
    local posx = 0
    local posy = 0
    local count = 0
    for i=1,12 do --列
        posy = (i-1) * HEIGHT + 50
        for j=1,4 do --行
            posx = (j-1) * WIDTH + 50
            require "src.game.general.view.ItemBox"
            count = count + 1
            local data = {[1]=self._sv,[2]=posx,[3]=svHeight-posy,[4]=count}
            self._arrBoxItem[count] = ItemBox:create(data)
            self._arrBoxItem[count]:upDate(zzm.GeneralModel.Fragment[count])
            self._sv:addChild(self._arrBoxItem[count],1)
            self._arrBoxItem[count]:setPosition(posx,svHeight - posy)
        end
    end
    
    local btnConvert = ndBox:getChildByName("btn_convert")
    local btnDestroy = ndBox:getChildByName("btn_destroy")
    btnConvert:addTouchEventListener(function(target,type)
        if type == 2 then
            SoundsFunc_playSounds(SoundsType.OPEN_PAGE,false)
            require "src.game.general.view.FragmentShop"
            local shop = FragmentShop:create()
            self:addChild(shop)
        end
    end)
    btnDestroy:addTouchEventListener(function(target,type)
        if type == 2 then
            SoundsFunc_playSounds(SoundsType.OPEN_PAGE,false)
            require "src.game.general.view.DestroyMore"
            local more = DestroyMore:create(1)
            self:addChild(more)
        end
    end)
    
    self:GNCopyUD()
end

function GeneralRank:initEvent()
    dxyDispatcher_addEventListener("addFragment",self,self.addFragment)
    dxyDispatcher_addEventListener("delFragment",self,self.delFragment)
    dxyDispatcher_addEventListener("changeFragment",self,self.changeFragment)
    dxyDispatcher_addEventListener(dxyEventType.Character_AttrUpdate,self,self.RankRes)
    
    dxyDispatcher_addEventListener("GNCopyUD",self,self.GNCopyUD)
    dxyDispatcher_addEventListener("GeneralRank_RankAgain",self,self.RankAgain)
end

function GeneralRank:removeEvent()
    dxyDispatcher_removeEventListener("addFragment",self,self.addFragment)
    dxyDispatcher_removeEventListener("delFragment",self,self.delFragment)
    dxyDispatcher_removeEventListener("changeFragment",self,self.changeFragment)
    dxyDispatcher_removeEventListener(dxyEventType.Character_AttrUpdate,self,self.RankRes)
    
    dxyDispatcher_removeEventListener("GNCopyUD",self,self.GNCopyUD)
    dxyDispatcher_removeEventListener("GeneralRank_RankAgain",self,self.RankAgain)
    
    self:removeModle()
end

function GeneralRank:addFragment(data)
    for i,target in pairs(self._arrBoxItem) do
        if target._data == nil then
            target:upDate(data)
            break
        end
    end
end

function GeneralRank:delFragment(id)
    for i,target in pairs(self._arrBoxItem) do
        if target._data and target._data.Id == id then
            target:upDate()
            break
        end
    end
end

function GeneralRank:changeFragment(data)
    for i,target in pairs(self._arrBoxItem) do
        if target._data and data["Id"] == target._data["Id"] then
            target:upDate(data)
            break
        end
    end
end

function GeneralRank:RankAgain()
    local count = 0
    for i=1,12 do --列
        for j=1,4 do --行
            count = count + 1
            self._arrBoxItem[count]:upDate(zzm.GeneralModel.Fragment[count])
        end
    end
end

function GeneralRank:updateStage(id)
    local dfc = GodGeneralSceneConfig:getCopyDifficulty(self._GNCopyDFC)
    local mst = GodGeneralSceneConfig:getCopyMonster(dfc,self._GNCopyMST)
    
    self._txtName:setString(mst.Name)
    self._txtDff:setString(zzd.GodGeneralData[dfc.Difficulty])
    
    if self._action then
        self._ndModel:removeAllChildren()
    end
    local Ossature = GodGeneralConfig:getSceneModel(mst.Icon)
    self._action = mc.SkeletonDataCash:getInstance():createWithCashName(Ossature)
    self._action:setAnimation(1,"ready", true)
    self._action:setAnchorPoint(0.5,0)
    self._action:setPosition(0,0)
    self._ndModel:addChild(self._action)
    
    ---drop
    for j=1,6 do
        self._arrDrop[j]:setVisible(false)
    end
    local dropList = dfc.SceneDrop.DropPreview
    for i=1,#dropList do
        local goods = GoodsConfigProvider:findGoodsById(dropList[i].Id)
        self._arrDrop[i]:loadTextureNormal("GodGeneralsIcon/"..goods.Icon..".png")
        self._arrDrop[i]:loadTexturePressed("GodGeneralsIcon/"..goods.Icon..".png")
        self._arrDrop[i]:setVisible(true)
    end
end

function GeneralRank:GNCopyUD()
    self._role = zzm.CharacterModel:getCharacterData()
    self._enCAT = enCharacterAttrType
    local Ud = self._role:getValueByType(self._enCAT.GNCOPYUD)
    if Ud == 0 then --更新扣元宝
        self._Text:setVisible(true)
        self._txtSur:setVisible(false)
        self._txtRmb:setString(GodGeneralSceneConfig:getCopyValue().Rmb)
    else
        self._Text:setVisible(false)
        self._txtSur:setVisible(true)
        self._txtSur:setString("剩余"..Ud.."次")
    end
    self._need = GodGeneralConfig:getPowerNeed()--挑战扣体力
    self._txtCN:setString(self._need)
    
    self.rmb_need = GodGeneralSceneConfig:getRmbGeneralRipe()--扫荡元宝
    self._txtRipe:setString(self.rmb_need)

    self._GNCopyDFC = nil
    self._GNCopyMST = nil
    if zzm.GeneralModel._GNCopyDFC and zzm.GeneralModel._GNCopyMST then
        self._GNCopyDFC = zzm.GeneralModel._GNCopyDFC
        self._GNCopyMST = zzm.GeneralModel._GNCopyMST
    else
        self._GNCopyDFC = self._role:getValueByType(self._enCAT.GNCOPYDFC)
        self._GNCopyMST = self._role:getValueByType(self._enCAT.GNCOPYMST)
    end
    dxyWaitBack:close()
    self:updateStage(_G.GeneralData.Current)
end

function GeneralRank:RankRes()
    local role = zzm.CharacterModel:getCharacterData()
    local enCAT = enCharacterAttrType
    self._txtPhy:setString(role:getValueByType(enCAT.GNCOPYCN).."/"..PhysicalConfig:getBaseValue().Limit)
    self._Golden:setString(cn:convert(role:getValueByType(enCAT.ENERGYSOUL)))
    self._Blue:setString(cn:convert(role:getValueByType(enCAT.SOUL)))
end

function GeneralRank:removeModle()
    if self._action then
        self._ndModel:removeAllChildren()
        self._action = nil
    end
end

--按照难度进入神将挑战副本
function GeneralRank:enterGeneralCopy(difficulty)
    zzc.LoadingController:setCopyData({copyType = DefineConst.CONST_COPY_TYPE_GODWILL,chapterID = difficulty, startTalkID = 0, endTalkID = 0,
        sceneID = GodGeneralSceneConfig:getSceneIdByDifficulty(difficulty), param1 = 0})
    zzc.LoadingController:enterScene(SceneType.LoadingScene)
    zzc.LoadingController:setDelegate2({target = self,func = function (data) zzc.LoadingController:enterScene(SceneType.CopyScene) end,data = self.m_data})
end
