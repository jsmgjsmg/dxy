local SkillController = SkillController or class("SkillController")

function SkillController:ctor()
    self.m_view = nil
    self._model = nil
    self.visibleSize = cc.Director:getInstance():getVisibleSize()
    self.origin = cc.Director:getInstance():getVisibleOrigin()
    self:initController()
end 

function SkillController:initController()
    self:registerListenner()
    print("SkillController initController")
end

function SkillController:getLayer()
    if self.m_view == nil then
        require("game.skill.view.SkillMainLayer")
        self.m_view = SkillMainLayer:create()
    end
    return self.m_view
end

function SkillController:showLayer()
    local scene = SceneManager:getCurrentScene()
    UIManager:addUI(self:getLayer(), "SkillController")
    scene:addChild(self:getLayer())
    self:getLayer():setPosition(self.origin.x + self.visibleSize.width / 2,self.origin.y + self.visibleSize.height / 2)
end

function SkillController:closeLayer()
    if self.m_view then
        UIManager:closeUI("SkillController")
        self.m_view = nil
    end
end

-----------------------------------------------------------------
--Network 
--
--initNetwork
function SkillController:registerListenner()
    _G.NetManagerLuaInst:registerListenner(NetEventType.Rec_Skill_List,self)
    _G.NetManagerLuaInst:registerListenner(NetEventType.Rec_CTSkill_List,self)
end

function SkillController:unregisterListenner()
    _G.NetManagerLuaInst:unregisterListenner(NetEventType.Rec_Skill_List,self)
    _G.NetManagerLuaInst:unregisterListenner(NetEventType.Rec_CTSkill_List,self)
end


--请求获取技能列表
function SkillController:request_SkillList()
    local msg = mc.packetData:createWritePacket(NetEventType.Req_Skill_List); --编写发送包
    mc.NetMannager:getInstance():sendMsg(msg); --发送 包
end

--请求解锁技能
function SkillController:request_DeblockSkill(id)
    local msg = mc.packetData:createWritePacket(NetEventType.Req_Deblock_Skill); --编写发送包
    msg:writeInt(id)
    mc.NetMannager:getInstance():sendMsg(msg); --发送 包
end

--请求升级技能
function SkillController:request_UpgradeSkill(id)
    local msg = mc.packetData:createWritePacket(NetEventType.Req_Upgrade_Skill); --编写发送包
    msg:writeInt(id)
    mc.NetMannager:getInstance():sendMsg(msg); --发送 包
end

--请求发送技能链
function SkillController:request_CTSkillList()
    local msg = mc.packetData:createWritePacket(NetEventType.Req_CTSkill_List); --编写发送包
    mc.NetMannager:getInstance():sendMsg(msg); --发送 包
end

--请求放置技能到技能链(技能链ID,技能链位置,技能ID)
function SkillController:request_CTSkillAddSkill(chainId,idx,skill_id)
    local msg = mc.packetData:createWritePacket(NetEventType.Req_CTSkill_AddSkill); --编写发送包
    msg:writeByte(chainId)
    msg:writeByte(idx)
    msg:writeInt(skill_id)
    mc.NetMannager:getInstance():sendMsg(msg); --发送 包
end

--卸下技能(技能链ID,技能链位置)
function SkillController:request_UnloadSkill(chainId,idx)
    local msg = mc.packetData:createWritePacket(DefineProto.PROTO_SKILL_DISCHARGE_SKILL); --编写发送包
    msg:writeByte(chainId)
    msg:writeByte(idx)
    mc.NetMannager:getInstance():sendMsg(msg); --发送 包
end

--请求解锁技能链
function SkillController:request_CTSkillDeblock(chainId,idx)
    local msg = mc.packetData:createWritePacket(NetEventType.Req_CTSkill_Deblock); --编写发送包
    msg:writeByte(chainId)
    msg:writeByte(idx)
    mc.NetMannager:getInstance():sendMsg(msg); --发送 包
end

-----------------------------------------------------------------
--Receive
function SkillController:dealMsg(msg)
    local cmdType = msg:getpacketCmdType()
    if cmdType == NetEventType.Rec_Skill_List then
        local n = msg:readByte()
        for i = 1 , n do
            local list = {}
            list.id= msg:readUint()
            list.lv= msg:readUshort()
            zzm.SkillModel:setSkillList(list)
        end
        dxyDispatcher_dispatchEvent(dxyEventType.Skill_Layer,zzm.SkillModel:getSkillList())
        dxyDispatcher_dispatchEvent(dxyEventType.Skill_Info,zzm.SkillModel:getCurSkill())
        dxyDispatcher_dispatchEvent(dxyEventType.ctSkill_Info,zzm.SkillModel:getCurSkill())
        dxyDispatcher_dispatchEvent("MainScene_updateSkillTips")
        dxyDispatcher_dispatchEvent("UpdateAllSkill")
    elseif cmdType == NetEventType.Rec_CTSkill_List then
        local n = msg:readByte()
        local list = {}
        for i = 1 , n do
            local id = msg:readByte()
            list[id] = {}
            local number = msg:readByte()
            for j = 1 , number do
                list[id][j] = {}
                list[id][j].idx = msg:readByte()
                list[id][j].skill_id = msg:readUint()
                list[id][j].is_unlock = msg:readByte()
                list[id][j].skill_am_id = _G.SkillConfigId_SkillAmId[list[id][j].skill_id]
                list[id][j].lv = zzm.SkillModel:getSkillLvById(list[id][j].skill_id)
                _G.CTSkillList[id][j] = list[id][j]
                zzm.SkillModel:isUnlockCTSkillList(list[id][j],id,j)
            end
        end
        zzm.SkillModel:setCTSkillList(list)
        dxyDispatcher_dispatchEvent(dxyEventType.ctSkill_Layer,zzm.SkillModel:getCTSkillList())
    end
    -- 默认返回false ，表示不中断读取下一个msg
    return false
end

return SkillController