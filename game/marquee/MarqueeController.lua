local MarqueeController = class("MarqueeController")

function MarqueeController:ctor()
   self:registerListenner()
   self.isPlaying = true
end

function MarqueeController:startTimer()
    self._myTimer = self._myTimer or require("game.utils.MyTimer").new()
    local function tick()
        if #zzm.MarqueeModel.newsTable > 0 then
            local news = zzm.MarqueeModel.newsTable[1].News
            local type = zzm.MarqueeModel.newsTable[1].Type
            local playNum = zzm.MarqueeModel.newsTable[1].PlayNumber
            local priority = zzm.MarqueeModel.newsTable[1].Priority
            

            require("game.marquee.view.MarqueeLayer")

            if self.isPlaying == false then
            	return
            else
                self.isPlaying = false
            end
            table.remove(zzm.MarqueeModel.newsTable,1)
            self:show(news,playNum,priority)
        end
    end
    self._myTimer:start(1, tick)
end

function MarqueeController:closeTimer()
	if self._myTimer then
		self._myTimer:stop()
		self.isPlaying = true
	end
end

---initNetwork
function MarqueeController:registerListenner()
    _G.NetManagerLuaInst:registerListenner(DefineProto.PROTO_CHAT_TROTTING_HORSE_LAMP,self)
    
end

function MarqueeController:unregisterListenner()
    _G.NetManagerLuaInst:unregisterListenner(DefineProto.PROTO_CHAT_TROTTING_HORSE_LAMP,self)

end

---receive
function MarqueeController:dealMsg(msg)
    local cmd = msg:getCmd()
    if cmd == DefineProto.PROTO_CHAT_TROTTING_HORSE_LAMP then
        local type = msg:readUbyte()
        local playNum = msg:readUbyte()
        local priority = msg:readUbyte()
        local news = msg:readString()
        local time = msg:readUint()
        
        
        
        zzm.MarqueeModel:dealTable(type,playNum,priority,news,time)
        
    end   


end

function MarqueeController:show(news,playNum,priority)
    print("--------------------------------------------------------------------------------")
    require("game.marquee.view.MarqueeLayer")
    local dxyMarquee = MarqueeLayer.new()
    dxyMarquee:init(news,playNum,priority)
    SceneManager:getCurrentScene():addChild(dxyMarquee,1)
end

return MarqueeController