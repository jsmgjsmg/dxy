local LoginModel = class("LoginModel")
LoginModel.__index = LoginModel

function LoginModel:ctor()
    self.loginData = {}
    self.serverData = {}
    self.roleData = {}
    self.loginServer = {}
    
--    self.isConnect = false
    self.isOnHeand = false
    
    self.isTryAgainConnect = false
    self.tryAgainCount = 0
    
    self:initModel()
end

Debug_Account = "15800216245"
Debug_Password = "123456"
Debug_Account = "15800216245"
Debug_Password = "123456"
function LoginModel:initModel()

    self.registerData = {
        account = Debug_Account,
        password = Debug_Password,
--        identify = "",
--        account = "15119383674",
--        password = "123456",
        identify = "123",
    }

    self.loginData = {
        uuid = nil,
        session_id = nil,
        session_time = nil,
        host = nil,
        port = nil,
        isRemember = false,
        Account = Debug_Account,
        Password = Debug_Password,
--        Account = "15119383674",
--        Password = "123456",
        VersionNumber = "1.1.12345",
        loginTemp = {
            isRemember = false,
            Account = Debug_Account,
            Password = Debug_Password,}
--            Account = "15119383674",
--            Password = "123456",}
    }

--    local serverdata = {sid=1,host="dxy.7soul.com",port=10021,name="测试一服",status=0,is_new=1,}
    
    self.serverData = {
    _STEP_COUNT = 8,
    lastServerSid = nil,
    lastServer = {},
    recommendServerSid = nil,
    recommendServer = {},
    allList = {},
    haveRoleList = {},
    }
    
--    local role = {}
--    role.uid = msg:readUint()
--    role.name = msg:readString()
--    role.pro = msg:readByte()
--    role.lv = msg:readUshort()
--    role.time_del = msg:readUint()
    
    self.roleData = {
    _ALL_ROLE_COUNT = 4,             --可创建角色数量
    _DELETE_ROLE_TIME = 1*24*60*60,  --删除角色缓冲时间
    serverTimes = 0,
    curSelectRole = nil,
    roleCount = 0,
    allList = {},
    }
    
end

function LoginModel:getRoleData()
    return self.roleData
end

function LoginModel:setRoleData(data)
    self.roleData.serverTimes = data.serverTimes
    self.roleData.allList = data.allList
    self.roleData.roleCount = data.roleCount
    self:sortRoleData()
end

function LoginModel:insertRoleData(role)
    table.insert(self.roleData.allList,1,role)
    self.roleData.roleCount = #self.roleData.allList
    self:sortRoleData()
end

function LoginModel:sortRoleData()

end

function LoginModel:delRole(uid)
    for key, var in pairs(self.roleData.allList) do
    	if var.uid == uid then
            table.remove(self.roleData.allList,key)
            break
    	end
    end
    dxyDispatcher_dispatchEvent("SelectRoleLayer_delRole",uid)
end

function LoginModel:changeRole(data)
    for key, var in pairs(self.roleData.allList) do
        if var.uid == data.uid then
            var.time_del = data.time_del 
            dxyDispatcher_dispatchEvent("SelectRoleLayer_changeRole",var)
            dxyDispatcher_dispatchEvent("SelectRoleLayer_changeState",var.time_del)
            break
        end
    end
end

function LoginModel:chooseOtherOne()
    local num = #self.roleData.allList
    
end

function LoginModel:setServerData(data)
    self.serverData.lastServerTemp = data.lastServer
    self.serverData.recommendServer = data.recommendServer
    table.sort(self.serverData.recommendServer,self.sortRules)
    self.serverData.allList = data.allList
    table.sort(self.serverData.allList,self.sortRules)
    
    if #self.serverData.lastServerTemp == 0 then
        self.serverData.lastServer = self.serverData.recommendServer[#self.serverData.recommendServer]
    else
        self.serverData.lastServer = self.serverData.lastServerTemp[#self.serverData.lastServerTemp]
    end
    self:checkHaveRole()
end

function LoginModel.sortRules(serverA,serverB)
	return serverA.csid < serverB.csid
end

function LoginModel:checkHaveRole()
    local list = self.serverData.allList
    self.serverData.haveRoleList = {}
    for index=1, #list do
        if list[index].count > 0 then
            table.insert(self.serverData.haveRoleList,#self.serverData.haveRoleList+1,list[index])
        end
    end
end

function LoginModel:getServerById(sid)
    local list = self.serverData.allList
    for index=1, #list do
	   if list[index].csid == sid then
	       return list[index]
	   end
    end
    print("error: not find server data! error server sid :", sid)
    return nil
end

return LoginModel