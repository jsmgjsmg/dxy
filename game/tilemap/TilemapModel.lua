local TilemapModel = class("TilemapModel")
TilemapModel.__index = TilemapModel

function TilemapModel:ctor()
    self:initModel()
end

function TilemapModel:initModel()
    self.state = nil
end

function TilemapModel:setState(state)
	self.state = state
end

return TilemapModel