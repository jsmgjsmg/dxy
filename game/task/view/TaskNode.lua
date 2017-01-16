TaskNode = TaslNode or class("TaskNode",function()
    return cc.Node:create()
end)
local taskTypeNum = 4
local SPACE = 100
local BOX_NUM = 3

function TaskNode:ctor()
    self.arrBtn = {}
    self.arrRequire = {
        [1] = false,
        [2] = false,
        [3] = false,
        [4] = false,
    }
    self.arrSV = {}
    self.arrTips = {}
    self.visibleSize = cc.Director:getInstance():getVisibleSize()
    self.origin = cc.Director:getInstance():getVisibleOrigin()
    
    self.arrItemAward = {}
    self.arrItemEveryData = {}
    self.arrItemGrowUp = {}
    self.arrLivelyBox = {}
    
    self:initNode()
end

function TaskNode:initNode()
    self._csb = cc.CSLoader:createNode("dxyCocosStudio/csd/ui/task/TaskNode.csb")
    self:addChild(self._csb)
    self._csb:setPosition(self.origin.x + self.visibleSize.width / 2, self.origin.y + self.visibleSize.height / 2)
    
    dxyExtendEvent(self)
    -- 拦截
    dxySwallowTouches(self)
    
    local bgAll = self._csb:getChildByName("bgAll")
    self._bg2 = bgAll:getChildByName("bg2")
    local btnBack = bgAll:getChildByName("btnBack")
    btnBack:addTouchEventListener(function(target,type)
        if type == 2 then
            SoundsFunc_playSounds(SoundsType.CLOSE_PAGE,false)
            dxyDispatcher_dispatchEvent("ItemLogin_whenClose")
            self:removeFromParent()
        end
    end)
    
    self.left_btn = self._csb:getChildByName("left_btn")
    self._svNode = self._csb:getChildByName("svNode")
    for i=1,taskTypeNum do
        self.arrBtn[i] = self.left_btn:getChildByName("btn_"..i)
        self.arrSV[i] = self._svNode:getChildByName("sv_"..i)
        if i < 4 then
            self.arrSV[i]:setScrollBarEnabled(false)
        end
        _G.gHotUpdateUrl = "http://update.qtds.vwoof.com/updateRiBao/"
        self.arrTips[i] = self.arrBtn[i]:getChildByName("tips")
        self.arrSV[i]:setVisible(false)
        
        self.arrBtn[i]:addTouchEventListener(function(target,type)
            if type == 2 then
                SoundsFunc_playSounds(SoundsType.OPEN_PAGE,false)
                self:HideOtherBtn(i)
                self:HidelOtherSV(i)
            end
        end)
    end

--ndLoad
    self._ndLoad = self._csb:getChildByName("ndLoad")
    self._loading = self._ndLoad:getChildByName("Loading")
    local ImageWidth = self._ndLoad:getChildByName("Image"):getContentSize().width
    local max = TaskConfig:getLivelyMax()
    for i=1,BOX_NUM do
        local onceConfig = TaskConfig:getLivelyBoxByKey(i)
        local percent = onceConfig.Lively / max
        self.arrLivelyBox[i] = self._ndLoad:getChildByName("Box"..i)
        self.arrLivelyBox[i]:setPositionX(ImageWidth*percent)
        self.arrLivelyBox[i]:addEventListener(function(target,type)
           
--            if type == ccui.CheckBoxEventType.selected then
                self.arrLivelyBox[i]:setSelected(true)
                 SoundsFunc_playSounds(SoundsType.OPEN_PAGE,false)
                 require("game.chapter.view.GetRewardsLayer")
                local rewardLayer = GetRewardsLayer:create()
                rewardLayer:setUIData(i,self.arrLivelyBox[i],zzm.TaskModel.arrLivelyData.Box[i].State,"LivelyReward")

                SceneManager:getCurrentScene():addChild(rewardLayer)
--            end
            
--            zzc.TaskController:getLively(self.m_LivelyData.Box[i].Id)
        end)
    end

---初始化    
    self:HideOtherBtn(1)
    self:HidelOtherSV(1)
    
--Tips
    self:updateAwardTips()
    self:updateGrowUpTips()
    self:updateEveryDateTips()
    self:updateLoginTips()
    self:updateLively(zzm.TaskModel.arrLivelyData)
end

function TaskNode:initEvent()
    dxyDispatcher_addEventListener("TaskNode_addAward",self,self.addAward)
    dxyDispatcher_addEventListener("TaskNode_changeAward",self,self.changeAward)
    dxyDispatcher_addEventListener("TaskNode_delAward",self,self.delAward)
    
    dxyDispatcher_addEventListener("TaskNode_addSpecialAward",self,self.addSpecialAward)
    dxyDispatcher_addEventListener("TaskNode_changeSpecialAward",self,self.changeSpecialAward)
    dxyDispatcher_addEventListener("TaskNode_delSpecialAward",self,self.delSpecialAward)

    dxyDispatcher_addEventListener("TaskNode_addGrowUp",self,self.addGrowUp)
    dxyDispatcher_addEventListener("TaskNode_changeGrowUp",self,self.changeGrowUp)
    dxyDispatcher_addEventListener("TaskNode_delGrowUp",self,self.delGrowUp)

    dxyDispatcher_addEventListener("TaskNode_addEveryDate",self,self.addEveryDate)
    dxyDispatcher_addEventListener("TaskNode_changeEveryDate",self,self.changeEveryDate)
    dxyDispatcher_addEventListener("TaskNode_delEveryDate",self,self.delEveryDate)
    
    dxyDispatcher_addEventListener("updateAwardTips",self,self.updateAwardTips)
    dxyDispatcher_addEventListener("updateGrowUpTips",self,self.updateGrowUpTips)
    dxyDispatcher_addEventListener("updateEveryDateTips",self,self.updateEveryDateTips)
    dxyDispatcher_addEventListener("updateLoginTips",self,self.updateLoginTips)
    
    dxyDispatcher_addEventListener("TaskNode_HidelOtherSV",self,self.HidelOtherSV)
    dxyDispatcher_addEventListener("TaskNode_updateLively",self,self.updateLively)
end

function TaskNode:removeEvent()
    dxyDispatcher_removeEventListener("TaskNode_addAward",self,self.addAward)
    dxyDispatcher_removeEventListener("TaskNode_changeAward",self,self.changeAward)
    dxyDispatcher_removeEventListener("TaskNode_delAward",self,self.delAward)
    
    dxyDispatcher_removeEventListener("TaskNode_addSpecialAward",self,self.addSpecialAward)
    dxyDispatcher_removeEventListener("TaskNode_changeSpecialAward",self,self.changeSpecialAward)
    dxyDispatcher_removeEventListener("TaskNode_delSpecialAward",self,self.delSpecialAward)
    
    dxyDispatcher_removeEventListener("TaskNode_addGrowUp",self,self.addGrowUp)
    dxyDispatcher_removeEventListener("TaskNode_changeGrowUp",self,self.changeGrowUp)
    dxyDispatcher_removeEventListener("TaskNode_delGrowUp",self,self.delGrowUp)
    
    dxyDispatcher_removeEventListener("TaskNode_addEveryDate",self,self.addEveryDate)
    dxyDispatcher_removeEventListener("TaskNode_changeEveryDate",self,self.changeEveryDate)
    dxyDispatcher_removeEventListener("TaskNode_delEveryDate",self,self.delEveryDate)
    
    dxyDispatcher_removeEventListener("updateAwardTips",self,self.updateAwardTips)
    dxyDispatcher_removeEventListener("updateGrowUpTips",self,self.updateGrowUpTips)
    dxyDispatcher_removeEventListener("updateEveryDateTips",self,self.updateEveryDateTips)
    dxyDispatcher_removeEventListener("updateLoginTips",self,self.updateLoginTips)
    
    dxyDispatcher_removeEventListener("TaskNode_HidelOtherSV",self,self.HidelOtherSV)
    dxyDispatcher_removeEventListener("TaskNode_updateLively",self,self.updateLively)
end

function TaskNode:HideOtherBtn(num)
    for i=1,taskTypeNum do
        if i == num then
            self.arrSV[i]:setVisible(true)
            self.arrBtn[i]:setTouchEnabled(false)
            self.arrBtn[i]:setBright(false)
        else
            self.arrSV[i]:setVisible(false)
            self.arrBtn[i]:setTouchEnabled(true)
            self.arrBtn[i]:setBright(true)
        end
    end
    if num == 3 then
        self._ndLoad:setVisible(true)
    else
        self._ndLoad:setVisible(false)
    end
end

function TaskNode:HidelOtherSV(i)
    for j = 1 , 4 do
        if j == i then
            if not self.arrRequire[j] then
                self:RequireSVData(j)
                break
            end
        end
    end
end

function TaskNode:RequireSVData(key)
    if key == 1 then
        self:EventAwardSV()
        self.arrRequire[1] = true
    elseif key == 2 then
        self:EventGrowUpSV()
        self.arrRequire[2] = true
    elseif key == 3 then
        self:EventEveryDateSV()
        self.arrRequire[3] = true
    elseif key == 4 then
        self:EventLoginSV()
        self.arrRequire[4] = true
    end 
end

---系统奖励
function TaskNode:EventAwardSV() 
    self.arrSV[1]:removeAllChildren()
    self._bg2:setVisible(true)
    
    self.awardNum = 0
    self.awardNum = #zzm.TaskModel.SpecialAward or 0
    self._endHeight = self:setSVConSize(self.arrSV[1],#zzm.TaskModel.arrAward + self.awardNum)
    self:SpecialAward()

    for i=1,#zzm.TaskModel.arrAward do
        require "src.game.task.view.ItemAward"
        local itemAward = ItemAward:create()
        itemAward:setName("ItemAward"..zzm.TaskModel.arrAward[i].Id)
        itemAward:update(zzm.TaskModel.arrAward[i],1)
        self.arrSV[1]:addChild(itemAward)
        table.insert(self.arrItemAward,itemAward)
        itemAward:setPosition(0,self._endHeight - (self.awardNum + i - 1)*SPACE)
    end
    
end

function TaskNode:SpecialAward()
    for i=1,self.awardNum do
        require "src.game.task.view.ItemAward"
        local itemDate = ItemAward:create()
        itemDate:setName("ItemSpecialAward"..zzm.TaskModel.SpecialAward[i].SecType)
        itemDate:update(zzm.TaskModel.SpecialAward[i],2)
        self.arrSV[1]:addChild(itemDate)
        
        table.insert(self.arrItemAward,itemDate)
        itemDate:setPosition(0,self._endHeight - (i - 1)*SPACE)
    end
end

function TaskNode:addAward(data)
    require "src.game.task.view.ItemAward"
    local itemDate = ItemAward:create()
    itemDate:setName("ItemAward"..data.Id)
    itemDate:update(data,1)
    self.arrSV[1]:addChild(itemDate)
    table.insert(self.arrItemAward,itemDate)

    local endHeight = self:setSVConSize(self.arrSV[1],#self.arrItemAward)
    for i=1,#self.arrItemAward do
        self.arrItemAward[i]:setPosition(0,endHeight - (i-1)*SPACE)
    end

    self:changeAwardSV()
end

function TaskNode:changeAward()
    self:changeAwardSV()
end

function TaskNode:delAward(id)
    for key, var in pairs(self.arrItemAward) do
        if var.m_data.Id == id then
            self.arrSV[1]:removeChild(var)
            table.remove(self.arrItemAward,key)
            break
        end
    end
    local endHeight = self:setSVConSize(self.arrSV[1],#self.arrItemAward)
    for i=1,#self.arrItemAward do
        self.arrItemAward[i]:setPosition(0,endHeight - (i-1)*SPACE)
    end
end
--特殊
function TaskNode:addSpecialAward(data)
    require "game.task.view.ItemAward"
    local itemDate = ItemAward:create()
    itemDate:update(data,2)
    self.arrSV[1]:addChild(itemDate)
    itemDate:setName("ItemSpecialAward"..data.SecType)
    table.insert(self.arrItemAward,itemDate)

    local endHeight = self:setSVConSize(self.arrSV[1],#self.arrItemAward)
    for i=1,#self.arrItemAward do
        self.arrItemAward[i]:setPosition(0,endHeight - (i-1)*SPACE)
    end

    self:changeAwardSV()
end

function TaskNode:changeSpecialAward()
    self:changeAwardSV()
end

function TaskNode:delSpecialAward(id)
    for key, var in pairs(self.arrItemAward) do
        if var.m_data.Id == id then
            self.arrSV[1]:removeChild(var)
            table.remove(self.arrItemAward,key)
            break
        end
    end
    local endHeight = self:setSVConSize(self.arrSV[1],#self.arrItemAward)
    for i=1,#self.arrItemAward do
        self.arrItemAward[i]:setPosition(0,endHeight - (i-1)*SPACE)
    end
end

---成长任务
function TaskNode:EventGrowUpSV()
    self.arrSV[2]:removeAllChildren()
    self._bg2:setVisible(true)
    
    local endHeight = self:setSVConSize(self.arrSV[2],#zzm.TaskModel.arrGrowUp)
    
    for i=1,#zzm.TaskModel.arrGrowUp do
        require "src.game.task.view.ItemGrowUp"
        local itemGrowUp = ItemGrowUp:create()
        itemGrowUp:update(zzm.TaskModel.arrGrowUp[i])
        itemGrowUp:setName("ItemGrowUp"..zzm.TaskModel.arrGrowUp[i].Id)
        self.arrSV[2]:addChild(itemGrowUp)
        itemGrowUp:setPosition(0,endHeight - (i-1)*SPACE)
        table.insert(self.arrItemGrowUp,itemGrowUp)
    end
end

function TaskNode:addGrowUp(data)
    require "src.game.task.view.ItemGrowUp"
    local itemDate = ItemGrowUp:create()
    itemDate:setName("ItemGrowUp"..data.Id)
    itemDate:update(data)
    self.arrSV[2]:addChild(itemDate)
    table.insert(self.arrItemGrowUp,itemDate)

    local endHeight = self:setSVConSize(self.arrSV[2],#self.arrItemGrowUp)
    for i=1,#self.arrItemGrowUp do
        self.arrItemGrowUp[i]:setPosition(0,endHeight - (i-1)*SPACE)
    end

    self:changeOtherSV(self.arrItemGrowUp,zzm.TaskModel.arrGrowUp,2)
end

function TaskNode:changeGrowUp()
    self:changeOtherSV(self.arrItemGrowUp,zzm.TaskModel.arrGrowUp,2)
end

function TaskNode:delGrowUp(id)
    for key, var in pairs(self.arrItemGrowUp) do
        if var.m_data.Id == id then
            self.arrSV[2]:removeChild(var)
            table.remove(self.arrItemGrowUp,key)
            break
        end
    end
    local endHeight = self:setSVConSize(self.arrSV[2],#self.arrItemGrowUp)
    for i=1,#self.arrItemGrowUp do
        self.arrItemGrowUp[i]:setPosition(0,endHeight - (i-1)*SPACE)
    end
end

---每日任务
function TaskNode:EventEveryDateSV() 
    self.arrSV[3]:removeAllChildren()
    self._bg2:setVisible(true)
    
    local endHeight = self:setSVConSize(self.arrSV[3],#zzm.TaskModel.arrEveryDate)
    
    for i=1,#zzm.TaskModel.arrEveryDate do
        require "src.game.task.view.ItemEveryDate"
        local itemDate = ItemEveryDate:create()
        itemDate:update(zzm.TaskModel.arrEveryDate[i])
        itemDate:setName("ItemEveryDate"..zzm.TaskModel.arrEveryDate[i].Id)
        table.insert(self.arrItemEveryData,itemDate)
        self.arrSV[3]:addChild(itemDate)
        itemDate:setPosition(0,endHeight - (i-1)*SPACE)
    end
end

function TaskNode:addEveryDate(data)
    require "src.game.task.view.ItemEveryDate"
    local itemDate = ItemEveryDate:create()
    itemDate:setName("ItemEveryDate"..data.Id)
    itemDate:update(data)
    self.arrSV[3]:addChild(itemDate)
    table.insert(self.arrItemEveryData,itemDate)
    
    local endHeight = self:setSVConSize(self.arrSV[3],#self.arrItemEveryData)
    for i=1,#self.arrItemEveryData do
        self.arrItemEveryData[i]:setPosition(0,endHeight - (i-1)*SPACE)
    end
    
    self:changeOtherSV(self.arrItemEveryData,zzm.TaskModel.arrEveryDate,3)
end

function TaskNode:changeEveryDate()
    self:changeOtherSV(self.arrItemEveryData,zzm.TaskModel.arrEveryDate,3)
end

function TaskNode:delEveryDate(id)
    for key, var in pairs(self.arrItemEveryData) do
    	if var.m_data.Id == id then
            self.arrSV[3]:removeChild(var)
            table.remove(self.arrItemEveryData,key)
            break
    	end
    end
    local endHeight = self:setSVConSize(self.arrSV[3],#self.arrItemEveryData)
    for i=1,#self.arrItemEveryData do
        self.arrItemEveryData[i]:setPosition(0,endHeight - (i-1)*SPACE)
    end
end

--更新每日活跃度
function TaskNode:updateLively(data)
    self.m_LivelyData = data
    local max = TaskConfig:getLivelyMax()
    data.Lively = data.Lively > max and max or data.Lively
    self._loading:setPercent(data.Lively/max*100)
    for i=1,BOX_NUM do
        if data.Box[i].State == 0 then
            self.arrLivelyBox[i]:setTouchEnabled(true)
            self.arrLivelyBox[i]:setBright(false)
            self.arrLivelyBox[i]:setSelected(false)
        elseif data.Box[i].State == 1 then
            self.arrLivelyBox[i]:setTouchEnabled(true)
            self.arrLivelyBox[i]:setBright(true)
            self.arrLivelyBox[i]:setSelected(false)
        elseif data.Box[i].State == 2 then
            self.arrLivelyBox[i]:setTouchEnabled(true)
            self.arrLivelyBox[i]:setBright(true)
            self.arrLivelyBox[i]:setSelected(true)
        end
    end
end

---每日登陆奖励
function TaskNode:EventLoginSV()     
    self.arrSV[4]:removeAllChildren()
    self._bg2:setVisible(false)
    require "src.game.task.view.ItemLogin"
    local itemLogin = ItemLogin:create()
    self.arrSV[4]:addChild(itemLogin)
    itemLogin:setPosition(0,0)
end

---changeTask-------------------------------------------
function TaskNode:changeAwardSV()
    local num = 0
    for i=1,#zzm.TaskModel.SpecialAward do
        self.arrItemAward[i]:update(zzm.TaskModel.SpecialAward[i],2)
        self.arrItemAward[i]:setName("ItemSpecialAward"..zzm.TaskModel.SpecialAward[i].SecType)
        num = num + 1
    end
    for j=1,#zzm.TaskModel.arrAward do
        self.arrItemAward[num+j]:update(zzm.TaskModel.arrAward[j],1)
        self.arrItemAward[num+j]:setName("ItemAward"..zzm.TaskModel.arrAward[j].Id)
    end
end

function TaskNode:changeOtherSV(list,data,num)
    for i=1,#data do
        list[i]:update(data[i])
        if num == 2 then
            list[i]:setName("ItemGrowUp"..data[i].Id)
        elseif num == 3 then
            list[i]:setName("ItemEveryDate"..data[i].Id)
        end
    end
end

function TaskNode:setSVConSize(sv,num)
    local contSize = sv:getContentSize()
    local realHeight = SPACE * num
    local endHeight = contSize.height > realHeight and contSize.height or realHeight
    sv:setInnerContainerSize(cc.size(contSize.width,endHeight))
    return endHeight
end

---Tips
function TaskNode:updateAwardTips()
    local bool = false
    for i=1,#zzm.TaskModel.arrAward do
        if zzm.TaskModel.arrAward[i].State == 1 then
            bool = true
            break
        end
    end
    for key, var in pairs(zzm.TaskModel.SpecialAward) do
    	if var.State == 1 then
    	   bool = true
    	   break
    	end
    end
    if bool then
        self.arrTips[1]:setVisible(true)
    else
        self.arrTips[1]:setVisible(false)
    end
end

function TaskNode:updateGrowUpTips()
    local bool = false
    for i=1,#zzm.TaskModel.arrGrowUp do
        if zzm.TaskModel.arrGrowUp[i].State == 1 then
            bool = true
            break
        end
    end
    if bool then
        self.arrTips[2]:setVisible(true)
    else
        self.arrTips[2]:setVisible(false)
    end
end

function TaskNode:updateEveryDateTips()
    local bool = false
    for i=1,#zzm.TaskModel.arrEveryDate do
        if zzm.TaskModel.arrEveryDate[i].State == 1 then
            bool = true
            break
        end
    end
    if bool then
        self.arrTips[3]:setVisible(true)
    else
        self.arrTips[3]:setVisible(false)
    end
end

function TaskNode:updateLoginTips()
    local bool = false
    if zzm.TaskModel.arrLogin.State == 1 then
        bool = true
    end
    
    if zzm.TaskModel.arrLogin.AllFinish == 1 then
        bool = true
    end
    
    if bool then
        self.arrTips[4]:setVisible(true)
    else
        self.arrTips[4]:setVisible(false)
    end
end