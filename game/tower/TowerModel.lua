local TowerModel = class("TowerModel")
TowerModel.__index = TowerModel

function TowerModel:ctor()
    self:initModel()
end

function TowerModel:initModel()
    self.clickCount = 0
    self.clickedCount = 0
    self.card_list = {}
    self.clicked_card = {}
    
    
    self.expId = 0
    self.flowerId = 0
    self.renownId = 0
    
    self.towerCDList = {}
    
end

function TowerModel:resetClickedCount()
    self.clickedCount = 0
    self.card_list = {}
    self.clicked_card = {}
end

return TowerModel