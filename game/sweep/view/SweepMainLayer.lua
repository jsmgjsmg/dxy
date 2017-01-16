SweepMainLayer = SweepMainLayer or class("SweepMainLayer",function()
    return cc.Layer:create()
end)

function SweepMainLayer.create()
    local layer = SweepMainLayer.new()
    return layer
end

function SweepMainLayer:ctor()
    self._csb = nil

    self:initUI()
    dxyExtendEvent(self)
end

function SweepMainLayer:initUI()
    self._csb = cc.CSLoader:getInstance():createNodeWithFlatBuffersFile("dxyCocosStudio/csd/ui/sweep/SweepMainLayer.csb")
    self:addChild(self._csb)
	
	self._timeLine = cc.CSLoader:createTimeline("dxyCocosStudio/csd/ui/sweep/SweepMainLayer.csb")
    self._csb:runAction(self._timeLine)
    self._timeLine:gotoFrameAndPlay(0,true)

    self.visibleSize = cc.Director:getInstance():getVisibleSize()
    self.origin = cc.Director:getInstance():getVisibleOrigin()

    local posX = self.origin.x + self.visibleSize.width/2
    local posY = self.origin.y + self.visibleSize.height/2

    local bg = self._csb:getChildByName("TitleNode"):getChildByName("BG")

    local node = self._csb:getChildByName("RoleNode")
    node:setPositionX(- posX)
    self.btn_tree = node:getChildByName("treeBtn")
    self.txt_treeNum = node:getChildByName("Sprite"):getChildByName("treeNumTxt")
    self.txt_ripeningRmb = node:getChildByName("useRmbText"):getChildByName("Text")
    self.txt_ripeningNum = node:getChildByName("Text"):getChildByName("Text")
    self.btn_ripening = node:getChildByName("Button")
    self.sp_tips = node:getChildByName("Sprite")
    
    self:tipsAnimation()

    node = self._csb:getChildByName("LeftNode")
    node:setPositionX(- posX)
    self.btn_back = node:getChildByName("Back")

    node = self._csb:getChildByName("RightNode")
    node:setPosition(cc.p(posX,- posY))
    self.btn_3 = node:getChildByName("Button_3")
    self.btn_6 = node:getChildByName("Button_6")
    self.btn_9 = node:getChildByName("Button_9")
    self.txt_3 = self.btn_3:getChildByName("Sprite"):getChildByName("Text")
    self.txt_6 = self.btn_6:getChildByName("Sprite"):getChildByName("Text")
    self.txt_9 = self.btn_9:getChildByName("Sprite"):getChildByName("Text")
    self.txt_stock = node:getChildByName("BG_1"):getChildByName("Text")
    self.txt_time = node:getChildByName("BG_2"):getChildByName("Text")

    node = self._csb:getChildByName("fightNode")
    node:setPositionX(posX)
    self.btn_fight = node:getChildByName("fightBtn")

    local dataNode = self._csb:getChildByName("dataNode")
    dataNode:setPosition(cc.p(posX ,posY - 35))
    require "src.game.utils.TopDataNode"
    local data = TopDataNode:create()
    dataNode:addChild(data)

    require("game.sweep.view.SweepRipening")
    require("game.sweep.view.SweepInfo")
    
end

function SweepMainLayer:tipsAnimation()
    local action = cc.RepeatForever:create(cc.Sequence:create(cc.FadeOut:create(0.8),cc.DelayTime:create(2),cc.FadeIn:create(0.8),cc.DelayTime:create(2)))
	self.sp_tips:runAction(action)	
end

function SweepMainLayer:WhenClose()
    if(self._handle)then
        cc.Director:getInstance():getScheduler():unscheduleScriptEntry(self._handle)
        self._handle = nil
    end
    self:removeFromParent()
end

function SweepMainLayer:removeEvent()
    dxyDispatcher_removeEventListener(dxyEventType.Sweep_Data_Update,self,self.updateValue)
end

function SweepMainLayer:initEvent()

    dxyDispatcher_addEventListener(dxyEventType.Sweep_Data_Update,self,self.updateValue)

    self:updateValue()

    --屏蔽点击事件
    dxySwallowTouches(self)

    self.btn_back:addTouchEventListener(function(target,type)
        if type == 2 then
            SoundsFunc_playSounds(SoundsType.CLOSE_PAGE,false)
            zzc.SweepController:closeLayer()
        end
    end)
    
    local function treeUpdate()
        if zzm.SweepModel.treeNum <= 0 then
            dxyFloatMsg:show("蟠桃尚未未成熟!")
            return
        end
        zzc.SweepController:request_removalPeach()
    end
    
    self.btn_tree:addTouchEventListener(function(target,type)
        if type == ccui.TouchEventType.began then
            self._myTimer = self._myTimer or require("game/utils/MyTimer.lua").new()
            self._myTimer:start(0.5,treeUpdate)
        elseif type == ccui.TouchEventType.moved then
            if self._myTimer then            	
                self._myTimer:stop()
                self._myTimer = nil
            end
        elseif type == ccui.TouchEventType.ended then
            if self._myTimer then               
                self._myTimer:stop()
                self._myTimer = nil
            end
            if zzm.SweepModel.treeNum <= 0 then
                dxyFloatMsg:show("蟠桃尚未未成熟!")
                SoundsFunc_playSounds(SoundsType.FAILE_TO_USE,false)
                return
            end
            SoundsFunc_playSounds(SoundsType.UNIVERSAL_BTN,false)
            zzc.SweepController:request_removalPeach()
        end
    end)


    self.btn_fight:addTouchEventListener(function(target,type)
        if type == 2 then
            SoundsFunc_playSounds(SoundsType.OPEN_PAGE,false)
            zzc.SweepController:closeLayer()
            zzc.CopySelectController:showLayer()
        end
    end)

    self.btn_ripening:addTouchEventListener(function(target,type)
        if type == 2 then
            if zzm.SweepModel.ripedCount + 1 > PeentoConfig:getCanBuyNum() then
                SoundsFunc_playSounds(SoundsType.FAILE_TO_USE,false)
            	dxyFloatMsg:show("催熟次数达到上限!")
            	return
            end
            if zzm.SweepModel.ripeCount <= 0 then
                dxyFloatMsg:show("今天次数已用完")
                return
            end
            SoundsFunc_playSounds(SoundsType.UNIVERSAL_BTN,false)
            zzc.SweepController:request_ripening()
--            SoundsFunc_playSounds(SoundsType.UNIVERSAL_BTN,false)
--            local layer = SweepRipening:create()
--            layer:update()
--            SceneManager:getCurrentScene():addChild(layer)
        end
    end)

    self.btn_3:addTouchEventListener(function(target,type)
        if type == 2 then
            SoundsFunc_playSounds(SoundsType.UNIVERSAL_BTN,false)
            local layer = SweepInfo:create()
            layer:update(DefineConst.CONST_PEENTO_TYPE_THREE_THOUSAND_YEARS)
            SceneManager:getCurrentScene():addChild(layer)
        end
    end)

    self.btn_6:addTouchEventListener(function(target,type)
        if type == 2 then
            SoundsFunc_playSounds(SoundsType.UNIVERSAL_BTN,false)
            local layer = SweepInfo:create()
            layer:update(DefineConst.CONST_PEENTO_TYPE_SIX_THOUSAND_YEARS)
            SceneManager:getCurrentScene():addChild(layer)
        end
    end)

    self.btn_9:addTouchEventListener(function(target,type)
        if type == 2 then
            SoundsFunc_playSounds(SoundsType.UNIVERSAL_BTN,false)
            local layer = SweepInfo:create()
            layer:update(DefineConst.CONST_PEENTO_TYPE_NINE_THOUSAND_YEARS)
            SceneManager:getCurrentScene():addChild(layer)
        end
    end)
end

function SweepMainLayer:updateValue()
    local data = zzm.SweepModel.peach_list
    local peachNum = 0
    for key, var in pairs(data) do
        peachNum = peachNum + var.count
        if var.type == DefineConst.CONST_PEENTO_TYPE_THREE_THOUSAND_YEARS then
    	   self.txt_3:setString(var.count)
        elseif var.type == DefineConst.CONST_PEENTO_TYPE_SIX_THOUSAND_YEARS then
            self.txt_6:setString(var.count)
        elseif var.type == DefineConst.CONST_PEENTO_TYPE_NINE_THOUSAND_YEARS then
            self.txt_9:setString(var.count)
    	end
    end
    local data1 = PeentoConfig:getDataByCount(zzm.SweepModel.ripedCount + 1)
    self.txt_treeNum:setString(zzm.SweepModel.treeNum)
    self.txt_stock:setString(peachNum.."/"..zzm.SweepModel.limit)
    self.txt_ripeningRmb:setString(data1.Sycee)
    self.txt_ripeningNum:setString(zzm.SweepModel.ripeCount)
    
    self:setTime(zzm.SweepModel.ripeTime,peachNum)
end

function SweepMainLayer:setTime(time,peachNum)
    if time > 0 then
        local overTime = time - os.time()
        if overTime > 0 and peachNum + zzm.SweepModel.treeNum < zzm.SweepModel.limit then
            self.txt_time:setVisible(true)
            local showTime = (string.format("%02d",os.date("%H",overTime)-8))..":"..os.date("%M",overTime)..":"..os.date("%S",overTime)
            self.txt_time:setString(showTime)
            local sharedScheduler = cc.Director:getInstance():getScheduler()
            self._handle = self._handle or sharedScheduler:scheduleScriptFunc(function()
                overTime = overTime - 1
                local showTime = (string.format("%02d",os.date("%H",overTime)-8))..":"..os.date("%M",overTime)..":"..os.date("%S",overTime)
                self.txt_time:setString(showTime)
                if overTime <= 0 then
                    if(self._handle)then
                        cc.Director:getInstance():getScheduler():unscheduleScriptEntry(self._handle)
                        self._handle = nil
                        self.txt_time:setString("桃树已满")
                    end
                end
            end,1,false)
        else
            if self._handle then
                cc.Director:getInstance():getScheduler():unscheduleScriptEntry(self._handle)
                self._handle = nil
            end
            self.txt_time:setString("桃树已满")
        end
    elseif time == 0 then
        self.txt_time:setString("桃树已满")
    end
end
