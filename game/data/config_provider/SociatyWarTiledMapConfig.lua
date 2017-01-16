SociatyWarTiledMapConfig = SociatyWarTiledMapConfig or class("SociatyWarTiledMapConfig")

---SociatyWarTiledMapConfig
function SociatyWarTiledMapConfig:inpairTileId(gid)
    local list = luacf.SociatyWarTiledMap.SociatyWarTiledMapConfig.TileId
    for i=1,#list do
        if gid < list[i].StartId then
            return list[i-1].StartId
        end
    end
end


---SociatyWarBaseConfig
function SociatyWarTiledMapConfig:getWarBaseConfig(type)
    local list = luacf.SociatyWarBase.SociatyWarBaseConfig.BaseConfig.Base
    for key, var in pairs(list) do
    	if var.Type == type then
            return var
        end   
    end
end

---SociatyWarTileDefineConfig
function SociatyWarTiledMapConfig:getFindExpendTime(gid) 
    local list = luacf.SociatyWarTileDefine.SociatyWarTileDefineConfig.TileDefine
    for key, var in pairs(list) do
    	if var.TileId == gid then
            return var
    	end
    end
    return {}
end

