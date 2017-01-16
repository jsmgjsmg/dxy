
SpiritCopyItem = SpiritCopyItem or class("SpiritCopyItem",function()
    return cc.Node:create()
end)


function SpiritCopyItem.create()
    local node = SpiritCopyItem.new()
    return node
end

function SpiritCopyItem:ctor()
    self._csbNode = nil
    self:initUI()
    self:initEvent()
end

function SpiritCopyItem:initUI()
    self._csbNode = cc.CSLoader:createNode("dxyCocosStudio/csd/ui/spirit/SpiritCopyItem.csb")
    self:addChild(self._csbNode)

    self.copyIcon = self._csbNode:getChildByName("CopyIcon")
    self.copyZi = self._csbNode:getChildByName("CopyZi")
    --self.copyIcon:setTouchEnabled(false)
    --self.copyIcon:setBright(false)
end

function SpiritCopyItem:initEvent()
    local role = zzm.CharacterModel:getCharacterData()
    local enCAT = enCharacterAttrType
    local gold = role:getValueByType(enCAT.GOLD)
    local rmb = role:getValueByType(enCAT.RMB)
    self.needAddGold = gold < MagicSoulConfigProvider:getCopyNeedGold(zzm.SpiritModel.curSpiritLv,zzm.SpiritModel.curSpiritDifficulty)
    self.needAddRmb = rmb < MagicSoulConfigProvider:getCopyNeedRmb(zzm.SpiritModel.curSpiritLv,zzm.SpiritModel.curSpiritDifficulty)

    local role = zzm.CharacterModel:getCharacterData()
    local enCAT = enCharacterAttrType
    self.searchCount = role:getValueByType(enCAT.EXPLORE)

    if(self.copyIcon)then
        self.copyIcon:addTouchEventListener(function(target,type)
            if(type==2 and self.m_config)then
                --TipsFrame:create("暂时不能探索！")
                local role = zzm.CharacterModel:getCharacterData()
                local enCAT = enCharacterAttrType
                local searchCount = role:getValueByType(enCAT.EXPLORE)
                if searchCount <= 0 then
                    if self.needAddGold and zzm.SpiritModel.spirit_type == DefineConst.CONST_MAGICSOUL_COPY_TYPE_NORMAL then
                        dxyFloatMsg:show("铜钱不足!")
                        SoundsFunc_playSounds(SoundsType.FAILE_TO_USE,false)
                        return
                    end
                end
--                if self.needAddGold and zzm.SpiritModel.spirit_type == DefineConst.CONST_MAGICSOUL_COPY_TYPE_NORMAL then
--                    dxyFloatMsg:show("铜钱不足!")
--                    SoundsFunc_playSounds(SoundsType.FAILE_TO_USE,false)
--                    return
--                end
                
--                if self.needAddRmb and zzm.SpiritModel.spirit_type == DefineConst.CONST_MAGICSOUL_COPY_TYPE_FAST then
--                    dxyFloatMsg:show("元宝不足!")
--                    SoundsFunc_playSounds(SoundsType.FAILE_TO_USE,false)
--                    return
--                end
                if zzm.SpiritModel.searchCount > MagicSoulConfigProvider:getSearchCountMax() then
                    dxyFloatMsg:show("探索次数已达上限")
                    return
                end
                local function callBack(target,type)
                    if type == 2 then
                        SoundsFunc_playSounds(SoundsType.UNIVERSAL_BTN,false)
                        UIManager:closeUI("CustomTips")
                        zzm.TalkingDataModel:onBegin("ql_"..zzm.SpiritModel.curSpiritLvType.."_"..zzm.SpiritModel.curSpiritDifficulty)
                        _G.spiritRoomDifficulty = self.m_config.copydifficulty
                        zzc.LoadingController:setCopyData({copyType = DefineConst.CONST_COPY_TYPE_MAGICSOUL,chapterID = self.m_config.copy_id, startTalkID = 0, endTalkID = 0, sceneID = self.m_config.copy_id, param1 = 0})
                        zzc.SpiritController:closeLayer()
                        zzc.LoadingController:enterScene(SceneType.LoadingScene)
                        zzc.LoadingController:setDelegate2(
                            {target = self,
                                func = function (data)
                                    --zzc.LoadingController:setCopyData({chapterID = self.m_data.chpaterID, startTalkID = self.m_data.startTalkID, endTalkID = self.m_data.endTalkID, sceneID = self.m_data.config.Id})
                                    zzc.LoadingController:enterScene(SceneType.CopyScene)
                                end,data = self.m_data})
                    end
                end

--                if self.searchCount <= 0 and zzm.SpiritModel.spirit_type == DefineConst.CONST_MAGICSOUL_COPY_TYPE_NORMAL then
--                    local layer = CustomTips:create()
--                    local text = "是否花费铜钱"..MagicSoulConfigProvider:getCopyNeedGold(zzm.SpiritModel.curSpiritLv,zzm.SpiritModel.curSpiritDifficulty).."进入副本?"                   
--                    layer:update(text,callBack)
--                    return
--                end
                
                if zzm.SpiritModel.spirit_type == DefineConst.CONST_MAGICSOUL_COPY_TYPE_FAST then
                    local layer = CustomTips:create()
                    local text = "是否花费元宝"..MagicSoulConfigProvider:getCopyNeedRmb(zzm.SpiritModel.curSpiritLv,zzm.SpiritModel.curSpiritDifficulty).."进入副本?"                   
                    layer:update(text,callBack)
                    return
                end

                zzm.TalkingDataModel:onBegin("ql_"..zzm.SpiritModel.curSpiritLvType.."_"..zzm.SpiritModel.curSpiritDifficulty)
                _G.spiritRoomDifficulty = self.m_config.copydifficulty
                zzc.LoadingController:setCopyData({copyType = DefineConst.CONST_COPY_TYPE_MAGICSOUL,chapterID = self.m_config.copy_id, startTalkID = 0, endTalkID = 0, sceneID = self.m_config.copy_id, param1 = 0})
                zzc.SpiritController:closeLayer()
                zzc.LoadingController:enterScene(SceneType.LoadingScene)
                zzc.LoadingController:setDelegate2(
                    {target = self,
                        func = function (data)
                            --zzc.LoadingController:setCopyData({chapterID = self.m_data.chpaterID, startTalkID = self.m_data.startTalkID, endTalkID = self.m_data.endTalkID, sceneID = self.m_data.config.Id})
                            zzc.LoadingController:enterScene(SceneType.CopyScene)
                        end,data = self.m_data})
            end
            SoundsFunc_playSounds(SoundsType.UNIVERSAL_BTN,false)
        end)
    end
end



function SpiritCopyItem:setConfig(data)
    self.m_config = data
    if self.m_config == nil then
        return
    end
    print("init copy ID: " .. self.m_config.copy_id)
    --self:update(zzm.CopySelectModel:getCopyData(self.m_config.Id))

    --self.copyIcon:setTitleText(data.copy_id)
    --self:setPositionX(100*(math.random(1,6)-3))
    --self:setPositionY(100*(math.random(2,5)-3))

    if self.m_config.state == 0 then
        self.copyIcon:setBright(true)
        self.copyIcon:setTouchEnabled(true)
    elseif self.m_config.state == 1 then
        self.copyIcon:setBright(false)
        self.copyIcon:setTouchEnabled(false)
    end
    local path = "dxyCocosStudio/png/spirit/search/fam_"..self.m_config.idx..".png"
    self.copyZi:setTexture(path)

end

function SpiritCopyItem:update(diff)
    --    self.m_data = data
    --    if self.m_data == nil then --未开启不能进入
    --        return
    --    end
    --    self.m_data.config = self.m_config
    --    print("open copy ID: " .. self.m_config.Id)
    --    self.copyIcon:setTouchEnabled(false)
    --    self.copyIcon:setBright(false)
    self.diff = diff
    self.copyIcon:loadTextureNormal("dxyCocosStudio/png/spirit/search/lockIcon_"..self.diff..".png")
    self.copyIcon:loadTextureDisabled("dxyCocosStudio/png/spirit/search/unlockIcon_"..self.diff..".png")

end

function SpiritCopyItem:getItemHgight()
    return self.titleBG:getContentSize().height + self.itemPanel:getContentSize().height
end




