ChallengeLayer = ChallengeLayer or class("ChallengeLayer",function()
    return cc.Layer:create()
end)

function ChallengeLayer:create()
    local layer = ChallengeLayer:new()
    return layer
end

function ChallengeLayer:ctor()
    self._csb = nil

    self.countDown = 3
    self.m_timer = nil

    self:initUI()
--    self:initEvent()
    dxyExtendEvent(self)
end

function ChallengeLayer:initUI()
    self._csb = cc.CSLoader:getInstance():createNodeWithFlatBuffersFile("dxyCocosStudio/csd/ui/immortalfield/ChallengeLayer.csb")
    self:addChild(self._csb)
    
    self.visibleSize = cc.Director:getInstance():getVisibleSize()
    self.origin = cc.Director:getInstance():getVisibleOrigin()
    
    self:setPosition(self.origin.x + self.visibleSize.width / 2,self.origin.y + self.visibleSize.height / 2)

    self.txt_msg = self._csb:getChildByName("msgTxt")
    self.txt_countdown = self._csb:getChildByName("countdownTxt")
    self.btn_outfight = self._csb:getChildByName("outfightBtn")

    self.leftNode = self._csb:getChildByName("leftNode")
    self.leftName = self._csb:getChildByName("leftName")
    self.rightNode = self._csb:getChildByName("rightNode")
    self.rightName = self._csb:getChildByName("rightName")

end

function ChallengeLayer:initEvent()

    dxyDispatcher_addEventListener("ChallengeLayerClose",self,self.WhenClose)

    dxySwallowTouches(self)--拦截

    if self.btn_outfight then
        self.btn_outfight:addTouchEventListener(function(target,type)
            if type == 2 then
                print("逃离战斗")
                zzc.ImmortalFieldController:request_cancelFight()
                self:WhenClose()
            end
        end)
    end
end

function ChallengeLayer:removeEvent()
	dxyDispatcher_removeEventListener("ChallengeLayerClose",self,self.WhenClose)
end

function ChallengeLayer:loadHeroData(scene_id,is_active,herPro,herLv,herName)
    local role = zzm.CharacterModel:getCharacterData()
    local enCAT = enCharacterAttrType
    local myPro = role:getValueByType(enCAT.PRO)
    local myLv = role:getValueByType(enCAT.LV)
    local myName = role:getValueByType(enCAT.NAME)
    local data = HeroConfig:getOssatureById(myPro)
    self.myHero = mc.SkeletonDataCash:getInstance():createWithCashName(data.Ossature)
    self.myHero:setAnimation(1,"ready", true)
    self.myHero:setPosition(0,0)
    
    if is_active == 0 then    
        self.myHero:setScaleX(-1)	
        self.rightNode:addChild(self.myHero)
        self.rightName:setString("LV "..myLv.." "..myName)
        self.txt_msg:setString(herName.."对你发动了战斗!")
    else
        self.myHero:setScaleX(1)
        self.leftNode:addChild(self.myHero)
        self.leftName:setString("LV "..myLv.." "..myName)
        self.txt_msg:setString("你对"..herName.."发动了战斗!")
    end
    
    
    self.scene_id = scene_id
    self.herPro = herPro
    local herData = HeroConfig:getOssatureById(self.herPro)
    self.herHero = mc.SkeletonDataCash:getInstance():createWithCashName(herData.Ossature)
    self.herHero:setAnimation(1,"ready", true)
    self.herHero:setPosition(0,0)
    
    if is_active == 0 then   
        self.herHero:setScaleX(1)	
        self.leftNode:addChild(self.herHero)
        self.leftName:setString("LV "..herLv.." "..herName)
    else
        self.herHero:setScaleX(-1)
        self.rightNode:addChild(self.herHero)
        self.rightName:setString("LV "..herLv.." "..herName)
    end
    
    self:startTimer()
end

function ChallengeLayer:startTimer()
	self.m_timer = self.m_timer or require("game.utils.MyTimer").new()
	local function tick(dt)
        self.countDown = self.countDown - dt
        self.txt_countdown:setString(self.countDown.."秒后进入战斗")
        if self.countDown <= 0 then
            zzc.StepTwoController:getTileLayer()._mineModel:stopTimer()

            --进入战斗Loding
            require("game.loading.CombatpreloadScene")
            local scene = CombatpreloadScene:create()
            scene:initPreLoad(self.scene_id,0,{},2,self.herPro)
            SceneManager:enterScene(scene, "CombatpreloadScene")
            self:WhenClose()
        end
	end
    self.txt_countdown:setString(self.countDown.."秒后进入战斗")
	self.m_timer:start(1,tick)
end

function ChallengeLayer:WhenClose()
    if self.m_timer then
        self.m_timer:stop()
        self.m_timer = nil
    end
    self:removeFromParent()
end