TalentNode = TalentNode or class("TalentNode",function()
    return cc.Node:create()
end)
require("game.group.function.ItemTalent")
local ICON_NUM = 12

function TalentNode:ctor()
    self.visibleSize = cc.Director:getInstance():getVisibleSize()
    self.origin = cc.Director:getInstance():getVisibleOrigin()
    self.arrIcon = {}
    self.attrIcon = {}
    
    self.ItemTalent = {}
end

function TalentNode:create()
    local node = TalentNode.new()
    node:init()
    return node
end

function TalentNode:init()
    self._csb = cc.CSLoader:createNode("dxyCocosStudio/csd/ui/groupfunc/TalentNode.csb")
    self:addChild(self._csb)
    self._csb:setPosition(self.origin.x + self.visibleSize.width / 2, self.origin.y + self.visibleSize.height / 2)

    dxyExtendEvent(self)
    -- 拦截
    dxySwallowTouches(self)

    require "src.game.utils.TopTitleNode"
    local node = TopTitleNode:create(self,"dxyCocosStudio/png/groupfunc/talent/txt1.png")
    self:addChild(node)
    
--Icon/Text    
    local ndIcon = self._csb:getChildByName("ndIcon")
    local ndText = self._csb:getChildByName("ndText")
    for i=1,ICON_NUM do
        self.arrIcon[i] = ndIcon:getChildByName("Node_"..i)
    end

    self._ndBtn = self._csb:getChildByName("ndBtn")
    self._ndBtn:setPosition(self.visibleSize.width / 2,-self.visibleSize.height / 2)
    local btnAdd = self._ndBtn:getChildByName("btnAdd")
    btnAdd:addTouchEventListener(function(target,type)
        if type == 2 then
			SoundsFunc_playSounds(SoundsType.PRACTICE,false)
            zzc.GroupController:addTalent()
        end
    end)
    
    self._ndAdd = self._csb:getChildByName("ndAdd")
    self._ndAdd:setPosition(-self.visibleSize.width / 2,-self.visibleSize.height / 2)
    self._txtTitle = self._csb:getChildByName("txtTitle")
    self._txtAtk = self._ndAdd:getChildByName("txtAtk")
    self._txtDef = self._ndAdd:getChildByName("txtDef")
    self._txtHp = self._ndAdd:getChildByName("txtHp")
    self._txtContribute = self._ndBtn:getChildByName("txtContribute")

---add---   
    self._txtUse = self._ndBtn:getChildByName("txtUse")
    self._ndCurAdd = self._ndBtn:getChildByName("ndCurAdd")
    self._txtAtt = self._ndCurAdd:getChildByName("txtAtt")
    for i=1,4 do
        self.attrIcon[i] = self._ndCurAdd:getChildByName("icon"..i)
    end
---------
    self:initTalent(zzm.GroupModel.TalentData)
end

function TalentNode:initEvent()
    dxyDispatcher_addEventListener("TalentNode_updateTalent",self,self.updateTalent)
end

function TalentNode:removeEvent()
    dxyDispatcher_removeEventListener("TalentNode_updateTalent",self,self.updateTalent)
end

function TalentNode:initTalent(data)
    local config = GroupConfig:getTalentConfigById(data.Id+1)
    if data.Id >= GroupConfig:getTalentConfigLen() then --满
        for i=1,ICON_NUM do
            self.ItemTalent[i] = ItemTalent:create()
            self.arrIcon[i]:addChild(self.ItemTalent[i])
            self.ItemTalent[i]:update(3)
        end
        self._ndCurAdd:setVisible(false)
        self._txtUse:setString(0)
    else
        local rem = data.Id % ICON_NUM + 1
        for i=1,ICON_NUM do
            self.ItemTalent[i] = ItemTalent:create()
            self.arrIcon[i]:addChild(self.ItemTalent[i])
            if i < rem then --已点亮
                self.ItemTalent[i]:update(3)
            elseif i == rem then --当时
                self.ItemTalent[i]:update(2,config)
            else
                self.ItemTalent[i]:update(1)
            end
        end
---add---        
        self._ndCurAdd:setVisible(true)
        for i=1,4 do
            if i == config.TalentType then
                self.attrIcon[i]:setVisible(true)
            else
                if self.attrIcon[i] then
                    self.attrIcon[i]:setVisible(false)
                end
            end
        end
        self._txtAtt:setString("+"..config.TalentNum)
        self._txtUse:setString(config.TalentCost)
---------
    end
    self._txtTitle:setString(config.Tier)
    self._txtContribute:setString(data.Contribute)

    self._txtAtk:setString(data.Atk)
    self._txtDef:setString(data.Def)
    self._txtHp:setString(data.Hp)
end

function TalentNode:updateTalent(data)
    local config = GroupConfig:getTalentConfigById(data.Id+1)
    if data.Id >= GroupConfig:getTalentConfigLen() then --满
        for i=1,ICON_NUM do
            self.ItemTalent[i]:update(3)
        end
        self._ndCurAdd:setVisible(false)
        self._txtUse:setString(0)
    else
        local rem = data.Id % ICON_NUM + 1
        
        local old = data.Id % ICON_NUM == 0 and ICON_NUM or data.Id % ICON_NUM
        if old == ICON_NUM then
            self.ItemTalent[old]:update(1)
        else
            self.ItemTalent[old]:update(3)
        end
        self.ItemTalent[rem]:update(2,config)
        
        if rem == 1 then
            for i=2,ICON_NUM do
                self.ItemTalent[i]:update(1)
            end
        end
---add---        
        self._ndCurAdd:setVisible(true)
        for i=1,4 do
            if i == config.TalentType then
                self.attrIcon[i]:setVisible(true)
            else
                if self.attrIcon[i] then
                    self.attrIcon[i]:setVisible(false)
                end
            end
        end
        self._txtAtt:setString("+"..config.TalentNum)
        self._txtUse:setString(config.TalentCost)
---------
    end
    
    self._txtTitle:setString(config.Tier)
    self._txtContribute:setString(data.Contribute)

    self._txtAtk:setString(data.Atk)
    self._txtDef:setString(data.Def)
    self._txtHp:setString(data.Hp)
end