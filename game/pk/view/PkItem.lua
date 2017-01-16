PkItem = PkItem or class("PkItem",function()
	return cc.Node:create()
end)

function PkItem:create()
	local node = PkItem:new()
	return node
end

function PkItem:ctor()
	self._csb = nil
	self:initUI()
	self:initEvent()
end

function PkItem:initUI()
	self._csb = cc.CSLoader:createNode("dxyCocosStudio/csd/ui/pk/pkItem.csb")
	self:addChild(self._csb)
	
	self.bg = self._csb:getChildByName("bg")
	self.btn_pk = self._csb:getChildByName("pkBtn")
	
	self.txt_ranking = self._csb:getChildByName("rankingTxt")
	self.txt_pic = self._csb:getChildByName("picBtn"):getChildByName("pic")
	self.txt_name = self._csb:getChildByName("name")
	self.txt_lv = self._csb:getChildByName("lv")
	self.txt_power = self._csb:getChildByName("power")
end

function PkItem:initEvent()
	self.btn_pk:addTouchEventListener(function(target,type)
	   if type == 2 and self.m_data then
            SoundsFunc_playSounds(SoundsType.UNIVERSAL_BTN,false)
            if self.parent.count <= 0 then
                local function callBack(target,type)
                    if type == 2 then
                        UIManager:closeUI("CustomTips")
                        SoundsFunc_playSounds(SoundsType.UNIVERSAL_BTN,false)
                        zzc.PkController:request_buyCount()
                    end
                end
                local rmb = PkConfig:getRmbByCount(self.parent.buyCount + 1)
                if not rmb then
                	dxyFloatMsg:show("已到购买上限")
                	return
                end
                local layer = CustomTips:create()
                local text = "挑战次数不足,是否花费"..rmb.."元宝购买挑战次数?"
                layer:update(text,callBack)
            	return
            end
            
            local function callBack(target,type)
            	if type == 2 then
                    SoundsFunc_playSounds(SoundsType.UNIVERSAL_BTN,false)
                    UIManager:closeUI("CustomTips")
                    zzm.TalkingDataModel:onEvent(EumEventId.PK_DEKARON_COUNT,{})        
                    zzc.LoadingController:setCopyData({copyType = DefineConst.CONST_COPY_TYPE_WAR,chapterID = self.m_data.type, startTalkID = 0, endTalkID = 0, sceneID = PkConfig:getBaseData().SceneId, param1 = self.m_data.uid})
                    zzc.PkController:closeLayer()
                    zzc.LoadingController:enterScene(SceneType.LoadingScene)
                    zzc.LoadingController:setDelegate2(
                        {target = self, 
                            func = function (data)
                                zzc.LoadingController:enterScene(SceneType.CopyScene)
                            end,
                            data = self.m_data})
            	end
            end
            local layer = CustomTips:create()
            layer:update("是否进入挑战?",callBack)
            
--	        zzm.TalkingDataModel:onEvent(EumEventId.PK_DEKARON_COUNT,{})	   	
--            zzc.LoadingController:setCopyData({copyType = DefineConst.CONST_COPY_TYPE_WAR,chapterID = self.m_data.type, startTalkID = 0, endTalkID = 0, sceneID = PkConfig:getBaseData().SceneId, param1 = self.m_data.uid})
--            zzc.PkController:closeLayer()
--            zzc.LoadingController:enterScene(SceneType.LoadingScene)
--            zzc.LoadingController:setDelegate2(
--                {target = self, 
--                    func = function (data)
--                        zzc.LoadingController:enterScene(SceneType.CopyScene)
--                    end,
--                    data = self.m_data})
	   end
	end)
end

function PkItem:getFrameSize()
	local size = self.bg:getContentSize()
	return size
end

function PkItem:setParent(parent)
	self.parent = parent
end

function PkItem:update(data)
	self.m_data = data
	
    self.txt_ranking:setString(self.m_data.ranking)
    self.txt_pic:setTexture(HeroConfig:getValueById(self.m_data.pro)["IconSquare"])
    self.txt_name:setString(self.m_data.uname)
    self.txt_lv:setString("LV."..self.m_data.lv)
    self.txt_power:setString(self.m_data.fight)
end