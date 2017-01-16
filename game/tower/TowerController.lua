local TowerController = TowerController or class("TowerController")

function TowerController:ctor()
    self.m_view = nil
    self._model = nil
    self.visibleSize = cc.Director:getInstance():getVisibleSize()
    self.origin = cc.Director:getInstance():getVisibleOrigin()
    self:initController()
end

function TowerController:initController()
    self:registerListenner()
    print("TowerController initController")
end

function TowerController:getLayer()
    if self.m_view == nil then
        require("game.tower.view.TowerLayer")
        self.m_view = TowerLayer:create()
    end
    return self.m_view
end

function TowerController:showLayer()
    local scene = SceneManager:getCurrentScene()
    UIManager:addUI(self:getLayer(), "TowerLayer")
    scene:addChild(self:getLayer())
    self:getLayer():setPosition(self.origin.x + self.visibleSize.width / 2,self.origin.y + self.visibleSize.height / 2)
end

function TowerController:closeLayer()
    if self.m_view then
        UIManager:closeUI("TowerLayer")
        self.m_view = nil
    end
end

-----------------------------------------------------------------
--Network 
--
--initNetwork
function TowerController:registerListenner()
    _G.NetManagerLuaInst:registerListenner(4192,self)
end

function TowerController:unregisterListenner()
    _G.NetManagerLuaInst:unregisterListenner(4192,self)
end

--请求试练塔冷却时间
function TowerController:request_towerCD()
    local msg = mc.packetData:createWritePacket(4190); --编写发送包
    msg:writeByte(2)
    mc.NetMannager:getInstance():sendMsg(msg); --发送 包
end

-----------------------------------------------------------------
--Receive
function TowerController:dealMsg(msg)
    local cmdType = msg:getpacketCmdType() 
    if cmdType == 4192 then
    	local type = msg:readUbyte()
    	local data = {}
    	for index=1, 3 do
    		data[index] = msg:readUint()
    	end
    	zzm.TowerModel.towerCDList = data
    	
        dxyDispatcher_dispatchEvent("updateTowerTime",zzm.TowerModel.towerCDList)
    end
    -- 默认返回false ，表示不中断读取下一个msg
    return false
end

return TowerController