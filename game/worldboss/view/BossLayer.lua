local BossLayer = class("BossLayer",function()
    return cc.Layer:create()
end)
local PATH = "dxyCocosStudio/png/worldboss/"

function BossLayer:ctor()
    self.winSize = cc.Director:getInstance():getVisibleSize()
    self.origin = cc.Director:getInstance():getVisibleOrigin()
end

function BossLayer:create()
    local layer = BossLayer:new()
    layer:init()
    return layer
end

function BossLayer:init()
    self._csb = cc.CSLoader:createNode("dxyCocosStudio/csd/ui/worldboss/BossLayer.csb")
    self:addChild(self._csb)
    self._csb:setPosition(self.origin.x + self.winSize.width / 2, self.origin.y + self.winSize.height / 2)
    
    dxyExtendEvent(self)
    -- 拦截
    dxySwallowTouches(self)
    
--    local swallow = self._csb:getChildByName("bg")
--    swallow:setContentSize(self.winSize.width,self.winSize.height)
    
    self._ndSP = self._csb:getChildByName("ndSP"):getChildByName("ndSP")
    local Ossature = WorldBossConfig:getWBSkeleton()
    self._action = mc.SkeletonDataCash:getInstance():createWithCashName(Ossature)
    self._action:setAnimation(1,"ready", true)
    self._action:setAnchorPoint(0.5,0)
    self._action:setPosition(0,0)
    self._ndSP:addChild(self._action)
    
    --title    
    require "src.game.utils.TopTitleNode"
    local node = TopTitleNode:create(self,PATH.."txt2.png")
    self:addChild(node)
    
    local EventGroup = WorldBossConfig:getEventGroup()
    
---Txt    
--    local bg = self._csb:getChildByName("bg")
--    bg:setContentSize(self.winSize.width,self.winSize.height)
    local txtTimer = self._csb:getChildByName("bg1"):getChildByName("txtTimer")
    local str = "每日"..cn:TimeForDay(EventGroup.StartTime).."~"..cn:TimeForDay(EventGroup.EndTime)
    txtTimer:setString(str)
    
    local txtGoods = self._csb:getChildByName("bg2"):getChildByName("txtGoods")
    txtGoods:setString(EventGroup.Explain)
    
    local txtInt = self._csb:getChildByName("bg4"):getChildByName("txtInt")

---Btn
    local ndBtn = self._csb:getChildByName("ndBTN")
    local btnRank = ndBtn:getChildByName("btnRank")
    btnRank:addTouchEventListener(function(target,type)
        if type == 2 then
            SoundsFunc_playSounds(SoundsType.OPEN_PAGE,false)
            zzc.WorldBossController:getCurRank()
            local rank = require("src.game.worldboss.view.HarmRank"):create()
            self:addChild(rank)
--            if not zzm.WorldBossModel.HurtRank then
--            else
--                rank:addItem()
--            end
        end
    end) 
    
    local btnFight = ndBtn:getChildByName("btnFight")
    btnFight:addTouchEventListener(function(target,type)
        if type == 2 then
            SoundsFunc_playSounds(SoundsType.OPEN_PAGE,false)
            local state = zzm.WorldBossModel.State
            if state == DefineConst.CONST_STATE_VALUE_WORLD_BOSS_END then         -- 状态值--世界boss--关闭
                dxyFloatMsg:show("世界BOSS尚未开启")
                return 
            else
                zzc.LoadingController:setCopyData({copyType = DefineConst.CONST_COPY_TYPE_WORLD_BOSS,chapterID = 0, startTalkID = 0, endTalkID = 0, sceneID = WorldBossConfig:getResourceByKey("SceneId"), param1 = 0})
                zzc.LoadingController:enterScene(SceneType.LoadingScene)
                zzc.LoadingController:setDelegate2(
                    {target = self, func = function (data) zzc.LoadingController:enterScene(SceneType.CopyScene)end,data = self.m_data})
            end
        end
    end) 
    
    self._txtTimer = ndBtn:getChildByName("txtTimer")
    local state = zzm.WorldBossModel.State
    if state == DefineConst.CONST_STATE_VALUE_WORLD_BOSS_END then -- 状态值--世界boss--关闭
        self._txtTimer:setVisible(true)
        local curOS = os.time() - _G.DiffTimer
        local H = os.date("%H",curOS) * 3600
        local M = os.date("%M",curOS) * 60
        local S = os.date("%S",curOS)
        local ALL = H + M + S
        local cut = 0
        if ALL < EventGroup.StartTime then
            cut = EventGroup.StartTime - ALL
        elseif ALL > EventGroup.EndTime then
            local allS = 24 * 3600
            cut = allS - (ALL - EventGroup.StartTime)
        else
            self._txtTimer("BOOS已经出现，赶紧进去挑战吧！")
            return
        end
        if not self.m_Timer then
            self.m_Timer = self.m_Timer or require("game.utils.MyTimer").new()
            local h = os.date("%H",cut)-8
            local m = os.date("%M",cut)
            local s = os.date("%S",cut)
            local str = string.format("%02d",h)..":"..string.format("%02d",m)..":"..string.format("%02d",s)
            self._txtTimer:setString("BOSS出现时间:"..str)
            local function tick()
                cut = cut - 1
                if cut >= 1 or zzm.WorldBossModel.State == DefineConst.CONST_STATE_VALUE_WORLD_BOSS_END then --未开启
                    local h = os.date("%H",cut)-8
                    local m = os.date("%M",cut)
                    local s = os.date("%S",cut)
                    local str = string.format("%02d",h)..":"..string.format("%02d",m)..":"..string.format("%02d",s)
                    self._txtTimer:setString("BOSS出现时间:"..str)
                else
                    self:stopTimer()
                end
            end
            self.m_Timer:start(1,tick)
        end
    else
        self._txtTimer:setVisible(false)
    end
end

function BossLayer:stopTimer()
    self._txtTimer:setVisible(false)
    self.m_Timer:stop()
    self.m_Timer = nil
end

function BossLayer:initEvent()
    dxyDispatcher_addEventListener("BossLayer_whenClose",self,self.whenClose)
end

function BossLayer:removeEvent()
    dxyDispatcher_removeEventListener("BossLayer_whenClose",self,self.whenClose)
end

function BossLayer:whenClose()
    self._ndSP:removeAllChildren()
    self._action = nil
    self:stopTimer()
end

return BossLayer