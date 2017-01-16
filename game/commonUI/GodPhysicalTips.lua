GodPhysicalTips = GodPhysicalTips or class("GodPhysicalTips",function()
    return cc.Node:create()
end)

function GodPhysicalTips:create()
    local node = GodPhysicalTips:new()
    return node
end

function GodPhysicalTips:ctor()
    self._csb = nil

    self:initUI()

    self:initEvent()
end

function GodPhysicalTips:initUI()
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

function GodPhysicalTips:initEvent()

    local role = zzm.CharacterModel:getCharacterData()
    local enCAT = enCharacterAttrType
    self.count = role:getValueByType(enCAT.GODPHYSICALBUY)
    if self.count >= #PhysicalConfig:getGodBuyList() then
        self.text:setString("是否花费"..PhysicalConfig:getGodRmbByCount(self.count).."元宝购买"..PhysicalConfig:getGodBaseValue().Buy.."神将副本体力?")
    else
        self.text:setString("是否花费"..PhysicalConfig:getGodRmbByCount(self.count + 1).."元宝购买"..PhysicalConfig:getGodBaseValue().Buy.."神将副本体力?")      
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

function GodPhysicalTips:request_BuyPhysical()
    if self.count >= #PhysicalConfig:getGodBuyList() then
        dxyFloatMsg:show("已超过购买上限!")
    	return
    end
    print("request_BuyGodPhysical")
    local msg = mc.packetData:createWritePacket(DefineProto.PROTO_RECHARGE_BUY_GODWILLPHYSICAL); --编写发送包
    mc.NetMannager:getInstance():sendMsg(msg); --发送 包
end