local GroupModel = GroupModel or class("GroupModel")

function GroupModel:ctor()
    self.GroupData = {}
    self.MemberData = {}
    self.AskForList = {}
    self.ThingData = {}
    self.GroupList = {}
    self.HisMemberList = {}
    self.isMove = false
    self.isLeadMove = false
    self.Direction = 0
    
    self.COPYTYPE = 0
    self.VisibleMember = {}

    self.isInTheTeam = false
    self.isEnterByGroup = false
        
    self.TalentData = {}
    self.PrayLogData = {}
    self.TeamMember = {}
    self.GroupShopData = {}
    self.curLevelSelect = nil
end

--初始化仙门状态
function GroupModel:initGroupState(data)
    self.GroupData = data
    dxyDispatcher_dispatchEvent("MainGroup_changeLayer")
end

--SDK保存最近登录数据
function GroupModel:saveRoleInfo()
    local role = zzm.CharacterModel:getCharacterData()
    local enCAT = enCharacterAttrType
    
    local lv = role:getValueByType(enCAT.LV)
    local name = role:getValueByType(enCAT.NAME)
    local serverName = zzm.LoginModel.loginServer.name
    local sociaty = ""
    if _G.GroupData.State == 1 then
        sociaty = self.GroupData["Name"]
    end
    if _G.gSDKhuawei then   	
        local extData = "{\"gameRank\":\""..lv.."\",\"gameRole\":\""..name.."\",\"gameArea\":\""..serverName.."\",\"gameSociaty\":\""..sociaty.."\"}"
        SDKManagerLua.instance():submitExtendData("loginGameRole",extData)
    end
end

--更新仙门DATA

function GroupModel:updateGroupData(data)
    self.GroupData.Lv = data.Lv
    self.GroupData.Build = data.Build
    dxyDispatcher_dispatchEvent("GroupHome_updateGroup",self.GroupData)
end

--初始化成员
function GroupModel:initMember(data)
    table.insert(self.MemberData,data)
    table.sort(self.MemberData,function(t1,t2) return t1.root < t2.root end)
end

--初始化事件
function GroupModel:initThings(data)
    table.insert(self.ThingData,data)
end

--更新成员职位
function GroupModel:ChangeRoot(data)
    for key, var in pairs(self.MemberData) do
    	if var.uid == data["uid"] then
    	    var.root = data["root"]
            dxyDispatcher_dispatchEvent("changeMember",var)
            break
    	end
    end
end

--更改仙门宗旨
function GroupModel:updateEditTenet(str)
    self.GroupData.Tenet = str
end

--更改战力限制
function GroupModel:updatePowerLimit(powerLimit,auto)
    self.GroupData.PowerLimit = powerLimit
    self.GroupData.Auto = auto
end

--更新成员战力
function GroupModel:updatePower(data)
    for key, var in pairs(self.MemberData) do
        if var.uid == data.uid then
            var.power = data.power
            dxyDispatcher_dispatchEvent("updatePower",var)
            break
        end
    end
end

--新增成员
function GroupModel:addMember(data)
    table.insert(self.MemberData,data)
    self:sort(self.MemberData)
    dxyDispatcher_dispatchEvent("addMember",data)
    dxyDispatcher_dispatchEvent("delAsk",data)
    dxyDispatcher_dispatchEvent("GroupHome_updataNum",#self.MemberData)
end

--新增事件
function GroupModel:addThing(data)
    table.insert(self.ThingData,data)
    dxyDispatcher_dispatchEvent("addThing",data)
end

--初始化申请列表
function GroupModel:initAskFor(data)
    table.insert(self.AskForList,data)
end

--增加申请
function GroupModel:insertAskFor(data)
    for key, var in pairs(self.AskForList) do
        if var.Uid == data.Uid then
            table.remove(self.AskForList,key)
            dxyDispatcher_dispatchEvent("delAsk_Id",data.Id)
            break
        end
    end
    table.insert(self.AskForList,data)
    dxyDispatcher_dispatchEvent("addAsk",data)
end

--删除单个申请
function GroupModel:delectAskFor(id)
    for key, var in pairs(self.AskForList) do
    	if var["Id"] == id then
            table.remove(self.AskForList,key)
            dxyDispatcher_dispatchEvent("delAsk_Id",id)
            break
    	end
    end
end

--清空所有申请
function GroupModel:delAllAsk()
    self.AskForList = {}
    dxyDispatcher_dispatchEvent("delAllAsk")
end

--接收仙门列表
function GroupModel:initGroupList(data)
    for key, var in pairs(self.GroupList) do
    	if var.Id == data["Id"] then
            table.remove(self.GroupList,var)
            dxyDispatcher_dispatchEvent("delGroup",var)
            break
    	end
    end
    table.insert(self.GroupList,data)
    dxyDispatcher_dispatchEvent("addGroup",data)
end

--接收查看仙门成员
function GroupModel:addHisMember(data)
    self.HisMemberList = data
    local function sort(t1,t2)
        if t1.root == t2.root then
            return t1.power > t2.power
        else
            return t1.root < t2.root
        end
    end
    table.sort(self.HisMemberList,sort)
    dxyDispatcher_dispatchEvent("addHisMember",data)
end

--获取权限
function GroupModel:getRoot(uid)
    for key, var in pairs(self.MemberData) do
    	if var.uid == uid then
            return var.root
    	end
    end
end

--退出仙门
function GroupModel:ExitGroup(uid)
    if uid ~= _G.RoleData.Uid and _G.GroupData.MasterUid ~= uid then --非门主的其他成员
        for key, var in ipairs(self.MemberData) do
            if uid == var.uid then
        	    table.remove(self.MemberData,key)
                dxyDispatcher_dispatchEvent("delMember",uid)
                dxyDispatcher_dispatchEvent("GroupHome_updataNum",#self.MemberData)
                break
        	end
        end
    elseif uid == _G.RoleData.Uid then --自己退出
        self.MemberData = {}
        self.ThingData = {}
        self.VisibleMember = {}
        self.COPYTYPE = 0
    elseif uid == _G.GroupData.MasterUid then --门主解散
        self.MemberData = {}
        self.ThingData = {}
        self.VisibleMember = {}
        self.COPYTYPE = 0
    end
end

---仙门场景
--初始化
function GroupModel:initVisibleMenber(data)
    table.insert(self.VisibleMember,data)
end

--新增成员
function GroupModel:addVisibleMenber(data)
    table.insert(self.VisibleMember,data)
    dxyDispatcher_dispatchEvent("GroupFunc_addMember",data)
end

--退出场景
function GroupModel:exitVisibleMenber(uid)
    for key, var in pairs(self.VisibleMember) do
    	if var.Uid == uid then
            dxyDispatcher_dispatchEvent("LeadLayer_stopTimer")
            dxyDispatcher_dispatchEvent("GroupFunc_delMember",uid)
    	    table.remove(self.VisibleMember,key)
    	end
    end
end

--我退出场景
function GroupModel:cleanVisibleMenber()
    self.VisibleMember = {}
    self.COPYTYPE = 0
end

--初始化天赋
function GroupModel:initTalentData(data)
    self.TalentData = data
    dxyDispatcher_dispatchEvent("TalentNode_updateTalent",data)
end

--初始化祈福日志
function GroupModel:initPrayLog(data)
    if data then
        self.PrayLogData = data
        local function curSort(t1,t2)
            if t1.Exp == t2.Exp then
                return t1.Name > t2.Name
            else
                return t1.Exp > t2.Exp
            end
        end
        table.sort(self.PrayLogData,curSort)
        dxyDispatcher_dispatchEvent("PrayNode_addItemLog")
    end
end

----------对外接口---------------------------------------------------
--获取单个仙门信息
function GroupModel:getGroupListOne(num)
    return self.GroupList[num]
end
------------------------------------------------------------------

--sort
function GroupModel:sort(data)
    table.sort(data,function(c1,c2) return c1.root < c2.root end)
end

function GroupModel:cleanMyMemberList()
    self.MemberData = {}
end

--获取我在仙门中的DATA
function GroupModel:getMyDataInGroup(uid)
    for key, var in pairs(self.MemberData) do
    	if var.uid == uid then
    	    return var
    	end
    end
end
 
--设置我在仙门中的DATA
function GroupModel:setMyDataInGroup(data)  
    local curData = nil
    for key, var in pairs(self.MemberData) do
    	if var.uid == _G.RoleData.Uid then
            if var.contribute < data.contribute then
                cn:TipsSchedule("仙门贡献  +"..data.contribute-var.contribute)
            end
            if var.integral < data.integral then
                cn:TipsSchedule("仙门积分  +"..data.integral-var.integral)
            end
            var.praynum = data.praynum 
            var.praynum_rmb = data.praynum_rmb 
            var.integral = data.integral
            var.contribute = data.contribute
            
            --祈福排行
            self.TalentData.Contribute = var.contribute
            if self.PrayLogData then
                for key, var2 in pairs(self.PrayLogData) do
                    if var2.Uid == _G.RoleData.Uid then
                        if var2.Exp < data.exp then
                            cn:TipsSchedule("仙门经验 +"..data.exp - var2.Exp)
                        end
                        var2.Exp = data.exp
                        break
                    end
                end

                local function curSort(t1,t2)
                    if t1.Exp == t2.Exp then
                        return t1.Name > t2.Name
                    else
                        return t1.Exp > t2.Exp
                    end
                end

                table.sort(self.PrayLogData,curSort)
                dxyDispatcher_dispatchEvent("PrayNode_updateItemLog")
            
                dxyDispatcher_dispatchEvent("PrayNode_updatePrayUse",{Lv=self.GroupData.Lv,Num=var.praynum,NumRmb=var.praynum_rmb})
                break
        	end
        end
    end
end

---组队爬塔
function GroupModel:initTeamMember(data)
    self.TeamMember = data
    if SceneManager.m_curSceneName == "GameScene" then
--        local mainScene = MainScene:create()
--        SceneManager:enterScene(mainScene, "mainScene")
        require("game.loading.PreLoadScene")
        local preLoadScene = PreLoadScene.create()
        preLoadScene:initPreLoad("MainScene","dxyCocosStudio/csd/scene/MainScene_new.csb",function()
            zzc.GroupFuncCtrl:enterTower()
        end)
        SceneManager:enterScene(preLoadScene, "PreLoadScene")
    else
        zzc.GroupFuncCtrl:enterTower()
    end
    
--    zzc.GroupFuncCtrl:enterTower()
end

function GroupModel:exitTeamMember(data)
    if SceneManager.m_curSceneName == "mainScene" or SceneManager.m_curSceneName == "MainScene" then
        if data.Root == DefineConst.CONST_CLIMBING_TOWER_TEAM_CAPTAIN then --队长
            zzc.GroupFuncCtrl:exitTower()
            dxyFloatMsg:show("队伍已解散")
            self.TeamMember = {}
            self.isInTheTeam = false
        else
            if data.Uid == _G.RoleData.Uid then
                zzc.GroupFuncCtrl:exitTower()
                dxyFloatMsg:show("已退出组队")
                self.TeamMember = {}
                self.isInTheTeam = false
            else
                for key, var in pairs(self.TeamMember.Member) do
                	if var.Uid == data.Uid then
                        table.remove(self.TeamMember.Member,key)
                        break
                	end
                end
                dxyDispatcher_dispatchEvent("TeamCopy_delMember",data)
            end
        end
    end
end
--

--增加组队队员
function GroupModel:addTeamMember(data)
    table.insert(self.TeamMember.Member,data)
    dxyDispatcher_dispatchEvent("TeamCopy_addMember",data)
end

--组队爬塔是是否队长
function GroupModel:isCaptain()
    for key, var in pairs(self.TeamMember.Member) do
        if var.Uid == _G.RoleData.Uid then
            if var.Root == DefineConst.CONST_CLIMBING_TOWER_TEAM_CAPTAIN then
                return true
            else
                return false
            end
        end
    end
end

--更新准备状态
function GroupModel:changeTeamState(data)
    for key, var in pairs(self.TeamMember.Member) do
        if var.Uid == data.Uid then
            var.State = data.State
            dxyDispatcher_dispatchEvent("TeamCopy_updateState",data)
            dxyDispatcher_dispatchEvent("GameScene_TeamCopyState",data)
            break
        end
    end
end

---仙门商店兑换
function GroupModel:initGroupShop(data)
    self.GroupShopData = data 
    table.sort(self.GroupShopData,function(t1,t2) return t1.Box < t2.Box end)
end

function GroupModel:changeGroupShop(data)
    for key, var in pairs(self.GroupShopData) do
    	if var.Box == data.Box then
    	    var.State = data.State
            dxyDispatcher_dispatchEvent("GroupShop_changeItemShop",var)
    	    break
    	end
    end
end

function GroupModel:updateIntegral(integral)
    for key, var in pairs(self.MemberData) do
        if var.uid == _G.RoleData.Uid then
            var.integral = integral
            dxyDispatcher_dispatchEvent("GroupShop_updateJF")
            break
        end
    end
end

return GroupModel