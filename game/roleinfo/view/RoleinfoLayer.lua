require("src.game.roleinfo.view.RenameLayer")
require("game.roleinfo.view.TitleLayer")
require("game.roleinfo.view.TitleWarfieldSlider")


RoleinfoLayer = RoleinfoLayer or class("RoleinfoLayer",function()
    return cc.Layer:create()
end)

function RoleinfoLayer:create()
    local layer = RoleinfoLayer:new()
    return layer
end

function RoleinfoLayer:ctor()
    self.visibleSize = cc.Director:getInstance():getVisibleSize()
    self.origin = cc.Director:getInstance():getVisibleOrigin()
    
    self.leftNode = nil
    self.rightNode = nil
    
    self._exp = nil
    
    self.btn_rename = ccui.Button   
    self.btn_retitle = ccui.Button
    self.btn_close = ccui.Button
    
    self:initUI()
    dxyExtendEvent(self)
end

function RoleinfoLayer:initUI()
    local roleinfoLayer = cc.CSLoader:createNode("dxyCocosStudio/csd/ui/roleinfo/roleinfoLayer.csb")
    self:addChild(roleinfoLayer)
    
    self.leftNode = roleinfoLayer:getChildByName("leftNode")
    self.pic_head = self.leftNode:getChildByName("headPic")
    self.txt_pk = self.leftNode:getChildByName("pkBmf")
    self._spNotyet = self.leftNode:getChildByName("spNotyet")
    self.txt_level = self.leftNode:getChildByName("levelTxt")
    self.txt_power = self.leftNode:getChildByName("powerTxt")
    self.txt_name = self.leftNode:getChildByName("nameTxt")
    self.txt_title = self.leftNode:getChildByName("titleTxt")
    
    self.bar_exp = self.leftNode:getChildByName("expBar")
    self.txt_exp = self.leftNode:getChildByName("expTxt")
    self.txt_fairydoor = self.leftNode:getChildByName("fairydoorTxt")
    
    self.txt_attack = self.leftNode:getChildByName("attackTxt")
    self.txt_defense = self.leftNode:getChildByName("defenseTxt")
    self.txt_life = self.leftNode:getChildByName("lifeTxt")
    self.txt_magic = self.leftNode:getChildByName("magicTxt")
    
    self.btn_rename = self.leftNode:getChildByName("renameBtn")
    self.btn_retitle = self.leftNode:getChildByName("retitleBtn")
    
    self.btn_close = roleinfoLayer:getChildByName("closeBtn")
    
    self.rightNode = roleinfoLayer:getChildByName("rightNode")
    local node = TitleWarfieldSlider.create()
    self.rightNode:addChild(node)
    
    --初始化数据
--    local role = zzm.CharacterModel:getCharacterData()
--    local enCAT = enCharacterAttrType
--    self.txt_pk:setString(role:getValueByType(enCAT.ANIMA))
--    self.txt_level:setString(role:getValueByType(enCAT.LV))
--    self.txt_power:setString(role:getValueByType(enCAT.POWER))
--    self.txt_name:setString(role:getValueByType(enCAT.NAME))
--    self.txt_title:setString("")
--    self.txt_fairydoor:setString("未加入")
--    self.txt_attack:setString(role:getValueByType(enCAT.ATK))
--    self.txt_defense:setString(role:getValueByType(enCAT.DEF))
--    self.txt_life:setString(role:getValueByType(enCAT.HP))
--    self.txt_magic:setString(role:getValueByType(enCAT.MP))
--    self.txt_exp:setString(role:getValueByType(enCAT.EXP).."/"..role:getValueByType(enCAT.EXPUP))
--    self.bar_exp:setPercent(role:getValueByType(enCAT.EXP) / role:getValueByType(enCAT.EXPUP) * 100)
--    
--    self.pic_head:setTexture(HeroConfig:getValueById(role:getValueByType(enCAT.PRO))["IconRole"])

    if _G.RankData.Uid == _G.RoleData.Uid then
        self:MinePro()
    else
        zzc.RoleinfoController:getDataWithPro(_G.RankData.Uid,0)
    end
    zzc.RoleinfoController:getPKranking(_G.RankData.Uid)
end

function RoleinfoLayer:removeEvent()
    dxyDispatcher_removeEventListener("RoleinfoLayer_update",self,self.updateValue)
    dxyDispatcher_removeEventListener("RoleinfoLayer_updateRank",self,self.updateRank)
end

function RoleinfoLayer:initEvent()
    dxyDispatcher_addEventListener("RoleinfoLayer_update",self,self.updateValue)
    dxyDispatcher_addEventListener("RoleinfoLayer_updateRank",self,self.updateRank)
    
    self.btn_rename:addTouchEventListener(function(target,type)
        if type == ccui.TouchEventType.ended then
        	local renameLayer = cc.Node
        	renameLayer = RenameLayer:create()
            SceneManager:getCurrentScene():addChild(renameLayer)
        	UIManager:addUI(renameLayer,"renameLayer")
        	renameLayer:setPosition(self.origin.x + self.visibleSize.width / 2,self.origin.y + self.visibleSize.height / 2)
        end
    end)
    
    self.btn_retitle:addTouchEventListener(function(target,type)
        if type == ccui.TouchEventType.ended then
            require("game.manager.TipsFrame")
            TipsFrame:create("称号系统未开放")
--        	local titleLayer = cc.Node
--        	titleLayer = TitleLayer:create()
--            SceneManager:getCurrentScene():addChild(titleLayer)
--        	UIManager:addUI(titleLayer,"titleLayer")
--            titleLayer:setPosition(self.origin.x + self.visibleSize.width / 2,self.origin.y + self.visibleSize.height / 2)
        end
    end)

    self.btn_close:addTouchEventListener(function(target,type)
        if type == ccui.TouchEventType.ended then
            zzc.RoleinfoController:closeLayer()
        end
    end)

    -- 拦截
    dxySwallowTouches(self)
end

function RoleinfoLayer:updateValue()

    local BASE = zzm.RoleinfoModel._arrRoleData.BASE
    
    self.txt_name:setString(BASE.Name)

    self.txt_level:setString(BASE.Lv)

    self.txt_power:setString(BASE.Power)
    
--    if BASE.Group ~= 0 then
--        self.txt_title:setString(BASE.Group)
--    else
--        self.txt_title:setString("")
--    end

    self.bar_exp:setPercent(BASE.Exp/BASE.NeedExp*100)
    self.txt_exp:setString(BASE.Exp.."/"..BASE.NeedExp)
    
    self.btn_rename:setVisible(false)
    self.btn_retitle:setVisible(false)
    
    if BASE.isGroup ~= 0 then
        self.txt_fairydoor:setString(BASE.Group)
    else
        self.txt_fairydoor:setString("未加入")
    end
    
    self.txt_attack:setString(BASE.Atk)
    self.txt_defense:setString(BASE.Def)
    self.txt_life:setString(BASE.Hp)
    self.txt_magic:setString(BASE.Mp)
    self.pic_head:setTexture(HeroConfig:getValueById(BASE.Pro)["IconRole"])
    self.pic_head:setVisible(true)
end

function RoleinfoLayer:MinePro()
    local role = zzm.CharacterModel:getCharacterData()
    local enCAT = enCharacterAttrType

    self.txt_name:setString(role:getValueByType(enCAT.NAME))
    self.txt_level:setString(role:getValueByType(enCAT.LV))
    self.txt_power:setString(role:getValueByType(enCAT.POWER))
    self.bar_exp:setPercent(role:getValueByType(enCAT.EXP) / role:getValueByType(enCAT.EXPUP) * 100)
    self.txt_exp:setString(role:getValueByType(enCAT.EXP).."/"..role:getValueByType(enCAT.EXPUP))
    self.txt_attack:setString(role:getValueByType(enCAT.ATK))
    self.txt_defense:setString(role:getValueByType(enCAT.DEF))
    self.txt_life:setString(role:getValueByType(enCAT.HP))
    self.txt_magic:setString(role:getValueByType(enCAT.MP))
    self.pic_head:setTexture(HeroConfig:getValueById(role:getValueByType(enCAT.PRO)).IconRole)
    if _G.GroupData.State == 1 then
        self.txt_fairydoor:setString(zzm.GroupModel.GroupData.Name)
    else
        self.txt_fairydoor:setString("未加入")
    end
    self.pic_head:setVisible(true)
    self.btn_rename:setVisible(true)
    self.btn_retitle:setVisible(false)
end

function RoleinfoLayer:updateRank(rank)
    if rank ~= 0 then
        self.txt_pk:setVisible(true)
        self._spNotyet:setVisible(false)
        self.txt_pk:setString(rank)
    else
        self.txt_pk:setVisible(false)
        self._spNotyet:setVisible(true)
    end
end

function RoleinfoLayer:WhenClose()
    --zzc.RoleinfoController:unregisterListenner()
    self:removeFromParent()
end