--名字配置表
NameConfig = {
}

--通过角色ID获取性别
function NameConfig:getTypeById(id)
	local list = luacf.Name.NameConfig.TypeGroup.NameType
    for key, var in pairs(list) do
		if var.Id == id then
			return var.Type
		end
	end
	return nil
end

--随机获取性
function NameConfig:randGetFirstName()
	local list = luacf.Name.NameConfig.MatchGroup.NameMatch.FamilyName
    --math.randomseed(os.time())
    local num = math.random(1,#list)
    return list[num]["Family"]
end

--通过性别随机获取名
function NameConfig:randGetNameBySex(sex)
    local list = luacf.Name.NameConfig.MatchGroup.NameMatch.Name
    --math.randomseed(os.time())
    local num = math.random(1,#list)
    if sex == 1 then
        return list[num]["ManName"]
    else
        return list[num]["WomanName"]
    end
end