PhysicalTipsController = PhysicalTipsController or class("PhysicalTipsController")

function PhysicalTipsController:ctor()

end

function PhysicalTipsController:showLayer()
    require "game.commonUI.PhysicalTips"
    local scene = SceneManager:getCurrentScene()
    scene:addChild(PhysicalTips:create())
end

function PhysicalTipsController:showGodLayer()
    require "game.commonUI.GodPhysicalTips"
    local scene = SceneManager:getCurrentScene()
    scene:addChild(GodPhysicalTips:create())
end

return PhysicalTipsController