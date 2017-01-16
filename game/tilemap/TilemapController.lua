local TilemapController = TilemapController or class("TilemapController")

function TilemapController:ctor()
    self.m_view = nil
    self._model = nil
    self.visibleSize = cc.Director:getInstance():getVisibleSize()
    self.origin = cc.Director:getInstance():getVisibleOrigin()
    self:initController()
end

function TilemapController:initController()
    self:registerListenner()
    print("TilemapController initController")
end

function TilemapController:getLayer()
    if self.m_view == nil then
        require("game.tilemap.view.TilemapLayer")
        self.m_view = TilemapLayer:create()
    end
    return self.m_view
end

function TilemapController:showLayer()
    zzm.CharacterModel.isTipsToGoods = false
    
    local scene = SceneManager:getCurrentScene()
    UIManager:addUI(self:getLayer(), "TilemapLayer")
    scene:addChild(self:getLayer())
    self:getLayer():setPosition(self.origin.x + self.visibleSize.width / 2,self.origin.y + self.visibleSize.height / 2)
end

function TilemapController:closeLayer()
    zzm.CharacterModel.isTipsToGoods = true
    if self.m_view then
        UIManager:closeUI("TilemapLayer")
        self.m_view = nil
    end
end

-----------------------------------------------------------------
--Network 
--
--initNetwork
function TilemapController:registerListenner()
    
end

function TilemapController:unregisterListenner()
    
end

-----------------------------------------------------------------
--Receive
function TilemapController:dealMsg(msg)
    local cmdType = msg:getpacketCmdType() 
    
    -- 默认返回false ，表示不中断读取下一个msg
    return false
end

return TilemapController