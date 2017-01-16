local HelperController = HelperController or class("HelperController")

function HelperController:ctor()
    self.m_view = nil
    self._model = nil
    self.visibleSize = cc.Director:getInstance():getVisibleSize()
    self.origin = cc.Director:getInstance():getVisibleOrigin()
    self:initController()
end

function HelperController:initController()
    self:registerListenner()
    print("HelperController initController")
end

function HelperController:getLayer()
    if self.m_view == nil then
        require("game.helper.view.HelperLayer")
        self.m_view = HelperLayer:create()
    end
    return self.m_view
end

function HelperController:showLayer(type)
    if self.m_view then
    	return
    end

    local scene = SceneManager:getCurrentScene()
    UIManager:addUI(self:getLayer(), "HelperLayer")
    scene:addChild(self:getLayer())
    self:getLayer():setPosition(self.origin.x + self.visibleSize.width / 2,self.origin.y + self.visibleSize.height / 2)
    
    --显示特定选项
    self:getLayer():update(type)
    
end

function HelperController:closeLayer()
    if self.m_view then
        UIManager:closeUI("HelperLayer")
        self.m_view = nil
        
        SceneManager.setFightLose(1)
        
    end
end

-----------------------------------------------------------------
--Network 
--
--initNetwork
function HelperController:registerListenner()
    
end

function HelperController:unregisterListenner()
    
end

-----------------------------------------------------------------
--Receive
function HelperController:dealMsg(msg)
    local cmdType = msg:getpacketCmdType() 
    
    -- 默认返回false ，表示不中断读取下一个msg
    return false
end

return HelperController