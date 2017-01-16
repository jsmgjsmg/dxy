
CopyDetails = CopyDetails or class("CopyDetails",function()
    return cc.Layer:create()
end)

function CopyDetails.create()
    local layer = CopyDetails.new()
    return layer
end

function CopyDetails:ctor()
    self.winSize = cc.Director:getInstance():getVisibleSize()
    self._csbNode = nil
    self:initUI()
    self:initEvent()
end

function CopyDetails:initUI()
    self._csbNode = cc.CSLoader:getInstance():createNodeWithFlatBuffersFile("dxyCocosStudio/csd/ui/copy/CopyDetails.csb")
    self:addChild(self._csbNode)
    local csbSize = self._csbNode:getContentSize()
    local rowGap = (self.winSize.width - csbSize.width) / 2
    local listGap = (self.winSize.height - csbSize.height) / 2
    self._csbNode:setPosition(rowGap,listGap)

    local node = self._csbNode:getChildByName("Panel")
    self.btn_back = node:getChildByName("Back")
    self.btn_fight = node:getChildByName("Fight")
    --self.btn_fight_0 = node:getChildByName("Fight_0")
    self.physicalIcon = self.btn_fight:getChildByName("Physical")
    self.rewardPhysical = self.physicalIcon:getChildByName("Text")
    
    self.ripeningNode = node:getChildByName("ripeningNode")
    self.btn_fight_r = self.ripeningNode:getChildByName("Fight")
    self.physicalIcon_r = self.btn_fight_r:getChildByName("Physical")
    self.rewardPhysical_r = self.physicalIcon_r:getChildByName("Text")
    self.btn_ripening = self.ripeningNode:getChildByName("ripeningBtn")
    self.ripeningNode:setVisible(false)
    
    self.eliteRipeningNode = node:getChildByName("eliteRipeningNode")
    self.btn_fight_e = self.eliteRipeningNode:getChildByName("Fight")
    self.physicalIcon_e = self.btn_fight_e:getChildByName("Physical")
    self.rewardPhysical_e = self.physicalIcon_e:getChildByName("Text")
    self.btn_eliteRipening = self.eliteRipeningNode:getChildByName("ripeningBtn")
    self.ckb_auto = self.eliteRipeningNode:getChildByName("autoCkb")
    self.eliteRipeningNode:setVisible(false)
    self.isAutoRipening = self.ckb_auto:isSelected()
    
    local nameNode = node:getChildByName("TitleBG")
    self.copyName = nameNode:getChildByName("Name")
    
    local startNode = node:getChildByName("Start")
    self.startList = {}
    for index=1, 3 do
        self.startList[index] = startNode:getChildByName("start_" .. index):getChildByName("start")
    end
    self.btn_help = startNode:getChildByName("Condition")
    
    local rewardNode = startNode:getChildByName("Reward")
    self.expIcon = rewardNode:getChildByName("Exp")
    self.rewardExp = self.expIcon:getChildByName("Text")
    self.rewardGold = rewardNode:getChildByName("Gold"):getChildByName("Text")
    

    self.renownIcon =rewardNode:getChildByName("Renown")
    self.rewardRenown = self.renownIcon:getChildByName("Text")
    self.firstReward = rewardNode:getChildByName("firstReward")

    require "src.game.equip.view.EquipItem"
    local goodsNode = rewardNode:getChildByName("Drop")
    self.goodsList = {}
    for index=1, 3 do
        local goods = goodsNode:getChildByName("Goods" .. index)
        local item = EquipItem:create()
        item:setTouchEnabled(false)
        --item:retain()
        goods:addChild(item)
        self.goodsList[index] = item        
    end
    
    
    local appraiseNode = node:getChildByName("AppraisePanel")
    self.appraise_1 = appraiseNode:getChildByName("Appraise_1")
    self.appraise_2 = appraiseNode:getChildByName("Appraise_2")
    self.appraise_3 = appraiseNode:getChildByName("Appraise_3")
end


function CopyDetails:initEvent()
    if(self.btn_back)then
        self.btn_back:addTouchEventListener(function(target,type)
            if(type==2)then
                SoundsFunc_playSounds(SoundsType.CLOSE_PAGE,false)
                zzc.CopySelectController:closeCopyDetails()
            end
        end)
    end
    
--   
    if(self.btn_fight)then
        self.btn_fight:addTouchEventListener(function(target,type)
            if(type==2)then
                SoundsFunc_playSounds(SoundsType.UNIVERSAL_BTN,false)
                local role = zzm.CharacterModel:getCharacterData()
                local enCAT = enCharacterAttrType
                local ph = role:getValueByType(enCAT.PHYSICAL)
                if self.m_data.config.Type == 2 then
                    if  ph < self.physical  then
                        dxyFloatMsg:show("元力不足")
                        return
                    end
                else
                    if  ph < 1  then
                        dxyFloatMsg:show("元力不足")
                        return
                    end
                    
                    if zzm.CharacterModel:backPackRemainSpace() <= 0  then
                        dxyFloatMsg:show("背包已满")
                        return
                    end
                end
                
            
                zzm.CopySelectModel.curCopyData = self.m_data
                zzm.TalkingDataModel:onBegin(zzm.CopySelectModel.curCopyData.config.Id)
                zzc.LoadingController:setCopyData({startId = self.m_data.config.StarId, copyType = self.m_data.config.Type, chapterID = self.m_data.chpaterID, startTalkID = self.m_data.startTalkID, endTalkID = self.m_data.endTalkID, sceneID = self.m_data.config.Id, param1 = 0})
                zzc.LoadingController:enterScene(SceneType.LoadingScene)
                zzc.LoadingController:setDelegate2(
                {target = self, 
                func = function (data)
                            --zzc.LoadingController:setCopyData({chapterID = self.m_data.chpaterID, startTalkID = self.m_data.startTalkID, endTalkID = self.m_data.endTalkID, sceneID = self.m_data.config.Id})
                    zzc.LoadingController:enterScene(SceneType.CopyScene)
                end,
                data = self.m_data})
                zzc.CopySelectController:closeCopyDetails()
                zzc.CopySelectController:closeLayer()
            end
        end)
    end
    
    if(self.btn_fight_r)then
        self.btn_fight_r:addTouchEventListener(function(target,type)
            if(type==2)then
                SoundsFunc_playSounds(SoundsType.UNIVERSAL_BTN,false)
                local role = zzm.CharacterModel:getCharacterData()
                local enCAT = enCharacterAttrType
                local ph = role:getValueByType(enCAT.PHYSICAL)
                if self.m_data.config.Type == 2 then
                    if  ph < self.physical  then
                        dxyFloatMsg:show("元力不足")
                        return
                    end
                else
                    if  ph < 1  then
                        dxyFloatMsg:show("元力不足")
                        return
                    end
                    
                    if zzm.CharacterModel:backPackRemainSpace() <= 0  then
                        dxyFloatMsg:show("背包已满")
                        return
                    end
                    
                end

                zzm.CopySelectModel.curCopyData = self.m_data
                zzm.TalkingDataModel:onBegin(zzm.CopySelectModel.curCopyData.config.Id)
                zzc.LoadingController:setCopyData({startId = self.m_data.config.StarId, copyType = self.m_data.config.Type, chapterID = self.m_data.chpaterID, startTalkID = self.m_data.startTalkID, endTalkID = self.m_data.endTalkID, sceneID = self.m_data.config.Id, param1 = 0})
                zzc.LoadingController:enterScene(SceneType.LoadingScene)
                zzc.LoadingController:setDelegate2(
                    {target = self, 
                        func = function (data)
                            --zzc.LoadingController:setCopyData({chapterID = self.m_data.chpaterID, startTalkID = self.m_data.startTalkID, endTalkID = self.m_data.endTalkID, sceneID = self.m_data.config.Id})
                            zzc.LoadingController:enterScene(SceneType.CopyScene)
                        end,
                        data = self.m_data})
                zzc.CopySelectController:closeCopyDetails()
                zzc.CopySelectController:closeLayer()
                SoundsFunc_playSounds(SoundsType.UNIVERSAL_BTN,false)
            end
        end)
    end
    
    if self.btn_ripening then
    	self.btn_ripening:addTouchEventListener(function(target,type)
    	   if type == 2 then
                SoundsFunc_playSounds(SoundsType.UNIVERSAL_BTN,false)
    	       require("game.sweep.view.SweepSetRipeningNum")
    	       local layer = SweepSetRipeningNum:create()
               layer:update(self.m_data.id)
               SceneManager:getCurrentScene():addChild(layer)
    	   end
    	end)
    end
    
    if(self.btn_fight_e)then
        self.btn_fight_e:addTouchEventListener(function(target,type)
            if(type==2)then
                SoundsFunc_playSounds(SoundsType.UNIVERSAL_BTN,false)
                local role = zzm.CharacterModel:getCharacterData()
                local enCAT = enCharacterAttrType
                local ph = role:getValueByType(enCAT.PHYSICAL)
                if self.m_data.config.Type == 2 then
                    if  ph < self.physical  then
                        dxyFloatMsg:show("元力不足")
                        return
                    end
                else
                    if  ph < 1  then
                        dxyFloatMsg:show("元力不足")
                        return
                    end

                    if zzm.CharacterModel:backPackRemainSpace() <= 0  then
                        dxyFloatMsg:show("背包已满")
                        return
                    end

                end

                zzm.CopySelectModel.curCopyData = self.m_data
                zzm.TalkingDataModel:onBegin(zzm.CopySelectModel.curCopyData.config.Id)
                zzc.LoadingController:setCopyData({startId = self.m_data.config.StarId, copyType = self.m_data.config.Type, chapterID = self.m_data.chpaterID, startTalkID = self.m_data.startTalkID, endTalkID = self.m_data.endTalkID, sceneID = self.m_data.config.Id, param1 = 0})
                zzc.LoadingController:enterScene(SceneType.LoadingScene)
                zzc.LoadingController:setDelegate2(
                    {target = self, 
                        func = function (data)
                            --zzc.LoadingController:setCopyData({chapterID = self.m_data.chpaterID, startTalkID = self.m_data.startTalkID, endTalkID = self.m_data.endTalkID, sceneID = self.m_data.config.Id})
                            zzc.LoadingController:enterScene(SceneType.CopyScene)
                        end,
                        data = self.m_data})
                zzc.CopySelectController:closeCopyDetails()
                zzc.CopySelectController:closeLayer()
                SoundsFunc_playSounds(SoundsType.UNIVERSAL_BTN,false)
            end
        end)
    end
    
    if self.btn_eliteRipening then
        self.btn_eliteRipening:addTouchEventListener(function(target,type)
            if type == 2 then
                SoundsFunc_playSounds(SoundsType.UNIVERSAL_BTN,false)
                local role = zzm.CharacterModel:getCharacterData()
                local enCAT = enCharacterAttrType
                local ph = role:getValueByType(enCAT.PHYSICAL)
                local limit = math.floor(ph / 6)
                if limit <= 0 then
                	dxyFloatMsg:show("元力不足")
                	return
                end
                
                local function autoCallBack(target,type)
                	if type == 2 then
                        UIManager:closeUI("CustomTips")
                        zzc.SweepController:request_eliteSweep(self.m_data.id,limit)
                        zzm.SweepModel.eliteCopyId = self.m_data.id
                        zzc.CopySelectController:closeCopyDetails()
                	end
                end
                
                if self.isAutoRipening then
                    local layer = CustomTips:create()
                    layer:update("确定使用全部元力扫荡?",autoCallBack)
                else
                    zzc.SweepController:request_eliteSweep(self.m_data.id,1)
                    zzm.SweepModel.eliteCopyId = self.m_data.id
                    zzc.CopySelectController:closeCopyDetails()
                end
                zzm.SweepModel.eliteCopyId = self.m_data.id
            end
        end)
    end
    
    if self.ckb_auto then
        self.ckb_auto:addEventListener(function(target,type)
            if type == ccui.CheckBoxEventType.selected then
                SoundsFunc_playSounds(SoundsType.UNIVERSAL_BTN,false)
                self.isAutoRipening = true
            elseif type == ccui.CheckBoxEventType.unselected then
                SoundsFunc_playSounds(SoundsType.UNIVERSAL_BTN,false)
                self.isAutoRipening = false
            end
        end)
    end
    

    local bg = self._csbNode:getChildByName("bgPanel")
    -- 拦截
    dxySwallowTouches(self,bg)
end

function CopyDetails:update(data)
    self.m_data = data
    if not self.m_data then
    	return
    end
    
    local copy = self.m_data.config
    self.copyName:setString(copy.Name)
    
    --local expRatio = SceneConfigProvider:getExpRatio()
    local goldRatio = SceneConfigProvider:getGoldRatio()
    local reward = SceneConfigProvider:getCopyRewardById(copy.Id)
    
    self.rewardExp:setString(reward.FirstWinExp)
    self.rewardGold:setString(reward.WinGold)
    self.rewardRenown:setString(reward.WinRenown)
    self.physical=SceneConfigProvider:getPhysical()
    self.commonPhysical=SceneConfigProvider:getCommonPhysical()
    
    if copy.Type ==2 then --精英副本
        if self.m_data.start>0 then --非首通
            self.rewardGold:setString(math.ceil(reward.WinGold))
            self.rewardRenown:setString(math.ceil(reward.WinRenown))
            self.rewardExp:setString(math.ceil(reward.WinExp))
            self.firstReward:setVisible(false)
        else --首通
            self.rewardGold:setString(math.ceil(reward.WinGold+reward.WinGold*goldRatio/100))
            self.rewardRenown:setString(math.ceil(reward.WinRenown))
            self.rewardExp:setString(math.ceil(reward.FirstWinExp))
            
        end
        self.btn_fight:setTitleText("        战斗")
    	self.physicalIcon:setVisible(true)
        self.rewardPhysical:setString(math.ceil(self.physical))
        self.btn_fight_r:setTitleText("        战斗")
        self.physicalIcon_r:setVisible(true)
        self.rewardPhysical_r:setString(self.physical)
        self.btn_fight_e:setTitleText("        战斗")
        self.physicalIcon_e:setVisible(true)
        self.rewardPhysical_e:setString(self.physical)
        self.expIcon:setVisible(false)
        self.rewardExp:setVisible(false)
        
        if self.m_data.start == 3 then           
            self.eliteRipeningNode:setVisible(true)
            self.btn_fight:setVisible(false)
        end
        
    else --普通副本
        if self.m_data.start>0 then --非首通
            self.rewardGold:setString(math.ceil(reward.WinGold))
            self.rewardRenown:setString(math.ceil(reward.WinRenown))
            self.rewardExp:setString(math.ceil(reward.WinExp))
            self.firstReward:setVisible(false)
        else --首通
            self.rewardGold:setString(math.ceil(reward.WinGold+reward.WinGold*goldRatio/100))
            self.rewardRenown:setString(math.ceil(reward.WinRenown))
            self.rewardExp:setString(math.ceil(reward.FirstWinExp))
            --self.firstReward:setVisible(true)
        end
        self.btn_fight:setTitleText("        战斗")
        self.physicalIcon:setVisible(true)
        self.rewardPhysical:setString(self.commonPhysical)
        self.btn_fight_r:setTitleText("        战斗")
        self.physicalIcon_r:setVisible(true)
        self.rewardPhysical_r:setString(self.commonPhysical)
        self.renownIcon:setVisible(false)
        self.rewardRenown:setVisible(false)
        
        if self.m_data.start == 3 and self.m_data.config.LV >= 8 then       	
            self.ripeningNode:setVisible(true)
            self.btn_fight:setVisible(false)
        end
        
    end
   
    
    
    
    local appraise = SceneConfigProvider:getStartDataById(copy.StarId)
    self.appraise_1 : setString("1."..appraise[1].Info)
    self.appraise_2 : setString("2."..appraise[2].Info)
    self.appraise_3 : setString("3."..appraise[3].Info)
    
    for index=1, 3 do
        local config = nil
        if reward.Goods[index] ~= nil then
        	config = GoodsConfigProvider:findGoodsById(reward.Goods[index].ID)
        end
        self.goodsList[index]:updateConfig(config)
    end
    
    self:setStart(self.m_data.start)
end

function CopyDetails:setStart(count)
    if count < 0 then return end
    --self.startNode:setVisible(true)
    for index=1, 3 do
        self.startList[index]:setVisible(false)
    end
    for index=1, count do
        self.startList[index]:setVisible(true)
    end
end

