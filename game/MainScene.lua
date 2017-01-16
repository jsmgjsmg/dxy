
require("game.utils.MyClippingNode")

LayerMoveFactors =
    {
        MID_MOVE = 0.8,
        FAR_MOVE = 0.6,
        BG_MOVE = 0.4,
    }

Quality_Color = {
    cc.c3b(255,255,255),
    cc.c3b(0,255,0),
    cc.c3b(0,168,255),
    cc.c3b(252,10,255),
    cc.c3b(255,252,0),
}

MainScene = MainScene or class("MainScene",function()
    return cc.Scene:create()
end)

MainScene._isPreLoad = true

MainScene._PreLoadPngList = {}

function MainScene:create()
    local scene = MainScene:new()
    return scene
end

function MainScene:ctor()

    mc.ResMgr:getInstance():releasedALLRes()
    --图片放入缓存
--    cc.SpriteFrameCache:getInstance():addSpriteFrames("dxyCocosStudio/png/yuanshen/Change1.plist")
--    cc.SpriteFrameCache:getInstance():addSpriteFrames("dxyCocosStudio/png/yuanshen/Change2.plist")
--    cc.SpriteFrameCache:getInstance():addSpriteFrames("dxyCocosStudio/png/yuanshen/stone/Change.plist")
--    cc.SpriteFrameCache:getInstance():addSpriteFrames("dxyCocosStudio/png/recharge/Change1.plist")
--    cc.SpriteFrameCache:getInstance():addSpriteFrames("dxyCocosStudio/png/ranking/Change1.plist")
--    cc.SpriteFrameCache:getInstance():addSpriteFrames("dxyCocosStudio/png/fairy/Change1.plist")
--    cc.SpriteFrameCache:getInstance():addSpriteFrames("dxyCocosStudio/png/fairy/Change2.plist")
--    cc.SpriteFrameCache:getInstance():addSpriteFrames("dxyCocosStudio/png/titletxt/Change.plist")
--
--    cc.SpriteFrameCache:getInstance():addSpriteFrames("dxyCocosStudio/png/recruitMoney/ratePlist.plist")
--    cc.SpriteFrameCache:getInstance():addSpriteFrames("dxyCocosStudio/png/groupfunc/talent/Change.plist")


    --    cc.SpriteFrameCache:getInstance():addSpriteFrames("dxyCocosStudio/png/equip/BgPlist.plist")
    --    cc.SpriteFrameCache:getInstance():addSpriteFrames("dxyCocosStudio/png/mainscene/Change.plist")
    --    cc.SpriteFrameCache:getInstance():addSpriteFrames("dxyCocosStudio/png/vip/change.plist")
    --    cc.SpriteFrameCache:getInstance():addSpriteFrames("dxyCocosStudio/png/roleinfo/titleIcon/titleIconPlist.plist")
    --    cc.SpriteFrameCache:getInstance():addSpriteFrames("dxyCocosStudio/png/recruitMoney/ratePlist.plist")
    --    cc.SpriteFrameCache:getInstance():addSpriteFrames("dxyCocosStudio/png/spirit/search/searchPlist.plist")
    ------------------------------------------------------------
    ------------------------------------------------------------

    self.visibleSize = cc.Director:getInstance():getVisibleSize()
    self.origin = cc.Director:getInstance():getVisibleOrigin()
    self._main = nil

    self.txt_name = nil
    self.txt_level = nil
    self.txt_power = nil

    self.txt_copper = nil
    self.txt_ingot = nil
    self.txt_physical = nil

    self._bg = nil

    self.ScrollView = ccui.ScrollView

    self.bgLayer = nil
    self.farLayer = nil
    self.midLayer = nil
    self.closeLayer = nil

    self.btn_lingshan = ccui.Button
    self.btn_tower = ccui.Button
    self.btn_warship = ccui.Button
    self.btn_cornucopia = ccui.Button
    self.btn_fairylake = ccui.Button
    self.btn_gods = ccui.Button
    self.btn_billboard = ccui.Button
    self.btn_faction = ccui.Button
    self.btn_tianmen = ccui.Button
    self.btn_pk = ccui.Button

    self.title_lingshan = cc.Sprite
    self.title_tower = cc.Sprite
    self.title_warship = cc.Sprite
    self.title_cornucopia = cc.Sprite
    self.title_fairylake = cc.Sprite
    self.title_gods = cc.Sprite
    self.title_billboard = cc.Sprite
    self.title_faction = cc.Sprite
    self.title_pk = cc.Sprite

    self._exp = nil

    self.startPoint = {}
    self.endPoint = {}

    self._delyTime = 0

    self:init()
    dxyExtendEvent(self)

    --local targetPlatform = cc.Application:getInstance():getTargetPlatform()
    --if (cc.PLATFORM_OS_IPHONE == targetPlatform) or (cc.PLATFORM_OS_IPAD == targetPlatform) or (cc.PLATFORM_OS_MAC == targetPlatform) then
    --ccexp.AudioEngine:play2d("sound/cityBgm.mp3",true)
    --else
    --cc.SimpleAudioEngine:getInstance():playMusic("sound/cityBgm.mp3",true)
    --ccexp.AudioEngine:play2d("sound/cityBgm.mp3",true)
    --end

    --	cc.SimpleAudioEngine:getInstance():playMusic("sound/cityBgm.mp3",true)
    --    SoundsInit.new()
end

function MainScene:updateButtonTitle()
    local fun = {
        [1] = function()
            self.btn_lingshan:setTouchEnabled(zzm.GuideModel:isOpenFunctionByType(enFunctionType.LingShan))
            self.title_lingshan:setVisible(zzm.GuideModel:isOpenFunctionByType(enFunctionType.LingShan))
        end,
        [2] = function()
            self.btn_tower:setTouchEnabled(zzm.GuideModel:isOpenFunctionByType(enFunctionType.ShiLianTa))
            self.title_tower:setVisible(zzm.GuideModel:isOpenFunctionByType(enFunctionType.ShiLianTa))
        end,
        [3] = function()
            self.btn_warship:setTouchEnabled(zzm.GuideModel:isOpenFunctionByType(enFunctionType.ChuMo))
            self.title_warship:setVisible(zzm.GuideModel:isOpenFunctionByType(enFunctionType.ChuMo))
        end,
        [4] = function()
            self.btn_cornucopia:setTouchEnabled(zzm.GuideModel:isOpenFunctionByType(enFunctionType.CaiShenBaoKu))
            self.title_cornucopia:setVisible(zzm.GuideModel:isOpenFunctionByType(enFunctionType.CaiShenBaoKu))
        end,
        [5] = function()
            self.btn_fairylake:setTouchEnabled(zzm.GuideModel:isOpenFunctionByType(enFunctionType.XianNv))
            self.title_fairylake:setVisible(zzm.GuideModel:isOpenFunctionByType(enFunctionType.XianNv))
        end,
        [6] = function()
            self.btn_gods:setTouchEnabled(zzm.GuideModel:isOpenFunctionByType(enFunctionType.FengShenTai))
            self.title_gods:setVisible(zzm.GuideModel:isOpenFunctionByType(enFunctionType.FengShenTai))
        end,
        [7] = function()
            self.btn_billboard:setTouchEnabled(zzm.GuideModel:isOpenFunctionByType(enFunctionType.PaiHangBang))
            self.title_billboard:setVisible(zzm.GuideModel:isOpenFunctionByType(enFunctionType.PaiHangBang))
        end,
        [8] = function()
            self.btn_faction:setTouchEnabled(zzm.GuideModel:isOpenFunctionByType(enFunctionType.XianMen))
            self.title_faction:setVisible(zzm.GuideModel:isOpenFunctionByType(enFunctionType.XianMen))
        end,
        [9] = function()
            self.btn_pk:setTouchEnabled(zzm.GuideModel:isOpenFunctionByType(enFunctionType.JingJiChang))
            self.title_pk:setVisible(zzm.GuideModel:isOpenFunctionByType(enFunctionType.JingJiChang))
        end,
        [10] = function()
            self.btn_zudui:setTouchEnabled(zzm.GuideModel:isOpenFunctionByType(enFunctionType.ZuDui))
            self.title_zudui:setVisible(zzm.GuideModel:isOpenFunctionByType(enFunctionType.ZuDui))
        end
    }

    for index=1, #fun do
        fun[index]()
    end

end

function MainScene:removeEvent()
    dxyDispatcher_removeEventListener(dxyEventType.Character_AttrUpdate,self,self.updateValue)
    dxyDispatcher_removeEventListener("MainScene_updateRecharge",self,self.updateRecharge)
    dxyDispatcher_removeEventListener("MainScene_updateTaskTips",self,self.updateTaskTips)
    dxyDispatcher_removeEventListener("MainScene_closeAction",self,self.updateTaskTips)
    dxyDispatcher_removeEventListener("MainScene_updateChatRedIcon",self,self.updateChatIcon)
    dxyDispatcher_removeEventListener("MainScene_updateFriendRedIcon",self,self.updateFriendIcon)
    dxyDispatcher_removeEventListener("MainScene_updateRoleTips",self,self.updateRoleTips)
    dxyDispatcher_removeEventListener("MainScene_updateSkillTips",self,self.updateSkillTips)
    dxyDispatcher_removeEventListener("MainScene_updateSweepTips",self,self.updateSweepTips)
    dxyDispatcher_removeEventListener("MainScene_updateCornucopiaTips",self,self.updateCornucopiaTips)
    dxyDispatcher_removeEventListener("MainScene_updateLingshanTips",self,self.updateLingshanTips)
    dxyDispatcher_removeEventListener("MainScene_updateActivityTips",self,self.updateActivityTips)
    dxyDispatcher_removeEventListener("MainScene_updateFightEffect",self,self.updateFightEffect)
    dxyDispatcher_removeEventListener("MainScene_updateSoulTips",self,self.updateSoulTips)
    dxyDispatcher_removeEventListener("MainScene_updateLotterDrawTips",self,self.updateLotterDrawTips)
    if self._myGuideTimer then
        self._myGuideTimer:stop()
        self._myGuideTimer = nil
    end

    --    zzc.CharacterController:releaseLayer()

end

function MainScene:initEvent()
    --zzc.AnnouncementController:enterMainScene()
    zzc.MarqueeController:startTimer()
    --zzc.CharacterController:getLayer() -- move to PreLoadScene.lua

    self:updateRoleTips()
    --self:updateSkillTips()
    self:updateSweepTips()
    self:updateCornucopiaTips()
    self:updateLingshanTips()
    self:updateActivityTips()
    self:updateFightEffect()
    self:updateSoulTips()
    self:updateLotterDrawTips()
    self:createGuideMask()
--    if zzm.FriendModel.friendList[2] and zzm.FriendModel.friendList[4] then
--        if next(zzm.FriendModel.friendList[2]) ~= nil and next(zzm.FriendModel.friendList[4]) ~= nil then
--            zzm.FriendModel.isRedFriend = true
--            self:updateFriendIcon(zzm.FriendModel.isRedFriend)
--        else
--            zzm.FriendModel.isRedFriend = false
--            if zzm.FriendModel.isRecentlyRed == false then
--            	self:updateFriendIcon(false)
--            else
--                self:updateFriendIcon(true)
--            end
--        end
--    end
    
    if  zzm.FriendModel.applyRed == false and  zzm.FriendModel.recentlyRed == false and  zzm.FriendModel.giftRed == false then
        self:updateFriendIcon(false)
    else
        self:updateFriendIcon(true)
    end

---每次进入主城开启新手检测 标①
    zzc.GuideController:checkNewFunction()
    self._myGuideTimer = self._myGuideTimer or require("game.utils.MyTimer").new()
    local function tick()
        --zzc.GroupController:checkNewFunction()
        local flag = zzc.GuideController:checkNewGuide()
        --        if flag then
        --            self._myGuideTimer:stop()
        --            self._myGuideTimer = nil
        --        end
		cc.Director:getInstance():getTextureCache():removeUnusedTextures()
    end
    tick()
    self._myGuideTimer:start(0.5, tick)

    --更新按钮标题
    self:updateButtonTitle()

    --是否打开小助手
    if SceneManager.isFightLose == 2 then
        zzc.HelperController:showLayer(1)
    end

    local role = zzm.CharacterModel:getCharacterData()
    local enCAT = enCharacterAttrType
    self.txt_name:setString(role:getValueByType(enCAT.NAME))
    self.txt_level:setString(role:getValueByType(enCAT.LV))
    self.txt_power:setString(role:getValueByType(enCAT.POWER))
    if role:getValueByType(enCAT.EXPUP) ~= 0 then
        self._exp:setPercent(role:getValueByType(enCAT.EXP)/role:getValueByType(enCAT.EXPUP) * 100)
    else
        self._exp:setPercent(100)
    end
    self:setCopper(role:getValueByType(enCAT.GOLD))
    self:setIngot(role:getValueByType(enCAT.RMB))
    --    self.txt_physical:setString(role:getValueByType(enCAT.GNCOPYCN).."/"..PhysicalConfig:getBaseValue().Limit)
    self.txt_yuanli:setString(role:getValueByType(enCAT.PHYSICAL).."/"..PhysicalConfig:getBaseValue().Limit)

    self.btn_head:loadTextureNormal(HeroConfig:getValueById(role:getValueByType(enCAT.PRO))["IconHkee"])
    self.btn_head:loadTexturePressed(HeroConfig:getValueById(role:getValueByType(enCAT.PRO))["IconHkee"])
    self.btn_head:loadTextureDisabled(HeroConfig:getValueById(role:getValueByType(enCAT.PRO))["IconHkee"])

    local Pro = role:getValueByType(enCAT.PRO)
    local hero = HeroConfig:getValueById(Pro)
    self._action = mc.SkeletonDataCash:getInstance():createWithCashName(hero.MainCity)
    self._action:setAnimation(1,"ready", true)
    self._action:setAnchorPoint(0.5,0)
    --    action:setPosition(0,0)
    self._ndMainCity:addChild(self._action)

    dxyDispatcher_addEventListener(dxyEventType.Character_AttrUpdate,self,self.updateValue)
    dxyDispatcher_addEventListener("MainScene_updateRecharge",self,self.updateRecharge)
    dxyDispatcher_addEventListener("MainScene_updateTaskTips",self,self.updateTaskTips)
    dxyDispatcher_addEventListener("MainScene_closeAction",self,self.closeAction)
    dxyDispatcher_addEventListener("MainScene_updateChatRedIcon",self,self.updateChatIcon)
    dxyDispatcher_addEventListener("MainScene_updateFriendRedIcon",self,self.updateFriendIcon)
    dxyDispatcher_addEventListener("MainScene_updateRoleTips",self,self.updateRoleTips)
    dxyDispatcher_addEventListener("MainScene_updateSkillTips",self,self.updateSkillTips)
    dxyDispatcher_addEventListener("MainScene_updateSweepTips",self,self.updateSweepTips)
    dxyDispatcher_addEventListener("MainScene_updateCornucopiaTips",self,self.updateCornucopiaTips)
    dxyDispatcher_addEventListener("MainScene_updateLingshanTips",self,self.updateLingshanTips)
    dxyDispatcher_addEventListener("MainScene_updateActivityTips",self,self.updateActivityTips)
    dxyDispatcher_addEventListener("MainScene_updateFightEffect",self,self.updateFightEffect)
    dxyDispatcher_addEventListener("MainScene_updateSoulTips",self,self.updateSoulTips)
    dxyDispatcher_addEventListener("MainScene_updateLotterDrawTips",self,self.updateLotterDrawTips)
    
    --点击按钮移动不打开功能
    local startPoint = cc.p(0,0)
    local endPoint = cc.p(0,0)
    self.btn_lingshan:addTouchEventListener(function(target,type)
        if type == 0 then
            startPoint.x,startPoint.y = target:getPosition()
            startPoint = target:convertToWorldSpace(startPoint)
        elseif type == 2 then
            endPoint.x,endPoint.y = target:getPosition()
            endPoint = target:convertToWorldSpace(endPoint)
            if math.abs(math.modf(endPoint.x - startPoint.x)) > 5 then
                return
            end
            SoundsFunc_playSounds(SoundsType.OPEN_PAGE,false)
            print("灵山")
            if zzc.GuideController:checkFunctionTips(enFunctionType.LingShan) == false then
                return
            end
            zzc.SpiritController:showLayer()
            self.lingshanTips:setVisible(false)
        end
    end)
    self.btn_tower:addTouchEventListener(function(target,type)
        if type == 0 then
            startPoint.x,startPoint.y = target:getPosition()
            startPoint = target:convertToWorldSpace(startPoint)
        elseif type == 2 then
            endPoint.x,endPoint.y = target:getPosition()
            endPoint = target:convertToWorldSpace(endPoint)
            if math.abs(math.modf(endPoint.x - startPoint.x)) > 5 then
                return
            end
            print("试练塔")
            SoundsFunc_playSounds(SoundsType.OPEN_PAGE,false)
            if zzc.GuideController:checkFunctionTips(enFunctionType.ShiLianTa) == false then
                return
            end
            zzc.TowerController:showLayer()
        end
    end)
    self.btn_warship:addTouchEventListener(function(target,type)
        if type == 0 then
            startPoint.x,startPoint.y = target:getPosition()
            startPoint = target:convertToWorldSpace(startPoint)
        elseif type == 2 then
            endPoint.x,endPoint.y = target:getPosition()
            endPoint = target:convertToWorldSpace(endPoint)
            if math.abs(math.modf(endPoint.x - startPoint.x)) > 5 then
                return
            end
            SoundsFunc_playSounds(SoundsType.OPEN_PAGE,false)
            --            print("讨伐")
            if zzc.GuideController:checkFunctionTips(enFunctionType.ChuMo) == false then
                return
            end
            zzc.WorldBossController:showLayer()
        end
    end)

    self.btn_cornucopia:addTouchEventListener(function(target,type)
        if type == 0 then
            startPoint.x,startPoint.y = target:getPosition()
            startPoint = target:convertToWorldSpace(startPoint)
        elseif type == 2 then
            endPoint.x,endPoint.y = target:getPosition()
            endPoint = target:convertToWorldSpace(endPoint)
            if math.abs(math.modf(endPoint.x - startPoint.x)) > 5 then
                return
            end
            print("聚宝盆")
            SoundsFunc_playSounds(SoundsType.OPEN_PAGE,false)
            if zzc.GuideController:checkFunctionTips(enFunctionType.CaiShenBaoKu) == false then
                return
            end
            --            TipsFrame:create("功能尚未开放")
            zzc.CornucopiaController:showLayer()
            self.cornucopiaTips:setVisible(false)
        end
    end)
    self.btn_fairylake:addTouchEventListener(function(target,type)
		--local targetPlatform = cc.Application:getInstance():getTargetPlatform()
		--if targetPlatform == cc.PLATFORM_OS_ANDROID then
			--print "JniUtil.callCanLockScreenLua"
			--JniUtil.callCanLockScreenLua("test")
		--end
        if type == 0 then
            startPoint.x,startPoint.y = target:getPosition()
            startPoint = target:convertToWorldSpace(startPoint)
        elseif type == 2 then
            endPoint.x,endPoint.y = target:getPosition()
            endPoint = target:convertToWorldSpace(endPoint)
            if math.abs(math.modf(endPoint.x - startPoint.x)) > 5 then
                return
            end
            print("仙女湖")
            SoundsFunc_playSounds(SoundsType.OPEN_PAGE,false)
            if zzc.GuideController:checkFunctionTips(enFunctionType.XianNv) == false then
                return
            end
            zzc.FairyController:showLayer()
        end
    end)
    self.btn_gods:addTouchEventListener(function(target,type)
        if type == 0 then
            startPoint.x,startPoint.y = target:getPosition()
            startPoint = target:convertToWorldSpace(startPoint)
        elseif type == 2 then
            endPoint.x,endPoint.y = target:getPosition()
            endPoint = target:convertToWorldSpace(endPoint)
            if math.abs(math.modf(endPoint.x - startPoint.x)) > 5 then
                return
            end
            SoundsFunc_playSounds(SoundsType.OPEN_PAGE,false)
            if zzc.GuideController:checkFunctionTips(enFunctionType.FengShenTai) == false then
                return
            end
            zzc.GeneralController:showLayer()
            --            require "src.game.general.view.GeneralLayer"
            --            local _csb = GeneralLayer:create()
            --            self:addChild(_csb)
            print("封神台")
        end
    end)
    self.btn_billboard:addTouchEventListener(function(target,type)
        if type == 0 then
            startPoint.x,startPoint.y = target:getPosition()
            startPoint = target:convertToWorldSpace(startPoint)
        elseif type == 2 then
            endPoint.x,endPoint.y = target:getPosition()
            endPoint = target:convertToWorldSpace(endPoint)
            if math.abs(math.modf(endPoint.x - startPoint.x)) > 5 then
                return
            end
            print("风云榜")
            SoundsFunc_playSounds(SoundsType.OPEN_PAGE,false)
            if zzc.GuideController:checkFunctionTips(enFunctionType.PaiHangBang) == false then
                return
            end
            local _csb = require("src.game.ranking.view.RankingLayer"):create()
            self:addChild(_csb)
            LoadWaitSec:show(90,-20)
        end
    end)

    --    if _G.GroupData.State == 1 then --已加入仙门
    --        zzc.GroupController:getMyMemberList()
    --    end
    self.btn_faction:addTouchEventListener(function(target,type)
        if type == 0 then
            startPoint.x,startPoint.y = target:getPosition()
            startPoint = target:convertToWorldSpace(startPoint)
        elseif type == 2 then
            endPoint.x,endPoint.y = target:getPosition()
            endPoint = target:convertToWorldSpace(endPoint)
            if math.abs(math.modf(endPoint.x - startPoint.x)) > 5 then
                return
            end
            print("仙门")
            SoundsFunc_playSounds(SoundsType.OPEN_PAGE,false)
            if zzc.GuideController:checkFunctionTips(enFunctionType.XianMen) == false then
                return
            end
            zzc.GroupController:showLayer()
            --            TipsFrame:create("功能尚未开启")
        end
    end)
    self.btn_tianmen:addTouchEventListener(function(target,type)
        if type == 0 then
            startPoint.x,startPoint.y = target:getPosition()
            startPoint = target:convertToWorldSpace(startPoint)
        elseif type == 2 then
            endPoint.x,endPoint.y = target:getPosition()
            endPoint = target:convertToWorldSpace(endPoint)
            if math.abs(math.modf(endPoint.x - startPoint.x)) > 5 then
                return
            end
            print("天门")
            SoundsFunc_playSounds(SoundsType.OPEN_PAGE,false)
            if zzc.GuideController:checkFunctionTips(enFunctionType.XianMenLianSai) == false then
                return
            end
            TipsFrame:create("功能尚未开放")
        end
    end)
    self.btn_zudui:addTouchEventListener(function(target,type)	--组队爬塔
        if type == 0 then
            startPoint.x,startPoint.y = target:getPosition()
            startPoint = target:convertToWorldSpace(startPoint)
    elseif type == 2 then
        endPoint.x,endPoint.y = target:getPosition()
        endPoint = target:convertToWorldSpace(endPoint)
        if math.abs(math.modf(endPoint.x - startPoint.x)) > 5 then
            return
        end
        SoundsFunc_playSounds(SoundsType.OPEN_PAGE,false)
        if zzc.GuideController:checkFunctionTips(enFunctionType.ZuDui) == false then
            return
        end
        if _G.GroupData.State == DefineConst.CONST_SOCIATY_MSG_TYPE_JOIN then --已加入仙门
            zzc.GroupController:createTeamTower()
        else
            cn:TipsSchedule("尚未加入仙门")
        end
    end
    end)

    self.btn_pk:addTouchEventListener(function(target,type)
        if type == 0 then
            startPoint.x,startPoint.y = target:getPosition()
            startPoint = target:convertToWorldSpace(startPoint)
        elseif type == 2 then
            endPoint.x,endPoint.y = target:getPosition()
            endPoint = target:convertToWorldSpace(endPoint)
            if math.abs(math.modf(endPoint.x - startPoint.x)) > 5 then
                return
            end
            print("演武场")
            SoundsFunc_playSounds(SoundsType.OPEN_PAGE,false)
            if zzc.GuideController:checkFunctionTips(enFunctionType.JingJiChang) == false then
                return
            end
            --TipsFrame:create("功能尚未开放")
            zzc.PkController:showLayer()
        end
    end)

    --    SoundsInit.new()
end

function MainScene:createGuideMask()
    self._guideMaskNode =  cc.Node:create()
    self:addChild(self._guideMaskNode)
    local _delyTime = 0
    self._myCheckFightOverTimer = self._myCheckFightOverTimer or require("game.utils.MyTimer").new()
    local function tick()
        if zzc.GuideController._nextGuideMask == true then
            self._startDely = true
        else
            self._startDely = false
            _delyTime = 0
        end
        if self._startDely == true then
            _delyTime = _delyTime + 1
        else
            _delyTime = 0
        end

        if _delyTime > 2 then
            zzc.GuideController._nextGuideMask = false
            self._startDely = false
            _delyTime = 0
        end
    end

    local deleTime = 1
    self._myCheckFightOverTimer:start(deleTime, tick)

    -- 拦截
    local function onTouchBegan(touch, event)
        print("----------------Mask")
        print(zzc.GuideController._nextGuideMask)
        return zzc.GuideController._nextGuideMask
    end

    local listener = cc.EventListenerTouchOneByOne:create()
    listener:registerScriptHandler(onTouchBegan,cc.Handler.EVENT_TOUCH_BEGAN )
    local eventDispatcher = self:getEventDispatcher()
    eventDispatcher:addEventListenerWithSceneGraphPriority(listener, self._guideMaskNode)
    listener:setSwallowTouches(true)
end

--function MainScene:closeAction()
--    if self._action then
--        self._ndMainCity:removAllChildren()
--        self._action = nil
--    end
--end

---------------------------
--@param
--@return
function MainScene:setNextFunc(rewardNode)
    local btn_nextFunc = rewardNode:getChildByName("nextFuncBtn")

    local  data = zzm.GuideModel:getNextOpenFunction()
    if data == nil then
        btn_nextFunc:setVisible(false)
    else
        btn_nextFunc:setVisible(true)
        local iconList = btn_nextFunc:getChildren()
        for i=1, #iconList do
            iconList[i]:setVisible(false)
        end
        print(data.ButtonName)
        local func = btn_nextFunc:getChildByName(data.ButtonName)
        if(func) then
            func:setVisible(true)
        end
    end

end


function MainScene:updateChatIcon(flag)
    self._spriteRedIcon:setVisible(flag)
end

function MainScene:init()
    --cc.Texture2D:setDefaultAlphaPixelFormat(9)
    self._main = cc.CSLoader:createNode("dxyCocosStudio/csd/scene/MainScene_new.csb")
    --cc.Texture2D:setDefaultAlphaPixelFormat(2)

    self:addChild(self._main)
    --self._main:retain()
    self._main:setPosition(self.origin.x,self.origin.y)

    self._timeLine = cc.CSLoader:createTimeline("dxyCocosStudio/csd/scene/MainScene_new.csb")
    self._main:runAction(self._timeLine)
    self._timeLine:gotoFrameAndPlay(0,true)

    --cc.SpriteFrameCache:getInstance():addSpriteFrames("dxyCocosStudio/png/equip/BgPlist.plist")
    --cc.SpriteFrameCache:getInstance():addSpriteFrames("dxyCocosStudio/png/mainscene/Change.plist")

    --    self.ScrollView = self._main:getChildByName("ScrollView")
    --    self.ScrollView:setContentSize(self.visibleSize)

    --	self.btnNode = self._main:getChildByName("btnNode")
    --	self.btnGM = self.btnNode:getChildByName("btnGM")
    --
    --	self.btnGM:setVisible(false)
    --	if _G.gGMcmd then
    --		self.btnGM:setVisible(true)
    --	end

    self.panel = self._main:getChildByName("Panel")

    self.cloudLayer = self.panel:getChildByName("cloudLayer")
    self.cloudNode = self.cloudLayer:getChildByName("moveCloudNode")

    self.bgLayer = self.panel:getChildByName("bgLayer")
    self._bg = self.bgLayer:getChildByName("BG")

    self.farLayer = self.panel:getChildByName("farLayer")
    self.midLayer = self.panel:getChildByName("midLayer")
    self.closeLayer = self.panel:getChildByName("closeLayer")

    self.t_bgLayer = self.panel:getChildByName("terrain_bgLayer")
    self.t_farLayer = self.panel:getChildByName("terrain_farLayer")
    self.t_midLayer = self.panel:getChildByName("terrain_midLayer")
    self.t_closeLayer = self.panel:getChildByName("terrain_closeLayer")
    self.t_frontLayer = self._main:getChildByName("terrain_frontLayer")
    self._ndMainCity = self.t_frontLayer:getChildByName("ndMainCity")

    --竞技场和封神台的云
    self.cloud_6 = self.t_farLayer:getChildByName("cloud_6")
    self.cloud_6_copy = self.t_farLayer:getChildByName("cloud_6_Copy")
    self.cloud_6_copy_0 = self.t_farLayer:getChildByName("cloud_6_Copy_0")
    self.cloud_6_copy_1 = self.t_farLayer:getChildByName("cloud_6_Copy_1")
    self.cloud_6_copy_2 = self.t_farLayer:getChildByName("cloud_6_Copy_2")
    self.cloud_6_copy_3 = self.t_farLayer:getChildByName("cloud_6_Copy_3")
    self._initPosx = self.cloud_6:getPositionX()
    self.cloud_7 = self.t_closeLayer:getChildByName("cloud_7")
    self.cloud_7_copy = self.t_closeLayer:getChildByName("cloud_7_Copy")
    self.cloud_7_copy_0 = self.t_closeLayer:getChildByName("cloud_7_Copy_0")

    self.btn_lingshan = self.midLayer:getChildByName("lingshanBtn")
    self.lingshanTips = self.btn_lingshan:getChildByName("redIcon")
    self.lingshanTips:setVisible(false)

    self.btn_zudui = self.midLayer:getChildByName("ZuDuiBtn")

    self.btn_tower = self.midLayer:getChildByName("trialtowerBtn")
    self.btn_warship = self.farLayer:getChildByName("warshipBtn")
    self.btn_cornucopia = self.midLayer:getChildByName("cornucopiaBtn")
    self.cornucopiaTips = self.btn_cornucopia:getChildByName("redIcon")
    self.cornucopiaTips:setVisible(false)

    self.btn_fairylake = self.midLayer:getChildByName("fairylakeBtn")
    self.btn_gods = self.midLayer:getChildByName("godsBtn")
    self.btn_billboard = self.midLayer:getChildByName("billboardBtn")
    self.btn_faction = self.closeLayer:getChildByName("fairydoorBtn")
    self.btn_tianmen = self.closeLayer:getChildByName("leagueBtn")
    self.btn_pk = self.closeLayer:getChildByName("pkBtn")

    --功能标题
    self.title_lingshan = self.btn_lingshan:getChildByName("Sprite")
    self.title_tower = self.btn_tower:getChildByName("Sprite")
    self.title_warship = self.btn_warship:getChildByName("Sprite")
    self.title_cornucopia = self.btn_cornucopia:getChildByName("Sprite")
    self.title_fairylake = self.btn_fairylake:getChildByName("Sprite")
    self.title_gods = self.btn_gods:getChildByName("Sprite")
    self.title_billboard = self.btn_billboard:getChildByName("Sprite")
    self.title_faction = self.btn_faction:getChildByName("Sprite")
    self.title_pk = self.btn_pk:getChildByName("Sprite")
    self.title_zudui = self.btn_zudui:getChildByName("Sprite")

    local noticeNode = self._main:getChildByName("noticeNode")
    noticeNode:setVisible(false)
    local headNode = self._main:getChildByName("headNode")
    local goldNode = self._main:getChildByName("goldNode")
    local btnNode = self._main:getChildByName("btnNode")
    local fightNode = self._main:getChildByName("fightNode")
    local rewardNode = self._main:getChildByName("rewardNode")

    --local expNode = headNode:getChildByName("expNode")
    self._exp = headNode:getChildByName("expBar")

    self.btn_head = headNode:getChildByName("headBtn")
    self.txt_name = headNode:getChildByName("nameTxt")
    self.txt_level = headNode:getChildByName("levelBmf")
    self.txt_power = headNode:getChildByName("powerBmf")

    self.txt_copper = goldNode:getChildByName("copperTxt")
    self.txt_ingot = goldNode:getChildByName("ingotTxt")
    self.txt_physical = goldNode:getChildByName("physicalTxt")
    self.txt_yuanli = goldNode:getChildByName("yuanliTxt")

    local btn_copper = goldNode:getChildByName("copperBtn")
    local btn_ingot = goldNode:getChildByName("ingotBtn")
    --    local btn_physical = goldNode:getChildByName("physicalBtn")
    local btn_yuanli = goldNode:getChildByName("yuanliBtn")

    local btn_role = btnNode:getChildByName("roleBtn")
    self.roleTips = btn_role:getChildByName("Sprite")
    self.roleTips:setVisible(false)

    local btn_setup = btnNode:getChildByName("setupBtn")
    local btn_friend = btnNode:getChildByName("friendBtn")
    self.red_friend = btn_friend:getChildByName("Sprite")
    local btn_chat = btnNode:getChildByName("chatBtn")
    
    local btn_soul = btnNode:getChildByName("soulBtn")
    self.soulTips = btn_soul:getChildByName("Sprite")
    self.soulTips:setVisible(false)
    
    local btn_skill = btnNode:getChildByName("skillBtn")
    self.skillTips = btn_skill:getChildByName("Sprite")
    self.skillTips:setVisible(false)

    local btn_sweep = btnNode:getChildByName("sweepBtn")
    self.sweepTips = btn_sweep:getChildByName("Sprite")
    self.sweepTips:setVisible(false)
    
    local btn_xianyu = btnNode:getChildByName("xianyuBtn")

    local btn_fight = fightNode:getChildByName("fightBtn")
    --    self.effect_fight = fightNode:getChildByName("Effect")
    self.effect_node = fightNode:getChildByName("EffectNode")

    local btn_reward = rewardNode:getChildByName("rewardBtn")
    self._rewardTips = btn_reward:getChildByName("tips")

    local activityBtn = rewardNode:getChildByName("activityBtn")

    local btn_helper = rewardNode:getChildByName("helperBtn")

    --self:setNextFunc(rewardNode)
    local btn_nextFunc = rewardNode:getChildByName("nextFuncBtn")

    self._spriteRedIcon = btn_chat:getChildByName("Sprite")
    self._spriteRedIcon:setVisible(zzm.ChatModel.RedChat)

    local  data = zzm.GuideModel:getNextOpenFunction()
    if data == nil then
        btn_nextFunc:setVisible(false)
    else
        btn_nextFunc:setVisible(true)
        local iconList = btn_nextFunc:getChildren()
        for i=1, #iconList do
            iconList[i]:setVisible(false)
        end
        print(data.ButtonName)
        local func = btn_nextFunc:getChildByName(data.ButtonName)
        if(func) then
            func:setVisible(true)
        end
    end

    self:updateTaskTips()
    local btn_firstcharge = rewardNode:getChildByName("firstchargeBtn")
    self._spCharge = btn_firstcharge:getChildByName("Sprite_38")
    if false and _G.RoleData.ALLRMB >= RechargeConfig:getDemand() and zzm.RechargeModel._isFirst >= 2 then
        self._spCharge:setTexture("dxyCocosStudio/png/mainscene/chongzhi.png")
    else
        self._spCharge:setTexture("dxyCocosStudio/png/mainscene/shouchong.png")
    end

    zzc.GuideController:registerFuncObj(enFunctionType.ZhuangBei, btn_role, 1)          --装备
    zzc.GuideController:registerFuncObj(enFunctionType.JiNeng, btn_skill, 1)            --技能
    zzc.GuideController:registerFuncObj(enFunctionType.YuanShen, btn_soul, 1)           --元神
    zzc.GuideController:registerFuncObj(enFunctionType.LingShan, self.btn_lingshan)     --器灵
    zzc.GuideController:registerFuncObj(enFunctionType.ShiLianTa, self.btn_tower)       --试练塔
    zzc.GuideController:registerFuncObj(enFunctionType.ChuMo, self.btn_warship)         --世界BOSS
    zzc.GuideController:registerFuncObj(enFunctionType.CaiShenBaoKu, self.btn_cornucopia)--财神宝库
    zzc.GuideController:registerFuncObj(enFunctionType.XianNv, self.btn_fairylake)      --仙女
    zzc.GuideController:registerFuncObj(enFunctionType.FengShenTai, self.btn_gods)      --封神台
    zzc.GuideController:registerFuncObj(enFunctionType.PaiHangBang, self.btn_billboard) --排行榜
    zzc.GuideController:registerFuncObj(enFunctionType.XianMen, self.btn_faction)       --仙门
    zzc.GuideController:registerFuncObj(enFunctionType.XianMenLianSai, self.btn_tianmen)--仙门联赛
    zzc.GuideController:registerFuncObj(enFunctionType.JingJiChang, self.btn_pk)        --竞技场
    zzc.GuideController:registerFuncObj(enFunctionType.JiangLi, btn_reward,1)           --奖励
    zzc.GuideController:registerFuncObj(enFunctionType.SaoDang, btn_sweep, 1)           --扫荡
    zzc.GuideController:registerFuncObj(enFunctionType.ZuDui, self.btn_zudui)           --组队爬塔
    zzc.GuideController:registerFuncObj(enFunctionType.XianYu, btn_xianyu ,1)           --仙域

    --适配屏幕
    headNode:setPosition(self.origin.x,self.origin.y+self.visibleSize.height)
    btnNode:setPosition(self.origin.x,self.origin.y)
    noticeNode:setPosition(self.origin.x+self.visibleSize.width/2,self.origin.y+self.visibleSize.height*0.8969)
    goldNode:setPosition(self.origin.x+self.visibleSize.width /2,self.origin.y+self.visibleSize.height * 0.97)
    fightNode:setPosition(self.origin.x+self.visibleSize.width,self.origin.y)
    rewardNode:setPosition(self.origin.x+self.visibleSize.width,self.origin.y+self.visibleSize.height)

    self.btn_head:addTouchEventListener(function(target,type)--头像
        if type ==2 then
            print("角色按钮")
            _G.RankData.Uid = _G.RoleData.Uid
            zzc.RoleinfoController:showLayer()
    end
    end)

    --    --经验条创建
    --    local path = "dxyCocosStudio/png/mainscene/head frame_2.png"
    --    self._exp = MyClippingNode:create()
    --    self._exp:init(path,0,0,expNode)
    --    self._exp:setPercentage(0.8)

    btn_copper:addTouchEventListener(function(target,type)--铜钱
        if type ==2 then
            print("铜钱按钮")
            --            TipsFrame:create("功能尚未开放")
            zzc.RecruitMoneyController:showLayer()
    end
    end)
    btn_ingot:addTouchEventListener(function(target,type)--元宝
        if type ==2 then
            print("元宝按钮")
            --            TipsFrame:create("功能尚未开放")
            if _G.RoleData.ALLRMB >= RechargeConfig:getDemand() and zzm.RechargeModel._isFirst >= 2 then
                zzc.RechargeController:showLayer()
            else
                require "src.game.recharge.view.FirstRecharge"
                local _csb = FirstRecharge:create()
                self:addChild(_csb)
            end
    end
    end)
    --    btn_physical:addTouchEventListener(function(target,type)--体力
    --        if type ==2 then
    --            zzc.PhysicalTipsController:showGodLayer()
    --        end
    --    end)
    btn_yuanli:addTouchEventListener(function(target,type)  --元力
        if type == 2 then
            zzc.PhysicalTipsController:showLayer()
    end
    end)


    btn_role:addTouchEventListener(function(target,type)--角色
        if type == 2 then
            SoundsFunc_playSounds(SoundsType.OPEN_PAGE,false)
            print("角色按钮")
            if zzc.GuideController:checkFunctionTips(enFunctionType.ZhuangBei) == false then
                return
            end
            zzc.CharacterController:showLayer()
            self.roleTips:setVisible(false)
    end
    end)

    btn_skill:addTouchEventListener(function(target,type)--技能
        if type == 2 then
            dxyDispatcher_dispatchEvent("dxyEventType.FinishButtonGuide")
            SoundsFunc_playSounds(SoundsType.OPEN_PAGE,false)
            print("技能按钮")
            if zzc.GuideController:checkFunctionTips(enFunctionType.JiNeng) == false then
                return
            end
            zzc.SkillController:showLayer()
            self.skillTips:setVisible(false)
    end
    end)

    btn_sweep:addTouchEventListener(function(target,type)--蟠桃园
        if type == 2 then
            SoundsFunc_playSounds(SoundsType.OPEN_PAGE,false)
            if zzc.GuideController:checkFunctionTips(enFunctionType.SaoDang) == false then
                return
            end
            zzc.SweepController:showLayer()
            self.sweepTips:setVisible(false)
    end
    end)
    
    btn_xianyu:addTouchEventListener(function(target,type)--仙域 
        if type == 2 then
            SoundsFunc_playSounds(SoundsType.OPEN_PAGE,false)
            if zzc.GuideController:checkFunctionTips(enFunctionType.XianYu) == false then
                return
            end
            zzc.ImmortalFieldController:request_GetUIData()
            zzc.ImmortalFieldController:request_GoodsData()
            zzc.TilemapController:showLayer()
        end
    end)

    function sendGM(gm)
        local msg = mc.packetData:createWritePacket(800); --编写发送包
        msg:writeString(gm)
        mc.NetMannager:getInstance():sendMsg(msg); --发送 包
    end

    function GM_initBackpack()
    --        sendGM("goods 101001 1")
    --        sendGM("goods 102001 1")
    --        sendGM("goods 103001 1")
    --        sendGM("goods 104001 1")
    --        sendGM("goods 105001 1")
    --        sendGM("goods 106001 1")
    --        sendGM("goods 201001 11")
    --        sendGM("gold 9999")
    --        sendGM("renown 9999")

    end

    local btnGM = btnNode:getChildByName("btnGM")
    btnGM:addTouchEventListener(function(target,type)
        if type == 2 then
            require("game.SendTest")
            SendTest:create()
        end
    end)

    btnGM:setVisible(false)
    if _G.gGMcmd then
        btnGM:setVisible(true)
    end

    local btnLottery = rewardNode:getChildByName("btnLottery")
    self.lotteryDrawTips = rewardNode:getChildByName("SpriteRedIcon")
    btnLottery:addTouchEventListener(function(target,type)
        if type == 2 then
            zzc.LotteryDrawController:request_EnterPanel()
        end
    end)


    btn_setup:addTouchEventListener(function(target,type)--设置
        if type == 2 then
            SoundsFunc_playSounds(SoundsType.OPEN_PAGE,false)
            local setup = require("game.setup.SetupNode"):create()
            self:addChild(setup)
        end
    end)
    btn_friend:addTouchEventListener(function(target,type)--好友
        if type == 2 then
            print("好友按钮")
            SoundsFunc_playSounds(SoundsType.OPEN_PAGE,false)
            require "game.friend.view.FriendMainLayer"
            local layer = FriendMainLayer.create()
            local scene = SceneManager:getCurrentScene()
            --UIManager:addUI(layer, "FriendMainLayer")
            scene:addChild(layer)
            --TipsFrame:create("功能尚未开放")
    end
    end)
    btn_chat:addTouchEventListener(function(target,type)--聊天
        if type == 2 then
            print("聊天按钮")
            --            zzc.AnnouncementController:showLayer()
            --            zzc.AnnouncementController:httpRequest_OpenAnnouncementLayer()
            --            require "game.chat.view.ChatMainLayer"
            --            local layer = ChatMainLayer.create()
            --            local scene = SceneManager:getCurrentScene()
            --            scene:addChild(layer)
            SoundsFunc_playSounds(SoundsType.OPEN_PAGE,false)
            zzc.ChatController:showLayer()
    end
    end)
    btn_soul:addTouchEventListener(function(target,type)--元神
        if type == 2 then
            SoundsFunc_playSounds(SoundsType.OPEN_PAGE,false)
            if zzc.GuideController:checkFunctionTips(enFunctionType.YuanShen) == false then
                return
            end
            zzc.YuanShenController:showLayer()
            print("元神按钮")
    end
    end)

    btn_fight:addTouchEventListener(function(target,type)--战斗
        if type ==2 then
            print("战斗按钮")
            SoundsFunc_playSounds(SoundsType.OPEN_PAGE,false)
            zzc.CopySelectController:showLayer()
    end
    end)

    btn_reward:addTouchEventListener(function(target,type)--奖励
        if type ==2 then
            SoundsFunc_playSounds(SoundsType.OPEN_PAGE,false)
            if zzc.GuideController:checkFunctionTips(enFunctionType.JiangLi) == false then
                return
            end
            zzc.TaskController:showLayer()
            --            dxyDispatcher_dispatchEvent("TaskNode_HidelOtherSV",1)
    end
    end)
    btn_firstcharge:addTouchEventListener(function(target,type)--首冲
        if type ==2 then
            print("首冲按钮")
            SoundsFunc_playSounds(SoundsType.OPEN_PAGE,false)
            if _G.RoleData.ALLRMB >= RechargeConfig:getDemand() and zzm.RechargeModel._isFirst >= 2 then
                zzc.RechargeController:showLayer()
            else
                zzc.RechargeController:showNode()
            end
            --            TipsFrame:create("功能尚未开启")
    end
    end)

    activityBtn:addTouchEventListener(function(target,type)--活动
        if type == 2 then
            zzc.ActivityController:showLayer()
    end
    end)
    self.activityTips = activityBtn:getChildByName("tips_0")

    btn_nextFunc:addTouchEventListener(function(target,type)--奖励
        if type ==2 then
            SoundsFunc_playSounds(SoundsType.OPEN_PAGE,false)
            zzc.GuideController:showNextFunctionTips()
            print("nextFuncnextFunc按钮")
    end
    end)

    btn_helper:addTouchEventListener(function(target,type)--小助手
        if type ==2 then
            SoundsFunc_playSounds(SoundsType.OPEN_PAGE,false)
            zzc.HelperController:showLayer()
    end
    end)

    --背景移动
    local bgPos = {x=0,y=0}
    local closePos = {x=0,y=0}
    local midPos = {x=0,y=0}
    local farPos = {x=0,y=0}
    local cloudPos = {x=0,y=0}
    local function onTouchBegan(touch, event)
        --print("点击")
        self.startPoint = touch:getLocation()

        bgPos.x = self.bgLayer:getPositionX()
        bgPos.y = self.bgLayer:getPositionY()
        closePos.x = self.closeLayer:getPositionX()
        closePos.y = self.closeLayer:getPositionY()
        midPos.x = self.midLayer:getPositionX()
        midPos.y = self.midLayer:getPositionY()
        farPos.x = self.farLayer:getPositionX()
        farPos.y = self.farLayer:getPositionY()
        cloudPos.x = self.t_bgLayer:getPositionX()
        cloudPos.y = self.t_bgLayer:getPositionY()

        return true
    end

    local function onTouchMoved(touch, event)
        --print("移动")
        self.endPoint = touch:getLocation()
        --print(self.endPoint.x..","..self.endPoint.y)
        local distance = self.endPoint.x - self.startPoint.x
        if distance > 0 then
            if self.bgLayer:getPositionX() < 0 and self.bgLayer:getPositionX() >= -(self._bg:getContentSize().width - self.visibleSize.width) then
                self.bgLayer:setPosition(bgPos.x+ distance,bgPos.y)
                self.closeLayer:setPosition(closePos.x+ distance,closePos.y)
                self.midLayer:setPosition(midPos.x + distance * LayerMoveFactors.MID_MOVE,midPos.y)
                self.farLayer:setPosition(farPos.x + distance * LayerMoveFactors.FAR_MOVE,farPos.y)
                self.cloudLayer:setPosition(bgPos.x+ distance,bgPos.y)

                self.t_bgLayer:setPosition(cloudPos.x + distance * LayerMoveFactors.BG_MOVE,cloudPos.y)
                self.t_farLayer:setPosition(farPos.x + distance * LayerMoveFactors.FAR_MOVE,farPos.y)
                self.t_midLayer:setPosition(midPos.x + distance * LayerMoveFactors.MID_MOVE,midPos.y)
                self.t_closeLayer:setPosition(closePos.x+ distance,closePos.y)
                self.t_frontLayer:setPosition(closePos.x+ distance,closePos.y)
            end
        elseif distance < 0 then
            if self.bgLayer:getPositionX() > -(self._bg:getContentSize().width - self.visibleSize.width) and self.bgLayer:getPositionX()<= 0 then
                self.bgLayer:setPosition(bgPos.x+ distance,bgPos.y)
                self.closeLayer:setPosition(closePos.x+ distance,closePos.y)
                self.midLayer:setPosition(midPos.x + distance * LayerMoveFactors.MID_MOVE ,midPos.y)
                self.farLayer:setPosition(farPos.x + distance * LayerMoveFactors.FAR_MOVE,farPos.y)
                self.cloudLayer:setPosition(bgPos.x+ distance,bgPos.y)

                self.t_bgLayer:setPosition(cloudPos.x + distance * LayerMoveFactors.BG_MOVE,cloudPos.y)
                self.t_farLayer:setPosition(farPos.x + distance * LayerMoveFactors.FAR_MOVE,farPos.y)
                self.t_midLayer:setPosition(midPos.x + distance * LayerMoveFactors.MID_MOVE,midPos.y)
                self.t_closeLayer:setPosition(closePos.x+ distance,closePos.y)
                self.t_frontLayer:setPosition(closePos.x+ distance,closePos.y)
            end
        end
        self:adjust()
    end

    local function onTouchEnded(touch, event)
    --print("结束")
    --print(self._bg:getPositionX()..","..self._bg:getPositionY())
    end

    local listener = cc.EventListenerTouchOneByOne:create()
    listener:registerScriptHandler(onTouchBegan,cc.Handler.EVENT_TOUCH_BEGAN )
    listener:registerScriptHandler(onTouchMoved,cc.Handler.EVENT_TOUCH_MOVED )
    listener:registerScriptHandler(onTouchEnded,cc.Handler.EVENT_TOUCH_ENDED )
    local eventDispatcher = self._bg:getEventDispatcher()
    eventDispatcher:addEventListenerWithSceneGraphPriority(listener, self._bg)
    listener:setSwallowTouches(false)

    self:moveCloud()

    self:checkSpecial()
end

--检查是否是特殊引导
function MainScene:checkSpecial()
	local funList = NewFunctionConfig:getSpecialConfig()
    local data = zzm.CopySelectModel.curCopyData
	if not data then
		return
	end
	for key, var in pairs(funList) do
		if var.Id == data.id then
			self:autoMove(var.ButtonName)
		end
	end
end

function MainScene:adjust()--调整滑屏
    if self.bgLayer:getPositionX() >= 0 then
        self.bgLayer:setPosition(0,0)
        self.closeLayer:setPosition(0,0)
        self.midLayer:setPosition(0,0)
        self.farLayer:setPosition(0,0)
        self.cloudLayer:setPosition(0,0)

        self.t_bgLayer:setPosition(0,0)
        self.t_farLayer:setPosition(0,0)
        self.t_midLayer:setPosition(0,0)
        self.t_closeLayer:setPosition(0,0)
        self.t_frontLayer:setPosition(0,0)

end

if self.bgLayer:getPositionX() <= -(self._bg:getContentSize().width - self.visibleSize.width) then
    self.bgLayer:setPosition(-(self._bg:getContentSize().width - self.visibleSize.width),0)
    self.closeLayer:setPosition(-(self._bg:getContentSize().width - self.visibleSize.width),0)
    self.midLayer:setPosition(-(self._bg:getContentSize().width - self.visibleSize.width)*LayerMoveFactors.MID_MOVE,0)
    self.farLayer:setPosition(-(self._bg:getContentSize().width - self.visibleSize.width)*LayerMoveFactors.FAR_MOVE,0)
    self.cloudLayer:setPosition(-(self._bg:getContentSize().width - self.visibleSize.width),0)

    self.t_bgLayer:setPosition(-(self._bg:getContentSize().width - self.visibleSize.width)*LayerMoveFactors.BG_MOVE,0)
    self.t_farLayer:setPosition(-(self._bg:getContentSize().width - self.visibleSize.width)*LayerMoveFactors.FAR_MOVE,0)
    self.t_midLayer:setPosition(-(self._bg:getContentSize().width - self.visibleSize.width)*LayerMoveFactors.MID_MOVE,0)
    self.t_closeLayer:setPosition(-(self._bg:getContentSize().width - self.visibleSize.width),0)
    self.t_frontLayer:setPosition(-(self._bg:getContentSize().width - self.visibleSize.width),0)

end
end


function MainScene:autoMove(functionId)
    local bgPos = {x=0,y=0}
    local closePos = {x=0,y=0}
    local midPos = {x=0,y=0}
    local farPos = {x=0,y=0}
    local cloudPos = {x=0,y=0}

    self.startPoint = cc.p(0,0)

    bgPos.x = self.bgLayer:getPositionX()
    bgPos.y = self.bgLayer:getPositionY()
    closePos.x = self.closeLayer:getPositionX()
    closePos.y = self.closeLayer:getPositionY()
    midPos.x = self.midLayer:getPositionX()
    midPos.y = self.midLayer:getPositionY()
    farPos.x = self.farLayer:getPositionX()
    farPos.y = self.farLayer:getPositionY()
    cloudPos.x = self.t_bgLayer:getPositionX()
    cloudPos.y = self.t_bgLayer:getPositionY()

    local btn = zzc.GuideController:getFuncObjByType(functionId)
    if not btn then
        return
    end
    self.endPoint.x = btn:getPositionX()
    self.endPoint.y = btn:getPositionY()
    --print(self.endPoint.x..","..self.endPoint.y)
    local distance = - (self.endPoint.x - self.startPoint.x)

    if distance > -960 then
        return
    end

    if distance > 0 then
        if self.bgLayer:getPositionX() < 0 and self.bgLayer:getPositionX() >= -(self._bg:getContentSize().width - self.visibleSize.width) then
            self.bgLayer:setPosition(bgPos.x+ distance,bgPos.y)
            self.closeLayer:setPosition(closePos.x+ distance,closePos.y)
            self.midLayer:setPosition(midPos.x + distance * LayerMoveFactors.MID_MOVE,midPos.y)
            self.farLayer:setPosition(farPos.x + distance * LayerMoveFactors.FAR_MOVE,farPos.y)
            self.cloudLayer:setPosition(bgPos.x+ distance,bgPos.y)

            self.t_bgLayer:setPosition(cloudPos.x + distance * LayerMoveFactors.BG_MOVE,cloudPos.y)
            self.t_farLayer:setPosition(farPos.x + distance * LayerMoveFactors.FAR_MOVE,farPos.y)
            self.t_midLayer:setPosition(midPos.x + distance * LayerMoveFactors.MID_MOVE,midPos.y)
            self.t_closeLayer:setPosition(closePos.x+ distance,closePos.y)
            self.t_frontLayer:setPosition(closePos.x+ distance,closePos.y)
        end
    elseif distance < 0 then
        if self.bgLayer:getPositionX() > -(self._bg:getContentSize().width - self.visibleSize.width) and self.bgLayer:getPositionX()<= 0 then
            self.bgLayer:setPosition(bgPos.x+ distance,bgPos.y)
            self.closeLayer:setPosition(closePos.x+ distance,closePos.y)
            self.midLayer:setPosition(midPos.x + distance * LayerMoveFactors.MID_MOVE ,midPos.y)
            self.farLayer:setPosition(farPos.x + distance * LayerMoveFactors.FAR_MOVE,farPos.y)
            self.cloudLayer:setPosition(bgPos.x+ distance,bgPos.y)

            self.t_bgLayer:setPosition(cloudPos.x + distance * LayerMoveFactors.BG_MOVE,cloudPos.y)
            self.t_farLayer:setPosition(farPos.x + distance * LayerMoveFactors.FAR_MOVE,farPos.y)
            self.t_midLayer:setPosition(midPos.x + distance * LayerMoveFactors.MID_MOVE,midPos.y)
            self.t_closeLayer:setPosition(closePos.x+ distance,closePos.y)
            self.t_frontLayer:setPosition(closePos.x+ distance,closePos.y)
        end
    end
    self:adjust()
end

--循环移动云
function MainScene:moveCloud()
    local cloud1 = cc.Sprite:create("dxyCocosStudio/png/mainscene/bgBtn/cloud_10.png")
    local cloud2 = cc.Sprite:create("dxyCocosStudio/png/mainscene/bgBtn/cloud_10.png")
    local cloud3 = cc.Sprite:create("dxyCocosStudio/png/mainscene/bgBtn/cloud_10.png")
    local cloud4 = cc.Sprite:create("dxyCocosStudio/png/mainscene/bgBtn/cloud_10.png")
	
	cloud1:setVisible(false)
	cloud2:setVisible(false)
	cloud3:setVisible(false)
	cloud4:setVisible(false)

    cloud1:setPositionX(cloud1:getContentSize().width/2 + self.origin.x)
    cloud2:setPositionX(cloud2:getContentSize().width/2 + self.origin.x + cloud2:getContentSize().width * 1.5)
    cloud3:setPositionX(cloud3:getContentSize().width/2 + self.origin.x + self._bg:getContentSize().width / 2)
    cloud4:setPositionX(cloud4:getContentSize().width/2 + self.origin.x + cloud4:getContentSize().width * 1.5 + self._bg:getContentSize().width / 2)

    self.cloudNode:addChild(cloud1,-100,100)
    self.cloudNode:addChild(cloud2,-200,200)
    self.cloudNode:addChild(cloud3,-300,300)
    self.cloudNode:addChild(cloud4,-400,400)

    local function move()

        if self.cloudNode == nil then return end

        local cloud1 = self.cloudNode:getChildByTag(100)
        local cloud2 = self.cloudNode:getChildByTag(200)
        local cloud3 = self.cloudNode:getChildByTag(300)
        local cloud4 = self.cloudNode:getChildByTag(400)

        cloud1:setPositionX(cloud1:getPositionX() + 1)
        cloud2:setPositionX(cloud2:getPositionX() + 1)
        cloud3:setPositionX(cloud3:getPositionX() + 1)
        cloud4:setPositionX(cloud4:getPositionX() + 1)

        self.cloud_6:setPositionX(self.cloud_6:getPositionX() + 1)
        self.cloud_6_copy:setPositionX(self.cloud_6_copy:getPositionX() + 1)
        self.cloud_6_copy_0:setPositionX(self.cloud_6_copy_0:getPositionX() + 1)
        self.cloud_6_copy_1:setPositionX(self.cloud_6_copy_1:getPositionX() + 1)
        self.cloud_6_copy_2:setPositionX(self.cloud_6_copy_2:getPositionX() + 1)
        self.cloud_6_copy_3:setPositionX(self.cloud_6_copy_3:getPositionX() + 1)
        self.cloud_7:setPositionX(self.cloud_7:getPositionX() + 1)
        self.cloud_7_copy:setPositionX(self.cloud_7_copy:getPositionX() + 1)
        self.cloud_7_copy_0:setPositionX(self.cloud_7_copy_0:getPositionX() + 1)

        if self.cloud_6:getPositionX() - self.cloud_6:getContentSize().width/8 >= self._bg:getContentSize().width then
            local offset = self.cloud_6:getPositionX() - self.cloud_6:getContentSize().width/8 - self._bg:getContentSize().width
            self.cloud_6:setPositionX(-self.cloud_6:getContentSize().width + self._initPosx + offset)
        end

        if self.cloud_6_copy:getPositionX() - self.cloud_6_copy:getContentSize().width/8 >= self._bg:getContentSize().width then
            local offset = self.cloud_6_copy:getPositionX() - self.cloud_6_copy:getContentSize().width/8 - self._bg:getContentSize().width
            self.cloud_6_copy:setPositionX(-self.cloud_6_copy:getContentSize().width + self._initPosx + offset)
        end

        if self.cloud_6_copy_0:getPositionX() - self.cloud_6_copy_0:getContentSize().width/8 >= self._bg:getContentSize().width then
            local offset = self.cloud_6_copy_0:getPositionX() - self.cloud_6_copy_0:getContentSize().width/8 - self._bg:getContentSize().width
            self.cloud_6_copy_0:setPositionX(-self.cloud_6_copy_0:getContentSize().width + self._initPosx + offset)
        end

        if self.cloud_6_copy_1:getPositionX() - self.cloud_6_copy_1:getContentSize().width/8 >= self._bg:getContentSize().width then
            local offset = self.cloud_6_copy_1:getPositionX() - self.cloud_6_copy_1:getContentSize().width/8 - self._bg:getContentSize().width
            self.cloud_6_copy_1:setPositionX(-self.cloud_6_copy_1:getContentSize().width + self._initPosx + offset)
        end

        if self.cloud_6_copy_2:getPositionX() - self.cloud_6_copy_2:getContentSize().width/8 >= self._bg:getContentSize().width then
            local offset = self.cloud_6_copy_2:getPositionX() - self.cloud_6_copy_2:getContentSize().width/8 - self._bg:getContentSize().width
            self.cloud_6_copy_2:setPositionX(-self.cloud_6_copy_2:getContentSize().width + self._initPosx + offset)
        end

        if self.cloud_6_copy_3:getPositionX() - self.cloud_6_copy_3:getContentSize().width/8 >= self._bg:getContentSize().width then
            local offset = self.cloud_6_copy_3:getPositionX() - self.cloud_6_copy_3:getContentSize().width/8 - self._bg:getContentSize().width
            self.cloud_6_copy_3:setPositionX(-self.cloud_6_copy_3:getContentSize().width + self._initPosx + offset)
        end

        if self.cloud_7:getPositionX() - self.cloud_7:getContentSize().width/2 >= self._bg:getContentSize().width then
            local offset = self.cloud_7:getPositionX() - self.cloud_7:getContentSize().width/2 - self._bg:getContentSize().width

            self.cloud_7:setPositionX(-self.cloud_7:getContentSize().width/2 + self.origin.x + offset)
        end

        if self.cloud_7_copy:getPositionX() - self.cloud_7_copy:getContentSize().width/2 >= self._bg:getContentSize().width then
            local offset = self.cloud_7_copy:getPositionX() - self.cloud_7_copy:getContentSize().width/2 - self._bg:getContentSize().width

            self.cloud_7_copy:setPositionX(-self.cloud_7_copy:getContentSize().width/2 + self.origin.x + offset)
        end

        if self.cloud_7_copy_0:getPositionX() - self.cloud_7_copy_0:getContentSize().width/2 >= self._bg:getContentSize().width then
            local offset = self.cloud_7_copy_0:getPositionX() - self.cloud_7_copy_0:getContentSize().width/2 - self._bg:getContentSize().width

            self.cloud_7_copy_0:setPositionX(-self.cloud_7_copy_0:getContentSize().width/2 + self.origin.x + offset)
        end

        if cloud1:getPositionX() - cloud1:getContentSize().width/2 >= self._bg:getContentSize().width then
            local offset = cloud1:getPositionX() - cloud1:getContentSize().width/2 - self._bg:getContentSize().width

            cloud1:setPositionX(-cloud1:getContentSize().width/2 + self.origin.x + offset)
        end

        if cloud2:getPositionX() - cloud2:getContentSize().width/2 >= self._bg:getContentSize().width then
            local offset = cloud2:getPositionX() - cloud2:getContentSize().width/2 - self._bg:getContentSize().width

            cloud2:setPositionX(-cloud2:getContentSize().width/2 + self.origin.x + offset)
        end

        if cloud3:getPositionX() - cloud3:getContentSize().width/2 >= self._bg:getContentSize().width then
            local offset = cloud3:getPositionX() - cloud3:getContentSize().width/2 - self._bg:getContentSize().width

            cloud3:setPositionX(-cloud3:getContentSize().width/2 + self.origin.x + offset)
        end

        if cloud4:getPositionX() - cloud4:getContentSize().width/2 >= self._bg:getContentSize().width then
            local offset = cloud4:getPositionX() - cloud4:getContentSize().width/2 - self._bg:getContentSize().width

            cloud4:setPositionX(-cloud4:getContentSize().width/2 + self.origin.x + offset)
        end

    end
    local myTimer = require("game.utils.MyTimer").new()
    myTimer:start(0.1,move)

end

function MainScene:updateRecharge()
    if _G.RoleData.ALLRMB >= RechargeConfig:getDemand() and zzm.RechargeModel._isFirst >= 2 then
        self._spCharge:setTexture("dxyCocosStudio/png/mainscene/chongzhi.png")
    else
        self._spCharge:setTexture("dxyCocosStudio/png/mainscene/shouchong.png")
    end
end

function MainScene:updateRoleTips()     --更新装备红点
    local equipNum = #zzm.CharacterModel:getBackpackList()
    if equipNum <= 0 then
        self.roleTips:setVisible(false)
    else
        self.roleTips:setVisible(true)
    end
end

function MainScene:updateSkillTips()  --更新技能红点
    local skillUpgrade = #zzm.SkillModel:getSkillIsTips()
    if skillUpgrade <= 0 then
        self.skillTips:setVisible(false)
    else
        self.skillTips:setVisible(true)
    end
end

function MainScene:updateSweepTips()    --更新蟠桃园红点
    local peachNum = zzm.SweepModel:getPeachNum()
    local treePeach = zzm.SweepModel.treeNum

    if peachNum <= 0 and treePeach <= 0 then
        self.sweepTips:setVisible(false)
    else
        self.sweepTips:setVisible(true)
    end
end

function MainScene:updateSoulTips() --更新元神修炼红点
    local role = zzm.CharacterModel:getCharacterData()
    local enCAT = enCharacterAttrType
    
    local data = YuanShenConfig:getNextRes(zzm.YuanShenModel._arrYuanShen["Lv"])
    
--    if role:getValueByType(enCAT.GOLD) >= data.Gold and role:getValueByType(enCAT.RENOWN) >= data.Prestige then
--        self.soulTips:setVisible(true)
--    else
--        self.soulTips:setVisible(false)
--    end
    
end

function MainScene:updateCornucopiaTips()   --更新财神宝库红点

    if zzm.GuideModel:isOpenFunctionByType(enFunctionType.CaiShenBaoKu) == false then
        return
    end

    local role = zzm.CharacterModel:getCharacterData()
    local enCAT = enCharacterAttrType
    local num = role:getValueByType(enCAT.MONEYCOUNT)

    if num <= 0 then
        self.cornucopiaTips:setVisible(false)
    else
        self.cornucopiaTips:setVisible(true)
    end
end

function MainScene:updateLingshanTips() --更新器灵红点

    if zzm.GuideModel:isOpenFunctionByType(enFunctionType.LingShan) == false then
        return
    end

    local role = zzm.CharacterModel:getCharacterData()
    local enCAT = enCharacterAttrType
    local num = role:getValueByType(enCAT.EXPLORE)

    if num <= 0 then
        self.lingshanTips:setVisible(false)
    else
        self.lingshanTips:setVisible(true)
    end
end

function MainScene:updateTaskTips()
    local bool = zzm.TaskModel:checkTaskTips()
    if bool then
        self._rewardTips:setVisible(true)
    else
        self._rewardTips:setVisible(false)
    end
end

function MainScene:updateActivityTips()
    if zzm.ActivityModel.isAcTips then
        self.activityTips:setVisible(true)
        zzm.ActivityModel.isAcTips = false
    else
        self.activityTips:setVisible(false)
    end
end

function MainScene:updateFightEffect()
    if zzm.CopySelectModel.isFightEffect then
        self.effect_node:setVisible(true)
        self.effect_action = nil
        self.effect_node:removeAllChildren()

        local Ossature = "res/images/fightBtnEffcet/bling"
        self.effect_action = mc.SkeletonDataCash:getInstance():createWithCashName(Ossature)
        self.effect_action:setAnimation(1,"bling", true)
        self.effect_action:setAnchorPoint(0,0)
        --    action:setPosition(0,0)
        self.effect_node:addChild(self.effect_action)
    else
        self.effect_node:setVisible(false)
        if self.effect_action then
            self.effect_action = nil
            self.effect_node:removeAllChildren()
        end
    end
end

function MainScene:updateLotterDrawTips()
	if zzm.LotteryDrawModel.freeChanceCount > 0 then
        self.lotteryDrawTips:setVisible(true)
	else
        self.lotteryDrawTips:setVisible(false)
	end
end

function MainScene:updateFriendIcon(isFriendRed)--更新好友红点
    self.red_friend:setVisible(isFriendRed)
end

function MainScene:updateValue(data)

    local role = zzm.CharacterModel:getCharacterData()
    local enCAT = enCharacterAttrType

    self:setCopper(role:getValueByType(enCAT.GOLD))
    self:setIngot(role:getValueByType(enCAT.RMB))
    self.txt_name:setString(role:getValueByType(enCAT.NAME))
    self.txt_level:setString(role:getValueByType(enCAT.LV))
    self.txt_power:setString(role:getValueByType(enCAT.POWER))
    self._exp:setPercent(role:getValueByType(enCAT.EXP) / role:getValueByType(enCAT.EXPUP) * 100)
    --    self.txt_physical:setString(role:getValueByType(enCAT.GNCOPYCN).."/"..PhysicalConfig:getBaseValue().Limit)
    self.txt_yuanli:setString(role:getValueByType(enCAT.PHYSICAL).."/"..PhysicalConfig:getBaseValue().Limit)
end

function MainScene:setCopper(copper)--设置铜钱
    self.txt_copper:setString(self:getFormat(copper))
end

function MainScene:setIngot(ingot)
    --设置元宝
    self.txt_ingot:setString(ingot)
end

function MainScene:getFormat(value)
    local ret = math.modf(tonumber(value) / 10000)


    if ret >= 1 then
        ret = tostring(ret).."万"
    else
        ret = tostring(value)
    end
    return ret
end

function MainScene:WhenClose()
    cc.SimpleAudioEngine:getInstance():stopMusic()
    ccexp.AudioEngine:stopAll()
    if self._myGuideTimer then
        self._myGuideTimer:stop()
        self._myGuideTimer = nil
    end

    if self._action then
        self._ndMainCity:removeAllChildren()
        self._action = nil
    end
    if zzc.MarqueeController._myTimer then
        zzc.MarqueeController:closeTimer()
    end

    if self.effect_action then
        self.effect_node:removeAllChildren()
        self.effect_action = nil
    end

    zzc.GroupController:clean()

    dxyDispatcher_dispatchEvent("BossLayer_whenClose")
    --mc.ResMgr:getInstance():releasedALLRes()
end