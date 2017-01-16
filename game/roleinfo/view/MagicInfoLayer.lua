MagicInfoLayer = MagicInfoLayer or class("MagicInfoLayer",function()
    return cc.Layer:create()
end)

local PATH = "dxyCocosStudio/png/yuanshen/"
local STAR = 9

function MagicInfoLayer:create()
    local layer = MagicInfoLayer:new()
    return layer
end

function MagicInfoLayer:ctor()
    self._csb = nil

    self._arrStar = {}
    self._arrBtn = {}
    self._lastBtn = nil

    self:initUI()
--    self:initEvent()
end

function MagicInfoLayer:initUI()
    self._csb = cc.CSLoader:createNode("dxyCocosStudio/csd/ui/roleinfo/magicInfoLayer.csb")
    self:addChild(self._csb)

    dxyExtendEvent(self)

    self.name = self._csb:getChildByName("name")
    self.Icon = self._csb:getChildByName("Icon")
    self.Lock = self._csb:getChildByName("lock")

    local proNode = self._csb:getChildByName("proNode")
    self.txt_atk = proNode:getChildByName("ATK")
    self.txt_def = proNode:getChildByName("DEF")
    self.txt_hp = proNode:getChildByName("HP")

    --star
    self._ndHide = self._csb:getChildByName("starNode")
    for i=1,STAR do
        local bg = self._ndHide:getChildByName("bg"..i)
        self._arrStar[i] = bg:getChildByName("star")
    end

    --pageView
    local ndPage = self._csb:getChildByName("pageNode")
    self._pageView = ndPage:getChildByName("PageView")
    local cont = 0
    for i=1,2 do
        for j=1,3 do
            cont = cont + 1
            local panel = self._pageView:getChildByName("Panel_"..i)
            self._arrBtn[cont] = panel:getChildByName("smIcon"..j)
            if zzm.YuanShenModel._arrMagic[cont].isLock == 0 then
--                self._arrBtn[cont]:setTouchEnabled(false)
--                self._arrBtn[cont]:setBright(false)
            end
        end
    end

    for i=1,6 do
        self._arrBtn[i]:addTouchEventListener(function(target,type)
            if type == 2 then
                local data = self._MAGIC[i]
                if self._MAGIC[i].isLock == 1 then
                    self.Lock:setVisible(false)
                    self:HideBtnForLight(i)
                elseif self._MAGIC[i].isLock == 0 then
                    self.Lock:setVisible(true)
                    self:HideBtnForLight()
                end
                self:changeMagicPro(data)
            end
        end)
    end

    if _G.RankData.Uid == _G.RoleData.Uid then
        self:MinePro()
    else
        zzc.RoleinfoController:getDataWithPro(_G.RankData.Uid,5)
    end

    local btnLeft = ndPage:getChildByName("leftBtn")
    local btnRight = ndPage:getChildByName("rightBtn")
    btnLeft:addTouchEventListener(function(target,type)
        if type == 2 then
            local index = self._pageView:getCurPageIndex()
            self._pageView:scrollToPage(index-1)
        end
    end)
    btnRight:addTouchEventListener(function(target,type)
        if type == 2 then
            local index = self._pageView:getCurPageIndex()
            self._pageView:scrollToPage(index+1)
        end
    end)

--    self:upDateTips()
--    self:upDateUnLock(zzm.YuanShenModel._arrMagic[1])
--    self:changeMagicPro(zzm.YuanShenModel._arrMagic[1])
end

--function MagicInfoLayer:initEvent()
--
--end

function MagicInfoLayer:changeMagicPro(data)
    local nameIcon = YuanShenConfig:getMagicName(data["Id"])
    self.name:setVisible(true)
    self.name:setSpriteFrame(cc.SpriteFrameCache:getInstance():getSpriteFrame(PATH..nameIcon)) --名字Icon
    self.Icon:setVisible(true)
    if data["isLock"] == 1 then
        local magicIcon = YuanShenConfig:getMagicIconBig(data["Id"])
        self.Icon:setSpriteFrame(cc.SpriteFrameCache:getInstance():getSpriteFrame(PATH..magicIcon)) --大法器Icon
    elseif data["isLock"] == 0 then
        local darkIcon = YuanShenConfig:getMagicIconDark(data["Id"])
        self.Icon:setSpriteFrame(cc.SpriteFrameCache:getInstance():getSpriteFrame(PATH..darkIcon))
        self:upDateUnLock(data)
    end
    self:upGradeStar(data)
end

function MagicInfoLayer:upGradeStar(data) --星星
    for i=1,9 do
        self._arrStar[i]:setVisible(false)
    end
    if data["Star"] then

        self.txt_atk:setString(data["Atk"])
        self.txt_def:setString(data["Def"])
        self.txt_hp:setString(data["Hp"])
        for i=1,data["Star"] do
            self._arrStar[i]:setVisible(true)
        end
    else
        self.txt_atk:setString(0)
        self.txt_def:setString(0)
        self.txt_hp:setString(0)
        for i=1,9 do
            self._arrStar[i]:setVisible(false)
        end
    end
end

--function MagicInfoLayer:upDateBtnState(data)
--    if data["isLock"] == 1 then
--        self._arrBtn[data.Key]:setTouchEnabled(true)
--        self._arrBtn[data.Key]:setBright(true)
--        self._ndHide:setVisible(true)
--        self:upGradeStar(data)
--        self:changeMagicPro(data)
--    end
--end

function MagicInfoLayer:upDateUnLock(data)
    if data["isLock"] == 0 then
        self.Lock:setVisible(true)
    end
end

function MagicInfoLayer:initEvent()
    dxyDispatcher_addEventListener("MagicInfoLayer_update",self,self.update)
end

function MagicInfoLayer:removeEvent()
    dxyDispatcher_removeEventListener("MagicInfoLayer_update",self,self.update)
end

function MagicInfoLayer:update()
    self._MAGIC = zzm.RoleinfoModel._arrRoleData.MAGIC

    local cont = 0
    for i=1,2 do
        for j=1,3 do
            cont = cont + 1
            if self._MAGIC[cont].isLock == 0 then
--                self._arrBtn[cont]:setTouchEnabled(false)
                self._arrBtn[cont]:setBright(false)
            end
            self._MAGIC[cont].Key = cont
--            self:upDateBtnState(self._MAGIC[cont])
        end
    end
    
    self:upDateUnLock(self._MAGIC[1])
    self:changeMagicPro(self._MAGIC[1])
    self._lastBtn = self._arrBtn[1]
    if self._MAGIC[1].isLock == 1 then
        self:HideBtnForLight(1)
    end
end

function MagicInfoLayer:MinePro()
    self._MAGIC = zzm.YuanShenModel:getMagic()

    local cont = 0
    for i=1,2 do
        for j=1,3 do
            cont = cont + 1
            if self._MAGIC[cont].isLock == 0 then
--                self._arrBtn[cont]:setTouchEnabled(false)
                self._arrBtn[cont]:setBright(false)
            end
            self._MAGIC[cont].Key = cont
--            self:upDateBtnState(self._MAGIC[cont])
        end
    end

    self:upDateUnLock(self._MAGIC[1])
    self:changeMagicPro(self._MAGIC[1])
    self._lastBtn = self._arrBtn[1]
    if self._MAGIC[1].isLock == 1 then
        self:HideBtnForLight(1)
    end
end

function MagicInfoLayer:HideBtnForLight(key)
    if self._lastBtn then
        self._lastBtn:setVisible(true)
    end
    if key then
        self._arrBtn[key]:setVisible(false)
        self._lastBtn = self._arrBtn[key]
    end
end