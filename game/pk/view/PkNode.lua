PkNode = PkNode or class("PkNode",function()
    return ccui.Layout:create()
end)
require("game.pk.view.PkItem")

function PkNode:ctor()
    self.visibleSize = cc.Director:getInstance():getVisibleSize()
    self.origin = cc.Director:getInstance():getVisibleOrigin()
    self.itemList = {}
end

function PkNode:create()
    local node = PkNode:new()
    node:init()
    return node
end

function PkNode:init()
    self._csb = cc.CSLoader:createNode("dxyCocosStudio/csd/ui/pk/PKNode.csb")
    self:addChild(self._csb)

    self._csb:setPosition(self.origin.x + self.visibleSize.width / 2, self.origin.y + self.visibleSize.height / 2)
    
    dxyExtendEvent(self)
    
    self:setClippingEnabled(true)
    
    local leftNode = self._csb:getChildByName("leftNode")
    self.txt_count = leftNode:getChildByName("countTxt")
    self.btn_ranking = leftNode:getChildByName("rankingBtn")
    self.btn_news = leftNode:getChildByName("newsBtn")
    self.btn_news:setTouchEnabled(false)
    self.btn_ranking:setPressedActionEnabled(true)
    self.btn_news:setPressedActionEnabled(true)
    self.btn_add = leftNode:getChildByName("addBtn")
    self.roleNode = leftNode:getChildByName("roleNode")
    self.pic_role = self.roleNode:getChildByName("rolePic")
    local nameBg = leftNode:getChildByName("nameBg")
    self.txt_name = nameBg:getChildByName("nameTxt")
    self.txt_lv = nameBg:getChildByName("lvTxt")
    self.txt_power = nameBg:getChildByName("powerTxt")
    self.txt_ranking = nameBg:getChildByName("rankingTxt")

    local rewardNode = leftNode:getChildByName("rewardNode")
    self.txt_gold = rewardNode:getChildByName("copperTxt")
    self.txt_rmb = rewardNode:getChildByName("goldTxt")
    self.txt_renown = rewardNode:getChildByName("renownTxt")

    local rightNode = self._csb:getChildByName("rightNode")
    self._panel = rightNode:getChildByName("dekaronPanel")

    self.middleNode = self._csb:getChildByName("middleNode")

    self:addPanel()

    local role = zzm.CharacterModel:getCharacterData()
    local enCAT = enCharacterAttrType
    self.pic_role:setTexture(HeroConfig:getValueById(role:getValueByType(enCAT.PRO))["BgLing"])

    zzc.PkController:getPkData()

    zzm.TalkingDataModel:onEvent(EumEventId.PK_OPEN_COUNT,{})
end

function PkNode:addPanel()
    local item = nil
    local itemSize = nil
    local x,y = 0,0
    local index = 1
    for i=5,1,-1 do
        item = PkItem:create()
        item:setName("pkItem_"..index)
        item:setParent(self)
        itemSize = item:getFrameSize()
        x = 8
        y = (itemSize.height + 6) * (i - 1)
        item:setPosition(cc.p(x,y))
        self._panel:addChild(item)
        self.itemList[index] = item
        index = index + 1
    end
end

function PkNode:initEvent()

    dxyDispatcher_addEventListener(dxyEventType.Pk_Data_Upgrade,self,self.updateValue)
    dxyDispatcher_addEventListener(dxyEventType.Character_AttrUpdate,self,self.updateData)

    self:updateData()

    self.btn_ranking:addTouchEventListener(function(target,type)
        if type == 2 then
            SoundsFunc_playSounds(SoundsType.OPEN_PAGE,false)
            require("game.pk.view.PkRankingLayer")
            local layer = PkRankingLayer:create()
            self.middleNode:addChild(layer)
        end
    end)

    self.btn_news:addTouchEventListener(function(target,type)
        if type == 2 then
            SoundsFunc_playSounds(SoundsType.OPEN_PAGE,false)
            require("game.pk.view.PkNewsLayer")
            local layer = PkNewsLayer:create()
            self.middleNode:addChild(layer)
        end
    end)

    self.btn_add:addTouchEventListener(function(target,type)
        if type == 2 then
            SoundsFunc_playSounds(SoundsType.OPEN_PAGE,false)
            if self.buyCount >= #PkConfig:getBuyCountData() then
                dxyFloatMsg:show("已到购买上限")
                return
            end

            local function callBack(target,type)
                if type == 2 then
                    SoundsFunc_playSounds(SoundsType.UNIVERSAL_BTN,false)
                    UIManager:closeUI("CustomTips")
                    zzc.PkController:request_buyCount()
                end
            end
            local layer = CustomTips:create()
            local text = "是否花费"..PkConfig:getRmbByCount(self.buyCount + 1).."元宝购买挑战次数?"
            layer:update(text,callBack)
        end
    end)

end

function PkNode:removeEvent()
    dxyDispatcher_removeEventListener(dxyEventType.Pk_Data_Upgrade,self,self.updateValue)
    dxyDispatcher_removeEventListener(dxyEventType.Character_AttrUpdate,self,self.updateData)
end

function PkNode:updateData()
    local role = zzm.CharacterModel:getCharacterData()
    local enCAT = enCharacterAttrType

    self.count = role:getValueByType(enCAT.WARCOUNT)
    self.buyCount = role:getValueByType(enCAT.WARBUY)

    self.txt_name:setString(role:getValueByType(enCAT.NAME))
    self.txt_lv:setString("LV."..role:getValueByType(enCAT.LV))
    self.txt_power:setString(role:getValueByType(enCAT.POWER))
    self.txt_ranking:setString("第"..zzm.PkModel.ranking.."名")
    self.txt_count:setString(self.count)
end

function PkNode:updateValue()
    for index=1, #zzm.PkModel.player_list do
        self.itemList[index]:update(zzm.PkModel.player_list[index])
    end
    self.txt_ranking:setString("第"..zzm.PkModel.ranking.."名")
    self:setReward()
end

function PkNode:setReward()
    local data = PkConfig:getRewardByRanking(zzm.PkModel.ranking)
    self.txt_gold:setString(data.Gold)
    self.txt_rmb:setString(data.Rmb)
    self.txt_renown:setString(data.Renown)
end
