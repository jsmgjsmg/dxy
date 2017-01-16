
local AnnouncementController = AnnouncementController or class("AnnouncementController")

function AnnouncementController:ctor()
    self.m_view = nil
    self.announcementItem = nil
    self._model = nil
    self._isInStartLayer = false
    self:initController()
end 

function AnnouncementController:initController()
    self._model = zzm.LoginModel

    print("AnnouncementController initController")
end

function AnnouncementController:getLayer()
    if self.m_view == nil then
        require("game.announcement.AnnouncementLayer")
        self.m_view = AnnouncementLayer.create()
    end
    return self.m_view
end

function AnnouncementController:showLayer()
    local scene = SceneManager:getCurrentScene()
    scene:addChild(self:getLayer())
end

function AnnouncementController:closeLayer()
    if self.m_view then
    	self.m_view:removeFromParent()
    	self.m_view = nil
    end
end

function AnnouncementController:enterMainScene()
    if zzm.AnnouncementModel.isFirstLogin then
        self:httpRequest_OpenAnnouncementLayer()
    end
end




-----------------------------------------------------------------
---- 网络相关处理

--Http和Socket相关处理

-- 登录界面的登录按钮处理
function AnnouncementController:httpRequest_OpenAnnouncementLayer()

    local urlstr = zzm.GlobalModel.NetHead .."api/PhoneSDK/UpdateLogs"..zzm.GlobalModel.CID
    local xhr = cc.XMLHttpRequest:new()

    local function onReadyStateChange()
        if xhr.readyState == 4 and (xhr.status >= 200 and xhr.status < 207) then -- 成功
            print(xhr.response)--
            -- json
            self:DecodeFunc_AnnouncementList(json.decode(xhr.response))
        else
            TipsFrame:create("请求公告失败")
            print("请求公告失败")
            print("xhr.readyState is:", xhr.readyState, "xhr.status is: ",xhr.status) -- 失败
        end
    end

    xhr.responseType = cc.XMLHTTPREQUEST_RESPONSE_STRING
    xhr:open("GET", urlstr)
    xhr:registerScriptHandler(onReadyStateChange)
    xhr:send()
    
    -- updateMsg
    local function tick()
        dxyFloatMsg:show("Requset open Announcement Layer faild!")
        self._myTimer:stop()
        self._myTimer = nil
    end
    --local MyTimer = require("game.utils.MyTimer")
    self._myTimer = self._myTimer or require("game.utils.MyTimer").new()
    self._myTimer:start(3, tick)
end

function AnnouncementController:DecodeFunc_AnnouncementList(data)
    if self._myTimer then
        self._myTimer:stop()
        self._myTimer = nil
    end
    
    zzm.AnnouncementModel.isFirstLogin = false

    local list =  data and data or {}
    zzm.AnnouncementModel:setAnnouncementList(list)
    
    if zzm.AnnouncementModel._isInStartLayer then
        self:showLayer()
    end
end

return AnnouncementController

