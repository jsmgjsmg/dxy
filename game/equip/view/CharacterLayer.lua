
CharacterLayer = CharacterLayer or class("CharacterLayer",function()
    return cc.Layer:create()
end)

function CharacterLayer.create()
    local layer = CharacterLayer.new()
    return layer
end

function CharacterLayer:ctor()
    self._csbNode = nil
    self:initUI()
    dxyExtendEvent(self)
end

function CharacterLayer:initUI()
    self._csbNode = cc.CSLoader:getInstance():createNodeWithFlatBuffersFile("dxyCocosStudio/csd/ui/equip/CharacterLayer.csb")
    self:addChild(self._csbNode)
    
    self.visibleSize = cc.Director:getInstance():getVisibleSize()
    self.origin = cc.Director:getInstance():getVisibleOrigin()

    local posX = self.origin.x + self.visibleSize.width/2
    local posY = self.origin.y + self.visibleSize.height/2

    self:setPosition(posX, posY)

    self.containerPanel = self._csbNode:getChildByName("ContainerPanel")
    
    local topBg = self._csbNode:getChildByName("top")
    topBg:setPositionY(self.origin.y + self.visibleSize.height/2)

    require("game.equip.view.CharacterPage")

    local backNode = self._csbNode:getChildByName("leftNode")
    backNode:setPosition(cc.p(-self.visibleSize.width / 2 + self.origin.x,self.visibleSize.height / 2 + self.origin.y))
    self.btn_back = backNode:getChildByName("CloseButton")
    self.title_bg = backNode:getChildByName("bg")
    
    local dataNode = self._csbNode:getChildByName("dataNode")
    dataNode:setPosition(cc.p(self.visibleSize.width / 2 + self.origin.x ,self.visibleSize.height / 2 + self.origin.y - 35))
    require "src.game.utils.TopDataNode"
    local data = TopDataNode:create()
    dataNode:addChild(data)
    
    local page = CharacterPage:create()
    self.containerPanel:addChild(page)
    page:setParent(self)

end

function CharacterLayer:playEffect()
    require("game.equip.view.EquipSwallowEffect")
    local scene = SceneManager:getCurrentScene()
    scene:addChild(EquipSwallowEffect:create()) 
end

function CharacterLayer:removeEvent()
    dxyDispatcher_removeEventListener(dxyEventType.EquipStrengthen_Effect,self,self.playEffect)
end

function CharacterLayer:initEvent()

    dxyDispatcher_addEventListener(dxyEventType.EquipStrengthen_Effect,self,self.playEffect)

    if(self.btn_back)then
        self.btn_back:addTouchEventListener(function(target,type)
            if(type==2)then
                SoundsFunc_playSounds(SoundsType.CLOSE_PAGE,false)
--                if self.containerPanel then
--                    self.containerPanel:removeAllChildren()
--                end
                zzc.CharacterController:closeLayer()
            end
        end)
    end
    
    -- 拦截
    dxySwallowTouches(self)
end

function CharacterLayer:WhenClose()
    self:removeFromParent()
end
