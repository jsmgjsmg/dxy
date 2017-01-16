local RoleinfoModel = RoleinfoModel or class("RoleinfoModel")
RoleinfoModel.__index = RoleinfoModel

function RoleinfoModel:ctor()
    self:initModel()
    
    self._arrRoleData = {}
    self._arrRoleData.BASE = {}
    self._arrRoleData.EQUIP = {}
    self._arrRoleData.SKILL = {}
    self._arrRoleData.SPIRIT = {}
    self._arrRoleData.YUANSHEN = {}
    self._arrRoleData.MAGIC = {}
    self._arrRoleData.FAIRY = {}
    self._arrRoleData.GENERAL = {}
end

function RoleinfoModel:initModel()
	
end

function RoleinfoModel:initBASE(data)
    self._arrRoleData.BASE = data
    dxyDispatcher_dispatchEvent("RoleinfoLayer_update")
end

function RoleinfoModel:initEQUIP(data)
    table.insert(self._arrRoleData.EQUIP,data)
end

function RoleinfoModel:initSKILL(data)
    self._arrRoleData.SKILL = data
    dxyDispatcher_dispatchEvent("CtskillLayer_update")
end

function RoleinfoModel:initSPIRIT(data)
    self._arrRoleData.SPIRIT = data
    dxyDispatcher_dispatchEvent("SpiritInfoLayer_update")
end

function RoleinfoModel:initYUANSHEN(data)
    self._arrRoleData.YUANSHEN = data
    dxyDispatcher_dispatchEvent("YuanshenInfoLayer_update")
end

function RoleinfoModel:initMAGIC(data)
    self._arrRoleData.MAGIC = data
    dxyDispatcher_dispatchEvent("MagicInfoLayer_update")
end

function RoleinfoModel:initFAIRY(data)
    self._arrRoleData.FAIRY = data
    dxyDispatcher_dispatchEvent("FairyInfoLayer_update")
end

function RoleinfoModel:initGENERAL(data)
    self._arrRoleData.GENERAL = data
    dxyDispatcher_dispatchEvent("GeneralInfoLayer_update")
end

return RoleinfoModel