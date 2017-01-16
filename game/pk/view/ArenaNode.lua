ArenaNode = ArenaNode or class("ArenaNode",function()
    return ccui.Layout:create()
end)
local path = "res/dxyCocosStudio/png/pk/arena/"

function ArenaNode:ctor()
    self.visibleSize = cc.Director:getInstance():getVisibleSize()
    self.origin = cc.Director:getInstance():getVisibleOrigin()
    self.itemList = {}
end

function ArenaNode:create()
    local node = ArenaNode:new()
    node:init()
    return node
end

function ArenaNode:init()
    self._csb = cc.CSLoader:createNode("dxyCocosStudio/csd/ui/pk/ArenaNode.csb")
    self:addChild(self._csb)

    self._csb:setPosition(self.origin.x + self.visibleSize.width / 2, self.origin.y + self.visibleSize.height / 2)
    
    self:setClippingEnabled(true)
    
    dxyExtendEvent(self)
    
    self.role = zzm.CharacterModel:getCharacterData()
    self.enCAT = enCharacterAttrType
    
    self._ndRole = self._csb:getChildByName("ndRole")
    self._bgHis = self._ndRole:getChildByName("bgHis")
    self._ndMyOss = self._ndRole:getChildByName("ndMyOss")
    self._ndHisOss = self._ndRole:getChildByName("ndHisOss")
    
    local heroConfig = HeroConfig:getValueById(self.role:getValueByType(self.enCAT.PRO))
    self.MyAction = mc.SkeletonDataCash:getInstance():createWithCashName(heroConfig.CreateBone)
    self.MyAction:setAnimation(1,"ready", true)
    self.MyAction:setScale(0.8)
    self._ndMyOss:addChild(self.MyAction)
    
    local ndDown = self._csb:getChildByName("ndDown")
    ndDown:setPositionY(-(self.visibleSize.height / 2))
    local spMyPro = ndDown:getChildByName("spMyPro")
    self._txtTime = ndDown:getChildByName("txtTime")
    local btnAdd = ndDown:getChildByName("btnAdd")
    local txtMyName = spMyPro:getChildByName("txtMyName")
    local txtMyPower = spMyPro:getChildByName("txtMyPower")
    self._txtMyAll = spMyPro:getChildByName("txtMyAll")
    self._txtMyWin = spMyPro:getChildByName("txtMyWin")
    
    txtMyName:setString(self.role:getValueByType(self.enCAT.NAME))
    txtMyPower:setString(self.role:getValueByType(self.enCAT.POWER))
    
--    local MatchData = zzm.PkModel.MatchData
    
    local rootVip = VipConfig:getVipByPrivilege(DefineConst.CONST_VIP_PRIVILEGE_TYPE_WAR_PK_OPEN)
    btnAdd:addTouchEventListener(function(target,type)
        if type == 2 then
        
            if _G.RoleData.VipLv < rootVip then
                cn:TipsSchedule("需要 Vip"..rootVip.." 才能开放购买")
                return
            end
        
            if zzm.PkModel.MatchData.Timer >= PkConfig:getMatchMax() then
                cn:TipsSchedule("次数到达上限")
                return
            end
        
            zzc.PkController:getMatchTimerNeed()
        end
    end)

    local spHisPro = ndDown:getChildByName("spHisPro")
    self.txtHisName = spHisPro:getChildByName("txtHisName")
    self.txtHisPower = spHisPro:getChildByName("txtHisPower")
    self.txtHisAll = spHisPro:getChildByName("txtHisAll")
    self.txtHisWin = spHisPro:getChildByName("txtHisWin")
    
    self._btnStart = ndDown:getChildByName("btnStart")
    self._btnStart:addTouchEventListener(function(target,type)
        if type == 2 then
            if zzm.PkModel.MatchData.Timer <= 0 then
                cn:TipsSchedule("次数不足，请先购买")
                return
            end
        
            self._btnStart:setVisible(false)  
            --协议  
            zzc.PkController:request_matching()
            self:changeBtnState(1)
        end
    end)
    
    local ndMiddle = self._csb:getChildByName("ndMiddle")
    self._txtReGold = ndMiddle:getChildByName("txtReGold")
    self._txtReRmb = ndMiddle:getChildByName("txtReRmb")
end

function ArenaNode:initEvent()
    dxyDispatcher_addEventListener("ArenaNode_changeHisData",self,self.changeHisData)
    dxyDispatcher_addEventListener("ArenaNode_BtnCallBack",self,self.BtnCallBack)
    dxyDispatcher_addEventListener("ArenaNode_changeBtnState",self,self.changeBtnState)
    dxyDispatcher_addEventListener("ArenaNode_updateTimer",self,self.updateTimer)
    dxyDispatcher_addEventListener("ArenaNode_updateRewards",self,self.updateRewards)
    dxyDispatcher_addEventListener("ArenaNode_openTipsPage",self,self.openTipsPage)
end

function ArenaNode:removeEvent()
    dxyDispatcher_removeEventListener("ArenaNode_changeHisData",self,self.changeHisData)
    dxyDispatcher_removeEventListener("ArenaNode_BtnCallBack",self,self.BtnCallBack)
    dxyDispatcher_removeEventListener("ArenaNode_changeBtnState",self,self.changeBtnState)
    dxyDispatcher_removeEventListener("ArenaNode_updateTimer",self,self.updateTimer)
    dxyDispatcher_removeEventListener("ArenaNode_updateRewards",self,self.updateRewards)
    dxyDispatcher_removeEventListener("ArenaNode_openTipsPage",self,self.openTipsPage)
    self:whenClose()
end

---更新对手数据
function ArenaNode:changeHisData(data)
    self._bgHis:setVisible(false)
    local heroConfig = HeroConfig:getValueById(data.Pro)
    self.HisAction = mc.SkeletonDataCash:getInstance():createWithCashName(heroConfig.CreateBone)
    self.HisAction:setAnimation(1,"ready", true)
    self.HisAction:setScale(0.8)
    self._ndHisOss:addChild(self.HisAction)
    
    self.txtHisName:setString(data.Name)
    self.txtHisPower:setString(data.Power)
    self.txtHisAll:setString(data.Total)
    self.txtHisWin:setString(data.Win)

    SwallowAllTouches:close()
    LoadWaitSec:close()
    SwallowAllTouches:show()
    self._btnStart:setVisible(true) 
    
    self.m_Timer = self.m_Timer or require("game.utils.MyTimer").new()
    local maxTime = 3
    local function tick()
        maxTime = maxTime - 1
        if maxTime == 1 then
            self.MyAction:setAnimation(1,"start", false)
            self.HisAction:setAnimation(1,"start", false)
        end
        if maxTime <= 0 then
            self:stopTimer()
            self:changeBtnState(2)
            zzc.PkController:closeLayer()
            --进入战斗
            zzc.LoadingController:setCopyData({copyType = DefineConst.CONST_COPY_TYPE_WAR_PK,chapterID = 0, startTalkID = 0, endTalkID = 0, sceneID = 90101, param1 = 0})
            zzc.LoadingController:enterScene(SceneType.LoadingScene)
            zzc.LoadingController:setDelegate2({target = self,func = function (data) zzc.LoadingController:enterScene(SceneType.CopyScene) end,data = self.m_data})
        end
    end
    self.m_Timer:start(1,tick)
end

function ArenaNode:BtnCallBack()
    --取消匹配
    zzc.PkController:cancel_matching()
    self:changeBtnState(2)
end

function ArenaNode:changeBtnState(state)
    if state == 1 then --准备中
        LoadWaitSec:show()
        self._btnStart:setVisible(false)
        SwallowAllTouches:show(path.."btn4.png",path.."btn5.png",self._btnStart,"ArenaNode_BtnCallBack")
    elseif state == 2 then --取消准备
        self._btnStart:setVisible(true)
        SwallowAllTouches:close()
        LoadWaitSec:close()
        self:stopTimer()   
    end
end

function ArenaNode:updateRewards()
    self.MatchData = zzm.PkModel.MatchData
    if not self.MatchData then
        return
    end
    for key, var in pairs(self.MatchData.Rewards) do
        if var.Type == DefineConst.CONST_CURRENCY_GOLD then
            self._txtReGold:setString(var.Num)
        elseif var.Type == DefineConst.CONST_AWARD_RENOWN then
            self._txtReRmb:setString(var.Num)
        end
    end
    self._txtMyAll:setString(self.MatchData.Total)
    self._txtMyWin:setString(self.MatchData.Win)
    self._txtTime:setString(self.MatchData.Timer)
    
    self:updateTimer()
end

function ArenaNode:updateTimer()
    self._txtTime:setString(zzm.PkModel.MatchData.Timer)
end

function ArenaNode:openTipsPage()
    if zzm.PkModel.MatchData.BuyNeed == 0 then
        cn:TipsSchedule("购买次数已用完")
        return
    end

    SoundsFunc_playSounds(SoundsType.OPEN_PAGE,false)
    local function callBack(target,type)
        if type == 2 then
            SoundsFunc_playSounds(SoundsType.UNIVERSAL_BTN,false)
            UIManager:closeUI("CustomTips")
            zzc.PkController:getMatchTimer()
        end
    end
    local layer = CustomTips:create()
    local text = "购买次数需要 "..zzm.PkModel.MatchData.BuyNeed.." 元宝"
    layer:update(text,callBack)
end

function ArenaNode:whenClose()
    if self.HisAction then
        self._ndHisOss:removeAllChildren()
        self.HisAction = nil
    end
    if self.MyAction then
        self._ndMyOss:removeAllChildren()
        self.MyAction = nil
    end
    self:stopTimer()
end

function ArenaNode:stopTimer()
    if self.m_Timer then
        self.m_Timer:stop()
        self.m_Timer = nil
    end
end
