ActivityNode = ActivityNode or class("ActivityNode",function()
    return cc.Node:create()
end) 
require("game.activity.view.ItemAcBtn")
require("game.activity.view.ScrollViewNode")
local BTNNUM = 10    
local SPACE = 60              

function ActivityNode:ctor()
    self.visibleSize = cc.Director:getInstance():getVisibleSize()
    self.origin = cc.Director:getInstance():getVisibleOrigin()
    
    self.arrItemBtn = {}
    self.arrItemBtnFunc = {}
    self.arrSVNode = {}
end

function ActivityNode:create()
    local node = ActivityNode.new()
    node:init()
    return node
end

function ActivityNode:init()
    self._csb = cc.CSLoader:createNode("dxyCocosStudio/csd/ui/activity/ActivityNode.csb")
    self:addChild(self._csb)
    self._csb:setPosition(self.origin.x + self.visibleSize.width / 2, self.origin.y + self.visibleSize.height / 2)

    dxyExtendEvent(self)
    -- 拦截
    dxySwallowTouches(self)
    
    local bg = self._csb:getChildByName("bgHole")
    
    local btnBack = bg:getChildByName("btnBack")
    btnBack:addTouchEventListener(function(target,type)
        if type == 2 then
            zzc.ActivityController:closeLayer()
        end
    end)
    
    local AcBtnList = zzm.ActivityModel.AcBtnList
    self._svBtn = self._csb:getChildByName("svBtn")
    self._svBtn:setScrollBarEnabled(false)
    local conSize = self._svBtn:getContentSize()
    local real = #AcBtnList * SPACE
    local last = conSize.height > real and conSize.height or real
    self._svBtn:setInnerContainerSize(cc.size(conSize.width,last))
    
    for i=1,#AcBtnList do
        self.arrItemBtn[i] = ItemAcBtn:create()
        self.arrItemBtn[i]:setPosition(-8,last-(i-1)*SPACE)
        self.arrItemBtn[i]:update(AcBtnList[i])
        self._svBtn:addChild(self.arrItemBtn[i])
    end
    
    self._txtDate = self._csb:getChildByName("txtDate")
    local y,m,d = cn:curYMD()
    self._txtDate:setString("今日 "..y.."."..m.."."..d)
    
    self:HideOtherBtn(zzm.ActivityModel.AcBtnList[1])
end

function ActivityNode:initEvent()
    dxyDispatcher_addEventListener("ActivityNode_addScrollView",self,self.addScrollView)
    dxyDispatcher_addEventListener("ActivityNode_changeActivity",self,self.changeActivity)
    dxyDispatcher_addEventListener("ActivityNode_HideOtherBtn",self,self.HideOtherBtn)
end

function ActivityNode:removeEvent()
    dxyDispatcher_removeEventListener("ActivityNode_addScrollView",self,self.addScrollView)
    dxyDispatcher_removeEventListener("ActivityNode_changeActivity",self,self.changeActivity)
    dxyDispatcher_removeEventListener("ActivityNode_HideOtherBtn",self,self.HideOtherBtn)
end

function ActivityNode:addScrollView(type)
    local data = zzm.ActivityModel:getDataByType(type)
    local isSVN = false
    for key, var in pairs(zzd.ActivityData.svType) do
    	if var == type then
	       isSVN = true
    	   break
    	end
    end
    if isSVN then  --普通SV
        self.arrSVNode[type] = ScrollViewNode:create()
        self.arrSVNode[type]:update(data,type)
        self._csb:addChild(self.arrSVNode[type])
    end
    
--兑换
    if type == DefineConst.CONST_ACTIVITY_TYPE_EXCHANGE then
        require("game.activity.view.PackageChangeLayer")
        self.arrSVNode[type] = PackageChangeLayer:create()
        self.arrSVNode[type]:update(type)
        self._csb:addChild(self.arrSVNode[type])
    end    
    
end

function ActivityNode:HideOtherBtn(type)
    if self.arrSVNode[type] then
        self.arrSVNode[type]:setVisible(true)
    else
        if type ~= DefineConst.CONST_ACTIVITY_TYPE_EXCHANGE then
            zzc.ActivityController:registerAcType(type)
        else
            self:addScrollView(type)
        end
    end

    for key, var in pairs(self.arrItemBtn) do
    	if var.m_data == type then
            self.arrItemBtn[key]:setTouchEnabled(false)
            self.arrItemBtn[key]:setBright(false)
    	else
            self.arrItemBtn[key]:setTouchEnabled(true)
            self.arrItemBtn[key]:setBright(true)
    	end
    end
    for key, var in pairs(self.arrSVNode) do
        if key ~= type then
            var:setVisible(false)
        end
    end
end

function ActivityNode:changeActivity(data)
    self.arrSVNode[data.type]:changePro(data.data)
end

