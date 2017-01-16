YuanShenNode = YuanShenNode or class("YuanShenNode",function()
    return ccui.Layout:create()
end)
local PATH = "dxyCocosStudio/png/yuanshen/"
require "game.yuanshen.view.EffectNode"

function YuanShenNode:ctor()
    self.winSize = cc.Director:getInstance():getVisibleSize()
    self.origin = cc.Director:getInstance():getVisibleOrigin()
    self._EffectBall = {}
    self._EffectEye = {}
    self._gradeYSData = {}
    self._isFirst = true
    self._firstTimer = true
    self._lastData = nil
end

function YuanShenNode:create()
    local layer = YuanShenNode:new()
    layer:init()
    return layer
end

function YuanShenNode:init()
    self._csb = cc.CSLoader:createNode("res/dxyCocosStudio/csd/ui/yuanshen/YuanShenNode.csb")
    self:addChild(self._csb)
    self._csb:setPosition(self.origin.x + self.winSize.width / 2, self.origin.y + self.winSize.height / 2)
    
    require "game.yuanshen.view.EyeEffect"
    self._eyeEffect = EyeEffect:create()
    self:addChild(self._eyeEffect)

    dxyExtendEvent(self)
    local posX = self.origin.x + self.winSize.width/2
    local posY = self.origin.y + self.winSize.height/2
    
    local bgB = self._csb:getChildByName("bgB")
    bgB:setContentSize(self.winSize.width,self.winSize.height)
    
---left
    local ndLeft = self._csb:getChildByName("ndLeft")
    
    --pro
    self._upAtk = ndLeft:getChildByName("upAtk")
    self._upDef = ndLeft:getChildByName("upDef")
    self._upHp = ndLeft:getChildByName("upHp")
    self._atk = ndLeft:getChildByName("atk")
    self._def = ndLeft:getChildByName("def")
    self._hp = ndLeft:getChildByName("hp")
    
---ndMiddle
    local ndMiddle = self._csb:getChildByName("ndMiddle")
    
    self._txtState = ndMiddle:getChildByName("bgmo"):getChildByName("txtState")
    
    --icon
    self._ysIcon = ndMiddle:getChildByName("ysIcon")
    self._ysBall = ndMiddle:getChildByName("ysBall")
    
    --lb
    local expLB = ndMiddle:getChildByName("expLB")
    self._percent = expLB:getChildByName("percent")
    self._txtPercent = expLB:getChildByName("txtPercent")
    
    --need
    self._needGold = ndMiddle:getChildByName("needGold")
    self._needRenown = ndMiddle:getChildByName("needRenown")
    
    --btn
    self._ndBtn = ndMiddle:getChildByName("ndBtn")
    self._btnOne = self._ndBtn:getChildByName("btnOne")
    self._btnTen = self._ndBtn:getChildByName("btnTen")
    self._btnOne:addTouchEventListener(function(target,type)
        if type == 2 then
            SoundsFunc_playSounds(SoundsType.PRACTICE,false)
            zzc.YuanShenController:upGradeYS(1)
        end
    end)
    self._btnTen:addTouchEventListener(function(target,type)
        if type == 2 then
            SoundsFunc_playSounds(SoundsType.PRACTICE,false)
            zzc.YuanShenController:upGradeYS(10)
        end
    end)
    --change
    self._ndChange = ndMiddle:getChildByName("ndChange")
    self._btnChange = self._ndChange:getChildByName("btnChange")
    self._btnChange:addTouchEventListener(function(target,type)
        if type == 2 then
            SoundsFunc_playSounds(SoundsType.UNIVERSAL_BTN,false)
            zzc.YuanShenController:upGradeYS(2)
        end
    end)
    
--res
    local bgRes = ndMiddle:getChildByName("bgRes")
    self._txtGold = bgRes:getChildByName("txtGold")
    self._txtRenown = bgRes:getChildByName("txtRenown")
    
--CheckBox
    self._cbox = self._csb:getChildByName("CheckBox")
    self._cbox:addEventListenerCheckBox(function(target,type)
        print(type) --0:勾选   1：非选
        self._isCBox = type
        cc.UserDefault:getInstance():setStringForKey(UserDefaulKey.YSCBState,tostring(type))
    end)
    self._isCBox = tonumber(cc.UserDefault:getInstance():getStringForKey(UserDefaulKey.YSCBState))
    if self._isCBox ~= 0 and self._isCBox ~= 1 then
        cc.UserDefault:getInstance():setStringForKey(UserDefaulKey.YSCBState,"1")
        self._isCBox = 1
    end
    if self._isCBox == 0 then
        self._cbox:setSelected(true)
    else
        self._cbox:setSelected(false)
    end
    
    self:upGradeYS(zzm.YuanShenModel._arrYuanShen)
    self:upDateGolds()
end

function YuanShenNode:initEvent()
    dxyDispatcher_addEventListener("upGradeYS",self,self.upGradeYS)
    dxyDispatcher_addEventListener("upDateGolds",self,self.upDateGolds)
    dxyDispatcher_addEventListener("YuanShenNode_addGradeYSData",self,self.addGradeYSData)
end

function YuanShenNode:removeEvent()
    dxyDispatcher_removeEventListener("upGradeYS",self,self.upGradeYS)
    dxyDispatcher_removeEventListener("upDateGolds",self,self.upDateGolds)
    dxyDispatcher_removeEventListener("YuanShenNode_addGradeYSData",self,self.addGradeYSData)
    if self._myTimer then
    	self._myTimer:stop()
    	self._myTimer = nil
    end
end

function YuanShenNode:addGradeYSData(data)
    if self._isCBox == 1 then
        local temp = {}
--        temp.Atk = data.Atk
--        temp.Def = data.Def
--        temp.Hp = data.Hp
--        temp.Lv = data.Lv
--        temp.Exp = data.Exp    
--        temp.goods_Exp = data.goods_Exp    
        for key, var in pairs(data) do
        	temp[key] = var
        end
        table.insert(self._gradeYSData,temp)
        
        if self._firstTimer then
            self:upGradeYS(self._gradeYSData[1])
            table.remove(self._gradeYSData,1)
            self._btnOne:setTouchEnabled(false)
            self._btnOne:setBright(false)
            self._btnTen:setTouchEnabled(false)
            self._btnTen:setBright(false)
            self._btnChange:setTouchEnabled(false)
            self._btnChange:setBright(false)
            self._firstTimer = false
        end
        
        self._cbox:setTouchEnabled(false)
        
        if not self._myTimer then
            self._myTimer = self._myTimer or require("game.utils.MyTimer").new()
            SwallowAllTouches:show()
            local function tick()
                if #self._gradeYSData > 0 then
                    self:upGradeYS(self._gradeYSData[1])
                    table.remove(self._gradeYSData,1)
                    self._btnOne:setTouchEnabled(false)
                    self._btnOne:setBright(false)
                    self._btnTen:setTouchEnabled(false)
                    self._btnTen:setBright(false)
                    self._btnChange:setTouchEnabled(false)
                    self._btnChange:setBright(false)
                else
                    self._btnOne:setTouchEnabled(true)
                    self._btnOne:setBright(true)
                    self._btnTen:setTouchEnabled(true)
                    self._btnTen:setBright(true)
                    self._btnChange:setTouchEnabled(true)
                    self._btnChange:setBright(true)
                    self._firstTimer = true
                    self._cbox:setTouchEnabled(true)
                    SwallowAllTouches:close()
                    self._myTimer:stop()
                    self._myTimer = nil
                end
            end
            self._myTimer:start(0.5, tick)
        end
    else
        self:upGradeYS(data)
    end
end

function YuanShenNode:upGradeYS(data)
    local config = YuanShenConfig:getDataByLv(data["Lv"])
    
    if not self._isFirst then
        if self._isCBox == 1 then --非勾选
            EffectNode:PlayEffect(data)
        end
        cn:TipsSchedule("获得元气："..data.goods_Exp)
    end
    self._isFirst = false
    self._eyeEffect:changeEffect(config.Effect)

    self._atk:setString(data["Atk"])
    self._def:setString(data["Def"])
    self._hp:setString(data["Hp"])
    
    self._txtState:setString(config.Name)
    if data.Lv >= YuanShenConfig:getMaxLv() then
        self._btnOne:setTouchEnabled(false)
        self._btnOne:setBright(false)
        self._btnOne:setTitleText("已满级")
        
        self._btnTen:setTouchEnabled(false)
        self._btnTen:setBright(false)
        self._btnTen:setTitleText("已满级")
        
        self._txtPercent:setString("已满级")
    end
    local ysIcon = YuanShenConfig:getYSIcon(data["Lv"])
    self._ysIcon:setSpriteFrame(cc.SpriteFrameCache:getInstance():getSpriteFrame(PATH..ysIcon.Icon_L))
    self._ysBall:setSpriteFrame(cc.SpriteFrameCache:getInstance():getSpriteFrame(PATH..ysIcon.Icon))
    
    local nextPro = YuanShenConfig:getNextPro(data["Lv"])
    self._upAtk:setString(nextPro["Atk"])
    self._upDef:setString(nextPro["Def"])
    self._upHp:setString(nextPro["Hp"])
    
    local nextRes = YuanShenConfig:getNextRes(data["Lv"])
    
    self._percent:setPercent(data["Exp"]/nextRes["Exp"]*100)
    self._txtPercent:setString(data["Exp"].."/"..nextRes["Exp"])
    
    self:changeYS(data,nextRes)
end

function YuanShenNode:changeYS(data,nextRes)
    self._ndBtn:setVisible(true)
    self._ndChange:setVisible(false)
    self._needGold:setString(nextRes["Gold"])
    self._needRenown:setString(nextRes["Prestige"])
    
    local change = YuanShenConfig:getChangePro(data["Lv"])
    if change and data["Exp"] >= nextRes["Exp"] then
        self._ndBtn:setVisible(false)
        self._ndChange:setVisible(true)
        self._needGold:setString(change["Gold"])
        self._needRenown:setString(change["Renown"])
    end

end

function YuanShenNode:upDateGolds()
    local role = zzm.CharacterModel:getCharacterData()
    local enCAT = enCharacterAttrType
    self._txtRenown:setString(cn:convert(role:getValueByType(enCAT.RENOWN)))
end