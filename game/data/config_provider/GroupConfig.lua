GroupConfig = GroupConfig or class("GroupConfig")

---luacf.SociatyJob
--获取权限
function GroupConfig:getRoot(root)
    local list = luacf.SociatyJob.SociatyJobConfig.SociatyJob
    for key, var in ipairs(list) do
    	if var.Type == root then
    	   return var
    	end
    end
end

---luacf.SociatyLv
function GroupConfig:getSociatyLv(lv)
    local list = luacf.SociatyLv.SociatyLvConfig.SociatyLv
    for key, var in pairs(list) do
    	if var.Lv == lv then
    	    return var
    	end
    end
end

---luacf.SociatyEvent
function GroupConfig:getStr(type)
    local list = luacf.SociatyEvent.SociatyEventConfig.SociatyEvent
    for key, var in ipairs(list) do
    	if var.Type == type then
    	   return var.Text
    	end
    end
end

---luacf.PrayConfig
function GroupConfig:initPrayConfig()
    self.PrayConfig = {}
    local list = luacf.Pray.PrayConfig.SociatyPray.Pray
    for i=1,#list do
        if not self.PrayConfig[list[i].SociatyLv] then
            self.PrayConfig[list[i].SociatyLv] = {}
        end
        table.insert(self.PrayConfig[list[i].SociatyLv],list[i])
    end
end

--金币可祈福次数
function GroupConfig:getGoldPrayNum(lv)
    local GoldPrayNum = 0
    for j=1,#self.PrayConfig[lv] do
        if self.PrayConfig[lv][j].GoldPray ~= 0 then
            GoldPrayNum = GoldPrayNum + 1
        else
            return GoldPrayNum
        end
    end
end

function GroupConfig:getPrayConfig(lv,num)
    for key, var in pairs(self.PrayConfig[lv]) do
        if var.Num == num then
    	    return var
    	end
    end
end

function GroupConfig:getPrayLen(lv)
    return #self.PrayConfig[lv]
end

---luacf.TalentConfig
function GroupConfig:getTalentConfigById(id)
    local list = luacf.Talent.TalentConfig.Base
    if list[id] then
        return list[id]
    end
    return {Tier = list[#list].Tier}
end

function GroupConfig:getTalentConfigLen()
    local list = luacf.Talent.TalentConfig.Base
    return #list
end

---luacf.SkyPagodaConfig
function GroupConfig:initSkyPagoda()
    self.SkyPagodaConfig = {}
    local list = luacf.SkyPagoda.SkyPagodaConfig.Copy.CopyConfig
    for i=1,#list do
        self.curPage = math.ceil(i / 18)
        if not self.SkyPagodaConfig[self.curPage] then
            self.SkyPagodaConfig[self.curPage] = {}
        end
        table.insert(self.SkyPagodaConfig[self.curPage],list[i])
    end
end

function GroupConfig:getSkyPagodaByPage(page)
    if self.SkyPagodaConfig[page] then
        return self.SkyPagodaConfig[page]
    end
end

function GroupConfig:getSkyPagodaLen()
    return #luacf.SkyPagoda.SkyPagodaConfig.Copy.CopyConfig
end

function GroupConfig:getSkyPagodaByPageById(id)
    local list = luacf.SkyPagoda.SkyPagodaConfig.Copy.CopyConfig
    for key, var in pairs(list) do
    	if var.Id == id then
    	    return var
    	end
    end
    return false
end
