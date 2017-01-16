--神将场景表
GodGeneralSceneConfig = {
}

function GodGeneralSceneConfig:getSceneIdByDifficulty(difficulty)
    local list = luacf.GodGeneralsScene.GodGeneralsSceneConfig.SceneConfig.Scene
    for key, var in pairs(list) do
		if var.Difficulty == difficulty then
			return var.SceneId
		end
	end
	return nil
end

--神将副本(难度)
function GodGeneralSceneConfig:getCopyDifficulty(dfc)
    local list = luacf.GodGeneralsScene.GodGeneralsSceneConfig.SceneConfig.Scene
    for key, var in pairs(list) do
        if var.Difficulty == dfc then
            return var
        end
    end
end

--(怪物组)
function GodGeneralSceneConfig:getCopyMonster(list,mst)
    local Monster = list.SceneMonster.Monster
    for key, var in pairs(Monster) do
        if var.MonsterGroup == mst then
            return var
        end
    end
end

--刷新
function GodGeneralSceneConfig:getCopyValue()
    return luacf.GodGeneralsScene.GodGeneralsSceneConfig.CopyValueConfig.CopyValue
end

--神将副本扫荡元宝
function GodGeneralSceneConfig:getRmbGeneralRipe()
    return luacf.GodGeneralsScene.GodGeneralsSceneConfig.CopyValueConfig.CopyValue.SaoDangRmb
end
