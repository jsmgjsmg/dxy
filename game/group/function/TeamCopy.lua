TeamCopy = TeamCopy or class("TeamCopy",function()
    return cc.Node:create()
end)
require("game.group.function.TowerSV")
--local MAXLABEL = 20
local ROLE_NUM = 3
local GOODS_NUM = 6
local LEVEL = 18
local PATH = "res/dxyCocosStudio/png/equip/"

function TeamCopy:ctor()
    self.winSize = cc.Director:getInstance():getVisibleSize()
    self.origin = cc.Director:getInstance():getVisibleOrigin()
    self.arrRole = {}
    self.txtName = {}
    self.arrBtnAdd = {}
    self.isNull = {}
    self.arrGoods = {}
    self.arrSpColor = {}
    self.arrSpGoods = {}
    self.arrNum = {}
    self.arrState = {}
    
    self.arrLevel = {}
    
    zzm.GroupFuncModel._firstTime = true
end

function TeamCopy:create()
    local node = TeamCopy:new()
    node:init()
    return node
end

function TeamCopy:init()
    self._csb = cc.CSLoader:createNode("dxyCocosStudio/csd/ui/groupfunc/TeamCopyLayer.csb")
    self:addChild(self._csb)
    self._csb:setPosition(self.origin.x + self.winSize.width / 2, self.origin.y + self.winSize.height / 2)

    zzm.GroupModel.isInTheTeam = false

    dxyExtendEvent(self)
    -- 拦截
    dxySwallowTouches(self)
    
--topTitle
    local pro = self._csb:getChildByName("ProjectNode")
    pro:setPositionY(self.winSize.height / 2)
    local ndBack = pro:getChildByName("ndBack")
    ndBack:setPositionX(-(self.winSize.width / 2))
    local btnBack = ndBack:getChildByName("btnBack")
    btnBack:addTouchEventListener(function(target,type)
        if type == 2 then
            SoundsFunc_playSounds(SoundsType.OPEN_PAGE,false)
            local function callBack(target,type)
                if type == 2 then
                    SoundsFunc_playSounds(SoundsType.UNIVERSAL_BTN,false)
                    UIManager:closeUI("CustomTips")
                    zzc.GroupController:exitTeamTower(zzm.GroupModel.TeamMember.TeamId)
                end
            end
            local layer = CustomTips:create()
            local text = "你正在队伍中，是否确定离开？"
            layer:update(text,callBack)
        end
    end)
    
    local ndData = pro:getChildByName("ndData")
    ndData:setPositionX(self.winSize.width / 2)
    require "src.game.utils.TopDataNode"
    local data = TopDataNode:create()
    ndData:addChild(data)
    
    local image = self._csb:getChildByName("Image")
    image:setContentSize(self.winSize.width,self.winSize.height)
    local image2 = self._csb:getChildByName("Image2")
    image2:setContentSize(self.winSize.width,self.winSize.height)
    local bg1 = self._csb:getChildByName("bg1")
    local bg2 = self._csb:getChildByName("bg2")
    local bgConSize = bg1:getContentSize()
    local width = self.winSize.width/2 - (bgConSize.width - 190)
    bg1:setContentSize(bgConSize.width+width,bgConSize.height)
    bg2:setContentSize(bgConSize.width+width,bgConSize.height)
    
--ndCur
    local ndCur = self._csb:getChildByName("ndCur")
    self._txtCurPos = ndCur:getChildByName("txtCurPos")   
    self._txtCount = ndCur:getChildByName("txtCount")   
        
--ndSV
    local ndSV = self._csb:getChildByName("ndSV")
    self._pvLV = ndSV:getChildByName("PageView")
    self._txtLvName = ndSV:getChildByName("txtLvName")

--ndRole
    local ndRole = self._csb:getChildByName("ndRole")
    for i=1,ROLE_NUM do
        self.isNull[i] = true
        self.arrRole[i] = ndRole:getChildByName("role"..i)
        self.txtName[i] = self.arrRole[i]:getChildByName("txtName")
        self.arrState[i] = ndRole:getChildByName("spState"..i)
        self.arrBtnAdd[i] = ndRole:getChildByName("btnAdd"..i)
        self.arrBtnAdd[i]:addTouchEventListener(function(target,type)
            if type == 2 then
                require("game.group.function.SetPowerFunc")
                local spf = SetPowerFunc:create()
                self:addChild(spf)
            end
        end)
    end
    
--ndRewards
    local ndReward = self._csb:getChildByName("ndReward")
    for i=1,GOODS_NUM do
        self.arrGoods[i] = ndReward:getChildByName("goods"..i)
        self.arrSpColor[i] = self.arrGoods[i]:getChildByName("spColor")
        self.arrSpGoods[i] = self.arrGoods[i]:getChildByName("spGoods")
        self.arrNum[i] = self.arrGoods[i]:getChildByName("txtNum")
    end
    self._cbDouble = ndReward:getChildByName("cbDouble")
    self._cbDouble:addEventListener(function(target,type)
        print("_cbDouble  "..type)
    end)
    
--btn
    local btnTalk = self._csb:getChildByName("btnTalk")
    self._btnStart = self._csb:getChildByName("btnStart")
    self._btnReady = self._csb:getChildByName("btnReady")
    btnTalk:addTouchEventListener(function(target,type)
        if type == 2 then
            zzc.ChatController:showLayer(EnumChannelType.Faction)
        end
    end)
    self._btnStart:addTouchEventListener(function(target,type)
        if type == 2 then
            for key, var in pairs(zzm.GroupModel.TeamMember.Member) do
                if var.Root ~= DefineConst.CONST_CLIMBING_TOWER_TEAM_CAPTAIN and var.State == DefineConst.CONST_CLIMBING_TOWER_NOT_PREPARE then
            	    dxyFloatMsg:show("尚有队员未准备")
            	    return
            	end
            end
            self:startTeamCopy()
        end
    end)
    self._btnReady:addTouchEventListener(function(target,type)
        if type == 2 then
            self:startTeamCopy()
        end
    end)
    
    self:update(zzm.GroupModel.TeamMember)
end

function TeamCopy:initEvent()
    dxyDispatcher_addEventListener("TeamCopy_addMember",self,self.addMember)
    dxyDispatcher_addEventListener("TeamCopy_delMember",self,self.delMember)
    dxyDispatcher_addEventListener("TeamCopy_updateState",self,self.updateState)
    dxyDispatcher_addEventListener("TeamCopy_scrllToPage",self,self.scrllToPage)
    dxyDispatcher_addEventListener("TeamCopy_updateRewards",self,self.updateRewards)
    dxyDispatcher_addEventListener("TeamCopy_lockSV",self,self.lockSV)
    dxyDispatcher_addEventListener(dxyEventType.Character_AttrUpdate,self,self.updateValue)
    dxyDispatcher_addEventListener("TeamCopy_removeAllOssature",self,self.removeAllOssature)
end

function TeamCopy:removeEvent()
    dxyDispatcher_removeEventListener("TeamCopy_addMember",self,self.addMember)
    dxyDispatcher_removeEventListener("TeamCopy_delMember",self,self.delMember)
    dxyDispatcher_removeEventListener("TeamCopy_updateState",self,self.updateState)
    dxyDispatcher_removeEventListener("TeamCopy_scrllToPage",self,self.scrllToPage)
    dxyDispatcher_removeEventListener("TeamCopy_updateRewards",self,self.updateRewards)
    dxyDispatcher_removeEventListener("TeamCopy_lockSV",self,self.lockSV)
    dxyDispatcher_removeEventListener(dxyEventType.Character_AttrUpdate,self,self.updateValue)
    dxyDispatcher_removeEventListener("TeamCopy_removeAllOssature",self,self.removeAllOssature)
end

function TeamCopy:startTeamCopy()
    zzc.GroupController:setPrepare(zzm.GroupModel.TeamMember.TeamId)
end

function TeamCopy:update(data)
    self._isCaptain = self:isCaptain(data)
    if self._isCaptain then --队长
        self._btnReady:setVisible(false)
    else                   --成员
        self._btnStart:setVisible(false)
        self._btnReady:setVisible(true)
        self._cbDouble:setTouchEnabled(false)
        self._pvLV:setTouchEnabled(false)
        for i=1,ROLE_NUM do
            self.arrBtnAdd[i]:setVisible(false)
        end
    end
    for i=1,#data.Member do
        self:addMember(data.Member[i])
    end
    
    self:initPage()
end

function TeamCopy:initPage()
    local len = GroupConfig:getSkyPagodaLen()

    self._role = zzm.CharacterModel:getCharacterData()
    self._enCAT = enCharacterAttrType
    local TCLEVEL = self._role:getValueByType(self._enCAT.TCLEVEL)

    --可点击位置    
    local tempLv = TCLEVEL + 1 > len and len or TCLEVEL + 1 --下一层
    self._openPage = math.ceil(tempLv / LEVEL) --已开启的页数（重天）
    local openLv = tempLv % LEVEL == 0 and LEVEL or tempLv % LEVEL --当前页数（重天）的层数

    --加载SV
    self.lenPage = math.ceil(len / LEVEL)
    for i=1,self.lenPage do
        local layout = TowerSV:create()
        layout:update(i)
        self._pvLV:addPage(layout)
        table.insert(self.arrLevel,layout)
        if i <= self._openPage then
            layout:setTouchOrNot(i,self._openPage,openLv)
        end
    end
    
    self._txtCurPos:setString(TCLEVEL)

    --初始化位置    
--    self:initVisiblePos()
    TCLEVEL = TCLEVEL == 0 and 1 or TCLEVEL
    local TCOUNT = self._role:getValueByType(self._enCAT.TCCOUNT)
    self._curPage = math.ceil(TCLEVEL / LEVEL) - 1
    self:scrllToPage(self._curPage)
    local curTouch = TCLEVEL % LEVEL == 0 and LEVEL or TCLEVEL % LEVEL
    self.arrLevel[self._curPage+1]:jumpToPercen(curTouch)

    --初始锁定
    if not self._isCaptain then
        self:lockSV(false)
    end

    --初始化奖励    
    self:updateRewards(GroupConfig:getSkyPagodaByPage(self._curPage+1)[TCLEVEL % LEVEL == 0 and LEVEL or TCLEVEL%LEVEL])
    self:updateValue()
end

function TeamCopy:scrllToPage(page)
    if self._openPage <= page then
        return 
    end
    if page < 0 then
        return
    end
    self._pvLV:scrollToPage(page)

    self:removeLastOssature(page)
    self._curPage = page
end

--初始化奖励   
function TeamCopy:updateRewards(data)
    data.Rewards = dxyConfig_toList(data.Rewards)
    for i=1,GOODS_NUM do
        if data.Rewards[i] then
            self.arrGoods[i]:setVisible(true)
            local var = data.Rewards[i]
            if var.Type == 6 or var.Type == 10 then
                local goods = GoodsConfigProvider:findGoodsById(var.Id)
                self.arrSpColor[i]:setTexture(PATH.."spiritQuality_"..goods.Quality..".png")
                if var.Type == 6 then
                    self.arrSpGoods[i]:setTexture("Icon/"..goods.Icon..".png")
                else
                    self.arrSpGoods[i]:setTexture("GodGeneralsIcon/"..goods.Icon..".png")
                end
            else
                self.arrSpColor[i]:setTexture(PATH.."spiritQuality_1.png")
                self.arrSpGoods[i]:setTexture(zzd.TaskData.arrGoodsIcon[var.Type])
            end
            self.arrNum[i]:setString(var.Num)
        else
            self.arrGoods[i]:setVisible(false)
        end
    end 
    self._txtLvName:setString(data.Name)
    zzm.GroupModel.curLevelSelect = data
end

function TeamCopy:isCaptain(data)
    for key, var in pairs(data.Member) do
    	if var.Uid == _G.RoleData.Uid then
            if var.Root == DefineConst.CONST_CLIMBING_TOWER_TEAM_CAPTAIN then
    	        return true
    	    else
    	        return false
    	    end
    	end
    end
end

function TeamCopy:addMember(data)
    for i=1,#self.isNull do
        if self.isNull[i] then --没人
            local hero = HeroConfig:getValueById(data.Pro)
            self.txtName[i]:setString(data.Name)
            self.arrRole[i]:setTexture(hero.IconSquare)
            
            self.arrRole[i].m_data = data
            
            self.arrBtnAdd[i]:setVisible(false)
            self.arrRole[i]:setVisible(true)
            self.txtName[i]:setVisible(true)
            if data.State == DefineConst.CONST_CLIMBING_TOWER_IS_PREPARE and data.Root ~= DefineConst.CONST_CLIMBING_TOWER_TEAM_CAPTAIN then --已准备
                self.arrState[i]:setVisible(true)
            else
                self.arrState[i]:setVisible(false)
            end
            self.isNull[i] = false
            break
        end
    end
end

function TeamCopy:delMember(data)
    for key, var in pairs(self.arrRole) do
        if var.m_data.Uid == data.Uid then
            self.arrBtnAdd[key]:setVisible(true)
            self.arrRole[key]:setVisible(false)
            self.txtName[key]:setVisible(false)
            self.arrState[key]:setVisible(false)
            self.isNull[key] = true
            break
    	end
    end
end

function TeamCopy:updateState(data)
    for key, var in pairs(self.arrRole) do
        if var.m_data.Uid == data.Uid then
            if data.State == DefineConst.CONST_CLIMBING_TOWER_IS_PREPARE then --已准备
                self.arrState[key]:setVisible(true)
            else
                self.arrState[key]:setVisible(false)
            end
            if data.Uid == _G.RoleData.Uid then
                self._btnReady:setTouchEnabled(false)
                self._btnReady:setBright(false)
            end
            break
        end
    end
end

--锁住滚动条不可点击
function TeamCopy:lockSV(bool)
    self._cbDouble:setTouchEnabled(bool)
    self._pvLV:setTouchEnabled(bool)
    for i=1,#self.arrLevel do
        self.arrLevel[i]:changeTouchEvent(bool)
    end
end

function TeamCopy:updateValue()
    local role = zzm.CharacterModel:getCharacterData()
    local enCAT = enCharacterAttrType
    self._txtCount:setString(role:getValueByType(enCAT.TCCOUNT))
end

function TeamCopy:removeLastOssature(page)
    if not zzm.GroupFuncModel._firstTime then
        --删除上一个动画
        local temp = 0
        if page < self._curPage then
            temp = page + 1
        else
            temp = self._curPage
        end
        for key, var in pairs(self.arrLevel) do
            if var._page-1 == temp then
                var:removeOssature() 
                break
            end
        end
        
        --初始动画停留位置
        local TCLEVEL = self._role:getValueByType(self._enCAT.TCLEVEL)
        TCLEVEL = TCLEVEL == 0 and 1 or TCLEVEL
        
        local curTouch = 0
        if TCLEVEL >= (page + 1) * LEVEL then
            curTouch = LEVEL
        else
            curTouch = TCLEVEL % LEVEL == 0 and LEVEL or TCLEVEL % LEVEL    
        end
        self.arrLevel[page+1]:jumpToPercen(curTouch)
        
        --更新资源
        self:updateRewards(GroupConfig:getSkyPagodaByPage(page+1)[curTouch])
    end
end

function TeamCopy:removeAllOssature()
    for key, var in pairs(self.arrLevel) do
    	var:removeOssature()
    end
end

---talk--------------------------------------------------------------------------------
--talk
--    local ndTalk = self._csb:getChildByName("ndTalk")
--    self._svTalk = ndTalk:getChildByName("svTalk")
--    self.conSize = self._svTalk:getContentSize()
--    self.textField = ndTalk:getChildByName("TextField")    
--    local btnTalk = ndTalk:getChildByName("btnTalk")
--    btnTalk:addTouchEventListener(function(target,type)
--        if type == 2 then
--            local str = self.textField:getString()
--            if str ~= nil and str ~= "" then
--            
--            end
--        end
--    end)
--    
--function TeamCopy:addTalk(str)
--    local label = self:createLabel(str)
--    local len = #self.arrItemTalk + 1
--    if len > MAXLABEL then
--        len = MAXLABEL
--        self._svTalk:removeChild(self.arrItemTalk[1])
--        for i=1,MAXLABEL-1 do
--            self.arrItemTalk[i] = self.arrItemTalk[i+1]
--        end
--    end
--    table.insert(self.arrItemTalk,len,label)
--    self._svTalk:addChild(label)
--    
--    local last = self.conSize.height > self.allLabelHeight and self.conSize.height or self.allLabelHeight
--    self._svTalk:setInnerContainerSize(cc.size(self.conSize.width,last))
--    local curHeight = 0
--    for i=1,#self.arrItemTalk do
--        self.arrItemTalk[i]:setPosition(0,last-curHeight)
--        curHeight = curHeight + self.arrItemTalk[i]:getContentSize().height
--    end
--    self._svTalk:scrollToBottom()
--end
--
--function TeamCopy:createLabel(str)
--    local label = cc.Label:createWithTTF("","dxyCocosStudio/font/MicosoftBlack.ttf",15)
--    label:setDimensions(490,self:getDimensions().height) --宽高
--    label:setAlignment(0) --对齐方式
--    label:setAnchorPoint(0,1) --锚点
--    label:setString(str)
--    self.allLabelHeight = self.allLabelHeight + label:getContentSize().height
--end
------------------------------------------------------------------------------------------