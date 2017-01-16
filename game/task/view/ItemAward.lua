ItemAward = ItemAward or class("ItemAward",function()
    return cc.Node:create()
end)
local GOODS_NUM = 4

function ItemAward:ctor()
    self._iconGoods = {}
    self._bgGoods = {}
    self._txtGoodsNum = {}
    self._initPosX = 167
    self.m_data = nil
    self.visibleSize = cc.Director:getInstance():getVisibleSize()
    self.origin = cc.Director:getInstance():getVisibleOrigin()
end

function ItemAward:create()
    local node = ItemAward:new()
    node:initItem()
    return node
end

function ItemAward:initItem()
    self._csb = cc.CSLoader:createNode("res/dxyCocosStudio/csd/ui/task/ItemTask.csb")
    self:addChild(self._csb)
	
	local tl = cc.CSLoader:createTimeline("res/dxyCocosStudio/csd/ui/task/ItemTask.csb") 
    self._csb:runAction(tl) 
    tl:gotoFrameAndPlay(0,true) 
    
    self._role = zzm.CharacterModel:getCharacterData()
    self._enCAT = enCharacterAttrType

    self._Image = self._csb:getChildByName("Image")
    self._gold = self._Image:getChildByName("gold")
    self._yb = self._Image:getChildByName("yb")
    self._exp = self._Image:getChildByName("exp")
    self._power = self._Image:getChildByName("power")
    self._renown = self._Image:getChildByName("renown")
    for i=1,GOODS_NUM do
        self._bgGoods[i] = self._Image:getChildByName("goods"..i)
        self._iconGoods[i] = self._bgGoods[i]:getChildByName("Sprite")
        self._txtGoodsNum[i] = self._bgGoods[i]:getChildByName("txtNum")
    end
    self._flower = self._Image:getChildByName("flower")
    self._hufu = self._Image:getChildByName("hufu")
    self._douhun = self._Image:getChildByName("douhun")
    self._jingpo = self._Image:getChildByName("jingpo")
    self._fragment = self._Image:getChildByName("fragment")
    self._spFragment = self._fragment:getChildByName("Sprite")
    self._taozi3 = self._Image:getChildByName("taozi3")
    self._taozi6 = self._Image:getChildByName("taozi6")
    self._taozi9 = self._Image:getChildByName("taozi9")
    self._ks = self._Image:getChildByName("ks")
    self._qs = self._Image:getChildByName("qs")
    self._lingqi = self._Image:getChildByName("lingqi")
    
    self._txtGold = self._gold:getChildByName("txtGold")
    self._txtYB = self._yb:getChildByName("txtYB")
    self._txtExp = self._exp:getChildByName("txtExp")
    self._txtPower = self._power:getChildByName("txtPower")
    self._txtRenown = self._renown:getChildByName("txtRenown")
    self._txtFlower = self._flower:getChildByName("txtFlower")
    self._txtHufu = self._hufu:getChildByName("txtHufu")
    self._txtDouhun = self._douhun:getChildByName("txtDouhun")
    self._txtJingpo = self._jingpo:getChildByName("txtJingpo")
    self._txtFragment = self._fragment:getChildByName("txtFragment")
    self._txtTaozi3 = self._taozi3:getChildByName("txtTaozi3")
    self._txtTaozi6 = self._taozi6:getChildByName("txtTaozi6")
    self._txtTaozi9 = self._taozi9:getChildByName("txtTaozi9")
    self._txtKS = self._ks:getChildByName("txtKS")
    self._txtQS = self._qs:getChildByName("txtQS")
    self._txtLingqi = self._lingqi:getChildByName("txtLingqi")
    
    local ndTxt = self._csb:getChildByName("ndTxt")
    self._txtTitle = ndTxt:getChildByName("txtTitle")
    self._txtInt = ndTxt:getChildByName("txtInt")

    self._btnGet = self._csb:getChildByName("btnGet")
    self._btnGoto = self._csb:getChildByName("btnGoto")
    self._btnNotyet = self._csb:getChildByName("btnNotyet")
    self._btnNotyet:setVisible(false)
    
    self._btnGoto:addTouchEventListener(function(target,type)
        if type == 2 then
            SoundsFunc_playSounds(SoundsType.OPEN_PAGE,false)

            if zzd.TaskData.arrTypeTitle[self._want.Type] == "TipsFrame" then
                _G[zzd.TaskData.arrTypeTitle[self._want.Type]]:create("功能尚未开放")

            elseif zzd.TaskData.arrTypeTitle[self._want.Type] == "Copy" then
                local copy = zzm.CopySelectModel:getCopyData(self._want.Finish1)
                if copy then
                    local lv = SceneConfigProvider:getCopyById(copy.id).DeblockingLv
                    if lv > self._role:getValueByType(self._enCAT.LV) then
                        dxyFloatMsg:show("副本尚未解锁")
                        return
                    end
                    zzc.CopySelectController:AutoOpenCopyPage(self._want.Finish1)
                    zzc.TaskController:closeLayer()
                else
                    dxyFloatMsg:show("副本尚未解锁")
                end
            elseif zzd.TaskData.arrTypeTitle[self._want.Type] == "LV" then
                zzc.CopySelectController:OpenCopyPage() 
                zzc.TaskController:closeLayer()
            elseif zzc[zzd.TaskData.arrTypeGoto[self._want.Type]] then
            
                if enFunctionType[zzd.TaskData.openType[self._want.Type]] then
                    if zzc.GuideController:checkFunctionTips(enFunctionType[zzd.TaskData.openType[self._want.Type]]) == false then
                        return
                    end
                end
            
                local layer = zzc[zzd.TaskData.arrTypeGoto[self._want.Type]]:showLayer()
                if zzd.TaskData.scrollPage[self._want.Type] then
                    layer:scrollToPage(1)
                end
                zzc.TaskController:closeLayer()
            else
--                dxyFloatMsg:show("")
            end
        end
    end)
    
    self._btnGet:addTouchEventListener(function(target,type)
        if type == 2 then
            SoundsFunc_playSounds(SoundsType.UNIVERSAL_BTN,false)
            if self.m_data.Type == 5 then
                zzc.TaskController:registerGetSpecialAward(self.m_data.Id) --3575
            else
                zzc.TaskController:registerGetAwardDate(self.m_data.Id) --3550
            end
        end
    end)

end

function ItemAward:update(data,type)
    self.m_data = data
    
    self._gold:setVisible(false)
    self._yb:setVisible(false)
    self._exp:setVisible(false)
    self._power:setVisible(false)
    self._renown:setVisible(false)
    for i=1,GOODS_NUM do
        self._bgGoods[i]:setVisible(false)
    end
    self._flower:setVisible(false)
    self._hufu:setVisible(false)
    self._douhun:setVisible(false)
    self._jingpo:setVisible(false)
    self._fragment:setVisible(false)
    self._spFragment:setVisible(false)
    self._taozi3:setVisible(false)
    self._taozi6:setVisible(false)
    self._taozi9:setVisible(false)
    self._ks:setVisible(false)
    self._qs:setVisible(false)
    self._lingqi:setVisible(false)
    
    self._btnGet:setVisible(false)
    self._btnGoto:setVisible(false)
    self._btnNotyet:setVisible(false)
    self._initPosX = 167
    
    if type == 1 then     ---普通奖励任务
        self._want = TaskConfig:getWantById(self.m_data.Id)
        self._rewards = dxyConfig_toList(self.m_data.Config.Rewards)
    elseif type == 2 then ---特殊奖励任务
        self._want = TaskConfig:getSpecialGroup(self.m_data.SecType)
        self._rewards = dxyConfig_toList(self.m_data.Reward)
    end
    self:HideGoods(self._rewards)
--    self:HideGoodsSP(self._rewards)
    
    self:HideRes(self._gold,self._txtGold,self:findRes(1))      --游戏币
    self:HideRes(self._yb,self._txtYB,self:findRes(2))          --元宝
    self:HideRes(self._exp,self._txtExp,self:findRes(3))        --经验
    self:HideRes(self._power,self._txtPower,self:findRes(12))   --体力
    self:HideRes(self._renown,self._txtRenown,self:findRes(4))  --声望
    self:HideRes(self._flower,self._txtFlower,self:findRes(11)) --鲜花
    self:HideRes(self._hufu,self._txtHufu,self:findRes(7))      --护符
    self:HideRes(self._jingpo,self._txtJingpo,self:findRes(9))  --精魄
    self:HideRes(self._douhun,self._txtDouhun,self:findRes(8))  --斗魂
    self:HideRes(self._taozi3,self._txtTaozi3,self:findRes(13)) --桃子3
    self:HideRes(self._taozi6,self._txtTaozi6,self:findRes(14)) --桃子6
    self:HideRes(self._taozi9,self._txtTaozi9,self:findRes(15)) --桃子9
    self:HideRes(self._ks,self._txtKS,self:findRes(16))         --乾石
    self:HideRes(self._qs,self._txtQS,self:findRes(17))         --坤石
    self:HideRes(self._lingqi,self._txtLingqi,self:findRes(5))  --灵气

--    self:HideFragment(self._rewards)
    self._txtTitle:setString(self._want.Name)
    self._txtInt:setString(self._want.Introduction)
    
--btn
    local state = self.m_data.State
    if state == 0 then
        self._btnGet:setVisible(false)
        self._btnGoto:setVisible(true)
        for j=1,#zzd.TaskData.arrNoNeedType do
            if self._want.Type == zzd.TaskData.arrNoNeedType[j] then
                self._btnGet:setVisible(false)
                self._btnGoto:setVisible(false)
                self._btnNotyet:setVisible(true)
            end
        end
        self._Image:loadTexture("dxyCocosStudio/png/pk/dekaronBg.png")
    elseif state == 1 then
        self._btnGet:setVisible(true)
        self._btnGoto:setVisible(false)
        self._Image:loadTexture("dxyCocosStudio/png/task/new/bgLight.png")
    elseif state == 2 then
        self._btnGet:setTouchEnabled(false)
        self._btnGoto:setBright(false)
    end    
end

function ItemAward:findRes(type)
    for key, var in pairs(self._rewards) do
    	if var.Type == type then
    	    return var
    	end
    end
end

function ItemAward:HideRes(target,text,res)
    if res then
        target:setVisible(true)
        text:setString(cn:convert(res.Num))
        self._initPosX = self._initPosX + 80
        target:setPositionX(self._initPosX)
    else
        target:setVisible(false)
    end
end

function ItemAward:HideGoods(data)
    local i = 1
    for key, var in pairs(data) do
    	if var.Type == 6 or var.Type == 10 then
            self._bgGoods[i]:setVisible(true)
            self._initPosX = self._initPosX + 80
            self._bgGoods[i]:setPositionX(self._initPosX)
            self._txtGoodsNum[i]:setString(var.Num)
            local config = GoodsConfigProvider:findGoodsById(var.Id)
            if var.Type == 6 then
                self._iconGoods[i]:setTexture("Icon/"..config.Icon..".png")
            else
                self._iconGoods[i]:setTexture("GodGeneralsIcon/"..config.Icon..".png")
            end
            i = i + 1
    	end
    end
end

function ItemAward:HideGoodsSP(data)
    local i = 1
    for key, var in pairs(data) do
    	if var.Type == 6 then
            self._bgGoods[i]:setVisible(true)
            self._initPosX = self._initPosX + 80
            self._bgGoods[i]:setPositionX(self._initPosX)
            local config = GoodsConfigProvider:findGoodsById(var.Num)
            self._iconGoods[i]:setTexture("Icon/"..config.Icon..".png")
            i = i + 1
    	end
    end
end
