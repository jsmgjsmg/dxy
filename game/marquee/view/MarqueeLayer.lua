MarqueeLayer = MarqueeLayer or class("MarqueeLayer",function()
    return cc.Layer:create()
end)

function MarqueeLayer:ctor()
	self.text = nil
	self:initUI()
end



function MarqueeLayer:initUI()
    self._csbNode = cc.CSLoader:createNode("dxyCocosStudio/csd/ui/commonUI/MarqueeTips.csb")
    self:addChild(self._csbNode)

    self.coverPanel = self._csbNode:getChildByName("Sprite"):getChildByName("Panel")
    self.text = self.coverPanel:getChildByName("announcementTxt")

    self.visibleSize = cc.Director:getInstance():getVisibleSize()
    self.origin = cc.Director:getInstance():getVisibleOrigin()
    self.posX = self.origin.x + self.visibleSize.width/2
    self.posY = self.origin.y + self.visibleSize.height/2+220
    self:setPosition(self.posX, self.posY)

end


function MarqueeLayer:init(news,playNum,priority)

    self.text:setString(news)
    
    print("优先级:"..priority.." 播放次数："..playNum.." 内容："..news)

    self.textSize = self.text:getContentSize()

    --    local action1 = cc.CallFunc:create(playTime,cc.p(-coverPosX-coverSize.width,0))
    --    local action2 = cc.CallFunc:create(function() self:removeFromParent() end)
    --    local sequence = cc.Sequence:create(action1, action2)
    --    self.text:runAction(sequence)
    local textSize = self.text:getContentSize()
    local coverPosX = self.coverPanel:getPositionX()
    local coverPosY = self.coverPanel:getPositionY()
    self.coverSize = self.coverPanel:getContentSize()

    self.text:setPosition(coverPosX+self.coverSize.width/2,coverPosY)
    local playSpeed = MoveNewsConfig:getPlaySpeed()
    local playTime = (textSize.width+self.coverSize.width)/playSpeed
    local action1 = cc.MoveBy:create(playTime,cc.p(-textSize.width-self.coverSize.width,0))
--    self.text:runAction(action)
    local function revertPosi() 
        self.text:setPosition(coverPosX+self.coverSize.width/2,coverPosY) 
    end
    local revertSeq = cc.Sequence:create(action1,cc.CallFunc:create(revertPosi))
    local repeatAction = cc.Repeat:create(revertSeq,playNum)
--    local action2 = cc.CallFunc:create(function() table.remove(zzm.MarqueeModel.newsTable,1) end)
    local action3 = cc.CallFunc:create(function() self:textAction() end)
    
    local sequence = cc.Sequence:create(repeatAction,action3)
    self.text:runAction(sequence)
    
end

function MarqueeLayer:textAction()

    if #zzm.MarqueeModel.newsTable <= 0 then
        zzc.MarqueeController.isPlaying = true
    	self:removeFromParent()
    	return
    end
    local news = zzm.MarqueeModel.newsTable[1].News
    local priority = zzm.MarqueeModel.newsTable[1].Priority
    local playNum = zzm.MarqueeModel.newsTable[1].PlayNumber
    table.remove(zzm.MarqueeModel.newsTable,1)
    self:init(news,playNum,priority)

end
