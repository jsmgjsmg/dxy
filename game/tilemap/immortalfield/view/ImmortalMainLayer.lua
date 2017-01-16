ImmortalMainLayer = ImmortalMainLayer or class("ImmortalMainLayer",function()
    return cc.Scene:create()
end)

function ImmortalMainLayer.create()
    local node = ImmortalMainLayer.new()
    return node
end

function ImmortalMainLayer:ctor()
    self._csbNode = nil
    self.groupRank = {}
--    self.isUnderAtk = false
--    self.isOpenPage = false
--    self.groupItem = {}
    self:initUI()
    dxyExtendEvent(self)
end

function ImmortalMainLayer:initUI()
    self.visibleSize = cc.Director:getInstance():getVisibleSize()
    self.origin = cc.Director:getInstance():getVisibleOrigin()
    local posX = self.origin.x + self.visibleSize.width/2
    local posY = self.origin.y + self.visibleSize.height/2

    self:addChild(zzc.StepTwoController:getTileLayer())
    
    
--clipping
--    local node = cc.Node:create()
--    node:setPosition(posX,posY)
--   
--    local clip = cc.ClippingNode:create()
--    clip:setStencil(node)
--    clip:setInverted(true)
--    clip:setAlphaThreshold(0)
--    self:addChild(clip)    
--    
--    local black = cc.Sprite:create("dxyCocosStudio/png/clipping/22.png")
--    black:setPosition(posX,posY)
--    clip:addChild(black)    
--    
--    self._view = cc.Sprite:create("dxyCocosStudio/png/clipping/11.png")
--    self._view:setScale(0.5)
--    node:addChild(self._view)
    
    
    self._csbNode = cc.CSLoader:createNode("dxyCocosStudio/csd/scene/ImmortalMainScene.csb")
    self:addChild(self._csbNode)
    
    self._role = zzm.CharacterModel:getCharacterData()
    self._enCAT = enCharacterAttrType
    
--    local swallow = self._csbNode:getChildByName("Image_6")
    
    self.returnNode = self._csbNode:getChildByName("ReturnNode")
    self.btn_return = self.returnNode:getChildByName("btnReturn")
    
    self.areaNode = self.returnNode:getChildByName("AreaNode")
    self.areaNode:setVisible(false)
    self.coordinateTxt = self.areaNode:getChildByName("CoordinateText")
    self.icon_resource = self.areaNode:getChildByName("Icon")
    self.num_resource = self.areaNode:getChildByName("Num")
    
    local groupNode = self._csbNode:getChildByName("GroupNode")
    local manorNode = groupNode:getChildByName("ManorNode")
    self.myGroupName = manorNode:getChildByName("groupName")
    if _G.GroupData.State == 1 then
        self.myGroupName:setString(zzm.ImmortalFieldModel.groupData.name)
    else
        self.myGroupName:setString("未加入仙门")
    end    
--    self.myGroupName:setString(zzm.ImmortalFieldModel.groupData.name)

    local btnBg = groupNode:getChildByName("bg")
    btnBg:addTouchEventListener(function(target,type)
        if type == 2 then
            SoundsFunc_playSounds(SoundsType.UNIVERSAL_BTN,false)
            zzc.StepTwoController:getTileLayer():setCurView()
        end
    end)
    
    self.manorTxt = manorNode:getChildByName("manorText")
    self.manorTxt:setVisible(false)
    self.killTxt = manorNode:getChildByName("killText")
    self.physicalTxt = manorNode:getChildByName("physicalText")
    self.powerTxt = manorNode:getChildByName("powerText")
    self.powerTxt:setVisible(false)
    
    local powerNode = groupNode:getChildByName("PowerNode")
    for i =1, 3 do
        self.groupRank[i] = powerNode:getChildByName("group_"..i)
        self.groupRank[i].Name = self.groupRank[i]:getChildByName("TextName")
        self.groupRank[i].PowerValue = self.groupRank[i]:getChildByName("TextValue")
    end
    
    
    self.newsNode = self._csbNode:getChildByName("NewsNode")
    
    self.btnNode = self._csbNode:getChildByName("BtnNode")
    self.btn_search = self.btnNode:getChildByName("btn_search")
    self.btn_occupy = self.btnNode:getChildByName("btn_occupy")
    self.btn_occupy:setVisible(false)
    self.btn_resource = self.btnNode:getChildByName("btn_resource")
    self.btn_resource:setVisible(false)
    self.btn_goods = self.btnNode:getChildByName("btn_goods")
    
--pos
--    swallow:setPosition(posX,posY)
    self.returnNode:setPosition(posX*2,posY*2)
    groupNode:setPosition(0,posY*2)
    self.newsNode:setPosition(0,0)
    self.btnNode:setPosition(posX*2,0)
    
    local data = zzm.ImmortalFieldModel.rankData
    self:updateMyGroupUI()
    self:updateGroupRank(data)
--    self:addNewsPanel()
end

function ImmortalMainLayer:removeEvent()
    dxyDispatcher_removeEventListener(dxyEventType.Character_AttrUpdate,self,self.updateMyGroupUI)
    dxyDispatcher_removeEventListener("ImmortalMainLayer_updateGroupRank",self,self.updateGroupRank)
    dxyDispatcher_removeEventListener("ImmortalMainLayer_stopAllTimer",self,self.stopAllTimer)
--    dxyDispatcher_removeEventListener("ImmortalMainLayer_setisOpenPageState",self,self.setisOpenPageState)
end

function ImmortalMainLayer:initEvent()
    
    dxyDispatcher_addEventListener(dxyEventType.Character_AttrUpdate,self,self.updateMyGroupUI)
    dxyDispatcher_addEventListener("ImmortalMainLayer_updateGroupRank",self,self.updateGroupRank)
    dxyDispatcher_addEventListener("ImmortalMainLayer_stopAllTimer",self,self.stopAllTimer)
--    dxyDispatcher_addEventListener("ImmortalMainLayer_setisOpenPageState",self,self.setisOpenPageState)
    
    if self.btn_return then
        self.btn_return:addTouchEventListener(function(target,type)
            if (type == 2) then
                SoundsFunc_playSounds(SoundsType.OPEN_PAGE,false)
                SwallowAllTouches:show()
                
                zzc.StepTwoController:getTileLayer()._mineModel:outsideStop()
                
                local function callBack(target,type)
                    if type == 2 then
                        SoundsFunc_playSounds(SoundsType.UNIVERSAL_BTN,false)
                        self._exitTimer:stop()
--                        self.isOpenPage = false
                        UIManager:closeUI("OneBtnTips")
                        SwallowAllTouches:close()
                    end
                end
                self._OneBtnTips = OneBtnTips:create()
                local num = 10
                local text = num.."秒后退出仙域"
                self._OneBtnTips:update(text,"取消",callBack)
--                self.isOpenPage = true
                
                self._exitTimer = self._exitTimer or require("game.utils.MyTimer").new()
                local function tick()
                    num = num - 1
                    
--                    if self.isUnderAtk then --是否受到入侵
--                        self.isUnderAtk = false
--                        self.isOpenPage = false
--                        UIManager:closeUI("OneBtnTips")
--                        SwallowAllTouches:close()
--                        return
--                    end
                    
                    if num == 0 then
                        self._exitTimer:stop()
                        
                        UIManager:closeUI("OneBtnTips")
                        SwallowAllTouches:close()
--                        self.isOpenPage = false
                        
--                        if self.isUnderAtk then --最后一秒是否受到入侵
--                            self.isUnderAtk = false
--                            return
--                        end
                        
                        zzc.StepTwoController:register_outScene()
                        zzc.StepTwoController:getTileLayer():whenClose()
                        
                        require("game.loading.PreLoadScene")
                        local preLoadScene = PreLoadScene.create()
                        preLoadScene:initPreLoad("MainScene","dxyCocosStudio/csd/scene/MainScene_new.csb",function()
                            zzc.TilemapController:showLayer()
                        end)
                        SceneManager:enterScene(preLoadScene, "PreLoadScene")
                        return
                    end
                    text = num.."秒后退出仙域"
                    self._OneBtnTips:update(text,"取消",callBack)
                end
                self._exitTimer:start(1, tick)
            end
        end)
    end
    
    if self.btn_search then
        self.btn_search:addTouchEventListener(function(target,type)
            if (type == 2) then
                SoundsFunc_playSounds(SoundsType.OPEN_PAGE,false)
                zzc.StepTwoController:getTileLayer()._mineModel:outsideStop()
                zzc.ImmortalFieldController:request_GetSearchUIData(CMap:getGlobalGID(cc.p(zzm.StepTwoModel:getMyData().posX,zzm.StepTwoModel:getMyData().posY)))
            end
        end)
	end
	
    if(self.btn_occupy)then
        self.btn_occupy:addTouchEventListener(function(target,type)
            if(type==2)then
                SoundsFunc_playSounds(SoundsType.OPEN_PAGE,false)
                require("game.tilemap.immortalfield.view.OccupyLayer")
                local occupyLayer = OccupyLayer:create()
                SceneManager:getCurrentScene():addChild(occupyLayer)
            end
        end)
    end
    
    if(self.btn_resource)then
        self.btn_resource:addTouchEventListener(function(target,type)
            if(type==2)then
                SoundsFunc_playSounds(SoundsType.OPEN_PAGE,false)
                require("game.tilemap.immortalfield.view.ResourceLayer")
                local resourceLayer = ResourceLayer:create()
                SceneManager:getCurrentScene():addChild(resourceLayer)
            end
        end)
    end
    
    if(self.btn_goods)then
        self.btn_goods:addTouchEventListener(function(target,type)
            if(type==2)then
                SoundsFunc_playSounds(SoundsType.OPEN_PAGE,false)
                zzc.ImmortalFieldController:enterGoodsGetLayerIn()
            end
        end)
    end
end

function ImmortalMainLayer:updateMyGroupUI()
    self.manorTxt:setString(zzm.ImmortalFieldModel.groupData.manorId)
    self.powerTxt:setString(zzm.ImmortalFieldModel.groupData.power)
--    if zzm.ImmortalFieldModel.groupData.kill > 0 then
--    	self.killTxt:setString(zzm.ImmortalFieldModel.groupData.kill)
--        self.killTxt:setVisible(true)
--    	self.physicalTxt:setVisible(false)
--    else
        local role = zzm.CharacterModel:getCharacterData()
        local enCAT = enCharacterAttrType
        self.physicalTxt:setString(role:getValueByType(enCAT.PHYSICAL))
        self.physicalTxt:setVisible(true)
        self.killTxt:setVisible(false)
--    end
    
end

function ImmortalMainLayer:updateGroupRank(data)
	for i =1, 3 do
        self.groupRank[i]:setVisible(false)
	end
	if data and data.name and data.power then
        for index = 1, #data do
            self.groupRank[index]:setVisible(true)
            self.groupRank[index].Name:setString(data[index].name)
            self.groupRank[index].PowerValue:setString(data[index].power)
        end
	end
	
end

function ImmortalMainLayer:addNewsPanel()
    require("game.tilemap.immortalfield.view.NewsNode")
	local newsPanel = NewsNode:create()
    self.newsNode:addChild(newsPanel)
end

--设置界面是否打开状态
--function ImmortalMainLayer:setisOpenPageState(bool)
--    self.isOpenPage = bool
--end

--关闭所有定时器
function ImmortalMainLayer:stopAllTimer()
--    if self.isOpenPage then
--        self.isUnderAtk = true
--    end 
    UIManager:closeUI("OneBtnTips")
    SwallowAllTouches:close()
    if self._exitTimer then
        self._exitTimer:stop()
        self._exitTimer = nil
    end
    if self.find_timer then
        self.find_timer:stop()
        self.find_timer = nil
    end
    SwallowAllTouches:close()
    zzc.ImmortalFieldController:closeSearchLayer()
    zzc.ImmortalFieldController:exitGoodsGetLayer()
    zzc.StepTwoController:getTileLayer()._mineModel:stopFinding()
end

function ImmortalMainLayer:WhenClose()
    if zzc.StepTwoController:getTileLayer().whenClose then
        zzc.StepTwoController:getTileLayer():whenClose()
    end
end

--function ImmortalMainLayer:setViewPos(pos)
--    local curPos = {}
--    curPos.x,curPos.y = self._view:getPosition()
--    curPos.x = curPos.x + 10
--    curPos.y = curPos.y + 10
--    self._view:setPosition(curPos)
--end
