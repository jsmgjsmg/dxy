local dxyGlobalModel = dxyGlobalModel or class("dxyGlobalModel")
dxyGlobalModel.__index = dxyGlobalModel

-- _G._isTestingDebug = false -- 是否开启TestingDebug，快速登录测试
-- _G._isGotoMainScene = true  -- 在上TestingDebug为true的情况下有效
-- 定义在 defineTestIn.lua

function dxyGlobalModel:ctor()
--    self.isLocal = true    --true本地开关  false远程开关_G._isLocal改为在main.lua里修改
    
    if _G._isTestingDebug  then
        _G._isLocal = true
    end
    
    -- 平台cid视情况而定
    if _G._isLocal then
        self.m_CID = 1100 -- 研发平台cid 168
    else
        self.m_CID = SDKManagerLua.instance():getPID() -- 渠道cid       
    end
    
    self.link_1 = "http://dxyapi.7soul.com/"    --内网
    self.link_2 = "http://xyapi.vwoof.com/" --外网
    
    if _G._isTestingDebug  then
        self.link_1 = "http://xyapi.vwoof.com/" --外网 
		self.m_CID = SDKManagerLua.instance():getPID() -- 渠道cid 
    end
    
    self.CID = "?cid=" .. self.m_CID -- 168"
    
    self.type = 2   --type:1内网   2外网
    self:getNetHead(self.type)
end 

function dxyGlobalModel:changeNet()
    if self.type == 1 then  --内网切外网
        self.NetHead = self.link_2
        self.type = 2
        return
    elseif self.type == 2 then  --外网切内网
        self.NetHead = self.link_1
        self.type = 1
        return
	end
end

function dxyGlobalModel:getNetHead(type)
	if type == 1 then
        self.NetHead = self.link_1
    elseif type == 2 then
        self.NetHead = self.link_2
	end
end

return dxyGlobalModel