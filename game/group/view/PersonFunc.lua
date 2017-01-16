PersonFunc = PersonFunc or class("PersonFunc",function()
    return cc.Node:create()
end)

function PersonFunc:ctor()
    self.visibleSize = cc.Director:getInstance():getVisibleSize()
    self.origin = cc.Director:getInstance():getVisibleOrigin()
end

function PersonFunc:create(data)
    local node = PersonFunc:new()
    node:init(data)
    return node
end

function PersonFunc:init(data)
    self._csb = cc.CSLoader:createNode("dxyCocosStudio/csd/ui/group/PersonFunc.csb")
    self:addChild(self._csb)
    self._csb:setPosition(self.origin.x + self.visibleSize.width / 2, self.origin.y + self.visibleSize.height / 2)

    local bg = self._csb:getChildByName("Button_9")
    -- 拦截
    dxySwallowTouches(self,bg)
    
    local btnMsg = self._csb:getChildByName("btn_msg")
    local btnAdd = self._csb:getChildByName("btn_add")
    local btnPop = self._csb:getChildByName("btn_pop")
    btnMsg:addTouchEventListener(function(target,type)
        if type == 2 then
            SoundsFunc_playSounds(SoundsType.OPEN_PAGE,false)
            _G.RankData.Uid = data.uid
            zzc.RoleinfoController:showLayer()
            self:removeFromParent()
        end
    end)
    
    btnAdd:addTouchEventListener(function(target,type)
        if type == 2 then
            SoundsFunc_playSounds(SoundsType.UNIVERSAL_BTN,false)
            zzc.FriendController:request_AddFriend(data.uid)
--            dxyFloatMsg:show("已发送请求")
            self:removeFromParent()
        end
    end)
    
    btnPop:addTouchEventListener(function(target,type)
        if type == 2 then
            SoundsFunc_playSounds(SoundsType.UNIVERSAL_BTN,false)
            zzc.GroupController:PopatGroup(data["uid"])
            self:removeFromParent()
        end
    end) 
    btnMsg:setPressedActionEnabled(true)
    btnAdd:setPressedActionEnabled(true)
    btnPop:setPressedActionEnabled(true)
    
--name
    self._txtName = self._csb:getChildByName("txt_name")
    self._txtName:setString(data["name"])    
end

