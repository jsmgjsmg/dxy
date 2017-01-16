GeneralMsg = GeneralMsg or class("GeneralMsg",function()
    return cc.Node:create()
end)
local PATH = "dxyCocosStudio/png/general/new/"
local PLUS = 10

function GeneralMsg:ctor()
    self.visibleSize = cc.Director:getInstance():getVisibleSize()
    self.origin = cc.Director:getInstance():getVisibleOrigin()
    self._arrStar = {}
    self._arrSkill = {}
end

function GeneralMsg:create(config)
	local node = GeneralMsg:new()
    node:initMsg(config)
	return node
end

function GeneralMsg:initMsg(config)
    self._csb = cc.CSLoader:createNode("res/dxyCocosStudio/csd/ui/general/GeneralMsg.csb")
    self:addChild(self._csb)
    self._csb:setPosition(self.origin.x + self.visibleSize.width / 2, self.origin.y + self.visibleSize.height / 2) 

    dxyExtendEvent(self)
    -- 拦截
    dxySwallowTouches(self)

    local swallow = self._csb:getChildByName("swallow")
    swallow:setContentSize(self.visibleSize.width,self.visibleSize.height)
    
    local ndClose = self._csb:getChildByName("ndGeneralClose")
    local btnClose = ndClose:getChildByName("btnClose")
    btnClose:addTouchEventListener(function(target,type)
        if type == 2 then
            SoundsFunc_playSounds(SoundsType.CLOSE_PAGE,false)
            self:removeFromParent()
        end
    end)

    local bg = self._csb:getChildByName("bg")

    local data = config
    for key, var in pairs(zzm.GeneralModel.General.Card) do
    	if var.Id == config.Id then
    	   data = var
    	end
    end
    
--sprite
    self._txtGold = self._csb:getChildByName("txtGold")
    self._txtFragment = self._csb:getChildByName("txtFragment")
    local name = GodGeneralConfig:getNameByGID(data.Id)
    local txtName = bg:getChildByName("txtName")
    txtName:setString(name)
    local color_data = GoodsConfigProvider:findGoodsById(data.Id).Quality
    txtName:setColor(Quality_Color[color_data])
    
    local spColor = bg:getChildByName("spColor")
    local colour = GodGeneralConfig:getMsgColour(data.Id,1).IconLittle
    spColor:setTexture("res/GodGeneralsIcon/"..colour)
    
    local spSM = bg:getChildByName("spSM")
    local icon = GoodsConfigProvider:findGoodsById(data.Id).Icon
    spSM:setTexture("res/GodGeneralsIcon/"..icon..".png")

    local ndBig = bg:getChildByName("ndBig")
    local Ossature = GodGeneralConfig:getGeneralModel(data.Id,1)
    local action = mc.SkeletonDataCash:getInstance():createWithCashName(Ossature)
    action:setAnimation(1,"ready", true)
    action:setAnchorPoint(0.5,0)
    action:setPosition(0,0)
    local scale = GodGeneralConfig:getGeneralData(data.Id,1).Scale/100
    action:setScale(scale)
    ndBig:addChild(action)
    
--skill
    local config = GodGeneralConfig:getGeneralData(data.Id,1)
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
    txtInt:setString(GodGeneralConfig:getGeneralInt(data["Id"]))

--pro
    local ndDown = self._csb:getChildByName("ndDown")
    self._txtAtk = ndDown:getChildByName("txtAtk")
    self._txtDef = ndDown:getChildByName("txtDef")
    self._txtHp = ndDown:getChildByName("txtHp")
    
--星星
    local ndStar = self._csb:getChildByName("ndStar")
    for i=1,5 do
        self._arrStar[i] = ndStar:getChildByName("Star"..i):getChildByName("star")
    end
 
--升星
    self._btnUpStar = ndDown:getChildByName("btnUpStar")
    if data.Star and data.Star < 5 then
        self._btnUpStar:addTouchEventListener(function(target,type)
            if type==2 then 
                SoundsFunc_playSounds(SoundsType.UPGRADE_STAR,false)
                zzc.GeneralController:sendUpStarMsg(data["Id"])
            end 
        end)
    else
        self._btnUpStar:setTouchEnabled(false)
        self._btnUpStar:setBright(false)
    end

--出战    
    local _btnFight = ndDown:getChildByName("btnFight")
    if data.Star then
        _btnFight:addTouchEventListener(function(target,type)
            if type == 2 then
                SoundsFunc_playSounds(SoundsType.USE_GOODS,false)
                if data.Id == _G.GeneralData.Current then
                    dxyFloatMsg:show("神将正在出战中")
                else
                    zzc.GeneralController:FightGeneral(data["Id"])
                    self:removeFromParent()
                end
            end
        end)
    else
        _btnFight:setTouchEnabled(false)
        _btnFight:setBright(false)
    end
    
    self:updatePro(data)
    self:updateRes(data)
end

function GeneralMsg:initEvent()
    dxyDispatcher_addEventListener("GeneralMsg_updatePro",self,self.updatePro)
    dxyDispatcher_addEventListener("ResForUpStar_updatePro",self,self.updateRes)
end

function GeneralMsg:removeEvent()
    dxyDispatcher_removeEventListener("GeneralMsg_updatePro",self,self.updatePro)
    dxyDispatcher_removeEventListener("ResForUpStar_updatePro",self,self.updateRes)
end

function GeneralMsg:updatePro(data)

    local BaseAttribute = GodGeneralConfig:getBaseAttribute(data.Quality,data.Star or 1)
    local allData = zzm.GeneralModel.General

    if data.Star then
        for i=1,data.Star do
            self._arrStar[i]:setVisible(true)
        end
        if data.Star >= 5 then
            self._btnUpStar:setTouchEnabled(false)
            self._btnUpStar:setBright(false)
        end

        self._txtAtk:setString(math.floor((data.Atk + allData.useAtk + BaseAttribute.addAtk)* BaseAttribute.addFactor))
        self._txtDef:setString(math.floor((data.Def + allData.useDef + BaseAttribute.addDef)* BaseAttribute.addFactor))
        self._txtHp:setString(math.floor((data.Hp + allData.useHp + BaseAttribute.addHp)* BaseAttribute.addFactor))
    else
        local One = GodGeneralConfig:getGeneralPro(data.Id,1)
        self._txtAtk:setString(math.floor((_G.GeneralData.Atk*One.Atk + allData.useAtk + BaseAttribute.addAtk)* BaseAttribute.addFactor))
        self._txtDef:setString(math.floor((_G.GeneralData.Def*One.Def + allData.useDef + BaseAttribute.addDef)* BaseAttribute.addFactor))
        self._txtHp:setString(math.floor((_G.GeneralData.Hp*One.Hp + allData.useHp + BaseAttribute.addHp)* BaseAttribute.addFactor))
    end
end

function GeneralMsg:updateRes(data)
    if data.Id and data.Star then
        local need = GodGeneralConfig:getGoldByGeneralUp(data.Id,data.Star)
        self._txtGold:setString(need)
    else
        self._txtGold:setVisible(false)
    end

    local num = zzm.GeneralModel:getFragmentWithGeneral(data["Id"]) or 0
    if data["Star"] then
        local max = GodGeneralConfig:getFragmentByGeneralUp(data["Id"],data["Star"])
        self._txtFragment:setString("碎片："..num.."/"..max)
        if num >= max then
            self._txtFragment:setColor(cc.c3b(0,255,0))
        else
            self._txtFragment:setColor(cc.c3b(220,20,60))
        end
    else
        self._txtFragment:setVisible(false)
    end
    
end
