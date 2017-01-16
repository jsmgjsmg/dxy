--特殊数值配置表

AutocephalyValueConfig = {
}

function AutocephalyValueConfig:getValueByContent(content)
	local list = luacf.AutocephalyValue.AutocephalyValueConfig.content
    for key, var in pairs(list) do
		if var.content == content then
			return var.Value
		end
	end
	return nil
end