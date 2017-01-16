SweepEliteResultLayer = SweepEliteResultLayer or class("SweepEliteResultLayer",function()
    return cc.Layer:create()
end)

function SweepEliteResultLayer:create()
    local layer = SweepEliteResultLayer:new()
    return layer
end

function SweepEliteResultLayer:ctor()
    self._csb = nil
    
    self:initUI()
    dxyExtendEvent(self)
end

function SweepEliteResultLayer:initUI()
    self._csb = cc.CSLoader:getInstance():createNodeWithFlatBuffersFile("dxyCocosStudio/csd/ui/sweep/SweepEliteResultLayer.csb")
    self:addChild(self._csb)

    self.visibleSize = cc.Director:getInstance():getVisibleSize()
    self.origin = cc.Director:getInstance():getVisibleOrigin()

    local posX = self.origin.x + self.visibleSize.width/2
    local posY = self.origin.y + self.visibleSize.height/2
    
    self:setPosition(posX,posY)
    
    self.bg = self._csb:getChildByName("bg")
    
    self.pageView = self._csb:getChildByName("PageView")
    self.pageView:setDirection(ccui.PageViewDirection.VERTICAL)
    
    local btnNode = self._csb:getChildByName("btnNode")
    self.btn_again = btnNode:getChildByName("againBtn")
    self.btn_return = btnNode:getChildByName("returnBtn")
    self.ckb_auto = btnNode:getChildByName("autoCkb")
    
    local awardNode = self._csb:getChildByName("awardNode")
    self.txt_renown = awardNode:getChildByName("renownTxt")
    self.txt_gold = awardNode:getChildByName("goldTxt")
    
    require("game.sweep.view.SweepEliteResultItem")
    
    self.isAutoSweep = self.ckb_auto:isSelected()
    
end

function SweepEliteResultLayer:WhenClose()
    if self._myTimer then
        self._myTimer:stop()
        self._myTimer = nil
    end
	self:removeFromParent()
end

function SweepEliteResultLayer:removeEvent()
    dxyDispatcher_removeEventListener(dxyEventType.Sweep_Result_Update,self,self.updateValue)
end

function SweepEliteResultLayer:initEvent()
    -- 拦截
    local function onTouchBegan(touch, event)
        return true
    end

    local function onTouchMoved(touch, event)
    end

    local function onTouchEnded(touch, event)   
        local location = touch:getLocation()

        local point = self.bg:convertToNodeSpace(location)
        local rect = cc.rect(0,0,self.bg:getContentSize().width,self.bg:getContentSize().height)
        if cc.rectContainsPoint(rect,point) == false then
            UIManager:closeUI("SweepEliteResultLayer")
        end
    end

    local listener = cc.EventListenerTouchOneByOne:create()
    listener:registerScriptHandler(onTouchBegan,cc.Handler.EVENT_TOUCH_BEGAN )
    listener:registerScriptHandler(onTouchMoved,cc.Handler.EVENT_TOUCH_MOVED )
    listener:registerScriptHandler(onTouchEnded,cc.Handler.EVENT_TOUCH_ENDED )
    local eventDispatcher = self:getEventDispatcher()
    eventDispatcher:addEventListenerWithSceneGraphPriority(listener, self)
    listener:setSwallowTouches(true)
    
    dxyDispatcher_addEventListener(dxyEventType.Sweep_Result_Update,self,self.updateValue)
    
    self.btn_again:addTouchEventListener(function(target,type)
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
                    zzc.SweepController:request_eliteSweep(zzm.SweepModel.eliteCopyId,limit)
                    self.btn_again:setTouchEnabled(false)
                    self.btn_again:setBright(false)
                end
            end
            
            if self.isAutoSweep then              	
                local layer = CustomTips:create()
                layer:update("确定使用全部元力扫荡?",autoCallBack)
            else
                zzc.SweepController:request_eliteSweep(zzm.SweepModel.eliteCopyId,1)
            end
        end
    end)
    
    self.btn_return:addTouchEventListener(function(target,type)
        if type == 2 then
            SoundsFunc_playSounds(SoundsType.UNIVERSAL_BTN,false)
            UIManager:closeUI("SweepEliteResultLayer")
            zzc.CopySelectController:closeLayer()
        end
    end)
    
    self.ckb_auto:addEventListener(function(target,type)
        if type == ccui.CheckBoxEventType.selected then
            SoundsFunc_playSounds(SoundsType.UNIVERSAL_BTN,false)
            self.isAutoSweep = true
        elseif type == ccui.CheckBoxEventType.unselected then
            SoundsFunc_playSounds(SoundsType.UNIVERSAL_BTN,false)
            self.isAutoSweep = false
        end
    end)    
    
end

function SweepEliteResultLayer:updateValue()
    local data = zzm.SweepModel.award_elite_list
    
    local pageSize = nil
    for index=#data, 1, -1 do
        local page = SweepEliteResultItem:create()
        page:update(data[index])
        self.pageView:addPage(page)
        pageSize = page:getPageSize()
    end
    
    self.pageView:setContentSize(pageSize.width,pageSize.height)
    self.pageView:setCustomScrollThreshold(pageSize.width*0.1)
    
    self:showAnimation()
end

function SweepEliteResultLayer:showAnimation()
    require("game.utils.NumberChangeByUpdate")
    self._myTimer = require("game.utils.MyTimer").new()
    local num = 1
    local renown = 0
    local gold = 0
    self.renownNode = NumberChangeByUpdate:create()
    self:addChild(self.renownNode)
    
    self.goldNode = NumberChangeByUpdate:create()
    self:addChild(self.goldNode)
    
    renown = renown + zzm.SweepModel.award_elite_list[num].renown
    gold = gold + zzm.SweepModel.award_elite_list[num].gold
    
    self.renownNode:initByPam(0,renown,self.txt_renown,1.25,0.05)
    self.goldNode:initByPam(0,gold,self.txt_gold,1.25,0.05)
    
    local function tick()
        local page = self.pageView:getCurPageIndex()
        if page >= #zzm.SweepModel.award_elite_list - 1 and num >= #zzm.SweepModel.award_elite_list then
            self._myTimer:stop()
            return
        end
        self.pageView:scrollToPage(page + 1)
        num = num + 1
        renown = renown + zzm.SweepModel.award_elite_list[num].renown
        gold = gold + zzm.SweepModel.award_elite_list[num].gold
        self.renownNode:initByPam(0,renown,self.txt_renown,1.25,0.05)
        self.goldNode:initByPam(0,gold,self.txt_gold,1.25,0.05)
       
    end
    
    self._myTimer:start(0.5,tick)
    
end

function SweepEliteResultLayer:reset()
    self.renownNode:removeFromParent()
    self.goldNode:removeFromParent()
    self.pageView:removeAllPages()
end