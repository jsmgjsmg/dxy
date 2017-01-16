GetRewardsLayer = GetRewardsLayer or class("GetRewardsLayer",function()
    return cc.Layer:create()
end)


function GetRewardsLayer:ctor()
	self.goodsNode = {}

	self:initUI()
end


function GetRewardsLayer:initUI()
    self._csbNode = cc.CSLoader:getInstance():createNodeWithFlatBuffersFile("dxyCocosStudio/csd/ui/copy/GetRewardsLayer.csb")
    self:addChild(self._csbNode)
    
    for i=1, 3 do
        self.goodsNode[i] = {}
        self.goodsNode[i].Node = self._csbNode:getChildByName("Node_"..i)
        self.goodsNode[i].Node:setVisible(false)
        self.goodsNode[i].spColor = self.goodsNode[i].Node:getChildByName("spColor")
        self.goodsNode[i].spGoods = self.goodsNode[i].Node:getChildByName("spGoods")
        self.goodsNode[i].txtName = self.goodsNode[i].Node:getChildByName("txtName")
    end
    
    
    
    self.btn_get = self._csbNode:getChildByName("btn_get")
    self.touchBg = self._csbNode:getChildByName("touchBg")
    
    self.visibleSize = cc.Director:getInstance():getVisibleSize()
    self.origin = cc.Director:getInstance():getVisibleOrigin()
    self.posX = self.origin.x + self.visibleSize.width/2
    self.posY = self.origin.y + self.visibleSize.height/2
    self:setPosition(self.posX, self.posY)
    
--    if(self.btn_get)then
--        self.btn_get:addTouchEventListener(function(target,type)
--            if(type==2)then
--                SoundsFunc_playSounds(SoundsType.UNIVERSAL_BTN,false)
--                local chapterId = zzm.CopySelectModel:getCurChapter()
--                zzc.CopySelectController:request_GetBoxReward(chapterId, self.index)
--                self.box:setSelected(true)
--                self:removeFromParent()
--            end
--        end)
--    end
    
     if(self.touchBg)then
        self.touchBg:addTouchEventListener(function(target,type)
            if(type==2)then
                SoundsFunc_playSounds(SoundsType.CLOSE_PAGE,false)
                if self.state == 2 then
                    self.box:setSelected(true)
                else
                    self.box:setSelected(false)
                end
                
                self:removeFromParent()
--                CopySelectLayer.ckb_list[self.index]:setSelected(self.touchState)
               
            end
        end)
    end
    
end



function GetRewardsLayer:setUIData(index,box,state,type)
    
    self.index = index
    self.box = box
    self.state = state
    if state == 0 then
        self.btn_get:setTitleText("领取")
        self.btn_get:setBright(false)
        self.btn_get:setTouchEnabled(false) 
    elseif state == 1 then
        self.btn_get:setTitleText("领取")
        self.btn_get:setBright(true)
        self.btn_get:setTouchEnabled(true)
    elseif state == 2 then
        self.btn_get:setTitleText("已领取")
        self.btn_get:setBright(false)
        self.btn_get:setTouchEnabled(false)
    end
--    self.btn_get:setBright(state)
--    self.btn_get:setTouchEnabled(state) 
    
    local bg = self._csbNode:getChildByName("bg")
    local myJob = zzm.CharacterModel:getCharacterData().pro
    local rewardData = nil

    if type == "CopyReward" then
        if(self.btn_get)then
            self.btn_get:addTouchEventListener(function(target,type)
                if(type==2)then
                    SoundsFunc_playSounds(SoundsType.UNIVERSAL_BTN,false)
                    local chapterId = zzm.CopySelectModel:getCurChapter()
                    zzc.CopySelectController:request_GetBoxReward(chapterId, self.index)
                    self.box:setSelected(true)
                    self:removeFromParent()
                end
            end)
        end
        local chapterId = zzm.CopySelectModel:getCurChapter()
        rewardData = StarRewardConfig:findIngotRewardByChapterId(chapterId,index)
    elseif type == "LivelyReward" then
        if(self.btn_get)then
            self.btn_get:addTouchEventListener(function(target,type)
                if(type==2)then
                    SoundsFunc_playSounds(SoundsType.UNIVERSAL_BTN,false)
                    zzc.TaskController:getLively(zzm.TaskModel.arrLivelyData.Box[index].State)
                    self.box:setSelected(true)
                    self:removeFromParent()
                end
            end)
        end
        rewardData = TaskConfig:getLivelyReawardById(index)
    end
    
--    local chapterId = zzm.CopySelectModel:getCurChapter()
--    
--    local myJob = zzm.CharacterModel:getCharacterData().pro
--    local rewardData = StarRewardConfig:findIngotRewardByChapterId(chapterId,index)

    if #rewardData >1 then
--        self.goodsNode[3].Node:setVisible(false)
        local goodsSeq = 2
        for key, var in pairs(rewardData) do
            if var.Type == DefineConst.CONST_AWARD_RMB then --2
                
                self:setGoodsUI(var,goodsSeq)
                goodsSeq = goodsSeq - 1
			end
			
            if var.Type == DefineConst.CONST_AWARD_GOODS then  --6
				if var.Job == myJob then
                   
                    self:setGoodsUI(var,goodsSeq)
                    goodsSeq = goodsSeq - 1
				end
			end
			
            if var.Type == DefineConst.CONST_AWARD_THREE_YEAR_PEENTO or -- 13
               var.Type == DefineConst.CONST_AWARD_FIVE_YEAR_PEENTO or -- 14 
               var.Type == DefineConst.CONST_AWARD_NINE_YEAR_PEENTO then -- 15
                
                self:setGoodsUI(var,goodsSeq)
                goodsSeq = goodsSeq - 1
			end
            if goodsSeq == 0 then return end
		end
	else
--        self.goodsNode[1].Node:setVisible(false)
--        self.goodsNode[2].Node:setVisible(false)
        self:setGoodsUI(rewardData[1],3)
        
	end
end

local PATH = "res/dxyCocosStudio/png/equip/"
function GetRewardsLayer:setGoodsUI(goods,nodeNum)

    self.goodsNode[nodeNum].Node:setVisible(true)
    if goods.Type == DefineConst.CONST_AWARD_GOODS or --6
       goods.Type == DefineConst.CONST_AWARD_CHIP or  --10
       goods.Type == DefineConst.CONST_AWARD_RAND_EQUIP or --22
       goods.Type == DefineConst.CONST_AWARD_RAND_MAGICSOUL or --23
       goods.Type == DefineConst.CONST_AWARD_RAND_GODCHIP then --24
       
        local data = GoodsConfigProvider:findGoodsById(goods.Id)
        self.goodsNode[nodeNum].spColor:setTexture(PATH.."spiritQuality_"..data.Quality..".png")
        self.goodsNode[nodeNum].txtName:setString(data.Name.." + "..goods.Num)
        self.goodsNode[nodeNum].txtName:setColor(Quality_Color[data.Quality])
        if  goods.Type == DefineConst.CONST_AWARD_CHIP or --10
            goods.Type == DefineConst.CONST_AWARD_RAND_GODCHIP then --24
            self.goodsNode[nodeNum].spGoods:setTexture("GodGeneralsIcon/"..data.Icon..".png")
        else
            self.goodsNode[nodeNum].spGoods:setTexture("Icon/"..data.Icon..".png")
        end
    else
        self.goodsNode[nodeNum].spGoods:setTexture(zzd.TaskData.arrGoodsIcon[goods.Type])
        self.goodsNode[nodeNum].spColor:setTexture(PATH.."spiritQuality_1.png")
        self.goodsNode[nodeNum].txtName:setString(zzd.TaskData.arrStrType[goods.Type].." + "..goods.Num)
    end

end