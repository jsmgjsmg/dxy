SkillStone = SkillStone or class("SkillStone",function()
    return cc.Node:create()
end)
local HEIGHT = 90
local WIDTH = 92
local ROW = 6
local LIST = 7

function SkillStone:ctor()
    self.visibleSize = cc.Director:getInstance():getVisibleSize()
    self.origin = cc.Director:getInstance():getVisibleOrigin()
    self._arrItem = {}
    zzm.CharacterModel.isTipsToGoods = false
end

function SkillStone:create()
    local node = SkillStone:new()
    node:init()
    return node
end

function SkillStone:init()
    self._csb = cc.CSLoader:createNode("dxyCocosStudio/csd/ui/yuanshen/SkillStone.csb")
    self:addChild(self._csb)
    self._csb:setPosition(self.origin.x + self.visibleSize.width / 2, self.origin.y + self.visibleSize.height / 2)

    dxyExtendEvent(self)
-- 拦截
    dxySwallowTouches(self)
    
    local btnBack = self._csb:getChildByName("btnBack")
    btnBack:addTouchEventListener(function(target,type)
        if type == 2 then
            SoundsFunc_playSounds(SoundsType.CLOSE_PAGE,false)
            zzm.CharacterModel.isTipsToGoods = true
            self:removeFromParent()
        end
    end)
    
    self._sv = self._csb:getChildByName("ScrollView")
    self._sv:setScrollBarEnabled(false)
    self._stoneList = zzm.CharacterModel:getStoneOfMagic()
    
    local conSize = self._sv:getContentSize()
    local height = HEIGHT * ROW
    self._sv:setInnerContainerSize(cc.size(conSize.width,height))
    local posx,posy = nil
    local count = 0
    for i=1,ROW do
        posy = height - (i-1) * HEIGHT - 40.5
        for j=1,LIST do
            posx = (j-1) * WIDTH + 40.5
            count = count + 1
            local _csb = require ("src.game.yuanshen.view.ItemStone"):create()
            local config = self._stoneList[count]
            _csb:update(config)
            self._sv:addChild(_csb)
            _csb:setPosition(posx,posy)
            table.insert(self._arrItem,_csb)
        end
    end
    
    local btnMerger = self._csb:getChildByName("btnMerger")
    btnMerger:addTouchEventListener(function(target,type)
        if type == 2 then
            SoundsFunc_playSounds(SoundsType.UNIVERSAL_BTN,false)
            zzc.YuanShenController:MergerAll()
        end 
    end)
end

function SkillStone:initEvent()
    dxyDispatcher_addEventListener("SkillStone_addStone",self,self.addStone)
    dxyDispatcher_addEventListener("SkillStone_changeStone",self,self.changeStone)
    dxyDispatcher_addEventListener("SkillStone_delStone",self,self.delStone)
end

function SkillStone:removeEvent()
    dxyDispatcher_removeEventListener("SkillStone_addStone",self,self.addStone)
    dxyDispatcher_removeEventListener("SkillStone_changeStone",self,self.changeStone)
    dxyDispatcher_removeEventListener("SkillStone_delStone",self,self.delStone)
end

function SkillStone:addStone(data)
    for key, var in pairs(self._arrItem) do
    	if var._data == nil then
            var:update(data)
    	    break
    	end
    end
end

function SkillStone:changeStone(data)
    for key, var in pairs(self._arrItem) do
        if var._data and var._data.config.Id == data.config.Id then
    	    var:update(data)
    	    break
    	end
    end
end

function SkillStone:delStone(idx)
    for key, var in pairs(self._arrItem) do
        if var._data and var._data.idx == idx then
    	    var:update()
    	    break
    	end
    end
end