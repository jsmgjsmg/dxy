SweepResultItem = SweepResultItem or class("SweepResultItem",function()
    return ccui.Layout:create()
end)

function SweepResultItem:create()
    local layer = SweepResultItem:new()
    return layer
end

function SweepResultItem:ctor()
    self._csb = nil

    self:initUI()
    self:initEvent()
end

function SweepResultItem:initUI()
    self._csb = cc.CSLoader:getInstance():createNodeWithFlatBuffersFile("dxyCocosStudio/csd/ui/sweep/SweepResultItem.csb")
    self:addChild(self._csb)
    
    self.bg = self._csb:getChildByName("bg")

    self.txt_num = self._csb:getChildByName("Image"):getChildByName("numTxt")
    self.txt_exp = self._csb:getChildByName("Image"):getChildByName("expTxt")
    self.txt_gold = self._csb:getChildByName("Image"):getChildByName("goldTxt")
    
    require "src.game.equip.view.EquipItem"
    self.goodsList = {}
    for index=1, 7 do
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

function SweepResultItem:initEvent()
    
end

function SweepResultItem:update(data)
	self.m_data = data
	
    self.txt_num:setString("第"..self.m_data.idx.."次扫荡,您获得:")
    self.txt_exp:setString(self.m_data.exp)
    self.txt_gold:setString(self.m_data.gold)
    
    local config = nil
    for index=1, #self.m_data.equip do
        config = GoodsConfigProvider:findGoodsById(self.m_data.equip[index].goods_id)
        self.goodsList[index]:updateConfig(config,self.m_data.equip[index].count)
    end
end

function SweepResultItem:getPageSize()
    return self.bg:getContentSize() 
end