HintMsg = HintMsg or class("HintMsg",function()
    return cc.Node:create()
end)

function HintMsg:ctor()
    self.visibleSize = cc.Director:getInstance():getVisibleSize()
    self.origin = cc.Director:getInstance():getVisibleOrigin()
end

function HintMsg:create(lv)
    local node = HintMsg:new()
    node:init(lv)
    return node
end

function HintMsg:init(lv)
    self._csb = cc.CSLoader:createNode("dxyCocosStudio/csd/ui/yuanshen/HintMsg.csb")
    self:addChild(self._csb)
    self._csb:setPosition(self.origin.x + self.visibleSize.width / 2, self.origin.y + self.visibleSize.height / 2)

    -- 拦截
    dxySwallowTouches(self)

--pro
    local Content = self._csb:getChildByName("txt")
    Content:setString()
    
    local reward = YuanShenConfig:getUpSkillPro(lv)
    local text = ""
    table.foreach(reward,function(key,value)
        if key == "Goods" then
            for i=1,#value do
                local name = GoodsConfigProvider:findGoodsById(reward[key][i]["ID"])["Name"]
                text = text..name.."*"
                text = text..reward[key][i]["Num"].." "
            end   
        end
    end)
    Content:setString(text)


    local _btnSure = self._csb:getChildByName("btn_sure")
    _btnSure:addTouchEventListener(function(target,type)
        if type == 2 then
            SoundsFunc_playSounds(SoundsType.UNIVERSAL_BTN,false)
            self:removeFromParent()
        end       
    end)

    local _btnCancel = self._csb:getChildByName("btn_cancel")
    _btnCancel:addTouchEventListener(function(target,type)
        if type == 2 then
            SoundsFunc_playSounds(SoundsType.CLOSE_PAGE,false)
            self:removeFromParent()
        end       
    end)
end