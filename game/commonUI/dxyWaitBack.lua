--[[
-- 成对出现，发协议时show，收到时close
-- 如果一条请求多条协议返回，可以在指定返回协议后close，如果想任意返回关闭就每条都加close
dxyWaitBack:show()
dxyWaitBack:close()
-------------------------
-- 多条协议返回收到任意一条就关闭菊花
dxyWaitBack:show({NetEventType.Rec_Swallow_Succeed})
-------------------------
-- 一条协议返回就关闭菊花
dxyWaitBack:show(NetEventType.Rec_Swallow_Succeed)
--]]

dxyWaitBack = dxyWaitBack or class("dxyWaitBack",function()
    return cc.Node:create()
end)

function dxyWaitBack:ctor()
    self._csbNode = nil
    self._proIdList = nil
    self:initUI()
    self:initEvent()
end

function dxyWaitBack:initUI()
    self._csbNode = cc.CSLoader:getInstance():createNodeWithFlatBuffersFile("dxyCocosStudio/csd/ui/commonUI/WaitBack.csb")
    self:addChild(self._csbNode)

    self.visibleSize = cc.Director:getInstance():getVisibleSize()
    self.origin = cc.Director:getInstance():getVisibleOrigin()
    
    local posX = self.origin.x + self.visibleSize.width/2
    local posY = self.origin.y + self.visibleSize.height/2

    self:setPosition(posX, posY)
    
    self.image = self._csbNode:getChildByName("Image")
    self.image:setVisible(false)
    

    self.action = cc.RepeatForever:create(cc.RotateBy:create(0.5,360))
    self.action:retain()
end


function dxyWaitBack:startRunAction()
    self.image:setVisible(true)
    self.image:runAction(self.action)
end

function dxyWaitBack:initEvent()

    -- 拦截
    dxySwallowTouches(self)
end

function dxyWaitBack:acceptNetProId(proId)
    if self.isShow and self._proIdList ~= nil then
        local proType = type(self._proIdList)
        if proType == "number" then
            if self._proIdList == proId then
                self:close()
                return
            end
        elseif proType == "table" then
            for key, id in pairs(self._proIdList) do
                if id == proId then
                    self:close()
                    return
                end
            end
        end
    end
end

function dxyWaitBack:show(proIdList, isAuto)
    if self.isShow then return end
    self._proIdList = proIdList
    if not self.layer then
        self.layer = dxyWaitBack.new()
        self.layer:retain()
    end
    --self.layer:startRunAction()
    self.isShow = true
    self:waitTimesDisplay(1)
    if isAuto == true then
        self:waitTimesClose(6)
    end
    SceneManager:getCurrentScene():addChild(self.layer) 
end

function dxyWaitBack:setImageVisible(flag)
    self.image:setVisible(flag)
end

function dxyWaitBack:waitTimesDisplay(time)
    local deleTime = 0
    self._myDisplayTimer = self._myDisplayTimer or require("game.utils.MyTimer").new()
    local function tick()
        self._myDisplayTimer:stop()
        self._myDisplayTimer = nil
        self.layer:startRunAction()
    end
    self._myDisplayTimer:start(time, tick)
end

function dxyWaitBack:waitTimesClose(time)
    local deleTime = 0
    self._myDelayTimer = self._myDelayTimer or require("game.utils.MyTimer").new()
    local function tick()
        deleTime = deleTime + 1
        if deleTime > time then
        	deleTime = 0
        	dxyFloatMsg:show("网络不稳定，尝试重新链接！")
        	self:close()
        end
    end
    self._myDelayTimer:start(1, tick)
end

function dxyWaitBack:close()
    if self.isShow then 
        self.layer:removeFromParent() 
        self.isShow = false
        self._proIdList = nil
        if self._myDelayTimer then
            self._myDelayTimer:stop()
            self._myDelayTimer = nil
        end
        if self._myDisplayTimer then
            self._myDisplayTimer:stop()
            self._myDisplayTimer = nil
        end
    end
end