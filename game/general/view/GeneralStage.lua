GeneralStage = GeneralStage or class("GeneralStage",function()
    return ccui.Layout:create()
end)
--local HEIGHT = 70
--local WIDTH = 80

local LIST = 4
local HEIGHT = 97
local WIDTH = 97
local ROW = 12 

function GeneralStage:ctor()
    self.visibleSize = cc.Director:getInstance():getVisibleSize()
    self.origin = cc.Director:getInstance():getVisibleOrigin()
--    self._arrDrop = {}
    self._arrSkill = {}
    self._arrStar = {}
    self._arrBoxItem = {}
    self._btnTitle = {
        [1] = "一",
        [10] = "十",
    }
    self._isFirst = true
end

function GeneralStage:create()
    local node = GeneralStage:new()
    node:initNode()
    return node
end

function GeneralStage:initNode()
    self._csb = cc.CSLoader:createNode("res/dxyCocosStudio/csd/ui/general/GeneralStage.csb")
    self:addChild(self._csb)
    self.visibleSize = cc.Director:getInstance():getVisibleSize()
    self.origin = cc.Director:getInstance():getVisibleOrigin()
    local posX = self.origin.x + self.visibleSize.width/2
    local posY = self.origin.y + self.visibleSize.height/2
    self._csb:setPosition(posX,posY)
    self:setPosition(0,0)
    
    self._tl = cc.CSLoader:createTimeline("res/dxyCocosStudio/csd/ui/general/GeneralStage.csb") 
    self._csb:runAction(self._tl) 
--    self._tl:gotoFrameAndPlay(0,false) 

    dxyExtendEvent(self)

    self._scene = GodGeneralConfig:getGeneralScene()

--res
    local _ndStage = self._csb:getChildByName("nd_stage")
    self._txtPhy = _ndStage:getChildByName("physical"):getChildByName("txtPhy")
    self._Golden = _ndStage:getChildByName("yellow"):getChildByName("txt_yellow")
    self._Blue = _ndStage:getChildByName("blue"):getChildByName("txt_blue")

    local btnPhy = _ndStage:getChildByName("physical"):getChildByName("btnPhy")
    btnPhy:addTouchEventListener(function(target,type)
        if type == 2 then
            SoundsFunc_playSounds(SoundsType.UNIVERSAL_BTN,false)
            zzc.PhysicalTipsController:showGodLayer()
        end
    end)
    
    --new
    self._nodeSprite = _ndStage:getChildByName("ndSprite")
    self._ndSprite = self._nodeSprite:getChildByName("ndSprite")
    self._txtName = self._nodeSprite:getChildByName("txtName")
    if _G.GeneralData.Current == 0 then
        self._nodeSprite:setVisible(false)
    end
    
    local ndStar = self._nodeSprite:getChildByName("nd_star")
    for i=1,5 do
        self._arrStar[i] = ndStar:getChildByName("bg"..i):getChildByName("star")
    end
    
    local btnRest = self._nodeSprite:getChildByName("btnRest")
    btnRest:addTouchEventListener(function(target,type)
        if type == 2 then
            SoundsFunc_playSounds(SoundsType.UNIVERSAL_BTN,false)
            zzc.GeneralController:putDownGeneral()
        end
    end)
    for i=1, 2 do
        self._arrSkill[i] = self._nodeSprite:getChildByName("bgSkill"..i):getChildByName("btnSkill")
    end
    
    local ndupPro = self._csb:getChildByName("nd_upPro")
    local before = ndupPro:getChildByName("ndBefore")
    self._beforeAth = before:getChildByName("beforeAtk")
    self._beforeDef = before:getChildByName("beforeDef")
    self._beforeHp = before:getChildByName("beforeHp")
    
    
    local _ndMsg = self._csb:getChildByName("bg7")
    self._atk = _ndMsg:getChildByName("txt_atk")
    self._def = _ndMsg:getChildByName("txt_def")
    self._hp = _ndMsg:getChildByName("txt_hp")
    
    local _ndMsg_0 = self._csb:getChildByName("bg7_0")
    self._txtAtk = _ndMsg_0:getChildByName("txt_atk")
    self._txtDef = _ndMsg_0:getChildByName("txt_def")
    self._txtHp = _ndMsg_0:getChildByName("txt_hp")
--    self:updateStage(_G.GeneralData.Current)
    
    local _ndUpGrade = self._csb:getChildByName("nd_upgrade")
    self._txtLv = _ndUpGrade:getChildByName("txt_lv")
    local exp = _ndUpGrade:getChildByName("exp")
    self._lbExp = exp:getChildByName("lb_exp")
    self._txtExp = exp:getChildByName("txt_exp")
    
    --吸魂
    self._btnAddSoul = _ndUpGrade:getChildByName("btn_addSoul")
    local Text = _ndUpGrade:getChildByName("Text")
    self._txtSoul = Text:getChildByName("txtNB")
    self._txtGold = Text:getChildByName("txtGD")

    self._btnAddSoul:addTouchEventListener(function(target,type)
        if type == 2 then
            zzc.GeneralController:AddSoul()
            SoundsFunc_playSounds(SoundsType.ADD_SOUL,false)
        end
    end)
    
    
    --ndBox    
    local ndBox = self._csb:getChildByName("nd_box")
    self._SV = ndBox:getChildByName("ScrollView")
    self._SV:setScrollBarEnabled(false)
--    local width = self._SV:getContentSize().width
--    local svHeight = ROW * HEIGHT
--    self._SV:setInnerContainerSize(cc.size(width,svHeight))
--    local posx = 0
--    local posy = 0
--    local count = 0
--    for i=1,12 do --列
--        posy = (i-1) * HEIGHT + 50
--        for j=1,4 do --行
--            posx = (j-1) * WIDTH + 50
--            require "src.game.general.view.ItemBox"
--            count = count + 1
--            local data = {[1]=self._SV,[2]=posx,[3]=svHeight-posy,[4]=count}
--            self._arrBoxItem[count] = ItemBox:create(data)
--            self._arrBoxItem[count]:upDate(zzm.GeneralModel.Fragment[count])
--            self._SV:addChild(self._arrBoxItem[count],1)
--            self._arrBoxItem[count]:setPosition(posx,svHeight - posy)
--        end
--    end

--    local btnConvert = ndBox:getChildByName("btn_convert")
--    local btnDestroy = ndBox:getChildByName("btn_destroy")
--    btnConvert:addTouchEventListener(function(target,type)
--        if type == 2 then
--            SoundsFunc_playSounds(SoundsType.OPEN_PAGE,false)
--            require "src.game.general.view.FragmentShop"
--            local shop = FragmentShop:create()
--            self:addChild(shop)
--        end
--    end)
--    btnDestroy:addTouchEventListener(function(target,type)
--        if type == 2 then
--            SoundsFunc_playSounds(SoundsType.OPEN_PAGE,false)
--            require "src.game.general.view.DestroyMore"
--            local more = DestroyMore:create(1)
--            self:addChild(more)
--        end
--    end)
    
    
    self:StageRes()
    self:updateAddSoul()
--    self:GNCopyUD()
    self:updateFS()
    self:upDateVisibleRes(_G.GeneralData.Current)



    --sprite
--    self._sprite = _ndStage:getChildByName("ndSprite")
--    self._ndModel = self._sprite:getChildByName("ndModel")
--    self._bgSp = self._sprite:getChildByName("Image")
----    self._txtName = self._sprite:getChildByName("txtName")
--    self._txtDff = self._sprite:getChildByName("txtDff")

--    --btnChange
--    local btnChange = _ndStage:getChildByName("btn_change")
--    self._txtSur = btnChange:getChildByName("txt_sur")
--    btnChange:addTouchEventListener(function(target,type)
--        if type == 2 then
--            SoundsFunc_playSounds(SoundsType.UNIVERSAL_BTN,false)
--            zzc.GeneralController:UpDateCopy()
--        end
--    end)
--
--    self._Text = btnChange:getChildByName("Text")
--    self._txtRmb = self._Text:getChildByName("txtRmb")
--    --挑战
--    local btnFight = _ndStage:getChildByName("btn_fight")
--    btnFight:addTouchEventListener(function(target,type)
--        if type == 2 then
--            SoundsFunc_playSounds(SoundsType.UNIVERSAL_BTN,false)
--            if self._role:getValueByType(self._enCAT.GNCOPYCN) >= self._need then
--                self._ndModel:removeAllChildren()
--                self._action = nil
--                dxyDispatcher_dispatchEvent("removeModle")
--                self:enterGeneralCopy(self._GNCopyDFC)
--            else
--                dxyFloatMsg:show("体力不足")
--            end
--        end
--    end)
--    self._txtCN = btnFight:getChildByName("txtCN")
--


    --经验条
--    local _ndUpGrade = self._csb:getChildByName("nd_upgrade")
--    self._txtLv = _ndUpGrade:getChildByName("txt_lv")
--    local exp = _ndUpGrade:getChildByName("exp")
--    self._lbExp = exp:getChildByName("lb_exp")
--    self._txtExp = exp:getChildByName("txt_exp")

    --吸魂
--    self._btnAddSoul = _ndUpGrade:getChildByName("btn_addSoul")
--    local Text = _ndUpGrade:getChildByName("Text")
--    self._txtSoul = Text:getChildByName("txtNB")
--    self._txtGold = Text:getChildByName("txtGD")
--
--    self._btnAddSoul:addTouchEventListener(function(target,type)
--        if type == 2 then
--            zzc.GeneralController:AddSoul()
--            SoundsFunc_playSounds(SoundsType.ADD_SOUL,false)
--        end
--    end)

    
--    self._afterAtk = after:getChildByName("afterAtk")
--    self._afterDef = after:getChildByName("afterDef")
--    self._afterHp = after:getChildByName("afterHp")

    
end

function GeneralStage:initEvent()
    dxyDispatcher_addEventListener(dxyEventType.Character_AttrUpdate,self,self.StageRes)
    dxyDispatcher_addEventListener("updateAddSoul",self,self.updateAddSoul)
--    dxyDispatcher_addEventListener("GNCopyUD",self,self.GNCopyUD)
    
    dxyDispatcher_addEventListener("GeneralFS_updateFS",self,self.updateFS)
    dxyDispatcher_addEventListener("updateStage",self,self.upDateVisibleRes)
    dxyDispatcher_addEventListener("GeneralFS_ComputePro",self,self.ComputePro)
    
--    dxyDispatcher_addEventListener("addFragment",self,self.addFragment)
--    dxyDispatcher_addEventListener("delFragment",self,self.delFragment)
--    dxyDispatcher_addEventListener("changeFragment",self,self.changeFragment)
end

function GeneralStage:removeEvent()
    dxyDispatcher_removeEventListener(dxyEventType.Character_AttrUpdate,self,self.StageRes)
    dxyDispatcher_removeEventListener("updateAddSoul",self,self.updateAddSoul)
--    dxyDispatcher_removeEventListener("GNCopyUD",self,self.GNCopyUD)
    
    dxyDispatcher_removeEventListener("GeneralFS_updateFS",self,self.updateFS)
    dxyDispatcher_removeEventListener("updateStage",self,self.upDateVisibleRes)
    dxyDispatcher_removeEventListener("GeneralFS_ComputePro",self,self.ComputePro)
    
--    dxyDispatcher_removeEventListener("addFragment",self,self.addFragment)
--    dxyDispatcher_removeEventListener("delFragment",self,self.delFragment)
--    dxyDispatcher_removeEventListener("changeFragment",self,self.changeFragment)
end

function GeneralStage:StageRes()
    local role = zzm.CharacterModel:getCharacterData()
    local enCAT = enCharacterAttrType
    self._Golden:setString(cn:convert(role:getValueByType(enCAT.ENERGYSOUL)))
    self._Blue:setString(cn:convert(role:getValueByType(enCAT.SOUL)))
    self._txtPhy:setString(role:getValueByType(enCAT.GNCOPYCN).."/"..PhysicalConfig:getBaseValue().Limit)
end

function GeneralStage:updateAddSoul()
    if not self._isFirst then
        if not self._tl:isPlaying() then
            self._tl:gotoFrameAndPlay(0,false)
        end
    end 
    self._isFirst = false

    local pro = GodGeneralConfig:getUpGradeNeed(_G.GeneralData.Lv)
    local upPro = GodGeneralConfig:getProByLv(_G.GeneralData.Lv+1)
    self._txtLv:setString("LV:".._G.GeneralData.Lv)
    if _G.GeneralData.Lv >= GodGeneralConfig:getStageLvMax() then
        _G.GeneralData.Exp = pro["Exp"]
    end
    self._lbExp:setPercent(_G.GeneralData.Exp/pro["Exp"]*100)
    self._txtExp:setString(_G.GeneralData.Exp.."/"..pro["Exp"])
    self._txtSoul:setString(pro["MuhonConsume"])
    self._txtGold:setString(pro["GoldConsume"])

    self._beforeAth:setString(_G.GeneralData.Atk)
    self._beforeDef:setString(_G.GeneralData.Def)
    self._beforeHp:setString(_G.GeneralData.Hp)
--    self._afterAtk:setString(upPro.Atk)
--    self._afterDef:setString(upPro.Def)
--    self._afterHp:setString(upPro.Hp)

    local data = zzm.GeneralModel.General
    if data then
        if _G.GeneralData.Current ~= 0 then
            self._atk:setString(data.allAtk)
            self._def:setString(data.allDef)
            self._hp:setString(data.allHp)
        else
            self._atk:setString(0)
            self._def:setString(0)
            self._hp:setString(0)
        end
    else
        self._atk:setString(0)
        self._def:setString(0)
        self._hp:setString(0)
    
    end
--    self._atk:setString(data["Atk"])
--    self._def:setString(data["Def"])
--    self._hp:setString(data["Hp"])
    
    local strTitle = "吸魂"..self._btnTitle[GodGeneralConfig:getStateBtnChange(_G.GeneralData.Lv)].."次"
    self._btnAddSoul:setTitleText(strTitle)
end

--function GeneralStage:GNCopyUD()
--    self._role = zzm.CharacterModel:getCharacterData()
--    self._enCAT = enCharacterAttrType
--    local Ud = self._role:getValueByType(self._enCAT.GNCOPYUD)
--    if Ud == 0 then --更新扣元宝
--        self._Text:setVisible(true)
--        self._txtSur:setVisible(false)
--        self._txtRmb:setString(GodGeneralSceneConfig:getCopyValue().Rmb)
--    else
--        self._Text:setVisible(false)
--        self._txtSur:setVisible(true)
--        self._txtSur:setString("剩余"..Ud.."次")
--    end
--    self._need = GodGeneralConfig:getPowerNeed()--挑战扣体力
--    self._txtCN:setString(self._need)
--
--    self._GNCopyDFC = nil
--    self._GNCopyMST = nil
--    if zzm.GeneralModel._GNCopyDFC and zzm.GeneralModel._GNCopyMST then
--        self._GNCopyDFC = zzm.GeneralModel._GNCopyDFC
--        self._GNCopyMST = zzm.GeneralModel._GNCopyMST
--    else
--        self._GNCopyDFC = self._role:getValueByType(self._enCAT.GNCOPYDFC)
--        self._GNCopyMST = self._role:getValueByType(self._enCAT.GNCOPYMST)
--    end
--    self:upDateVisibleRes(_G.GeneralData.Current)
--    dxyWaitBack:close()
--end

function GeneralStage:upDateVisibleRes(id)
--    local dfc = GodGeneralSceneConfig:getCopyDifficulty(self._GNCopyDFC)
--    local mst = GodGeneralSceneConfig:getCopyMonster(dfc,self._GNCopyMST)
--new
--    local id = _G.GeneralData.Current
--    local name = GodGeneralConfig:getNameByGID(id)
--    self._txtName:setString(name)
    
--    self._txtName:setString(mst.Name)
    
--    
    
    if id ~= 0 then
        
        local name = GodGeneralConfig:getNameByGID(id)
        self._txtName:setString(name)
        
        local config = GodGeneralConfig:getGeneralData(id,1)
        for i=1,2 do
            self._arrSkill[i]:loadTextureNormal("res/GodGeneralsIcon/"..config["Icon"..i])
            self._arrSkill[i]:loadTexturePressed("res/GodGeneralsIcon/"..config["Icon"..i])
        end
        
        self._nodeSprite:setVisible(true)
        
        local Ossature = GodGeneralConfig:getGeneralModel(id,1)
        self._ndSprite:removeAllChildren()
        self._action = nil
        self._action = mc.SkeletonDataCash:getInstance():createWithCashName(Ossature)
        self._action:setAnimation(1,"ready", true)
        self._action:setAnchorPoint(0.5,0)
        self._action:setPosition(0,0)
        local scale = GodGeneralConfig:getGeneralData(id,1).Scale/100
        self._action:setScale(scale)
        self._ndSprite:addChild(self._action)
        
        for i=1,5 do
            self._arrStar[i]:setVisible(false)
        end
        local data = zzm.GeneralModel:getGeneralPro(id)
        local star = data["Star"]
        for i=1,star do
            self._arrStar[i]:setVisible(true)
        end
        local allData = zzm.GeneralModel.General
        if allData then
            if _G.GeneralData.Current ~= 0 then
                self._atk:setString(allData.allAtk)
                self._def:setString(allData.allDef)
                self._hp:setString(allData.allHp)
            else
                self._atk:setString(0)
                self._def:setString(0)
                self._hp:setString(0)
            end
        else
            self._atk:setString(0)
            self._def:setString(0)
            self._hp:setString(0)

        end
    else
        self._ndSprite:removeAllChildren()
        self._action = nil
        self._nodeSprite:setVisible(false)
        self._atk:setString(0)
        self._def:setString(0)
        self._hp:setString(0)
    end
    
--    local Ossature = GodGeneralConfig:getGeneralModel(id,1)
--    self._ndSprite:removeAllChildren()
--    self._action = nil
--    self._action = mc.SkeletonDataCash:getInstance():createWithCashName(Ossature)
--    self._action:setAnimation(1,"ready", true)
--    self._action:setAnchorPoint(0.5,0)
--    self._action:setPosition(0,0)
--    local scale = GodGeneralConfig:getGeneralData(id,1).Scale/100
--    self._action:setScale(scale)
--    self._ndSprite:addChild(self._action)
--    self._txtDff:setString(zzd.GodGeneralData[dfc.Difficulty])

--    if self._action then
--        self._ndModel:removeAllChildren()
--    end
--    local Ossature = GodGeneralConfig:getSceneModel(mst.Icon)
--    self._action = mc.SkeletonDataCash:getInstance():createWithCashName(Ossature)
--    self._action:setAnimation(1,"ready", true)
--    self._action:setAnchorPoint(0.5,0)
--    self._action:setPosition(0,0)
--    self._ndModel:addChild(self._action)

    ---drop
--    for j=1,6 do
--        self._arrDrop[j]:setVisible(false)
--    end
--    local dropList = dfc.SceneDrop.DropPreview
--    for i=1,#dropList do
--        local goods = GoodsConfigProvider:findGoodsById(dropList[i].Id)
--        self._arrDrop[i]:loadTextureNormal("GodGeneralsIcon/"..goods.Icon..".png")
--        self._arrDrop[i]:loadTexturePressed("GodGeneralsIcon/"..goods.Icon..".png")
--        self._arrDrop[i]:setVisible(true)
--    end

end

function GeneralStage:ComputePro()
    local data = zzm.GeneralModel.General
    if data then
        if _G.GeneralData.Current ~= 0 then
            self._atk:setString(data.allAtk)
            self._def:setString(data.allDef)
            self._hp:setString(data.allHp)
        else
            self._atk:setString(0)
            self._def:setString(0)
            self._hp:setString(0)
        end
    else
        self._atk:setString(0)
        self._def:setString(0)
        self._hp:setString(0)

    end
--    self._txtAtk:setString(data.useAtk)
--    self._txtDef:setString(data.useDef)
--    self._txtHp:setString(data.useHp)  
end

function GeneralStage:updateFS()
    self._SV:removeAllChildren()
    local dataAtt = zzm.GeneralModel.General
    self._txtAtk:setString(dataAtt.useAtk)
    self._txtDef:setString(dataAtt.useDef)
    self._txtHp:setString(dataAtt.useHp)  
    local NUM = GodGeneralConfig:getBoxNum()
    local row = NUM / LIST
    
    local conSize = self._SV:getContentSize()
    local real = row * HEIGHT
    local last = conSize.height > real and conSize.height or real
    self._SV:setInnerContainerSize(cc.size(conSize.width,last))
    local posx = 0
    local posy = 0
    local count = 0
    for i=1,row do --列
        posy = (i-1) * HEIGHT + 50
        for j=1,LIST do --行
            posx = (j-1) * WIDTH + 50
            count = count + 1
            require "src.game.general.view.ItemCard"
            local config = nil
            if zzm.GeneralModel.ALLGENERAL[1] then
                config = zzm.GeneralModel.ALLGENERAL[count]
                print("zzm.GeneralModel.ALLGENERAL*****************************************")
            else
                config = GodGeneralConfig:getGeneralByKey(count)
                print("GodGeneralConfig:getGeneralByKey*****************************************")
            end
            local data = {[1]=self._SV,[2]=posx,[3]=last-posy,[4]=config,[5]=count}
            local item = ItemCard:create(data)
            self._SV:addChild(item,1)
            item:setPosition(posx,last - posy)
        end
    end
end

--function GeneralStage:addFragment(data)
--    for i,target in pairs(self._arrBoxItem) do
--        if target._data == nil then
--            target:upDate(data)
--            break
--        end
--    end
--end
--
--function GeneralStage:delFragment(id)
--    for i,target in pairs(self._arrBoxItem) do
--        if target._data and target._data.Id == id then
--            target:upDate()
--            break
--        end
--    end
--end
--
--function GeneralStage:changeFragment(data)
--    for i,target in pairs(self._arrBoxItem) do
--        if target._data and data["Id"] == target._data["Id"] then
--            target:upDate(data)
--            break
--        end
--    end
--end

--按照难度进入神将挑战副本
function GeneralStage:enterGeneralCopy(difficulty)
    zzc.LoadingController:setCopyData({copyType = DefineConst.CONST_COPY_TYPE_GODWILL,chapterID = difficulty, startTalkID = 0, endTalkID = 0,
        sceneID = GodGeneralSceneConfig:getSceneIdByDifficulty(difficulty), param1 = 0})
    zzc.LoadingController:enterScene(SceneType.LoadingScene)
    zzc.LoadingController:setDelegate2({target = self,func = function (data) zzc.LoadingController:enterScene(SceneType.CopyScene) end,data = self.m_data})
end
