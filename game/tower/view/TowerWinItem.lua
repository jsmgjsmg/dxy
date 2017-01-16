TowerWinItem = TowerWinItem or class("TowerWinItem",function()
    local path = "dxyCocosStudio/png/cornucopia/frameBg.png"
    return ccui.Button:create(path,path,path)
end)

function TowerWinItem:create()
    local node = TowerWinItem:new()
    return node
end

function TowerWinItem:ctor()
    self._csb = nil
    self.timeOut = false
    self:initUI()
    self:initEvent()
end

function TowerWinItem:initUI()
    self._csb = cc.CSLoader:createNode("dxyCocosStudio/csd/ui/cornucopia/cornucopiaWinItem.csb")
    self:addChild(self._csb)

    local x = self:getContentSize().width / 2
    local y = self:getContentSize().height / 2

    self._csb:setPosition(cc.p(x,y))

    self.isTurn = false

    self.positiveBg = self._csb:getChildByName("positiveBg")
    self.txt_gold = self.positiveBg:getChildByName("Text")
    self.icon = self.positiveBg:getChildByName("icon")

    self.backBg = self._csb:getChildByName("backBg")
    self.txt_vip = self.backBg:getChildByName("vipTxt")
    self.chargeNode = self.backBg:getChildByName("chargeNode")
    self.txt_rmb = self.chargeNode:getChildByName("rmbTxt")
    self.freeNode = self.backBg:getChildByName("freeNode")
    self.txt_free = self.freeNode:getChildByName("Text_2")

    self.txt_vip:setVisible(false)
    self.positiveBg:setVisible(false)
end

function TowerWinItem:initEvent()
    self:addTouchEventListener(function(target,type)
        if type == 2 and not self.isTurn then
            if self.parent._myTimer then               
                self.parent._myTimer:stop()
            end
            self.parent.txt_time:setVisible(false)
            
            if self.idx < 5 then
                for index=1, 4 do
                    self.parent.list_item[index]:setTouchEnabled(false)
                end
            end
            
            self:turnCard()
            if self.idx > 4 then
                zzm.TowerModel.clickedCount = zzm.TowerModel.clickedCount + 1
                for index=5, 8 do
                    self.parent.list_item[index]:update()
                end
            end
            table.insert(zzm.TowerModel.clicked_card,zzm.TowerModel.card_list[self.idx].id)
            
            self:runTimeLine()
            
        end
    end)
end

function TowerWinItem:runTimeLine()
    self._timeLine = cc.CSLoader:createTimeline("dxyCocosStudio/csd/ui/cornucopia/cornucopiaWinItem.csb")
    self._csb:runAction(self._timeLine)
    self._timeLine:gotoFrameAndPlay(0,true)
    self._timeLine:setTimeSpeed(0.3)
end

function TowerWinItem:setParent(parent,idx,copyType,awardType)
    self.parent = parent
    self.idx = idx
    self.copyType = copyType
    self.awardType = awardType
    
    local path = "dxyCocosStudio/png/tower/"
    if self.copyType == DefineConst.CONST_COPY_TYPE_TRAIN_EXP then
        self.icon:setTexture(path.."expS_light.png")
    elseif self.copyType == DefineConst.CONST_COPY_TYPE_TRAIN_FLOWER then
        self.icon:setTexture(path.."flowerS_light.png")
    elseif self.copyType == DefineConst.CONST_COPY_TYPE_TRAIN_RENOWN then
        self.icon:setTexture(path.."prestigeS_light.png")
    end
end

function TowerWinItem:turnCard()
    local function autoTurn()
        if self.idx < 5 then
            for index=1, 4 do
                if index ~= self.idx and not self.parent.list_item[index].isTurn then
                    self.parent.list_item[index]:turnCard()
                end
            end
            for index=5, 8 do
                if self.timeOut and not self.parent.list_item[index].isTurn then
                    self.parent.list_item[index]:turnCard()
                end
                self.parent.list_item[index]:update()
            end
            self.parent.cornucopiaBtn:setTouchEnabled(true)
        end
    end
    self.isTurn = true
    local orbitPositive = cc.OrbitCamera:create(0.5,1,0,90,-90,0,0)
    local orbitBack = cc.OrbitCamera:create(0.5,1,0,0,-90,0,0)
    self.positiveBg:setVisible(false)
    local sequence = cc.Sequence:create(cc.Show:create(),orbitBack,cc.Hide:create(),cc.TargetedAction:create(self.positiveBg,cc.Sequence:create(cc.Show:create(),orbitPositive)),cc.CallFunc:create(autoTurn))
    self.backBg:runAction(sequence)

end

function TowerWinItem:update()
    if self.idx < 5 then
        self.chargeNode:setVisible(false)
        self.freeNode:setVisible(true)
    else
        self.chargeNode:setVisible(true)
        self.freeNode:setVisible(false)
    end
    self.txt_gold:setString(zzm.TowerModel.card_list[self.idx].value)

    if self.idx > 4 then
        self.chargeNode:setVisible(true)
        self.freeNode:setVisible(false)
        if TowerConfig:getCardByType(self.copyType)[zzm.TowerModel.clickedCount + 1] then  	
            self.txt_rmb:setString(TowerConfig:getCardByType(self.copyType)[zzm.TowerModel.clickedCount + 1].Rmb)
        end
        self:setTouchEnabled(true)
        self.txt_vip:setVisible(true)
        if TowerConfig:getVipByType(self.copyType)[zzm.TowerModel.clickedCount + 1] then
            self.txt_vip:setString("VIP"..(TowerConfig:getVipByType(self.copyType)[zzm.TowerModel.clickedCount + 1].VIP).."开放")
        end
    end
    
    local vipCount = VipConfig:getAppreciationByLvAndType(_G.RoleData.VipLv,self.awardType)
    print("当前VIP等级为:".._G.RoleData.VipLv)
    print("当前VIP可翻的牌:"..vipCount)

    if self.idx > 4 and zzm.TowerModel.clickCount <= zzm.TowerModel.clickedCount and vipCount > zzm.TowerModel.clickedCount then
        self.chargeNode:setVisible(false)
        self.freeNode:setVisible(true)
        self.txt_free:setString("元宝不足")
        self:setTouchEnabled(false)
    end
    
    if self.idx > 4 and zzm.TowerModel.clickCount <= zzm.TowerModel.clickedCount and vipCount == zzm.TowerModel.clickedCount then
        self.chargeNode:setVisible(false)
        self.freeNode:setVisible(true)
        self.txt_free:setString("VIP等级不足")
        self:setTouchEnabled(false)
    end
end