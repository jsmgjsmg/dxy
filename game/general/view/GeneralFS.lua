GeneralFS = GeneralFS or class("GeneralFS",function()
    return cc.Node:create()
end)
local LIST = 6
local WIDTH = 110
local HEIGHT = 110

function GeneralFS:ctor()
    self.visibleSize = cc.Director:getInstance():getVisibleSize()
    self.origin = cc.Director:getInstance():getVisibleOrigin()
end

function GeneralFS:create()
    local node = GeneralFS:new()
    node:init()
    return node
end

function GeneralFS:init()
    self._csb = cc.CSLoader:createNode("res/dxyCocosStudio/csd/ui/general/GeneralFS.csb")
    self:addChild(self._csb)
    self._csb:setPosition(self.origin.x + self.visibleSize.width / 2, self.origin.y + self.visibleSize.height / 2)
    
    dxyExtendEvent(self)
    -- 拦截
    dxySwallowTouches(self)
    
--back    
    local btnBack = self._csb:getChildByName("Image"):getChildByName("btnBack")
    btnBack:addTouchEventListener(function(target,type)
        if type == 2 then
            SoundsFunc_playSounds(SoundsType.CLOSE_PAGE,false)
--            SoundsFunc_playSounds(SoundsType.,false)
            self:removeFromParent()
        end
    end)
    
--pro
    local ndPro = self._csb:getChildByName("ndPro")
    self._allAtk = ndPro:getChildByName("allAtk")    
    self._allDef = ndPro:getChildByName("allDef")    
    self._allHp = ndPro:getChildByName("allHp")    
    self._txtAtk = ndPro:getChildByName("txtAtk")    
    self._txtDef = ndPro:getChildByName("txtDef")    
    self._txtHp = ndPro:getChildByName("txtHp")    
    self._arrowD = ndPro:getChildByName("arrowD")  
    self:ComputePro()
    
--SV
    self._SV = ndPro:getChildByName("ScrollView")
    self._SV:setScrollBarEnabled(false)
    self._SV:addEventListener(function(target,type)
        if type == 1 then
            self._arrowD:setVisible(false)
        else
            self._arrowD:setVisible(true)
        end
    end)
    
    self:updateFS()
end

function GeneralFS:initEvent()
--    dxyDispatcher_addEventListener("GeneralFS_ComputePro",self,self.ComputePro)
--    dxyDispatcher_addEventListener("GeneralFS_updateFS",self,self.updateFS)
end

function GeneralFS:removeEvent()
--    dxyDispatcher_removeEventListener("GeneralFS_ComputePro",self,self.ComputePro)
--    dxyDispatcher_removeEventListener("GeneralFS_updateFS",self,self.updateFS)
end

function GeneralFS:updateFS()
    self._SV:removeAllChildren()
    
    local NUM = GodGeneralConfig:getBoxNum()
    local row = NUM / LIST
    
    local conSize = self._SV:getContentSize()
    local real = row * HEIGHT
    local last = conSize.height > real and conSize.height or real
    self._SV:setInnerContainerSize(cc.size(conSize.width,last))
    local posx = 0
    local posy = 0
    local count = 0
    for i=1,row do --列
        posy = (i-1) * HEIGHT + 50
        for j=1,LIST do --行
            posx = (j-1) * WIDTH + 50
            count = count + 1
            require "src.game.general.view.ItemCard"
            local config = nil
            if zzm.GeneralModel.ALLGENERAL[1] then
                config = zzm.GeneralModel.ALLGENERAL[count]
                print("zzm.GeneralModel.ALLGENERAL*****************************************")
            else
                config = GodGeneralConfig:getGeneralByKey(count)
                print("GodGeneralConfig:getGeneralByKey*****************************************")
            end
            local data = {[1]=self._SV,[2]=posx,[3]=last-posy,[4]=config,[5]=count}
            local item = ItemCard:create(data)
            self._SV:addChild(item,1)
            item:setPosition(posx,last - posy)
        end
    end
    
-------------------------------------------------------------------------------------------    
--    local NUM = GodGeneralConfig:getBoxNum()
--    local row = NUM / LIST
--    
--    local conSize = self._SV:getContentSize()
--    local real = row * HEIGHT
--    local last = conSize.height > real and conSize.height or real
--    self._SV:setInnerContainerSize(cc.size(conSize.width,last))
--    local posx = 0
--    local posy = 0
--    local count = 0
--    for i=1,row do --行
--        posy = (i-1) * HEIGHT + 50
--        for j=1,LIST do --列
--            posx = (j-1) * WIDTH + 50
--            require "src.game.general.view.ItemCard"
--            count = count + 1
--            local config = GodGeneralConfig:getGeneralByKey(count)
--            local data = {[1]=self._SV,[2]=posx,[3]=last-posy,[4]=config}
--            local item = ItemCard:create(data)
--            self._SV:addChild(item,1)
--            item:setPosition(posx,last - posy)
--        end
--    end    
end

function GeneralFS:ComputePro()
    local data = zzm.GeneralModel.General
    self._allAtk:setString(data.allAtk)
    self._allDef:setString(data.allDef)
    self._allHp:setString(data.allHp)
    self._txtAtk:setString(data.useAtk)
    self._txtDef:setString(data.useDef)
    self._txtHp:setString(data.useHp)  
end