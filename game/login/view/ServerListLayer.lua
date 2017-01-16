
ServerListLayer = ServerListLayer or class("ServerListLayer",function()
    return cc.Layer:create()
end)

function ServerListLayer.create()
    local layer = ServerListLayer.new()
    return layer
end

function ServerListLayer:ctor()
    self._csbNode = nil
    self._curIndex = 0
    
    require("game.login.view.OneServerItem")
    require("game.login.view.ServersItem")
    
    self:initUI()
    self:initEvent()
end

function ServerListLayer:initUI()
    self._csbNode = cc.CSLoader:getInstance():createNodeWithFlatBuffersFile("dxyCocosStudio/csd/ui/login/ServerListLayer.csb")
    self:addChild(self._csbNode)
    
    self.visibleSize = cc.Director:getInstance():getVisibleSize()
    self.origin = cc.Director:getInstance():getVisibleOrigin()
    
    local backNode = self._csbNode:getChildByName("backNode")
    backNode:setPosition(cc.p(-self.visibleSize.width / 2 + self.origin.x,self.visibleSize.height / 2 + self.origin.y))
    self.btn_back = backNode:getChildByName("backBtn")
    
    local node = self._csbNode:getChildByName("ServerBG")
    self.btn_enter = node:getChildByName("EnterGame")
    self.selectListView = node:getChildByName("SelectListPanel"):getChildByName("ScrollView")
    self.selectListView:setScrollBarEnabled(false)
    self.allListView = node:getChildByName("AllListPanel"):getChildByName("ListView")
    self.txt_lastServer = node:getChildByName("lastServerBG"):getChildByName("Text")
    self.state = node:getChildByName("lastServerBG"):getChildByName("state")
    
--    local tempPanel = node:getChildByName("RecommendPanel")
--    local item = ServersItem.create()
--    tempPanel:addChild(item)
--    local title = zzc.LoginController:getRecommendServer().name
--    item:updateButton(title)
--    if(item.itemButton)then
--        item.itemButton:addTouchEventListener(function(target,type)
--            if(type==2)then
--                self:requestSever(zzc.LoginController:getRecommendServer())
--            end
--        end)
--    end
    
    local tempPanel = node:getChildByName("HaveRolePanel")
    local item = ServersItem.create()
    tempPanel:addChild(item)
    local title = "推荐区"
    item:updateButton(title)
    if(item.itemButton)then
        item.itemButton:addTouchEventListener(function(target,type)
            if(type==2)then
                if self._curIndex ~= -1 then
                    SoundsFunc_playSounds(SoundsType.UNIVERSAL_BTN,false)
                    self._curIndex = -1
                    local dataList = zzc.LoginController:getRecommendServer()
                    --print("2334356456474  ", #dataList)
                    self:updateSelectServer(dataList)
                end
            end
        end)
    end
    
    local count = zzc.LoginController:getServerGroup()
    for index=count,1,-1 do
        local item = ServersItem.create()
        local front = (index - 1) * zzm.LoginModel.serverData._STEP_COUNT + 1
        local back = (index - 1) * zzm.LoginModel.serverData._STEP_COUNT + 1 + (zzm.LoginModel.serverData._STEP_COUNT - 1)
        item:updateServer(front.."-"..back.."服")
        self.allListView:pushBackCustomItem(item) --pushBackCustomItem
    end
    
    local dataList = zzc.LoginController:getSelectServer(self._curIndex)
    self:updateSelectServer(dataList)

end

function ServerListLayer:updateSelectServer(dataList)
    local tempHeight = 0
    local tempwidth = 0
    local flag = 0
    self.selectListView:removeAllChildren()
    if #dataList>0 then
        for index=8,1,-1 do
        
            flag = flag + 1
            if flag > #dataList then
            	break
            end
            
            local item = OneServerItem.create()
            tempwidth = (index)%2*item:getContentSize().width
            tempHeight = (math.floor((index-1)/2))*item:getContentSize().height +10
            --print("111111111111111111", tempwidth, tempHeight)
            item:setPosition(tempwidth,tempHeight)
            item:setParent(self)
            item:update(dataList[flag])
            self.selectListView:setInnerContainerSize(cc.size(self.selectListView:getContentSize().width,tempHeight))
            self.selectListView:addChild(item)
        end
    end

end


function ServerListLayer:initEvent()
    if(self.btn_enter)then
        self.btn_enter:addTouchEventListener(function(target,type)
            if(type==2)then
                SoundsFunc_playSounds(SoundsType.OPEN_PAGE,false)
                local lastServer = zzc.LoginController:getLastServer()
                local t1 = os.time()
                local t2 = tonumber(lastServer.open_time) 
                if t1 < t2 then
                    local yy = os.date("%Y",t2) .. "年"
                    local mm = os.date("%m",t2) .. "月"
                    local dd = os.date("%d",t2) .. "日"
                    local time = os.date("%X",t2)
                    dxyFloatMsg:show("该服开启时间 " .. yy .. mm .. dd .. time)
                    return
                end

                self:requestSever(lastServer)
            end
        end)
    end
    
    if (self.allListView) then
        self.allListView:addEventListener(function(target,type)
            if(type==ccui.ListViewEventType.ONSELECTEDITEM_END)then
                SoundsFunc_playSounds(SoundsType.UNIVERSAL_BTN,false)
                print("select child index = %d",target:getCurSelectedIndex())
                if self._curIndex ~= target:getCurSelectedIndex() then
                	self._curIndex = target:getCurSelectedIndex()
                    local dataList = zzc.LoginController:getSelectServer(self._curIndex)
                    self:updateSelectServer(dataList)
                end
            end
        end)
    end
    
    if(self.btn_back)then
        self.btn_back:addTouchEventListener(function(target,type)
            if(type==2)then
                SoundsFunc_playSounds(SoundsType.CLOSE_PAGE,false)
                zzc.LoginController:enterLayer(LoginLayerType.StartLayer)
            end
        end)
    end
    
    self.txt_lastServer:setString(zzm.LoginModel.serverData.lastServer.name)
    if tonumber(zzm.LoginModel.serverData.lastServer.status) == 0 then
        self.state:setTexture("dxyCocosStudio/png/login/state_Maintain.png")
    elseif tonumber(zzm.LoginModel.serverData.lastServer.status) == 1 then
        self.state:setTexture("dxyCocosStudio/png/login/state_Fluent.png")
    elseif tonumber(zzm.LoginModel.serverData.lastServer.status) == 2 then
        self.state:setTexture("dxyCocosStudio/png/login/state_Hot.png")
    elseif tonumber(zzm.LoginModel.serverData.lastServer.status) == 3 then
        self.state:setTexture("dxyCocosStudio/png/login/state_Crowded.png")
    end
    
end

function ServerListLayer:requestSever(serverdata)
    --local lastServer = zzm.LoginModel:getServerById(2)
    --zzc.LoginController:connectServerFirst(serverdata) --通过700获取逻辑服务器登陆游戏
    zzc.LoginController:connectServerSecond(serverdata)  --不走700直接登陆游戏
    zzm.LoginModel.loginServer = serverdata
end

function ServerListLayer:enterGame()
    zzc.LoginController:createOrSelectRole(serverdata)
end

