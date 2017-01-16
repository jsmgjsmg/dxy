
OneServerItem = OneServerItem or class("OneServerItem",function()
    return ccui.Layout:create()
end)

function OneServerItem.create()
    local node = OneServerItem.new()
    return node
end

function OneServerItem:ctor()
    self._csbNode = nil
    self:initUI()
    self:initEvent()
end

function OneServerItem:initUI()
    self._csbNode = cc.CSLoader:createNode("dxyCocosStudio/csd/ui/login/OneServerItem.csb")
    self:addChild(self._csbNode)
    
    self.btn_item = self._csbNode:getChildByName("Button")
    
    self:setContentSize(cc.size(self.btn_item:getContentSize().width+10,self.btn_item:getContentSize().height+10))
    self:setAnchorPoint(cc.p(0,0))
    self:setTouchEnabled(true)
    --self.btn_item:setTouchEnabled(true)
      
    self.titleText = self._csbNode:getChildByName("Name")
    self.recommend = self._csbNode:getChildByName("recommend")
    self.serverState = self._csbNode:getChildByName("serverState")
end

function OneServerItem:initEvent()
    if(self.btn_item)then
        self.btn_item:addTouchEventListener(function(target,type)
            if(type==2)then
                SoundsFunc_playSounds(SoundsType.UNIVERSAL_BTN,false)
                local t1 = os.time()
                local t2 = tonumber(self.m_data.open_time) 
                if t1 < t2 then
                    local yy = os.date("%Y",t2) .. "年"
                    local mm = os.date("%m",t2) .. "月"
                    local dd = os.date("%d",t2) .. "日"
                    local time = os.date("%X",t2)
                    dxyFloatMsg:show("该服开启时间 " .. yy .. mm .. dd .. time)
                    return
                end
                self.m_parent:requestSever(self.m_data)
                zzm.LoginModel.serverData.lastServer = self.m_data
            end
        end)
    end
end

function OneServerItem:setParent(parent)
    self.m_parent = parent
end

function OneServerItem:update(data)
    self.m_data = data
    self.titleText:setString(self.m_data.name)

    if tonumber(self.m_data.status) == 0 then
        self.serverState:setTexture("dxyCocosStudio/png/login/state_Maintain.png")
    elseif tonumber(self.m_data.status) == 1 then
        self.serverState:setTexture("dxyCocosStudio/png/login/state_Fluent.png")
    elseif tonumber(self.m_data.status) == 2 then
        self.serverState:setTexture("dxyCocosStudio/png/login/state_Hot.png")
    elseif tonumber(self.m_data.status) == 3 then
        self.serverState:setTexture("dxyCocosStudio/png/login/state_Crowded.png")
    end
    
    self.recommend:setVisible(false)
    for key, var in pairs(zzm.LoginModel.serverData.recommendServer) do
    	if self.m_data.csid == var.csid then
    		self.recommend:setVisible(true)
    		break
    	end
    end
    
--    local contents = cc.Label:createWithSystemFont("","Trebuchet Ms",20)
--    contents:setDimensions(OneServerItem.parentSize,contents:getDimensions().height)
--    contents:setAlignment(0)
--    contents:setAnchorPoint(0,0)
--    contents:setString(self.m_data.contents)
--    self.itemPanel:addChild(contents)
--
--    local contentsHeight = contents:getContentSize().height
--    self.itemPanel:setContentSize(OneServerItem.parentSize, contentsHeight)
--    self.titleBG:setPositionY(contentsHeight)
end






