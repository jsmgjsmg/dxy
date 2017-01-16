GeneralInfoLayer = GeneralInfoLayer or class("GeneralInfoLayer",function()
    return cc.Layer:create()
end)

function GeneralInfoLayer:create()
    local layer = GeneralInfoLayer:new()
    return layer
end

function GeneralInfoLayer:ctor()
    self._csb = nil

    self._arrStar = {}

    self:initUI()
--    self:initEvent()
end

function GeneralInfoLayer:initUI()
    self._csb = cc.CSLoader:createNode("dxyCocosStudio/csd/ui/roleinfo/generalInfoLayer.csb")
    self:addChild(self._csb)

    dxyExtendEvent(self)

    self.name = self._csb:getChildByName("name")
    self.icon = self._csb:getChildByName("iconNode")

    self.txt_atk = self._csb:getChildByName("ATK")
    self.txt_def = self._csb:getChildByName("DEF")
    self.txt_hp = self._csb:getChildByName("HP")
    
    local node = self._csb:getChildByName("starNode")
    for index=1, 5 do
    	self._arrStar[index] = node:getChildByName("star_"..index):getChildByName("star")
    end
    
    if _G.RankData.Uid == _G.RoleData.Uid then
        self:MinePro()
    else
        zzc.RoleinfoController:getDataWithPro(_G.RankData.Uid,7)
    end
end

--function GeneralInfoLayer:initEvent()
--    if _G.GeneralData.Current ~= 0 then
--        local data = self:getData()
--        if data.Star ~= 0 then
--        	for index=1, data.Star do
--        		self._arrStar[index]:setVisible(true)
--        	end
--        end
--        self.name:setString(GodGeneralConfig:getNameByGID(data.Id))
--        self.txt_atk:setString(data["Atk"])
--        self.txt_def:setString(data["Def"])
--        self.txt_hp:setString(data["Hp"])
--        
--        --local node = self._csb:getChildByName("iconNode")
--        local Ossature = GodGeneralConfig:getGeneralModel(data.Id,1)
--        local action = sp.SkeletonAnimation:create(Ossature..".json", Ossature..".atlas")
--        action:setAnimation(1,"ready", true)
--        --action:setScale(1.2)
--        action:setPosition(0,0)
--        self.icon:addChild(action)
--    else       
--        self.name:setVisible(false)
--        self.txt_atk:setString(0)
--        self.txt_def:setString(0)
--        self.txt_hp:setString(0)
--    end
--end

function GeneralInfoLayer:initEvent()
    dxyDispatcher_addEventListener("GeneralInfoLayer_update",self,self.update)
end

function GeneralInfoLayer:removeEvent()
    dxyDispatcher_removeEventListener("GeneralInfoLayer_update",self,self.update)
end

function GeneralInfoLayer:update()
    local GENERAL = zzm.RoleinfoModel._arrRoleData.GENERAL
    
    if GENERAL.isCur ~= 0 then
        self.name:setString(GodGeneralConfig:getNameByGID(GENERAL.Id))
        self.txt_atk:setString(GENERAL.AllAtk)
        self.txt_def:setString(GENERAL.AllDef)
        self.txt_hp:setString(GENERAL.AllHp)
        self.name:setVisible(true)
        
        local Ossature = GodGeneralConfig:getGeneralModel(GENERAL.Id,1)
        self._action = mc.SkeletonDataCash:getInstance():createWithCashName(Ossature)
        self._action:setAnimation(1,"ready", true)
        self._action:setPosition(0,0)
        local scale = GodGeneralConfig:getGeneralData(GENERAL.Id,1).Scale/100
        self._action:setScale(scale)
        self.icon:addChild(self._action)
        
        if GENERAL.Star ~= 0 then
            for index=1, GENERAL.Star do
                self._arrStar[index]:setVisible(true)
            end
        end
    else
        self.name:setVisible(false)
        self.txt_atk:setString(0)
        self.txt_def:setString(0)
        self.txt_hp:setString(0)
    end
end

function GeneralInfoLayer:MinePro()
    local curData = nil
    for key, var in pairs(zzm.GeneralModel.General.Card) do
        if var.Id == _G.GeneralData.Current then
            curData = var
        end
    end
    
    if curData then
        self.name:setString(GodGeneralConfig:getNameByGID(curData.Id))
--        self.txt_atk:setString(curData.AllAtk)
--        self.txt_def:setString(curData.AllDef)
--        self.txt_hp:setString(curData.AllHp)
        
        self.txt_atk:setString(zzm.GeneralModel.General["allAtk"])
        self.txt_def:setString(zzm.GeneralModel.General["allDef"])
        self.txt_hp:setString(zzm.GeneralModel.General["allHp"])
--        zzm.GeneralModel.General["useAtk"] = msg:readUint()
--        zzm.GeneralModel.General["useDef"] = msg:readUint()
--        zzm.GeneralModel.General["useHp"] = msg:readUint()
        
        self.name:setVisible(true)

        local Ossature = GodGeneralConfig:getGeneralModel(curData.Id,1)
        self._action = mc.SkeletonDataCash:getInstance():createWithCashName(Ossature)
        self._action:setAnimation(1,"ready", true)
        self._action:setPosition(0,0)
        local scale = GodGeneralConfig:getGeneralData(curData.Id,1).Scale/100
        self._action:setScale(scale)
        self.icon:addChild(self._action)

        if curData.Star ~= 0 then
            for index=1, curData.Star do
                self._arrStar[index]:setVisible(true)
            end
        end
    else
        
    end
    
end