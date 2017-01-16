local ResForUpStar = class("ResForUpStar",function()
    return cc.Node:create()
end)

function ResForUpStar:ctor()
    self.visibleSize = cc.Director:getInstance():getVisibleSize()
    self.origin = cc.Director:getInstance():getVisibleOrigin()
end

function ResForUpStar:create(data)
    local node = ResForUpStar:new()
    node:init(data)
    return node
end

function ResForUpStar:init(data)
    self._csb = cc.CSLoader:createNode("res/dxyCocosStudio/csd/ui/general/ResForUpStar.csb")
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
    local colour = GodGeneralConfig:getMsgColour(data.Id,1).IconLittle
    bgSP:setTexture("res/GodGeneralsIcon/"..colour)
    self:updateRes(data)
    
    local btnSure = self._csb:getChildByName("btnSure")
    btnSure:addTouchEventListener(function(target,type)
        if type == 2 then
            SoundsFunc_playSounds(SoundsType.UPGRADE_STAR,false)
            zzc.GeneralController:sendUpStarMsg(data["Id"])
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

function ResForUpStar:initEvent()
    dxyDispatcher_addEventListener("ResForUpStar_updatePro",self,self.updateRes)
end

function ResForUpStar:removeEvent()
    dxyDispatcher_removeEventListener("ResForUpStar_updatePro",self,self.updateRes)
end

function ResForUpStar:updateRes(data)
    local need = GodGeneralConfig:getGoldByGeneralUp(data.Id,data.Star)
    self._txtGold:setString(need)
    
    local num = zzm.GeneralModel:getFragmentWithGeneral(data["Id"]) or 0
    local max = GodGeneralConfig:getFragmentByGeneralUp(data["Id"],data["Star"])
    self._txtFragment:setString(num.."/"..max)
end

return ResForUpStar