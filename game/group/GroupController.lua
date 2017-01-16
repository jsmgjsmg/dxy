local GroupController = class("GroupController")

function GroupController:ctor()
    self:registerListener()
    self._mainGroup = nil
end

function GroupController:registerListener()
    _G.NetManagerLuaInst:registerListenner(NetEventType.Rec_Group_InitGroup,self)
    _G.NetManagerLuaInst:registerListenner(NetEventType.Rec_Group_InitMember,self)
    _G.NetManagerLuaInst:registerListenner(NetEventType.Rec_Group_GroupList,self)
    _G.NetManagerLuaInst:registerListenner(NetEventType.Rec_Group_ExitGroup,self)
    _G.NetManagerLuaInst:registerListenner(NetEventType.Rec_Group_JoinGroup,self)
    _G.NetManagerLuaInst:registerListenner(NetEventType.Rec_Group_JoinOne,self)
    _G.NetManagerLuaInst:registerListenner(NetEventType.Rec_Group_AnswerJoin,self)
    _G.NetManagerLuaInst:registerListenner(NetEventType.Rec_Group_EditTenet,self)
    _G.NetManagerLuaInst:registerListenner(NetEventType.Rec_Group_ChangeRoot,self)
    _G.NetManagerLuaInst:registerListenner(NetEventType.Rec_Group_InitThing,self)
    _G.NetManagerLuaInst:registerListenner(NetEventType.Rec_Group_AddThing,self)
    _G.NetManagerLuaInst:registerListenner(NetEventType.Rec_Group_AddMember,self)
    _G.NetManagerLuaInst:registerListenner(NetEventType.Rec_Group_ResufeAll,self)
    _G.NetManagerLuaInst:registerListenner(NetEventType.Rec_Group_AskMemberList,self)
    _G.NetManagerLuaInst:registerListenner(NetEventType.Rec_Group_FindGroup,self)
    _G.NetManagerLuaInst:registerListenner(NetEventType.Rec_Group_UpdatePower,self)
    _G.NetManagerLuaInst:registerListenner(DefineProto.PROTO_SOCIATY_REQUEST_SUCCEED,self)
    _G.NetManagerLuaInst:registerListenner(DefineProto.PROTO_SOCIATY_RETURN_FIGHTLIMIT,self)
    
    --仙门场景
    _G.NetManagerLuaInst:registerListenner(DefineProto.PROTO_COPY_RETURN_COPY_TYPE,self)
    _G.NetManagerLuaInst:registerListenner(DefineProto.PROTO_COPY_COME_SOCIATY_SCENSE,self)
    _G.NetManagerLuaInst:registerListenner(DefineProto.PROTO_COPY_NEW_IN_SOCIATY_SCENSE,self)
    _G.NetManagerLuaInst:registerListenner(DefineProto.PROTO_COPY_RETURN_EXIT_SOCIATY_SCENSE,self)
    _G.NetManagerLuaInst:registerListenner(DefineProto.PROTO_COPY_UPDATE_MOVE_SOCIATY_SCENSE,self)
    
    --功能
    _G.NetManagerLuaInst:registerListenner(DefineProto.PROTO_SOCIATY_SOCIATY_UPDATE_BUILD,self)
    _G.NetManagerLuaInst:registerListenner(DefineProto.PROTO_SOCIATY_SOCIATY_RETURN_PRAY,self)
    _G.NetManagerLuaInst:registerListenner(DefineProto.PROTO_SOCIATY_RETURN_TALENT,self)
    _G.NetManagerLuaInst:registerListenner(DefineProto.PROTO_SOCIATY_RETURN_PRAY_RANKING,self)
    _G.NetManagerLuaInst:registerListenner(DefineProto.PROTO_CLIMBING_TOWER_TEAM,self)
    _G.NetManagerLuaInst:registerListenner(DefineProto.PROTO_CLIMBING_TOWER_NEW_JOIN_TEAM,self)
    _G.NetManagerLuaInst:registerListenner(DefineProto.PROTO_CLIMBING_TOWER_MEMBER_EXIT,self)
    _G.NetManagerLuaInst:registerListenner(DefineProto.PROTO_SOCIATY_EXCHANGE_SHOP,self)
    _G.NetManagerLuaInst:registerListenner(DefineProto.PROTO_SOCIATY_RETURN_EXCHANGE_GOODS,self)
    _G.NetManagerLuaInst:registerListenner(DefineProto.PROTO_SOCIATY_UPDATE_INTEGRAL,self)
    _G.NetManagerLuaInst:registerListenner(DefineProto.PROTO_CLIMBING_TOWER_RETURN_PREPARE,self)
    _G.NetManagerLuaInst:registerListenner(DefineProto.PROTO_CLIMBING_TOWER_START_COPY,self)
end

function GroupController:unregisterListenner()
    _G.NetManagerLuaInst:unregisterListenner(NetEventType.Rec_Group_InitGroup,self)
    _G.NetManagerLuaInst:unregisterListenner(NetEventType.Rec_Group_InitMember,self)
    _G.NetManagerLuaInst:unregisterListenner(NetEventType.Rec_Group_GroupList,self)
    _G.NetManagerLuaInst:unregisterListenner(NetEventType.Rec_Group_ExitGroup,self)
    _G.NetManagerLuaInst:unregisterListenner(NetEventType.Rec_Group_JoinGroup,self)
    _G.NetManagerLuaInst:unregisterListenner(NetEventType.Rec_Group_JoinOne,self)
    _G.NetManagerLuaInst:unregisterListenner(NetEventType.Rec_Group_AnswerJoin,self)
    _G.NetManagerLuaInst:unregisterListenner(NetEventType.Rec_Group_EditTenet,self)
    _G.NetManagerLuaInst:unregisterListenner(NetEventType.Rec_Group_ChangeRoot,self)
    _G.NetManagerLuaInst:unregisterListenner(NetEventType.Rec_Group_InitThing,self)
    _G.NetManagerLuaInst:unregisterListenner(NetEventType.Rec_Group_AddThing,self)
    _G.NetManagerLuaInst:unregisterListenner(NetEventType.Rec_Group_AddMember,self)
    _G.NetManagerLuaInst:unregisterListenner(NetEventType.Rec_Group_ResufeAll,self)
    _G.NetManagerLuaInst:unregisterListenner(NetEventType.Rec_Group_AskMemberList,self)
    _G.NetManagerLuaInst:unregisterListenner(NetEventType.Rec_Group_FindGroup,self)
    _G.NetManagerLuaInst:unregisterListenner(NetEventType.Rec_Group_UpdatePower,self)
    _G.NetManagerLuaInst:unregisterListenner(DefineProto.PROTO_SOCIATY_REQUEST_SUCCEED,self)
    _G.NetManagerLuaInst:unregisterListenner(DefineProto.PROTO_SOCIATY_RETURN_FIGHTLIMIT,self)
    
    --仙门场景
    _G.NetManagerLuaInst:unregisterListenner(DefineProto.PROTO_COPY_RETURN_COPY_TYPE,self)
    _G.NetManagerLuaInst:unregisterListenner(DefineProto.PROTO_COPY_COME_SOCIATY_SCENSE,self)
    _G.NetManagerLuaInst:unregisterListenner(DefineProto.PROTO_COPY_NEW_IN_SOCIATY_SCENSE,self)
    _G.NetManagerLuaInst:unregisterListenner(DefineProto.PROTO_COPY_RETURN_EXIT_SOCIATY_SCENSE,self)
    _G.NetManagerLuaInst:unregisterListenner(DefineProto.PROTO_COPY_UPDATE_MOVE_SOCIATY_SCENSE,self)
    
    --功能
    _G.NetManagerLuaInst:unregisterListenner(DefineProto.PROTO_SOCIATY_SOCIATY_UPDATE_BUILD,self)
    _G.NetManagerLuaInst:unregisterListenner(DefineProto.PROTO_SOCIATY_SOCIATY_RETURN_PRAY,self)
    _G.NetManagerLuaInst:unregisterListenner(DefineProto.PROTO_SOCIATY_RETURN_TALENT,self)
    _G.NetManagerLuaInst:unregisterListenner(DefineProto.PROTO_SOCIATY_RETURN_PRAY_RANKING,self)
    _G.NetManagerLuaInst:unregisterListenner(DefineProto.PROTO_CLIMBING_TOWER_TEAM,self)
    _G.NetManagerLuaInst:unregisterListenner(DefineProto.PROTO_CLIMBING_TOWER_NEW_JOIN_TEAM,self)
    _G.NetManagerLuaInst:unregisterListenner(DefineProto.PROTO_CLIMBING_TOWER_MEMBER_EXIT,self)
    _G.NetManagerLuaInst:unregisterListenner(DefineProto.PROTO_SOCIATY_EXCHANGE_SHOP,self)
    _G.NetManagerLuaInst:unregisterListenner(DefineProto.PROTO_SOCIATY_RETURN_EXCHANGE_GOODS,self)
    _G.NetManagerLuaInst:unregisterListenner(DefineProto.PROTO_SOCIATY_UPDATE_INTEGRAL,self)
    _G.NetManagerLuaInst:unregisterListenner(DefineProto.PROTO_CLIMBING_TOWER_RETURN_PREPARE,self)
    _G.NetManagerLuaInst:unregisterListenner(DefineProto.PROTO_CLIMBING_TOWER_START_COPY,self)
end

function GroupController:showLayer() 
    require "game.group.view.MainGroup"
    local scene = SceneManager:getCurrentScene()
    self._mainGroup = MainGroup:create()
    scene:addChild(self._mainGroup)
    dxyDispatcher_dispatchEvent("MainGroup_changeLayer") 
end

function GroupController:showGroupFuncLayer()
    self:removeLastLayer()
    require "game.group.view.GroupFunc"
    self._layer = GroupFunc:create()
    self._mainGroup:addChild(self._layer) 
    
    self:showLeadLayer()
    
    self:initTalent()
    self:getMyMemberList()
end

function GroupController:showLeadLayer()
    require "game.rolelayer.view.LeadLayer"
    self._leadLayer = LeadLayer:create()
    self._mainGroup:addChild(self._leadLayer)
    if zzm.GroupModel.isInTheTeam then
        zzc.GroupFuncCtrl:enterTower()
    end
end

function GroupController:showGroupListLayer()
    self:removeLastLayer()
    require "game.group.view.GroupLayer"
    local scene = SceneManager:getCurrentScene()
    self._layer = GroupLayer:create()
    self._mainGroup:addChild(self._layer)
end

function GroupController:showGroupListMember(bool) --type(true:仙门信息，false:仙门列表)
    local MemberVisible = require ("game.group.view.MemberVisible"):create(bool)
    self._mainGroup:addChild(MemberVisible)
end

function GroupController:closeLayer()
    if self._mainGroup then
        self._mainGroup:removeFromParent()
        self._mainGroup = nil
    end
    self._layer = nil
    self._leadLayer = nil
end

function GroupController:getLeadLayer()
    return self._leadLayer
end

function GroupController:removeLastLayer()
    if self._layer then
        self._layer:removeFromParent()
        self._layer = nil
    end
    if self._leadLayer then
        self._leadLayer:removeFromParent()
        self._leadLayer = nil
    end
end

function GroupController:getLayer()
    if self._mainGroup then
        return self._mainGroup
    end
end

function GroupController:clean()
    dxyDispatcher_dispatchEvent("TeamCopy_removeAllOssature")
    self._layer = nil
    self._leadLayer = nil
    self._mainGroup = nil
end

function GroupController:getFuncLayer()
    if self._layer then
        return self._layer
    end
end

------发送消息------------------------------------
--创建仙门
function GroupController:createGroup(str)
    local _strMsg = mc.packetData:createWritePacket(NetEventType.Req_Group_CreateGroup)
    _strMsg:writeString(str)
    mc.NetMannager:getInstance():sendMsg(_strMsg)
    print("~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~send: "..NetEventType.Req_Group_CreateGroup.." str: "..str)
end

--快速加入
function GroupController:AutoJoin()
    local _strMsg = mc.packetData:createWritePacket(NetEventType.Req_Group_AutoJoin)
    mc.NetMannager:getInstance():sendMsg(_strMsg)
    print("~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~send: "..NetEventType.Req_Group_AutoJoin)
end

--搜索仙门
function GroupController:FindGroup(name)
    local _strMsg = mc.packetData:createWritePacket(NetEventType.Req_Group_FindGroup)
    _strMsg:writeString(name)
    mc.NetMannager:getInstance():sendMsg(_strMsg)
    print("~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~send: "..NetEventType.Req_Group_FindGroup.." str:"..name)
end

--退出仙门
function GroupController:ExitGroup()
    local _strMsg = mc.packetData:createWritePacket(NetEventType.Req_Group_ExitGroup)
    mc.NetMannager:getInstance():sendMsg(_strMsg)
    print("~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~send: "..NetEventType.Req_Group_ExitGroup)
end

--获取仙门列表
function GroupController:initGroupList(num)
    local _strMsg = mc.packetData:createWritePacket(NetEventType.Req_Group_GroupList)
    _strMsg:writeShort(num)
    mc.NetMannager:getInstance():sendMsg(_strMsg)
    print("~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~send: "..NetEventType.Req_Group_GroupList.." num:"..num)
end

--申请加入仙门
function GroupController:JoinGroup(id)
    local _strMsg = mc.packetData:createWritePacket(NetEventType.Req_Group_JoinGroup)
    _strMsg:writeInt(id)
    mc.NetMannager:getInstance():sendMsg(_strMsg)
    print("~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~send: "..NetEventType.Req_Group_JoinGroup.." id:"..id)
end

--申请处理
function GroupController:AnswerJoin(id,state)
    local _strMsg = mc.packetData:createWritePacket(NetEventType.Req_Group_AnswerJoin)
    _strMsg:writeInt(id)
    _strMsg:writeByte(state)
    mc.NetMannager:getInstance():sendMsg(_strMsg)
    print("~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~send: "..NetEventType.Req_Group_AnswerJoin.." id:"..id.." state:"..state)
end

--全部拒绝
function GroupController:ResufeAll()
    local _strMsg = mc.packetData:createWritePacket(NetEventType.Req_Group_ResufeAll)
    mc.NetMannager:getInstance():sendMsg(_strMsg)
    print("~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~send: "..NetEventType.Req_Group_ResufeAll)
end

--改变宗旨
function GroupController:EditTenet(str)
    local _strMsg = mc.packetData:createWritePacket(NetEventType.Req_Group_EditTenet)
    _strMsg:writeString(str)
    mc.NetMannager:getInstance():sendMsg(_strMsg)
    print("~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~send: "..NetEventType.Req_Group_EditTenet.." str:"..str)
end

--改变职位
function GroupController:ChangeRoot(uid,root)
    local _strMsg = mc.packetData:createWritePacket(NetEventType.Req_Group_ChangeRoot)
    _strMsg:writeInt(uid)
    _strMsg:writeByte(root)
    mc.NetMannager:getInstance():sendMsg(_strMsg)
    print("~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~send: "..NetEventType.Req_Group_ChangeRoot.." uid:"..uid.." root:"..root)
end

--踢出仙门
function GroupController:PopatGroup(uid)
    local _strMsg = mc.packetData:createWritePacket(NetEventType.Req_Group_DelectMember)
    _strMsg:writeInt(uid)
    mc.NetMannager:getInstance():sendMsg(_strMsg)
    print("~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~send: "..NetEventType.Req_Group_DelectMember.." uid:"..uid)
end

--请求仙门成员
function GroupController:AskMemberList(id)
    local _strMsg = mc.packetData:createWritePacket(NetEventType.Req_Group_AskMemberList)
    _strMsg:writeInt(id)
    mc.NetMannager:getInstance():sendMsg(_strMsg)
    print("~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~send: "..NetEventType.Req_Group_AskMemberList.." id "..id)
end

--发布招募
function GroupController:IssueJoin(power,str)
    local _strMsg = mc.packetData:createWritePacket(DefineProto.PROTO_CHAT_RECRUIT)
    _strMsg:writeInt(power)
    _strMsg:writeString(str)
    mc.NetMannager:getInstance():sendMsg(_strMsg)
    print("~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~send: "..DefineProto.PROTO_CHAT_RECRUIT.." power "..power.." str"..str)
end

--获取我的仙门成员列表
function GroupController:getMyMemberList()
    local _strMsg = mc.packetData:createWritePacket(DefineProto.PROTO_SOCIATY_REQUEST_MEMBER_DATA)
    mc.NetMannager:getInstance():sendMsg(_strMsg)
    print("~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~send: "..DefineProto.PROTO_SOCIATY_REQUEST_MEMBER_DATA)
end

--设置战力限制
function GroupController:setPowerLimit(power,auto)
    local _strMsg = mc.packetData:createWritePacket(DefineProto.PROTO_SOCIATY_SET_FIGHTLIMIT)
    _strMsg:writeByte(auto)
    _strMsg:writeInt(power)
    mc.NetMannager:getInstance():sendMsg(_strMsg)
    print("~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~send: "..DefineProto.PROTO_SOCIATY_SET_FIGHTLIMIT.." power "..power.." auto "..auto)
end

---仙门场景
--进入场景
function GroupController:enterGroupFunc(posx,posy)
    dxyWaitBack:show()
    local _strMsg = mc.packetData:createWritePacket(DefineProto.PROTO_COPY_ENTER_THE_COPY)
    _strMsg:writeByte(DefineConst.CONST_COPY_TYPE_SOCIATY_SCENE)
    _strMsg:writeInt(posx)
    _strMsg:writeInt(posy)
    _strMsg:writeInt(posx)
    mc.NetMannager:getInstance():sendMsg(_strMsg)
    print("~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~send: "..DefineProto.PROTO_COPY_ENTER_THE_COPY.." posx "..posx.." posy "..posy)
end

--退出场景
function GroupController:exitGroupFunc()
    local _strMsg = mc.packetData:createWritePacket(DefineProto.PROTO_COPY_EXIT_SOCIATY_SCENSE)
    mc.NetMannager:getInstance():sendMsg(_strMsg)
    print("~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~send: "..DefineProto.PROTO_COPY_EXIT_SOCIATY_SCENSE)
end

--移动
function GroupController:registerListenerMove(posx,posy)
    local _strMsg = mc.packetData:createWritePacket(DefineProto.PROTO_COPY_MOVE_SOCIATY_SCENSE)
    _strMsg:writeInt(posx)
    _strMsg:writeInt(posy)
    mc.NetMannager:getInstance():sendMsg(_strMsg)
    print("~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~send: "..DefineProto.PROTO_COPY_MOVE_SOCIATY_SCENSE.." posx "..posx.." posy "..posy)
end

---GroupFunc
function GroupController:Pray(type) --1:金币  2:元宝
    local _strMsg = mc.packetData:createWritePacket(DefineProto.PROTO_SOCIATY_SOCIATY_PRAY)
    _strMsg:writeByte(type)
    mc.NetMannager:getInstance():sendMsg(_strMsg)
    print("~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~send: "..DefineProto.PROTO_SOCIATY_SOCIATY_PRAY)
end

--初始化天赋
function GroupController:initTalent()
    local _strMsg = mc.packetData:createWritePacket(DefineProto.PROTO_SOCIATY_GET_TALENT)
    mc.NetMannager:getInstance():sendMsg(_strMsg)
    print("~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~send: "..DefineProto.PROTO_SOCIATY_GET_TALENT)
end

--天赋
function GroupController:addTalent()
    local _strMsg = mc.packetData:createWritePacket(DefineProto.PROTO_SOCIATY_TALENT_XIULIAN)
    mc.NetMannager:getInstance():sendMsg(_strMsg)
    print("~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~send: "..DefineProto.PROTO_SOCIATY_TALENT_XIULIAN)
end

--获取祈福日志
function GroupController:getPrayLog()
    local _strMsg = mc.packetData:createWritePacket(DefineProto.PROTO_SOCIATY_PRAY_RANKING)
    mc.NetMannager:getInstance():sendMsg(_strMsg)
    print("~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~send: "..DefineProto.PROTO_SOCIATY_PRAY_RANKING)
end

--创建组队
function GroupController:createTeamTower()
    local _strMsg = mc.packetData:createWritePacket(DefineProto.PROTO_CLIMBING_TOWER_CREATE_TEAM)
    mc.NetMannager:getInstance():sendMsg(_strMsg)
    print("~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~send: "..DefineProto.PROTO_CLIMBING_TOWER_CREATE_TEAM)
end

--加入队伍
function GroupController:JoinTeamTower(id)
    local _strMsg = mc.packetData:createWritePacket(DefineProto.PROTO_CLIMBING_TOWER_JOIN_TEAM)
    _strMsg:writeInt(id)
    mc.NetMannager:getInstance():sendMsg(_strMsg)
    print("~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~send: "..DefineProto.PROTO_CLIMBING_TOWER_JOIN_TEAM.." id "..id)
end

--退出组队
function GroupController:exitTeamTower(id)
    local _strMsg = mc.packetData:createWritePacket(DefineProto.PROTO_CLIMBING_TOWER_EXIT_TEAM)
    _strMsg:writeInt(id)
    mc.NetMannager:getInstance():sendMsg(_strMsg)
    print("~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~send: "..DefineProto.PROTO_CLIMBING_TOWER_EXIT_TEAM.." id "..id)
end

--发布队伍招募
function GroupController:sendTeamCopyAdd(power,level)
    local _strMsg = mc.packetData:createWritePacket(DefineProto.PROTO_CLIMBING_TOWER_RECRUITING_TEAM)
    _strMsg:writeInt(power)
    _strMsg:writeShort(level)
    mc.NetMannager:getInstance():sendMsg(_strMsg)
    print("~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~send: "..DefineProto.PROTO_CLIMBING_TOWER_RECRUITING_TEAM.." power "..power.." level "..level)
end

--准备
function GroupController:setPrepare(id)
    local _strMsg = mc.packetData:createWritePacket(DefineProto.PROTO_CLIMBING_TOWER_PREPARE)
    _strMsg:writeInt(id)
    mc.NetMannager:getInstance():sendMsg(_strMsg)
    print("~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~send: "..DefineProto.PROTO_CLIMBING_TOWER_PREPARE.." id "..id)
end

--仙门兑换
function GroupController:getGroupShop(id,type)
    local _strMsg = mc.packetData:createWritePacket(DefineProto.PROTO_SOCIATY_EXCHANGE_GOODS)
    _strMsg:writeByte(id)
    _strMsg:writeByte(type)
    mc.NetMannager:getInstance():sendMsg(_strMsg)
    print("~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~send: "..DefineProto.PROTO_SOCIATY_EXCHANGE_GOODS.." id "..id.." type "..type)
end

------接收消息------------------------------------
function GroupController:dealMsg(msg)
    local cmd = msg:getCmd()
    if cmd == NetEventType.Rec_Group_InitGroup then --8001(初始化仙门)
        _G.GroupData.State = msg:readUbyte()
        if _G.GroupData.State == 1 then --已加入仙门
            local data = {}
            data["Id"] = msg:readUint()
            data["Name"] = msg:readString()
            data["MasterUid"] = msg:readUint()
            _G.GroupData.MasterUid = data["MasterUid"]
            data["Master"] = msg:readString()
            data["Pro"] = msg:readByte()
            data["Rank"] = msg:readUint()
            data["Lv"] = msg:readUbyte()
            data["Build"] = msg:readUint()
            data["PowerLimit"] = msg:readUint()
            data["Power"] = msg:readUint()
            data["Tenet"] = msg:readString()
            data["Auto"] = msg:readUbyte()
            data["Num"] = msg:readUbyte()
            zzm.GroupModel:initGroupState(data)
        elseif _G.GroupData.State == 0 then
            dxyDispatcher_dispatchEvent("LeadLayer_stopTimer")
            dxyDispatcher_dispatchEvent("MainGroup_changeLayer")
        end
        
    elseif cmd == NetEventType.Rec_Group_InitMember then --8002(成员初始化)
        zzm.GroupModel.MemberData = {}
        local len = msg:readUbyte()
        for i=1,len do
            local data = {}
            data["uid"] = msg:readUint()
            data["name"] = msg:readString()
            data["lv"] = msg:readUshort()
            data["pro"] = msg:readUbyte()
            data["root"] = msg:readUbyte()
            data["power"] = msg:readUint()
            data["closest"] = msg:readUint()
            if data["uid"] == _G.RoleData.Uid then
                data["contribute"] = msg:readUint()
                data["praynum"] = msg:readUbyte()
                data["praynum_rmb"] = msg:readUbyte()
                data["integral"] = msg:readUint()
            end
            zzm.GroupModel:initMember(data)
        end
        
    elseif cmd == NetEventType.Rec_Group_AddMember then --8030(新增成员)
        local data = {}
        data["uid"] = msg:readUint()
        data["name"] = msg:readString()
        data["lv"] = msg:readUshort()
        data["pro"] = msg:readUbyte()
        data["root"] = msg:readUbyte()
        data["power"] = msg:readUint()
        data["closest"] = msg:readUint()
        zzm.GroupModel:addMember(data)
    
    elseif cmd == NetEventType.Rec_Group_GroupList then --8008(仙门列表)
        zzm.GroupModel.GroupList = {}
        local len = msg:readUbyte()
        for i=1,len do
            local data = {}
            data["Id"] = msg:readUint()
            data["Name"] = msg:readString()
            data["Master"] = msg:readString()
            data["Pro"] = msg:readUbyte()
            data["Rank"] = msg:readUint()
            data["Lv"] = msg:readUbyte()
            data["Num"] = msg:readUbyte()
            data["PowerLimit"] = msg:readUint()
            data["Auto"] = msg:readUbyte()
            data["Tenet"] = msg:readString()
            zzm.GroupModel:initGroupList(data)
        end
        
    elseif cmd == NetEventType.Rec_Group_ExitGroup then --8018（退出仙门）
        local uid = msg:readUint()
        zzm.GroupModel:ExitGroup(uid)
    
    elseif cmd == NetEventType.Rec_Group_JoinGroup then --8022(申请列表)
        local len = msg:readUbyte()
        for i=1,len do
            local data = {}
            data["Id"] = msg:readUint()
            data["Uid"] = msg:readUint()
            data["Name"] = msg:readString()
            data["Lv"] = msg:readUshort()
            data["Pro"] = msg:readUbyte()
            data["Power"] = msg:readUint()
            zzm.GroupModel:initAskFor(data)
        end
    
    elseif cmd == NetEventType.Rec_Group_JoinOne then --8025(单个申请消息)
        local data = {}
        data["Id"] = msg:readUint()
        data["Uid"] = msg:readUint()
        data["Name"] = msg:readString()
        data["Lv"] = msg:readUshort()
        data["Pro"] = msg:readUbyte()
        data["Power"] = msg:readUint()
        zzm.GroupModel:insertAskFor(data)
    
    elseif cmd == DefineProto.PROTO_SOCIATY_REQUEST_SUCCEED then --8115(申请加入仙门返回)
        dxyFloatMsg:show("已发送请求")

    elseif cmd == NetEventType.Rec_Group_AnswerJoin then --8038(单个申请处理)
        local id = msg:readUint()
        zzm.GroupModel:delectAskFor(id)
    
    elseif cmd == NetEventType.Rec_Group_ResufeAll then --8035(全部拒绝)
        zzm.GroupModel:delAllAsk()
    
    elseif cmd == NetEventType.Rec_Group_EditTenet then --8045(接收更改宗旨)
        local str = msg:readString()
        zzm.GroupModel:updateEditTenet(str)
        dxyDispatcher_dispatchEvent("updataEdit",str)
    
    elseif cmd == NetEventType.Rec_Group_ChangeRoot then --8050(改变职位)
        local data = {}
        data["uid"] = msg:readUint()
        data["root"] = msg:readUbyte()
        zzm.GroupModel:ChangeRoot(data)
    
    elseif cmd == NetEventType.Rec_Group_InitThing then  --8060(初始化事件)
        local len = msg:readUbyte()
        for i=1,len do
            local data = {}
            data["type"] = msg:readUbyte()
            cn:readThing(msg,data["type"],data)
            zzm.GroupModel:initThings(data)
        end
    
    elseif cmd == NetEventType.Rec_Group_AddThing then  --8056(新增事件)
        local data = {}
        data["type"] = msg:readUbyte()
        cn:readThing(msg,data["type"],data)
        zzm.GroupModel:addThing(data)
        
    elseif cmd == NetEventType.Rec_Group_AskMemberList then  --8065(仙门成员)
        zzm.GroupModel.HisMemberList = {}
        local data = {}
        local num = msg:readUbyte()
        for i=1,num do
            data[i] = {}
            data[i]["uid"] = msg:readUint()
            data[i]["name"] = msg:readString()
            data[i]["lv"] = msg:readUshort()
            data[i]["pro"] = msg:readUbyte()
            data[i]["root"] = msg:readUbyte()
            data[i]["power"] = msg:readUint()
            data[i]["time"] = msg:readUint()
        end
        zzm.GroupModel:addHisMember(data)
    
    elseif cmd == NetEventType.Rec_Group_FindGroup then --8070(搜索仙门)
        local data = {}
        data["Len"] = msg:readUbyte()
        data["Id"] = msg:readUint()
        data["Name"] = msg:readString()
        data["Master"] = msg:readString()
        data["Pro"] = msg:readUbyte()
        data["Rank"] = msg:readUint()
        data["Lv"] = msg:readUbyte()
        data["Num"] = msg:readUbyte()
        data["PowerLimit"] = msg:readUint()
        data["Auto"] = msg:readUbyte()
        data["Tenet"] = msg:readString()
        dxyDispatcher_dispatchEvent("FindGroup",data)
    
    elseif cmd == NetEventType.Rec_Group_UpdatePower then --8072(更新战斗力)
        local data = {}
        data.uid = msg:readUint()
        data.power = msg:readUint()
        zzm.GroupModel:updatePower(data)
    
    ---仙门场景
    elseif cmd == DefineProto.PROTO_COPY_RETURN_COPY_TYPE then --4007(进入场景类型)
        local type = msg:readUbyte()
        zzm.GroupModel.COPYTYPE = type
        
    elseif cmd == DefineProto.PROTO_COPY_COME_SOCIATY_SCENSE then --4138(已进入仙门场景)
        local len = msg:readUbyte()
        for i=1,len do
            local data = {}
            data.Uid = msg:readUint()
            data.Pro = msg:readUbyte()
            data.Name = msg:readString()
            data.PosX = msg:readUint()        
            data.PosY = msg:readUint()        
            zzm.GroupModel:initVisibleMenber(data)
        end
        self:showGroupFuncLayer()
        dxyWaitBack:close()
        
    elseif cmd == DefineProto.PROTO_COPY_RETURN_EXIT_SOCIATY_SCENSE then --4150(退出仙门场景)
        local uid = msg:readUint()
        zzm.GroupModel:exitVisibleMenber(uid)
        
    elseif cmd == DefineProto.PROTO_COPY_NEW_IN_SOCIATY_SCENSE then --4140(新增可见成员)
        local data = {}
        data.Uid = msg:readUint()
        data.Pro = msg:readUbyte()
        data.Name = msg:readString()
        data.PosX = msg:readUint()        
        data.PosY = msg:readUint()        
        zzm.GroupModel:addVisibleMenber(data)
        
    elseif cmd == DefineProto.PROTO_COPY_UPDATE_MOVE_SOCIATY_SCENSE then --4165(移动)
        local data = {}
        data.Uid = msg:readUint()
        data.PosX = msg:readUint()
        data.PosY = msg:readUint()
        dxyDispatcher_dispatchEvent("GroupFunc_moveMember",data)
        
    elseif cmd == DefineProto.PROTO_SOCIATY_SOCIATY_RETURN_PRAY then --8095(返回祈福结果)
        local data = {}
        data.praynum = msg:readUbyte()
        data.praynum_rmb = msg:readUbyte()
        data.contribute = msg:readUint()
        data.exp = msg:readUint()
        data.integral = msg:readUint()
        zzm.GroupModel:setMyDataInGroup(data)
    
    elseif cmd == DefineProto.PROTO_SOCIATY_SOCIATY_UPDATE_BUILD then --8100(更新仙门建设度)
        local data = {}
        data.Lv = msg:readUbyte()
        data.Build = msg:readUint()
        zzm.GroupModel:updateGroupData(data)
        
    elseif cmd == DefineProto.PROTO_SOCIATY_RETURN_TALENT then --8110 返回天赋
        local data = {}
        data.Id = msg:readUshort()
        data.Atk = msg:readUint()
        data.Def = msg:readUint()
        data.Hp = msg:readUint()
        data.Contribute = msg:readUint()
        zzm.GroupModel:initTalentData(data)
        
    elseif cmd == DefineProto.PROTO_SOCIATY_RETURN_PRAY_RANKING then --8125(祈福排行榜返回)
        local len = msg:readUbyte()
        local data = {}
        for i=1,len do
            data[i] = {}
            data[i].Uid = msg:readUint()
            data[i].Name = msg:readString()
            data[i].Exp = msg:readUint()
        end
        zzm.GroupModel:initPrayLog(data)
    
    elseif cmd == DefineProto.PROTO_SOCIATY_RETURN_FIGHTLIMIT then --8135(返回战斗力限制 )
        local aoto = msg:readUbyte()
        local powerLimit = msg:readUint()
        zzm.GroupModel:updatePowerLimit(powerLimit,aoto)
    
    elseif cmd == DefineProto.PROTO_CLIMBING_TOWER_TEAM then --11502(队伍数据)
        local data = {}
        data.TeamId = msg:readUint()
        local num = msg:readUbyte()
        data.Member = {}
        for i=1,num do
            local arr = {}
            arr.Uid = msg:readUint()
            arr.Name = msg:readString()
            arr.Lv = msg:readUbyte()
            arr.Pro = msg:readUbyte()
            arr.Root = msg:readUbyte()
            arr.State = msg:readUbyte()
            table.insert(data.Member,arr)
        end
        table.sort(data.Member,function(t1,t2) return t1.Root < t2.Root end)
        zzm.GroupModel:initTeamMember(data)
    
    elseif cmd == DefineProto.PROTO_CLIMBING_TOWER_NEW_JOIN_TEAM then --11506(新增队员)
        local data = {}
        data.Uid = msg:readUint()
        data.Name = msg:readString()
        data.Lv = msg:readUbyte()
        data.Pro = msg:readUbyte()
        data.Root = msg:readUbyte()
        data.State = msg:readUbyte()
        zzm.GroupModel:addTeamMember(data)
    
    elseif cmd == DefineProto.PROTO_CLIMBING_TOWER_MEMBER_EXIT then --11511(退出组队)
        local data = {}
        data.Uid = msg:readUint()
        data.Root = msg:readUbyte()
        zzm.GroupModel:exitTeamMember(data)
    
    elseif cmd == DefineProto.PROTO_SOCIATY_EXCHANGE_SHOP then --8140(仙门兑换商店)
        local len = msg:readUbyte()
        local data = {}
        for i=1,len do
            data[i] = {}        
            data[i].Box = msg:readUbyte()        
            data[i].Discount = msg:readUshort()        
            data[i].Type = msg:readUbyte()        
            data[i].GoodsId = msg:readUint()        
            data[i].Num = msg:readUint()        
            data[i].NeedYB = msg:readUint()        
            data[i].NeedINT = msg:readUint()
            data[i].State = msg:readUbyte()        
        end
        zzm.GroupModel:initGroupShop(data)
    
    elseif cmd == DefineProto.PROTO_SOCIATY_RETURN_EXCHANGE_GOODS then --8150(返回兑换商品)
        local data = {}
        data.Box = msg:readUbyte()
        data.State = msg:readUbyte()
        zzm.GroupModel:changeGroupShop(data)
    
    elseif cmd == DefineProto.PROTO_SOCIATY_UPDATE_INTEGRAL then --8155(更新商店积分)
        local integral = msg:readUint()
        zzm.GroupModel:updateIntegral(integral)
    
    elseif cmd == DefineProto.PROTO_CLIMBING_TOWER_RETURN_PREPARE then --11525(返回准备状态)
        local data = {}
        data.Uid = msg:readUint()
        data.State = msg:readUbyte()
        zzm.GroupModel:changeTeamState(data)

    elseif cmd == DefineProto.PROTO_CLIMBING_TOWER_START_COPY then --11655(开始组队爬塔)
        local id = msg:readUshort()
        local sceneID = 0
        local param1 = 0
        if zzm.GroupModel.isInTheTeam then --副本中选择下一层
            zzm.GroupModel.curLevelSelect = GroupConfig:getSkyPagodaByPageById(zzm.GroupModel.curLevelSelect.Id+1)
        else
            if #zzm.GroupModel.TeamMember.Member > 1 then --多人（为统一队员的数据）
                local temp = GroupConfig:getSkyPagodaByPageById(id)
                if temp.Id == zzm.GroupModel.curLevelSelect.Id then
                    zzm.GroupModel.curLevelSelect = temp
                end
            end
        end
        local sceneID = zzm.GroupModel.curLevelSelect.CopyId
        local param1 = zzm.GroupModel.curLevelSelect.Id
        
--        zzm.GroupModel.isInTheTeam = true
        zzc.LoadingController:setCopyData({copyType = DefineConst.CONST_COPY_TYPE_SOCIATY_SCENE_BOSS,chapterID = 0, startTalkID = 0, endTalkID = 0, sceneID = sceneID, param1 = param1})
        zzc.LoadingController:enterScene(SceneType.LoadingScene)
        zzc.LoadingController:setDelegate2({target = self,func = function (data) zzc.LoadingController:enterScene(SceneType.CopyScene) end,data = self.m_data})
    end
end

return GroupController