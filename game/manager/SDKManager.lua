SDKManagerLua = SDKManagerLua or class("SDKManagerLua",{})

function SDKManagerLua:ctor()
    self.listenerTable = {}
end

function SDKManagerLua.create()
    local mgr = SDKManagerLua.new()
    return mgr
end

_G.SDKManagerLuaInst = _G.SDKManagerLuaInst or SDKManagerLua.create()

function SDKManagerLua.instance()
    return _G.SDKManagerLuaInst
end

function SDKManagerLua:initLua()

    mc.SDKMannager:getInstance():initLua()

    if _G.gSDKuc then
        local i = 0
        i = i + 1
    end

end

function SDKManagerLua:getPID()
    return mc.SDKManager:getInstance():getPID()
end

function SDKManagerLua:initCpp()

    return mc.SDKManager:getInstance():initCpp()

end

function SDKManagerLua:check_login_status()

    return mc.SDKManager:getInstance():check_login_status()

end

function SDKManagerLua:login()

    return mc.SDKManager:getInstance():login()

end

function SDKManagerLua:logout()

    return mc.SDKManager:getInstance():logout()

end

function SDKManagerLua:exit()

    return mc.SDKManager:getInstance():exit()

end

function SDKManagerLua:getSid()
    return mc.SDKManager:getInstance():getSid()
end

function SDKManagerLua:getExt1()
    return mc.SDKManager:getInstance():getExt1()
end

function SDKManagerLua:submitExtendData(dataType,dataStr)

    return mc.SDKManager:getInstance():submitExtendData(dataType,dataStr)

end

function SDKManagerLua:pay(money,serverId,gameRole,ext1,ext2)
    mc.SDKManager:getInstance():pay(money,serverId,gameRole,ext1,ext2)
end

function SDKManagerLua.sdkLoginSuccessCallBack(dataStr)

    if _G.gSDK93damai then
        local i = 0
        i = i + 1
    end

end

_G.JniUtil = _G.JniUtil or {}

function JniUtil.callJavaLoginSuccessCall(func)
    local luaj = require "cocos.cocos2d.luaj"
    local className = "org/cocos2dx/lua/AppActivity"
    local args = { "tips that give", func }
    local sigs = "(Ljava/lang/String;I)V"
    local ok = luaj.callStaticMethod(className,"onLuaLoginSuccessCallBack",args,sigs)
    if not ok then
        --print("============= call callback error")
    else
        --print("------------- call callback success")
    end
end

function JniUtil.onLuaLoginSuccessCallBack(msg)
	release_print("print log r ------------------- onLuaLoginSuccessCallBack ---------------------------- print log r")
	release_print(msg)
	
	--local urlstr = zzm.GlobalModel.NetHead.."api/Phone/Login".. zzm.GlobalModel.CID .."&uid="..uid.."&session="..session.."&time="..cTime.."&sign="..cSign
--    urlstr = "http://xyapi.vwoof.com/api/Phone/Login?cid=800&uid=40705601&session=iYDam0OB6FfdE6e0&time=1456371079&sign=bc15b9f5bfd4199ca4713df45238fac2"
--    release_print(urlstr)

	release_print("请求登陆0 DecodeFunc_LoginGame")
	local urlstr = zzm.GlobalModel.NetHead.."api/Phone/Login"..msg
	release_print(urlstr)
    local xhr = cc.XMLHttpRequest:new()
    dxyWaitBack:show()
--    release_print("显示菊花")
    local function onReadyStateChange()
        dxyWaitBack:close()
        if xhr.readyState == 4 and (xhr.status >= 200 and xhr.status < 207) then -- 成功
            -- json
            local response = string.gsub(xhr.response,"\\/","/")
			release_print("请求登陆1 DecodeFunc_LoginGame")
			release_print(response)
            SceneManager.DecodeFunc_LoginGame(SceneManager,json.decode(response))
			release_print("请求登陆2 DecodeFunc_LoginGame")
        else
            TipsFrame:create("请求登陆失败")
            release_print("请求登陆失败")
            release_print("xhr.readyState is:", xhr.readyState, "xhr.status is: ",xhr.status) -- 失败
        end
    end

    xhr.responseType = cc.XMLHTTPREQUEST_RESPONSE_STRING
    xhr:open("GET", urlstr)
    xhr:registerScriptHandler(onReadyStateChange)
    xhr:send()
	
end

local targetPlatform = cc.Application:getInstance():getTargetPlatform()
if (cc.PLATFORM_OS_IPHONE == targetPlatform) or (cc.PLATFORM_OS_IPAD == targetPlatform) or (cc.PLATFORM_OS_ANDROID == targetPlatform) then
	if _G.gSDK93damai or _G.gSDK93damai185 or _G.gSDKAoyou then
		--release_print("print log r ------------------- onLuaLoginSuccessCallBack11 fff ---------------------------- print log r")
		JniUtil.callJavaLoginSuccessCall(JniUtil.onLuaLoginSuccessCallBack)
		--release_print("print log r ------------------- onLuaLoginSuccessCallBack22 fff ---------------------------- print log r")
	end
end
