TowerExpLayer = TowerExpLayer or class("TowerExpLayer",function()
	return cc.Layer:create()
end)

function TowerExpLayer:create()
    local layer = TowerExpLayer:new()
    return layer
end

function TowerExpLayer:ctor()
	self._csb = nil
	
	self.item_list = {}
	self.list_data = {}
	
	self:initUI()
	self:initEvent()
end

function TowerExpLayer:initUI()
	self._csb = cc.CSLoader:createNode("dxyCocosStudio/csd/ui/tower/TowerExpLayer.csb")
	self:addChild(self._csb)
	
	self.bg = self._csb:getChildByName("BG")
	
	self.txt_count = self.bg:getChildByName("text")
	
	self.scrollView = self._csb:getChildByName("ScrollView")
    self.scrollView:setScrollBarEnabled(false)
	
	self:addScrollView()
end

function TowerExpLayer:initEvent()

    local role = zzm.CharacterModel:getCharacterData()
    local enCAT = enCharacterAttrType
    local expCount = role:getValueByType(enCAT.TRAINEXPCOUNT)
    self.txt_count:setString("当前剩余次数:"..expCount)

    -- 拦截
    dxySwallowTouches(self,self.bg)
end

function TowerExpLayer:addScrollView()
    require("game.tower.view.TowerExpItem")
    local item = nil
    local itemSize = nil
    local x,y = 0,0
    local index = 1
    
    self.list_data = TowerConfig:getDataByType(TowerType.EXP).Base

    for i=1,#self.list_data do
        item = TowerExpItem:create()
        item:update(self.list_data[i])
        item:setAnchorPoint(cc.p(0,0))
        itemSize = item:getContentSize()
        x = 0
        y = itemSize.height * (i - 1)
        item:setPosition(cc.p(x,y))
        self.scrollView:addChild(item)
        self.item_list[index] = item
        index = index + 1
    end
    self.scrollView:setInnerContainerSize(cc.size(itemSize.width,itemSize.height * #self.list_data))
    
    self.scrollView:scrollToBottom(0,false)
end