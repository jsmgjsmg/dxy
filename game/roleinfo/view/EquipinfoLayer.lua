EquipinfoLayer = EquipinfoLayer or class("EquipinfoLayer",function()
	return cc.Layer:create()
end)

function EquipinfoLayer:create()
	local layer = EquipinfoLayer:new()
	return layer
end

function EquipinfoLayer:ctor()
    self._nameList = {"weapon","pants","helmet","necklace","clothes","shoes"}
    self._arrItem = {}
    self._equipList = {}
    
	self:initUI()
end

function EquipinfoLayer:initUI()
	self._equipinfoLayer = cc.CSLoader:createNode("dxyCocosStudio/csd/ui/roleinfo/equipinfoLayer.csb")
    self:addChild(self._equipinfoLayer)
	
    dxyExtendEvent(self)
	
    for j=1,6 do
        local node = self._equipinfoLayer:getChildByName(self._nameList[j])
        require "src.game.roleinfo.view.EquipinfoItem"
        self._arrItem[j] = EquipinfoItem:create()
        self._arrItem[j]:setBG(self._nameList[j])
        node:addChild(self._arrItem[j])
    end
    
    if _G.RankData.Uid == _G.RoleData.Uid then
        self:MinePro()
    else
        zzc.RoleinfoController:getDataWithPro(_G.RankData.Uid,0)
        zzc.RoleinfoController:getDataWithPro(_G.RankData.Uid,1)
    end
end

function EquipinfoLayer:initEvent()
    dxyDispatcher_addEventListener("EquipinfoLayer_update",self,self.update)
end

function EquipinfoLayer:removeEvent()
    dxyDispatcher_removeEventListener("EquipinfoLayer_update",self,self.update)
end

function EquipinfoLayer:update()
    local EQUIP = zzm.RoleinfoModel._arrRoleData.EQUIP

    for i=1,#EQUIP do
        local TypeSub = EQUIP[i].config.TypeSub
        self._arrItem[TypeSub]:update(EQUIP[i])
    end
    
--    require("game.roleinfo.view.EquipinfoItem")
--    for index=1, #self._nameList do  
--        local name = self._nameList[index]
--        local node = self._equipinfoLayer:getChildByName(name)
--        if node then
--            self._equipList[name] = EquipinfoItem:create()
--            node:addChild(self._equipList[name])
--            self._equipList[name]:setBG(self._nameList[index])
--            self._equipList[name]:update(EQUIP[index])
--        end
--    end
end

function EquipinfoLayer:MinePro()
    local EQUIP = zzm.CharacterModel:getEquipedList()
    
    require("game.roleinfo.view.EquipinfoItem")
    for index=1, #self._nameList do  
        local name = self._nameList[index]
        local node = self._equipinfoLayer:getChildByName(name)
        if node then
            self._equipList[name] = EquipinfoItem:create()
            node:addChild(self._equipList[name])
            self._equipList[name]:setBG(self._nameList[index])
            self._equipList[name]:update(EQUIP[index])
        end
    end
end