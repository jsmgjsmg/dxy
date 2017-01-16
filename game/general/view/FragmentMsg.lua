FragmentMsg = FragmentMsg or class("FragmentMsg",function()
    return cc.Node:create()
end)
local PATH = "dxyCocosStudio/png/general/new/"
local PLUS = 10

function FragmentMsg:ctor()
    self.visibleSize = cc.Director:getInstance():getVisibleSize()
    self.origin = cc.Director:getInstance():getVisibleOrigin()
    self._arrStar = {}
    self._arrSkill = {}
end

function FragmentMsg:create(data)
    local node = FragmentMsg:new()
    node:initMsg(data)
    return node
end

function FragmentMsg:initMsg(data)
    self._csb = cc.CSLoader:createNode("res/dxyCocosStudio/csd/ui/general/FragmentMsg.csb")
    self:addChild(self._csb)
    self._csb:setPosition(self.origin.x + self.visibleSize.width / 2, self.origin.y + self.visibleSize.height / 2) 

    dxyExtendEvent(self)
    -- 拦截
    dxySwallowTouches(self)
    
    local swallow = self._csb:getChildByName("swallow")
    swallow:setContentSize(self.visibleSize.width,self.visibleSize.height)

    local ndClose = self._csb:getChildByName("ndFragmentClose")
    local btnClose = ndClose:getChildByName("btnClose")
    btnClose:addTouchEventListener(function(target,type)
        if type == 2 then
            SoundsFunc_playSounds(SoundsType.CLOSE_PAGE,false)
            self:removeFromParent()
        end
    end)

    local bg = self._csb:getChildByName("bg")

    --sprite
    self._txtGold = self._csb:getChildByName("txtGold")
    self._txtFragment = self._csb:getChildByName("txtFragment")
    local name = GodGeneralConfig:getNameByFID(data.Id)
    local txtName = bg:getChildByName("txtName")
    txtName:setString(name)
    local color_data = GoodsConfigProvider:findGoodsById(data.Id).Quality
    txtName:setColor(Quality_Color[color_data])

    local spColor = bg:getChildByName("spColor")
    local colour = GodGeneralConfig:getMsgColour(data.Id,2).IconLittle
    spColor:setTexture("res/GodGeneralsIcon/"..colour)

    local spSM = bg:getChildByName("spSM")
    local icon = GoodsConfigProvider:findGoodsById(data.Id).Icon
    spSM:setTexture("res/GodGeneralsIcon/"..icon..".png")

    local ndBig = bg:getChildByName("ndBig")
    local Ossature = GodGeneralConfig:getGeneralModel(data.Id,2)
    local action = mc.SkeletonDataCash:getInstance():createWithCashName(Ossature)
    action:setAnimation(1,"ready", true)
    action:setAnchorPoint(0.5,0)
    action:setPosition(0,0)
    local scale = GodGeneralConfig:getGeneralData(data.Id,2).Scale/100
    action:setScale(scale)
    ndBig:addChild(action)
    

    --skill
    local config = GodGeneralConfig:getGeneralData(data.Id,2)
    for i=1,2 do
        self._arrSkill[i] = bg:getChildByName("bgSkill"..i):getChildByName("btnSkill")
        self._arrSkill[i]:loadTextureNormal("res/GodGeneralsIcon/"..config["Icon"..i])
        self._arrSkill[i]:loadTexturePressed("res/GodGeneralsIcon/"..config["Icon"..i])
        self._arrSkill[i]:addTouchEventListener(function(target,type)
            if type == 2 then
                SoundsFunc_playSounds(SoundsType.UNIVERSAL_BTN,false)
            end
        end)
    end

--txtInt    
    local bgInt = bg:getChildByName("bgInt")
    local txtInt = bgInt:getChildByName("txtInt")
    txtInt:setString(GodGeneralConfig:getFragmentInt(data["Id"]))

--pro
    local ndDown = self._csb:getChildByName("ndDown")
    self._txtAtk = ndDown:getChildByName("txtAtk")
    self._txtDef = ndDown:getChildByName("txtDef")
    self._txtHp = ndDown:getChildByName("txtHp")
    if data then
        local One = GodGeneralConfig:getFragmentPro(data.Id,1)
        local allData = zzm.GeneralModel.General
        local BaseAttribute = GodGeneralConfig:getBaseAttribute(data.Config.Quality,data.Star or 1)
        self._txtAtk:setString(math.floor((_G.GeneralData.Atk*One.Atk + allData.useAtk + BaseAttribute.addAtk)* BaseAttribute.addFactor))
        self._txtDef:setString(math.floor((_G.GeneralData.Def*One.Def + allData.useDef + BaseAttribute.addDef)* BaseAttribute.addFactor))
        self._txtHp:setString(math.floor((_G.GeneralData.Hp*One.Hp + allData.useHp + BaseAttribute.addHp)* BaseAttribute.addFactor))
    end

--分解
    local _btnDestroy = ndDown:getChildByName("btnDestroy")
    _btnDestroy:addTouchEventListener(function(target,type)
        if type==2 then 
            SoundsFunc_playSounds(SoundsType.OPEN_PAGE,false)
            require "src.game.general.view.DestroyFragment"
            local _csb = DestroyFragment:create(data)
            SceneManager:getCurrentScene():addChild(_csb)
        end 
    end)

--合并
    self._btnMerger = ndDown:getChildByName("btnMerger")

    self:updateRes(data)
end

function FragmentMsg:updateUIData(data)
    if data then
        if data.Star and data.Star <= 5 then
            if data.Star == 5 then
            	self._btnMerger:setTouchEnabled(false)
            	self._btnMerger:setBright(false)
            end
            self._btnMerger:setTitleText("升星")
            local need = GodGeneralConfig:getGoldByGeneralUp(data.Id,data.Star)
            self._txtGold:setString(need)

            local num = zzm.GeneralModel:getFragmentWithGeneral(data["Id"]) or 0
            local max = GodGeneralConfig:getFragmentByGeneralUp(data["Id"],data["Star"])
            self._txtFragment:setString("碎片："..num.."/"..max)
            if num >= max then
                self._txtFragment:setColor(cc.c3b(0,255,0))
            else
                self._txtFragment:setColor(cc.c3b(220,20,60))
            end
            
            local allData = zzm.GeneralModel.General
            local BaseAttribute = GodGeneralConfig:getBaseAttribute(data.Quality,data.Star or 1)
            self._txtAtk:setString(math.floor((data.Atk + allData.useAtk + BaseAttribute.addAtk)* BaseAttribute.addFactor))
            self._txtDef:setString(math.floor((data.Def + allData.useDef + BaseAttribute.addDef)* BaseAttribute.addFactor))
            self._txtHp:setString(math.floor((data.Hp + allData.useHp + BaseAttribute.addHp)* BaseAttribute.addFactor))


            self._btnMerger:addTouchEventListener(function(target,type)
                if type == 2 then
                    SoundsFunc_playSounds(SoundsType.COMPOUND_FRAGMENT,false)
                    zzc.GeneralController:sendUpStarMsg(data.Id)  
                end
            end)
        else
            self._btnMerger:setTitleText("合成")
        end
  end
end

function FragmentMsg:initEvent()
    dxyDispatcher_addEventListener("FragmentMsg_removeSelf",self,self.removeSelf)
    dxyDispatcher_addEventListener("ResForMerger_updatePro",self,self.updateUIData)
    dxyDispatcher_addEventListener("FragmentMsg_updateRes",self,self.updateRes)
end

function FragmentMsg:removeEvent()
    dxyDispatcher_removeEventListener("FragmentMsg_removeSelf",self,self.removeSelf)
    dxyDispatcher_removeEventListener("ResForMerger_updatePro",self,self.updateUIData)
    dxyDispatcher_removeEventListener("FragmentMsg_updateRes",self,self.updateRes)
end

function FragmentMsg:updateRes(data)
    local need = GodGeneralConfig:getGoldByGeneralUp(data.Id,0)
    self._txtGold:setString(need)

    local num = zzm.GeneralModel:getFragmentWithGeneral(data["Id"]) or 0
    local max = GodGeneralConfig:getNumByMerger(data["Id"])
    self._txtFragment:setString("碎片："..data.Num.."/"..max)
    if data.Num >= max then
        self._txtFragment:setColor(cc.c3b(0,255,0))
    else
        self._txtFragment:setColor(cc.c3b(220,20,60))
    end
    self._btnMerger:addTouchEventListener(function(target,type)
        if type == 2 then
            SoundsFunc_playSounds(SoundsType.COMPOUND_FRAGMENT,false)
            zzc.GeneralController:sendMergerMsg(data.Id)
            self:removeFromParent()
        end
    end)
    local myGeneralData = nil
    for key, var in pairs(zzm.GeneralModel.General["Card"]) do
        if var.Id == data.Config.Id then
            myGeneralData = var
        end
    end
    if myGeneralData then
        if myGeneralData.Star then
            self:updateUIData(myGeneralData)
    	end
    end
    
end

--function FragmentMsg:updateFragment(Id)
--    local myGeneralData = nil
--    for key, var in pairs(zzm.GeneralModel.General["Card"]) do
--        if var.Id == Id then
--            myGeneralData = var
--        end
--    end
--    if myGeneralData then
--        if myGeneralData.Star then
--            self:updateUIData(myGeneralData)
--        end
--    end
--    local num = zzm.GeneralModel:getFragmentWithGeneral(myGeneralData["Id"]) or 0
--    local max = GodGeneralConfig:getFragmentByGeneralUp(myGeneralData["Id"],myGeneralData["Star"])
--    self._txtFragment:setString("碎片："..num.."/"..max)
--    if num >= max then
--        self._txtFragment:setColor(cc.c3b(0,255,0))
--    else
--        self._txtFragment:setColor(cc.c3b(220,20,60))
--    end
--end

function FragmentMsg:removeSelf()
    require "game.equip.view.EquipSwallowEffect"
    local scene = SceneManager:getCurrentScene()
    scene:addChild(EquipSwallowEffect:create())
    self:removeFromParent()
end
