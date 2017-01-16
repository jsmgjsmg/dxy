SweepSetRipeningNum = SweepSetRipeningNum or class("SweepSetRipeningNum",function()
    return cc.Node:create()
end)

function SweepSetRipeningNum.create()
    local node = SweepSetRipeningNum.new()
    return node
end

function SweepSetRipeningNum:ctor()
    self._csb = nil

    self:initUI()
--    self:initEvent()
    dxyExtendEvent(self)
end

function SweepSetRipeningNum:initUI()
    self._csb = cc.CSLoader:getInstance():createNodeWithFlatBuffersFile("dxyCocosStudio/csd/ui/sweep/SweepSetRipeningNum.csb")
    self:addChild(self._csb)

    self.visibleSize = cc.Director:getInstance():getVisibleSize()
    self.origin = cc.Director:getInstance():getVisibleOrigin()

    local posX = self.origin.x + self.visibleSize.width/2
    local posY = self.origin.y + self.visibleSize.height/2

    self:setPosition(cc.p(posX,posY))
    
    self.bg = self._csb:getChildByName("bg")
    
    self.btn_ripening = self._csb:getChildByName("ripeningBtn")
    
    local awardNode = self._csb:getChildByName("awardNode")
    self.txt_exp = awardNode:getChildByName("expTxt")
    self.txt_gold = awardNode:getChildByName("goldTxt")
    
    local countNode = self._csb:getChildByName("countNode")
    self.img_list = {}
    self.showNode_list = {}
    self.subBtn_list = {}
    self.addBtn_list = {}
    self.numTxt_list = {}
    self.txt_list = {}
    
    self.num_list = {}
    self.limit_list = {}
    
    for index=1, 3 do
    	self.img_list[index] = countNode:getChildByName("Image_"..index)
        self.showNode_list[index] = self.img_list[index]:getChildByName("showNode")
        self.subBtn_list[index] = self.showNode_list[index]:getChildByName("subBtn")
        self.addBtn_list[index] = self.showNode_list[index]:getChildByName("addBtn")
        self.numTxt_list[index] = self.showNode_list[index]:getChildByName("numTxt")
        self.txt_list[index] = self.img_list[index]:getChildByName("Text")
        
        self.num_list[index] = 0
        self.limit_list[index] = 0
        
    end

end

function SweepSetRipeningNum:closeLayer()
    self:removeFromParent()
    zzc.CopySelectController:closeCopyDetails()
end

function SweepSetRipeningNum:removeEvent()
    dxyDispatcher_removeEventListener("sweep_close_layer",self,self.closeLayer)
end

function SweepSetRipeningNum:initEvent()

    dxyDispatcher_addEventListener("sweep_close_layer",self,self.closeLayer)
    
    --屏蔽点击事件
    dxySwallowTouches(self,self.bg)
    
    self.btn_ripening:addTouchEventListener(function(target,type)
        if type == 2 then
            if #self.send_list > 0 then
                zzm.SweepModel.sendNum = #self.send_list
            	zzc.SweepController:request_sweep(self.copy_id,self.send_list)
				zzm.SweepModel.isLoginSend = true
--            	require("game.sweep.view.SweepResultLayer")
--            	local layer = SweepResultLayer:create()
--                SceneManager:getCurrentScene():addChild(layer)
            end
            SoundsFunc_playSounds(SoundsType.OPEN_PAGE,false)
--        	self:removeFromParent()
--            zzc.CopySelectController:closeCopyDetails()
        end
    end)
    
    for key, var in pairs(zzm.SweepModel.peach_list) do
        self.limit_list[var.type] = var.count
        if  self.limit_list[var.type] <= 0 then
            self.showNode_list[var.type]:setVisible(false)
            self.txt_list[var.type]:setVisible(true)
        else
            self.showNode_list[var.type]:setVisible(true)
            self.txt_list[var.type]:setVisible(false)          
            self.numTxt_list[var.type]:setString(self.num_list[var.type].."/"..self.limit_list[var.type])
        end
    end
    
    for index=1, 3 do
    	self.subBtn_list[index]:addTouchEventListener(function(target,type)
    	   if type == 2 then
                SoundsFunc_playSounds(SoundsType.UNIVERSAL_BTN,false)
    	       if self.num_list[index] > 0 then
                    self.num_list[index] = self.num_list[index] - 1
    	       end
    	       self:sortData()
    	   end
    	end)
    	
    	self.addBtn_list[index]:addTouchEventListener(function(target,type)
    	   if type == 2 then
                SoundsFunc_playSounds(SoundsType.UNIVERSAL_BTN,false)
                if self.num_list[index] < self.limit_list[index] then
                    self.num_list[index] = self.num_list[index] + 1
                end
                self:sortData()
    	   end
    	end)
    end
end

function SweepSetRipeningNum:sortData()
	for index=1, 3 do
        if self.limit_list[index] > 0 then
            self.numTxt_list[index]:setString(self.num_list[index].."/"..self.limit_list[index])
		end
	end
	
	self.send_list = {}
	for index=1, 3 do
	   local num = 0
        if self.num_list[index] > 0 then
            table.insert(self.send_list,#self.send_list + 1,{type = index,count = self.num_list[index]})
            zzm.SweepModel.sendNum = num + self.num_list[index]
		end
	end
	
	local exp = 0
	local gold = 0
    local copy_data = SceneConfigProvider:getCopyRewardById(self.copy_id)
    for index=1, 3 do
        exp = exp + self.num_list[index] * copy_data.WinExp
        gold = gold + self.num_list[index] * copy_data.WinGold
    end
    
    self.txt_exp:setString(exp)
    self.txt_gold:setString(gold)
	
end

function SweepSetRipeningNum:update(copy_id)
    self.copy_id = copy_id
    
    self:sortData()
end
