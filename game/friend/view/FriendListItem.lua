
FriendListItem = FriendListItem or class("FriendListItem",function()
    return ccui.Layout:create()
end)

function FriendListItem.create(type)
    local node = FriendListItem.new(type)
    return node
end

function FriendListItem:ctor(type)
    self._csbNode = nil
    self._pageType = type
    self:initUI()
end

function FriendListItem:initUI()
    self._csbNode = cc.CSLoader:createNode("dxyCocosStudio/csd/ui/friend/FriendListItem.csb")
    self:addChild(self._csbNode)

    self:setContentSize(cc.size(660,100))
    self:setAnchorPoint(cc.p(0,0))
    self:setTouchEnabled(true)
    

    local btnNode = self._csbNode:getChildByName("Button")
    self.selectImage = btnNode:getChildByName("select")
    self.selectImage:setVisible(false)
    self.backNode = btnNode:getChildByName("Back" .. self:getNameStr())
    self.backNode:setVisible(true)

    local frontNode = btnNode:getChildByName("Front")
    self.lv = frontNode:getChildByName("LV")
    self.name = frontNode:getChildByName("Name")
    self.btn_head = frontNode:getChildByName("Button")
    self.icon_head = self.btn_head:getChildByName("Head")
    
    if(self.btn_head)then
        self.btn_head:addTouchEventListener(function(target,type)
            if(type==2)then
                FriendFunctionTips.m_data = self.m_data
                FriendFunctionTips.create()
            end
        end)
    end
end

function FriendListItem:getNameStr()
    local name = ""
    if self._pageType == FRIEND_PANEL_TYPE.ListLayer then
        name = "1"
    elseif self._pageType == FRIEND_PANEL_TYPE.ApplyLayer then
        name = "3"
    elseif self._pageType == FRIEND_PANEL_TYPE.ContactLayer then
        name = "2"
    elseif self._pageType == FRIEND_PANEL_TYPE.GiftLayer then
        name = "4"
    elseif self._pageType == FRIEND_PANEL_TYPE.AddLayer then
        name = "2"
    end
    return name
end


function FriendListItem:setSelect(flag)
    self.selectImage:setVisible(flag)
end

function FriendListItem:updateAddItem(data)
    self.m_data = data
    self.lv:setString("LV." .. self.m_data.lv)
    self.name:setString(self.m_data.name)
    local hero = HeroConfig:getValueById(self.m_data.pro)
    self.icon_head:setTexture(hero.IconSquare)
    if self._pageType == FRIEND_PANEL_TYPE.ListLayer then
        self.times = self.backNode:getChildByName("Timer")
        if self.m_data.times then
            local time = os.time() - self.m_data.times
            if time > 3600  then
        		local h = math.floor(time/3600)
        		
        		local m = math.floor(time/60 - h*60)
        		self.times:setString("最近登录："..h.."小时前")
        		if h > 24 then
                    self.times:setString("最近登录：1天前")
        		end
        	else
                local m = math.floor(time/60)
                self.times:setString("最近登录："..m.."分钟前")
        	end
        end
--        self.times:setString(self.m_data.times)
        self.btn_Give = self.backNode:getChildByName("Button")
        self.desc = self.backNode:getChildByName("Des")
        self.power = self.backNode:getChildByName("Power")
        self.power:setString(self.m_data.power)
        if(self.btn_Give)then
            self.btn_Give:addTouchEventListener(function(target,type)
                if(type==2)then
                    zzc.FriendController:request_GiveGift(self.m_data.uid,FRIEND_PANEL_TYPE.ListLayer)
                    self.desc:setVisible(true)
                    self.btn_Give:setVisible(false)
                end
            end)
        end
        if self.m_data.gift == 1 then
            self.desc:setVisible(true)
            self.btn_Give:setVisible(false)
        elseif self.m_data.gift == 0 then
            self.desc:setVisible(false)
            self.btn_Give:setVisible(true)
        end
    elseif self._pageType == FRIEND_PANEL_TYPE.ApplyLayer then
        self.btn_Cancle = self.backNode:getChildByName("Button1")
        self.btn_OK = self.backNode:getChildByName("Button2")
        if(self.btn_OK)then
            self.btn_OK:addTouchEventListener(function(target,type)
                if(type==2)then
                    zzc.FriendController:request_AcceptFriend(self.m_data.uid, 1)
                end
            end)
        end
        if(self.btn_Cancle)then
            self.btn_Cancle:addTouchEventListener(function(target,type)
                if(type==2)then
                    zzc.FriendController:request_AcceptFriend(self.m_data.uid, 0)
                end
            end)
        end
    elseif self._pageType == FRIEND_PANEL_TYPE.ContactLayer then
        self.power = self.backNode:getChildByName("Power")
        self.power:setString(self.m_data.power)
        self.times = self.backNode:getChildByName("Timer")
        if self.m_data.times then
            local time = os.time() - self.m_data.times
            if time > 3600  then
                local h = math.floor(time/3600)

                local m = math.floor(time/60 - h*60)
                self.times:setString("最近联系："..h.."小时前")
                if h > 24 then
                    self.times:setString("最近联系：1天前")
                end
            else
                local m = math.floor(time/60)
                self.times:setString("最近联系："..m.."分钟前")
            end
        end
    elseif self._pageType == FRIEND_PANEL_TYPE.GiftLayer then
        self.btn_OK = self.backNode:getChildByName("Button")
        if(self.btn_OK)then
            self.btn_OK:addTouchEventListener(function(target,type)
                if(type==2)then
                    print("gift: ", self.m_data.gift)
                    zzc.FriendController:request_AcceptGift(self.m_data.gift)
                    self:removeFromParent()
                    zzm.FriendModel:deleteFriendData(FRIEND_LIST_TYPE.GiftList,self.m_data)
                    if zzm.FriendModel.friendList[FRIEND_LIST_TYPE.GiftList] then
                        if next(zzm.FriendModel.friendList[FRIEND_LIST_TYPE.GiftList]) == nil then
                            zzm.FriendModel.giftRed = false
                        end
                    end
                end
            end)
        end
    elseif self._pageType == FRIEND_PANEL_TYPE.AddLayer then
        self.power = self.backNode:getChildByName("Power")
        self.power:setString(self.m_data.power)
        self.times = self.backNode:getChildByName("Timer")
        if self.m_data.times then
            local time = os.time() - self.m_data.times
            if time > 3600  then
                local h = math.floor(time/3600)

                local m = math.floor(time/60 - h*60)
                self.times:setString("最近登录："..h.."小时前")
                if h > 24 then
                    self.times:setString("最近登录：1天前")
                end
            else
                local m = math.floor(time/60)
                self.times:setString("最近登录："..m.."分钟前")
            end
        end
--        self.times:setString(self.m_data.times)
    end
end

function FriendListItem:updateButton(title)
    self.m_data = title
    self.contentsText:setString(title)
    self.itemButton:setTouchEnabled(true)
end

function FriendListItem:getItemHgight()
    return self.titleBG:getContentSize().height + self.itemPanel:getContentSize().height
end

function FriendListItem:setBtnVisible()
    if self.btn_Give and self.desc then
		self.btn_Give:setVisible(false)
        self.desc:setVisible(true)
	end
end