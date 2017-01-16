
local LoginController = LoginController or class("LoginController")

function LoginController:ctor()
    self._isFirstConnectServer = true
    self._loginScene = nil
    self._model = nil
    self._STEP_COUNT = 8
    self:initController()
	self._askForReconnectUI = false
end 

function LoginController:showAskForReconnectUI()
   self._askForReconnectUI = true
   
   local layer = cc.LayerColor:create({r=0,g=0,b=0,a=128})
   local text = cc.LabelTTF:create("网络不给力，请点击屏幕重连服务器","",26)
   local layerSize = layer:getContentSize()
   text:setPosition(layerSize.width/2,layerSize.height/2)
   layer:addChild(text)
   SceneManager:getCurrentScene():addChild(layer,123456789)
   
       -- 拦截
    local function onTouchBegan(touch, event)
        return true
    end

    local function onTouchMoved(touch, event)
    end

    local function onTouchEnded(touch, event)
		self:tryAgainConnect()
		self._askForReconnectUI = false
		layer:removeFromParent()
    end

    local listener = cc.EventListenerTouchOneByOne:create()
    listener:registerScriptHandler(onTouchBegan,cc.Handler.EVENT_TOUCH_BEGAN )
    listener:registerScriptHandler(onTouchMoved,cc.Handler.EVENT_TOUCH_MOVED )
    listener:registerScriptHandler(onTouchEnded,cc.Handler.EVENT_TOUCH_ENDED )
    local eventDispatcher = cc.Director:getInstance():getEventDispatcher()
    eventDispatcher:addEventListenerWithSceneGraphPriority(listener, layer)
    listener:setSwallowTouches(true)
	
	
end

function LoginController:initController()
    self._model = zzm.LoginModel
    print("LoginController initController")
end

-- 打开Login的Layer，参数为 LoginLayerType
function LoginController:enterLayer(layerType)

    if layerType == nil then
        print("Error : layerType can not nil !")
        --self._loginScene:enterLayer(LoginLayerType.LoginLayer)
    else
        self._loginScene:enterLayer(layerType)
    end
end

-- 打开登录scene
-- 没有纪录帐号进入帐号输入界面
-- 已经纪录帐号进入开始游戏界面
function LoginController:enterStartOrLogin()
    if not zzm.LoginModel.isOnHeand then
        if zzm.LoginModel.loginData.isRemember == false then
            self:enterLayer(LoginLayerType.LoginLayer)
        else
            self:enterLayer(LoginLayerType.StartLayer)
        end
    end
end

-- 打开进入Loading Scene
function LoginController:enterLoadingScene(sceneType)
    local gameScene = zzc.LoadingController:getScene(sceneType)
    SceneManager:enterScene(gameScene, "LoadingScene")
end

function LoginController:enterNextScene()
    if _G._isTestingDebug then
		
		math.randomseed(os.time())
		local randValue = math.random(0,2)
		if randValue > 1 then 
			_G._isGotoMainScene = true
		else
			_G._isGotoMainScene = false
		end
		
		
        if _G._isGotoMainScene then
            self:enterMainScene()
            
        else
            self:enterCopyScene()
        end
        return
    end
    
    if zzm.LoginModel.isTryAgainConnect == true then
        self:enterMainScene()
        return
    end

    if self._roleLV == 1 then
        self:enterCopyScene()
    else
        self:enterMainScene()
    end
end


-- 打开进入Loading Scene
function LoginController:enterMainScene(roleUid)
    --require("game.MainScene")
    --local gameScene = MainScene.create()
    --SceneManager:enterScene(gameScene, "MainScene")
	--zzc.LoadingController:enterScene(SceneType.MainScene)
	
	require("game.loading.PreLoadScene")
    local preLoadScene = PreLoadScene.create()
	preLoadScene:initPreLoad("MainScene","dxyCocosStudio/csd/scene/MainScene_new.csb")
    SceneManager:enterScene(preLoadScene, "PreLoadScene")
end

function LoginController:enterCopyScene(data)
    local chapter = zzm.CopySelectModel:getChapterByID(1)
    local copyList = chapter.CopyId
    local data = SceneConfigProvider:getCopyById(copyList[1].CopyId)
    local startTalk = data.StartTalkId
    local endTalk = data.EndTalkId
    local chapterId = data.ChapterId
        if endTalk == nil then
            endTalk = 0
        end
        if startTalk == nil then
            startTalk = 0
        end
    SceneManager._EndTalk = false
    zzm.CopySelectModel.curCopyData  = {}--zzm.CopySelectModel:getCopyData(data.Id)
    zzm.CopySelectModel.curCopyData.config = data
    zzm.TalkingDataModel:onBegin(zzm.CopySelectModel.curCopyData.config.Id)
    zzc.LoadingController:setCopyData({copyType = 1, chapterID = data.ChapterId, startTalkID = startTalk, endTalkID = endTalk, sceneID = data.Id, param1 = 0})
    zzc.LoadingController:enterScene(SceneType.LoadingScene)
    zzc.LoadingController:setDelegate2(
        {target = self, 
            func = function (data)
                zzc.LoadingController:enterScene(SceneType.CopyScene)
            end,
            data = nil})
end

-- 开始界面开始游戏后
-- 没有创建过角色进入创建角色界面
-- 已经有创建角色进入角色选择界面
function LoginController:createOrSelectRole(roleCount)
    if _G._isTestingDebug == true then
        if not roleCount or roleCount == 0 then
            
            local _name = math.random(13900000000,13999999999)
            --local _pro = 2 -- math.random(1,3)
            local _pro = math.random(1,3)
            self:request_CreateRole({name = "T".._name, pro = _pro})
        else
            local roleData = zzm.LoginModel:getRoleData()
            local dataList = roleData.allList
            local data = dataList[1]
            zzc.LoginController:request_enterMainScene({uid = data.uid, lv = data.lv})
        end
        return
    end
    if not roleCount or roleCount == 0 then
		local battleShowStep = cc.UserDefault:getInstance():getIntegerForKey("BattleShowStep",0)
		--battleShowStep = 0 -- 0
		if battleShowStep == 0 then
			_G.MyData.returnBattleShowType = 1
			require("game.loading.LoadBattleShowScene")
			local lbss = LoadBattleShowScene.create()
			lbss:initPreLoad("LoginScene","GameScene/maps/YWC.csb",function()
                local i = 0
            end)
			SceneManager:enterScene(lbss, "LoadBattleShowScene")
		else
			self:enterLayer(LoginLayerType.CreateRoleLayer)
		end
        
	else
        self:enterLayer(LoginLayerType.SeclectRoleLayer)
	end
end

-- 打开登录scene
function LoginController:getScene()
    --if self._loginScene == nil then
        require "game.login.LoginScene"
        self._loginScene = LoginScene.create()
        self:enterStartOrLogin()
    --end
    return self._loginScene
end

function LoginController:getRecommendServer()
    return zzm.LoginModel.serverData.recommendServer
end

function LoginController:getLastServer()
    return zzm.LoginModel.serverData.lastServer
end

function LoginController:getHaveRoleServer()
    return zzm.LoginModel.serverData.haveRoleList
end

function LoginController:getServerGroup()
    local serverData = zzm.LoginModel.serverData
    return math.ceil(#serverData.allList/serverData._STEP_COUNT)
end

function LoginController:getSelectServer(index)
    local serverData = zzm.LoginModel.serverData
    local start = index*serverData._STEP_COUNT+1
    local endindex = start+serverData._STEP_COUNT-1
    if endindex > #serverData.allList then
        endindex = #serverData.allList
    end
    print("sdkhgigolighowglh   ----",start, endindex, #serverData.allList)
    local resultdata = {}
--    for i=endindex,start,-1 do
--        resultdata [endindex-i+1] = serverData.allList[i]
--    end
    for i=start ,endindex do
        resultdata [i-start+1] = serverData.allList[i]
    end
    print("sdkhgigolighowglh   ----", #resultdata)
    return resultdata
end


-----------------------------------------------------------------
---- 网络相关处理

--Http和Socket相关处理

-- 登录界面的登录按钮处理
function LoginController:httpRequest_LoginGame(data)

    local accout = data.Accout
    local password = data.Password
    --local md5password = mc.MD5:GetMD5String(password)
    --local md5password = MD5:GetMD5String(password)
    zzm.LoginModel.loginData.loginTemp = data
    local md5PW = mc.MD5:GetMD5String(password)
    local urlstr = zzm.GlobalModel.NetHead .."api/Phone/Login"..zzm.GlobalModel.CID.."&account="..accout.."&passwd="..md5PW
    if _G._isTestingDebug == true then
        urlstr = urlstr .. "&debug=1"
    end
    print(urlstr)
    local xhr = cc.XMLHttpRequest:new()
    dxyWaitBack:show()
    
    local function onReadyStateChange()
        dxyWaitBack:close()
        print("xhr.response " .. xhr.response)
        if xhr.readyState == 4 and (xhr.status >= 200 and xhr.status < 207) then -- 成功
            -- json
            self:DecodeFunc_LoginGame(json.decode(xhr.response))
        else
            TipsFrame:create("请求登陆失败")
            print("请求登陆失败")
            print("xhr.readyState is:", xhr.readyState, "xhr.status is: ",xhr.status) -- 失败
        end
    end

    xhr.responseType = cc.XMLHTTPREQUEST_RESPONSE_STRING
    xhr:open("GET", urlstr)
    xhr:registerScriptHandler(onReadyStateChange)
    xhr:send()
end

function LoginController:DecodeFunc_LoginGame(data)
    local ref = data["ref"]
    local uuid = data["uuid"] or nil
    local session_id = data["session_id"] or nil
    local session_time = data["session_time"] or nil
    local verify = data["verify"] and data["verify"] or nil
    local error = data["error"] and data["error"] or nil
    local msg = data["msg"] and data["msg"] or nil

    local temp = zzm.LoginModel.loginData.loginTemp
    if temp == nil then
    	temp = {}
    end
    local isRemember = temp.isRemember 
    local accout = temp.Accout 
    local password = temp.Password

    if(ref == 1)then
        print("Connect Suecceed")

--        _G.g_acount_uuid = uuid
--        _G.g_acount_session_id = session_id

        local accountData = {
            uuid = uuid,
            session_id = session_id,
            session_time = session_time,
            isRemember = isRemember,
            Account = accout,
            Password = password,
        }
        
        cc.UserDefault:getInstance():setBoolForKey(UserDefaulKey.AccountIsRemember, isRemember)
        cc.UserDefault:getInstance():setStringForKey(UserDefaulKey.Account, accout)
        cc.UserDefault:getInstance():setStringForKey(UserDefaulKey.Password, password)

        zzm.LoginModel.loginData = accountData
        if _G._isTestingDebug == true then
            self:httpRequest_SeversList()
            return
        end
        if zzc.LoginController.enterLayer then
        	--dxyFloatMsg:show("对不起，数据异常，请重新登录！！")
        	--return
        end
        zzc.LoginController:enterLayer(LoginLayerType.StartLayer)        

    elseif(ref == 0)then
        TipsFrame:create(msg)
        print("error: "..error,"msg: "..msg)
    else
        TipsFrame:create("请求登陆失败")
        print("请求登陆失败")
        --请求服务器列表失败
    end
end

-- 注册界面的获取验证码按钮处理
function LoginController:httpRequest_GetIdentify(account)
    zzm.LoginModel.registerData.account = account
    local xhr = cc.XMLHttpRequest:new()
    xhr.responseType = cc.XMLHTTPREQUEST_RESPONSE_STRING
    local urlstr = zzm.GlobalModel.NetHead .."api/Phone/Verify?phone="..account.."&type=1"
    xhr:open("GET", urlstr)
    dxyWaitBack:show()
    local function onReadyStateChange()
        dxyWaitBack:close()
        if xhr.readyState == 4 and (xhr.status >= 200 and xhr.status < 207) then -- 成功
            print(xhr.response)--
            -- json
            self:DecodeFunc_GetIdentify(json.decode(xhr.response))
        else
            TipsFrame:create("请求注册失败")
            print("请求注册失败")
            print("xhr.readyState is:", xhr.readyState, "xhr.status is: ",xhr.status) -- 失败
        end
    end
    xhr:registerScriptHandler(onReadyStateChange)
    xhr:send()
end

function LoginController:DecodeFunc_GetIdentify(data)
    local ref = data["ref"]
    local type = data["type"] or nil
    local verify = data["verify"] and data["verify"] or nil
    local error = data["error"] and data["error"] or nil
    local msg = data["msg"] and data["msg"] or nil
    if(ref == 1)then
        print("Connect Suecceed")
        zzm.LoginModel.registerData.identify = verify
        dxyDispatcher_dispatchEvent(dxyEventType.Login_UpdateIdentify, verify)
    elseif(ref == 0)then
        TipsFrame:create(msg)
        print("error: "..error,"msg: "..msg)
    else
        TipsFrame:create("请求验证码失败")
        print("请求验证码失败")
    end
end

-- 重置密码界面的获取验证码按钮处理
function LoginController:httpRequest_GetPasswordIdentify(account)
    zzm.LoginModel.registerData.account = account
    local xhr = cc.XMLHttpRequest:new()
    xhr.responseType = cc.XMLHTTPREQUEST_RESPONSE_STRING
    local urlstr = zzm.GlobalModel.NetHead .."api/Phone/Verify?phone="..account.."&type=2"
    xhr:open("GET", urlstr)
    dxyWaitBack:show()
    local function onReadyStateChange()
        dxyWaitBack:close()
        if xhr.readyState == 4 and (xhr.status >= 200 and xhr.status < 207) then -- 成功
            print(xhr.response)--
            -- json
            self:DecodeFunc_GetPasswordIdentify(json.decode(xhr.response))
        else
            TipsFrame:create("请求注册失败")
            print("请求注册失败")
            print("xhr.readyState is:", xhr.readyState, "xhr.status is: ",xhr.status) -- 失败
        end
    end
    xhr:registerScriptHandler(onReadyStateChange)
    xhr:send()
end

function LoginController:DecodeFunc_GetPasswordIdentify(data)
    local ref = data["ref"]
    local type = data["type"] or nil
    local verify = data["verify"] and data["verify"] or nil
    local error = data["error"] and data["error"] or nil
    local msg = data["msg"] and data["msg"] or nil
    if(ref == 1)then
        print("Connect Suecceed")
        zzm.LoginModel.registerData.identify = verify
        dxyDispatcher_dispatchEvent(dxyEventType.Login_UpdateIdentify, verify)
    elseif(ref == 0)then
        TipsFrame:create(msg)
        print("error: "..error,"msg: "..msg)
    else
        TipsFrame:create("请求验证码失败")
        print("请求验证码失败")
    end
end

-- 注册界面的提交注册按钮处理
function LoginController:httpRequest_SureRegister(data)
    zzm.LoginModel.registerData = data
    local xhr = cc.XMLHttpRequest:new()
    xhr.responseType = cc.XMLHTTPREQUEST_RESPONSE_STRING
    local md5PW = mc.MD5:GetMD5String(data.password) -- 加密
    local urlstr = zzm.GlobalModel.NetHead .."api/Phone/Register"..zzm.GlobalModel.CID.."&account="..data.account.."&passwd="..md5PW.."&verify="..data.identify
    print("Register: "..urlstr..".........................")
    xhr:open("GET", urlstr)
    dxyWaitBack:show()
    local function onReadyStateChange()
        dxyWaitBack:close()
        if xhr.readyState == 4 and (xhr.status >= 200 and xhr.status < 207) then -- 成功
            print(xhr.response)--
            -- json
            self:DecodeFunc_Regist(json.decode(xhr.response))
        else
            TipsFrame:create("请求注册失败")
            print("请求注册失败")
            print("xhr.readyState is:", xhr.readyState, "xhr.status is: ",xhr.status) -- 失败
        end
    end
    xhr:registerScriptHandler(onReadyStateChange)
    xhr:send()
end

function LoginController:DecodeFunc_Regist(dec)
    local ref = dec["ref"] or nil
    local error = dec["error"] or nil
    local msg = dec["msg"] or nil

    if(ref == 1)then
        print("Register Succeed.......")
        local data = {}
        data.Accout = zzm.LoginModel.registerData.account
        data.Password = zzm.LoginModel.registerData.password
        data.isRemember = true
        self:httpRequest_LoginGame(data)
    elseif(ref == 0)then
        print("error: "..error.."msg:"..msg)
        TipsFrame:create("注册失败")
    else
        TipsFrame:create("注册失败2")
        print("注册失败2")
    end

end

-- 重置密码处理
function LoginController:httpRequest_ResetPassword(data)
    zzm.LoginModel.registerData = data
    local xhr = cc.XMLHttpRequest:new()
    xhr.responseType = cc.XMLHTTPREQUEST_RESPONSE_STRING
    local md5PW = mc.MD5:GetMD5String(data.password) -- 加密
    local urlstr = zzm.GlobalModel.NetHead .."api/Phone/ResetPasswd?account="..data.account.."&password="..md5PW.."&verify="..data.identify
    xhr:open("GET", urlstr)
    dxyWaitBack:show()
    local function onReadyStateChange()
        dxyWaitBack:close()
        if xhr.readyState == 4 and (xhr.status >= 200 and xhr.status < 207) then -- 成功
            print(xhr.response)--
            -- json
            self:DecodeFunc_ResetPassword(json.decode(xhr.response))
        else
            TipsFrame:create("重置密码失败")
            print("重置密码失败")
            print(xhr.response)
            print("xhr.readyState is:", xhr.readyState, "xhr.status is: ",xhr.status) -- 失败
        end
    end
    xhr:registerScriptHandler(onReadyStateChange)
    xhr:send()
end

function LoginController:DecodeFunc_ResetPassword(dec)
    local ref = dec["ref"] or nil
    local error = dec["error"] or nil
    local msg = dec["msg"] or nil

    if(ref == 1)then
        print("ResetPassword Succeed.......")
        local data = {}
        data.Accout = zzm.LoginModel.registerData.account
        data.Password = zzm.LoginModel.registerData.password
        data.isRemember = true
        self:httpRequest_LoginGame(data)
    elseif(ref == 0)then
        print("error: "..error.."msg:"..msg)
        TipsFrame:create("重置失败")
    else
        TipsFrame:create("重置失败2")
        print("重置失败2")
    end

end


-- 开始界面的开始游戏按钮处理
function LoginController:httpRequest_SeversList()
    local urlstr = zzm.GlobalModel.NetHead  .. "api/Phone/ServList"..zzm.GlobalModel.CID.."&uuid="..zzm.LoginModel.loginData.uuid
--    local urlstr = zzm.GlobalModel.NetHead  .. "api/Phone/ServList?cid=888&uuid="..zzm.LoginModel.loginData.uuid
    local xhr = cc.XMLHttpRequest:new()
    dxyWaitBack:show()
    local function onReadyStateChange()
        dxyWaitBack:close()
        if xhr.readyState == 4 and (xhr.status >= 200 and xhr.status < 207) then -- 成功
            print(xhr.response)--
            -- json
            self:DecodeFunc_SeversList(json.decode(xhr.response))
        else
            TipsFrame:create("请求服务器列表失败1")
            print("请求服务器列表失败1")
            print("xhr.readyState is:", xhr.readyState, "xhr.status is: ",xhr.status) -- 失败
        end
    end

    xhr.responseType = cc.XMLHTTPREQUEST_RESPONSE_STRING
    xhr:open("GET", urlstr)
    xhr:registerScriptHandler(onReadyStateChange)
    xhr:send()
end

function LoginController:DecodeFunc_SeversList(data)
    local ref = data["ref"]
    local history = data["history"] and data["history"] or nil
    local recommend = data["recommend"] and data["recommend"] or nil
    local serv_all = data["all"] and data["all"] or nil
    local error = data["error"] or nil
    local msg = data["msg"] or nil

    if(ref == 1)then
        print("Connect Suecceed")
        zzm.LoginModel:setServerData({lastServer = history, recommendServer = recommend, allList = serv_all})
        local server = zzm.LoginModel.serverData.lastServer
        if _G._isTestingDebug == true then
            local server = zzm.LoginModel.serverData.allList[1]
            zzc.LoginController:connectServerSecond(server)
            zzm.LoginModel.loginServer = server
            return
        end
        if zzm.LoginModel.isTryAgainConnect == true then
            zzc.LoginController:connectServerSecond(server)
        end
        dxyDispatcher_dispatchEvent(dxyEventType.Login_UpdateLastServer, server)
    elseif(ref == 0)then
        TipsFrame:create(msg)
        print("error: "..error,"msg: "..msg)
    else
        TipsFrame:create("请求服务器列表失败2")
        print("请求服务器列表失败2")
    end
end


--Network 
--initNetwork
function LoginController:registerListenner()
    _G.NetManagerLuaInst:registerListenner(NetEventType.Rec_Login_Logic_Server,self)
    _G.NetManagerLuaInst:registerListenner(NetEventType.Rec_Login_Server,self)
    _G.NetManagerLuaInst:registerListenner(NetEventType.Rec_Create_Role,self)
    _G.NetManagerLuaInst:registerListenner(NetEventType.Rec_Enter_Game,self)
    _G.NetManagerLuaInst:registerListenner(NetEventType.Rec_Error_Code,self)
    _G.NetManagerLuaInst:registerListenner(NetEventType.Rec_Login_DelRole,self)
--    _G.NetManagerLuaInst:registerListenner(440,self)
    -- updateMsg
    NetManagerLua.instance():startUpdate()
    
    if _G._isTestingDebug == true then
        self._myDebugTimer = self._myDebugTimer or require("game.utils.MyTimer").new()
        local function tick()
            self._myDebugTimer:stop()
            self._myDebugTimer = nil
            self:testLogin()
        end
        self._myDebugTimer:start(0.5, tick)
    end

end

function LoginController:unregisterListenner()
    self._myDisConnectServerTimer = nil
    self._myGameServerTimer = nil
    self._mySubServerTimer = nil
    _G.NetManagerLuaInst:unregisterListenner(NetEventType.Rec_Login_Logic_Server,self)
    _G.NetManagerLuaInst:unregisterListenner(NetEventType.Rec_Login_Server,self)
    _G.NetManagerLuaInst:unregisterListenner(NetEventType.Rec_Create_Role,self)
    _G.NetManagerLuaInst:unregisterListenner(NetEventType.Rec_Enter_Game,self)
    _G.NetManagerLuaInst:unregisterListenner(NetEventType.Rec_Login_DelRole,self)
--    _G.NetManagerLuaInst:unregisterListenner(NetEventType.Rec_Error_Code,self) 
--    _G.NetManagerLuaInst:unregisterListenner(440,self) 
end

function LoginController:connectServerFirst(serverData)
        
        -- 链接服务器时停止网络链接检查
        if self._myGameNetworkTimer then
            self._myGameNetworkTimer:stop()
            self._myGameNetworkTimer = nil
        end

        dxyWaitBack:show()
        
        local ip = serverData.host
        local port = serverData.port
        print("Connect1 ----------------....",ip,port)
        ip = mc.NetMannager:getInstance():getIpByDNS(ip)
        port = tonumber(port)

        -- 需要再次连接(返回IP、端口)
        --local isConnect = mc.NetMannager:getInstance():connect("192.168.6.5",10011);
        local isConnect = nil
        -- 第一次链接使用connect 以后都使用reConnect
        if self._isFirstConnectServer then
            isConnect = mc.NetMannager:getInstance():connect(ip,port);
            self._isFirstConnectServer = false
        else
            isConnect = mc.NetMannager:getInstance():reConnect(ip,port)
        end
        
        print("Connect2 ----------------....",isConnect,ip,port)
        if isConnect then
            print("1 Connect Succeed....")
            self:request_LinkServerFirst()
        else
            self:checkConnectGameServerTimer()
        end
end


function LoginController:checkConnectGameServerTimer()
    self._myGameServerTimer = self._myGameServerTimer or require("game.utils.MyTimer").new()
    local function tick()
        if mc.NetMannager:getInstance():checkReConnect() == true then
            print("----- Try Re Connect")
            return
        end
        if mc.NetMannager:getInstance():getConnectState() == 1 then 
            print("2 Connect Succeed....")
            self:request_LinkServerFirst()
            self._myGameServerTimer:stop()
        elseif mc.NetMannager:getInstance():getConnectState() == -1 then
            print("连接失败")
            dxyWaitBack:close()
            TipsFrame:create("连接失败")
            self._myGameServerTimer:stop()
        elseif mc.NetMannager:getInstance():getConnectState() == -2 then
            print("连接超时")
            dxyWaitBack:close()
            TipsFrame:create("连接超时")
            self._myGameServerTimer:stop()
        elseif mc.NetMannager:getInstance():getConnectState() == 0 then
            print("继续等待")
        end
        print("-----------"..mc.NetMannager:getInstance():getConnectState())
    end
    self._myGameServerTimer:start(0.5, tick)
end

function LoginController:connectServerSecond(serverData)
    if serverData == nil then
    	dxyFloatMsg:show("数据异常，请尝试重新选择服务器。")
    	return
    end
    local ip = serverData.ip
    local port = serverData.port
    ip = mc.NetMannager:getInstance():getIpByDNS(ip)
    port = tonumber(port)
    
    dxyWaitBack:show(nil, false)

    -- 需要再次连接(返回IP、端口)
    local isConnect = nil
    -- 第一次链接使用connect 以后都使用reConnect
    if self._isFirstConnectServer then
        isConnect = mc.NetMannager:getInstance():connect(ip,port);
        self._isFirstConnectServer = false
    else
        isConnect = mc.NetMannager:getInstance():reConnect(ip,port)
    end
    print("Connect ----------------....",self._isFirstConnectServer,isConnect,ip,port)
    if isConnect then
        print("Connect Succeed....")
        self:request_LinkServerSecond()
    else
        print("Try Check")
        self:checkConnectSubServerTimer()
    end
end

function LoginController:checkConnectSubServerTimer()
    self._mySubServerTimer = self._mySubServerTimer or require("game.utils.MyTimer").new()
    local function tick()
        print("------check")
        if mc.NetMannager:getInstance():checkReConnect() == true then
            print("----- Try Re Connect")
            return
        end
        
        local state = mc.NetMannager:getInstance():getConnectState()
        print(state)
        if state == 0 then
            print("继续等待")
            return
        end
        if state == 1 then 
            print("Connect Succeed....")
            if self._mySubServerTimer then
                self._mySubServerTimer:stop()
                self._mySubServerTimer = nil
            end
            dxyWaitBack:close()
            self:request_LinkServerSecond()
            return
        end
        
        if zzm.LoginModel.isTryAgainConnect == true then
            if self._mySubServerTimer then
                self._mySubServerTimer:stop()
                self._mySubServerTimer = nil
            end
            
            if zzm.LoginModel.tryAgainCount >= 3 then
                zzm.LoginModel.tryAgainCount = 0
                zzm.LoginModel.isTryAgainConnect = false
                local loginScene = zzc.LoginController:getScene()
                print("check Game Network is Not Connect ......2")
                SceneManager:enterScene(loginScene,"loginScene")
                TipsFrame:create("你的网络已断开，请检查网络！！！")
            end
            
            if state == -1 then
                print("连接失败")
            elseif state == -2 then
                print("连接超时")
            end
            --dxyWaitBack:close()
            mc.NetMannager:getInstance():disconnect()
            self._isFirstConnectServer = true
            self:tryAgainConnect()

            return
        end
        
        
        if state == -1 then
            print("连接失败")
            dxyWaitBack:close()
            TipsFrame:create("连接失败")
        elseif state == -2 then
            print("连接超时")
            dxyWaitBack:close()
            TipsFrame:create("连接超时")
        end
        
        if self._mySubServerTimer then
            self._mySubServerTimer:stop()
            self._mySubServerTimer = nil
        end
    end
    self._mySubServerTimer:start(0.2, tick)
end

function LoginController:checkGameNetworkTimer()
    self._myGameNetworkTimer = self._myGameNetworkTimer or require("game.utils.MyTimer").new()
    local function tick()

		if self._askForReconnectUI then return end
	
        if mc.NetMannager:getInstance():checkDisConnect() == true then
            local lastMsg = mc.NetMannager:getInstance():getLastMsg()
            
            if not zzm.LoginModel.isOnHeand then
--                local gameScene = zzc.LoginController:getScene()
--                SceneManager:enterScene(gameScene, "LoginScene")
            
                zzm.LoginModel.isTryAgainConnect = true

                if _G.NormalQuitLogin then
                    _G.NormalQuitLogin = nil
                elseif lastMsg ~= nil and lastMsg:getCmd() == 440 then
                    local gameScene = zzc.LoginController:getScene()
                    SceneManager:enterScene(gameScene, "LoginScene")
                    TipsFrame:create("你的账号已在别处登陆11")
                else
                    if zzm.LoginModel.isTryAgainConnect == true then
--                        self._isFirstConnectServer = false
                        --mc.NetMannager:getInstance():disconnect()
						
						print("look here -------------------------------------------------- look here")
						self:showAskForReconnectUI()
                        --self:tryAgainConnect()
						
						
						
--                        cn:removeAllNetController() --清理网络协议
--                        initMC.new() --清理Model/Controller
--                        self._myGameNetworkTimer:stop()
--                        return
                    end
                    --TipsFrame:create("网络已断开11")
                end
                cn:removeAllNetController() --清理网络协议
                initMC.new() --清理Model/Controller
            else
                local gameScene = zzc.LoginController:getScene()
                SceneManager:enterScene(gameScene, "LoginScene")
                gameScene:enterLayer(LoginLayerType.LoginLayer)
                SDKManagerLua.instance():login()
            end
            
            self._isFirstConnectServer = false
            --mc.NetMannager:getInstance():realEndConnect()
            self._myGameNetworkTimer:stop()
            return
        end
        --print("check Game Network is Connect ......111")
    end
    
    self._myGameNetworkTimer:start(3, tick)
end

--Request
-- 获取逻辑节点地址 Request Type 700  Receive Type 710
function LoginController:request_LinkServerFirst()
    self:request_LinkServer(NetEventType.Req_Login_Logic_Server)
end

-- 登陆 Request Type 1002  Receive Type 1004
function LoginController:request_LinkServerSecond()
    self:request_LinkServer(NetEventType.Req_Login_Server)
end

--request link server
function LoginController:request_LinkServer(requestType)
    print("----> requestType:" .. requestType)
    local data = zzm.LoginModel.loginData
    local cid = tonumber(zzm.GlobalModel.m_CID)
    print(cid)
    local uuid = tonumber(data.uuid)
    print(uuid)
    local session_id = data.session_id
    print(session_id)
    local session_time = tonumber(data.session_time)
    print(session_time)
    
    mc.NetMannager:getInstance():startRecvThread(); -- 启动线程
    
    local msg = mc.packetData:createWritePacket(requestType); --编写发送包
    msg:writeInt(cid)
    msg:writeInt(uuid)
    msg:writeString(session_id)
    msg:writeInt(session_time)

    mc.NetMannager:getInstance():sendMsg(msg); --发送 包
end

-- 创建角色 Request Type 1006  Receive Type 1008
function LoginController:request_CreateRole(data)
    print("request_CreateRole name: "..data.name.." pro: "..data.pro)
    local msg = mc.packetData:createWritePacket(NetEventType.Req_Create_Role); --编写发送包
    msg:writeString(data.name)
    msg:writeByte(data.pro)
    mc.NetMannager:getInstance():sendMsg(msg); --发送 包
end

-- 进入主城 Request Type 1020  Receive Type 1022
function LoginController:request_enterMainScene(data)
    dxyWaitBack:show()  
    print("request_enterMainScene uid: "..data.uid)
    print(data.lv)
    self._roleLV = data.lv
    local msg = mc.packetData:createWritePacket(NetEventType.Req_Enter_Game); --编写发送包
    msg:writeInt(data.uid)
    mc.NetMannager:getInstance():sendMsg(msg); --发送 包
end

--删除角色
function LoginController:delRole(uid,type)
    local msg = mc.packetData:createWritePacket(NetEventType.Req_Login_DelRole); --编写发送包
    msg:writeInt(uid)
    msg:writeByte(type)
    mc.NetMannager:getInstance():sendMsg(msg); --发送 包
    print("Send---------------------------------"..NetEventType.Req_Login_DelRole.." uid "..uid.." type "..type)
end

--Receive
function LoginController:dealMsg(msg)
    local cmdType = msg:getpacketCmdType()
    if cmdType == NetEventType.Rec_Error_Code then
        local code = msg:readUshort()
        
        if ErrorCode[""..code] == ErrorCode["150"] then
            zzc.HelperController:showLayer(3)
        end
        
        if ErrorCode[""..code] == ErrorCode["160"] then
            zzc.HelperController:showLayer(4)
        end
        
        if ErrorCode[""..code] then
            cn:TipsSchedule(ErrorCode[""..code])
            SoundsFunc_playSounds(SoundsType.FAILE_TO_USE,false)
        end
        
        print("网络消息错误，错误代码  "..code)
    elseif cmdType == NetEventType.Rec_Login_Logic_Server then
        --First Server登录成功

        zzm.LoginModel.loginData.host = msg:readString()
        zzm.LoginModel.loginData.port = msg:readUshort()
        print("--->host ".. zzm.LoginModel.loginData.host)
        print("--->port ".. zzm.LoginModel.loginData.port)
        self:connectServerSecond(zzm.LoginModel.loginData)
    elseif cmdType == NetEventType.Rec_Login_Server then
        --Second Server登录成功
        print("======= 1004 return ")
        local data = {}
        data.serverTimes = msg:readUint()
        cn:DiffTimer(data.serverTimes)
        data.roleCount = msg:readByte()
        data.allList = {}
        for var=1, data.roleCount do
        	local role = {}
            role.uid = msg:readUint()
            role.name = msg:readString()
            role.pro = msg:readByte()
            role.lv = msg:readUshort()
            role.time_del = msg:readUint()
            table.insert(data.allList,1+#data.allList,role)
            print("role index:".. var .. " uid:".. role.uid .. " name:"..role.name)
        end
        
        self:checkGameNetworkTimer()
        zzm.LoginModel:setRoleData(data)

        if zzm.LoginModel.isTryAgainConnect == true then
            local role = zzm.LoginModel.loginData.curRoleData 
            if role == nil then
            	dxyFloatMsg:show("角色数据丢失，请重新登录！！！")
            	return
            end
            zzc.LoginController:request_enterMainScene({uid = role.uid, lv = role.lv})
        	return
        end
        

        if zzm.LoginModel.isOnHeand then 
            local gameScene = zzc.LoginController:getScene()
            SceneManager:enterScene(gameScene, "LoginScene")
        end
        dxyWaitBack:close()
        self:createOrSelectRole(data.roleCount)
        return true
    elseif cmdType == NetEventType.Rec_Create_Role then
        --角色创建成功，进入角色选择界面
        local enCAT = enCharacterAttrType
        local role = zzd.CharacterData.new()
        role.uid = enCAT:readMsg(msg,enCAT.UID)
        role.name = enCAT:readMsg(msg,enCAT.NAME)
        role.pro = enCAT:readMsg(msg,enCAT.PRO)
        role.lv = enCAT:readMsg(msg,enCAT.LV)
        role.time_del = 0
        zzm.LoginModel:insertRoleData(role)
        print("role uid:".. role.uid .. " name:"..role.name)
        if _G._isTestingDebug == true then
            local roleData = zzm.LoginModel:getRoleData()
            local dataList = roleData.allList
            local data = dataList[1]
            zzc.LoginController:request_enterMainScene({uid = data.uid, lv = data.lv})
        end
        self:enterLayer(LoginLayerType.SeclectRoleLayer)
    elseif cmdType == NetEventType.Rec_Enter_Game then
        dxyWaitBack:close()  
        local enCAT = enCharacterAttrType
        local role = zzd.CharacterData.new()
        role.uid = enCAT:readMsg(msg,enCAT.UID)
        role.gold = enCAT:readMsg(msg,enCAT.GOLD)
        role.rmb = enCAT:readMsg(msg,enCAT.RMB)
        role.renown = enCAT:readMsg(msg,enCAT.RENOWN)
        role.godsoul = enCAT:readMsg(msg,enCAT.GODSOUL)
        role.anima = enCAT:readMsg(msg,enCAT.ANIMA)
        role.soul = enCAT:readMsg(msg,enCAT.SOUL)
        role.flower = enCAT:readMsg(msg,enCAT.FLOWER)
        role.energysoul = enCAT:readMsg(msg,enCAT.ENERGYSOUL)
        role.amulet = enCAT:readMsg(msg,enCAT.AMULET)
        role.moneycount = enCAT:readMsg(msg,enCAT.MONEYCOUNT)
        role.moneylayer = enCAT:readMsg(msg,enCAT.MONEYLAYER)
        role.physical = enCAT:readMsg(msg,enCAT.PHYSICAL)
        role.physicalbuy = enCAT:readMsg(msg,enCAT.PHYSICALBUY)
        role.trainexpcount = enCAT:readMsg(msg,enCAT.TRAINEXPCOUNT)
        role.trainflowercount = enCAT:readMsg(msg,enCAT.TRAINFLOWERCOUNT)
        role.trainrenowncount = enCAT:readMsg(msg,enCAT.TRAINRENOWNCOUNT)
        role.explore = enCAT:readMsg(msg,enCAT.EXPLORE)
        role.warcount = enCAT:readMsg(msg,enCAT.WARCOUNT)
        role.warbuy = enCAT:readMsg(msg,enCAT.WARBUY)
        role.gncopyud = enCAT:readMsg(msg,enCAT.GNCOPYUD)
        role.gncopycn = enCAT:readMsg(msg,enCAT.GNCOPYCN)
        role.gncopydfc = enCAT:readMsg(msg,enCAT.GNCOPYDFC)
        role.gncopymst = enCAT:readMsg(msg,enCAT.GNCOPYMST)
        role.godphysicalbuy = enCAT:readMsg(msg,enCAT.GODPHYSICALBUY)
        role.tccount = enCAT:readMsg(msg,enCAT.TCCOUNT)
        role.tclevel = enCAT:readMsg(msg,enCAT.TCLEVEL)
        
        
        zzc.CopySelectController:request_CopyList()
        zzm.CharacterModel:setCharacterData(role)
        zzc.CharacterController:request_Backpack()
--        zzc.CharacterController:request_SkillList()
--        zzc.CharacterController:request_CTSkillList()
        zzc.SkillController:request_SkillList()
        zzc.SkillController:request_CTSkillList()
        
        zzc.FriendController:request_InitFriend()
        
        _G.RoleData.Uid = role.uid
        _G.RoleData.Gold = role.gold
        _G.RoleData.Renown = role.renown
        _G.RoleData.RMB = role.rmb
        _G.gRoleRMB = role.rmb
        
        _G.FairyData.Flower = role.flower
        
        --进入主城场景
        --self:enterMainScene()
        --self:enterCopyScene()
        self:enterNextScene()
    elseif cmdType == NetEventType.Rec_Login_DelRole then --1012(删除角色)
        local data = {}
        data.uid = msg:readUint()
        data.time_del = msg:readUint()
        zzm.LoginModel:changeRole(data)
        
    end
    -- 默认返回false ，表示不中断读取下一个msg
    return false

end


function LoginController:tryAgainConnect()
    --mc.NetMannager:getInstance():disconnect()
    --self:httpRequest_SeversList()
    zzm.LoginModel.tryAgainCount = zzm.LoginModel.tryAgainCount + 1
    self:connectServerSecond(zzm.LoginModel.loginServer)
end


------------------------------------------------------------------------------
--
------------------------------------------------------------------------------

function LoginController:testLogin()
    --zzm.GlobalModel.type = 1 --1 内网 2 外网
    zzm.GlobalModel:changeNet()
    math.randomseed(os.time())
    local data = {}
    data.isRemember = cc.UserDefault:getInstance():getBoolForKey(UserDefaulKey.AccountIsRemember,false)
    data.Accout = math.random(13300000000,13699999999) .. ""
    data.Password = "123456"
    if data.isRemember then
        data.Accout = cc.UserDefault:getInstance():getStringForKey(UserDefaulKey.Account,"13922365801")
    end
    data.isRemember = true
    self:httpRequest_LoginGame(data)
end

function LoginController:stopNetworkTimer()
	if not (self._myGameNetworkTimer == nil) then
		self._myGameNetworkTimer:stop()
	end
end

return LoginController
