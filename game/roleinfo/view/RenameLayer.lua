RenameLayer = RenameLayer or class("RenameLayer",function()
	return cc.Layer:create()
end)

function RenameLayer:create()
	local layer = RenameLayer:new()
	return layer
end

function RenameLayer:ctor()
    self.txt_name = ccui.TextField
    self.editBox_name = ccui.EditBox

    self.btn_dice = ccui.Button
    self.btn_confirm = ccui.Button
    self.btn_close = ccui.Button
    
	self:initUI()
	self:initEvent()
end

function RenameLayer:initUI()
	local renameLayer = cc.CSLoader:createNode("dxyCocosStudio/csd/ui/roleinfo/renameLayer.csb")
	self:addChild(renameLayer)
	
	self.txt_name = renameLayer:getChildByName("nameTxt")
	
	self.btn_dice = renameLayer:getChildByName("diceBtn")
	self.btn_confirm = renameLayer:getChildByName("confirmBtn")
	self.btn_close = renameLayer:getChildByName("closeBtn")
	
	self.txt_rmb = renameLayer:getChildByName("2_Txt")
	
	local box_posX,box_poxY = self.txt_name:getPosition()
	
    self.editBox_name = ccui.EditBox:create(cc.size(220,42),ccui.Scale9Sprite:create("dxyCocosStudio/png/roleinfo/rename/editbox.png"))
    self.editBox_name:setFontName("dxyCocosStudio/font/MicosoftBlack.ttf")
	self.editBox_name:setFontSize(20)
	self.editBox_name:setFontColor(cc.c3b(0,255,197))
	self.editBox_name:setPlaceHolder("输入新角色名")
	self.editBox_name:setPlaceholderFontColor(cc.c3b(255,255,255))
	self.editBox_name:setMaxLength(12)
	self.editBox_name:setReturnType(cc.KEYBOARD_RETURNTYPE_DONE)
    self.editBox_name:setPosition(box_posX,box_poxY)
	
	self:addChild(self.editBox_name)
end

function RenameLayer:initEvent()

    self.txt_rmb:setString(AutocephalyValueConfig:getValueByContent("AlterName").."元宝")

    self.btn_dice:addTouchEventListener(function(target,type)
        if type == ccui.TouchEventType.ended then
        	local role = zzm.CharacterModel:getCharacterData()
            local enCAT = enCharacterAttrType 
            
            local sex = NameConfig:getTypeById(HeroConfig:getValueById(role:getValueByType(enCAT.PRO))["Id"])
            local name = NameConfig:randGetFirstName()..NameConfig:randGetNameBySex(sex)
            self.editBox_name:setText(name)
        end
    end)

    self.btn_confirm:addTouchEventListener(function(target,type)
        if type == ccui.TouchEventType.ended then
--            print("确定改名")
            require("game.manager.TipsFrame")
--            TipsFrame:create("未开放改名")
            local name = self.editBox_name:getText()
            if not name or name == "" then
                TipsFrame:create("角色名字不能为空")
                return
            end
            if self:utfstrlen(name) > 12 then
                TipsFrame:create("角色名字非法长度")
                return
            end
            
            if not self:checkName(name) then
                TipsFrame:create("角色名字含非法符号")
                return
            end
            zzc.RoleinfoController:request_Rename(name)
            UIManager:closeUI("renameLayer")
            
        end
    end)
    
    self.btn_close:addTouchEventListener(function(target,type)
        if type == ccui.TouchEventType.ended then
            UIManager:closeUI("renameLayer")
        end
    end)

    -- 拦截
    dxySwallowTouches(self)

end

function RenameLayer:WhenClose()
    self:removeFromParent()
end

--计算字符串的长度
-- @param str
-- @return byteCount
function RenameLayer:utfstrlen(str)
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
function RenameLayer:sLen(str)
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
function RenameLayer:checkName(name)
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
