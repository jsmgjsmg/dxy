CopyItem = CopyItem or class("CopyItem",function()
    return cc.Node:create()
end)


function CopyItem.create()
    local node = CopyItem.new()
    return node
end

function CopyItem:ctor()
    self._csbNode = nil
    self.copyName = nil
    self.copyIcon = nil
    self.startNode = nil
    self.m_data = nil
    self:initUI()
    dxyExtendEvent(self)
end




function CopyItem:initUI()
    self._csbNode = cc.CSLoader:createNode("dxyCocosStudio/csd/ui/copy/CopyItem.csb")
    self:addChild(self._csbNode)
    
    self.copyName = self._csbNode:getChildByName("CopyName")
    self.copyIcon = self._csbNode:getChildByName("CopyIcon")
    self.copyIcon:setTouchEnabled(false)
    self.copyIcon:setBright(false)
    self.startNode = self._csbNode:getChildByName("Start")
    self.startNode:setVisible(false)
    self.startList = {}
    for index=1, 3 do
    	self.startList[index] = self.startNode:getChildByName("start_" .. index):getChildByName("start")
    end
end

function CopyItem:setStart(count)
    if count < 1 then return end
    self.startNode:setVisible(true)
    for index=1, 3 do
        self.startList[index]:setVisible(false)
    end
    for index=1, count do
        self.startList[index]:setVisible(true)
    end
end

function CopyItem:removeEvent()
    dxyDispatcher_removeEventListener("CopySelectLayer_CopyItem",self,self.updateLevel)
end

function CopyItem:initEvent()
    dxyDispatcher_addEventListener("CopySelectLayer_CopyItem",self,self.updateLevel)
    
    if(self.copyIcon)then
        self.copyIcon:addTouchEventListener(function(target,type)
            if(type==2)then
                SoundsFunc_playSounds(SoundsType.OPEN_PAGE,false)
               if self.m_config.Type == 2 then
            	  if self.aheadCopyData.start == 1 or self.aheadCopyData.start == 2 then
                	  dxyFloatMsg:show("''"..self.aheadCopyData.config.Name.."''".."达到三星才能开启")
                  else
                      zzc.CopySelectController:showCopyDetails(self.m_data)
                  end
               else
--                  local role = zzm.CharacterModel:getCharacterData()
--                  if self.m_config.DeblockingLv> role:getValueByType(enCharacterAttrType.LV) then
--                    dxyFloatMsg:show(self.m_config.DeblockingLv.."级才能开启")
--                  else
--                    zzc.CopySelectController:showCopyDetails(self.m_data)
--                  end 
                  zzc.CopySelectController:showCopyDetails(self.m_data)
               end
            end
        end)
    end
end

function CopyItem:updateLevel(lastLV)
    if self.m_config == nil or lastLV == nil then
        return
    end
    if self.lockLVFlag ~= true then
    	return
    end
    self:setConfig(self.m_config)
end

function CopyItem:setConfig(data)
    self.m_config = data
    if self.m_config == nil then
        return
    end
    self.visibleSize = cc.Director:getInstance():getVisibleSize()
    self.origin = cc.Director:getInstance():getVisibleOrigin()

    local posX = self.origin.x + self.visibleSize.width/2
    local posY = self.origin.y + self.visibleSize.height/2
    
    self.m_chapterID = data.ChapterId
    
    self:update(zzm.CopySelectModel:getCopyData(data.Id))
    self.copyIcon:loadTextureNormal(self:getPathName(data.Type,1))
    self.copyIcon:loadTexturePressed(self:getPathName(data.Type,2))
    self.copyIcon:loadTextureDisabled(self:getPathName(data.Type,3))
    self.copyIcon:setTitleText("")
    --self.copyName:setString(data.Name)
    
    local x = data.IconX - 480 + posX
    local y = data.IconY - 320 + posY
    
    self:setPositionX(x) 
    self:setPositionY(y) 

end

function CopyItem:getPathName(copyType, buttonState)
    local name = "dxyCocosStudio/png/chapter/new/"
    if copyType == 1 then
    	name = name .. "copy_putong"
    elseif copyType == 2 then
        name = name .. "copy_jingyin"
    elseif copyType == 3 then
        name = name .. "copy_boss"
    else
        name = name .. "copy_putong"
    end
    if buttonState == 1 or buttonState == 2 then
    	name = name .. "_n.png"
    elseif buttonState == 3 then
        name = name .. "_d.png"
    else
        name = name .. "_n.png"
    end
    return name
end

function CopyItem:update(data)
    self.m_data = data
    if self.m_data == nil then --未开启不能进入
        self:setVisible(false)
    	return
    end
    self.m_data.config = self.m_config
        
    local startTalk = 0
    local endTalk = 0
    if self.m_data.start == 0 then
        startTalk = self.m_data.config.StartTalkId
        endTalk = self.m_data.config.EndTalkId
        if endTalk == nil then
            endTalk = 0
        end
        if startTalk == nil then
            startTalk = 0
        end
    end
    
    self.m_data.startTalkID = startTalk
    self.m_data.endTalkID = endTalk
    self.m_data.chpaterID = self.m_chapterID
    
    print("data.start = "..data.start)
    self:setStart(data.start)
    print("open copy ID: " .. self.m_config.Id)
    self.copyIcon:setTouchEnabled(true)
    self.copyIcon:setBright(true)
--    local aheadChapterId = SceneConfigProvider:getCopyKeyById(self.m_config.Id)
--    self.aheadCopyData = zzm.CopySelectModel:getCopyData(aheadChapterId)
    local role = zzm.CharacterModel:getCharacterData()
--    if self.m_config.DeblockingLv> role:getValueByType(enCharacterAttrType.LV) then
--	print("-----------" .. role:getValueByType(enCharacterAttrType.LV))
	if self.m_config.Id == 10101 then
		--self.copyName:setString("副本开启等级 " .. self.m_config.DeblockingLv)
            self.copyName:setVisible(false)
            self.copyIcon:setTouchEnabled(true)
            self.copyIcon:setBright(true)
            return
	end
	
	
    if self.m_config.Type == 2 then
        self.aheadCopyData = zzm.CopySelectModel:getCopyData(self.m_config.Id - 10000)
        if self.aheadCopyData.start == 3 then
                self.copyName:setVisible(false)
                self.copyIcon:setTouchEnabled(true)
                self.copyIcon:setBright(true)

        elseif self.aheadCopyData.start == 1 or self.aheadCopyData.start == 2 then
            --self.copyName:setString(self.aheadCopyData.config.Name.."达三星即开启")
            self.copyName:setVisible(false)
            self.copyIcon:setTouchEnabled(true)
            self.copyIcon:setBright(false)
        else
            --self.copyName:setString(self.aheadCopyData.config.Name.."达三星即开启")
            self.copyName:setVisible(false)
            self.copyIcon:setTouchEnabled(false)
            self.copyIcon:setBright(false)
        end
    		
	else
        local aheadChapterId = SceneConfigProvider:getCopyKeyById(self.m_config.Id)
        self.aheadCopyData = zzm.CopySelectModel:getCopyData(aheadChapterId)
        if self.aheadCopyData.config.Type == 2 then
            aheadChapterId = SceneConfigProvider:getCopyKeyById(aheadChapterId)
        	self.aheadCopyData = zzm.CopySelectModel:getCopyData(aheadChapterId)
        end
--        self.aheadCopyData = zzm.CopySelectModel:getCopyData(self.m_config.Id - 1)
        if self.aheadCopyData.start > 0  then
           if self.m_config.DeblockingLv> role:getValueByType(enCharacterAttrType.LV) then
           	  self.copyName:setVisible(true)
           	  self.copyName:setString(self.m_config.DeblockingLv.."级开启")
           	  self.copyIcon:setTouchEnabled(false)
           	  self.copyIcon:setBright(false)
           	  self.lockLVFlag = true
           else
              self.copyName:setVisible(false)
              self.copyIcon:setTouchEnabled(true)
              self.copyIcon:setBright(true)
           end
            --self.copyName:setString(self.aheadCopyData.config.Name.."通过即开启")
--            self.copyName:setVisible(false)
--            self.copyIcon:setTouchEnabled(true)
--            self.copyIcon:setBright(true)
	    end
	    
	
	end
     
    
end

function CopyItem:getItemHgight()
    return self.titleBG:getContentSize().height + self.itemPanel:getContentSize().height
end




