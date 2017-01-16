
local CopySelectController = CopySelectController or class("CopySelectController")

function CopySelectController:ctor()
    self.m_view = nil
    self.announcementItem = nil
    self._model = nil
    self:initController()
    self:registerListenner()
end 

function CopySelectController:initController()
    self._model = zzm.CopySelectModel
    require("game.chapter.view.CopySelectLayer")
    require("game.chapter.view.CopyDetails")
    
    print("CopySelectController initController")
end

-- 打开副本信息界面
function CopySelectController:showCopyDetails(data)
    if data == nil then
	   dxyFloatMsg:show("对不起数据异常！！！")
	   return
    end
    --if self.m_copyDetails == nil then
        self.m_copyDetails = CopyDetails.create()
        _G.StarAppraiseID = data.config.StarId
        --self.m_copyDetails:retain()
    --end
    self.m_copyDetails:update(data)
    local scene = SceneManager:getCurrentScene()
    scene:addChild(self.m_copyDetails)
end

-- 关闭副本信息界面
function CopySelectController:closeCopyDetails()
    if self.m_copyDetails ~= nil then
        --local scene = SceneManager:getCurrentScene()
        --scene:removeChild(self.m_copyDetails)
        --self.m_copyDetails:release()
        self.m_copyDetails:removeFromParent()
        self.m_copyDetails = nil
    end
end

-- 打开关卡选择界面
function CopySelectController:showLayer()
    if self.m_view == nil then
        self.m_view = CopySelectLayer.create()
        --self.m_view:retain()
    end
    local scene = SceneManager:getCurrentScene()
    scene:addChild(self.m_view)
end
    
-- 关闭关卡选择界面
function CopySelectController:closeLayer()
    if self.m_view ~= nil then
--        local scene = SceneManager:getCurrentScene()
--        scene:removeChild(self.m_view)
        self.m_view:removeFromParent()
        self.m_view = nil
    end
end

function CopySelectController:setDelegate(target, func, data)
    self.delegate.target = target
    self.delegate.func = func
    self.delegate.data = data
end

function CopySelectController:setDelegate2(delegate)
    self.delegate = delegate
end

--打开固定关卡
function CopySelectController:AutoOpenCopyPage(copyId)
    self:showLayer()
    local config = SceneConfigProvider:getCopyById(copyId)
    local star = zzm.CopySelectModel:getCopyData(copyId)
    local m_data = star
    m_data.config = config
    self:showCopyDetails(m_data)
    dxyDispatcher_dispatchEvent("CopySelectLayer_scrollToPage",config.ChapterId)
end

--打开最新副本位置
function CopySelectController:OpenCopyPage()
    self:showLayer()
    local data = zzm.CopySelectModel:getLastCopyData()
    local config = SceneConfigProvider:getCopyById(data.id)
    dxyDispatcher_dispatchEvent("CopySelectLayer_scrollToPage",config.ChapterId)
end

-----------------------------------------------------------------
--Network 
--
--initNetwork
function CopySelectController:registerListenner()
    _G.NetManagerLuaInst:registerListenner(NetEventType.Rec_Copy_OpenList,self)
    _G.NetManagerLuaInst:registerListenner(NetEventType.Rec_Copy_ResultReward,self)
    _G.NetManagerLuaInst:registerListenner(NetEventType.Rec_Copy_BoxReward,self)
    _G.NetManagerLuaInst:registerListenner(NetEventType.Rec_Copy_BoxRewardItem,self)

end

function CopySelectController:unregisterListenner()
    _G.NetManagerLuaInst:unregisterListenner(NetEventType.Rec_Copy_OpenList,self)
    _G.NetManagerLuaInst:unregisterListenner(NetEventType.Rec_Copy_ResultReward,self)
    _G.NetManagerLuaInst:unregisterListenner(NetEventType.Rec_Copy_BoxReward,self)
    _G.NetManagerLuaInst:unregisterListenner(NetEventType.Rec_Copy_BoxRewardItem,self)
end

-----------------------------------------------------------------
--Request
-- 请求背包 Request Type Req_Role_Backpack  Receive Type Rec_Backpack_Back
function CopySelectController:request_CopyList()
    print("request_CopyList  ")
    local msg = mc.packetData:createWritePacket(NetEventType.Req_Copy_OpenList); --编写发送包
    mc.NetMannager:getInstance():sendMsg(msg); --发送 包
end


function CopySelectController:request_EnterCopyScene(copyType, chapterId, copyId, param1)
    print("request_EnterCopyScene  chapterId: ".. chapterId .. " copyId :" .. copyId)
    local msg = mc.packetData:createWritePacket(NetEventType.Req_Copy_EnterCopy); --编写发送包
    msg:writeByte(copyType)
    msg:writeInt(chapterId)
    msg:writeInt(copyId)
    msg:writeInt(param1)
    mc.NetMannager:getInstance():sendMsg(msg); --发送 包
end

function CopySelectController:request_GetBoxReward(chaperid, boxid)
    print("request_GetBoxReward  ")
    local msg = mc.packetData:createWritePacket(NetEventType.Req_Copy_GetBoxReward); --编写发送包
    msg:writeByte(chaperid)
    msg:writeByte(boxid)
    mc.NetMannager:getInstance():sendMsg(msg); --发送 包
end



-----------------------------------------------------------------
--Receive
function CopySelectController:dealMsg(msg)
    local cmdType = msg:getpacketCmdType()
    if cmdType == NetEventType.Rec_Copy_OpenList then
        local count = msg:readUshort()
        local copyId = nil
        print("Rec_Copy_OpenList count:"..count)
        for index=1, count do
            local id = msg:readUint()
            local start = msg:readByte()
            print("--------- Copy_Open :" .. id)
            copyId = id
            zzm.CopySelectModel:insertCopyData(id, start)
            
            if index == 1 then
                local chapterId = SceneConfigProvider:getChapterByCopyId(id)
                zzm.CopySelectModel:setCurChapter(chapterId)
            end
            
        end
        
    elseif cmdType == NetEventType.Rec_Copy_BoxRewardItem then
        local data = {}
        data.chapterId = msg:readByte()
        data.boxId = msg:readByte()
        data.state = msg:readByte()
        zzm.CopySelectModel:insertBoxData(data)
    elseif cmdType == NetEventType.Rec_Copy_BoxReward then
        local count = msg:readUshort()
        print("Rec_Copy_BoxReward count:"..count)
        for index=1, count do
            local data = {}
            data.chapterId = msg:readByte()
            data.boxId = msg:readByte()
            data.state = msg:readByte()
            zzm.CopySelectModel:insertBoxData(data)
        end
    elseif cmdType == NetEventType.Rec_Copy_ResultReward then
        local type = msg:readByte()
        if type == 1 then
            zzm.GuideModel._newOpenCopy = true
        end
        --接收副本结果返回
    end   
    -- 默认返回false ，表示不中断读取下一个msg
    return false

end



return CopySelectController

