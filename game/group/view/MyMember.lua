MyMember = MyMember or class("MyMember",function()
    return cc.Node:create()
end)
local PATH = "dxyCocosStudio/png/group/"

function MyMember:ctor()
    self._data = nil
end

function MyMember:create(data,i)
    local node = MyMember:new()
    node:init(data,i)
    return node
end

function MyMember:init(data,i)
    self._csb = cc.CSLoader:createNode("res/dxyCocosStudio/csd/ui/group/MyMember.csb")
    self:addChild(self._csb)
    
--btn    
    self._btnMem = ccui.Button:create()
    self._btnMem:loadTextureNormal(PATH.."bgmem.png")
    self._btnMem:loadTexturePressed(PATH.."bgmem.png")
    self._btnMem:setAnchorPoint(0,1)
    self._btnMem:setPressedActionEnabled(true)
    data[1]:addChild(self._btnMem,1)
    self._btnMem:setPosition(data[2],data[3])
    
    local role = zzm.CharacterModel:getCharacterData()
    local enCAT = enCharacterAttrType
    self.myUid = role:getValueByType(enCAT.UID)
  
    self._btnMem:addTouchEventListener(function(target,type)
        if type == 2 then
            if self._data.uid ~= self.myUid then
                SoundsFunc_playSounds(SoundsType.OPEN_PAGE,false)
                require "src.game.group.view.PersonFunc"
                local func = PersonFunc:create(self._data)
                local scene = SceneManager:getCurrentScene()
                scene:addChild(func)
            end
        end
    end)
    
    self._btnRoot = self._csb:getChildByName("btn_root")
    self._btnRoot:addTouchEventListener(function(target,type)
        if type == 2 then
            if self._data.uid ~= self.myUid then
                SoundsFunc_playSounds(SoundsType.OPEN_PAGE,false)
                if GroupConfig:getRoot(zzm.GroupModel:getRoot(_G.RoleData.Uid))["AppointJob"] then
                    local posy = self._btnMem:getPositionY()
                    require "src.game.group.view.ChangeRoot"
                    self.itemChangeRoot = ChangeRoot:create(self._data)
                    self.itemChangeRoot:setPosition(318,posy-36)
                    data[1]:addChild(self.itemChangeRoot,3)
                else
                    TipsFrame:create("你的权限不足")
                end
            end
        end
    end)
    
--pro
    self._head = self._csb:getChildByName("bghead"):getChildByName("head")

    self.name = self._csb:getChildByName("name")
    
    self.lv = self._csb:getChildByName("lv")
    
    self.power = self._csb:getChildByName("power")
    
    self.time = self._csb:getChildByName("time")
    
    self.root = self._csb:getChildByName("root")
end

function MyMember:setData(data)
    self._data = data
    self._head:setTexture("HeroIcon/IconSquare_10"..data.pro..".png")
    self.name:setString(self._data["name"])
    self.lv:setString(self._data["lv"])
    self.power:setString(self._data["power"])
    self.time:setString(cn:cgTime(self._data["closest"]))
    self.root:setString(zzd.GroupData[self._data["root"]])
end

function MyMember:changeRoot(data)
    self._data["root"] = data["root"]
    self.root:setString(zzd.GroupData[data["root"]])
    if self.itemChangeRoot then
        self.itemChangeRoot:removeFromParent()
        self.itemChangeRoot = nil
    end
end

function MyMember:updatePower(data)
    self._data["power"] = data["power"]
    self.power:setString(data["power"])
end
