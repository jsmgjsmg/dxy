ItemAcOnce = ItemAcOnce or class("ItemAcOnce",function()
    return cc.Node:create()
end)
local PATH = "res/dxyCocosStudio/png/equip/"

function ItemAcOnce:ctor()
    self._goods = {}
    self._spColor = {}
    self._spGoods = {}
    self._txtNum = {}
    self._typeTitle = {}
end

function ItemAcOnce:create()
    local node = ItemAcOnce.new()
    node:init()
    return node
end

function ItemAcOnce:init()
    self._csb = cc.CSLoader:createNode("dxyCocosStudio/csd/ui/activity/ItemAcLv.csb")
    self:addChild(self._csb)

	local tl = cc.CSLoader:createTimeline("dxyCocosStudio/csd/ui/activity/ItemAcLv.csb") 
    self._csb:runAction(tl) 
    tl:gotoFrameAndPlay(0,true) 
	
    local Image = self._csb:getChildByName("Image")
    self._typeTitle[ActivityType.LV] = Image:getChildByName("spLv")
    self._txtLv = self._typeTitle[ActivityType.LV]:getChildByName("txtLv")
    self._typeTitle[ActivityType.LOGIN] = Image:getChildByName("txtDate")
    self._typeTitle[ActivityType.ONCERECHARGE] = Image:getChildByName("OnceCharge")
    self._typeTitle[ActivityType.ONCECONSUME] = Image:getChildByName("OnceConsume")
    for key, var in pairs(self._typeTitle) do
    	var:setVisible(false)
    end
    self._txtOnceCharge = Image:getChildByName("txtOnceCharge")
    
    for i=1,4 do
        self._goods[i] = Image:getChildByName("goods"..i)
        self._spColor[i] = self._goods[i]:getChildByName("spColor")
        self._spGoods[i] = self._goods[i]:getChildByName("spGoods")
        self._txtNum[i] = self._goods[i]:getChildByName("txtNum")
    end
    
    self._spGet = Image:getChildByName("spGet")
    self._btnGet = Image:getChildByName("btnGet")
    self._btnNot = Image:getChildByName("btnNot")
    self._btnGet:addTouchEventListener(function(target,type)
        if type == 2 then
            zzc.ActivityController:getActivity(self.m_data.Id)
        end
    end)
end

function ItemAcOnce:update(data,type)
    self.m_data = data
    if not self.m_data then
        return
    end
    
    for key, var in pairs(self._typeTitle) do
    	if key == type then
    	   var:setVisible(true)
    	else
    	   var:setVisible(false)
    	end
    end
    
    local Config = self.m_data.Config
    local Rewards = dxyConfig_toList(Config.Rewards)
    for i=1,4 do
        if Rewards[i] then
            self._goods[i]:setVisible(true)
            if Rewards[i].Type == 6 or Rewards[i].Type == 10 then
                local goods = GoodsConfigProvider:findGoodsById(Rewards[i].Id)
                self._spColor[i]:setTexture(PATH.."spiritQuality_"..goods.Quality..".png")
                if Rewards[i].Type == 6 then
                    self._spGoods[i]:setTexture("Icon/"..goods.Icon..".png")
                else
                    self._spGoods[i]:setTexture("GodGeneralsIcon/"..goods.Icon..".png")
                end
            else
                self._spColor[i]:setTexture(PATH.."spiritQuality_1.png")
                self._spGoods[i]:setTexture(zzd.TaskData.arrGoodsIcon[Rewards[i].Type])
            end
            self._txtNum[i]:setString(cn:convert(Rewards[i].Num))
        else
            self._goods[i]:setVisible(false)
        end
    end
    
    if type ~= ActivityType.LV then
        self._txtOnceCharge:setVisible(true)
        self._txtOnceCharge:setString(Config.Finish1)
    else
        self._txtLv:setString(Config.Finish1)
    end

    self:changePro(self.m_data)
end

function ItemAcOnce:changePro(data)
    if data.State == 0 then
        self._btnNot:setVisible(true)
        self._btnGet:setVisible(false)
        self._spGet:setVisible(false)
    elseif data.State == 1 then
        self._btnNot:setVisible(false)
        self._btnGet:setVisible(true)
        self._spGet:setVisible(false)
    else
        self._btnNot:setVisible(false)
        self._btnGet:setVisible(false)
        self._spGet:setVisible(true)
    end 
end