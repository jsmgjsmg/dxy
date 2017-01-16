local GuideModel = class("GuideModel")
GuideModel.__index = GuideModel

function GuideModel:ctor()
    self:initModel()
end

function GuideModel:initModel()
    self.newFunction = luacf.Guide.GuideConfig.NewFunctionConfig.NewFunction
    self.guideGroup = luacf.Guide.GuideConfig.GuideGroupConfig.GuideGroup
    self.openFunction = {}
    self.openNewFunction = {}
    self._currentOKGuideID = 0
    self._currentGuideData = nil
    self.startNewGuide = false
    self._currentCopyId = nil
    self._newOpenCopy = false
    self._isCheckPos = false
    self._isNoTalk = false
	self._isFightGuideOver = false
	
	self._isNeedToEnd = false
end

--判断是否开始新手引导
function GuideModel:IsStartGuide()
    if self._currentGuideData then
        if self._currentGuideData.GuideSartType == self._currentCopyId then
            --print("Error -----> " .. self._currentCopyId)
            --print(self._newOpenCopy)
            --print(SceneManager.m_curSceneName)
            if self._newOpenCopy and SceneManager.m_curSceneName == "mainScene" or SceneManager.m_curSceneName == "MainScene" then
                return true
            end
            if SceneManager.m_curSceneName == "GameScene" then
                if self._isNoTalk == true then
                	return true
                elseif self._isNoTalk == false then
                    return SceneManager._EndTalk
                end
            end
    	end
		--print(SceneManager.m_curSceneName)
        if SceneManager.m_curSceneName == "mainScene" or SceneManager.m_curSceneName == "MainScene" then
		--print(self._currentGuideData.ButtonName)
            if self._currentGuideData.ButtonName ~= nil then
                local  isOpen = zzm.GuideModel:isOpenFunctionByType(self._currentGuideData.ButtonName)
				return isOpen
            end
        end
    end
    return false
end

--服务器下发已完成的新手ID，设置当前正在进行的新手数据
function GuideModel:setCurrentGuideID(_guideId)
    print("Error                         setCurrentGuideID  " .. _guideId)
    self._currentOKGuideID = _guideId
    self:setCurrentGuide(_guideId+1)
end

--前端完成一组新手设置，设置ID和数据
function GuideModel:setNextGuideID()
    self._currentOKGuideID = self._currentOKGuideID + 1
    print("setNextGuideID                         setCurrentGuideID  " .. self._currentOKGuideID)
    self:setCurrentGuide(self._currentOKGuideID+1)
end

function GuideModel:getCurrentGuideID()
    return self._currentOKGuideID
end

--根据新手ID，设置当前进行新手的引导数据
function GuideModel:setCurrentGuide(guideID) 
    for key, var in ipairs(self.guideGroup) do
        if var.GuideId == guideID then
    		self._currentGuideData = var
    		return
        end
    end
    self._currentGuideData = nil
end

function GuideModel:getCurrentGuide()
    return self._currentGuideData
end

--根据副本进度设置新功能开始
function GuideModel:setOpenCopy(_type, _funcId)
    if _type == 1 then
        array_addObject(self.openFunction, _funcId)
    elseif _type == 2 then
        array_addObject(self.openFunction, _funcId)
        array_addObject(self.openNewFunction, _funcId)
    else
        print("error type")
    end
end

--判断新功能是否开启ButtonName
function GuideModel:isOpenFunctionByType(_type)
    local data = self:getFunctionTipsByType(_type)
--    print("Error --------------------- type -> " .. _type)
    if data then
--    print("Error --------------------- type -> " ..  data.Id)
        if( array_findObject(self.openFunction, data.Id) ~= 0 )then
            return true
        end
    end
    return false
end

--获取下一个新功能
function GuideModel:getNextOpenFunction()
    local maxFuncId = 0
    for key, id in pairs(self.openFunction) do
        if id > maxFuncId then
            maxFuncId = id
    	end
    end
    local nextFuncId = maxFuncId + 1
    local data = self:getFunctionTipsById(nextFuncId)
    return data
end

--判断新功能是否开启/ID
function GuideModel:isOpenFunctionById(_funcId)
    if( array_findObject(self.openFunction, _funcId) ~= 0 )then
        return true
    end
    return false
end

--获取新功能数据
function GuideModel:getFunctionTipsByType(_type)
    for key, var in ipairs(self.newFunction) do
        if var.ButtonName == _type then
    		return var
    	end
    end
    return nil
end

function GuideModel:getFunctionTipsById(funcId)
    for key, var in ipairs(self.newFunction) do
        if var.Id == funcId then
            return var
        end
    end
    return nil
end

function GuideModel:isOpenFunctionByCopyId(_copyId)
    for key, var in ipairs(self.newFunction) do
        if var.CopyId == _copyId then
            return true
        end
    end
    return false
end

return GuideModel