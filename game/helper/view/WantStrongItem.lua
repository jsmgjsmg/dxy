WantStrongItem = WantStrongItem or class("WantStrongItem",function()
    local path = "dxyCocosStudio/png/helper/frame.png"
    return ccui.Button:create(path,path,path)
end)

function WantStrongItem:create()
    local node = WantStrongItem:new()
    return node
end

function WantStrongItem:ctor()
	self._csb = nil
	
	self:initUI()
	self:initEvent()
end

function WantStrongItem:initUI()
    self._csb = cc.CSLoader:createNode("dxyCocosStudio/csd/ui/helper/WantStrongItem.csb")
    self:addChild(self._csb)
    
    self.icon = self._csb:getChildByName("Icon")
    self.txt_info = self._csb:getChildByName("infoTxt")
    self.bar_power = self._csb:getChildByName("powerLoadingBar")
    self.exp_frame = self._csb:getChildByName("exp_frame")
    self.bar_power:setVisible(false)
    self.exp_frame:setVisible(false)
    self.btn_go = self._csb:getChildByName("goBtn")
end

function WantStrongItem:initEvent()
	
end

function WantStrongItem:update(data)
    if not data then
        return
    end
    self.icon:loadTexture(data.Icon)
    self.txt_info:setString(data.Content)
    
    --当前系统战力
    local curFunPower = 2000000
    
    local role = zzm.CharacterModel:getCharacterData()
    local enCAT = enCharacterAttrType
    --当前推荐战力
    local curMaxPower = HelperConfig:getBasePowerByIdLv(data.Id,role:getValueByType(enCAT.LV)) * HelperConfig:getRatioByVipLv(_G.RoleData.VipLv)
    
    self.bar_power:setPercent(curFunPower / curMaxPower * 100)
    
    self:setButton(data)
end

function WantStrongItem:setButton(data)
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