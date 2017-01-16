tileMapGridTool = {}

require("game.utils.GetIntPart")

function tileMapGridTool.GetUpGrid( pos )
    return {x = pos.x,y = pos.y - 2}
end

function tileMapGridTool.GetDownGrid( pos )
    return {x = pos.x,y = pos.y + 2}
end

function tileMapGridTool.GetLeftGrid( pos )
    return {x = pos.x - 1,y = pos.y}
end

function tileMapGridTool.GetRightGrid( pos )
    return {x = pos.x + 1,y = pos.y}
end

function tileMapGridTool.GetLeftUpGrid( pos )

	local ret = {x=0,y=0}
	
	if math.mod(pos.y,2) == 0 then
		ret.x = pos.x - 1
		ret.y = pos.y - 1
	else
		ret.y = pos.y - 1
	end

    return ret
end

function tileMapGridTool.GetLeftDownGrid( pos )

	local ret = {x=0,y=0}
	
	if math.mod(pos.y,2) == 0 then
		ret.x = pos.x - 1
		ret.y = pos.y + 1
	else
		ret.y = pos.y + 1
	end

    return ret
end

function tileMapGridTool.GetRightUpGrid( pos )

	local ret = {x=0,y=0}
	
	if math.mod(pos.y,2) == 0 then
		ret.y = pos.y - 1
	else
		ret.x = pos.x + 1
		ret.y = pos.y - 1
	end

    return ret
end

function tileMapGridTool.GetRightDownGrid( pos )

	local ret = {x=0,y=0}
	
	if math.mod(pos.y,2) == 0 then
		ret.y = pos.y + 1
	else
		ret.x = pos.x + 1
		ret.y = pos.y + 1
	end

    return ret
end

-----------------------------------------------------------------------------------------------

function tileMapGridTool.CollectionUpGrid( posStart , posEnd , cList )
	local sy = posStart.y
	local ey = posEnd.y
	
	while (sy ~= ey) do
		sy = sy - 2
		table.insert(cList,{x = posStart.x,y = sy})
	end
end

function tileMapGridTool.CollectionDownGrid( posStart , posEnd , cList )
	local sy = posStart.y
	local ey = posEnd.y
	
	while(sy ~= ey) do
		sy = sy + 2
		table.insert(cList,{x = posStart.x,y = sy})
	end
end

function tileMapGridTool.CollectionLeftGrid( posStart , posEnd , cList )
	local sx = posStart.x
	local ex = posEnd.x
	
	while(sx ~= ex) do
		sx = sx - 1
		table.insert(cList,{x = sx,y = posStart.y})
	end
end

function tileMapGridTool.CollectionRightGrid( posStart , posEnd , cList )
	local sx = posStart.x
	local ex = posEnd.x
	
	while(sx ~= ex) do
		sx = sx + 1
		table.insert(cList,{x = sx,y = posStart.y})
	end
end

function tileMapGridTool.getObliquityGridCnt( posStart , posEnd)
	local gridCnt = math.abs(posEnd.y - posStart.y)
	local gridCnt2 = math.abs(posEnd.x - posStart.x)
	gridCnt2 = gridCnt2 * 2
	if posEnd.x == posStart.x then
		gridCnt2 = 1
	elseif posEnd.x > posStart.x then
		if math.mod(posEnd.y,2) == 1 then gridCnt2 = gridCnt2 + 1 end
		if math.mod(posStart.y,2) == 1 then gridCnt2 = gridCnt2 - 1 end	
	else
		if math.mod(posEnd.y,2) == 1 then gridCnt2 = gridCnt2 - 1 end
		if math.mod(posStart.y,2) == 1 then gridCnt2 = gridCnt2 + 1 end	
	end
	
	if gridCnt2 < gridCnt then gridCnt = gridCnt2 end
	
	return gridCnt
end

function tileMapGridTool.CollectionLeftUpGrid( posStart , posEnd , cList )

	local gridCnt = tileMapGridTool.getObliquityGridCnt(posStart , posEnd)
	
	local sx = posStart.x
	local sy = posStart.y
	
	for i=1,gridCnt,1 do
		if math.mod(sy,2) == 1 then
			sy = sy - 1
		else
			sx = sx - 1
			sy = sy - 1
		end
		table.insert(cList,{x = sx,y = sy})
	end
end

function tileMapGridTool.CollectionLeftDownGrid( posStart , posEnd , cList )

	local gridCnt = tileMapGridTool.getObliquityGridCnt(posStart , posEnd)
	
	local sx = posStart.x
	local sy = posStart.y
	
	for i=1,gridCnt,1 do
		if math.mod(sy,2) == 1 then
			sy = sy + 1
		else
			sx = sx - 1
			sy = sy + 1
		end
		table.insert(cList,{x = sx,y = sy})
	end
end

function tileMapGridTool.CollectionRightUpGrid( posStart , posEnd , cList )

	local gridCnt = tileMapGridTool.getObliquityGridCnt(posStart , posEnd)
	
	local sx = posStart.x
	local sy = posStart.y
	
	for i=1,gridCnt,1 do
		if math.mod(sy,2) == 1 then
			sy = sy - 1
			sx = sx + 1
		else
			sy = sy - 1
		end
		table.insert(cList,{x = sx,y = sy})
	end
end

function tileMapGridTool.CollectionRightDownGrid( posStart , posEnd , cList )

	local gridCnt = tileMapGridTool.getObliquityGridCnt(posStart , posEnd)
	
	local sx = posStart.x
	local sy = posStart.y
	
	for i=1,gridCnt,1 do
		if math.mod(sy,2) == 1 then
			sy = sy + 1
			sx = sx + 1
		else
			sy = sy + 1
		end
		table.insert(cList,{x = sx,y = sy})
	end
end
-----------------------------------------------------------------------------------------------
function tileMapGridTool.GetGridsToTargetPos( posStart , posEnd , pList)

	local retList = pList or {}

	if posStart.x == posEnd.x and posStart.y == posEnd.y then return retList end -- 如果是同一个坐标
	
	-- 如果是正方向
	if posStart.y == posEnd.y then
		if posEnd.x > posStart.x then
			-- right
			tileMapGridTool.CollectionRightGrid(posStart,posEnd,retList)
		else 
			-- left
			tileMapGridTool.CollectionLeftGrid(posStart,posEnd,retList)
		end
	elseif posEnd.x == posStart.x then
        local disy = math.abs(posEnd.y - posStart.y)
		local floaty = disy / 2
		local inty = GetIntPart(floaty)
		if inty == floaty then -- 能整除2则是正方向
			if posEnd.y > posStart.y then
				-- down
				tileMapGridTool.CollectionDownGrid(posStart,posEnd,retList)
			else
				-- up
				tileMapGridTool.CollectionUpGrid(posStart,posEnd,retList)
			end
		else -- X相邻一格才会出现这种情况
			if posEnd.y > posStart.y then
				if math.mod(posEnd.y,2) == 1 then
					-- RightDown
					tileMapGridTool.CollectionRightDownGrid(posStart,posEnd,retList)
					local n = #retList
					if retList[n] ~= posEnd then tileMapGridTool.GetGridsToTargetPos(retList[n] , posEnd , retList) end
				else
					-- LeftDown
					tileMapGridTool.CollectionLeftDownGrid(posStart,posEnd,retList)
					local n = #retList
					if retList[n] ~= posEnd then tileMapGridTool.GetGridsToTargetPos(retList[n] , posEnd , retList) end
				end
			else
				if math.mod(posEnd.y,2) == 1 then
					-- RightUp
					tileMapGridTool.CollectionRightUpGrid(posStart,posEnd,retList)
					local n = #retList
					if retList[n] ~= posEnd then tileMapGridTool.GetGridsToTargetPos(retList[n] , posEnd , retList) end
				else
					-- LeftUp
					tileMapGridTool.CollectionLeftUpGrid(posStart,posEnd,retList)
					local n = #retList
					if retList[n] ~= posEnd then tileMapGridTool.GetGridsToTargetPos(retList[n] , posEnd , retList) end
				end
				
			end
		end
		
	else -- 优先走斜线，再走正方向
		if posEnd.x < posStart.x then -- left
			if posEnd.y < posStart.y then -- left up
				tileMapGridTool.CollectionLeftUpGrid(posStart,posEnd,retList)
				local n = #retList
				if retList[n] ~= posEnd then tileMapGridTool.GetGridsToTargetPos(retList[n] , posEnd , retList) end
			else -- left down
				tileMapGridTool.CollectionLeftDownGrid(posStart,posEnd,retList)
				local n = #retList
				if retList[n] ~= posEnd then tileMapGridTool.GetGridsToTargetPos(retList[n] , posEnd , retList) end
			end
		else -- right
			if posEnd.y < posStart.y then -- right up
				tileMapGridTool.CollectionRightUpGrid(posStart,posEnd,retList)
				local n = #retList
				if retList[n] ~= posEnd then tileMapGridTool.GetGridsToTargetPos(retList[n] , posEnd , retList) end
			else -- right down
				tileMapGridTool.CollectionRightDownGrid(posStart,posEnd,retList)
				local n = #retList
				if retList[n] ~= posEnd then tileMapGridTool.GetGridsToTargetPos(retList[n] , posEnd , retList) end
			end
		end
	
	end
	
	
	return retList
	
end

