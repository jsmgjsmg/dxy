local ResForMerger = class("ResForMerger",function()
    return cc.Node:create()
end)

function ResForMerger:ctor()
    self.visibleSize = cc.Director:getInstance():getVisibleSize()
    self.origin = cc.Director:getInstance():getVisibleOrigin()
end

function ResForMerger:create(data)
    local node = ResForMerger:new()
    node:init(data)
    return node
end

function ResForMerger:init(data)
    self._csb = cc.CSLoader:createNode("res/dxyCocosStudio/csd/ui/general/ResForMerger.csb")
    self:addChild(self._csb)
    self._csb:setPosition(self.origin.x + self.visibleSize.width / 2, self.origin.y + self.visibleSize.height / 2) 

    dxyExtendEvent(self)
    -- 拦截
    dxySwallowTouches(self)

    self._txtGold = self._csb:getChildByName("txtGold")
    self._txtFragment = self._csb:getChildByName("txtFragment")
    local spFragment = self._csb:getChildByName("spFragment")
    spFragment:setTexture("res/GodGeneralsIcon/"..GoodsConfigProvider:findGoodsById(data.Id).Icon..".png")
    local bgSP = self._csb:getChildByName("bgSP")
    local colour = GodGeneralConfig:getMsgColour(data.Id,2).IconLittle
    bgSP:setTexture("res/GodGeneralsIcon/"..colour)
    self:updateRes(data)

    local btnSure = self._csb:getChildByName("btnSure")
    btnSure:addTouchEventListener(function(target,type)
        if type == 2 then
            SoundsFunc_playSounds(SoundsType.COMPOUND_FRAGMENT,false)
            zzc.GeneralController:sendMergerMsg(data.Id)
            self:removeFromParent()
        end
    end)

    local btnCancel = self._csb:getChildByName("btnCancel")
    btnCancel:addTouchEventListener(function(target,type)
        if type == 2 then
            SoundsFunc_playSounds(SoundsType.CLOSE_PAGE,false)
            self:removeFromParent()
        end
    end)
end

function ResForMerger:initEvent()
    dxyDispatcher_addEventListener("ResForMerger_updatePro",self,self.updateRes)
end

function ResForMerger:removeEvent()
    dxyDispatcher_removeEventListener("ResForMerger_updatePro",self,self.updateRes)
end

function ResForMerger:updateRes(data)
    local need = GodGeneralConfig:getGoldByGeneralUp(data.Id,0)
    self._txtGold:setString(need)

    local num = zzm.GeneralModel:getFragmentWithGeneral(data["Id"]) or 0
    local max = GodGeneralConfig:getNumByMerger(data["Id"])
    self._txtFragment:setString(data.Num.."/"..max)
end

return ResForMerger