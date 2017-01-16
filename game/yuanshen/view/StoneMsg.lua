local StoneMsg = class("StoneMsg",function()
    return cc.Node:create()
end)
local PATH = "dxyCocosStudio/png/yuanshen/stone/"

function StoneMsg:ctor()
    self.visibleSize = cc.Director:getInstance():getVisibleSize()
    self.origin = cc.Director:getInstance():getVisibleOrigin()
end

function StoneMsg:create(data)
    local node = StoneMsg:new()
    node:init(data)
    return node
end

function StoneMsg:init(data)
    self._csb = cc.CSLoader:createNode("dxyCocosStudio/csd/ui/yuanshen/StoneMsg.csb")
    self:addChild(self._csb)
    self._csb:setPosition(self.origin.x + self.visibleSize.width / 2, self.origin.y + self.visibleSize.height / 2)

    local image = self._csb:getChildByName("Image_1")

    dxyExtendEvent(self)
    -- 拦截
    dxySwallowTouches(self,image)
    
    local bg = self._csb:getChildByName("bg")
    local spStone = bg:getChildByName("spStone")
--    spStone:setTexture(PATH..data.config.Icon..".png")
    spStone:setSpriteFrame(cc.SpriteFrameCache:getInstance():getSpriteFrame(PATH..data.config.Icon..".png"))
    self._txtNum = bg:getChildByName("txtNum")
    self._txtNum:setString(data.count)
    local txtName = self._csb:getChildByName("txtName")
    txtName:setString(data.config.Name.." ×3")
    
--next
    local bgNext = self._csb:getChildByName("bgNext")
    local spNext = bgNext:getChildByName("spNext")
    local nextConfig = GoodsConfigProvider:findGoodsById(data.config.Id+1)
--    spNext:setTexture(PATH..nextConfig.Icon..".png")
    spNext:setSpriteFrame(cc.SpriteFrameCache:getInstance():getSpriteFrame(PATH..nextConfig.Icon..".png"))
    self._nextNum = bgNext:getChildByName("nextNum")
    local result = zzm.CharacterModel:findStone(data.goods_id + 1)
    self._nextNum:setString(result)
    local txtNext = self._csb:getChildByName("txtNext")
    txtNext:setString(nextConfig.Name.." ×1")
    
    
    local btnMerge = self._csb:getChildByName("btnMerge")
    btnMerge:addTouchEventListener(function(target,type)
        if type == 2 then
            SoundsFunc_playSounds(SoundsType.UNIVERSAL_BTN,false)
            zzc.YuanShenController:MergerGoods(0,YuanShenConfig:getTypeById(data.config.Id),data.config.Id)
        end
    end)
    
    local btnMax = self._csb:getChildByName("btnMax")
    btnMax:addTouchEventListener(function(target,type)
        if type == 2 then
            SoundsFunc_playSounds(SoundsType.UNIVERSAL_BTN,false)
            zzc.YuanShenController:MergerGoods(1,YuanShenConfig:getTypeById(data.config.Id),data.config.Id)
        end
    end)
end

function StoneMsg:initEvent()
    dxyDispatcher_addEventListener("StoneMsg_updateBefore",self,self.updateBefore)
    dxyDispatcher_addEventListener("StoneMsg_updateAfter",self,self.updateAfter)
end

function StoneMsg:removeEvent()
    dxyDispatcher_removeEventListener("StoneMsg_updateBefore",self,self.updateBefore)
    dxyDispatcher_removeEventListener("StoneMsg_updateAfter",self,self.updateAfter)
end

function StoneMsg:updateBefore(data)
    self._txtNum:setString(data.count)
end

function StoneMsg:updateAfter(data)
    self._nextNum:setString(data.count)
end

return StoneMsg