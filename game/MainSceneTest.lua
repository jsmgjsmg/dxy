require("game.utils.MyClippingNode")

MainSceneTest = MainSceneTest or class("MainSceneTest",function()
    return cc.Scene:create()
end)

function MainSceneTest:create()
    local scene = MainScene:new()
    return scene
end

function MainSceneTest:ctor()

    mc.ResMgr:getInstance():releasedALLRes()
    --图片放入缓存
    cc.SpriteFrameCache:getInstance():addSpriteFrames("dxyCocosStudio/png/equip/BgPlist.plist")
    cc.SpriteFrameCache:getInstance():addSpriteFrames("dxyCocosStudio/png/mainscene/Change.plist")
    cc.SpriteFrameCache:getInstance():addSpriteFrames("dxyCocosStudio/png/yuanshen/change.plist")
    cc.SpriteFrameCache:getInstance():addSpriteFrames("dxyCocosStudio/png/fairy/Change.plist")
    cc.SpriteFrameCache:getInstance():addSpriteFrames("dxyCocosStudio/png/recharge/Change.plist")
    cc.SpriteFrameCache:getInstance():addSpriteFrames("dxyCocosStudio/png/vip/change.plist")
    cc.SpriteFrameCache:getInstance():addSpriteFrames("dxyCocosStudio/png/roleinfo/titleIcon/titleIconPlist.plist")
    cc.SpriteFrameCache:getInstance():addSpriteFrames("dxyCocosStudio/png/general/new/Change.plist")
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

    self._exp = nil

    self.startPoint = {}
    self.endPoint = {}

    self:init()

end

function MainScene:init()
    self._main = cc.CSLoader:createNode("dxyCocosStudio/csd/scene/MainScene_new.csb")
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
    self.t_frontLayer = self.panel:getChildByName("terrain_frontLayer")

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
    self.btn_tower = self.midLayer:getChildByName("trialtowerBtn")
    self.btn_warship = self.farLayer:getChildByName("warshipBtn")
    self.btn_cornucopia = self.midLayer:getChildByName("cornucopiaBtn")
    self.btn_fairylake = self.midLayer:getChildByName("fairylakeBtn")
    self.btn_gods = self.midLayer:getChildByName("godsBtn")
    self.btn_billboard = self.midLayer:getChildByName("billboardBtn")
    self.btn_faction = self.closeLayer:getChildByName("fairydoorBtn")
    self.btn_tianmen = self.closeLayer:getChildByName("leagueBtn")
    self.btn_pk = self.closeLayer:getChildByName("pkBtn")

    local noticeNode = self._main:getChildByName("noticeNode")
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

    local btn_copper = goldNode:getChildByName("copperBtn")
    local btn_ingot = goldNode:getChildByName("ingotBtn")
    local btn_physical = goldNode:getChildByName("physicalBtn")

    local btn_role = btnNode:getChildByName("roleBtn")
    local btn_setup = btnNode:getChildByName("setupBtn")
    local btn_friend = btnNode:getChildByName("friendBtn")
    local btn_chat = btnNode:getChildByName("chatBtn")
    local btn_soul = btnNode:getChildByName("soulBtn")
    local btn_skill = btnNode:getChildByName("skillBtn")

    local btn_fight = fightNode:getChildByName("fightBtn")

    local btn_reward = rewardNode:getChildByName("rewardBtn")
    self._rewardTips = btn_reward:getChildByName("tips")
    self:updateTaskTips()
    local btn_firstcharge = rewardNode:getChildByName("firstchargeBtn")
    self._spCharge = btn_firstcharge:getChildByName("Sprite_38")

    zzc.GuideController:registerFuncObj(enFunctionType.ZhuangBei, btn_role, 1)
    zzc.GuideController:registerFuncObj(enFunctionType.JiNeng, btn_skill, 1)
    zzc.GuideController:registerFuncObj(enFunctionType.YuanShen, btn_soul, 1)
    zzc.GuideController:registerFuncObj(enFunctionType.LingShan, self.btn_lingshan)
    zzc.GuideController:registerFuncObj(enFunctionType.ShiLianTa, self.btn_tower)
    zzc.GuideController:registerFuncObj(enFunctionType.ChuMo, self.btn_warship)
    zzc.GuideController:registerFuncObj(enFunctionType.CaiShenBaoKu, self.btn_cornucopia)
    zzc.GuideController:registerFuncObj(enFunctionType.XianNv, self.btn_fairylake)
    zzc.GuideController:registerFuncObj(enFunctionType.FengShenTai, self.btn_gods)
    zzc.GuideController:registerFuncObj(enFunctionType.PaiHangBang, self.btn_billboard)
    zzc.GuideController:registerFuncObj(enFunctionType.XianMen, self.btn_faction)
    zzc.GuideController:registerFuncObj(enFunctionType.XianMenLianSai, self.btn_tianmen)
    zzc.GuideController:registerFuncObj(enFunctionType.JingJiChang, self.btn_pk)
    zzc.GuideController:registerFuncObj(enFunctionType.JiangLi, btn_reward)
    

    --适配屏幕
    headNode:setPosition(self.origin.x,self.origin.y+self.visibleSize.height)
    btnNode:setPosition(self.origin.x,self.origin.y)
    noticeNode:setPosition(self.origin.x+self.visibleSize.width/2,self.origin.y+self.visibleSize.height*0.8969)
    goldNode:setPosition(self.origin.x+self.visibleSize.width/2,self.origin.y+self.visibleSize.height)
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
            TipsFrame:create("功能尚未开放")
        end
    end)
    btn_ingot:addTouchEventListener(function(target,type)--元宝
        if type ==2 then
            print("元宝按钮")
--            TipsFrame:create("功能尚未开放")
            if _G.RoleData.ALLRMB >= RechargeConfig:getDemand() and zzm.RechargeModel._isFirst >= 2 then
                require "src.game.recharge.view.RechargeLayer"
                local _csb = RechargeLayer:create()
                self:addChild(_csb)
            else
                require "src.game.recharge.view.FirstRecharge"
                local _csb = FirstRecharge:create()
                self:addChild(_csb)
            end
        end
    end)
    btn_physical:addTouchEventListener(function(target,type)--体力
        if type ==2 then
            print("体力按钮")
--            TipsFrame:create("功能尚未开放")
            require("game.commonUI.PhysicalTips")
            PhysicalTips:create()
    end
    end)


    btn_role:addTouchEventListener(function(target,type)--角色
        if type == 2 then
            print("角色按钮")
            if zzc.GuideController:checkFunctionTips(enFunctionType.ZhuangBei) == false then
                return
            end
            zzc.CharacterController:showLayer()
    end
    end)

    btn_skill:addTouchEventListener(function(target,type)--技能
        if type == 2 then
--            print("技能按钮")
--            if zzc.GuideController:checkFunctionTips(enFunctionType.JiNeng) == false then
--                return
--            end
            zzc.SkillController:showLayer()
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
    btn_setup:addTouchEventListener(function(target,type)--设置
        if type == 2 then
            print("设置按钮")
            --            GM_initBackpack()
            require("game.SendTest")
            SendTest:create()
    end
    end)
    btn_friend:addTouchEventListener(function(target,type)--好友
        if type == 2 then
            print("好友按钮")
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
            zzc.ChatController:showLayer()
    end
    end)
    btn_soul:addTouchEventListener(function(target,type)--元神
        if type == 2 then
--            if zzc.GuideController:checkFunctionTips(enFunctionType.YuanShen) == false then
--                return
--            end
            require "src.game.yuanshen.view.YuanShenLayer"
            local _csb = YuanShenLayer:create()
            self:addChild(_csb)
            print("元神按钮")
    end
    end)

    btn_fight:addTouchEventListener(function(target,type)--战斗
        if type ==2 then
            print("战斗按钮")
            zzc.CopySelectController:showLayer()
            --            local loadingScene = zzc.LoadingController:getScene(SceneType.CopyScene)
            --            SceneManager:enterScene(loadingScene, "LoadingScene")
    end
    end)

    btn_reward:addTouchEventListener(function(target,type)--奖励
        if type ==2 then
--            if zzc.GuideController:checkFunctionTips(enFunctionType.JiangLi) == false then
--                return
--            end
            require "src.game.task.view.TaskNode"
            local _csb = TaskNode.new()
            self:addChild(_csb)
            print("奖励按钮")
--            TipsFrame:create("功能尚未开放")
    end
    end)
    btn_firstcharge:addTouchEventListener(function(target,type)--首冲
        if type ==2 then
            print("首冲按钮")
            if _G.RoleData.ALLRMB >= RechargeConfig:getDemand() and zzm.RechargeModel._isFirst >= 2 then
                require "src.game.recharge.view.RechargeLayer"
                local _csb = RechargeLayer:create()
                self:addChild(_csb)
            else
                require "src.game.recharge.view.FirstRecharge"
                local _csb = FirstRecharge:create()
                self:addChild(_csb)
            end
            --            require "src.game.recharge.view.RechargeLayer"
            --            local _csb = RechargeLayer:create()
            --            self:addChild(_csb)
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

end


function MainScene:WhenClose()
    cc.SimpleAudioEngine:getInstance():stopMusic()
    ccexp.AudioEngine:stopAll()
    
end