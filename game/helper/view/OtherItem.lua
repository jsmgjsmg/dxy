OtherItem = OtherItem or class("OtherItem",function()
    local path = "dxyCocosStudio/png/helper/frame.png"
    return ccui.Button:create(path,path,path)
end)

function OtherItem:create()
    local node = OtherItem:new()
    return node
end

function OtherItem:ctor()
	self._csb = nil
	
	self:initUI()
	self:initEvent()
end

function OtherItem:initUI()
	self._csb = cc.CSLoader:createNode("dxyCocosStudio/csd/ui/helper/OtherItem.csb")
	self:addChild(self._csb)
	
	self.icon = self._csb:getChildByName("Icon")
    self.txt_info = self._csb:getChildByName("infoTxt")
    self.txt_num = self._csb:getChildByName("numTxt")
    self.txt_num:setVisible(false)
    self.btn_go = self._csb:getChildByName("goBtn")
end

function OtherItem:initEvent()
	
end

function OtherItem:update(data)
	if not data then
		return
	end
	self.icon:loadTexture(data.Icon)
	self.txt_info:setString(data.Content)
	
	if data.Count == 1 then
	   self.txt_num:setVisible(true)
	   self:setNum(data)
	elseif data.Count == 2 then
        self.txt_num:setVisible(false)
	end
	
	self:setButton(data)
end

function OtherItem:setNum(data)
    local role = zzm.CharacterModel:getCharacterData()
    local enCAT = enCharacterAttrType
    
	if data.Id == 8 then   --招财
        self.txt_num:setString("("..zzm.RecruitMoneyModel.lucky_count.."/"..zzm.RecruitMoneyModel.lucky_limit..")")
	elseif data.Id == 9 then   --财神宝库
        self.txt_num:setString("("..role:getValueByType(enCAT.MONEYCOUNT).."/"..MoneySceneConfig:getBaseValueByKey("Number")..")")
	elseif data.Id == 10 then  --经验副本
        self.txt_num:setString("("..role:getValueByType(enCAT.TRAINEXPCOUNT).."/"..AutocephalyValueConfig:getValueByContent("TrainNumber")..")")
	end
end

function OtherItem:setButton(data)
    if self.btn_go then
        self.btn_go:addTouchEventListener(function(target,type)
            if type == 2 then
                SoundsFunc_playSounds(SoundsType.OPEN_PAGE,false)
                BUTTON_FUNCTION[data.Id]()              
                zzc.HelperController:closeLayer()
            end
        end)
    end
end