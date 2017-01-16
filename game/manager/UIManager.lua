
_G.UIManager = _G.UIManager or class("UIManager",{})
_G.UIManager.UIList = {}
_G.UIManager._TipsFrameList = {}

function UIManager:ctor(name)
    --UIManager.UIList = {}
end

function UIManager:addUI(ui,name)
    
    UIManager.UIList[name] = ui
    
end

function UIManager:closeUI(name)
    if UIManager.UIList[name] then
        UIManager.UIList[name]:WhenClose()
        UIManager.UIList[name] = nil
    end
end

function UIManager:getUI(name)

    return UIManager.UIList[name]
end

function UIManager:clearAll()
    for key, var in pairs(UIManager.UIList) do
        if var.WhenClose then
            var:WhenClose()
        end
    end
    
    UIManager.UIList = {}
end

function UIManager:showBlackBlock()

    if self._blackBlock == nil then
        self._blackBlock = cc.LayerColor:create({r=0,g=0,b=0,a=130},2000,2000)
        local winsize = cc.Director:getInstance():getWinSize()
        SceneManager:getCurrentScene():addChild(self._blackBlock)
        --self._blackBlock:setPosition(winsize.width/2,winsize.height/2)
        
        -- 拦截
        dxySwallowTouches(self)
    end
    
end

function UIManager:hideBlackBlock()

    if self._blackBlock == nil then return end
    
    self._blackBlock:removeFromParent()
    
    self._blackBlock = nil

end

function UIManager:showBlackBlockTips(tips)

    if self._blackBlock == nil then return end
        
    if self._tips == nil then
        self._tips = cc.Label:createWithTTF("","dxyCocosStudio/font/MicosoftBlack.ttf",20)
        local winsize = cc.Director:getInstance():getWinSize()
        SceneManager:getCurrentScene():addChild(self._tips)
        self._tips:setPosition(winsize.width/2,winsize.height/2)
    end

    self._tips:setString(tips)
    self._tips:setVisible(true)
end

function UIManager:hideBlackBlockTips()

    if self._tips == nil then return end

    --self._tips:setString(tips)
    self._tips:setVisible(false)
end

local tipId = 2
function UIManager:createTipId()
    tipId = tipId + 1
    
    if tipId > 99999 then 
        tipId = 2 
    end
    
    return tipId
end

function UIManager:showTipsFrame(tips)

    local frame = TipsFrame:create(tips)
    local id = self:createTipId()
    frame:setTag(id)
    
    _G.UIManager._TipsFrameList[id] = frame
    
    return id
end

function UIManager:closeTipsFrame(id)

    if _G.UIManager._TipsFrameList[id] ~= nil then
        _G.UIManager._TipsFrameList[id]:removeFromParent()
        _G.UIManager._TipsFrameList[id] = nil
    end
end

function UIManager:WhenChangeScene(newScene)

    if self._tips then
        self._tips:retain()
        self._tips:removeFromParent()
        newScene:addChild(self._tips)
        self._tips:release()
    end

    if self._blackBlock then
        self._blackBlock:retain()
        self._blackBlock:removeFromParent()
        newScene:addChild(self._blackBlock)
        self._blackBlock:release()
    end
    
    for key, var in pairs(self._TipsFrameList) do
        var:retain()
        var:removeFromParent()
        newScene:addChild(var)
        --var:release()
    end
    
end