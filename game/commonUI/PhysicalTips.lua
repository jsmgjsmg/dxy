PhysicalTips = PhysicalTips or class("PhysicalTips",function()
	return cc.Node:create()
end)

function PhysicalTips:create()
    local node = PhysicalTips:new()
    return node
end

function PhysicalTips:ctor()
	self._csb = nil
	
	self:initUI()
	
	self:initEvent()
end

function PhysicalTips:initUI()
	self._csb = cc.CSLoader:createNode("dxyCocosStudio/csd/ui/commonUI/PhysicalTips.csb")
	self:addChild(self._csb)
	
    self.visibleSize = cc.Director:getInstance():getVisibleSize()
    self.origin = cc.Director:getInstance():getVisibleOrigin()
    
    self:setPosition(cc.p(self.origin.x + self.visibleSize.width/2,self.origin.y + self.visibleSize.height/2))
    
    self.bg = self._csb:getChildByName("tipBG")
    
    self.btn_confirm = self._csb:getChildByName("confirmBtn")
    
    self.btn_close = self._csb:getChildByName("closeBtn")
    
    self.text = self._csb:getChildByName("Text")
	
end

function PhysicalTips:initEvent()

    local role = zzm.CharacterModel:getCharacterData()
    local enCAT = enCharacterAttrType
    self.count = role:getValueByType(enCAT.PHYSICALBUY)
    if self.count >= #PhysicalConfig:getBuyList() then
        self.text:setString("是否花费"..PhysicalConfig:getRmbByCount(self.count).."元宝购买"..PhysicalConfig:getBaseValue().Buy.."元力?")
    else
        self.text:setString("是否花费"..PhysicalConfig:getRmbByCount(self.count + 1).."元宝购买"..PhysicalConfig:getBaseValue().Buy.."元力?")       
    end
    

    self.btn_confirm:addTouchEventListener(function(target,type)
        if type == 2 then
        	self:request_BuyPhysical()
            self:removeFromParent()
        end
    end)
    
    self.btn_close:addTouchEventListener(function(target,type)
        if type == 2 then
            self:removeFromParent()
        end
    end)

    -- 拦截
    dxySwallowTouches(self,self.bg)
end

function PhysicalTips:request_BuyPhysical()
    if self.count >= #PhysicalConfig:getBuyList() then
        dxyFloatMsg:show("已超过购买上限!")
        return
    end
    print("request_BuyPhysical")
    local msg = mc.packetData:createWritePacket(NetEventType.Req_Buy_Physical); --编写发送包
    mc.NetMannager:getInstance():sendMsg(msg); --发送 包
end