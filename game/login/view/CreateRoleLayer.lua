
CreateRoleLayer = CreateRoleLayer or class("CreateRoleLayer",function()
    return cc.Layer:create()
end)

function CreateRoleLayer.create()
    local layer = CreateRoleLayer.new()
    return layer
end

function CreateRoleLayer:ctor()
    self._csbNode = nil
    
    self.pro = 1

    self:initUI()
--    self:initEvent()
    dxyExtendEvent(self)
end

function CreateRoleLayer:initUI()
    self._csbNode = cc.CSLoader:getInstance():createNodeWithFlatBuffersFile("dxyCocosStudio/csd/ui/login/CreateRoleLayer.csb")
    self:addChild(self._csbNode)
    
    self.visibleSize = cc.Director:getInstance():getVisibleSize()
    self.origin = cc.Director:getInstance():getVisibleOrigin()

    local node = self._csbNode:getChildByName("RoleInfo")
    node:setPosition(cc.p(-self.visibleSize.width / 2 + self.origin.x,-self.visibleSize.height / 2 + self.origin.y))
    self.pic_name = node:getChildByName("namePic")
    self.txt_weapean = node:getChildByName("weapeanTxt")
    self.txt_point = node:getChildByName("pointTxt")
    self.txt_core = node:getChildByName("coreTxt")

    node = self._csbNode:getChildByName("RolePanel")
    node:setPositionX(self.visibleSize.width / 2 +self.origin.x)
    self.btn_start = node:getChildByName("FinshCreate")
    self.ckb_role_1 = node:getChildByName("BtnNode"):getChildByName("head_1"):getChildByName("CheckBox")
    self.ckb_role_2 = node:getChildByName("BtnNode"):getChildByName("head_2"):getChildByName("CheckBox")
    self.ckb_role_3 = node:getChildByName("BtnNode"):getChildByName("head_3"):getChildByName("CheckBox")
    
    self.input_name = self._csbNode:getChildByName("RoleNameBG"):getChildByName("TextField")
    self.btn_randName = self._csbNode:getChildByName("RoleNameBG"):getChildByName("RandName")
    
    node = self._csbNode:getChildByName("backNode")
    node:setPosition(cc.p(-self.visibleSize.width / 2 +self.origin.x,self.visibleSize.height / 2 +self.origin.y))
    self.btn_back = node:getChildByName("Back")
    
    node = self._csbNode:getChildByName("RoleNode")
    self.RoleImage = node:getChildByName("RoleImage")
    self.leftShadow = node:getChildByName("leftShadow")
    self.rightShadow = node:getChildByName("rightShadow")
    
    
    math.randomseed(os.time())
    self:selectType(1)
    
end

function CreateRoleLayer:removeEvent()
--    if self.action_1 then
--        self.action_1:removeFromParent()
--        self.action_1 = nil
--    end
--
--    if self.action_2 then
--        self.action_2:removeFromParent()
--        self.action_2 = nil
--    end
end

function CreateRoleLayer:initEvent()
    if(self.btn_start)then
        self.btn_start:addTouchEventListener(function(target,type)
            if(type==2)then
                --zzc.LoginController:enterMainScene()
                local name = self.input_name:getString()
                if not name or name == "" then
                    TipsFrame:create("角色名字不能为空")
                    SoundsFunc_playSounds(SoundsType.FAILE_TO_USE,false)
                    --print("角色名字不能为空")
                    return
                end
                if self:utfstrlen(self.input_name:getString()) > 12 then
                    TipsFrame:create("角色名字非法长度")
                    SoundsFunc_playSounds(SoundsType.FAILE_TO_USE,false)
                    return
                end
                
                if not self:checkName(name) then
                    TipsFrame:create("角色名字含非法符号")
                    SoundsFunc_playSounds(SoundsType.FAILE_TO_USE,false)
                    return
                end
                --self.pro = 1
                SoundsFunc_playSounds(SoundsType.OPEN_PAGE,false)
                zzc.LoginController:request_CreateRole({name = name, pro = self.pro})
            end
        end)
    end

    if(self.btn_back)then
        self.btn_back:addTouchEventListener(function(target,type)
            if(type==2)then
                SoundsFunc_playSounds(SoundsType.CLOSE_PAGE,false)
                zzc.LoginController:enterLayer(LoginLayerType.SeclectRoleLayer)
            end
        end)
    end
    
    
    if self.btn_randName then
        self.btn_randName:addTouchEventListener(function(target,type)
            if(type==2)then
                SoundsFunc_playSounds(SoundsType.UNIVERSAL_BTN,false)
                self:randName()
            end
        end)
    end
    
    self.ckb_role_1:addEventListener(function(target,type)
        if type == ccui.CheckBoxEventType.selected then
            SoundsFunc_playSounds(SoundsType.UNIVERSAL_BTN,false)
            print("点击角色1")
            self:selectType(1)
            self:isOpenRole(true)
        end
    end)
    
    self.ckb_role_2:addEventListener(function(target,type)
        if type == ccui.CheckBoxEventType.selected then
            SoundsFunc_playSounds(SoundsType.UNIVERSAL_BTN,false)
            print("点击角色2")
            self:selectType(2)
            self:isOpenRole(true)
        end
    end)
        
    self.ckb_role_3:addEventListener(function(target,type)
        if type == ccui.CheckBoxEventType.selected then
            SoundsFunc_playSounds(SoundsType.UNIVERSAL_BTN,false)
            print("点击角色3")
            self:selectType(3) 
            self:isOpenRole(true)
        end
    end)
    
end

function CreateRoleLayer:selectType(type)    
	self.ckb_role_1:setTouchEnabled(true)
    self.ckb_role_2:setTouchEnabled(true)
    self.ckb_role_3:setTouchEnabled(true)

    if type == 1 then
        self.ckb_role_1:setTouchEnabled(false)
        self.ckb_role_1:setSelected(true)
        self.ckb_role_2:setSelected(false)
        self.ckb_role_3:setSelected(false)
    elseif type == 2 then
        self.ckb_role_2:setTouchEnabled(false)
        self.ckb_role_2:setSelected(true)
        self.ckb_role_1:setSelected(false)
        self.ckb_role_3:setSelected(false)
    elseif type == 3 then
        self.ckb_role_3:setTouchEnabled(false)
        self.ckb_role_3:setSelected(true)
        self.ckb_role_1:setSelected(false)
        self.ckb_role_2:setSelected(false)
    end 
    
    --self.pro = 2--HeroConfig:getValueById(type)["Job"]
    self.pro = HeroConfig:getValueById(type)["Job"]
    
    self:randName()
    
    self:setInfo(type)
end

function CreateRoleLayer:isOpenRole(falg)
    if not falg then 	
	   TipsFrame:create("暂未开放创建")
       self:selectType(1)
    end
end

function CreateRoleLayer:randName()
    local sex = NameConfig:getTypeById(HeroConfig:getValueById(self.pro)["Id"])
    local name = NameConfig:randGetFirstName()..NameConfig:randGetNameBySex(sex)
    self.input_name:setString(name)
end

function CreateRoleLayer:setInfo(type)

    self.RoleImage:removeAllChildren()

	local data = HeroConfig:getValueById(type)
	
    local boneName_1 = data["CreateBone"]
    self.action_1 = mc.SkeletonDataCash:getInstance():createWithCashName(boneName_1)
--    self.action_1 = sp.SkeletonAnimation:create(boneName_1..".json", boneName_1..".atlas")
    self.action_1:addAnimation(1,"start", false)
    self.action_1:addAnimation(1,"ready", true)
    self.action_1:setPosition(0,0)
    self.RoleImage:addChild(self.action_1)

    local boneName_2 = data["BoneEffect"]
    self.action_2 = mc.SkeletonDataCash:getInstance():createWithCashName(boneName_2)
--    self.action_2 = sp.SkeletonAnimation:create(boneName_2..".json", boneName_2..".atlas")
    self.action_2:setBlendFunc({src = gl.SRC_ALPHA,dst = gl.ONE})
    self.action_2:addAnimation(1,"start", false)
    self.action_2:addAnimation(1,"ready", true)
    self.action_2:setPosition(0,0)
    self.action_1:addChild(self.action_2)
	
	self.pic_name:setTexture(data["NameIcon"])
	
    self.leftShadow:setTexture(data["BgLeft"])
    self.rightShadow:setTexture(data["BgRight"])
	
	self.txt_weapean:setString(data["Weapon"])
	self.txt_point:setString(data["Trait"])
	self.txt_core:setString(data["Core"])
	
	self:heroSound(data["Job"])
end

function CreateRoleLayer:heroSound(pro)
	if pro == 1 then
--       SoundsFunc_playSounds(SoundsType.XZ_SOUND,false)
        cc.SimpleAudioEngine:getInstance():playEffect(SoundsType.XZ_SOUND,false)
	elseif pro == 2 then
--       SoundsFunc_playSounds(SoundsType.HY_SOUND,false)
        cc.SimpleAudioEngine:getInstance():playEffect(SoundsType.HY_SOUND,false)
	elseif pro == 3 then
--       SoundsFunc_playSounds(SoundsType.LQ_SOUND,false)
        cc.SimpleAudioEngine:getInstance():playEffect(SoundsType.LQ_SOUND,false)
	end
end

function CreateRoleLayer:enterGame()

end

--计算字符串的长度
-- @param str
-- @return byteCount
function CreateRoleLayer:utfstrlen(str)
    local list = self:sLen(str)
    local byteCount = 0
    
    for key, var in pairs(list) do
    	if string.byte(var) > 127 then
    		byteCount = byteCount + 2
    	else
    	   byteCount = byteCount + 1
    	end
    end
    return byteCount
end

--遍历字符串返回数组
function CreateRoleLayer:sLen(str)
    local len  = #str
    local left = 0
    local arr  = {0, 0xc0, 0xe0, 0xf0, 0xf8, 0xfc}
    local t = {}
    local start = 1
    local wordLen = 0
    while len ~= left do
        local tmp = string.byte(str, start)
        local i   = #arr
        while arr[i] do
            if tmp >= arr[i] then
                break
            end
            i = i - 1
        end
        wordLen = i + wordLen
        local tmpString = string.sub(str, start, wordLen)
        start = start + i
        left = left + i
        t[#t + 1] = tmpString
    end
    return t
end

--检查名字合法性
function CreateRoleLayer:checkName(name)
    local list = self:sLen(name)
	local chineseList = {}
	local englisthList = {}
	local i = 1
	local j = 1
    local curByte = nil
    for key, var in pairs(list) do
        curByte = string.byte(var)
        if curByte>0 and curByte<=127 then
            englisthList[j] = var
            j = j + 1
        elseif curByte>=192 and curByte<223 then
            chineseList[i] = var
            i = i + 1
        elseif curByte == 223 then
            englisthList[j] = var
            j = j + 1
        elseif curByte>=224 and curByte<226 then
            chineseList[i] = var
            i = i + 1  
        elseif curByte >= 226 and curByte <= 227 then
            englisthList[j] = var
            j = j + 1
        elseif curByte > 227 and curByte < 239 then
            chineseList[i] = var
            i = i + 1 
        elseif curByte == 239 then
            englisthList[j] = var
            j = j + 1
        elseif curByte>=240 and curByte<=247 then
            chineseList[i] = var
            i = i + 1
        end
    end
    
    if #englisthList == 0 then
        return true
    end

    local result = nil
    for key, var in pairs(englisthList) do
        result = string.find(var,"[%W%s]")
        if result then
        	return false
        end
    end
    
    return true
end