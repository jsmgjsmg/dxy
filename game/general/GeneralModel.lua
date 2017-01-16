local GeneralModel = GeneralModel or class("GeneralModel")

function GeneralModel:ctor()
    self.Fragment = {}
    self.General = {}
    self.General["Card"] = {}
    self.ALLGENERAL = {}
    self._arrTips = {}
    self._arrCrit = {}
    self._GNCopyDFC = nil
    self._GNCopyMST = nil
    self.isOnGeneral = false
end

--更新Res
function GeneralModel:updateRes()
    dxyDispatcher_dispatchEvent("RankRes")
end

--提示延迟
function GeneralModel:TipsSchedule(tips,crit)
    table.insert(self._arrTips,tips)
    table.insert(self._arrCrit,crit)
    local stopTimer = 3
    require "src.game.yuanshen.view.TipsCrit"
    if not self._myTimer then
        self._myTimer = self._myTimer or require("game.utils.MyTimer").new()
        local function tick()
            stopTimer = stopTimer - 0.1
            if stopTimer <= 0 then
                self._myTimer:stop()
                self._myTimer = nil
                self._arrTips = {}
                self._arrCrit = {}
                return 
            end
            if self._arrTips[1] then
                dxyFloatMsg:show(self._arrTips[1])
                table.remove(self._arrTips,1)
                if self._arrCrit[1] > 1 then
                    local scene = SceneManager:getCurrentScene()
                    local _csb = TipsCrit:create()
                    scene:addChild(_csb)
                end
                table.remove(self._arrCrit,1)
            else
                self._myTimer:stop()
                self._myTimer = nil
            end
        end
        self._myTimer:start(0.1, tick)
    end
end

---碎片---------------------------------------------------------

--初始化碎片
function GeneralModel:initFragment(data)
    table.insert(self.Fragment,data)
    table.sort(self.Fragment,function(t1,t2) return t1.Id > t2.Id end)
end

--新增碎片
function GeneralModel:addFragment(data)
    table.insert(self.Fragment,data)
    table.sort(self.Fragment,function(t1,t2) return t1.Id > t2.Id end)
    dxyDispatcher_dispatchEvent("addFragment",data)
    if self.isOnGeneral then
        cn:TipsSchedule(GoodsConfigProvider:findGoodsById(data.Id).Name.." +"..data.Num)
    end
end

--更新碎片
function GeneralModel:changeFragment(data)
    dxyDispatcher_dispatchEvent("changeFragment",data)
    dxyDispatcher_dispatchEvent("FragmentMsg_updateRes",data)
end

--分解碎片
function GeneralModel:delFragment(id)
    for key, var in pairs(self.Fragment) do
    	if var.Id == id  then
            table.remove(self.Fragment,key)
            dxyDispatcher_dispatchEvent("delFragment",id)
            dxyDispatcher_dispatchEvent("FragmentMsg_removeSelf")
            dxyDispatcher_dispatchEvent("FragmentMsg_updateRes",var)

            table.sort(self.Fragment,function(t1,t2) return t1.Id > t2.Id end)
            dxyDispatcher_dispatchEvent("GeneralRank_RankAgain")
            break
    	end
    end
end


---神将Card-----------------------------------------------------------

--初始化神将属性加成
function GeneralModel:initGeneralAdd(data)
    self.General = data
end

--初始化神将数量
function GeneralModel:initGeneralCard(data)
    table.insert(self.General.Card,data)
end

--新增神将
function GeneralModel:addGeneralCard(data)
    table.insert(self.General.Card,data)
end

--更新神将
function GeneralModel:changeGeneralCard(data)
    dxyDispatcher_dispatchEvent("GeneralFS_changeGenral",data)
end

--分解神将 
function GeneralModel:delGeneral(id)
    for key, var in pairs(self.General) do
        if var.Id == id  then
            table.remove(self.General,key)
            dxyDispatcher_dispatchEvent("GeneralFS_delGeneral",id)
            break
        end
    end
end

--更新神将星阶
function GeneralModel:updateStar(data)
    self:RankGeneralCard()
    dxyDispatcher_dispatchEvent("GeneralMsg_updatePro",data)
    dxyDispatcher_dispatchEvent("ResForUpStar_updatePro",data)
    dxyDispatcher_dispatchEvent("updateStage",_G.GeneralData.Current)
    dxyDispatcher_dispatchEvent("GeneralFS_updateFS")
    dxyDispatcher_dispatchEvent("ResForMerger_updatePro",data)
end

--获取神将对应碎片数量
function GeneralModel:getFragmentWithGeneral(id)
    local chipID = GodGeneralConfig:GIDtoFID(id)
    for i,target in pairs(self.Fragment) do
        if target.Id == chipID then
            return target.Num
        end
    end
end

--排序
function GeneralModel:RankGeneralCard()
    table.sort(self.General.Card,self.CoupleofSort)
    
    local config = GodGeneralConfig:getGeneralConfig()
    
    local curConfig = self:recursion(self.General.Card,config)
    self.ALLGENERAL = {}
    for k=1,#self.General.Card do
        table.insert(self.ALLGENERAL,self.General.Card[k])
    end
    for j=1,#curConfig do
        table.insert(self.ALLGENERAL,curConfig[j])
    end
    config = {}
end

function GeneralModel.CoupleofSort(t1,t2)
    if t1.Quality == t2.Quality then
        if t1.Star and t2.Star then 
            return t1.Star > t2.Star
        elseif not t1.Star and not t2.Star then
            return false
        elseif t1.Star or t2.Star then
            if t1.Star then
                return true
            end
            if t2.Star then
                return false
            end
        else
            return false
        end
    else 
        return t1.Quality > t2.Quality 
    end 
end

function GeneralModel:recursion(card,config)
    local curCard = card
    local curConfig = config
    for i=1,#curCard do
        for j=1,#curConfig do
            if curCard[i].Id == curConfig[j].Id then
                table.remove(curConfig,j)
                break
            end
        end
    end
    return curConfig
end

--更新神将属性
function GeneralModel:updateAllCard(data)
    for key, var in pairs(self.General.Card) do
    	if var.Id == data.Id then
    	   var.Atk = data.Atk
    	   var.Def = data.Def
    	   var.Hp = data.Hp
    	   return
    	end
    end
end

--更新出战神将
function GeneralModel:updateFight(id)
    for key, var in pairs(self.General.Card) do
    	if var.Id == id then
    	   var.isCur = 0 
    	   break
    	end
    end
    dxyDispatcher_dispatchEvent("updateStage",_G.GeneralData.Current)
    dxyDispatcher_dispatchEvent("GeneralFS_updateFS")
end

--多选分神将
function GeneralModel:DestroyGeneralMore(data,type)
    local des = {}
    local num = 0
    for i=1,4 do
        if data[i] ~= 0 then
            table.insert(des,data[i])
            num = num + 1
        end
    end
    
    local last = {[1]=num,[2]=des}
    zzc.GeneralController:DestroyMore(last,type)
end

--获取当前神将数据
function GeneralModel:getGeneralPro(id)
    for i,target in pairs(self.General.Card) do
        if target.Id == id then
            return target
        end
    end
end

return GeneralModel
