local ImmortalFieldController = ImmortalFieldController or class("ImmortalFieldController")


function ImmortalFieldController:ctor()
    self:registerListenner()
end

---show
function ImmortalFieldController:showLayer()
    self:request_GetUIData()
    require("game.tilemap.immortalfield.view.ImmortalMainLayer")
    local scene = SceneManager:getCurrentScene()
    self._layer = ImmortalMainLayer:create()
    scene:addChild(self._layer)
    self._layer:setPosition(0,0)
end

function ImmortalFieldController:closeLayer()
    if self._layer then
        self._layer:removeFromParent()
        self._layer = nil
    end
end

--探索
function ImmortalFieldController:enterSearchLayer()
    require "game.tilemap.immortalfield.view.SearchLayer"
    self._SearchLayer = self._SearchLayer or SearchLayer:create()
    local scene = SceneManager:getCurrentScene()
    scene:addChild(self._SearchLayer)
end
function ImmortalFieldController:closeSearchLayer()
    if self._SearchLayer then
        self._SearchLayer:removeFromParent()
        self._SearchLayer = nil
    end
end
function ImmortalFieldController:whenCloseSearchLayer()
    if self._SearchLayer then
        self._SearchLayer:whenClose()
	end
end

--物品
--仙域内
function ImmortalFieldController:enterGoodsGetLayerIn()
    require "game.tilemap.immortalfield.view.GoodsGetLayer"
    self._GoodsGetLayer = self._GoodsGetLayer or GoodsGetLayer:create()
    self._GoodsGetLayer:setBtn_get(false)
    local scene = SceneManager:getCurrentScene()
    scene:addChild(self._GoodsGetLayer)
end
--仙域外
function ImmortalFieldController:enterGoodsGetLayerOut()
    require "game.tilemap.immortalfield.view.GoodsGetLayer"
    self._GoodsGetLayer = self._GoodsGetLayer or GoodsGetLayer:create()
    self._GoodsGetLayer:setBtn_get(true)
    local scene = SceneManager:getCurrentScene()
    scene:addChild(self._GoodsGetLayer)
end
function ImmortalFieldController:exitGoodsGetLayer()
    if self._GoodsGetLayer then
        self._GoodsGetLayer:removeFromParent()
        self._GoodsGetLayer = nil
    end
end

function ImmortalFieldController:request_GetUIData()--请求仙域争霸界面数据
    local msg = mc.packetData:createWritePacket(DefineProto.PROTO_SOCIATY_WAR_REQUEST_DATA); --编写发送包
    --    msg:writeByte(reawerdType)
    mc.NetMannager:getInstance():sendMsg(msg); --发送 包
    print("~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~send: "..DefineProto.PROTO_SOCIATY_WAR_REQUEST_DATA)
end

function ImmortalFieldController:request_GetSearchUIData(gid)--请求探索界面数据
    local msg = mc.packetData:createWritePacket(DefineProto.PROTO_SOCIATY_WAR_CELL_DATA_REQ); --编写发送包
    msg:writeInt(gid)
    mc.NetMannager:getInstance():sendMsg(msg); --发送 包
    print("~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~send: "..DefineProto.PROTO_SOCIATY_WAR_CELL_DATA_REQ)
end

function ImmortalFieldController:request_Search(gid)--请求探索
    local msg = mc.packetData:createWritePacket(DefineProto.PROTO_SOCIATY_WAR_CELL_WAR); --编写发送包
    msg:writeInt(gid)
    mc.NetMannager:getInstance():sendMsg(msg); --发送 包
    print("~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~send: "..DefineProto.PROTO_SOCIATY_WAR_CELL_WAR)
end

function ImmortalFieldController:request_GoodsData()--请求掉落资源背包数据
    local msg = mc.packetData:createWritePacket(12090); --编写发送包
    --    msg:writeInt(gid)
    mc.NetMannager:getInstance():sendMsg(msg); --发送 包
    print("~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~send: "..12090)
end

function ImmortalFieldController:request_GoodsGet()--领取物品
    local msg = mc.packetData:createWritePacket(12096); --编写发送包
    --    msg:writeInt(gid)
    mc.NetMannager:getInstance():sendMsg(msg); --发送 包
    print("~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~send: "..12096)
end

function ImmortalFieldController:request_getSearchGoods(gid)--领取探索物品
    local msg = mc.packetData:createWritePacket(12120); --编写发送包
    msg:writeInt(gid)
    mc.NetMannager:getInstance():sendMsg(msg); --发送 包
    print("~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~send: "..12120)
end

function ImmortalFieldController:request_cancelFight()  --逃离战斗 
    local msg = mc.packetData:createWritePacket(12134); --编写发送包
    mc.NetMannager:getInstance():sendMsg(msg); --发送 包
    print("~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~send: "..12134)
end
-----------------------------------------------------------------
--Network
--
--initNetwork
function ImmortalFieldController:registerListenner()
    _G.NetManagerLuaInst:registerListenner(DefineProto.PROTO_SOCIATY_WAR_BASE_DATA,self)
    _G.NetManagerLuaInst:registerListenner(DefineProto.PROTO_SOCIATY_WAR_CELL_DATA,self)
    _G.NetManagerLuaInst:registerListenner(12092,self)
    _G.NetManagerLuaInst:registerListenner(12094,self)
    _G.NetManagerLuaInst:registerListenner(12086,self)
    _G.NetManagerLuaInst:registerListenner(12122,self)
    _G.NetManagerLuaInst:registerListenner(12136,self)
    _G.NetManagerLuaInst:registerListenner(12067,self)
end

function ImmortalFieldController:unregisterListenner()
    _G.NetManagerLuaInst:unregisterListenner(DefineProto.PROTO_SOCIATY_WAR_BASE_DATA,self)
    _G.NetManagerLuaInst:unregisterListenner(DefineProto.PROTO_SOCIATY_WAR_CELL_DATA,self)
    _G.NetManagerLuaInst:unregisterListenner(12092,self)
    _G.NetManagerLuaInst:unregisterListenner(12094,self)
    _G.NetManagerLuaInst:unregisterListenner(12086,self)
    _G.NetManagerLuaInst:unregisterListenner(12122,self)
    _G.NetManagerLuaInst:unregisterListenner(12136,self)
    _G.NetManagerLuaInst:unregisterListenner(12067,self)
end

-----------------------------------------------------------------
--Receive
function ImmortalFieldController:dealMsg(msg)
    local cmdType = msg:getpacketCmdType()
    if cmdType == DefineProto.PROTO_SOCIATY_WAR_BASE_DATA then
        local data = {}
        data.name = msg:readString()
        data.manorId = msg:readUshort()
        data.kill = msg:readUint()
        data.power = msg:readUint()
        zzm.ImmortalFieldModel:addGroupData(data)

        local rankCount = msg:readUshort()
        local rankData = {}
        for i = 1, rankCount do
            rankData[i].Id = msg:readUint()
            rankData[i].name = msg:readString()
            rankData[i].power = msg:readUint()
        end
        zzm.ImmortalFieldModel:addRankData(rankData)

        local newsCount = msg:readUshort()
        local newsData = {}
        local count_arg = nil
        for i = 1, newsCount do
            newsData[i].msg_id = msg:readUint()
            count_arg = msg:readUint()
            for j=1, count_arg do
                newsData[i].type = msg:readUbyte()
                if newsData[i].type == 1 then
                    newsData[i].arg = msg:readUint()
                elseif newsData[i].type == 2 then
                    newsData[i].arg = msg:readUstring()
                end
            end
        end
        zzm.ImmortalFieldModel:addNewsData(newsData)

        dxyDispatcher_dispatchEvent("tilemapUpdateValue")

        --        local goodsCount = msg:readUshort()
        --        local goodsData = {}
        --        for i = 1, goodsCount do
        --            goodsData[i].id = msg:readUint()
        --            goodsData[i].type = GoodsConfigProvider:findGoodsById(goodsData.id).Type
        --            goodsData[i].count = msg:readUshort()
        --        end
        --        zzm.ImmortalFieldModel:addGoodsData(goodsData)


        --    elseif cmdType == 12052 then
        --        local news = msg:readUint()
        --        zzm.ImmortalFieldModel:addNews(news)
    elseif cmdType == DefineProto.PROTO_SOCIATY_WAR_CELL_DATA then
        local len = msg:readUshort()
        local data = {}
        for i = 1, len do
            data[i] = {}
            data[i].Type = msg:readByte()
            data[i].Num = msg:readUint()
        end

        zzm.ImmortalFieldModel.isBox = msg:readByte()
        zzm.ImmortalFieldModel:addSearchData(data)
        local sceneData = {}
        sceneData.bossId = msg:readUint()
        sceneData.MonsterCount = msg:readUshort()
        sceneData.MonsterId = {}
        for i = 1, sceneData.MonsterCount do
            sceneData.MonsterId[i] = msg:readUint()
        end

        sceneData.sceneId = msg:readUint()
        zzm.ImmortalFieldModel:addSceneData(sceneData)

---change
        zzc.StepTwoController:getTileLayer()._mineModel:newFindEffect()
        SwallowAllTouches:show()
        self.find_timer = require ("game.utils.MyTimer").new()
        local endTimer = SociatyWarTiledMapConfig:getFindExpendTime(CMap:getGlobalGID(cc.p(zzm.StepTwoModel:getMyData().posX,zzm.StepTwoModel:getMyData().posY))).ExpendTime or 4
        local function tick()
            endTimer = endTimer - 1
            if endTimer <= 0 then
                SwallowAllTouches:close()
                self:enterSearchLayer()
                zzc.StepTwoController:getTileLayer()._mineModel:stopFinding()
                self.find_timer:stop()
            end
        end
        self.find_timer:start(1,tick)
        
    elseif cmdType == 12092 then
        local resNum = msg:readUshort()
        local data = {}
        for i = 1, resNum do
            data[i] = {}
            data[i].type = msg:readByte()
            data[i].count = msg:readUint()

        end
        --        zzm.ImmortalFieldModel:insertGoods(data)

        local count = msg:readUshort()
        print( " -----------1 " .. count)
        local goods = {}
        for index=1, count do
            goods[index] = {}
            goods[index].id = msg:readUint()
            goods[index].count = msg:readUshort()
            goods[index].type = 6


        end
        for key, var in ipairs(data) do
            table.insert(goods,var)
        end
        
        for key, var in ipairs(zzm.ImmortalFieldModel.goodsData) do
            cn:ShowGetSearchGoods(var)
        end
        zzm.ImmortalFieldModel.isShow = false
        zzm.ImmortalFieldModel:insertGoods(goods)
        dxyDispatcher_dispatchEvent("GoodsGetLayer_updateItem")
    elseif cmdType == 12094 then
        local resNum = msg:readUshort()
        local data = {}
        for i = 1, resNum do
            data[i] = {}
            data[i].type = msg:readByte()
            data[i].count = msg:readUint()
            zzm.ImmortalFieldModel:addGoods(data[i])
--            cn:ShowSearchGoods(data[i])
        end
        zzm.ImmortalFieldModel.fightRes = data
        --        zzm.ImmortalFieldModel:insertGoods(data)

        local count = msg:readUshort()
        print( " -----------1 " .. count)
        local goods = {}
        for index=1, count do
            goods[index] = {}
            goods[index].id = msg:readUint()
            goods[index].count = msg:readUshort()
            goods[index].type = 6
            zzm.ImmortalFieldModel:addGoods(goods[index])
--            cn:ShowSearchGoods(goods[index])
        end
        zzm.ImmortalFieldModel.fightGoods = goods

        zzm.ImmortalFieldModel:showTips()
        --        for key, var in ipairs(data) do
        --            table.insert(goods,var)
        --        end
        --        zzm.ImmortalFieldModel:addGoods(goods)
    elseif cmdType == 12086 then
        ---受到入侵
        dxyDispatcher_dispatchEvent("ImmortalMainLayer_stopAllTimer")
    
        local scene_id = msg:readUint()
        local uname = msg:readString()
        local lv = msg:readUshort()
        local pro = msg:readUbyte()
        local is_active = msg:readUbyte()   --0被动  1主动
        local pos_x = msg:readUshort()
        local pos_y = msg:readUshort()

        require("game.tilemap.immortalfield.view.ChallengeLayer")
        local scene = SceneManager:getCurrentScene()
        local layer = ChallengeLayer:create()
        layer:loadHeroData(scene_id,is_active,pro,lv,uname)
        scene:addChild(layer)

--        zzc.StepTwoController:getTileLayer()._mineModel:stopTimer()
--
--        --进入战斗Loding
--        require("game.loading.CombatpreloadScene")
--        local scene = CombatpreloadScene:create()
--        scene:initPreLoad(scene_id,0,{},2,pro)
--        SceneManager:enterScene(scene, "CombatpreloadScene")
    elseif cmdType == 12122 then
        dxyDispatcher_dispatchEvent("SearchLayer_OKGet")
    elseif cmdType == 12136 then
        print("收到对手逃离战斗")
		dxyFloatMsg:show("对手已逃离战斗")
        dxyDispatcher_dispatchEvent("ChallengeLayerClose")
    elseif cmdType == 12067 then    --接收是否可以战斗的布尔值
        local is_war = msg:readUbyte()
        if is_war then
--            zzc.ImmortalFieldController:whenCloseSearchLayer()
            zzc.StepTwoController:getTileLayer():whenClose()
--            zzc.ImmortalFieldController:closeSearchLayer()
            require("game.loading.CombatpreloadScene")
            local scene = CombatpreloadScene:create()
            scene:initPreLoad(zzm.ImmortalFieldModel.sceneData.sceneId,zzm.ImmortalFieldModel.sceneData.bossId,zzm.ImmortalFieldModel.sceneData.MonsterId,1,0)
            SceneManager:enterScene(scene, "CombatpreloadScene")
        end
    end
end


return ImmortalFieldController