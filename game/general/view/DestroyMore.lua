DestroyMore = DestroyMore or class("DestroyMore",function()
    return cc.Node:create()
end)

function DestroyMore:ctor()
    self.visibleSize = cc.Director:getInstance():getVisibleSize()
    self.origin = cc.Director:getInstance():getVisibleOrigin()
    self._arrCB = {}
    self._curIncome = 0
end

function DestroyMore:create(num)
    local node = DestroyMore:new()
    node:initMore(num)
    return node
end

function DestroyMore:initMore(num)
    self._csb = cc.CSLoader:createNode("res/dxyCocosStudio/csd/ui/general/DestroyMore.csb")
    self:addChild(self._csb)
    self._csb:setPosition(self.origin.x + self.visibleSize.width / 2, self.origin.y + self.visibleSize.height / 2)

    dxySwallowTouches(self)
    
--    self._cbWhite = self._csb:getChildByName("cb_white")
--    self._cbGreen = self._csb:getChildByName("cb_green")
--    self._cbBlue = self._csb:getChildByName("cb_blue")
--    self._cbPurple = self._csb:getChildByName("cb_purple")
    self._income = self._csb:getChildByName("txt_num")
    for i=1,4 do
        self._arrCB[i] = self._csb:getChildByName("cb_"..i)
        if i == 4 or i == 3 then
            self._arrCB[i]:setSelected(false)
        else
            self._arrCB[i]:setSelected(true)
        end
        if self._arrCB[i]:isSelected() then
        	self:updateDestroyGet(i,"add")
        end
        self._arrCB[i]:addEventListener(function(target,type)
            if target:isSelected() then
                self:updateDestroyGet(i,"add")
            else
                self:updateDestroyGet(i,"cut")
            end
        end)
    end
    
    
    
    local _btnCancel = self._csb:getChildByName("btn_cancel")
    local _btnSure = self._csb:getChildByName("btn_sure")
    _btnCancel:addTouchEventListener(function(target,type)
        if type == 2 then
            SoundsFunc_playSounds(SoundsType.CLOSE_PAGE,false)
            self:removeFromParent()
        end
    end)
    _btnSure:addTouchEventListener(function(target,type)
        if type == 2 then
            SoundsFunc_playSounds(SoundsType.UNIVERSAL_BTN,false)
            local len = 0
            local data = {[1] = 0,[2]=0,[3]=0,[4]=0}
            
            for i=1,4 do
                if self._arrCB[i]:isSelected() then
                    data[i] = i
                    len = len + 1
                end
            end
            if len == 0 then
                TipsFrame:create("请选择需要分解的品质")                
            else
                zzm.GeneralModel:DestroyGeneralMore(data,num)
            end
            self:removeFromParent()
        end
    end)
end

function DestroyMore:updateDestroyGet(qua,str)
    for key, var in pairs(zzm.GeneralModel.Fragment) do
    	if var.Config.Quality == qua then
    	    if str == "add" then
                self._curIncome = self._curIncome + GodGeneralConfig:FragmentDestroyNum(var.Id) * var.Num
            elseif str == "cut" then
                self._curIncome = self._curIncome - GodGeneralConfig:FragmentDestroyNum(var.Id) * var.Num
            end
    	end
    end
    self._curIncome = self._curIncome < 0 and 0 or self._curIncome
    self._income:setString(self._curIncome)
end
