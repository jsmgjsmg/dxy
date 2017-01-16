SweepResultLayer = SweepResultLayer or class("SweepResultLayer",function()
	return cc.Layer:create()
end)

function SweepResultLayer:create()
    local layer = SweepResultLayer:new()
    return layer
end

function SweepResultLayer:ctor()
	self._csb = nil
	
	self:initUI()
	dxyExtendEvent(self)
end

function SweepResultLayer:initUI()
    self._csb = cc.CSLoader:getInstance():createNodeWithFlatBuffersFile("dxyCocosStudio/csd/ui/sweep/SweepResultLayer.csb")
    self:addChild(self._csb)

    self.visibleSize = cc.Director:getInstance():getVisibleSize()
    self.origin = cc.Director:getInstance():getVisibleOrigin()

    local posX = self.origin.x + self.visibleSize.width/2
    local posY = self.origin.y + self.visibleSize.height/2
    
    self:setPosition(posX,posY)
    
    self.pageView = self._csb:getChildByName("PageView")
    self.pageView:setDirection(ccui.PageViewDirection.VERTICAL)
    
    local btnNode = self._csb:getChildByName("btnNode")
    self.btn_receive = btnNode:getChildByName("receiveBtn")
    self.ckb_list = {}
    for index=1, 3 do
    	self.ckb_list[index] = btnNode:getChildByName("ckb_"..index)
    end
    self.quality_list = {}
    
    local awardNode = self._csb:getChildByName("awardNode")
    self.txt_exp = awardNode:getChildByName("expTxt")
    self.txt_gold = awardNode:getChildByName("goldTxt")
    
    require("game.sweep.view.SweepResultItem")
    
end

function SweepResultLayer:removeEvent()
    dxyDispatcher_removeEventListener(dxyEventType.Sweep_Result_Update,self,self.updateValue)
end

function SweepResultLayer:initEvent()
    --屏蔽点击事件
    dxySwallowTouches(self)
    
    dxyDispatcher_addEventListener(dxyEventType.Sweep_Result_Update,self,self.updateValue)
    
    self.btn_receive:addTouchEventListener(function(target,type)
        if type == 2 then
            if not zzm.SweepModel:isLackOfSpace() then
                local function callBack(target,type)
                    if type == 2 then                    
                        SoundsFunc_playSounds(SoundsType.FAILE_TO_USE,false)
                        UIManager:closeUI("CustomTips")
                        zzc.CharacterController:showLayer()
                    end
                end
            	local layer = CustomTips:create()
                layer:update("背包空间不足,请先整理!",callBack)
                return
            end
            SoundsFunc_playSounds(SoundsType.CLOSE_PAGE,false)
            zzc.SweepController:request_receive(self.quality_list)
            self._myTimer:stop()
        	self:removeFromParent()
        end
    end)
    
    for index=1, 3 do
    	self.ckb_list[index]:addEventListener(function(target,type)
    	   if type == ccui.CheckBoxEventType.selected then
    	       self:addType(index)
    	   elseif type == ccui.CheckBoxEventType.unselected then
    	       self:delType(index)
    	   end
    	end)
    end
end

function SweepResultLayer:addType(type)
    table.insert(self.quality_list,type)
    
    table.sort(self.quality_list)
end

function SweepResultLayer:delType(type)
    for index=1, #self.quality_list do
    	if self.quality_list[index] == type then
            table.remove(self.quality_list,index)
    	end
    end
    table.sort(self.quality_list)
end

function SweepResultLayer:updateValue()
    local data = zzm.SweepModel.award_list
    
    local pageSize = nil
    for index=#data, 1, -1 do
    	local page = SweepResultItem:create()
        page:update(data[index])
        self.pageView:addPage(page)
        pageSize = page:getPageSize()
    end
    
    self.pageView:setContentSize(pageSize.width,pageSize.height)
    self.pageView:setCustomScrollThreshold(pageSize.width*0.1)
    
--    self.txt_exp:setString(zzm.SweepModel:getAllExp())
--    self.txt_gold:setString(zzm.SweepModel:getAllGold())
    
    self:showAnimation()
end

function SweepResultLayer:showAnimation()
    require("game.utils.NumberChangeByUpdate")
	self._myTimer = require("game.utils.MyTimer").new()
	local num = 1
	local exp = 0
	local gold = 0
    local expNode = NumberChangeByUpdate:create()
    self:addChild(expNode)
    
    local goldNode = NumberChangeByUpdate:create()
    self:addChild(goldNode)
    
    exp = exp + zzm.SweepModel.award_list[num].exp
    gold = gold + zzm.SweepModel.award_list[num].gold
    
    expNode:initByPam(0,exp,self.txt_exp,1.25,0.05)
    goldNode:initByPam(0,gold,self.txt_gold,1.25,0.05)
	
	local function tick()
		local page = self.pageView:getCurPageIndex()
        if page >= #zzm.SweepModel.award_list - 1 and num >= #zzm.SweepModel.award_list then
			self._myTimer:stop()
			return
		end
        self.pageView:scrollToPage(page + 1)
        num = num + 1
        exp = exp + zzm.SweepModel.award_list[num].exp
        gold = gold + zzm.SweepModel.award_list[num].gold
        expNode:initByPam(0,exp,self.txt_exp,1.25,0.05)
        goldNode:initByPam(0,gold,self.txt_gold,1.25,0.05)
       
	end
	
	self._myTimer:start(1.0,tick)
	
end