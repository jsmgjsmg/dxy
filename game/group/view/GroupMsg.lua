GroupMsg = GroupMsg or class("GroupMsg",function()
    return cc.Node:create()
end)
local HEIGHT = 72

function GroupMsg:ctor()
    self.visibleSize = cc.Director:getInstance():getVisibleSize()
    self.origin = cc.Director:getInstance():getVisibleOrigin()
    self._arrHisMember = {}
end

function GroupMsg:create(data)
    local node = GroupMsg:new()
    node:init(data)
    return node
end

function GroupMsg:init(data)
    self._csb = cc.CSLoader:createNode("res/dxyCocosStudio/csd/ui/group/GroupMsg.csb")
    self:addChild(self._csb)
    self._csb:setPosition(self.origin.x + self.visibleSize.width / 2, self.origin.y + self.visibleSize.height / 2)

    -- 拦截
    dxySwallowTouches(self)

    self._data = data
    dxyExtendEvent(self)
    zzc.GroupController:AskMemberList(self._data["Id"])
    
--back    
    self._btnBack = self._csb:getChildByName("bgDoor"):getChildByName("btn_back")
    self._btnBack:addTouchEventListener(function(target,type)
        if type == 2 then
            SoundsFunc_playSounds(SoundsType.CLOSE_PAGE,false)
            self:removeFromParent()
        end
    end)
    
--sv
    local _ndRight = self._csb:getChildByName("nd_right")
    self._sv = _ndRight:getChildByName("sv_player")
    self._sv:setScrollBarEnabled(false)
    
--条件
    local condition = _ndRight:getChildByName("condition")
    local txtPower = condition:getChildByName("txt_power")
    if data["Auto"] == 1 then
        condition:setVisible(true)
        txtPower:setString(self._data.PowerLimit)
    end
    
--left
    local ndLeft = self._csb:getChildByName("nd_left")
    self._txtName = ndLeft:getChildByName("txt_name")
    self._txtName:setString(data["Name"])    
        
    self._txtMaster = ndLeft:getChildByName("txt_master")
    self._txtMaster:setString(data["Master"])    
        
    self._txtLv = ndLeft:getChildByName("txt_lv")
    self._txtLv:setString(data["Lv"])    
        
    self._txtNum = ndLeft:getChildByName("txt_num")
    self._txtNum:setString(data["Num"])
    local posx = self._txtNum:getPositionX()
    local width = self._txtNum:getContentSize().width

    self._txtMax = ndLeft:getChildByName("txt_max")
    local SociatyLv = GroupConfig:getSociatyLv(data["Lv"])
    self._txtMax:setString("/"..SociatyLv.MemberMax)
    self._txtMax:setPositionX(posx+width)
        
    self._txtRank = ndLeft:getChildByName("txt_rank")
    self._txtRank:setString(data["Rank"])

    self._txtTenet = ndLeft:getChildByName("bg"):getChildByName("txt_introduce")
    self._txtTenet:setString(data["Tenet"])    

--right
    local ndRight = self._csb:getChildByName("nd_right")
    local btnAsk = ndRight:getChildByName("btn_ask")
    btnAsk:addTouchEventListener(function(target,type)
        if type == 2 then
            SoundsFunc_playSounds(SoundsType.UNIVERSAL_BTN,false)
            zzc.GroupController:JoinGroup(self._data["Id"])
        end
    end)
    
end

function GroupMsg:initEvent()
    dxyDispatcher_addEventListener("addHisMember",self,self.addHisMember)
end

function GroupMsg:removeEvent()
    dxyDispatcher_removeEventListener("addHisMember",self,self.addHisMember)
end

function GroupMsg:addHisMember(data)
    for i=1,#data do
        require "src.game.group.view.HisMember"
        self._arrHisMember[i] = HisMember:create(data[i])
        self._sv:addChild(self._arrHisMember[i])
    end
    self:setPos()
--    local len = #self._arrHisMember + 1
--    require "src.game.group.view.HisMember"
--    self._arrHisMember[len] = HisMember:create(data)
--    self._sv:addChild(self._arrHisMember[len])
--    local data = self._arrHisMember[len]._data
--    self:setPos()
end 

function GroupMsg:setPos()
    local len = #self._arrHisMember
    local content = self._sv:getContentSize()
    local real = len * HEIGHT
    local last = content.height > real and content.height or real
    self._sv:setInnerContainerSize(cc.size(content.width,last))
    for i=1,len do
        self._arrHisMember[i]:setPosition(0,last-(i-1)*HEIGHT)
    end
end
