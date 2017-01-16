
_G.SceneManager = _G.SceneManager or class("SceneManager")

function SceneManager:ctor(name)
   SceneManager.m_curSceneName = "defaultScene"
end

function SceneManager:getCurrentScene()
    return SceneManager.m_curScene
end

function SceneManager:enterScene(scene,name)
    print("--------enter scene name:"..name)
    if cc.Director:getInstance():getRunningScene() then
        if SceneManager.m_curScene then
            if SceneManager.m_curScene.WhenClose then
                SceneManager.m_curScene:WhenClose()
            end
        end
        
        SceneManager:initSFC()
        
        cc.Director:getInstance():replaceScene(scene)
        SceneManager.m_curScene = scene
        UIManager:WhenChangeScene(scene)
        UIManager:clearAll()
    else
        cc.Director:getInstance():runWithScene(scene)
        SceneManager.m_curScene = scene
    end
    
    SceneManager.m_curScene = scene
    SceneManager.m_curSceneName = name
    
    --local layer = mc.ClickBackTool:getInstance():getClickBackLayer()
    --SceneManager.m_curScene:addChild(layer)
    --local targetPlatform = cc.Application:getInstance():getTargetPlatform()
	--if targetPlatform == cc.PLATFORM_OS_ANDROID then
		--print "JniUtil.callCanLockScreenLua"
		--JniUtil.callCanLockScreenLua("test")
	--end
	
end

function SceneManager:initSFC()
    --图片放入缓存
--    cc.SpriteFrameCache:getInstance():addSpriteFrames("dxyCocosStudio/png/equip/BgPlist.plist")
--    cc.SpriteFrameCache:getInstance():addSpriteFrames("dxyCocosStudio/png/mainscene/Change.plist")
--    cc.SpriteFrameCache:getInstance():addSpriteFrames("dxyCocosStudio/png/yuanshen/Change.plist")
--    cc.SpriteFrameCache:getInstance():addSpriteFrames("dxyCocosStudio/png/yuanshen/stone/Change.plist")
--    cc.SpriteFrameCache:getInstance():addSpriteFrames("dxyCocosStudio/png/fairy/Change.plist")
--    cc.SpriteFrameCache:getInstance():addSpriteFrames("dxyCocosStudio/png/recharge/Change.plist")
--    cc.SpriteFrameCache:getInstance():addSpriteFrames("dxyCocosStudio/png/vip/change.plist")
--    cc.SpriteFrameCache:getInstance():addSpriteFrames("dxyCocosStudio/png/roleinfo/titleIcon/titleIconPlist.plist")
--    cc.SpriteFrameCache:getInstance():addSpriteFrames("dxyCocosStudio/png/general/new/Change.plist")
--    cc.SpriteFrameCache:getInstance():addSpriteFrames("dxyCocosStudio/png/ranking/Change.plist")
--    cc.SpriteFrameCache:getInstance():addSpriteFrames("dxyCocosStudio/png/worldboss/Change.plist")
    --提示音
--    SoundsFunc_addSoundFrames()
	print"inside DecodeFunc_LoginGame"
end

function SceneManager:SetUseSkill()
    SceneManager._UseSkillOK = true
end

function SceneManager:SetUseSkillUp()
    SceneManager._UseSkill = 2
end

function SceneManager:SetUseSkillDown()
    SceneManager._UseSkill = 9
end

function SceneManager:SetUseSkillRight()
    SceneManager._UseSkill = 8
end

function SceneManager:SetUseSkillLeft()
    SceneManager._UseSkill = 7
end

function SceneManager:SetComboMidle()
    SceneManager._ComboMidle = true
end

function SceneManager:SetFirstMonsterDead()
    SceneManager._FirstMonsterDead = true
end

function SceneManager:SetEndTalk()
    SceneManager._EndTalk = true
end

function SceneManager:GoToMainScene()
    SceneManager._GameEndMark = true
end

function SceneManager:CopyTimesIn()
    SceneManager._CopyTimesIn = true
end

function SceneManager:HaveUseHp()
    SceneManager._HaveUseHp = true
end

function SceneManager:HaveHalfMaxHp()
    SceneManager._HaveHalfMaxHp = true
end

function SceneManager:ReturnMainScene()
    SceneManager.m_curScene:WhenGameEnd()
--    local mainScene = MainScene:create()
--    SceneManager:enterScene(mainScene, "mainScene")
    require("game.loading.PreLoadScene")
    local preLoadScene = PreLoadScene.create()
    preLoadScene:initPreLoad("MainScene","dxyCocosStudio/csd/scene/MainScene_new.csb")
    SceneManager:enterScene(preLoadScene, "PreLoadScene")
end
function SceneManager:FightTips1()
    dxyFloatMsg:show("技能链冷却中")
end

function SceneManager:FightTips2()
    dxyFloatMsg:show("你的MP不足")
end

function SceneManager:FightTips3()
    dxyFloatMsg:show("技能冷却中")
end

function SceneManager:FightTips4()
    dxyFloatMsg:show("空中只能释放空中技能")
end

function SceneManager:FightTips5()
    dxyFloatMsg:show("护甲值不足")
end

function SceneManager:ReliveRmbTips()
    dxyFloatMsg:show("元宝不足")
end

function SceneManager:GoToMainSceneTest()
    cc.Director:getInstance():getActionManager():removeAllActions()
--    require("game.MainScene")
--    local mainScene = MainScene.create()
--    SceneManager:enterScene(mainScene, "MainScene")
    require("game.loading.PreLoadScene")
    local preLoadScene = PreLoadScene.create()
    preLoadScene:initPreLoad("MainScene","dxyCocosStudio/csd/scene/MainScene_new.csb")
    SceneManager:enterScene(preLoadScene, "PreLoadScene")
end

function SceneManager.setClearTimes(time)
    SceneManager._ClearTimes = MoneySceneConfig:getBaseValueByKey("fightTime") - math.ceil(time)
end

function SceneManager:showLoginScene()
    if _G.gSDKuc then   	
        local gameScene = zzc.LoginController:getScene()
        SceneManager:enterScene(gameScene, "LoginScene")
        SDKManagerLua.instance():login()
    elseif _G.gSDKhuawei then
        zzm.LoginModel.isOnHeand = true
        mc.NetMannager:getInstance():disconnect()
    elseif _G.gSDKbaidu then 
        zzm.LoginModel.isOnHeand = true
        mc.NetMannager:getInstance():disconnect()
    end
end

-- 登录界面的登录按钮处理
function SceneManager:httpRequest_LoginGame()
--    release_print("进入发送SID函数")
    local urlstr = nil
    if _G.gSDKuc then
        local sid = SDKManagerLua.instance():getSid()
        urlstr = zzm.GlobalModel.NetHead .. "api/CReturn/UcLogin" .. zzm.GlobalModel.CID .. "&uc_sid="..sid
    elseif _G.gSDKcgamebt then
        local userId = SDKManagerLua.instance():getSid()
        local cTime = os.time()       
        local cSign = mc.MD5:GetMD5String(zzm.GlobalModel.CID..userId..cTime.._G.gServerKey)
        urlstr = zzm.GlobalModel.NetHead.."api/Phone/Login".. zzm.GlobalModel.CID .."&userid="..userId.."&password=&time="..cTime.."&sign="..cSign
    elseif _G.gSDKhuawei then
        local token = SDKManagerLua.instance():getSid()
        local cTime = os.time()
        local cSign = mc.MD5:GetMD5String(zzm.GlobalModel.CID..token..cTime.._G.gServerKey)
        urlstr = zzm.GlobalModel.NetHead.."api/Phone/Login".. zzm.GlobalModel.CID .."&token="..token.."&time="..cTime.."&sign="..cSign
    elseif _G.gSDKoppo then
        local token = SDKManagerLua.instance():getExt1()
        local ssoid = SDKManagerLua.instance():getSid()
        local cSign = mc.MD5:GetMD5String(zzm.GlobalModel.CID..token..ssoid.._G.gServerKey)
        urlstr = zzm.GlobalModel.NetHead.."api/Phone/Login".. zzm.GlobalModel.CID .."&token="..token.."&ssoid="..ssoid.."&sign="..cSign   
    elseif _G.gSDK360 then 
        local token = SDKManagerLua.instance():getSid() 
        local cSign = mc.MD5:GetMD5String(zzm.GlobalModel.CID..token.._G.gServerKey)
        urlstr = zzm.GlobalModel.NetHead.."api/Phone/Login".. zzm.GlobalModel.CID .."&token="..token.."&sign="..cSign  
	elseif _G.gSDKbaidu then
		local token = SDKManagerLua.instance():getSid()
		local cTime = os.time()
		local cSign = mc.MD5:GetMD5String(zzm.GlobalModel.CID..token..cTime.._G.gServerKey)
		urlstr = zzm.GlobalModel.NetHead.."api/Phone/Login".. zzm.GlobalModel.CID .."&token="..token.."&time="..cTime.."&sign="..cSign
	elseif _G.gSDKxiaomi then
        local uid = SDKManagerLua.instance():getSid()
        local session = SDKManagerLua.instance():getExt1()
        local cTime = os.time()
        local cSign = mc.MD5:GetMD5String(zzm.GlobalModel.CID..uid..session..cTime.._G.gServerKey)
		urlstr = zzm.GlobalModel.NetHead.."api/Phone/Login".. zzm.GlobalModel.CID .."&uid="..uid.."&session="..session.."&time="..cTime.."&sign="..cSign
	elseif _G.gSDKhuoshu then
        local mem_id = SDKManagerLua.instance():getSid()
        local token = SDKManagerLua.instance():getExt1()
        local cTime = os.time()
        local cSign = mc.MD5:GetMD5String(zzm.GlobalModel.CID..mem_id..token..cTime.._G.gServerKey)
        urlstr = zzm.GlobalModel.NetHead.."api/Phone/Login".. zzm.GlobalModel.CID .."&mem_id="..mem_id.."&user_token="..token.."&time="..cTime.."&sign="..cSign
    end
--    urlstr = "http://xyapi.vwoof.com/api/Phone/Login?cid=800&uid=40705601&session=iYDam0OB6FfdE6e0&time=1456371079&sign=bc15b9f5bfd4199ca4713df45238fac2"
--    release_print(urlstr)
    local xhr = cc.XMLHttpRequest:new()
    dxyWaitBack:show()
--    release_print("显示菊花")
    local function onReadyStateChange()
        dxyWaitBack:close()
        if xhr.readyState == 4 and (xhr.status >= 200 and xhr.status < 207) then -- 成功
            -- json
            local response = string.gsub(xhr.response,"\\/","/")
            SceneManager:DecodeFunc_LoginGame(json.decode(response))
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

function SceneManager:DecodeFunc_LoginGame(data)
--    release_print("进入解包")
    local ref = data["ref"]
    local ucdata = data["data"] or nil
    local id = nil 
    local code = nil
    local msg = nil
    local uuid = nil
    local session_id = nil
    local session_time = nil
    local ext = nil
    if _G.gSDKuc then
    if ucdata then 
        id = ucdata["id"] or nil
        code = ucdata["code"] or nil
        msg = ucdata["msg"] or nil
        uuid = ucdata["uuid"] or nil
        session_id = ucdata["session_id"] or nil
        session_time = ucdata["session_time"] or nil
    end
    elseif _G.gSDKcgamebt or _G.gSDKhuawei or _G.gSDKoppo or _G.gSDK360 or _G.gSDKbaidu or _G.gSDKxiaomi or _G.gSDKhuoshu then
        uuid = data["uuid"] or nil
        session_id = data["session_id"] or nil
        session_time = data["session_time"] or nil
		ext = data["ext"] or nil
    end
	
	if _G.gSDK360 then
		local id = ext["id"] or nil
		local name = ext["name"] or nil
		local avatar = ext["avatar"] or nil
		local dataStr = "{\"id\":\""..id.."\",\"name\":\""..name.."\",\"avatar\":\""..avatar.."\"}"
		SDKManagerLua.instance():submitExtendData("",dataStr)
	end
    
	if _G.gSDK93damai or _G.gSDK93damai185 or _G.gSDKAoyou then
		uuid = data["uuid"] or nil
        session_id = data["session_id"] or nil
        session_time = data["session_time"] or nil
	end
	
    local error = data["error"] or nil
    local errmsg = data["msg"] or nil
    
--    local accountData = {
--        uuid = uuid,
--    }

--    release_print("id:"..id.."code:"..code.."msg:"..msg.."id:"..id.."session_id:"..session_id.."session_time"..session_time)


    if(ref == 1)then
        local accountData = {
            uuid = uuid,
            session_id = session_id,
            session_time = session_time,
            isRemember = false ,
            Account = 0,
            Password = 0,
        }
        zzm.LoginModel.loginData = accountData
        zzc.LoginController:enterLayer(LoginLayerType.StartLayer)        
    elseif(ref == 0)then
        TipsFrame:create(errmsg)
        print("error: "..error,"msg: "..errmsg)
    else
        TipsFrame:create("请求登陆失败")
        print("请求登陆失败")
        --请求服务器列表失败
    end
end

function SceneManager.setMusicByVaule(vaule) --背景音乐
    if vaule == 1 then --on
        SoundsInit:setMusic("on")
    elseif vaule == 2 then --off
        SoundsInit:setMusic("off")
    end
end

function SceneManager.setEffectByVaule(vaule) --音效
    if vaule == 1 then --on
        SoundsInit:setEffect("on")
    elseif vaule == 2 then --off
        SoundsInit:setEffect("off")
    end
 end

function SceneManager.ReturnMainSceneOnReliveLayer() --在副本死了但是没按复活
    SceneManager._isBeenDead = true
end

function SceneManager.setFightLose(flag)
    SceneManager.isFightLose = flag
end

function SceneManager.onBattleShowReturnBtn() --在战斗演示界面返回
    SceneManager.m_curScene:onBattleShowReturnBtn()
end

function SceneManager.fairylandSearchWin() --仙域中胜利
    zzc.StepTwoController:register_inScene()
    require("game.loading.TilemappreloadScene")
    local scene = TilemappreloadScene:create()
    scene:initPreLoad("dxyCocosStudio/csd/ui/immortalfield/ImmortalMainLyer.csb")
    SceneManager:enterScene(scene, "TilemappreloadScene")
end

function SceneManager.fairylandSearchLose() --仙域中战败
    zzc.StepTwoController:register_outScene()
    zzc.StepTwoController:getTileLayer():whenClose()

    require("game.loading.PreLoadScene")
    local preLoadScene = PreLoadScene.create()
    preLoadScene:initPreLoad("MainScene","dxyCocosStudio/csd/scene/MainScene_new.csb",function()
        zzc.TilemapController:showLayer()
    end)
    SceneManager:enterScene(preLoadScene, "PreLoadScene")
end

function SceneManager.fairylandSearchEscape() --仙域中逃跑
    zzc.StepTwoController:register_inScene()
    require("game.loading.TilemappreloadScene")
    local scene = TilemappreloadScene:create()
    scene:initPreLoad("dxyCocosStudio/csd/ui/immortalfield/ImmortalMainLyer.csb")
    SceneManager:enterScene(scene, "TilemappreloadScene")
end

function SceneManager.noHpToEscapeTips()
    cn:TipsSchedule("没有足够 HP 逃跑")
end

function SceneManager.enemyLostTips() --对手掉线
    cn:TipsSchedule("你的对手已 掉线")
end

function SceneManager.enemyEscapeTips() --对手逃跑
    cn:TipsSchedule("你的对手已 逃跑")
end

function SceneManager.beforEnterBackground() --将进入后台
    SceneManager._inTime = os.time()
	SceneManager._backgroundMark = true
	
	release_print("print log r ---------------- beforEnterBackground ------------------------------- print log r")
end

function SceneManager.willEnterForeground() --回到前台

	release_print("print log r ------------------- willEnterForeground ---------------------------- print log r")

	if SceneManager._backgroundMark then
		SceneManager._backgroundMark = nil
		
		SceneManager._outTime = os.time()
		local dis = SceneManager._outTime - SceneManager._inTime
		release_print(dis)
		release_print("print log r ------------------- willEnterForeground2 ---------------------------- print log r")
		if dis > 360 then
			-- 断开连接 , 释放监听（controler , event）,释放资源 , 退出SDK(不用退出SDK，断线重连即可)
			mc.NetMannager:getInstance():disconnect()
			
			dxyDispatcher_resetAll()
			
			zzc.LoginController:stopNetworkTimer()
			
			initMC.new()
			
			local logoScene = LogoScene:create()
			SceneManager:enterScene(logoScene, "LogoScene")
		end
	end
end

function G_CallbackFromJava_Pause(msg)
    if msg == "success" then
        release_print("print log r ------------------- G_CallbackFromJava_Pause ---------------------------- print log r")
		SceneManager.beforEnterBackground()
    end
end

function G_CallbackFromJava_Foreground(msg)
    if msg == "success" then
        --release_print("print log r ------------------- G_CallbackFromJava_Foreground ---------------------------- print log r")
    end
end

--------------------------------------------------------------------- JniUtil

_G.JniUtil = _G.JniUtil or {}

function JniUtil.callJavaCallbackLua(func)
    local luaj = require "cocos.cocos2d.luaj"
    local className = "org/cocos2dx/lua/AppActivity"
    local args = { "callBackLua_Foreground2", func }
    local sigs = "(Ljava/lang/String;I)V"
    local ok = luaj.callStaticMethod(className,"callBackLua_Foreground",args,sigs)
    if not ok then
        --print("============= call callback error")
    else
        --print("------------- call callback success")
    end
end

function JniUtil.onLuaCallBack(msg)
	--release_print("print log r ------------------- onLuaCallBack ---------------------------- print log r")
	--release_print(msg)
end

--release_print("print log r ------------------- JniUtil.callJavaCallbackLua1 ---------------------------- print log r")
--JniUtil.callJavaCallbackLua(JniUtil.onLuaCallBack)
--release_print("print log r ------------------- JniUtil.callJavaCallbackLua2 ---------------------------- print log r")

function JniUtil.callNoLockScreenLua(func)
    local luaj = require "cocos.cocos2d.luaj"
    local className = "org/cocos2dx/lua/AppActivity"
    local args = { "noLockScreen", func }
    local sigs = "(Ljava/lang/String;I)V"
    local ok = luaj.callStaticMethod(className,"noLockScreen",args,sigs)
    if not ok then
        --print("============= call callback error")
    else
        --print("------------- call callback success")
    end
end

function JniUtil.callCanLockScreenLua(func)
    local luaj = require "cocos.cocos2d.luaj"
    local className = "org/cocos2dx/lua/AppActivity"
    local args = { "canLockScreen", func }
    local sigs = "()V"
    local ok = luaj.callStaticMethod(className,"canLockScreen",args,sigs)
    if not ok then
        print("============= callCanLockScreenLua 11 callback error")
    else
        print("------------- callCanLockScreenLua 22 callback success")
    end
end