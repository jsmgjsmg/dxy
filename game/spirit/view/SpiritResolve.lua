SpiritResolve = SpiritResolve or class("SpiritResolve",function()
    return cc.Layer:create()
end)

function SpiritResolve:create()
    local layer = SpiritResolve:new()
    return layer
end

function SpiritResolve:ctor()
    self._csbNode = nil
    
    self.txt_reiki = nil
    
    self.btn_close = ccui.Button
    self.btn_confirm = ccui.Button
    
    self.ckbList = {}
    
    self.m_data = {}
--    self.m_data.typelen = 0
    self.m_data.typeList ={}

    self:initUI()
    self:initEvent()
--    dxyExtendEvent(self)
end

function SpiritResolve:initUI()
    self._csbNode = cc.CSLoader:createNode("dxyCocosStudio/csd/ui/spirit/spiritResolve.csb")
    self:addChild(self._csbNode)
    
    self.txt_reiki = self._csbNode:getChildByName("reikiTxt")

    self.btn_close = self._csbNode:getChildByName("closeBtn")
    self.btn_confirm = self._csbNode:getChildByName("confirmBtn")

    local infoNode = self._csbNode:getChildByName("infoNode")
    for index=1,5 do
        self.ckbList[index] = infoNode:getChildByName("ckb_"..index)
        if index < 4 then
        	self.ckbList[index]:setSelected(true)
        end
    end
end

function SpiritResolve:initEvent()

    for index=1,5 do
        if self.ckbList[index]:isSelected() == true then
            self:setCkbState(index,true)
        else
            self:setCkbState(index,false)
        end
    end

--    self:reset()

    -- 拦截
    dxySwallowTouches(self)
    
--    self.txt_reiki:setString(0)

    self.btn_close:addTouchEventListener(function(target,type)
        if type == 2 then
            self:removeFromParent()
        end
    end)

    self.btn_confirm:addTouchEventListener(function(target,type)
        if type == 2 then
            SoundsFunc_playSounds(SoundsType.RESOLVE_SPIRIT,false)
            if tonumber(self.txt_reiki:getString()) ~= 0 then
                for index=1, #self.m_data.typeList do               	
                    zzm.TalkingDataModel:onEvent(EumEventId.SPIRIT_RESOLVE,{})
                end
                zzc.CharacterController:request_Resolve(self.m_data)         
                self:removeFromParent()
            else
                SoundsFunc_playSounds(SoundsType.FAILE_TO_USE,false)
                TipsFrame:create("没有该品质的器灵!")
            end
        end
    end)
    for index=1,5 do
        self.ckbList[index]:addEventListener(function(target,type)
            if type == ccui.CheckBoxEventType.selected then
                self:setCkbState(index,true)
            else
                self:setCkbState(index,false)
            end
        end)
    end
end

function SpiritResolve:removeEvent()
	
end

function SpiritResolve:setCkbState(index,flag)
	if flag then
--        self.m_data.typelen = self.m_data.typelen + 1
        table.insert(self.m_data.typeList,#self.m_data.typeList+1,index)
    else
--        self.m_data.typelen = self.m_data.typelen - 1
        for key, var in pairs(self.m_data.typeList) do
        	if var == index then
                table.remove(self.m_data.typeList,key)
                break
        	end
        end
	end
	table.sort(self.m_data.typeList)
	self:setReiki()
end

function SpiritResolve:setReiki()
    local _reiki = 0
    local baseRate = zzm.SpiritModel:getResolveBaseRate()
	local spiritList = zzm.CharacterModel:getSpiritList()
    for key1,type in pairs(self.m_data.typeList) do
        for key2,spirit in pairs(spiritList) do
            if type == spirit.config.Quality and spirit.lv == 0 then
                _reiki = _reiki + math.ceil(baseRate * (zzm.SpiritModel:findCoefficientByLv(spirit.config.Lv)) *(zzm.SpiritModel:findCoefficientByQuality(type)))
			end
		end
	end
    self.txt_reiki:setString(_reiki)
end

function SpiritResolve:reset()
    for index=1,5 do
        self.ckbList[index]:setSelected(false)
    end
    self.m_data.typeList = {}
    self.m_data.typelen = 0
end
