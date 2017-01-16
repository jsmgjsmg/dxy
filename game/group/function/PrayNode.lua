PrayNode = PrayNode or class("PrayNode",function()
    return cc.Node:create()
end)
require("game.group.function.ItemPrayLog")
local SPACE = 55

function PrayNode:ctor()
    self.visibleSize = cc.Director:getInstance():getVisibleSize()
    self.origin = cc.Director:getInstance():getVisibleOrigin()
    self.arrPrayLog = {}
end

function PrayNode:create()
    local node = PrayNode.new()
    node:init()
    return node
end

function PrayNode:init()
    self._csb = cc.CSLoader:createNode("dxyCocosStudio/csd/ui/groupfunc/PrayNode.csb")
    self:addChild(self._csb)
    self._csb:setPosition(self.origin.x + self.visibleSize.width / 2, self.origin.y + self.visibleSize.height / 2)
   
    dxyExtendEvent(self)
    -- 拦截
    dxySwallowTouches(self)
    zzc.GroupController:getPrayLog()
    
    self.GroupData = zzm.GroupModel.GroupData
    self.MyData = zzm.GroupModel:getMyDataInGroup(_G.RoleData.Uid)
    
    local btnBack = self._csb:getChildByName("btnBack")
    btnBack:addTouchEventListener(function(target,type)
        if type == 2 then
            zzc.GroupFuncCtrl:removePrayNode()
        end
    end) 
    
    self._btnPrayGold = self._csb:getChildByName("btnPrayGold")
    self._btnPrayGold:setPressedActionEnabled(true)
    self._btnPrayGold:addTouchEventListener(function(target,type)
        if type == 2 then
			SoundsFunc_playSounds(SoundsType.UNIVERSAL_BTN,false)
            zzc.GroupController:Pray(1) --金币
        end
    end) 
    self._txtPrayGold = self._btnPrayGold:getChildByName("txtGold")
    
    self._btnPrayYB = self._csb:getChildByName("btnPrayYB")
    self._btnPrayYB:setPressedActionEnabled(true)
    self._btnPrayYB:addTouchEventListener(function(target,type)
        if type == 2 then
			SoundsFunc_playSounds(SoundsType.UNIVERSAL_BTN,false)
            zzc.GroupController:Pray(2) --元宝
        end
    end) 
    self._txtPrayYB = self._btnPrayYB:getChildByName("txtYB")
    
    self._SV = self._csb:getChildByName("ScrollView")
    self._SV:setScrollBarEnabled(false)
    
---add---    
    self._ndAttrG = self._csb:getChildByName("ndAttrG")
    self._txtExpG = self._ndAttrG:getChildByName("txtExpG")
    self._txtJfG = self._ndAttrG:getChildByName("txtJfG")
    self._txtGxG = self._ndAttrG:getChildByName("txtGxG")
    self._txtSurG = self._ndAttrG:getChildByName("txtSurG")
    
    self._ndAttrR = self._csb:getChildByName("ndAttrR")
    self._txtExpR = self._ndAttrR:getChildByName("txtExpR")
    self._txtJfR = self._ndAttrR:getChildByName("txtJfR")
    self._txtGxR = self._ndAttrR:getChildByName("txtGxR")
    self._txtSurR = self._ndAttrR:getChildByName("txtSurR")
---------
    
    self:updatePrayUse({Lv=self.GroupData.Lv,Num=self.MyData.praynum,NumRmb=self.MyData.praynum_rmb})
end

function PrayNode:initEvent()
    dxyDispatcher_addEventListener("PrayNode_updatePrayUse",self,self.updatePrayUse)
    dxyDispatcher_addEventListener("PrayNode_addItemLog",self,self.addItemLog)
    dxyDispatcher_addEventListener("PrayNode_updateItemLog",self,self.updateItemLog)
end

function PrayNode:removeEvent()
    dxyDispatcher_removeEventListener("PrayNode_updatePrayUse",self,self.updatePrayUse)
    dxyDispatcher_removeEventListener("PrayNode_addItemLog",self,self.addItemLog)
    dxyDispatcher_removeEventListener("PrayNode_updateItemLog",self,self.updateItemLog)
end

function PrayNode:updatePrayUse(data)
    local num = data.Num + 1
    local rmbnum = data.NumRmb + 1
    if rmbnum > GroupConfig:getPrayLen(data.Lv) then
        self._btnPrayYB:setTouchEnabled(false)
        self._btnPrayYB:setBright(false)
        self._txtPrayYB:setString(0)
        self._txtExpR:setString(0)
        self._txtJfR:setString(0)
        self._txtGxR:setString("剩余次数:0")
    else
        local config = GroupConfig:getPrayConfig(data.Lv,rmbnum)
        self._txtPrayYB:setString(config.RmbPray)
        self._txtExpR:setString(config.Exp)
        self._txtJfR:setString(config.Integral)
        self._txtGxR:setString(config.Feats)
        self._txtSurR:setString("剩余次数:"..(18-data.NumRmb))
    end
    
    local config2 = GroupConfig:getPrayConfig(data.Lv,num)
    if config2.GoldPray == 0 then
        self._btnPrayGold:setTouchEnabled(false)
        self._btnPrayGold:setBright(false)
        self._txtSurG:setString("剩余次数:0")
    else
        self._txtSurG:setString("剩余次数:"..GroupConfig:getGoldPrayNum(data.Lv)-data.Num)
    end
    self._txtPrayGold:setString(config2.GoldPray)
    self._txtExpG:setString(config2.Exp)
    self._txtJfG:setString(config2.Integral)
    self._txtGxG:setString(config2.Feats)
end

function PrayNode:addItemLog()
    local model = zzm.GroupModel.PrayLogData
    local last = cn:setSVSize(self._SV,"height",#model,SPACE)
    for i=1,#model do
        local item = ItemPrayLog:create()
        item:update(model[i])
        self._SV:addChild(item)
        table.insert(self.arrPrayLog,item)
        item:setPosition(0,last-(i-1)*SPACE)
    end
end

function PrayNode:updateItemLog()
    local model = zzm.GroupModel.PrayLogData
    for i=1,#model do
        self.arrPrayLog[i]:update(model[i])
    end
end