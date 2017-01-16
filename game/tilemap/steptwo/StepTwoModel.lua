local StepTwoModel = class("StepTwoModel")

function StepTwoModel:ctor()
    self.allPlayerData = {} --其他玩家数据
    self._myData = {}      --自身数据
    self._arrCDTimer = {} --探索CD
    self._arrResource = {} --地图掉落资源
    
    self._arrLastView = {} --视角范围
end

---自身数据
function StepTwoModel:initMyData(data)
    self._myData = data
--    local drop = {
--        posX = data.posX,
--        posY = data.posY,
--        goods = {{type = 6,value = 101001,num = 1}},
--    }
--    self:initArrResource(drop)
end

--设置自身数据
function StepTwoModel:setMyData(data)
    self._myData.posX = data.x
    self._myData.posY = data.y
end

--获取自身数据
function StepTwoModel:getMyData()
    return self._myData
end

---当前视角范围
function StepTwoModel:getLastView()
    return self._arrLastView
end

function StepTwoModel:setLastView(data)
    self._arrLastView = data
end

---initPlayerData
function StepTwoModel:initPlayerData(data)
    table.insert(self.allPlayerData,data)
end

--addPlayerData
function StepTwoModel:addPlayerData(data)
    for key, var in pairs(self.allPlayerData) do
    	if var.uid == data.uid then
    	    return
    	end
    end
    table.insert(self.allPlayerData,data)
    dxyDispatcher_dispatchEvent("TileMapLayer_addPerson",data)
end

--updatePlayerData
function StepTwoModel:updatePlayerData(data)
    for key, var in pairs(self.allPlayerData) do
    	if var.uid == data.uid then
    	    var.posX = data.posX
    	    var.posY = data.posY
            zzm.StepTwoModel:checkAllThings(CMap:viewCan(2,cc.p(self:getMyData().posX,self:getMyData().posY)))
            dxyDispatcher_dispatchEvent("TileMapLayer_updatePerson",var)
    	    break
    	end
    end
end

--delPlayerData
function StepTwoModel:delPlayerData(uid)
    for key, var in pairs(self.allPlayerData) do
    	if var.uid == uid then
            dxyDispatcher_dispatchEvent("TileMapLayer_delPerson",var.uid)
            table.remove(self.allPlayerData,key)
    	    break
    	end
    end
end

---探索CD
--init
function StepTwoModel:initCDTimer(data)
    table.insert(self._arrCDTimer,data)
end
--add
function StepTwoModel:addCDTimer(data)
    table.insert(self._arrCDTimer,data)
    if SceneManager.m_curSceneName == "ImmortalMainScene" then
        dxyDispatcher_dispatchEvent("TileMapLayer_updateCDEffect",data)
    end
end

---地图掉落资源
--init
function StepTwoModel:initArrResource(data)
    table.insert(self._arrResource,data)
end

--add
function StepTwoModel:addArrResource(data)
    table.insert(self._arrResource,data)
    dxyDispatcher_dispatchEvent("TileMapLayer_addDropResource",data)
end

--del
function StepTwoModel:delArrResource(data)
    for key, var in pairs(self._arrResource) do
    	if var.posX == data.posX and var.posY == data.posY then
            dxyDispatcher_dispatchEvent("TileMapLayer_delDropResource",data)
    	    table.remove(self._arrResource,key)
    	    break
    	end
    end
end

---其他玩家部分状态更新
function StepTwoModel:updateSomeState(data)
    if data.type == 1 then --战斗更新
        for key, var in pairs(self.allPlayerData) do
        	if var.uid == data.uid then
        	    var.isWar = data.value
                dxyDispatcher_dispatchEvent("TileMapLayer_updatePerson",var)
        	    break
        	end
        end
    elseif data.type == 2 then --探索更新
        for key, var in pairs(self.allPlayerData) do
        	if var.uid == data.uid then
                var.isFind = data.value
                dxyDispatcher_dispatchEvent("TileMapLayer_updatePerson",var)
        	    break
        	end
        end
    end
end

---其他玩家部分状态新增
function StepTwoModel:addSomeState(data)
    if data.type == 1 then --是否新增探索事件
--        for key, var in pairs(self.allPlayerData) do
--            if var.uid == data.uid then
--                var.isFind = data.value
--                dxyDispatcher_dispatchEvent("TileMapLayer_updatePerson",var)
--                break
--            end
--        end
    elseif data.type == 2 then --新增地图CD
        local isNew = true
        for key, var in pairs(self._arrCDTimer) do
        	if var.posX == data.posX and var.posY == data.posY then
                var.endTimer = data.endTimer
        	    isNew = false
        	end
        end
        if isNew then
            table.insert(self._arrCDTimer,data)
        end
        if SceneManager.m_curSceneName == "ImmortalMainScene" then
            dxyDispatcher_dispatchEvent("TileMapLayer_updateCDEffect",data)
        end
    end 
end

---检查可视范围 check
function StepTwoModel:checkAllThings(view)
    local havePlayer,isnewCD,isoldCD,isoldDrop
    local beyondPlayer = {}
    local newCD = {}
    local oldCD = {}
    local oldDrop = {}
--otherPlayers
    for key, var in pairs(self.allPlayerData) do
        havePlayer = false
    	for i=1,#view do
			if var.posX == view[i].x and var.posY == view[i].y then
                havePlayer = true 
				break
			end
		end
        if not havePlayer then
            table.insert(beyondPlayer,var.uid)
		end
    end

    for key, var in pairs(beyondPlayer) do
        if var then
    	   self:delPlayerData(var)
    	end
    end
    
--CD
    --add
    local lastView = self:getLastView()
    for key1, var1 in pairs(view) do
	    isnewCD = true
    	for key2, var2 in pairs(lastView) do
    		if var2.x == var1.x and var2.y == var1.y then
    		    isnewCD = false
    		    break
    		end 
    	end
        if isnewCD then
            table.insert(newCD,var1)
    	end
    end
    
    --del
    for key2, var2 in pairs(lastView) do
        isoldCD = true
    	for key1, var1 in pairs(view) do
    		if var2.x == var1.x and var2.y == var1.y then
    		    isoldCD = false
    		    break
    		end
    	end
    	if isoldCD then
    	    table.insert(oldCD,var2)
    	end
    end
    
    for key, var in pairs(newCD) do
        local gid = CMap:getGlobalGID(var)
        local timer = SociatyWarTiledMapConfig:getFindExpendTime(gid).ExploreCd
        if timer then --不存在探索则不显示CD
            dxyDispatcher_dispatchEvent("TileMapLayer_addCDEffect",var)
        end
    end
    for var=1, #oldCD do
        dxyDispatcher_dispatchEvent("TileMapLayer_delCDEffect",oldCD[var])
    end
    
    self:setLastView(view)
    
--drop
    for key1, var1 in pairs(self._arrResource) do
        isoldDrop = true
    	for key2, var2 in pairs(view) do
    		if var1.posX == var2.x and var1.posY == var2.y then
    		    local curPos = self:getMyData() 
                if var1.posX == curPos.posX and var1.posY == curPos.posY then --拣到资源
                    table.insert(oldDrop,var1)
    		    end
    		    isoldDrop = false
    		    break
    		end
    	end
    	if isoldDrop then
            table.insert(oldDrop,var1)
    	end
    end    
    
    for i=1,#oldDrop do
        self:delArrResource(oldDrop[i])
    end
end

function StepTwoModel:whenClose()
    self.allPlayerData = {} --其他玩家数据
    self._arrCDTimer = {} --探索CD
    self._arrResource = {} --地图掉落资源
end

return StepTwoModel