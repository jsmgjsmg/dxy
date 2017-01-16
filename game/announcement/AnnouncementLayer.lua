
AnnouncementLayer = AnnouncementLayer or class("AnnouncementLayer",function()
    return cc.Layer:create()
end)

function AnnouncementLayer.create()
    local layer = AnnouncementLayer.new()
    return layer
end

function AnnouncementLayer:ctor()
    self._csbNode = nil
    self.btn_back = nil
    self.scrollView = nil
    self.contentsPanel = nil
    
    self:initUI()
    self:initEvent()
    dxySwallowTouches(self)
end

function AnnouncementLayer:initUI()
    self._csbNode = cc.CSLoader:getInstance():createNodeWithFlatBuffersFile("dxyCocosStudio/csd/ui/announcement/AnnouncementLayer.csb")
    self:addChild(self._csbNode)
    
    self.visibleSize = cc.Director:getInstance():getVisibleSize()
    self.origin = cc.Director:getInstance():getVisibleOrigin()

    local posX = self.origin.x + self.visibleSize.width/2
    local posY = self.origin.y + self.visibleSize.height/2

    self:setPosition(posX, posY)

    local node = self._csbNode:getChildByName("ImageBG")
    self.btn_back = node:getChildByName("Back")
    self.scrollView = node:getChildByName("Panel"):getChildByName("ScrollView")
    self.scrollView:setScrollBarEnabled(false)
    self.contentsPanel = self.scrollView:getChildByName("Panel")
    
    require("game/announcement/AnnouncementItem")
    AnnouncementItem.parentSize = self.scrollView:getContentSize().width
    
    local dataList = zzm.AnnouncementModel.announcementList
    local tempHeight = self.scrollView:getContentSize().height
    for index=#dataList,1,-1 do
        local item = AnnouncementItem.create()
        self.scrollView:addChild(item)
        item:setPosition(0,tempHeight)
        item:update(dataList[index])
        tempHeight = tempHeight + item:getItemHgight()
        self.scrollView:setInnerContainerSize(cc.size(self.scrollView:getContentSize().width,tempHeight))
    end

end


function AnnouncementLayer:initEvent()
    if(self.btn_back)then
        self.btn_back:addTouchEventListener(function(target,type)
            if(type==2)then
                SoundsFunc_playSounds(SoundsType.CLOSE_PAGE,false)
                zzc.AnnouncementController:closeLayer()
            end
        end)
    end
end

function AnnouncementLayer:WhenClose()

end

