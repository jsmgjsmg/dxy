SweepRipening = SweepRipening or class("SweepRipening",function()
    return cc.Node:create()
end)

function SweepRipening.create()
    local node = SweepRipening.new()
    return node
end

function SweepRipening:ctor()
    self._csb = nil

    self:initUI()
    dxyExtendEvent(self)
end

function SweepRipening:initUI()
    self._csb = cc.CSLoader:getInstance():createNodeWithFlatBuffersFile("dxyCocosStudio/csd/ui/sweep/SweepRipening.csb")
    self:addChild(self._csb)

    self.visibleSize = cc.Director:getInstance():getVisibleSize()
    self.origin = cc.Director:getInstance():getVisibleOrigin()

    local posX = self.origin.x + self.visibleSize.width/2
    local posY = self.origin.y + self.visibleSize.height/2
    
    self:setPosition(cc.p(posX,posY))
    
    self.bg = self._csb:getChildByName("bg")
    
    self.txt_num = self.bg:getChildByName("numTxt")   
    self.btn_ripening = self.bg:getChildByName("ripeningBtn")
    self.txt_rmb = self.btn_ripening:getChildByName("rmbTxt")

end

function SweepRipening:initEvent()

    dxyDispatcher_addEventListener(dxyEventType.Sweep_Ripening_Update,self,self.update)
    
    --屏蔽点击事件
    dxySwallowTouches(self,self.bg)
    
    self.btn_ripening:addTouchEventListener(function(target,type)
        if type == 2 then
            SoundsFunc_playSounds(SoundsType.UNIVERSAL_BTN,false)
            zzc.SweepController:request_ripening()
        end
    end)
end

function SweepRipening:removeEvent()
    dxyDispatcher_removeEventListener(dxyEventType.Sweep_Ripening_Update,self,self.update)
end

function SweepRipening:update()
    if zzm.SweepModel.ripeCount <= 0 then
        self.btn_ripening:setTouchEnabled(false)
        self.btn_ripening:setBright(false)
	end
	
    local data = PeentoConfig:getDataByCount(zzm.SweepModel.ripedCount + 1)
    self.txt_num:setString(data.Num)
    self.txt_rmb:setString(data.Sycee)
end
