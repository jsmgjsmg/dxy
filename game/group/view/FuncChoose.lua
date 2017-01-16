FuncChoose = FuncChoose or class("FuncChoose",function()
    return cc.Node:create()
end)

function FuncChoose:ctor()
    self.visibleSize = cc.Director:getInstance():getVisibleSize()
    self.origin = cc.Director:getInstance():getVisibleOrigin()
    self._arrBtn = {}
    self._arrTab = {}
    self.last = nil
    self.pathTab = {[1]="GroupHome",
                    [2]="GroupMember",
                    [3]="GroupThing",
                    [4]="GroupAskFor"
    }
end

function FuncChoose:create()
    local node = FuncChoose:new()
    node:init()
    return node
end

function FuncChoose:init()
    self._csb = cc.CSLoader:createNode("dxyCocosStudio/csd/ui/group/FuncChoose.csb")
    self:addChild(self._csb)
    self._csb:setPosition(self.origin.x + self.visibleSize.width / 2, self.origin.y + self.visibleSize.height / 2)

    local btnNode = self._csb:getChildByName("nd_btn")
    for i=1,4 do
        self._arrBtn[i] = btnNode:getChildByName("Btn_"..i)
        local req = require("game.group.view."..self.pathTab[i])
        self._arrTab[i] = req:create()
        self:addChild(self._arrTab[i])
        if i >= 2 then
            self._arrTab[i]:setVisible(false)
        end
    end
    self._arrBtn[1]:setTouchEnabled(false)
    self._arrBtn[1]:setBright(false)

--change    
    for j=1,4 do
        self._arrBtn[j]:addTouchEventListener(function(target,type)
            SoundsFunc_playSounds(SoundsType.OPEN_PAGE,false)
            self:changeFunc(j)
        end)
    end
    
end

function FuncChoose:changeFunc(num)
    for i=1,#self._arrTab do
        if i == num then
            self._arrTab[i]:setVisible(true)
            self._arrBtn[i]:setTouchEnabled(false)
            self._arrBtn[i]:setBright(false)
        else
            self._arrTab[i]:setVisible(false)
            self._arrBtn[i]:setTouchEnabled(true)
            self._arrBtn[i]:setBright(true)
        end
    end
end
