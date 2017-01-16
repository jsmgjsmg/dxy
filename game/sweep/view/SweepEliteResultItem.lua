SweepEliteResultItem = SweepEliteResultItem or class("SweepEliteResultItem",function()
    return ccui.Layout:create()
end)

function SweepEliteResultItem:create()
    local layer = SweepEliteResultItem:new()
    return layer
end

function SweepEliteResultItem:ctor()
    self._csb = nil

    self:initUI()
    self:initEvent()
end

function SweepEliteResultItem:initUI()
    self._csb = cc.CSLoader:getInstance():createNodeWithFlatBuffersFile("dxyCocosStudio/csd/ui/sweep/SweepEliteResultItem.csb")
    self:addChild(self._csb)

    self.bg = self._csb:getChildByName("bg")

    self.txt_num = self._csb:getChildByName("Image"):getChildByName("numTxt")
    self.txt_renown = self._csb:getChildByName("Image"):getChildByName("renownTxt")
    self.txt_gold = self._csb:getChildByName("Image"):getChildByName("goldTxt")

    require "src.game.equip.view.EquipItem"
    self.goodsList = {}
    for index=1, 3 do
        local goods = self._csb:getChildByName("Node_" .. index)
        local item = EquipItem:create()
        item:setScale(0.8)
        item:setTouchEnabled(false)
        --item:retain()
        goods:addChild(item)
        self.goodsList[index] = item 
        self.goodsList[index]:updateConfig()       
    end
end

function SweepEliteResultItem:initEvent()

end

function SweepEliteResultItem:update(data)
    self.m_data = data

    self.txt_num:setString("第"..self.m_data.idx.."次扫荡,您获得:")
    self.txt_renown:setString(self.m_data.renown)
    self.txt_gold:setString(self.m_data.gold)

    local config = nil
    for index=1, #self.m_data.stone do
        config = GoodsConfigProvider:findGoodsById(self.m_data.stone[index].goods_id)
        self.goodsList[index]:updateConfig(config,self.m_data.stone[index].count)
    end
end

function SweepEliteResultItem:getPageSize()
    return self.bg:getContentSize() 
end