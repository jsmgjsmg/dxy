GroupList = GroupList or class("GroupList",function()
    return cc.Node:create()
end)
local HEIGHT = 105

function GroupList:ctor()
    self.visibleSize = cc.Director:getInstance():getVisibleSize()
    self.origin = cc.Director:getInstance():getVisibleOrigin()
    self.Page = 1
    self._arrGroup = {}
    self._tag = false
    self._findData = nil
end

function GroupList:create()
    local node = GroupList:new()
    node:init()
    return node
end

function GroupList:init()
    self._csb = cc.CSLoader:createNode("res/dxyCocosStudio/csd/ui/group/VisitorList.csb")
    self:addChild(self._csb)
    self._csb:setPosition(self.origin.x + self.visibleSize.width / 2, self.origin.y + self.visibleSize.height / 2)
    
    zzc.GroupController:initGroupList(self.Page)
    dxyExtendEvent(self)

--    self._vipPri = VipConfig:getVipByPrivilege(19) --19:创建仙门权限
--SV
    self._sv = self._csb:getChildByName("ScrollView")
    self._sv:setScrollBarEnabled(false)
    self._btnMore = self._sv:getChildByName("btn_more")
    self._btnMore:addTouchEventListener(function(target,type)
        if type == 2 then
            SoundsFunc_playSounds(SoundsType.UNIVERSAL_BTN,false)
            self.Page = self.Page + 1
            zzc.GroupController:initGroupList(self.Page)
            print("****************************"..self.Page.."*******************************************")
        end
    end)
    self._btnMore:setVisible(false)
    
--find
    self._find = self._csb:getChildByName("find")
    self._group = self._find:getChildByName("group")
    self._head = self._find:getChildByName("bghead"):getChildByName("head")
    self._name = self._find:getChildByName("name")
    self._lv = self._find:getChildByName("lv")
    self._num = self._find:getChildByName("num")
    self._max = self._find:getChildByName("max")
    self._btnView = self._find:getChildByName("btn_view")
    self._btnView:addTouchEventListener(function(target,type)
        if type == 2 then
            SoundsFunc_playSounds(SoundsType.OPEN_PAGE,false)
            require "src.game.group.view.GroupMsg"
            local msg = GroupMsg:create(self._findData)
            local scene = SceneManager:getCurrentScene()
            scene:addChild(msg)
        end
    end)
    
--editbox
    local image = self._csb:getChildByName("Image")
    local test = image:getChildByName("test")
    local size = test:getContentSize()
    local posx,posy = test:getPosition()
    self._input = ccui.EditBox:create(size,"dxyCocosStudio/png/group/TM.jpg")
    image:addChild(self._input)
    self._input:setMaxLength(13)
    self._input:setPlaceHolder("输入仙门名称")
    self._input:setFont("res/dxyCocosStudio/font/MicosoftBlack.ttf",30)
    self._input:setPosition(posx, posy)  
    
    local btnFind = image:getChildByName("btn_find")
    btnFind:addTouchEventListener(function(target,type)
        if type == 2 then
            SoundsFunc_playSounds(SoundsType.UNIVERSAL_BTN,false)
            local group = self._input:getText()
            if group == "" or group == nil then
                if self._tag then
                    dxyDispatcher_dispatchEvent("FinishFind")
                else
                    dxyFloatMsg:show("请输入仙门名称")
                end
            else
                zzc.GroupController:FindGroup(group)
            end
        end
    end)
  
--btn
    self._btnCreate = self._csb:getChildByName("btn_create")
    self._btnCreate:addTouchEventListener(function(target,type)
        if type == 2 then
--            if _G.RoleData.VipLv >= self._vipPri then
--                SoundsFunc_playSounds(SoundsType.OPEN_PAGE,false)
                require "src.game.group.view.CreateGroup"
                local create = CreateGroup:create()
                self:addChild(create)
--            else
--                require "src.game.group.view.HintCreate"
--                local hint = HintCreate:create(self._vipPri)
--                self:addChild(hint)
--            end
        end
    end)
    
    self._btnJoin = self._csb:getChildByName("btn_join")
    self._btnJoin:addTouchEventListener(function(target,type)
        if type == 2 then
            SoundsFunc_playSounds(SoundsType.UNIVERSAL_BTN,false)
            zzc.GroupController:AutoJoin()
        end
    end)
    
end

function GroupList:initEvent()
    dxyDispatcher_addEventListener("addGroup",self,self.addGroup)
    dxyDispatcher_addEventListener("delGroup",self,self.delGroup)
    dxyDispatcher_addEventListener("FindGroup",self,self.FindGroup)
    dxyDispatcher_addEventListener("FinishFind",self,self.FinishFind)
end

function GroupList:removeEvent()
    dxyDispatcher_removeEventListener("addGroup",self,self.addGroup)
    dxyDispatcher_removeEventListener("delGroup",self,self.delGroup)
    dxyDispatcher_removeEventListener("FindGroup",self,self.FindGroup)
    dxyDispatcher_removeEventListener("FinishFind",self,self.FinishFind)
end

function GroupList:addGroup(data)
    local len = #self._arrGroup + 1
    require "src.game.group.view.ItemGroup"
    self._arrGroup[len] = ItemGroup:create(data)
    self._sv:addChild(self._arrGroup[len])
    self:setPos()
end

function GroupList:delGroup(data)
    for key, var in pairs(self._arrGroup) do
    	if var._data["Id"] == data["Id"] then
            table.remove(self._arrGroup,key)
            self._sv:removeChild(var)
            self:setPos()
            break
    	end
    end
end

function GroupList:setPos()
    local len = #self._arrGroup
    local content = self._sv:getContentSize()
    local real = len * HEIGHT
    local last = content.height > real and content.height or real
    if len >= 5 then
        self._btnMore:setVisible(true)
        last = last + 50
        self._btnMore:setPosition(0,0)
    end
    self._sv:setInnerContainerSize(cc.size(content.width,last))
    for i=1,len do
        self._arrGroup[i]:setPosition(0,last-(i-1)*HEIGHT)
    end
end

function GroupList:FindGroup(data)
    self._tag = true
    self._findData = data
    self._find:setVisible(true)
    self._sv:setVisible(false)
    self._head:setTexture("HeroIcon/IconSquare_10"..data.Pro..".png")
    self._group:setString(data["Name"])
    self._name:setString(data["Master"])
    self._lv:setString(data["Lv"])
    self._num:setString(data["Num"])
    if data["Num"] >= 99 then
        self._num:setColor(cc.c3b(246,228,178))
    end
    self._max:setString("/99")
end

function GroupList:FinishFind()
    self._tag = false
    self._sv:jumpToTop()
    self._sv:setVisible(true)
    self._find:setVisible(false)
end
