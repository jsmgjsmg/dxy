
LotteryDrawLayer = LotteryDrawLayer or class("LotteryDrawLayer",function()
    return cc.Layer:create()
end)

function LotteryDrawLayer.create()
    local layer = LotteryDrawLayer.new()
    return layer
end

function LotteryDrawLayer:ctor()
    self._csbNode = nil
    self._currentTab = 1
    self._clickType = 0
    self:initUI()
    dxyExtendEvent(self)
end

function LotteryDrawLayer:initUI()
    self._csbNode = cc.CSLoader:getInstance():createNodeWithFlatBuffersFile("dxyCocosStudio/csd/ui/lotterydraw/LotteryDrawLayer.csb")
    self:addChild(self._csbNode)
    self.visibleSize = cc.Director:getInstance():getVisibleSize()
    self.origin = cc.Director:getInstance():getVisibleOrigin()

    local posX = self.origin.x + self.visibleSize.width/2
    local posY = self.origin.y + self.visibleSize.height/2

    self:setPosition(posX, posY)
    
     require("game.lotterydraw.view.LotteryDrawItem")
     
    local titleNode = self._csbNode:getChildByName("TitleNode")
    local ndData = titleNode:getChildByName("ndData")
    ndData:setPositionX(self.visibleSize.width/2)
    require "game.utils.TopDataNode"
    local dataNode = TopDataNode:create()
    ndData:addChild(dataNode)
  
    local node = self._csbNode:getChildByName("LeftNode")
    self.btn_back = node:getChildByName("Back")
    node:setPosition(-posX, posY)
    
    local bg = self._csbNode:getChildByName("BG"):getChildByName("ImageBG")
    self.btn_One = bg:getChildByName("BG"):getChildByName("Panel"):getChildByName("One")
    self.btn_Ten = bg:getChildByName("BG"):getChildByName("Panel"):getChildByName("Ten")
    
    self._rightPanel = bg:getChildByName("BG"):getChildByName("RightPanel")
    
    self._currentItem = bg:getChildByName("TopPanel"):getChildByName("ProjectNode")
    self._currentName = bg:getChildByName("TopPanel"):getChildByName("NameText")
    
    self._itemList ={}
    for i=1,8 do
        self._itemList[i] = self._rightPanel:getChildByName("RightPanel"):getChildByName("Sprite_".. i):getChildByName("ProjectNode") 
    end
    
    self._ckbOne = bg:getChildByName("DownPanel"):getChildByName("CheckBox_1")
    self._ckbTwo = bg:getChildByName("DownPanel"):getChildByName("CheckBox_2")
    self._scrollView = bg:getChildByName("DownPanel"):getChildByName("ScrollView")
    self._scrollView:setScrollBarEnabled(false)
    
    self.oneText = self.btn_One:getChildByName("Text")
    self.redIcon = self.btn_One:getChildByName("Sprite")
    
    self._scrollHeight = self._scrollView:getContentSize().height
    self._scrollWidth = self._scrollView:getContentSize().width
    LotteryDrawItem.parentSize = 300
    
    self:updateData()

end

function LotteryDrawLayer:WhenClose()
    self:removeFromParent()
    dxyFloatMsg.isOpen = true
    --dxyDispatcher_removeEventListener("LotteryDrawLayer.startActionTwo", self, self.startActionTwo)
    --zzc.ChatController:unregisterListenner()
end

function LotteryDrawLayer:removeEvent()
    dxyFloatMsg.isOpen = true
    dxyDispatcher_removeEventListener("LotteryDrawLayer.startActionTwo", self, self.startActionTwo)
    dxyDispatcher_removeEventListener("LotteryDrawLayer_updateBtnTxt",self,self.updateBtnTxt)
end

function LotteryDrawLayer:initEvent()
    dxyFloatMsg.isOpen = false
    dxyDispatcher_addEventListener("LotteryDrawLayer.startActionTwo", self, self.startActionTwo)
    dxyDispatcher_addEventListener("LotteryDrawLayer_updateBtnTxt",self,self.updateBtnTxt)

    if(self.btn_back)then
        self.btn_back:addTouchEventListener(function(target,type)
            if(type==2)then
                zzc.LotteryDrawController:closeLayer()
            end
        end)
    end
    if (self.btn_One) then
        self.btn_One:addTouchEventListener(function(target,type)
            if type == 2 then
                zzc.LotteryDrawController:request_GetReawerd(1)
                self._clickType = 1
            end
        end)
    end
    if (self.btn_Ten) then
        self.btn_Ten:addTouchEventListener(function(target,type)
            if type == 2 then
                zzc.LotteryDrawController:request_GetReawerd(2)
                self._clickType = 2
            end
        end)
    end
    
    if (self._ckbOne) then
        self._ckbOne:addTouchEventListener(function(target,type)
            if type == 2 then
                self:onSelectByType(1)
            end
        end)
    end
    if (self._ckbTwo) then
        self._ckbTwo:addTouchEventListener(function(target,type)
            if type == 2 then
                self:onSelectByType(2)
            end
        end)
    end
    -- 拦截
    dxySwallowTouches(self)
end


---------------------------
--@param
--@return
function LotteryDrawLayer:startActionOne()
    self._rightPanel:stopAllActions()
	local rot = cc.RotateBy:create(10,360)
	local rep = cc.RepeatForever:create(rot)
	self._rightPanel:runAction(rep)
end


function LotteryDrawLayer:setButton(falg)
    self.btn_One:setTouchEnabled(falg)
    self.btn_One:setTouchEnabled(falg)
end

function LotteryDrawLayer:startActionTwo(data)
    self:setButton(false)
    self._rightPanel:stopAllActions()
    local R = self._rightPanel:getRotation()
    print("--------R: " .. R)
    r =  math.floor(R/360)
    print("--------r: " .. r)
    local i = data.index
    print("--------i: " .. i)
    --math.floor(R/360)*360
    local ret = 360*6 - 360*0.125*(i-1)
    print("--------ret: " .. ret)
    local rot = cc.RotateTo:create(1.5,ret)
    local easeSineInOut = cc.EaseSineInOut:create(rot)
    local fun1 = cc.CallFunc:create(
        function() 
            zzc.LotteryDrawController:request_EnterPanel()     
            if  data.type == 2 then
                self:setButton(true)
                zzc.LotteryDrawController:showRewardLayer()
            end
        end)
    local delay = cc.DelayTime:create(0.3)
    local fun2 = cc.CallFunc:create(
    function()  
        if data.type == 1 then
            self:setButton(true)
            self:setRewardData()
            self:startActionOne()
            self:floatReward()
        end
    end)
    local sequence = cc.Sequence:create(easeSineInOut,fun1,delay,fun2)
    self._rightPanel:runAction(sequence)
end

function LotteryDrawLayer:updateData()
    if self._clickType ~= 1 then
        self:setRewardData()
        self:startActionOne()
    end
    
    self:setCurrentRewardData()
    self:onSelectByType(self._currentTab)
 
end

function LotteryDrawLayer:onSelectByType(type)
        self._currentTab = type
        self._scrollHeight = 200
        self._scrollView:removeAllChildren()
        local dataList = zzm.LotteryDrawModel:getInfo(type)
        for index=1,#dataList do
            self:addInfoItem(dataList[index])
        end
end

function LotteryDrawLayer:addInfoItem(info)
    local item = LotteryDrawItem.create()
    self._scrollView:addChild(item)
    item:setPosition(0,self._scrollHeight)
    item:update(info)
    self._scrollHeight = self._scrollHeight + item:getItemHgight()
    self._scrollView:setInnerContainerSize(cc.size(self._scrollWidth,self._scrollHeight))
end

function LotteryDrawLayer:setCurrentRewardData()

    EquipItem.ItemNode = self._currentItem
    local data = zzm.LotteryDrawModel:getCurrentItem()
    local item = EquipItem:create()
    item:updateReward(data)
    item:setName("EquipItemCurrent")
    if data == nil then
        self._currentName:setString("")
    else
        self._currentName:setString(cn:GetRewardsInfo(data))
    end
end

function LotteryDrawLayer:setRewardData()
    
--    local oneText = self.btn_One:getChildByName("Text")
--    local redIcon = self.btn_One:getChildByName("Sprite")
    if self.oneText then
        local msg
        local count = zzm.LotteryDrawModel.freeChanceCount
        if count > 0 then
            msg = "免费\n抽"..count.."次"
            self.redIcon:setVisible(true)
        else
            msg = zzm.LotteryDrawModel._OneRMB .. "元宝\n抽1次"
            self.redIcon:setVisible(false)
        end
        
        self.oneText:setString(msg)
    end
    
    local tenText = self.btn_Ten:getChildByName("Text")
    if tenText then
        local msg  = zzm.LotteryDrawModel._TenRMB .. "元宝\n抽10次"
        tenText:setString(msg)
    end

    
    for i=1,8 do
        EquipItem.ItemNode = self._itemList[i]
        local item = EquipItem:create()
        local data = zzm.LotteryDrawModel:getReward(i)
        item:updateReward(data)
        --item:isShowEquipSmelt()
        item:setName("EquipItem"..i)
    end
end

function LotteryDrawLayer:updateBtnTxt()
    if self.oneText then
        local msg
        local count = zzm.LotteryDrawModel.freeChanceCount
        if count > 0 then
            msg = "免费\n抽"..count.."次"
            self.redIcon:setVisible(true)
        else
            msg = zzm.LotteryDrawModel._OneRMB .. "元宝\n抽1次"
            self.redIcon:setVisible(false)
        end

        self.oneText:setString(msg)
    end
   
end

function LotteryDrawLayer:floatReward()
    dxyFloatMsg.isOpen = true
    local data = zzm.LotteryDrawModel:getCurrentItem()
    if data then
       dxyFloatMsg:show("获得"..cn:GetRewardsInfo(data))
       dxyFloatMsg.isOpen = false
    end
end
