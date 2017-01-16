local StepTwoController = class("StepTwoController")

function StepTwoController:ctor()
    self._layer = nil
    self._haveData = false
    self:registerListenner()
end

function StepTwoController:registerListenner()
    _G.NetManagerLuaInst:registerListenner(DefineProto.PROTO_SOCIATY_WAR_REGION_DATA,self)
    _G.NetManagerLuaInst:registerListenner(DefineProto.PROTO_SOCIATY_WAR_WALK_DATA,self)
    _G.NetManagerLuaInst:registerListenner(DefineProto.PROTO_SOCIATY_WAR_WALK_DATA_BROADCAST,self)
	_G.NetManagerLuaInst:registerListenner(DefineProto.PROTO_SOCIATY_WAR_EXIT_BROADCAST,self)
	_G.NetManagerLuaInst:registerListenner(DefineProto.PROTO_SOCIATY_WAR_POSITION_DATA,self)
	_G.NetManagerLuaInst:registerListenner(DefineProto.PROTO_SOCIATY_WAR_DROP_DATA,self)
	_G.NetManagerLuaInst:registerListenner(DefineProto.PROTO_SOCIATY_WAR_ROLE_UPDATE,self)
    _G.NetManagerLuaInst:registerListenner(DefineProto.PROTO_SOCIATY_WAR_POSITION_UPDATE,self)
end

function StepTwoController:unregisterListenner()
    _G.NetManagerLuaInst:unregisterListenner(DefineProto.PROTO_SOCIATY_WAR_REGION_DATA,self)
    _G.NetManagerLuaInst:unregisterListenner(DefineProto.PROTO_SOCIATY_WAR_WALK_DATA,self)
    _G.NetManagerLuaInst:unregisterListenner(DefineProto.PROTO_SOCIATY_WAR_WALK_DATA_BROADCAST,self)
	_G.NetManagerLuaInst:unregisterListenner(DefineProto.PROTO_SOCIATY_WAR_EXIT_BROADCAST,self)
	_G.NetManagerLuaInst:unregisterListenner(DefineProto.PROTO_SOCIATY_WAR_POSITION_DATA,self)
	_G.NetManagerLuaInst:unregisterListenner(DefineProto.PROTO_SOCIATY_WAR_DROP_DATA,self)
    _G.NetManagerLuaInst:unregisterListenner(DefineProto.PROTO_SOCIATY_WAR_ROLE_UPDATE,self)
    _G.NetManagerLuaInst:unregisterListenner(DefineProto.PROTO_SOCIATY_WAR_POSITION_UPDATE,self)
end

--tileLayer
function StepTwoController:getTileLayer()
    require "game.tilemap.steptwo.TileMapLayer"
    self._tileMap = self._tileMap or TileMapLayer:create()
    return self._tileMap
end

function StepTwoController:closeTileLayer()
    if self._tileMap then
        self._tileMap = nil
    end
end

---send
--发送坐标
function StepTwoController:sendNextPos(pos,type)
    local _strMsg = mc.packetData:createWritePacket(DefineProto.PROTO_SOCIATY_WAR_WALK)
    _strMsg:writeShort(pos.x)
    _strMsg:writeShort(pos.y)
    _strMsg:writeByte(type)
    mc.NetMannager:getInstance():sendMsg(_strMsg)
    print("~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~send: "..DefineProto.PROTO_SOCIATY_WAR_WALK .." posX:"..pos.x.." posY:"..pos.y.." type:"..type)
end

--进入仙域
function StepTwoController:register_inScene()
    local _strMsg = mc.packetData:createWritePacket(DefineProto.PROTO_SOCIATY_WAR_REGION_REQ)
    mc.NetMannager:getInstance():sendMsg(_strMsg)
    print("~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~send: "..DefineProto.PROTO_SOCIATY_WAR_REGION_REQ)
end

--退出仙域
function StepTwoController:register_outScene()
    local _strMsg = mc.packetData:createWritePacket(DefineProto.PROTO_SOCIATY_WAR_EXIT)
    mc.NetMannager:getInstance():sendMsg(_strMsg)
    print("~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~send: "..DefineProto.PROTO_SOCIATY_WAR_EXIT)
end

--ready进入场景加载完成
function StepTwoController:register_readyScene()
    local _strMsg = mc.packetData:createWritePacket(DefineProto.PROTO_SOCIATY_WAR_CELL_ENTER_LOAD_OK)
    mc.NetMannager:getInstance():sendMsg(_strMsg)
    print("~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~send: "..DefineProto.PROTO_SOCIATY_WAR_CELL_ENTER_LOAD_OK)
end


---struct
--玩家数据 12010
function StepTwoController:structPerson(msg)
    local data = {} 
    data.uid = msg:readUint()
    data.name = msg:readString()
    data.pro = msg:readUbyte()
    data.lv = msg:readUshort()
    data.power = msg:readUint()
    data.isWar = msg:readUbyte()
    data.isFind = msg:readUbyte()
    data.invincible = msg:readUint()
    data.maxHp = msg:readUint()
    data.curHp = msg:readUint()
    data.posX = msg:readUshort()
    data.posY = msg:readUshort()
    if data.uid == _G.RoleData.Uid then
        zzm.StepTwoModel:initMyData(data)
        return false
    end
    return data
end

--行走数据
function StepTwoController:structWall(msg)
    local data = {}
    data.uid = msg:readUint()
    data.posX = msg:readUshort()
    data.posY = msg:readUshort()
    return data
end

--掉落物品数据
function StepTwoController:structDrop(msg)
    local data = {}
    data.posX = msg:readUshort()
    data.posY = msg:readUshort()
    local goodsLen = msg:readUshort()
    data.goods = {}
    for j=1,goodsLen do
        data.goods[j] = {}
        data.goods[j].type = msg:readUbyte() 
        data.goods[j].value = msg:readUint()
        data.goods[j].num = msg:readUint()
    end
    return data
end

--地图cd数据
function StepTwoController:structMapCD(msg)
    local data = {}
    data.posX = msg:readUshort()
    data.posY = msg:readUshort()
    data.endTimer = msg:readUint()
    return data
end

---deal
function StepTwoController:dealMsg(msg)
    local cmd = msg:getCmd()

    if cmd == DefineProto.PROTO_SOCIATY_WAR_WALK_DATA then --行走数据(12042) 
        local data = self:structWall(msg)
        zzm.StepTwoModel:updatePlayerData(data)
        
    elseif cmd == DefineProto.PROTO_SOCIATY_WAR_REGION_DATA then --区域玩家数据(12022)
        local len = msg:readUshort()
        for i=1,len do
            local data = self:structPerson(msg)
            if data then
                zzm.StepTwoModel:initPlayerData(data)
            end
        end
        self._haveData = true
--        self:showLayer()

    elseif cmd == DefineProto.PROTO_SOCIATY_WAR_POSITION_DATA then --探索CD（12024）
        local type = msg:readUbyte()
        local len = msg:readUshort()
        for i=1,len do
            if type == 1 then --初始
                local data = self:structMapCD(msg)
                if data.posX then
                    zzm.StepTwoModel:initCDTimer(data)
                end
            elseif type == 2 then --新增 
                local data = self:structMapCD(msg)
                if data.posX then
                    zzm.StepTwoModel:addCDTimer(data)
                end
            end
        end
        
    elseif cmd == DefineProto.PROTO_SOCIATY_WAR_WALK_DATA_BROADCAST then --新增视野内玩家（12030）
        local data = self:structPerson(msg)
        if data then
            zzm.StepTwoModel:addPlayerData(data)
        end
		
	elseif cmd == DefineProto.PROTO_SOCIATY_WAR_EXIT_BROADCAST then --12072(退出仙域)
		local uid = msg:readUint()
		zzm.StepTwoModel:delPlayerData(uid)
		
	elseif cmd == DefineProto.PROTO_SOCIATY_WAR_DROP_DATA then --12130(初始地图掉落资源)
		local type = msg:readUbyte()
		if type == 1 then --初始
		    local len = msg:readUshort()
	        for i=1, len do
                local data = self:structDrop(msg)
                zzm.StepTwoModel:initArrResource(data)
	        end
		elseif type == 2 then --新增
            local len = msg:readUshort()
            for i=1, len do
                local data = self:structDrop(msg)
                zzm.StepTwoModel:addArrResource(data)
            end
		end
		
	elseif cmd == DefineProto.PROTO_SOCIATY_WAR_ROLE_UPDATE then --玩家状态变化通知(12026)
	    local data = {}
	    data.uid = msg:readUint()
	    data.type = msg:readUbyte()
	    data.value = msg:readUint()
	    zzm.StepTwoModel:updateSomeState(data)

    elseif cmd == DefineProto.PROTO_SOCIATY_WAR_POSITION_UPDATE then --坐标点状态变化通知(12028)
	    local data = {}
	    data.posX = msg:readUshort()
	    data.posY = msg:readUshort()
	    data.type = msg:readUbyte()
        data.endTimer = msg:readUint()
	    zzm.StepTwoModel:addSomeState(data)
	    
    end
end

return StepTwoController