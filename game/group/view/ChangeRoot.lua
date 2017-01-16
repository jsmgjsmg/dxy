ChangeRoot = ChangeRoot or class("ChangeRoot",function()
    return cc.Node:create()
end)

function ChangeRoot:ctor()
    self._arrRoot = {}
    self._arrBtn = {}
end

function ChangeRoot:create(data)
    local node = ChangeRoot:new()
    node:init(data)
    return node
end

function ChangeRoot:init(data)
    self._csb = cc.CSLoader:createNode("res/dxyCocosStudio/csd/ui/group/ChangeRoot.csb")
    self:addChild(self._csb)
    
--    local swallow = self._csb:getChildByName("swallow")
    
--    swallow:addTouchEventListener(function(target,type)
--        if type == 2 then
--            self:removeFromParent()    
--        end
--    end)
    local swallow = self._csb:getChildByName("Image_1")
    
    -- 拦截
    dxySwallowTouches(self,swallow)
    
    local txtNow = self._csb:getChildByName("txt_now")
    txtNow:setString(zzd.GroupData[data["root"]])
    
    for i=1,3 do
        self._arrRoot[i] = self._csb:getChildByName("root"..i)
        self._arrRoot[i]:setString(zzd.GroupData[i+1])
        self._arrBtn[i] = self._csb:getChildByName("btn_root"..i)
        self._arrBtn[i]:addTouchEventListener(function(target,type)
            if type == 2 then
                SoundsFunc_playSounds(SoundsType.OPEN_PAGE,false)
                local txt = "确定任命"..data["name"].."为"..zzd.GroupData[i+1].."吗？"
                local data = {[1]=data["uid"],[2]=i+1,[3]=txt}
                require "src.game.group.view.HintMsg"
                local msg = HintMsg:create(data)
                local scene = SceneManager:getCurrentScene()
                scene:addChild(msg)
            end
        end)
        if zzd.GroupData[i+1] == zzd.GroupData[data["root"]] then
            self._arrBtn[i]:setTouchEnabled(false)
            self._arrBtn[i]:setBright(false)
        end
    end
end