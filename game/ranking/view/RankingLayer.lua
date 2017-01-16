local RankingLayer = class("RankingLayer",function()
    return cc.Node:create() 
end)
local PATH = "dxyCocosStudio/png/ranking/"

function RankingLayer:ctor()
    self.winSize = cc.Director:getInstance():getVisibleSize()
    self.origin = cc.Director:getInstance():getVisibleOrigin()
    self._arrBtn = {}
    self._arrNode = {}
end

function RankingLayer:create()
    local layer = RankingLayer:new()
    layer:init()
    return layer
end

function RankingLayer:init()
    self._csb = cc.CSLoader:createNode("dxyCocosStudio/csd/ui/ranking/RankingLayer.csb")
    self:addChild(self._csb)
    self._csb:setPosition(self.origin.x + self.winSize.width / 2, self.origin.y + self.winSize.height / 2)
    
    local swallow = self._csb:getChildByName("pk_bg")
    swallow:setContentSize(self.winSize.width,self.winSize.height)
    
    dxyExtendEvent(self)
    -- 拦截
    dxySwallowTouches(self)

--title    
    require "src.game.utils.TopTitleNode"
    local node = TopTitleNode:create(self,PATH.."txt1.png")
    self:addChild(node)
    
--LV
--    self._arrNode[1] = (require(zzd.RankingData._nodePath[1])):create()
--    self:addChild(self._arrNode[1])
    
--btn 
    local ndBtn = self._csb:getChildByName("ndBtn")
    for i=1,4 do 
        self._arrBtn[i] = ndBtn:getChildByName("Btn"..i)
        self._arrBtn[i]:addTouchEventListener(function(target,type)
            if type == 2 then
                SoundsFunc_playSounds(SoundsType.OPEN_PAGE,false)
                self:changeBtn(i)
            end
        end)
    end

--txt    
    self._bgRank = self._csb:getChildByName("bg1"):getChildByName("bg2")
    self._txtRank = self._bgRank:getChildByName("txtRank")
    self._spR = self._bgRank:getChildByName("spR")    
    self._spXM = self._bgRank:getChildByName("spXM")   
    self._txtTitle = self._bgRank:getChildByName("txtTitle")   
    local txtInt = self._bgRank:getChildByName("txtInt")
    
    self:changeBtn(1)
end

function RankingLayer:initEvent()
    dxyDispatcher_addEventListener("RankingLayer_setRank",self,self.setRank)
end

function RankingLayer:removeEvent()
    dxyDispatcher_removeEventListener("RankingLayer_setRank",self,self.setRank)
end

function RankingLayer:changeBtn(num)
    for i=1, 4 do
        if i == num then
            self._arrBtn[i]:setTouchEnabled(false)
            self._arrBtn[i]:setBright(false)
            if self._arrNode[i] then
                self._arrNode[i]:setVisible(true)
                self._arrNode[i]:updateRank()
            else
                if i ~= 1 then
                    LoadWaitSec:show(90,-20)
                end
                self._arrNode[i] = require(zzd.RankingData._nodePath[i]):create()
                self:addChild(self._arrNode[i])
                self._arrNode[i]:setVisible(true)
            end
            if i ~= 3 then
                self._spR:setVisible(true)
                self._spXM:setVisible(false)
                self._txtTitle:setString("我的排名")
            else
                self._spR:setVisible(false)
                self._spXM:setVisible(true)
                self._txtTitle:setString("我的仙门排名")
            end
        else
            self._arrBtn[i]:setTouchEnabled(true)
            self._arrBtn[i]:setBright(true)
            
            if self._arrNode[i] then
                self._arrNode[i]:setVisible(false)
            end
        end
    end
end

function RankingLayer:setRank(rank)
    self._bgRank:setVisible(true)
    if rank then
        self._txtRank:setString(rank)
    else
        self._txtRank:setString("未上榜")
    end
end

function RankingLayer:whenClose()
    zzm.RankingModel:clean()
end

return RankingLayer