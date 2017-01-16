NewFunctionConfig = NewFunctionConfig or class("NewFunctionConfig")

function NewFunctionConfig:getNewFuncRewards(id)
    local list = luacf.NewFunction.NewFunctionConfig.NewFunction
    if list[id] then
        return list[id]
    end
end

--获取特殊引导
function NewFunctionConfig:getSpecialConfig()
	local list = luacf.GuideScene.GuideSceneConfig.Deal
	
	if #list ~= 0 then
		return list
	end
	
	return nil
end