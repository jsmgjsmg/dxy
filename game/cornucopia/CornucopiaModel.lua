local CornucopiaModel = class("CornucopiaModel")
CornucopiaModel.__index = CornucopiaModel

function CornucopiaModel:ctor()
    self:initModel()
end

function CornucopiaModel:initModel()
    self.clickCount = 0
    self.clickedCount = 0
    self.card_list = {}
    self.clicked_card = {}
    
    --冷却时间
    self.cdTime = 0
end

function CornucopiaModel:resetClickedCount()
    self.clickedCount = 0
    self.card_list = {}
    self.clicked_card = {}
end

return CornucopiaModel