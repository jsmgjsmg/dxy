ItemRecharge = ItemRecharge or class("ItemRecharge",function()
    return cc.Node:create()
end)
local PATH = "res/dxyCocosStudio/png/equip/"

function ItemRecharge:ctor()
    self._goods = {}
    self._spColor = {}
    self._spGoods = {}
    self._arrNum = {}
end

function ItemRecharge:create()
    local node = ItemRecharge.new()
    node:init()
    return node
end

function ItemRecharge:init()
    self._csb = cc.CSLoader:createNode("dxyCocosStudio/csd/ui/activity/ItemAcPK.csb")
    self:addChild(self._csb)

    local Image = self._csb:getChildByName("Image")
    self._spPK = Image:getChildByName("spPK")
    self._spPK:setVisible(false)
    self._spRecharge = Image:getChildByName("spRecharge")
    self._spRecharge:setVisible(true)
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

function ItemRecharge:update(data)
    self.m_data = data
    if not self.m_data then
        return
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
    
    self._txtNum:setString(Config.Finish1/VipConfig:getRate())
    self._txtPrecent:setString(self.m_data.Finish.."/"..Config.Finish1)
	
    self:changePro(self.m_data)
end

function ItemRecharge:changePro(data)
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