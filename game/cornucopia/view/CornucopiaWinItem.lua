CornucopiaWinItem = CornucopiaWinItem or class("CornucopiaWinItem",function()
    local path = "dxyCocosStudio/png/cornucopia/frameBg.png"
    return ccui.Button:create(path,path,path)
end)

function CornucopiaWinItem:create()
    local node = CornucopiaWinItem:new()
    return node
end

function CornucopiaWinItem:ctor()
    self._csb = nil
    self.timeOut = false
    self:initUI()
    self:initEvent()
end

function CornucopiaWinItem:initUI()
    self._csb = cc.CSLoader:createNode("dxyCocosStudio/csd/ui/cornucopia/cornucopiaWinItem.csb")
    self:addChild(self._csb)

    local x = self:getContentSize().width / 2
    local y = self:getContentSize().height / 2

    self._csb:setPosition(cc.p(x,y))

    self.isTurn = false

    self.positiveBg = self._csb:getChildByName("positiveBg")
    self.txt_gold = self.positiveBg:getChildByName("Text")
    
    self.backBg = self._csb:getChildByName("backBg")
    self.txt_vip = self.backBg:getChildByName("vipTxt")
    self.chargeNode = self.backBg:getChildByName("chargeNode")
    self.txt_rmb = self.chargeNode:getChildByName("rmbTxt")
    self.freeNode = self.backBg:getChildByName("freeNode")
    self.txt_free = self.freeNode:getChildByName("Text_2")
    
    self.txt_vip:setVisible(false)
    self.positiveBg:setVisible(false)
end

function CornucopiaWinItem:initEvent()
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
                zzm.CornucopiaModel.clickedCount = zzm.CornucopiaModel.clickedCount + 1
                for index=5, 8 do
                	self.parent.list_item[index]:update()
                end
            end
            table.insert(zzm.CornucopiaModel.clicked_card,zzm.CornucopiaModel.card_list[self.idx].id)
            
            self:runTimeLine()
            
        end
    end)
end

function CornucopiaWinItem:runTimeLine()
    self._timeLine = cc.CSLoader:createTimeline("dxyCocosStudio/csd/ui/cornucopia/cornucopiaWinItem.csb")
    self._csb:runAction(self._timeLine)
    self._timeLine:gotoFrameAndPlay(0,true)
    self._timeLine:setTimeSpeed(0.3)
end

function CornucopiaWinItem:setParent(parent,idx)
    self.parent = parent
    self.idx = idx
end

function CornucopiaWinItem:turnCard()
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

function CornucopiaWinItem:update()
    if self.idx < 5 then
        self.chargeNode:setVisible(false)
        self.freeNode:setVisible(true)
    else
        self.chargeNode:setVisible(true)
        self.freeNode:setVisible(false)
    end
    self.txt_gold:setString(zzm.CornucopiaModel.card_list[self.idx].value)
    
    if self.idx > 4 then
        self.chargeNode:setVisible(true)
        self.freeNode:setVisible(false)
        self.txt_rmb:setString(MoneySceneConfig:getCardRmbByCount(zzm.CornucopiaModel.clickedCount + 1))
        self:setTouchEnabled(true)
        self.txt_vip:setVisible(true)
        self.txt_vip:setString("VIP"..MoneySceneConfig:getVipByCount(zzm.CornucopiaModel.clickedCount + 1).."开放")
    end
    
    local vipCount = VipConfig:getAppreciationByLvAndType(_G.RoleData.VipLv,DefineConst.CONST_VIP_PRIVILEGE_TYPE_MONEY_TURNOVER)
    
    if self.idx > 4 and zzm.CornucopiaModel.clickCount <= zzm.CornucopiaModel.clickedCount and vipCount > zzm.CornucopiaModel.clickCount then
        self.chargeNode:setVisible(false)
        self.freeNode:setVisible(true)
        self.txt_free:setString("元宝不足")
        self:setTouchEnabled(false)
    end
    
    if self.idx > 4 and zzm.CornucopiaModel.clickCount <= zzm.CornucopiaModel.clickedCount and vipCount == zzm.CornucopiaModel.clickCount then
        self.chargeNode:setVisible(false)
        self.freeNode:setVisible(true)
        self.txt_free:setString("VIP等级不足")
        self:setTouchEnabled(false)
    end
end