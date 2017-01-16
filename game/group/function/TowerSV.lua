TowerSV = TowerSV or class("TowerSV",function()
    return ccui.Layout:create()
end)
local LEVEL = 18
local TOWER_HEIGHT = 114
local PACE_HEIGHT = 32

function TowerSV:ctor()
    self.arrLevel = {}
end

function TowerSV:create()
    local node = TowerSV.new()
    node:init()
    return node
end

function TowerSV:init()
    self._csb = cc.CSLoader:createNode("dxyCocosStudio/csd/ui/groupfunc/TowerSV.csb")
    self:addChild(self._csb)

    self._SV = self._csb:getChildByName("ScrollView")
    self._SV:setScrollBarEnabled(false)
    self._spCur = self._SV:getChildByName("spCur")
    self._spCur:setVisible(false)
    
--    local role = zzm.CharacterModel:getCharacterData()
--    local enCAT = enCharacterAttrType
--    local pro = role:getValueByType(enCAT.PRO)
--    self.OssatureConfig = HeroConfig:getOssatureById(pro)
--    self._action = mc.SkeletonDataCash:getInstance():createWithCashName(self.OssatureConfig.Ossature)
--    self._action:setAnimation(1,"ready", true)
--    self._action:setAnchorPoint(0.5,0.5)
--    self._action:setScale(0.4)
--    self._spCur:addChild(self._action)
    
    local visibleSize = self._SV:getContentSize()
    local innerSize = self._SV:getInnerContainerSize()
    local Min = -(innerSize.height - visibleSize.height + 150)
    self._SV:addEventListener(function(target,type)
        if type == 9 then
            zzm.GroupFuncModel._firstTime = false
            local svposy = target:getInnerContainer():getPositionY()
            if svposy <= Min then
                dxyDispatcher_dispatchEvent("TeamCopy_scrllToPage",self._page)
--                self._spCur:setVisible(false)
            elseif svposy >= 150 then
                dxyDispatcher_dispatchEvent("TeamCopy_scrllToPage",self._page-2)
--                self._spCur:setVisible(false)
            end
        end
    end)
    
    for i=1, LEVEL do
        self.arrLevel[i] = self._SV:getChildByName("level"..i)
        self.arrLevel[i]:setTouchEnabled(false)
        self.arrLevel[i]:setBright(false)
        self.arrLevel[i]:addTouchEventListener(function(target,type)
            if type == 2 then
                dxyFloatMsg:show("第 "..self._config[i].Layer.." 层")
                self._curSpLevel = self._config[i].Layer % LEVEL == 0 and LEVEL or self._config[i].Layer % LEVEL
                self:setCurPosY(self._curSpLevel)
                dxyDispatcher_dispatchEvent("TeamCopy_updateRewards",self._config[i])
            end
        end)
    end
end

function TowerSV:update(page)
    self._page = page
    self._config = GroupConfig:getSkyPagodaByPage(page)
end

--设置初始视角停留位置
--function TowerSV:jumpToPercen(level)
--    self.curLevel = level % LEVEL == 0 and LEVEL or level % LEVEL
--    local InnerConSize = self._SV:getInnerContainerSize()
--    local conSize = self._SV:getContentSize()
--
--    local posy = (self.curLevel - 1) * TOWER_HEIGHT + PACE_HEIGHT
--    if posy > InnerConSize.height - conSize.height then
--        posy = InnerConSize.height - conSize.height
--    end
--    self._SV:getInnerContainer():setPositionY(-posy)
--    
--    self._curSpLevel = self.curLevel
--    self:setCurPosY()
--end
function TowerSV:jumpToPercen(curTouch)
    local InnerConSize = self._SV:getInnerContainerSize()
    local conSize = self._SV:getContentSize()

    local posy = (curTouch - 1) * TOWER_HEIGHT + PACE_HEIGHT
    if posy > InnerConSize.height - conSize.height then
        posy = InnerConSize.height - conSize.height
    end
    self._SV:getInnerContainer():setPositionY(-posy)
    
    self:setCurPosY(curTouch)
end

--设置初始红点位置
function TowerSV:setCurPosY(curTouch)
    self._spCur:setVisible(true)
    
    local role = zzm.CharacterModel:getCharacterData()
    local enCAT = enCharacterAttrType
    local pro = role:getValueByType(enCAT.PRO)
    self.OssatureConfig = HeroConfig:getOssatureById(pro)
    if not self._action then 
        self._action = mc.SkeletonDataCash:getInstance():createWithCashName(self.OssatureConfig.Ossature)
        self._action:setAnimation(1,"ready", true)
        self._action:setAnchorPoint(0.5,0.5)
        self._action:setScale(0.4)
        self._spCur:addChild(self._action)
    end
    
--    self._spCur:setPositionY(self._curSpLevel * TOWER_HEIGHT + PACE_HEIGHT - TOWER_HEIGHT / 2 - 30)
    self._spCur:setPositionY(curTouch * TOWER_HEIGHT + PACE_HEIGHT - TOWER_HEIGHT / 2 - 30)
end

--全部不可点
function TowerSV:changeTouchEvent(bool)
    self._SV:setTouchEnabled(bool)
    for i=1,LEVEL do
        self.arrLevel[i]:setTouchEnabled(bool)
    end
end

--初始已开启页数、层数
function TowerSV:setTouchOrNot(i,page,lv)
    if i < page then
        for i=1,LEVEL do
            self.arrLevel[i]:setTouchEnabled(true)
            self.arrLevel[i]:setBright(true)
        end
    elseif i == page then
        for i=1,lv do
            self.arrLevel[i]:setTouchEnabled(true)
            self.arrLevel[i]:setBright(true)
        end
    end
end

function TowerSV:removeOssature()
    self._spCur:removeAllChildren()
    self._action = nil
end