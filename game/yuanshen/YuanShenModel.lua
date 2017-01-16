local YuanShenModel = YuanShenModel or class("YuanShenModel")

function YuanShenModel:ctor()
    self._arrYuanShen = {}
    self._arrMagic = {}
    self._arrTips = {}
    self._arrStone = {}
end

--初始化法器
function YuanShenModel:initMagic(data)
    table.insert(self._arrMagic,data)
end

--更新法器
function YuanShenModel:changeMagic(data)

end

--获取元神
function YuanShenModel:getYuanShen()
    return self._arrYuanShen
end

--获取法器
function YuanShenModel:getMagic()
	return self._arrMagic
end

function YuanShenModel:getMagicById(id)
    for key, var in pairs(self._arrMagic) do
    	if var.Id == id then
    	    return var
    	end
    end
end

--提示延迟
function YuanShenModel:TipsSchedule(tips)
    cn:TipsSchedule(tips)
end

---技能石
function YuanShenModel:initStone(data)
    table.insert(self._arrStone,data)
end

return YuanShenModel