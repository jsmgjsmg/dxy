local VipController = VipController or class("VipController")

function VipController:ctor()
    self:registerListener()
end

function VipController:registerListener()
    _G.NetManagerLuaInst:registerListenner(NetEventType.Rec_Vip_InitState,self)
end

function VipController:unregisterListenner()
    _G.NetManagerLuaInst:unregisterListenner(NetEventType.Rec_Vip_InitState,self)
end

function VipController:dealMsg(msg)
    local cmd = msg:getCmd()
    if cmd == NetEventType.Rec_Vip_InitState then
        _G.RoleData.VipLv = msg:readUbyte()
        _G.RoleData.ALLRMB = msg:readUint()
        dxyDispatcher_dispatchEvent("RechargeLayer_updateVIP")
    end
end

return VipController