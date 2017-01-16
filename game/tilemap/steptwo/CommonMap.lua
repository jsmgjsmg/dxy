CMap = CMap or class("CMap")

---init
function CMap:init(tileMap)
    self._tileMap = tileMap
    self._layerTerrian1 = self._tileMap:getLayer("base") 
    self._tileSize = self._tileMap:getTileSize()
    self._mapSize = self._tileMap:getMapSize()
    self.visibleSize = cc.Director:getInstance():getVisibleSize()
    --地图整体像素大小
    self._tureMapSize = {width=(self._mapSize.width + 0.5) * self._tileSize.width, height=(self._mapSize.height + 1) * math.modf(self._tileSize.height / 2)}
    --移动边界
    self.MetaMin = {x = -(self._tileSize.width), y = -(self._tileSize.height)}
    self.MetaMax = {x = -(self._tureMapSize.width - self._tileSize.width - self.visibleSize.width), 
        y = -(self._tureMapSize.height - self._tileSize.height - self.visibleSize.height)}
    self.viewScope = {}
end

--    --GID
--    local layer1 = self._tileMap:getLayer("Terrian1")
--    local gid = layer1:getTileGIDAt(cc.p(x,y))
--    print("gid "..gid)
--    return {x = math.modf(x),y = math.modf(y)}

---转换成tile坐标
function CMap:tileCoordForPosition(pos)
    local x = pos.x / self._tileSize.width
    local y = (self._tureMapSize.height - pos.y) / (self._tileSize.height/2)

--[[ 
             由于tilemap45度交错的单个菱形存在互相包含 ，通过测试做出以下①②处理
--]]

    local tempTilePos = {x = math.modf(x),y = math.modf(y)}
    local tempLayerPos = self:layerCoordForPosition(tempTilePos)
    
    ----①如果点击坐标与算出坐标(都是layer坐标)x方向相差半个菱形，则x-1
    if math.abs(tempLayerPos.x - pos.x) > self._tileSize.width/2 then
        tempTilePos.x = tempTilePos.x - 1
        tempLayerPos = self:layerCoordForPosition(tempTilePos)
    end
    ----
    
    ---②菱形水平切开，是否在上半，如果在上半可直接返回。下半会出现坐标偏移，相应处理
    local A = {}
    local B = {}
    local C = {}
    local P = {}
    A.x = tempLayerPos.x - self._tileSize.width/2
    A.y = tempLayerPos.y

    B.x = tempLayerPos.x
    B.y = tempLayerPos.y + self._tileSize.height/2

    C.x = tempLayerPos.x + self._tileSize.width/2
    C.y = tempLayerPos.y

    P.x = pos.x
    P.y = pos.y

    --S = |(Ax*By + Bx*Cy + Cx*Ay - Ay*Bx - By*Cx - Cy*Ax) / 2|
    local S  = math.abs((A.x*B.y + B.x*C.y + C.x*A.y - A.y*B.x - B.y*C.x - C.y*A.x) / 2)
    local SA = math.abs((A.x*B.y + B.x*P.y + P.x*A.y - A.y*B.x - B.y*P.x - P.y*A.x) / 2)
    local SB = math.abs((P.x*B.y + B.x*C.y + C.x*P.y - P.y*B.x - B.y*C.x - C.y*P.x) / 2)
    local SC = math.abs((A.x*P.y + P.x*C.y + C.x*A.y - A.y*P.x - P.y*C.x - C.y*A.x) / 2)

    local lastPos = {}

    --是否在上半
    if S >= SA + SB + SC then --in
        return tempTilePos
    else --out
        if pos.x > tempLayerPos.x then --左下,取右上
            if tempTilePos.y % 2 == 1 then
                lastPos.x = tempTilePos.x + 1
                lastPos.y = tempTilePos.y - 1
            else
                lastPos.x = tempTilePos.x
                lastPos.y = tempTilePos.y - 1
            end 
        else --右下，取左上
            if tempTilePos.y % 2 == 1 then
                lastPos.x = tempTilePos.x
                lastPos.y = tempTilePos.y - 1
            else
                lastPos.x = tempTilePos.x - 1
                lastPos.y = tempTilePos.y - 1
            end 
        end
    end
    
    return lastPos
end

---转换成layer坐标
function CMap:layerCoordForPosition(pos)
    local layerCoord = self._layerTerrian1:getPositionAt(pos)
    layerCoord.x = layerCoord.x + self._tileSize.width / 2
    layerCoord.y = layerCoord.y + self._tileSize.height / 2
    print("layerCoord "..layerCoord.x..","..layerCoord.y)
    return layerCoord
end

---判断可否点击
function CMap:isBeyond(pos)
    local beyond = self._tileMap:getLayerName("Meta")
    local tileGid = beyond:getTileGIDAt(CMap:tileCoordForPosition(pos)) --得到全局唯一标识
    if tileGid then
        local properties = self._tileMap:getPropertiesForGID(tileGid) --所有属性
        if properties then
            local is = properties:getProperty("Beyond")  --单项属性
            if is == "True" then
                return true
            end
        end
    end

    return false
end

---可视范围
--all
function CMap:viewCan(dis,pos)--(距离，当前位置)
    local temp = {}
    self.viewScope = {}
    local first = true
    local upPos = {}
    for key, var in pairs(pos) do
    	upPos[key] = var
    end
    upPos.y = pos.y - 2 * dis
    local x = upPos.x
    local y = upPos.y
    for i=1,2*dis+1 do --左列
        if not first then
            if upPos.y % 2 == 1 then
                upPos.y = upPos.y + 1
                x = upPos.x
                y = upPos.y
            else
                upPos.x = upPos.x - 1
                upPos.y = upPos.y + 1
                x = upPos.x
                y = upPos.y
            end
        end
        if x > 0 and x < self._mapSize.width-1 and y > 0 and y < self._mapSize.height-1 then
            table.insert(self.viewScope,cc.p(x,y))
        end
        first = false
    
        temp.x = x
        temp.y = y
        local w,h = 0
        for i=1,2*dis do --右列
            if temp.y % 2 == 1 then
                temp.x = temp.x + 1
                temp.y = temp.y + 1
                w = temp.x
                h = temp.y
            else
                temp.y = temp.y + 1
                w = temp.x
                h = temp.y
            end
            if w > 0 and w < self._mapSize.width-1 and h > 0 and h < self._mapSize.height-1 then
                table.insert(self.viewScope,cc.p(w,h))
            end
        end
    end
    return self.viewScope
end

---获取全局GID
function CMap:getGlobalGID(tilePos)
    local layerCity = self._tileMap:getLayer("city") 
    local layerObject = self._tileMap:getLayer("object") 
    local layerCloud = self._tileMap:getLayer("cloud") 
    local layerBase = self._tileMap:getLayer("base")
    
    local gidCity = layerCity:getTileGIDAt(tilePos)
    if gidCity ~= 0 then
        print("CMap:getGlobalGID: "..gidCity)
        return gidCity
    end
    
    local gidObject = layerObject:getTileGIDAt(tilePos)
    if gidObject ~= 0 then
        print("CMap:getGlobalGID: "..gidObject)
        return gidObject
    end
    
    local gidCloud = layerCloud:getTileGIDAt(tilePos)
    if gidCloud ~= 0 then
        print("CMap:getGlobalGID: "..gidCloud)
        return gidCloud
    end
    
    local gidBase = layerBase:getTileGIDAt(tilePos)
    if gidBase ~= 0 then
        print("CMap:getGlobalGID: "..gidBase)
        return gidBase
    end
end

----上
--function CMap:viewUp(dis,pos)
--    local temp = nil
--    for i = 1,dis do
--        if not temp then
--            temp = pos
--        end
--        temp.y = temp.y - 2
--        table.insert(self.viewScope,temp)
--    end
--end
--
----下
--function CMap:viewDown(dis,pos)
--    local temp = nil
--    for i = 1,dis do
--        if not temp then
--            temp = pos
--        end
--        temp.y = temp.y + 2
--        table.insert(self.viewScope,temp)
--    end
--end
--
----左
--function CMap:viewLeft(dis,pos)
--    local temp = nil
--    for i = 1,dis do
--        if not temp then
--            temp = pos
--        end
--        temp.x = temp.x - 1
--        table.insert(self.viewScope,temp)
--    end
--end
--
----右
--function CMap:viewRight(dis,pos)
--    local temp = nil
--    for i = 1,dis do
--        if not temp then
--            temp = pos
--        end
--        temp.x = temp.x + 1
--        table.insert(self.viewScope,temp)
--    end
--end
--
----左上
--function CMap:viewUpLeft(dis,pos)
--    local temp = nil
--    for i=1,dis do
--        if not temp then
--            temp = pos
--        end
--        if temp.y % 2 == 1 then
--            temp.y = temp.y - 1
--        else
--            temp.x = temp.x - 1
--            temp.y = temp.y - 1
--        end
--        table.insert(self.viewScope,temp)
--    end
--end
--
----右上
--function CMap:viewUpRight(dis,pos)
--    local temp = nil
--    for i=1,dis do
--        if not temp then
--            temp = pos
--        end
--        if temp.y % 2 == 1 then
--            temp.x = temp.x + 1
--            temp.y = temp.y - 1
--        else
--            temp.y = temp.y + 1
--        end
--        table.insert(self.viewScope,temp)
--    end
--end
--
----左下
--function CMap:viewDownLeft(dis,pos)
--    local temp = nil
--    for i=1,dis do
--        if not temp then
--            temp = pos
--        end
--        if temp.y % 2 == 1 then
--            temp.y = temp.y + 1
--        else
--            temp.x = temp.x - 1
--            temp.y = temp.y + 1
--        end
--        table.insert(self.viewScope,temp)
--    end
--end
--
----右下
--function CMap:viewDownRight(dis,pos)
--    local temp = nil
--    for i=1,dis do
--        if not temp then
--            temp = pos
--        end
--        if temp.y % 2 == 1 then
--            temp.x = temp.x + 1
--            temp.y = temp.y + 1
--        else
--            temp.y = temp.y + 1
--        end
--        table.insert(self.viewScope,temp)
--    end
--end
