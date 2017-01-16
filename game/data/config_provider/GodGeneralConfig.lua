GodGeneralConfig = GodGeneralConfig or class("GodGeneralConfig")
GodGeneralConfig.ThreeQE = (function()
    local list = luacf.GodGenerals.GodGeneralsConfig.GodGeneralsGroup.GodGenerals
    for i=1,#list do
        if list[i].Quality > 2 then
            return i - 1
        end
    end
end)()

---封神台--------------------------------------------------------------

--获取封神台等级上限
function GodGeneralConfig:getStageLvMax()
    return #luacf.GodGenerals.GodGeneralsConfig.GodsTaiGroup.GodsTai-1
end

--获取封神台升级所需
function GodGeneralConfig:getUpGradeNeed(lv)
    if lv >= #luacf.GodGenerals.GodGeneralsConfig.GodsTaiGroup.GodsTai-1 then
        lv = #luacf.GodGenerals.GodGeneralsConfig.GodsTaiGroup.GodsTai-1
    end
    local list = luacf.GodGenerals.GodGeneralsConfig.GodsTaiGroup.GodsTai
    local data = {}
    for key, var in pairs(list) do
    	if var.Lv == lv then
            data["Exp"] = var.Exp
            data["MuhonConsume"] = var.MuhonConsume 
            data["GoldConsume"] = var.GoldConsume 
            return data
    	end
    end
end

--获取封神台按钮变换
function GodGeneralConfig:getStateBtnChange(lv)
    local list = dxyConfig_toList(luacf.GodGenerals.GodGeneralsConfig.GodsTaiGroup.Absorb)
    local num = 1
    for i=1,#list do
        if list[i].Lv <= lv then
            num = list[i].Num
        end 
    end
    return num
end

--获取封神台等级属性
function GodGeneralConfig:getProByLv(lv)
    if lv >= #luacf.GodGenerals.GodGeneralsConfig.GodsTaiGroup.GodsTai-1 then
        lv = #luacf.GodGenerals.GodGeneralsConfig.GodsTaiGroup.GodsTai-1
    end
    local list = luacf.GodGenerals.GodGeneralsConfig.GodsTaiGroup.GodsTai
    for key, var in pairs(list) do
    	if var.Lv == lv then
            local data = {}
            data.Atk = var.Atk
            data.Def = var.Def
            data.Hp = var.Hp
            return data
        end
    end    
end

--获取进入副本体力消耗
function GodGeneralConfig:getPowerNeed()
    return luacf.Power.PowerConfig.GodConfig.Base.Consume
end



---NEW-----------------------------------------------

function GodGeneralConfig:getBaseAttribute(qua,star)
    local list = luacf.GodGenerals.GodGeneralsConfig.GodGeneralsGroup.BaseAttribute
    local addData = {}
    local Factor = 0
    for key, var in pairs(list.QualityFactor) do
    	if var.Quality == qua and star == var.Star then
            Factor = var.Factor/10000
    	end
    end
    
    addData.addAtk = list.Base.Atk
    addData.addDef = list.Base.Def
    addData.addHp = list.Base.Hp
    addData.addFactor = Factor
    
    return addData

end




---封神榜-----------------------------------------------------------------
--获取整个神将表
function GodGeneralConfig:getGeneralConfig()
    local list = luacf.GodGenerals.GodGeneralsConfig.GodGeneralsGroup.GodGenerals
    local data = {}
    for i=self.ThreeQE+1,#list do
        table.insert(data,list[i])
    end
    return data
end

--通过Key获取神将
function GodGeneralConfig:getGeneralByKey(i)
    return luacf.GodGenerals.GodGeneralsConfig.GodGeneralsGroup.GodGenerals[i+self.ThreeQE]
end

function GodGeneralConfig:getGeneralById(id,type)
    local list = luacf.GodGenerals.GodGeneralsConfig.GodGeneralsGroup.GodGenerals
    for key, var in pairs(list) do
        if type == 1 then
        	if var.Id == id then
        	    return var
        	end
         elseif type == 2 then
            if var.ChipId == id then
                return var
            end
         end
    end
end

--通过神将ID获取碎片ID
function GodGeneralConfig:GIDtoFID(id)
    local general = luacf.GodGenerals.GodGeneralsConfig.GodGeneralsGroup.GodGenerals
    for i,target in pairs(general) do
        if target.Id == id then
            return target.ChipId
        end
    end
end

--通过碎片ID获取神将ID
function GodGeneralConfig:FIDtoGID(id)
    local general = luacf.GodGenerals.GodGeneralsConfig.GodGeneralsGroup.GodGenerals
    local Quality = 0
    for i,target in pairs(general) do
        if target.ChipId == id then
            return target.Id
        end
    end
end

--获取封神背包个数
function GodGeneralConfig:getBoxNum()
    return luacf.GodGenerals.GodGeneralsConfig.StarGroup.UpStar.BaseGroup.Fengshen
end

--获取背景颜色
--type == 1 神将
--type == 2 碎片
function GodGeneralConfig:getMsgColour(id,type)
    local list = luacf.GodGenerals.GodGeneralsConfig.GodGeneralsGroup.GodGenerals
    local Quality = nil
    local Colour = nil
    for key, var in pairs(list) do
        if type == 1 then
            if var.Id == id then
                Quality = var.Quality
                break
            end    
        elseif type == 2 then
            if var.ChipId == id then
                Quality = var.Quality
                break
            end
        end
    end
    
    local list2 = luacf.GodGenerals.GodGeneralsConfig.GodGeneralsGroup.QualityFloor
    for key, var in pairs(list2) do
    	if var.Quality == Quality then
            return var
    	end
    end
end

--获取神将属性
function GodGeneralConfig:getGeneralPro(id,star)
    local GodGeneralsGroup = luacf.GodGenerals.GodGeneralsConfig.GodGeneralsGroup.GodGenerals
    local Type = nil
    local Quality = nil
    for key, var in pairs(GodGeneralsGroup) do
    	if var.Id == id then
    	   Type = var.Type
    	   Quality = var.Quality
    	   break
    	end
    end
    
    local UpStar = luacf.GodGenerals.GodGeneralsConfig.StarGroup.UpStar
    local Base = UpStar.BaseGroup.Base
    
    local TypeGroup = UpStar.TypeGroup
    local percent = {}
    for key, var in pairs(TypeGroup) do
    	if var.Type == Type then
    	   percent["Atk"] = var.Atk
    	   percent["Def"] = var.Def
    	   percent["Hp"] = var.Hp
    	   break
    	end
    end
    
    local QualityFactor = UpStar.Factor.QualityFactor
    local Factor = nil
    local Num = nil
    for key, var in pairs(QualityFactor) do
    	if var.Quality == Quality then
    	    Factor = var.Factor
    	    Num = var.Num
    	    break
    	end
    end
    
    local StarFactor = UpStar.Factor.StarFactor
    local Star = nil
    for key, var in pairs(StarFactor) do
    	if var.Star == star then
    	   Star = var.Factor
    	   break
    	end
    end
    
    local data = {}
    data["Atk"] = Base*Star*Factor*Type*percent["Atk"]/Num
    data["Def"] = Base*Star*Factor*Type*percent["Def"]/Num
    data["Hp"] = Base*Star*Factor*Type*percent["Hp"]/Num
    
    return data
end

--获取碎片属性
function GodGeneralConfig:getFragmentPro(chipId,star)
    local GodGeneralsGroup = luacf.GodGenerals.GodGeneralsConfig.GodGeneralsGroup.GodGenerals
    local Type = nil
    local Quality = nil
    for key, var in pairs(GodGeneralsGroup) do
        if var.ChipId == chipId then
    	   Type = var.Type
    	   Quality = var.Quality
    	   break
    	end
    end
    
    local UpStar = luacf.GodGenerals.GodGeneralsConfig.StarGroup.UpStar
    local Base = UpStar.BaseGroup.Base
    
    local TypeGroup = UpStar.TypeGroup
    local percent = {}
    for key, var in pairs(TypeGroup) do
    	if var.Type == Type then
    	   percent["Atk"] = var.Atk
    	   percent["Def"] = var.Def
    	   percent["Hp"] = var.Hp
    	   break
    	end
    end
    
    local QualityFactor = UpStar.Factor.QualityFactor
    local Factor = nil
    local Num = nil
    for key, var in pairs(QualityFactor) do
    	if var.Quality == Quality then
    	    Factor = var.Factor
    	    Num = var.Num
    	    break
    	end
    end
    
    local StarFactor = UpStar.Factor.StarFactor
    local Star = nil
    for key, var in pairs(StarFactor) do
    	if var.Star == star then
    	   Star = var.Factor
    	   break
    	end
    end
    
    local data = {}
    data["Atk"] = Base*Star*Factor*Type*percent["Atk"]/Num
    data["Def"] = Base*Star*Factor*Type*percent["Def"]/Num
    data["Hp"] = Base*Star*Factor*Type*percent["Hp"]/Num
    
    return data
end

--通过碎片获取名字
function GodGeneralConfig:getNameByFID(id)
    local general = luacf.GodGenerals.GodGeneralsConfig.GodGeneralsGroup.GodGenerals
    for i,target in pairs(general) do
        if target.ChipId == id then
            return target.Name
        end
    end
end

--通过神将获取名字
function GodGeneralConfig:getNameByGID(id)
    local general = luacf.GodGenerals.GodGeneralsConfig.GodGeneralsGroup.GodGenerals
    local Quality = 0
    for i,target in pairs(general) do
        if target.Id == id then
            return target.Name
        end
    end
end

--获取神将介绍
function GodGeneralConfig:getGeneralInt(id)
    local general = luacf.GodGenerals.GodGeneralsConfig.GodGeneralsGroup.GodGenerals
    local Quality = 0
    for i,target in pairs(general) do
        if target.Id == id then
            return target.Introduction
        end
    end
end

--获取碎片介绍
function GodGeneralConfig:getFragmentInt(id)
    local general = luacf.GodGenerals.GodGeneralsConfig.GodGeneralsGroup.GodGenerals
    local Quality = 0
    for i,target in pairs(general) do
        if target.ChipId == id then
            return target.Introduction
        end
    end
end

--获取神将属性
function GodGeneralConfig:getFragmentShopPro(i)
    return luacf.GodGenerals.GodGeneralsConfig.GodGeneralsGroup.GodGenerals[i+self.ThreeQE]
end

--获取神将合并所需碎片数量
function GodGeneralConfig:getNumByMerger(id)
    local general = luacf.GodGenerals.GodGeneralsConfig.GodGeneralsGroup.GodGenerals
    local Quality = 0
    for i,target in pairs(general) do
        if target.ChipId == id then
            Quality = target.Quality
            break
        end
    end
    
    local StarConsume = luacf.GodGenerals.GodGeneralsConfig.StarGroup.StarConsume.Synth
    local Base = StarConsume.BaseGroup.Base
    
    local QualityFactor = StarConsume.Factor.QualityFactor
    local Factor = 0
    for j,target in pairs(QualityFactor) do
        if target.Quality == Quality then
            Factor = target.Factor
            break
        end
    end
    
    return Factor*Base
end

--获取各神将升星所需金币
function GodGeneralConfig:getGoldByGeneralUp(id,num)
    local star = num + 1
    local Quality = 0
    if star == 1 then
        local general = luacf.GodGenerals.GodGeneralsConfig.GodGeneralsGroup.GodGenerals
        for i,target in pairs(general) do
            if target.ChipId == id then
                Quality = target.Quality
                break
            end
        end
    else
        local len = #luacf.GodGenerals.GodGeneralsConfig.StarGroup.UpStar.Factor.StarFactor
        if num >= len then
            star = len
        end
        
        local general = luacf.GodGenerals.GodGeneralsConfig.GodGeneralsGroup.GodGenerals
        for i,target in pairs(general) do
            if target.Id == id then
                Quality = target.Quality
                break
            end
        end
    end
    
    local GoldGroup = luacf.GodGenerals.GodGeneralsConfig.StarGroup.StarConsume.Gold
    local BaseGroup = GoldGroup.BaseGroup
    local Base = BaseGroup.Base
    local Increasing = BaseGroup.Increasing
    local Adjust = BaseGroup.Adjust
    
    local QualityFactor = GoldGroup.Factor.QualityFactor
    local Factor = 0
    for j,target in pairs(QualityFactor) do
        if target.Quality == Quality then
            Factor = target.Factor
            break
        end
    end
    
    return (Base+star*Increasing)*Factor*Adjust
end

--获取各神将升星所需碎片
function GodGeneralConfig:getFragmentByGeneralUp(id,star)
    local general = luacf.GodGenerals.GodGeneralsConfig.GodGeneralsGroup.GodGenerals
    local Quality = 0
    for i,target in pairs(general) do
        if target.Id == id then
            Quality = target.Quality
            break
        end
    end
    
    local DebrisGroup = luacf.GodGenerals.GodGeneralsConfig.StarGroup.StarConsume.Debris
    local BaseGroup = DebrisGroup.BaseGroup
    local Base = BaseGroup.Base
    local Increasing = BaseGroup.Increasing
    
    local QualityFactor = DebrisGroup.Factor.QualityFactor
    local Factor = 0
    for j,target in pairs(QualityFactor) do
        if target.Quality == Quality then
            Factor = target.Factor
            break
        end
    end
   
    return (Base+Increasing*star)*Factor
end

function GodGeneralConfig:getFragmentByGeneralDestroy(id,star)
    local general = luacf.GodGenerals.GodGeneralsConfig.GodGeneralsGroup.GodGenerals
    local Quality = 0
    for i,target in pairs(general) do
        if target.Id == id then
            Quality = target.Quality
            break
        end
    end
    
    local DebrisGroup = luacf.GodGenerals.GodGeneralsConfig.StarGroup.StarConsume.Debris
    local BaseGroup = DebrisGroup.BaseGroup
    local Base = BaseGroup.Base
    local Increasing = BaseGroup.Increasing
    
    local QualityFactor = DebrisGroup.Factor.QualityFactor
    local Factor = 0
    for j,target in pairs(QualityFactor) do
        if target.Quality == Quality then
            Factor = target.Factor
            break
        end
    end
    
    return (Base+Increasing*star)*Factor
end

--获取碎片分解获得精魄
function GodGeneralConfig:FragmentDestroyNum(chipId)
    local general = luacf.GodGenerals.GodGeneralsConfig.GodGeneralsGroup.GodGenerals
    local Quality = 0
    for i,target in pairs(general) do
        if target.ChipId == chipId then
            Quality = target.Quality
            break
        end
    end
    
    local ChipSpiritExplode = luacf.GodGenerals.GodGeneralsConfig.StarGroup.StarConsume.ChipSpiritExplode
    local BaseGroup = ChipSpiritExplode.BaseGroup
    local Num = 0
    for j,target in pairs(BaseGroup) do
        if target.Quality == Quality then
            Num = target.Num
            break
        end
    end
    
    return Num
end

--获取神将分解获得精魄
function GodGeneralConfig:GeneralDestroyNum(id,star)
    local general = luacf.GodGenerals.GodGeneralsConfig.GodGeneralsGroup.GodGenerals
    local Quality = 0
    for i,target in pairs(general) do
        if target.Id == id then
            Quality = target.Quality
            break
        end
    end
    
    local CardSpiritExplode = luacf.GodGenerals.GodGeneralsConfig.StarGroup.StarConsume.CardSpiritExplode
    local BaseGroup = CardSpiritExplode.BaseGroup
    local Base = BaseGroup.Base
    local Discount = BaseGroup.Discount
    
    local QualityFactor = CardSpiritExplode.Factor.QualityFactor
    local Factor = 0
    for j,target in pairs(QualityFactor) do
        if target.Quality == Quality then
            Factor = target.Factor
            break
        end
    end
    
    local Fragment = 0
    if star == 1 then
        Fragment = self:getNumByMerger(id)
    else
        Fragment = self:getFragmentByGeneralDestroy(id,star)
    end
    
    return (Base+Fragment*Discount)*Factor
end

--获取兑换商店价钱
function GodGeneralConfig:getShopPrice(quality)
    local list = luacf.GodGenerals.GodGeneralsConfig.StarGroup.StarConsume.SpiritCash.Spirit
    for key, var in pairs(list) do
    	if var.Quality == quality then
    	    return var.Num
    	end
    end
end

--model
function GodGeneralConfig:getGeneralModel(id,type)
    local list = luacf.GodGenerals.GodGeneralsConfig.GodGeneralsGroup.GodGenerals
    local Model = nil
    for key, var in pairs(list) do
        if type == 1 then
    	   if var.Id == id then
                Model = var.Model
                break
    	   end
    	elseif type == 2 then
    	   if var.ChipId == id then
                Model = var.Model
                break
    	   end
    	end
    end
    local list2 = luacf.Ossature.OssatureConfig.Ossature
    for key, var in pairs(list2) do
    	if var.Id == Model then
            return var.Ossature
    	end
    end
end

--怪物model
function GodGeneralConfig:getMonsterModel(id)
    local list2 = luacf.Ossature.OssatureConfig.Ossature
    for key, var in pairs(list2) do
        if var.Id == id then
            return var.Ossature
        end
    end
end

function GodGeneralConfig:getSceneModel(model)
    local list2 = luacf.Ossature.OssatureConfig.Ossature
    for key, var in pairs(list2) do
        if var.Id == model then
            return var.Ossature
        end
    end
end

--GodGenerals
function GodGeneralConfig:getGeneralData(id,type)
    local list = luacf.GodGenerals.GodGeneralsConfig.GodGeneralsGroup.GodGenerals
    local GodGenerals = nil
    for key, var in pairs(list) do
        if type == 1 then
    	   if var.Id == id then
                GodGenerals = var
                break
    	   end
    	elseif type == 2 then
    	   if var.ChipId == id then
                GodGenerals = var
                break
    	   end
    	end
    end
    return GodGenerals
end

---GodGeneralsSceneConfig------------------------------------------------------------------------------------
function GodGeneralConfig:getGeneralScene()
    return luacf.GodGeneralsScene.GodGeneralsSceneConfig.SceneConfig.Scene
end    
