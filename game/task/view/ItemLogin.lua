ItemLogin = ItemLogin or class("ItemLogin",function()
    return cc.Node:create()
end)
local SPACE = 95

function ItemLogin:ctor()
    self._arrItem = {}
end

function ItemLogin:create()
    local node = ItemLogin:new()
    node:initItem()
    return node
end

function ItemLogin:initItem()
    self._csb = cc.CSLoader:createNode("dxyCocosStudio/csd/ui/task/ItemLogin.csb")
    self:addChild(self._csb)

    dxyExtendEvent(self)

--SV
    self._SV = self._csb:getChildByName("ScrollView")
    self._SV:setScrollBarEnabled(false)
    local year = tonumber(os.date("%Y",os.time()))
    local month = tonumber(os.date("%m",os.time()))
    self._today = tonumber(os.date("%d",os.time()))
    
    local day = zzd.TaskData.arrMonthDate[month]
    if month == 2 then
        day = cn:February(year)
    end
    
    local num = 0
    if day % 7 == 0 then
        num = 4
    else
        num = 5
    end
    
    local contSize = self._SV:getContentSize()
    local realHeight = SPACE * num
    local endHeight = contSize.height > realHeight and contSize.height or realHeight
    self._SV:setInnerContainerSize(cc.size(contSize.width,endHeight))
    local x = 0 
    local y = 1   
    for i=1,day do
        x = x + 1
        if x > 7 then
            x = 1
            y = y + 1
        end
        local posx = (x-1)*SPACE
        local posy = endHeight-(y-1)*SPACE
        local item = require ("src.game.task.view.ItemDate"):create(i)
        item:setName("ItemDate"..i)
        item:update(i)
        self._SV:addChild(item)
        table.insert(self._arrItem,item)
        item:setPosition(posx,posy)
    end
    
--ndMonth    
    local ndMonth = self._csb:getChildByName("ndMonth")
    self._txtMonth = ndMonth:getChildByName("txtMonth")
    self._txtAll = ndMonth:getChildByName("txtAll")
    self._txtSur = ndMonth:getChildByName("txtSur")
    
    local arrLogin = zzm.TaskModel.arrLogin
    self._txtMonth:setString(month.."月")
    self._txtAll:setString(arrLogin.Day)
    self._txtSur:setString(self._today - arrLogin.Start - arrLogin.Day < 0 and 0 or self._today - arrLogin.Start - arrLogin.Day)
    
    self._btnExtra = ndMonth:getChildByName("btnExtra")
    if arrLogin.AllFinish == 1 then
        self._btnExtra:setBright(true)
    else
        self._btnExtra:setBright(false)
    end
    self._btnExtra:addTouchEventListener(function(target,type)
        if type == 2 then
            SoundsFunc_playSounds(SoundsType.OPEN_PAGE,false)
            if arrLogin.AllFinish == 1 then
                zzc.TaskController:registerGetAllFinish()
            else
                local rewards = dxyConfig_toList(TaskConfig:getAllFinish())
                local str = "" 
                for i=1,#rewards do
                    local goods = GoodsConfigProvider:findGoodsById(rewards[i].Id)
                    str = str..goods.Name.." ×"..rewards[i].Num.."\n"
                end
                if str ~= "" then
                    TipsFrame:create(str)
                end
            end
        end
    end)
end

function ItemLogin:initEvent()
    dxyDispatcher_addEventListener("ItemLogin_updateExtra",self,self.updateExtra)
    dxyDispatcher_addEventListener("ItemLogin_whenClose",self,self.whenClose)
    dxyDispatcher_addEventListener("ItemLogin_changeItem",self,self.changeItem)
end

function ItemLogin:removeEvent() 
    dxyDispatcher_removeEventListener("ItemLogin_updateExtra",self,self.updateExtra)
    dxyDispatcher_removeEventListener("ItemLogin_whenClose",self,self.whenClose)
    dxyDispatcher_removeEventListener("ItemLogin_changeItem",self,self.changeItem)
end

function ItemLogin:changeItem()
    for key=1,#self._arrItem do
        self._arrItem[key]:update(key)
    end
    local arrLogin = zzm.TaskModel.arrLogin
    self._txtAll:setString(arrLogin["Day"])
    self._txtSur:setString(self._today - arrLogin.Start - arrLogin.Day < 0 and 0 or self._today - arrLogin.Start - arrLogin.Day)
end

function ItemLogin:updateExtra()
    self._btnExtra:setBright(false)
end

function ItemLogin:whenClose()
    for i=1,#self._arrItem do
        if self._arrItem[i]._effect then
            self._arrItem[i]:whenClose()
        end
    end
end
