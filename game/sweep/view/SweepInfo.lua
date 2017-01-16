SweepInfo = SweepInfo or class("SweepInfo",function()
    return cc.Node:create()
end)

function SweepInfo.create()
    local node = SweepInfo.new()
    return node
end

function SweepInfo:ctor()
    self._csb = nil

    self:initUI()
    self:initEvent()
end

function SweepInfo:initUI()
    self._csb = cc.CSLoader:getInstance():createNodeWithFlatBuffersFile("dxyCocosStudio/csd/ui/sweep/SweepInfo.csb")
    self:addChild(self._csb)

    self.visibleSize = cc.Director:getInstance():getVisibleSize()
    self.origin = cc.Director:getInstance():getVisibleOrigin()

    local posX = self.origin.x + self.visibleSize.width/2
    local posY = self.origin.y + self.visibleSize.height/2

    self:setPosition(cc.p(posX,posY))

    self.bg = self._csb:getChildByName("bg")

    self.img_peach = self.bg:getChildByName("peachImg")
    self.txt_num = self.bg:getChildByName("pointImg"):getChildByName("numTxt")
    self.btn_sweep = self.bg:getChildByName("sweepBtn")
    
    self.txt_info = self.bg:getChildByName("infoTxt")
    self.txt_count = self.bg:getChildByName("countTxt")
    
end

function SweepInfo:initEvent()
    --屏蔽点击事件
    dxySwallowTouches(self,self.bg)

    self.btn_sweep:addTouchEventListener(function(target,type)
        if type == 2 then
            SoundsFunc_playSounds(SoundsType.UNIVERSAL_BTN,false)
            self:removeFromParent()
            zzc.SweepController:closeLayer()
            zzc.CopySelectController:showLayer()
        end
    end)
end

function SweepInfo:update(type)
    if type == DefineConst.CONST_PEENTO_TYPE_THREE_THOUSAND_YEARS then
	   self.img_peach:setTexture("dxyCocosStudio/png/Sweep/4.png")
    elseif type == DefineConst.CONST_PEENTO_TYPE_SIX_THOUSAND_YEARS then
        self.img_peach:setTexture("dxyCocosStudio/png/Sweep/5.png")
    elseif type == DefineConst.CONST_PEENTO_TYPE_NINE_THOUSAND_YEARS then
        self.img_peach:setTexture("dxyCocosStudio/png/Sweep/6.png")
	end
    self.txt_num:setString(zzm.SweepModel:findPeachNumByType(type))

    if zzm.SweepModel:findPeachNumByType(type) <= 0 then
    	self.btn_sweep:setTouchEnabled(false)
    	self.btn_sweep:setBright(false)
    end
    
    self.txt_info:setString(PeentoConfig:getConfigByType(type).Content1)
    self.txt_count:setString(PeentoConfig:getConfigByType(type).Content2)
    
    self.txt_count:setPositionX(self.txt_info:getPositionX() + self.txt_info:getContentSize().width / 2)
end
