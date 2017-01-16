ItemAcTotal = ItemAcTotal or class("ItemAcTotal",function()
    return cc.Node:create()
end)
local PATH = "res/dxyCocosStudio/png/equip/"

function ItemAcTotal:ctor()
    self._goods = {}
    self._spColor = {}
    self._spGoods = {}
    self._arrNum = {}
    self._typeTitle = {}
end

function ItemAcTotal:create()
    local node = ItemAcTotal.new()
    node:init()
    return node
end

function ItemAcTotal:init()
    self._csb = cc.CSLoader:createNode("dxyCocosStudio/csd/ui/activity/ItemAcPK.csb")
    self:addChild(self._csb)

    local Image = self._csb:getChildByName("Image")
    self._typeTitle[ActivityType.PK] = Image:getChildByName("spPK")
    self._typeTitle[ActivityType.RECHARGE] = Image:getChildByName("spRecharge")
    self._typeTitle[ActivityType.ALLCONSUME] = Image:getChildByName("spConsume")
    for key, var in pairs(self._typeTitle) do
    	var:setVisible(false)
    end
    self._txtNum = Image:getChildByName("txtNum")

    for i=1,3 do
        self._goods[i] = Image:getChildByName("goods"..i)
        self._spColor[i] = self._goods[i]:getChildByName("spColor")
        self._spGoods[i] = self._goods[i]:getChildByName("spGoods")
        self._arrNum[i] = self._goods[i]:getChildByName("txtNum")
    end

    self._spGet = Image:getChildByName("spGet")
    self._ndBtn = Image:getChildByName("ndBtn")
    self._txtPrecent = self._ndBtn:getChildByName("txtPrecent")
    self._btnGet = self._ndBtn:getChildByName("btnGet")
    self._btnGoto = self._ndBtn:getChildByName("btnGoto")
    self._btnGet:addTouchEventListener(function(target,type)
        if type == 2 then
            zzc.ActivityController:getActivity(self.m_data.Id)
        end
    end)
    self._btnGoto:addTouchEventListener(function(target,type)
        if type == 2 then
            zzc.RechargeController:showLayer()
            zzc.ActivityController:closeLayer()
        end
    end)
end

function ItemAcTotal:update(data,type)
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
    for i=1,3 do
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
            self._arrNum[i]:setString(Rewards[i].Num)
        else
            self._goods[i]:setVisible(false)
        end
    end
    
    if type == ActivityType.RECHARGE then
        self._txtNum:setString(Config.Finish1/VipConfig:getRate())
    else
        self._txtNum:setString(Config.Finish1)
    end
    self._txtPrecent:setString(self.m_data.Finish.."/"..Config.Finish1)

	if _G.gSDKhuoshu or _G.gSDKAoyou then
		 if type == ActivityType.RECHARGE then
			local realRMB = _G.RoleData.ALLRMB / 200
			self._txtPrecent:setString(realRMB.."/"..Config.Finish1)
			self._txtNum:setString(Config.Finish1)
		 end
	end
	
    self:changePro(self.m_data)
end

function ItemAcTotal:changePro(data)
    if data.State == 0 then
        self._ndBtn:setVisible(true)
        self._btnGet:setVisible(false)
        self._btnGoto:setVisible(true)
        self._spGet:setVisible(false)
    elseif data.State == 1 then
        self._ndBtn:setVisible(true)
        self._btnGet:setVisible(true)
        self._btnGoto:setVisible(false)
        self._spGet:setVisible(false)
    elseif data.State == 2 then
        self._ndBtn:setVisible(false)
        self._spGet:setVisible(true)
    end 
end