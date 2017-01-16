TilemapLayer = TilemapLayer or class("TilemapLayer",function()
	return cc.Layer:create()
end)

function TilemapLayer:create()
    local layer = TilemapLayer:new()
    return layer
end

function TilemapLayer:ctor()
	self._csb = nil
	
	self:initUI()
	dxyExtendEvent(self)
	
end

function TilemapLayer:initUI()
	self._csb = cc.CSLoader:createNode("dxyCocosStudio/csd/ui/immortalfield/TilemapLayer.csb")
	self:addChild(self._csb)
	
    self.visibleSize = cc.Director:getInstance():getVisibleSize()
    self.origin = cc.Director:getInstance():getVisibleOrigin()
    
    local bg = self._csb:getChildByName("Image_1")
    bg:setContentSize(self.visibleSize.width,self.visibleSize.height)
	
	local backNode = self._csb:getChildByName("backNode")
	self.btn_back = backNode:getChildByName("backBtn")
	backNode:setPosition(-self.visibleSize.width/2,self.visibleSize.height/2)
	
	local dataNode = self._csb:getChildByName("dataNode")
    dataNode:setPosition(cc.p(self.visibleSize.width / 2 + self.origin.x ,self.visibleSize.height / 2 + self.origin.y - 35))
    require "src.game.utils.TopDataNode"
    local data = TopDataNode:create()
    dataNode:addChild(data)
	
	local leftNode = self._csb:getChildByName("leftNode")
    leftNode:setPosition(cc.p(-self.visibleSize.width / 2 +self.origin.x,self.visibleSize.height / 2 +self.origin.y))
	self.txt_group = leftNode:getChildByName("groupTxt")
	self.txt_manor = leftNode:getChildByName("manorTxt")
    self.txt_manor:setVisible(false)
	self.txt_kill = leftNode:getChildByName("killTxt")
	self.txt_kill:setVisible(true)
	self.txt_force = leftNode:getChildByName("forceTxt")
	self.txt_force:setVisible(false)
	
	local rightNode = self._csb:getChildByName("rightNode")
	rightNode:setPosition(cc.p(self.visibleSize.width / 2 + self.origin.x , -self.visibleSize.height / 2 + self.origin.y))
	self.btn_goods = rightNode:getChildByName("goodsBtn")
	
	self.btn_enter = self._csb:getChildByName("enterBtn")
end

function TilemapLayer:initEvent()

    self:updateValue()

    dxyDispatcher_addEventListener("tilemapUpdateValue",self,self.updateValue)
	
	dxyDispatcher_addEventListener(dxyEventType.Character_AttrUpdate,self,self.updateValue)

    -- 拦截
    dxySwallowTouches(self)

    if self.btn_back then
        self.btn_back:addTouchEventListener(function(target,type)
            if type == 2 then
                SoundsFunc_playSounds(SoundsType.CLOSE_PAGE,false)
                zzc.TilemapController:closeLayer()
            end
        end)
    end

    if self.btn_goods then
        self.btn_goods:addTouchEventListener(function(target,type)
            if type == 2 then
                SoundsFunc_playSounds(SoundsType.OPEN_PAGE,false)
                zzc.ImmortalFieldController:enterGoodsGetLayerOut()
            end
        end)
	end
	
    if self.btn_enter then
        self.btn_enter:addTouchEventListener(function(target,type)
            if type == 2 then
                SoundsFunc_playSounds(SoundsType.OPEN_PAGE,false)
                zzc.StepTwoController:register_inScene()
                zzc.TilemapController:closeLayer()
                require("game.loading.TilemappreloadScene")
                local scene = TilemappreloadScene:create()
                scene:initPreLoad("dxyCocosStudio/csd/ui/immortalfield/ImmortalMainLyer.csb")
                SceneManager:enterScene(scene, "TilemappreloadScene")
            end
        end)
    end
end

function TilemapLayer:removeEvent()
    dxyDispatcher_removeEventListener("tilemapUpdateValue",self,self.updateValue)
	dxyDispatcher_removeEventListener(dxyEventType.Character_AttrUpdate,self,self.updateValue)
end

function TilemapLayer:updateValue()
    if not zzm.ImmortalFieldModel.groupData.name then
    	return
    end
    self.txt_group:setString(zzm.ImmortalFieldModel.groupData.name)
    self.txt_manor:setString("领地:"..zzm.ImmortalFieldModel.groupData.manorId)
--    self.txt_kill:setString("击杀:"..zzm.ImmortalFieldModel.groupData.kill)
    local role = zzm.CharacterModel:getCharacterData()
    local enCAT = enCharacterAttrType
	self.txt_kill:setString("体力:"..role:getValueByType(enCAT.PHYSICAL))
    self.txt_force:setString("势力值:"..zzm.ImmortalFieldModel.groupData.power)
end

function TilemapLayer:WhenClose()
	self:removeFromParent()
end