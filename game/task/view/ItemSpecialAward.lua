local ItemSpecialAward = class("ItemSpecialAward",function()
    return cc.Node:create()
end)
local GOODS_NUM = 3

function ItemSpecialAward:ctor()
    self._iconGoods = {}
    self._bgGoods = {}
    self._initPosX = 167
end

function ItemSpecialAward:create(i)
    local node = ItemSpecialAward:new()
    node:init(i)
    return node
end

function ItemSpecialAward:init(i)
    self._csb = cc.CSLoader:createNode("res/dxyCocosStudio/csd/ui/task/ItemTask.csb")
    self:addChild(self._csb)
    local Image = self._csb:getChildByName("Image")
    self._gold = Image:getChildByName("gold")
    self._yb = Image:getChildByName("yb")
    self._exp = Image:getChildByName("exp")
    self._power = Image:getChildByName("power")
    self._renown = Image:getChildByName("renown")
    for i=1,GOODS_NUM do
        self._bgGoods[i] = self._Image:getChildByName("goods"..i)
        self._iconGoods[i] = self._bgGoods[i]:getChildByName("Sprite")
    end
    
    self._txtGold = self._gold:getChildByName("txtGold")
    self._txtYB = self._yb:getChildByName("txtYB")
    self._txtExp = self._exp:getChildByName("txtExp")
    self._txtPower = self._power:getChildByName("txtPower")
    self._txtRenown = self._power:getChildByName("txtRenown")

    local ndTxt = self._csb:getChildByName("ndTxt")
    self._txtTitle = ndTxt:getChildByName("txtTitle")
    self._txtInt = ndTxt:getChildByName("txtInt")
    
    self._btnGet = self._csb:getChildByName("btnGet")
    self._btnGoto = self._csb:getChildByName("btnGoto")
    self._btnNotyet = self._csb:getChildByName("btnNotyet")
    self._btnNotyet:setVisible(false)
    
    self._btnGet:addTouchEventListener(function(target,type)
        if type == 2 then
            SoundsFunc_playSounds(SoundsType.UNIVERSAL_BTN,false)
            zzc.TaskController:registerGetSpecialAward(self.m_data.Id)
        end
    end)
    
end

function ItemSpecialAward:update(data)
    self.m_data = data
    
    self._btnGet:setVisible(false)
    self._btnGoto:setVisible(false)
    self._btnNotyet:setVisible(false)
    self._gold:setVisible(false)
    self._yb:setVisible(false)
    self._exp:setVisible(false)
    self._power:setVisible(false)
    self._renown:setVisible(false)
    for i=1,GOODS_NUM do
        self._bgGoods[i]:setVisible(false)
    end
    self._initPosX = 167
    
    local specialConfig = TaskConfig:getSpecialGroup(self.m_data.SecType)
    self._txtTitle:setString(specialConfig.Name)
    self._txtInt:setString(specialConfig.Introduction)
    if self.m_data.State == 0 then
        self._btnGet:setVisible(false)
        self._btnGoto:setVisible(false)
        self._btnNotyet:setVisible(true)
        self._Image:loadTexture("dxyCocosStudio/png/pk/dekaronBg.png")
    elseif self.m_data.State == 1 then
        self._btnGet:setVisible(true)
        self._btnGoto:setVisible(false)
        self._btnNotyet:setVisible(false)
        self._Image:loadTexture("dxyCocosStudio/png/task/new/bgLight.png")
    elseif self.m_data.State == 2 then
        self._btnGet:setVisible(false)
        self._btnGoto:setVisible(false)
        self._btnNotyet:setVisible(false)
    end
    
    self._rewards = self.m_data.Reward
    self:HideRes(self._gold,self._txtGold,self:findRes(1))
    self:HideRes(self._yb,self._txtYB,self:findRes(2))
    self:HideRes(self._exp,self._txtExp,self:findRes(3))
    self:HideRes(self._power,self._txtPower,self:findRes(12))
    self:HideRes(self._renown,self._txtRenown,self:findRes(4))
    self:HideGoods(self._rewards)
end

function ItemSpecialAward:findRes(type)
    for key, var in pairs(self._rewards) do
        if var.Type == type then
            return var
        end
    end
end

function ItemSpecialAward:HideRes(target,text,res)
    if res then
        target:setVisible(true)
        text:setString(cn:convert(res.Num))
        self._initPosX = self._initPosX + 80
        target:setPositionX(self._initPosX)
    else
        target:setVisible(false)
    end
end

function ItemSpecialAward:HideGoods(data)
    local i = 1
    for key, var in pairs(data) do
        if var.Type == 6 or var.Type == 10 then
            self._bgGoods[i]:setVisible(true)
            self._initPosX = self._initPosX + 80
            self._bgGoods[i]:setPositionX(self._initPosX)
            local config = GoodsConfigProvider:findGoodsById(var.Id)
            self._iconGoods[i]:setTexture("Icon/"..config.Icon..".png")
            i = i + 1
        end
    end
end

return ItemSpecialAward
