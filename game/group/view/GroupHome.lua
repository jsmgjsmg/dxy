local GroupHome = GroupHome or class("GroupHome",function()
    return cc.Node:create()
end)

function GroupHome:ctor()
    self.visibleSize = cc.Director:getInstance():getVisibleSize()
    self.origin = cc.Director:getInstance():getVisibleOrigin()
end

function GroupHome:create()
    local node = GroupHome:new()
    node:init()
    return node
end

function GroupHome:init()
    self._csb = cc.CSLoader:createNode("dxyCocosStudio/csd/ui/group/GroupHome.csb")
    self:addChild(self._csb)
    self._csb:setPosition(self.origin.x + self.visibleSize.width / 2, self.origin.y + self.visibleSize.height / 2)

    dxyExtendEvent(self)
    local GroupData = zzm.GroupModel.GroupData
    local MemberData = zzm.GroupModel.MemberData
    
    local _ndDoor = self._csb:getChildByName("nd_door")
    
--btn
    local btnEdit = _ndDoor:getChildByName("btn_edit")
    btnEdit:addTouchEventListener(function(target,type)
        if type == 2 then
            SoundsFunc_playSounds(SoundsType.OPEN_PAGE,false)
            if GroupConfig:getRoot(zzm.GroupModel:getRoot(_G.RoleData.Uid))["Tenet"] then
                local txt = self._txtTenet:getString()
                require "game.group.view.Editing"
                local edit = Editing:create(txt)
                self:addChild(edit)
            else
                TipsFrame:create("你的权限不足")
            end
        end
    end)
    
    local txt = "是否退出仙门"
    local btnExit = _ndDoor:getChildByName("btn_exit")
    if GroupData["MasterUid"] == _G.RoleData.Uid then
        btnExit:setTitleText("解散仙门")
        txt = "是否解散仙门"
    end
    btnExit:addTouchEventListener(function(target,type)
        if type == 2 then
            SoundsFunc_playSounds(SoundsType.UNIVERSAL_BTN,false)
            require "src.game.group.view.HintExit"
            local exit = HintExit:create(txt)
            self:addChild(exit)
        end       
    end)

    
--txt
    self._txtName = _ndDoor:getChildByName("txt_name")
    self._txtName:setString(GroupData["Name"])

    self._txtMaster = _ndDoor:getChildByName("txt_master")
    local role = zzm.CharacterModel:getCharacterData()
--    local enCAT = enCharacterAttrType
--    self._txtMaster:setString(role:getValueByType(enCAT.NAME))
    self._txtMaster:setString(GroupData.Master)

    self._txtLv = _ndDoor:getChildByName("txt_lv")
    self._txtLv:setString(GroupData["Lv"])

    self._txtNum = _ndDoor:getChildByName("txt_num")
    self._txtNum:setString(GroupData.Num)
    local posx = self._txtNum:getPositionX()
    local width = self._txtNum:getContentSize().width

    self._txtMax = _ndDoor:getChildByName("txt_max")
    self._txtMax:setPositionX(posx+width)

    self._txtRank = _ndDoor:getChildByName("txt_rank")
    self._txtRank:setString(GroupData["Rank"])    

    self._txtTenet = _ndDoor:getChildByName("bgIntroduce"):getChildByName("txt_introduce")
    self:updataEdit(GroupData["Tenet"])
    
    local build = _ndDoor:getChildByName("build")
    self._lbBuild = build:getChildByName("lb_build")
    self._txtBuild = build:getChildByName("txt_build")
    
    self:updateGroup(GroupData)
end

function GroupHome:initEvent()
    dxyDispatcher_addEventListener("updataEdit",self,self.updataEdit)
    dxyDispatcher_addEventListener("GroupHome_updataNum",self,self.updataNum)
    dxyDispatcher_addEventListener("GroupHome_updateGroup",self,self.updateGroup)
end

function GroupHome:removeEvent()
    dxyDispatcher_removeEventListener("updataEdit",self,self.updataEdit)
    dxyDispatcher_removeEventListener("GroupHome_updataNum",self,self.updataNum)
    dxyDispatcher_removeEventListener("GroupHome_updateGroup",self,self.updateGroup)
end

function GroupHome:updataEdit(txt)
    self._txtTenet:setString(txt)
end

function GroupHome:updataNum(num)
    self._txtNum:setString(num)
    local posx = self._txtNum:getPositionX()
    local width = self._txtNum:getContentSize().width

    self._txtMax:setPositionX(posx+width)
end

------------------NEW
function GroupHome:updateGroup(data)
    local config = GroupConfig:getSociatyLv(data.Lv)
    self._txtMax:setString("/"..config.MemberMax)
    
    self._txtBuild:setString(data["Build"].."/"..config.Exp)
    self._lbBuild:setPercent(data["Build"]/config.Exp*100)
end


return GroupHome