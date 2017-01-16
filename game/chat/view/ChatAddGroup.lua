ChatAddGroup = ChatAddGroup or class("ChatAddGroup",function()
    return cc.Node:create()
end)

function ChatAddGroup:ctor(msg)
    self.visibleSize = cc.Director:getInstance():getVisibleSize()
    self.origin = cc.Director:getInstance():getVisibleOrigin()
end

function ChatAddGroup:create()
    
    local node = ChatAddGroup:new()
    node:init()
    return node
end

function ChatAddGroup:init()
    self._csb = cc.CSLoader:getInstance():createNodeWithFlatBuffersFile("dxyCocosStudio/csd/ui/chat/JoinFairyTips.csb")
    self:addChild(self._csb)
    self._csb:setPosition(self.origin.x + self.visibleSize.width / 2, self.origin.y + self.visibleSize.height / 2)
    
    SceneManager:getCurrentScene():addChild(self) 
    
    local bg = self._csb:getChildByName("bg")
    local node = self._csb:getChildByName("node")
    local power = node:getChildByName("powerTxt")
    local content = node:getChildByName("declarationTxt")
    
    print(self.m_data.special)
    print(self.m_data.power)
    print(self.m_data.specialname)
    
    --power:setString("不论你战力多少，我们都欢迎你的加入！！！")
    if tonumber(self.m_data.power) >= 0 then
        power:setString(self.m_data.power)
    end
    
    content:setString("门主很懒，居然没有留下几个字！")
    if self.m_data.specialname ~= nil then
        content:setString(self.m_data.specialname)
    end
    
    -- 拦截
    dxySwallowTouches(self, bg)
    
    local _btnSure = self._csb:getChildByName("joinBtn")
    _btnSure:addTouchEventListener(function(target,type)
        if type == 2 then
            SoundsFunc_playSounds(SoundsType.UNIVERSAL_BTN,false)
            zzc.GroupController:JoinGroup(self.m_data.special)
            self:removeFromParent()
        end       
    end)
end