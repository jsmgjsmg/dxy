SearchLayer = SearchLayer or class("SearchLayer",function()
   return cc.Layer:create()
end)

function SearchLayer.create()
	local layer = SearchLayer.new()
	return layer
end

function SearchLayer:ctor()
	
	self:initUI()
	
	dxyExtendEvent(self)
    dxySwallowTouches(self)--拦截
end

function SearchLayer:initUI()
	self._csb = cc.CSLoader:getInstance():createNodeWithFlatBuffersFile("dxyCocosStudio/csd/ui/immortalfield/SearchLayer.csb")
    self:addChild(self._csb)
    
    self.visibleSize = cc.Director:getInstance():getVisibleSize()
    self.origin = cc.Director:getInstance():getVisibleOrigin()
    local posX = self.origin.x + self.visibleSize.width/2
    local posY = self.origin.y + self.visibleSize.height/2

    self._csb:setPosition(posX, posY)
    
	self.btn_back = self._csb:getChildByName("btnBack")
	self.btn_get = self._csb:getChildByName("BtnGet")
	self.btn_get:setTitleText("领取")
	
    self.headText = self._csb:getChildByName("HeadText")
   
    
    self.resourceNode = self._csb:getChildByName("resourceNode")
    self.panel_resource = self.resourceNode:getChildByName("Panel")
    
    self.boxNode = self._csb:getChildByName("boxNode")
    self.panel_box = self.boxNode:getChildByName("Panel")
    self.boxIcon = self.panel_box:getChildByName("boxIcon")
    self.boxIcon:setVisible(false)
    
    self.bossNode = self._csb:getChildByName("bossNode")
    self.panel_boss = self.bossNode:getChildByName("Panel")
    self.boss_Node = self.panel_boss:getChildByName("bossNode")
    
    self.discoverText = self._csb:getChildByName("discoverText")
    self.manorText = self._csb:getChildByName("manorText")
    
    
    self._scrollHeight_res = self.panel_resource:getContentSize().height - 100
    self._scrollWidth_res = self.panel_resource:getContentSize().width
    
    self._scrollHeight_box = self.panel_box:getContentSize().height - 100
    self._scrollWidth_box = self.panel_box:getContentSize().width
    
    self._scrollHeight_boss = self.panel_boss:getContentSize().height - 100
    self._scrollWidth_boss = self.panel_boss:getContentSize().width
    
--    local data = zzm.ImmortalFieldModel.sceneData
    self:addDataToPanel()
end

function SearchLayer:removeEvent()
--    dxyDispatcher_removeEventListener("SearchLayer_addDataToPanel",self,self.addDataToPanel)
    dxyDispatcher_removeEventListener("SearchLayer_OKGet",self,self.OKGet)
end

function SearchLayer:initEvent()
--    dxyDispatcher_addEventListener("SearchLayer_addDataToPanel",self,self.addDataToPanel)
    dxyDispatcher_addEventListener("SearchLayer_OKGet",self,self.OKGet)
	if self.btn_back then
		self.btn_back:addTouchEventListener(function(target,type)
		     if (type == 2) then
                self:whenClose()
                zzc.ImmortalFieldController:closeSearchLayer()
--                dxyDispatcher_addEventListener("ImmortalMainLayer_setisOpenPageState",false)
		     end
		end)
	end
	
    if self.btn_get then
        self.btn_get:addTouchEventListener(function(target,type)
            if (type == 2) then
--                self:whenClose()
                local sceneData = zzm.ImmortalFieldModel.sceneData
                if sceneData.bossId and sceneData.bossId ~= 0 then
--                    zzc.StepTwoController:getTileLayer():whenClose()
                    self:whenClose()
                    zzc.ImmortalFieldController:closeSearchLayer()
                    
                    zzc.ImmortalFieldController:request_Search(CMap:getGlobalGID(cc.p(zzm.StepTwoModel:getMyData().posX,zzm.StepTwoModel:getMyData().posY)))
--                    require("game.loading.CombatpreloadScene")
--                    local scene = CombatpreloadScene:create()
--                    scene:initPreLoad(zzm.ImmortalFieldModel.sceneData.sceneId,zzm.ImmortalFieldModel.sceneData.bossId,zzm.ImmortalFieldModel.sceneData.MonsterId,1,0)
--                    SceneManager:enterScene(scene, "CombatpreloadScene")
                else
                    zzc.ImmortalFieldController:request_getSearchGoods(CMap:getGlobalGID(cc.p(zzm.StepTwoModel:getMyData().posX,zzm.StepTwoModel:getMyData().posY)))
                    self:whenClose()
                    zzc.ImmortalFieldController:closeSearchLayer()
                end
--                zzc.ImmortalFieldController:request_Search(CMap:getGlobalGID(cc.p(zzm.StepTwoModel:getMyData().posX,zzm.StepTwoModel:getMyData().posY)))
--                require("game.loading.CombatpreloadScene")
--                local scene = CombatpreloadScene:create()
--                scene:initPreLoad(zzm.ImmortalFieldModel.sceneData.sceneId,zzm.ImmortalFieldModel.sceneData.bossId,zzm.ImmortalFieldModel.sceneData.MonsterId,1,0)
--                SceneManager:enterScene(scene, "CombatpreloadScene")
                
            end
        end)
    end
end


function SearchLayer:addDataToPanel()
    require("game.tilemap.immortalfield.view.ResourceItem")
    local searchData = zzm.ImmortalFieldModel.searchData
    for i=1, #searchData do
        local resourceItem = ResourceItem:create()
        self.panel_resource:addChild(resourceItem)
        resourceItem:update(searchData[i])
        resourceItem:setScale(0.6)
        resourceItem:setPosition(60,self._scrollHeight_res)
        self._scrollHeight_res = self._scrollHeight_res - 55
    end
    
    if zzm.ImmortalFieldModel.isBox then
        self.headText:setString("探索")
        self.discoverText:setString("本次探索发现了：")
        self.manorText:setString("领地战：掠夺敌人领地势力XX点，可得元宝X")
        self.manorText:setVisible(false)
    end
    
    if zzm.ImmortalFieldModel.isBox == 1 then
    	self.boxIcon:setVisible(true)
    else
        self.boxIcon:setVisible(false)
    end
    
    
    self.boss_Node:removeAllChildren()
    
    local sceneData = zzm.ImmortalFieldModel.sceneData
    if sceneData.bossId and sceneData.bossId ~= 0 then
        
        local Ossature = GodGeneralConfig:getMonsterModel(sceneData.bossId)
        self._action = nil
        self._action = mc.SkeletonDataCash:getInstance():createWithCashName(Ossature)
        self._action:setAnimation(1,"ready", true)
        self._action:setAnchorPoint(0.5,0)
        self._action:setPosition(0,0)
--        local scale = GodGeneralConfig:getGeneralData(sceneData.bossId,1).Scale/100*0.8
        self._action:setScale(0.8)
        self.boss_Node:addChild(self._action)

        self.btn_get:setTitleText("战斗")
    end
    
end

function SearchLayer:OKGet()
	self:removeFromParent()
end

function SearchLayer:whenClose()
    if self._action then
        self._action:removeFromParent()
        self._action = nil
    end
end
