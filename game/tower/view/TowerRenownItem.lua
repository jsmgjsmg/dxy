TowerRenownItem = TowerRenownItem or class("TowerRenownItem",function()
    local path = "dxyCocosStudio/png/tower/item.png"
    return ccui.Button:create(path,path,path)
end)

function TowerRenownItem:create()
    local node = TowerRenownItem:new()
    return node
end

function TowerRenownItem:ctor()
	self._csb = nil
	
	self:initUI()
	self:initEvent()
end

function TowerRenownItem:initUI()
    self._csb = cc.CSLoader:createNode("dxyCocosStudio/csd/ui/tower/TowerRenownItem.csb")
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

function TowerRenownItem:update(data)
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

function TowerRenownItem:initEvent()
    self.btn_challenge:addTouchEventListener(function(target,type)
        if type == 2 then  
            SoundsFunc_playSounds(SoundsType.UNIVERSAL_BTN,false)
            local role = zzm.CharacterModel:getCharacterData()
            local enCAT = enCharacterAttrType
            local renownCount = role:getValueByType(enCAT.TRAINRENOWNCOUNT)
            if renownCount <= 0 then
                dxyFloatMsg:show("次数不足")
                return
            end
            zzm.TowerModel.renownId = self.m_data.Id
            zzc.LoadingController:setCopyData({copyType = DefineConst.CONST_COPY_TYPE_TRAIN_RENOWN,chapterID = self.m_data.Id, startTalkID = 0, endTalkID = 0, sceneID = TowerConfig:getDataByType(TowerType.RENOWN).ScenesId, param1 = 0})
            zzc.TowerController:closeLayer()
            zzm.TalkingDataModel:onBegin(TowerConfig:getDataByType(TowerType.RENOWN).ScenesId.."_"..zzm.TowerModel.renownId)
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