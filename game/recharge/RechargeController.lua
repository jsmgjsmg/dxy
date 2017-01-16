local RechargeController = RechargeController or class("RechargeController")

function RechargeController:ctor()
   self:registerListener() 
end

function RechargeController:registerListener()
    _G.NetManagerLuaInst:registerListenner(NetEventType.Rec_Rec_InitState,self)
    _G.NetManagerLuaInst:registerListenner(NetEventType.Rec_Rec_InitRecList,self)
    _G.NetManagerLuaInst:registerListenner(NetEventType.Rec_Rec_Recharge,self)
    _G.NetManagerLuaInst:registerListenner(NetEventType.Rec_Rec_GetFirstPay,self)
end

function RechargeController:unregisterListenner()
    _G.NetManagerLuaInst:unregisterListenner(NetEventType.Rec_Rec_InitState,self)
    _G.NetManagerLuaInst:unregisterListenner(NetEventType.Rec_Rec_InitRecList,self)
    _G.NetManagerLuaInst:unregisterListenner(NetEventType.Rec_Rec_Recharge,self)
    _G.NetManagerLuaInst:unregisterListenner(NetEventType.Rec_Rec_GetFirstPay,self)
end

function RechargeController:showLayer()
    require "game.recharge.view.RechargeLayer"
    local scene = SceneManager:getCurrentScene()
    scene:addChild(RechargeLayer:create())
end

function RechargeController:showNode()
    require "game.recharge.view.FirstRecharge"
    local scene = SceneManager:getCurrentScene()
    scene:addChild(FirstRecharge:create())
end

---发送消息------------------------------------------------------------
--普通item
function RechargeController:Recharge(id)
    local _strMsg = mc.packetData:createWritePacket(NetEventType.Req_Rec_Recharge)
    _strMsg:writeInt(id)
    mc.NetMannager:getInstance():sendMsg(_strMsg)
    print("~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~send: "..NetEventType.Req_Rec_Recharge.." id:"..id)
end

--月卡
function RechargeController:MonthCard(id)
    local _strMsg = mc.packetData:createWritePacket(NetEventType.Req_Rec_MonthCard)
    _strMsg:writeInt(id)
    mc.NetMannager:getInstance():sendMsg(_strMsg)
    print("~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~send: "..NetEventType.Req_Rec_MonthCard.." id:"..id)
end

--领取首冲奖励
function RechargeController:GetMonthCard()
    local _strMsg = mc.packetData:createWritePacket(NetEventType.Req_Rec_GetFirstPay)
    mc.NetMannager:getInstance():sendMsg(_strMsg)
    print("~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~send: "..NetEventType.Req_Rec_GetFirstPay)
end

---接收消息------------------------------------------------------------
function RechargeController:dealMsg(msg)
    local cmd = msg:getCmd()
    if cmd == NetEventType.Rec_Rec_InitState then --6001(初始化VIP)
        _G.RoleData.VipLv = msg:readUbyte()
        _G.RoleData.ALLRMB = msg:readUint()
        dxyDispatcher_dispatchEvent("RechargeLayer_updateVIP")
        
    elseif cmd == NetEventType.Rec_Rec_InitRecList then --6004(初始化已充值)
        local data = {}
        zzm.RechargeModel._isFirst = msg:readUbyte()
        local len = msg:readUbyte()
        for i = 1 , len do
            data["Id"] = msg:readUint()
            data["Num"] = msg:readUshort()
            zzm.RechargeModel:initRecList(data) 
        end 
    
    elseif cmd == NetEventType.Rec_Rec_Recharge then --6009(购买)
        local data = {}
        data["Id"] = msg:readUint()
        data["Num"] = msg:readUshort()
        zzm.RechargeModel:changeRecList(data)
    
    elseif cmd == NetEventType.Rec_Rec_GetFirstPay then --6018(领取首冲奖励)
        zzm.RechargeModel._isFirst = msg:readUbyte()
        if zzm.RechargeModel._isFirst == 2 then
            zzm.RechargeModel:showFirstPayInt()
        end
        dxyDispatcher_dispatchEvent("MainScene_updateRecharge")
    end
end

return RechargeController