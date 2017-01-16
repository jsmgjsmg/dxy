local SetupNode = class("SetupNode",function()
    return cc.Node:create()
end)

function SetupNode:ctor()
    self.visibleSize = cc.Director:getInstance():getVisibleSize()
    self.origin = cc.Director:getInstance():getVisibleOrigin()
end

function SetupNode:create()
    local node = SetupNode:new()
    node:init()
    return node
end

function SetupNode:init()
    self._csb = cc.CSLoader:createNode("res/dxyCocosStudio/csd/ui/setup/SetupNode.csb")
    self:addChild(self._csb)
    self._csb:setPosition(self.origin.x + self.visibleSize.width / 2, self.origin.y + self.visibleSize.height / 2)
    
    -- 拦截
    dxySwallowTouches(self)
    
--    local role = zzm.CharacterModel:getCharacterData()
--    local enCAT = enCharacterAttrType
--    role:getValueByType(enCAT.GOLD)
    
    local btnBack = self._csb:getChildByName("btnBack")
    btnBack:addTouchEventListener(function(target,type)
        if type == 2 then
            SoundsFunc_playSounds(SoundsType.CLOSE_PAGE,false)
            self:removeFromParent()
        end 
    end)
    
    local node1 = self._csb:getChildByName("Node_1")
    local node2 = self._csb:getChildByName("Node_2")
    local ePosX,ePosY = node1:getPosition()
    local mPosX,mPosY = node2:getPosition()
    
    self._ctrlEffect = cc.ControlSwitch:create(   --音效
        cc.Sprite:create("dxyCocosStudio/png/ctrlswitch/1.png"),
        cc.Sprite:create("dxyCocosStudio/png/ctrlswitch/6.png"),
        cc.Sprite:create("dxyCocosStudio/png/ctrlswitch/6.png"),
        cc.Sprite:create("dxyCocosStudio/png/ctrlswitch/2.png"),
        cc.Label:createWithTTF("ON","dxyCocosStudio/font/MicosoftBlack.ttf",25),
        cc.Label:createWithTTF("OFF","dxyCocosStudio/font/MicosoftBlack.ttf",25)
    )
    node1:addChild(self._ctrlEffect)
    if _G.isEffect == "on" then
        self._ctrlEffect:setOn(true)
    elseif _G.isEffect == "off" then
        self._ctrlEffect:setOn(false)
    end
    local function valueChanged(target)
        if target:isOn() then
            SoundsInit:setEffect("on")
        else
            SoundsInit:setEffect("off")
        end
    end
    self._ctrlEffect:registerControlEventHandler(valueChanged, cc.CONTROL_EVENTTYPE_VALUE_CHANGED)

    
    self._ctrlMusic = cc.ControlSwitch:create(   --音乐
        cc.Sprite:create("dxyCocosStudio/png/ctrlswitch/1.png"),
        cc.Sprite:create("dxyCocosStudio/png/ctrlswitch/6.png"),
        cc.Sprite:create("dxyCocosStudio/png/ctrlswitch/6.png"),
        cc.Sprite:create("dxyCocosStudio/png/ctrlswitch/2.png"),
        cc.Label:createWithTTF("ON","dxyCocosStudio/font/MicosoftBlack.ttf",25),
        cc.Label:createWithTTF("OFF","dxyCocosStudio/font/MicosoftBlack.ttf",25)
    )
    node2:addChild(self._ctrlMusic)
    if _G.isMusic == "on" then
        self._ctrlMusic:setOn(true)
    elseif _G.isMusic == "off" then
        self._ctrlMusic:setOn(false)
    end
    local function valueChanged2(target)
        if target:isOn() then
            SoundsInit:setMusic("on")
            SoundsFunc_playBackgroundMusic()
        else
            SoundsInit:setMusic("off")
            SoundsFunc_stopBackgroundMusic()
        end
    end
    self._ctrlMusic:registerControlEventHandler(valueChanged2, cc.CONTROL_EVENTTYPE_VALUE_CHANGED)
    
    local txtServer = self._csb:getChildByName("txtServer")
    if zzc.LoginController:getLastServer() then
        txtServer:setString(zzc.LoginController:getLastServer().name)
    end
    
    local btnMsg = self._csb:getChildByName("btnMsg")
    btnMsg:addTouchEventListener(function(target,type)
        if type == 2 then
            SoundsFunc_playSounds(SoundsType.OPEN_PAGE,false)
            zzc.AnnouncementController:showLayer()
        end 
    end)
    
    local btnExit = self._csb:getChildByName("btnExit")
    btnExit:addTouchEventListener(function(target,type)
        if type == 2 then
            SoundsFunc_playSounds(SoundsType.OPEN_PAGE,false)
--            if zzm.GlobalModel.isLocal then
                local double = require("game.setup.DoubleCheck"):create()
                self:addChild(double)           
--            else               
--                mc.UcSdkTool:getInstance():exit()
--            end
        end
    end)
    
    local btnChange = self._csb:getChildByName("btnChange")
    btnChange:addTouchEventListener(function(target,type)
        if type == 2 then
            if zzc.MarqueeController._myTimer then
            	zzc.MarqueeController:closeTimer()
            end
            
            SoundsFunc_playSounds(SoundsType.OPEN_PAGE,false)
            zzm.LoginModel.isOnHeand = true
            mc.NetMannager:getInstance():disconnect()
            
            local lastServer = zzc.LoginController:getLastServer()
            zzc.LoginController:connectServerSecond(lastServer)
            zzm.LoginModel.loginServer = lastServer
            cn:removeAllNetController() --清理网络协议
            initMC.new() --清理Model/Controller
        end
    end)
end

return SetupNode
