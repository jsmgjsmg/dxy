local GroupAskFor = GroupAskFor or class("GroupAskFor",function()
    return cc.Node:create()
end)
local HEIGHT = 75

function GroupAskFor:ctor()
    self.visibleSize = cc.Director:getInstance():getVisibleSize()
    self.origin = cc.Director:getInstance():getVisibleOrigin()
    self._arrItem = {}
end

function GroupAskFor:create()
    local node = GroupAskFor:new()
    node:init()
    return node
end

function GroupAskFor:init()
    self._csb = cc.CSLoader:createNode("dxyCocosStudio/csd/ui/group/GroupAskFor.csb")
    self:addChild(self._csb)
    self._csb:setPosition(self.origin.x + self.visibleSize.width / 2, self.origin.y + self.visibleSize.height / 2)

    dxyExtendEvent(self)
    
    self._GroupData = zzm.GroupModel.GroupData

--sv
    self._sv = self._csb:getChildByName("ScrollView")
    self._sv:setScrollBarEnabled(false)
    local AskForList = zzm.GroupModel.AskForList
    local len = #AskForList
    for i=1,len do
        self:addAsk(AskForList[i])
    end
    
--btn
    local ndBtn = self._csb:getChildByName("nd_btn")
    local _btnSet = ndBtn:getChildByName("btn_set")
    _btnSet:addTouchEventListener(function(target,type)
        if type == 2 then
            SoundsFunc_playSounds(SoundsType.OPEN_PAGE,false)
            if GroupConfig:getRoot(zzm.GroupModel:getRoot(_G.RoleData.Uid))["RecruitNews"] then
                require "src.game.group.view.SetPower"
                local power = SetPower:create()
                self:addChild(power)
            else
                TipsFrame:create("你的权限不足")
            end
        end
    end)
    local _btnIssue = ndBtn:getChildByName("btn_issue")
    _btnIssue:addTouchEventListener(function(target,type)
        SoundsFunc_playSounds(SoundsType.UNIVERSAL_BTN,false)
        if type == 2 then
            if GroupConfig:getRoot(zzm.GroupModel:getRoot(_G.RoleData.Uid))["RecruitNews"] then
                zzc.GroupController:IssueJoin(self._GroupData.PowerLimit,"滚蛋吧，肿瘤君")
            else
                TipsFrame:create("你的权限不足")
            end
        end
    end)
    local _btnRefuse = ndBtn:getChildByName("btn_refuse")
    _btnRefuse:addTouchEventListener(function(target,type)
        if type == 2 then
            SoundsFunc_playSounds(SoundsType.UNIVERSAL_BTN,false)
            if GroupConfig:getRoot(zzm.GroupModel:getRoot(_G.RoleData.Uid))["PermitEnter"] then
                zzc.GroupController:ResufeAll()
            else
                TipsFrame:create("你的权限不足")
            end
        end       
    end)    
end

function GroupAskFor:initEvent()
    dxyDispatcher_addEventListener("addAsk",self,self.addAsk)
    dxyDispatcher_addEventListener("delAsk",self,self.delAsk)
    dxyDispatcher_addEventListener("delAsk_Id",self,self.delAsk_Id)
    dxyDispatcher_addEventListener("delAllAsk",self,self.delAllAsk)
end

function GroupAskFor:removeEvent()
    dxyDispatcher_removeEventListener("addAsk",self,self.addAsk)
    dxyDispatcher_removeEventListener("delAsk",self,self.delAsk)
    dxyDispatcher_removeEventListener("delAsk_Id",self,self.delAsk_Id)
    dxyDispatcher_removeEventListener("delAllAsk",self,self.delAllAsk)
end

function GroupAskFor:addAsk(data)
    require "src.game.group.view.ItemAskFor"
    local item = ItemAskFor:create(self._sv)
    item:setData(data)
    self._sv:addChild(item)
    table.insert(self._arrItem,item)
    self:updatePos()
end

function GroupAskFor:delAsk(data)
    for key, var in pairs(self._arrItem) do
        if var._data["Uid"] == data["uid"] then
            table.remove(self._arrItem,key)
            self._sv:removeChild(var)
            self:updatePos()
            break
        end
    end
end

function GroupAskFor:delAsk_Id(id)
    for key, var in ipairs(self._arrItem) do
        if var._data["Id"] == id then
            table.remove(self._arrItem,key)
            self._sv:removeChild(var)
            self:updatePos()
            break
        end
    end
end

function GroupAskFor:delAllAsk()
    self._sv:removeAllChildren()
    self._arrItem = {}
    self._sv:removeAllChildren()
    self:updatePos()
end


function GroupAskFor:updatePos()
    local len = #self._arrItem
    local content = self._sv:getContentSize()
    local real = len * HEIGHT
    local last = content.height > real and content.height or real
    self._sv:setInnerContainerSize(cc.size(content.width,last))
    for i=1,len do
        self._arrItem[i]:setPosition(0,last-(i-1)*HEIGHT)
    end
end

return GroupAskFor