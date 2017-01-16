local GroupMsg = class("GroupMsg",function()
    return cc.Node:create()
end)
local HEIGHT = 72

function GroupMsg:ctor()
    self.visibleSize = cc.Director:getInstance():getVisibleSize()
    self.origin = cc.Director:getInstance():getVisibleOrigin()
    self._arrHisMember = {}
end

function GroupMsg:create()
    local node = GroupMsg:new()
    node:init()
    return node
end

function GroupMsg:init()
    self._csb = cc.CSLoader:createNode("res/dxyCocosStudio/csd/ui/group/GroupMsg.csb")
    self:addChild(self._csb)
    self._csb:setPosition(self.origin.x + self.visibleSize.width / 2, self.origin.y + self.visibleSize.height / 2)

    -- 拦截
    dxySwallowTouches(self)

    dxyExtendEvent(self)

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

    --条件
    self._condition = _ndRight:getChildByName("condition")
    self._txtPower = self._condition:getChildByName("txt_power")

    --left
    local ndLeft = self._csb:getChildByName("nd_left")
    self._txtName = ndLeft:getChildByName("txt_name")

    self._txtMaster = ndLeft:getChildByName("txt_master")

    self._txtLv = ndLeft:getChildByName("txt_lv")

    self._txtNum = ndLeft:getChildByName("txt_num")

    self._txtMax = ndLeft:getChildByName("txt_max")

    self._txtRank = ndLeft:getChildByName("txt_rank")

    self._txtTenet = ndLeft:getChildByName("bg"):getChildByName("txt_introduce")

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
    dxyDispatcher_addEventListener("Rank_baseHisMember",self,self.baseHisMember)
    dxyDispatcher_addEventListener("Rank_addHisMember",self,self.addHisMember)
end

function GroupMsg:removeEvent()
    dxyDispatcher_removeEventListener("Rank_baseHisMember",self,self.baseHisMember)
    dxyDispatcher_removeEventListener("Rank_addHisMember",self,self.addHisMember)
end

function GroupMsg:baseHisMember()
    local Base = zzm.RankingModel._arrRankGroup.Base
    self._data = Base

    self._txtName:setString(Base["Name"])  
    self._txtMaster:setString(Base["Master"])
    self._txtLv:setString(Base["Lv"])  
    
    self._txtNum:setString(Base["Num"])
    local posx = self._txtNum:getPositionX()
    local width = self._txtNum:getContentSize().width
    local SociatyLv = GroupConfig:getSociatyLv(Base["Lv"])
    self._txtMax:setString("/"..SociatyLv.MemberMax)
    self._txtMax:setPositionX(posx+width)
    
--    self._txtRank:setString(Base["Rank"])
    self._txtTenet:setString(Base["Tenet"])
    
    if Base["Auto"] == 1 then
        self._condition:setVisible(true)
        self._txtPower:setString(self._data.PowerLimit)
    end
end

function GroupMsg:addHisMember()
    local Menber = zzm.RankingModel._arrRankGroup.Member
    
    for i=1,Menber.num do
        require "src.game.group.view.HisMember"
        self._arrHisMember[i] = HisMember:create(Menber[i])
        self._sv:addChild(self._arrHisMember[i])
        self:setPos()
    end
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

return GroupMsg