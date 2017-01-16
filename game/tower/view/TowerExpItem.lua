TowerExpItem = TowerExpItem or class("TowerExpItem",function()
    local path = "dxyCocosStudio/png/tower/item.png"
    return ccui.Button:create(path,path,path)
end)

function TowerExpItem:create()
    local node = TowerExpItem:new()
    return node
end

function TowerExpItem:ctor()
	self._csb = nil
	
	self:initUI()
	self:initEvent()
end

function TowerExpItem:initUI()
	self._csb = cc.CSLoader:createNode("dxyCocosStudio/csd/ui/tower/TowerExpItem.csb")
	self:addChild(self._csb)
	
    local x = self:getContentSize().width / 2
    local y = self:getContentSize().height / 2 

    self._csb:setPosition(cc.p(x,y))
    
    self.unlockNode = self._csb:getChildByName("unlockNode")
    self.unlock_layerCount = self.unlockNode:getChildByName("layerCount")
    self.btn_challenge = self.unlockNode:getChildByName("challengeBtn")
    
    self.lockNode = self._csb:getChildByName("lockNode")
    self.lock_layerCount = self.lockNode:getChildByName("layerCount")
    self.txt_unlock = self.lockNode:getChildByName("unlockTxt")
	
end

function TowerExpItem:update(data)
	self.m_data = data
	
    local role = zzm.CharacterModel:getCharacterData()
    local enCAT = enCharacterAttrType
    local lv = role:getValueByType(enCAT.LV)
    
    if lv >= self.m_data.DeblockingLV then
    	self.unlockNode:setVisible(true)
    	self.unlock_layerCount:setString(self.m_data.Name)
    	self.lockNode:setVisible(false)
    else
        self.unlockNode:setVisible(false)
        self.lockNode:setVisible(true)
        self.lock_layerCount:setString(self.m_data.Name)
        self.txt_unlock:setString(self.m_data.DeblockingLV.."级解锁")
    end
end

function TowerExpItem:initEvent()
    self.btn_challenge:addTouchEventListener(function(target,type)
        if type == 2 then
            SoundsFunc_playSounds(SoundsType.UNIVERSAL_BTN,false)
            local role = zzm.CharacterModel:getCharacterData()
            local enCAT = enCharacterAttrType
            local expCount = role:getValueByType(enCAT.TRAINEXPCOUNT)
            if expCount <= 0 then
            	dxyFloatMsg:show("次数不足")
            	return
            end
            zzm.TowerModel.expId = self.m_data.Id
            zzc.LoadingController:setCopyData({copyType = DefineConst.CONST_COPY_TYPE_TRAIN_EXP,chapterID = self.m_data.Id, startTalkID = 0, endTalkID = 0, sceneID = TowerConfig:getDataByType(TowerType.EXP).ScenesId, param1 = 0})
            zzc.TowerController:closeLayer()
            zzm.TalkingDataModel:onBegin(TowerConfig:getDataByType(TowerType.EXP).ScenesId.."_"..zzm.TowerModel.expId)
            zzc.LoadingController:enterScene(SceneType.LoadingScene)
            zzc.LoadingController:setDelegate2(
                {target = self, 
                    func = function (data)
                        zzc.LoadingController:enterScene(SceneType.CopyScene)
                    end,
                    data = nil})
        end
    end)
end