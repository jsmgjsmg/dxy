
local GuideController = GuideController or class("GuideController")

function GuideController:ctor()
    self.m_view = nil
    self._model = nil
    self.m_newFunction = {}
    self._isRunning = false
    self._nextGuideMask = false
    self.findRetNode = {}
    self:initController()
    self:registerListenner()
end 

function GuideController:initController()
    self._model = zzm.LoginModel
--    dxyDispatcher_addEventListener("sghsuakhfnuksfsukfvhusakjfhui",self,self.checkNewFunction)
    --dxyDispatcher_removeEventListener(dxyEventType.EquipStrengthen_SwallowBtn,self,self.swallowBtn)
    print("GuideController initController")
end

function GuideController:getLayer()
    if self.m_view == nil then
        require("game.announcement.AnnouncementLayer")
        self.m_view = AnnouncementLayer.create()
    end
    return self.m_view
end

function GuideController:showLayer()
    local scene = SceneManager:getCurrentScene()
    scene:addChild(self:getLayer())
end

function GuideController:closeLayer()
    if self.m_view then
        self.m_view:removeFromParent()
        self.m_view = nil
    end
end

--新手引导入口
function GuideController:checkNewGuide()
    --print(" checkNewGuide")
    if self._isRunning then
        --print("is Running New Function")
        return false
    end
    if zzm.GuideModel:IsStartGuide() == false then
        return false
    end
    self:showGuideLayer()
    return true
end

--打开新手引导
function GuideController:showGuideLayer()
    if self.m_GuideLayer == nil then
        require("game.guide.view.GuideMainLayer")
        self.m_GuideLayer = GuideMainLayer.create()
        self.m_GuideLayer:retain()
    end
    self._isRunning = true
    print("display Guide Layer")
    self.m_GuideLayer:update()
    local scene = SceneManager:getCurrentScene()
    scene:addChild(self.m_GuideLayer)
end


--根据path查找对象
function GuideController:findObjectInScene(path)
    local scene = SceneManager:getCurrentScene()
    local nameList = dxyStringSplit(path, "/")
    return self:findObjectByPath(scene, nameList)
end

function GuideController:findObjectByPath(node, path)
    for key, var in ipairs(path) do
    	print(key.." ---->"..var)
    end
    local ret = {}
    self.findRetNode = {}
    self:find(node, path[1])
    print("find ".. path[1] .." Object count: " .. #self.findRetNode)
    if #path == 1 then
        return self.findRetNode[1]
    end
    return self:findChildByPath(self.findRetNode, path)
end


function GuideController:findChildByPath(ret, path)
    for key = 1, #ret do
        local node = ret[key]
        local node1 = nil
        for index=2, #path do
            if node ~= nil then
                node1 = node:getChildByName(path[index])
            else
                break
            end
            
            if node1 ~= nil and index == #path then
                return node1
            end
            node = node1
            node1 = nil
        end
    end
    return nil
end


function GuideController:find(node, name)
    local _listNode = node:getChildren() 
    for key, parent in ipairs(_listNode) do
        --print(key .."NodeName: " .. parent:getName())
        local child = parent:getChildByName(name)
        if child ~= nil then
            table.insert(self.findRetNode,#self.findRetNode+1,child)
        end
        self:find(parent, name)
    end
end

-----------------------------------------------------------------
--openNewFunction 
--新功能开启的注册
function GuideController:registerFuncObj(_type, _obj, params)
    if self.m_funcObj == nil then
        self.m_funcObj = {}
    end
    if params ~= 1 then
    	params = 2
    end
    self:setFunction(_obj, params, false)
    self.m_funcObj[_type] = {_obj, params}
end

function GuideController:getFuncObj(_funcId)
    if self.m_funcObj == nil then
        self.m_funcObj = {}
    end
    local data = zzm.GuideModel:getFunctionTipsById(_funcId)
    if data then
        return self.m_funcObj[data.ButtonName][1]
    end
    return nil
end

function GuideController:getFuncParam(_funcId)
    if self.m_funcObj == nil then
        self.m_funcObj = {}
    end
    local data = zzm.GuideModel:getFunctionTipsById(_funcId)
    if data then
        return self.m_funcObj[data.ButtonName][2]
    end
    return nil
end

function GuideController:getFuncObjByType(_type)
    return self.m_funcObj[_type][1]
end

function GuideController:insertNewFunction(funcId)
    if self.m_newFunction == nil then
    	self.m_newFunction = {}
    end
    table.insert(self.m_newFunction,#self.m_newFunction,funcId)
end

function GuideController:visableFunction()
    for index=1, #zzm.GuideModel.openFunction do
        local _funcId = zzm.GuideModel.openFunction[index]
        local index = array_findObject(zzm.GuideModel.openNewFunction,_funcId)
        if index == 0 then
            local obj = self:getFuncObj(_funcId)
            local param = self:getFuncParam(_funcId)
            self:setFunction(obj, param, true)
        end
    end
end

--打开新功能开启界面
function GuideController:showNewFunction()
    for index=1, #zzm.GuideModel.openNewFunction do
        local _funcId = zzm.GuideModel.openNewFunction[index]
        local obj = self:getFuncObj(_funcId)
        local param = self:getFuncParam(_funcId)
        self:setFunction(obj, param, true)
    end
end

--设置按钮显示或隐藏
function GuideController:setFunction(obj, _type, flag)
    if _type == 1 then
        obj:setVisible(flag)
    elseif _type ==2 and obj then
--        local name = obj:getChildByName("Sprite")
--        if name then
--            name:setVisible(flag)
--        end
    end
end

--新手入口
function GuideController:checkNewFunction() --检测新功能开启
--    local path = "btnNode/roleBtn"
--    self:findObjectInScene(path)
    self:visableFunction()
    if self._isRunning then
        return
    end
    if #zzm.GuideModel.openNewFunction == 0 then
        return
    end
    print("-------------" .. #zzm.GuideModel.openNewFunction)
    self:showNewFunctionLayer()
end

--显示新功能界面
function GuideController:showNewFunctionLayer() --打开新功能开启界面
    if self.m_NewFunctionLayer == nil then
        require("game.guide.view.NewFunctionLayer")
        self.m_NewFunctionLayer = NewFunctionLayer.create()
        self.m_NewFunctionLayer:retain()
    end
    self.m_NewFunctionLayer:updateData()
    self._isRunning = true
    local scene = SceneManager:getCurrentScene()
    scene:addChild(self.m_NewFunctionLayer)
end


function GuideController:closeNewFunctionLayer()
    if self.m_NewFunctionLayer then
        self.m_NewFunctionLayer:removeFromParent()
        self.m_NewFunctionLayer:release()
        self.m_NewFunctionLayer = nil
    end
end

-----------------------------------------------------------------
--FunctionTips 
--
--新功能的信息提示界面
function GuideController:checkFunctionTips(funcId)
    local  isOpen = zzm.GuideModel:isOpenFunctionByType(funcId)
    if isOpen == false then
        self:showFunctionTips(funcId)
    end
    return isOpen
end


function GuideController:showNextFunctionTips()
    local  data = zzm.GuideModel:getNextOpenFunction()
    if data ~= nil then
        self:showFunctionTips(data.ButtonName)
    end
end

function GuideController:showFunctionTips(funcId)
    if self.m_FunctionTipsLayer == nil then
        require("game.guide.view.FunctionTipLayer")
        self.m_FunctionTipsLayer = FunctionTipsLayer.create()
        self.m_FunctionTipsLayer:retain()
    end
    local  data = zzm.GuideModel:getFunctionTipsByType(funcId)
    self.m_FunctionTipsLayer:update(data)
    local scene = SceneManager:getCurrentScene()
    scene:addChild(self.m_FunctionTipsLayer)
end

function GuideController:closeFunctionTips()
    if self.m_FunctionTipsLayer then
        self.m_FunctionTipsLayer:removeFromParent()
        self.m_FunctionTipsLayer:release()
        self.m_FunctionTipsLayer = nil
    end
end


-----------------------------------------------------------------
--Network 
--
--initNetwork
function GuideController:registerListenner()
    _G.NetManagerLuaInst:registerListenner(NetEventType.Rec_NewFunction_Init,self)
    _G.NetManagerLuaInst:registerListenner(NetEventType.Rec_NewFunction_Add,self)
end

function GuideController:unregisterListenner()
    _G.NetManagerLuaInst:unregisterListenner(NetEventType.Rec_NewFunction_Init,self)
    _G.NetManagerLuaInst:unregisterListenner(NetEventType.Rec_NewFunction_Add,self)
end

-----------------------------------------------------------------
--Request Req_GuideGroup_Update
--
function GuideController:request_GuideID_Update(guideID)
    local msg = mc.packetData:createWritePacket(NetEventType.Req_GuideGroup_Update); --编写发送包
    msg:writeInt(zzm.GuideModel._currentOKGuideID+1)
    mc.NetMannager:getInstance():sendMsg(msg); --发送 包
end

-----------------------------------------------------------------
--Receive
function GuideController:dealMsg(msg)
    local cmdType = msg:getpacketCmdType()
    --服务器下发新手ID
    if cmdType == NetEventType.Rec_NewFunction_Init then
        local _guideId = msg:readUint()
        zzm.GuideModel:setCurrentGuideID(_guideId)
        local count = msg:readByte()
        print("Error Rec_NewFunction_Init count:"..count)
        for index=1, count do
            local funcId = msg:readUint()
            zzm.GuideModel:setOpenCopy(1, funcId)
        end
    elseif cmdType == NetEventType.Rec_NewFunction_Add then
        local count = msg:readByte()
        print("Error Rec_NewFunction_Add count:"..count)
        for index=1, count do
            local funcId = msg:readUint()
            zzm.GuideModel:setOpenCopy(2, funcId)
        end
    end   
    -- 默认返回false ，表示不中断读取下一个msg
    return false

end

return GuideController




