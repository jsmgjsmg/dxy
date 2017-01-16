
LotteryDrawReward = LotteryDrawReward or class("LotteryDrawReward",function()
    return cc.Layer:create()
end)

function LotteryDrawReward.create()
    local layer = LotteryDrawReward.new()
    return layer
end

function LotteryDrawReward:ctor()
    self._csbNode = nil
    self:initUI()
    dxyExtendEvent(self)
end

function LotteryDrawReward:initUI()
    self._csbNode = cc.CSLoader:getInstance():createNodeWithFlatBuffersFile("dxyCocosStudio/csd/ui/lotterydraw/LotteryDrawReward.csb")
    self:addChild(self._csbNode)
    self.visibleSize = cc.Director:getInstance():getVisibleSize()
    self.origin = cc.Director:getInstance():getVisibleOrigin()

    local posX = self.origin.x + self.visibleSize.width/2
    local posY = self.origin.y + self.visibleSize.height/2

    self:setPosition(posX, posY)
    
    local node = self._csbNode:getChildByName("Panel")
    self._itemList ={}
    for i=1,10 do
        self._itemList[i] = node:getChildByName("ProjectNode_" .. i) 
    end
    
    self.btn_Sure = self._csbNode:getChildByName("Sure")
    self.btn_TryTen = self._csbNode:getChildByName("TryTen")
    
    self:setRewardData()

end

function LotteryDrawReward:WhenClose()
--    dxyDispatcher_dispatchEvent("MainScene_updateChatRedIcon", false)
    self:removeFromParent()

end

function LotteryDrawReward:removeEvent()
 --   dxyDispatcher_dispatchEvent("MainScene_updateChatRedIcon", false)
end

function LotteryDrawReward:initEvent()
    if(self.btn_Sure)then
        self.btn_Sure:addTouchEventListener(function(target,type)
            if(type==2)then
                zzc.LotteryDrawController:closeRewardLayer()
            end
        end)
    end
    if (self.btn_TryTen) then
        self.btn_TryTen:addTouchEventListener(function(target,type)
            if type == 2 then
                zzc.LotteryDrawController:closeRewardLayer()
                zzc.LotteryDrawController:request_GetReawerd(2)
            end
        end)
    end
    
    -- 拦截
    dxySwallowTouches(self)
end

function LotteryDrawReward:setRewardData()
    
    for i=1,10 do
        EquipItem.ItemNode = self._itemList[i]
        local item = EquipItem:create()
        local data = zzm.LotteryDrawModel:getTenReward(i)
        item:updateReward(data)
        --item:isShowEquipSmelt()
        item:setName("EquipItem"..i)
    end
end
