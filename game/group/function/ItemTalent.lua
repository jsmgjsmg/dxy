ItemTalent = ItemTalent or class("ItemTalent",function()
    return cc.Node:create()
end)
local SF_PATH = "dxyCocosStudio/png/groupfunc/talent/"

function ItemTalent:ctor()
    self.addType = {
        [1] = "生命",
        [2] = "",
        [3] = "攻击",
        [4] = "防御",
    }
    self._arrIcon = {}
end

function ItemTalent:create()
    local node = ItemTalent.new()
    node:init()
    return node
end

function ItemTalent:init()
    self._csb = cc.CSLoader:createNode("dxyCocosStudio/csd/ui/groupfunc/ItemTalent.csb")
    self:addChild(self._csb)
    
    dxyExtendEvent(self)
    
    self._spSprite = self._csb:getChildByName("Sprite")
    self._node = self._csb:getChildByName("Node")
    self._txtAtt = self._node:getChildByName("txtAtt")
    self._txtUse = self._node:getChildByName("txtUse")
    for i=1,4 do
        self._arrIcon[i] = self._node:getChildByName("icon"..i)
    end
end

function ItemTalent:initEvent()
    dxyDispatcher_addEventListener("ItemTalent_update",self,self.update)
end

function ItemTalent:removeEvent()
    dxyDispatcher_removeEventListener("ItemTalent_update",self,self.update)
end

function ItemTalent:update(state,config)
    if state == 1 then --未解锁
        self._spSprite:setSpriteFrame(cc.SpriteFrameCache:getInstance():getSpriteFrame(SF_PATH.."3.png"))
        self._node:setVisible(false)
    elseif state == 2 then --当前
        self._spSprite:setSpriteFrame(cc.SpriteFrameCache:getInstance():getSpriteFrame(SF_PATH.."1.png"))
--        self._node:setVisible(true)
--        for i=1,4 do
--            if i == config.TalentType then
--                self._arrIcon[i]:setVisible(true)
--            else
--                if self._arrIcon[i] then
--                    self._arrIcon[i]:setVisible(false)
--                end
--            end
--        end
--        self._txtAtt:setString("+"..config.TalentNum)
--        self._txtUse:setString("-"..config.TalentCost)
    elseif state == 3 then --已解锁
        self._spSprite:setSpriteFrame(cc.SpriteFrameCache:getInstance():getSpriteFrame(SF_PATH.."2.png"))
        self._node:setVisible(false)
    end
    self._node:setVisible(false)
end
