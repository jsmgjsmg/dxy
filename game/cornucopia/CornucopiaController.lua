local CornucopiaController = CornucopiaController or class("CornucopiaController")

function CornucopiaController:ctor()
    self.m_view = nil
    self._model = nil
    self.visibleSize = cc.Director:getInstance():getVisibleSize()
    self.origin = cc.Director:getInstance():getVisibleOrigin()
    self:initController()
end

function CornucopiaController:initController()
    self:registerListenner()
    print("CornucopiaController initController")
end

function CornucopiaController:getLayer()
    if self.m_view == nil then
        require("game.cornucopia.view.CornucopiaLayer")
        self.m_view = CornucopiaLayer:create()
    end
    return self.m_view
end

function CornucopiaController:showLayer()
    local scene = SceneManager:getCurrentScene()
    UIManager:addUI(self:getLayer(), "CornucopiaLayer")
    scene:addChild(self:getLayer())
    self:getLayer():setPosition(self.origin.x + self.visibleSize.width / 2,self.origin.y + self.visibleSize.height / 2)
end

function CornucopiaController:closeLayer()
    if self.m_view then
        UIManager:closeUI("CornucopiaLayer")
        self.m_view = nil
    end
end

-----------------------------------------------------------------
--Network 
--
--initNetwork
function CornucopiaController:registerListenner()
    _G.NetManagerLuaInst:registerListenner(4192,self)
end

function CornucopiaController:unregisterListenner()
    _G.NetManagerLuaInst:unregisterListenner(4192,self)
end

--请求财神宝库冷却时间
function CornucopiaController:request_cornucopiaCD()
    local msg = mc.packetData:createWritePacket(4190); --编写发送包
    msg:writeByte(1)
    mc.NetMannager:getInstance():sendMsg(msg); --发送 包
end

-----------------------------------------------------------------
--Receive
function CornucopiaController:dealMsg(msg)
    local cmdType = msg:getpacketCmdType()
    if cmdType == 4192 then
    	local type = msg:readUbyte()
    	if type == 1 then
    		zzm.CornucopiaModel.cdTime = msg:readUint()
            dxyDispatcher_dispatchEvent("updateTime",zzm.CornucopiaModel.cdTime)
    	end
    end 
    -- 默认返回false ，表示不中断读取下一个msg
    return false
end

return CornucopiaController