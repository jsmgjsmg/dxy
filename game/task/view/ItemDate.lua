local ItemDate = class("ItemDate",function()
    return ccui.Button:create("dxyCocosStudio/png/task/new/bg3.png","dxyCocosStudio/png/task/new/bg5.png","dxyCocosStudio/png/task/new/bg5.png")
end)

function ItemDate:ctor()

end

function ItemDate:create(day)
    local node = ItemDate:new()
    node:initItem(day)
    return node
end

function ItemDate:initItem(day)
    self._csb = cc.CSLoader:createNode("res/dxyCocosStudio/csd/ui/task/ItemDate.csb")
    local conSize = self:getContentSize()
    self:addChild(self._csb)
    self:setAnchorPoint(0,1)
    self._csb:setPosition(conSize.width/2,conSize.height/2)
    
    local ndBtn = self._csb:getChildByName("ndBtn")
    self._icon = self._csb:getChildByName("icon")
    self._bu = self._csb:getChildByName("bu")
    self._txtDay = self._csb:getChildByName("txtDay")
    self._txtNum = self._csb:getChildByName("txtNum")
    self._bibao = self._csb:getChildByName("bibao")
    self._txtLv = self._bibao:getChildByName("lv")
    self._spGet = self._csb:getChildByName("get")
    self._light = self._csb:getChildByName("light")
    
    self:setTouchEnabled(false)
    self:addTouchEventListener(function(target,type)
        if type == 2 then
            SoundsFunc_playSounds(SoundsType.UNIVERSAL_BTN,false)
            if self._arrLogin.State == 1 then
                zzc.TaskController:registerGetLogin()
            elseif self._arrLogin.State == 2 then
                local tips = (require "src.game.task.view.TipsMakeUp"):create()
                local scene = SceneManager:getCurrentScene()
                scene:addChild(tips)
            end
        end
    end)
    
    self._Rewards = TaskConfig:getRewardByDay(day)

    --icon
    self._icon:setTexture("Icon/"..self._Rewards.Icon)
    --bibao
    if self._Rewards.Vip > 0 then
        self._bibao:setVisible(true)
        self._txtLv:setString(self._Rewards.Vip)
    end
    --num
    if self._Rewards.Rewards.Num then
        self._txtNum:setString("×"..self._Rewards.Rewards.Num)
    end
    --day
    self._txtDay:setString(self._Rewards.Days.."天")

end

function ItemDate:update(day)
    self._day = day
    self._arrLogin = zzm.TaskModel.arrLogin
    local today = tonumber(os.date("%d",os.time()))
    self._arrLogin.Start = self._arrLogin.Start == 0 and 1 or self._arrLogin.Start
--    today = 1
--get
    if self._arrLogin.State == 1 then --今天未领取
        if self._Rewards.Days <= self._arrLogin.Day then --已领取
            self:setTouchEnabled(false)
            self:setBright(false)
            self._spGet:setVisible(true)
        elseif self._Rewards.Days == self._arrLogin.Day + 1 and self._arrLogin.Day + 1 <= today then --当天
            self:setTouchEnabled(true)
            self._spGet:setVisible(false)
    
            self._effect = require ("game.task.view.DateEffect"):create()
            self._csb:addChild(self._effect)
        else                                 --之后
            self._spGet:setVisible(false)
            self:setTouchEnabled(false)
        end
    elseif self._arrLogin.State == 2 then  --今天已领取
        if self._Rewards.Days <= self._arrLogin.Day then --已领取部分
            self:setTouchEnabled(false)
            self:setBright(false)
            self._spGet:setVisible(true)
            self._bu:setVisible(false)

            self._light:setVisible(false)
            if self._effect then
                self._csb:removeChild(self._effect)
                self._effect = nil
            end
        elseif self._Rewards.Days == self._arrLogin.Day + 1 and self._arrLogin.Start + self._arrLogin.Day <= today then --可补签
            self:setTouchEnabled(true)
            self._bu:setVisible(true)
            self._spGet:setVisible(false)
        else --其他
            self._spGet:setVisible(false)
            self:setTouchEnabled(false)
        end
    end
end

function ItemDate:whenClose()
    if self._effect then
        self._csb:removeChild(self._effect)
        self._effect = nil
    end
end

return ItemDate