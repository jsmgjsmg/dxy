GroupShop = GroupShop or class("GroupShop",function()
    return cc.Node:create()
end)
require("game.group.function.ItemGroupShop")
local SPACE_WIDTH = 190
local SPACE_HEIGHT = 190
local MAX_X = 4

function GroupShop:ctor()
    self.visibleSize = cc.Director:getInstance():getVisibleSize()
    self.origin = cc.Director:getInstance():getVisibleOrigin()
    self._arrItem = {}
    self._initType = 1
end

function GroupShop:create()
    local node = GroupShop.new()
    node:init()
    return node
end

function GroupShop:init()
    self._csb = cc.CSLoader:createNode("dxyCocosStudio/csd/ui/groupfunc/GroupShop.csb")
    self:addChild(self._csb)
    self._csb:setPosition(self.origin.x + self.visibleSize.width / 2, self.origin.y + self.visibleSize.height / 2)

    dxyExtendEvent(self)
    -- 拦截
    dxySwallowTouches(self)

    self._txtJF = self._csb:getChildByName("txtJF")
    self._txtYB = self._csb:getChildByName("txtYB")

    local btnBack = self._csb:getChildByName("btnBack")
    btnBack:addTouchEventListener(function(target,type)
        if type == 2 then
			SoundsFunc_playSounds(SoundsType.CLOSE_PAGE,false)
            self:stopTimer()
            self:removeFromParent()
        end
    end)
    
    self._sv = self._csb:getChildByName("ScrollView")
    self._sv:setScrollBarEnabled(false)
    
    self._cbYB = self._csb:getChildByName("cbYB")
    self._cbJF = self._csb:getChildByName("cbJF")
    self._cbYB:addEventListener(function(target,type)
        local is = target:isSelected()
        if is then
            self._cbJF: setSelected(false)
            self:changeValue(1)
        end
    end)
    self._cbJF:addEventListener(function(target,type)
        local is = target:isSelected()
        if is then
            self._cbYB: setSelected(false)
            self:changeValue(2)
        end
    end)
    
    self._txtTimer = self._csb:getChildByName("txtTimer")
    
    self:update(zzm.GroupModel.GroupShopData)
    self:updateJF()
    self:GroupShop_updateYB()
    self:updateTimer()
end 

function GroupShop:initEvent()
    dxyDispatcher_addEventListener("GroupShop_changeItemShop",self,self.changeItemShop)
    dxyDispatcher_addEventListener("GroupShop_updateJF",self,self.updateJF)
    dxyDispatcher_addEventListener(dxyEventType.Character_AttrUpdate,self,self.GroupShop_updateYB)
end

function GroupShop:removeEvent()
    dxyDispatcher_removeEventListener("GroupShop_changeItemShop",self,self.changeItemShop)
    dxyDispatcher_removeEventListener("GroupShop_updateJF",self,self.updateJF)
    dxyDispatcher_removeEventListener(dxyEventType.Character_AttrUpdate,self,self.GroupShop_updateYB)
end

function GroupShop:update(data)
    if data then
        self._sv:removeAllChildren()
    end
    
    local num = math.ceil(#data / MAX_X)
    local last = cn:setSVSize(self._sv,"height",num,SPACE_HEIGHT)
    local x = 0 
    local y = 1   
    for i=1,#data do
        x = x + 1
        if x > MAX_X then
            x = 1
            y = y + 1
        end
        local posx = (x-1)*SPACE_WIDTH
        local posy = last-(y-1)*SPACE_HEIGHT
        local item = ItemGroupShop:create()
        item:update(data[i])
        self._sv:addChild(item)
        table.insert(self._arrItem,item)
        item:setPosition(posx,posy)
    end
    self:changeValue(self._initType)
end

function GroupShop:changeItemShop(data)
    for key, var in pairs(self._arrItem) do
    	if var.m_data.Box == data.Box then
            var:update(data)
            break
    	end
    end
end

function GroupShop:changeValue(type)
    for key, var in pairs(self._arrItem) do
    	var:changeValue(type)
    end
    self._initType = type
end

function GroupShop:updateJF()
    self._txtJF:setString(zzm.GroupModel:getMyDataInGroup(_G.RoleData.Uid).integral)
end

function GroupShop:GroupShop_updateYB()
    local role = zzm.CharacterModel:getCharacterData()
    local enCAT = enCharacterAttrType
    self._txtYB:setString(role:getValueByType(enCAT.RMB))
end

function GroupShop:updateTimer()
    local curOS = os.time() - _G.DiffTimer
    local H = os.date("%H",curOS) * 3600
    local M = os.date("%M",curOS) * 60
    local S = os.date("%S",curOS)
    local ALL = H + M + S
    local cut = 0
    if ALL < 10800 then -- 10800(刷新点时间戳)
        cut = 10800 - ALL
    elseif ALL > 10800 then
        local allS = 24 * 3600
        cut = allS - (ALL - 10800)
    end
    if not self.m_Timer then
        self.m_Timer = self.m_Timer or require("game.utils.MyTimer").new()
        local h = os.date("%H",cut)-8
        local m = os.date("%M",cut)
        local s = os.date("%S",cut)
        local str = string.format("%02d",h)..":"..string.format("%02d",m)..":"..string.format("%02d",s)
        self._txtTimer:setString(str)
        local function tick()
            cut = cut - 1
            if cut >= 0 then
                local h = os.date("%H",cut)-8
                local m = os.date("%M",cut)
                local s = os.date("%S",cut)
                local str = string.format("%02d",h)..":"..string.format("%02d",m)..":"..string.format("%02d",s)
                self._txtTimer:setString(str)
            else
                self:stopTimer()
                self:updateTimer()
            end
        end
        self.m_Timer:start(1,tick)
    end
end

function GroupShop:stopTimer()
    if self.m_Timer then
        self.m_Timer:stop()
        self.m_Timer = nil
    end
end