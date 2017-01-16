local GroupMember = GroupMember or class("GroupMember",function()
    return cc.Node:create()
end)
local HEIGHT = 77

function GroupMember:ctor()
    self.visibleSize = cc.Director:getInstance():getVisibleSize()
    self.origin = cc.Director:getInstance():getVisibleOrigin()
    self.arrMember = {}
    self.arrBtn = {}
end

function GroupMember:create()
    local node = GroupMember:new()
    node:init()
    return node
end

function GroupMember:init()
    self._csb = cc.CSLoader:createNode("dxyCocosStudio/csd/ui/group/GroupMember.csb")
    self:addChild(self._csb)
    self._csb:setPosition(self.origin.x + self.visibleSize.width / 2, self.origin.y + self.visibleSize.height / 2)

    dxyExtendEvent(self)
    
--sv
    self._sv = self._csb:getChildByName("ScrollView")
    self._sv:setScrollBarEnabled(false)
    local member = zzm.GroupModel.MemberData
    for i=1,#member do
        self:addMember(member[i])
    end
end


function GroupMember:initEvent()
    dxyDispatcher_addEventListener("addMember",self,self.addMember)
    dxyDispatcher_addEventListener("changeMember",self,self.changeMember)
    dxyDispatcher_addEventListener("updatePower",self,self.updatePower)
    dxyDispatcher_addEventListener("delMember",self,self.delMember)
end

function GroupMember:removeEvent()
    dxyDispatcher_removeEventListener("addMember",self,self.addMember)
    dxyDispatcher_removeEventListener("changeMember",self,self.changeMember)
    dxyDispatcher_removeEventListener("updatePower",self,self.updatePower)
    dxyDispatcher_removeEventListener("delMember",self,self.delMember)
end

function GroupMember:addMember(data)
    local len = #self.arrMember+1
    local content = self._sv:getContentSize()
    local real = len * HEIGHT
    local last = content.height > real and content.height or real
    self._sv:setInnerContainerSize(cc.size(content.width,last))
    
    require "src.game.group.view.MyMember"
    local arr = {[1]=self._sv,[2]=2,[3]=last-(len-1)*HEIGHT-2}
    local item = MyMember:create(arr)
    item:setData(data)
    table.insert(self.arrMember,item)
    table.insert(self.arrBtn,item._btnMem)
    self._sv:addChild(item,2)
    self:setPos()
end

function GroupMember:changeMember(data)
    for key, var in pairs(self.arrMember) do
    	if var._data["uid"] == data["uid"] then
            var:changeRoot(data)
    	end
    end
end

function GroupMember:updatePower(data)
    for key, var in pairs(self.arrMember) do
        if var._data["uid"] == data["uid"] then
            var:updatePower(data)
        end
    end
end

function GroupMember:delMember(uid)
    for key, var in ipairs(self.arrMember) do
    	if var._data["uid"] == uid then
            table.remove(self.arrMember,key)
            table.remove(self.arrBtn,key)
            self._sv:removeChild(var._btnMem)
            self._sv:removeChild(var)
            self:setPos()
            break
    	end
    end
end

function GroupMember:setPos()
    local len = #self.arrMember
    local content = self._sv:getContentSize()
    local real = len * HEIGHT
    local last = content.height > real and content.height or real
    self._sv:setInnerContainerSize(cc.size(content.width,last))
    for i=1,len do
        self.arrMember[i]:setPosition(0,last-(i-1)*HEIGHT)
        self.arrBtn[i]:setPosition(0,last-(i-1)*HEIGHT)
    end
end

return GroupMember