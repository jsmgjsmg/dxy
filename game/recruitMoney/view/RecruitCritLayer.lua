RecruitCritLayer = RecruitCritLayer or class("RecruitCritLayer",function()
	return cc.Layer:create()
end)

function RecruitCritLayer:create(data)
    local layer = RecruitCritLayer:new()
    layer:initUI(data)
    return layer
end

function RecruitCritLayer:ctor()
	
end

function RecruitCritLayer:initUI(data)
	local _csb = cc.CSLoader:createNode("dxyCocosStudio/csd/ui/recruitMoney/recruitCritLayer.csb")
    SceneManager:getCurrentScene():addChild(self) 
    self:addChild(_csb)
    
    local node = _csb:getChildByName("Node")
    
    local tenRate = node:getChildByName("tenRate")
    local rate = node:getChildByName("rate")
    
    if data.rate == 10 then
    	tenRate:setVisible(true)
        rate:setSpriteFrame(cc.SpriteFrameCache:getInstance():getSpriteFrame("dxyCocosStudio/png/recruitMoney/0_1.png"))
    else
        tenRate:setVisible(false)
        rate:setSpriteFrame(cc.SpriteFrameCache:getInstance():getSpriteFrame("dxyCocosStudio/png/recruitMoney/0_"..data.rate..".png"))
    end
    
    local act = cc.CSLoader:createTimeline("dxyCocosStudio/csd/ui/recruitMoney/recruitCritLayer.csb")
    _csb:runAction(act)
    act:gotoFrameAndPlay(0,false)
    
    self.visibleSize = cc.Director:getInstance():getVisibleSize()
    self.origin = cc.Director:getInstance():getVisibleOrigin()

    self:setPosition(self.origin.x + self.visibleSize.width/2 , self.origin.y + self.visibleSize.height/2)
    
    self._myTimer = self._myTimer or require("game.utils.MyTimer").new()
    local function tick()
        self._myTimer:stop()
        self:removeFromParent()
--        dxyFloatMsg:show("招财成功,获得铜钱"..data.gold)
    end
    self._myTimer:start(0.3, tick)
end