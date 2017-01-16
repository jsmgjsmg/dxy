CreateGroup = CreateGroup or class("CreateGroup",function()
    return cc.Node:create()
end)

function CreateGroup:ctor()
    self.visibleSize = cc.Director:getInstance():getVisibleSize()
    self.origin = cc.Director:getInstance():getVisibleOrigin()
end

function CreateGroup:create()
    local node = CreateGroup:new()
    node:init()
    return node
end

function CreateGroup:init()
    self._csb = cc.CSLoader:createNode("res/dxyCocosStudio/csd/ui/group/CreateGroup.csb")
    self:addChild(self._csb)
    self._csb:setPosition(self.origin.x + self.visibleSize.width / 2, self.origin.y + self.visibleSize.height / 2)
    
    -- 拦截
    dxySwallowTouches(self)
    
--editbox
    local bg = self._csb:getChildByName("bg")
    local test = bg:getChildByName("test")
    local size = test:getContentSize()
    local posx,posy = test:getPosition()
    self._input = ccui.EditBox:create(size,"dxyCocosStudio/png/group/TM.jpg")
    bg:addChild(self._input)
    self._input:setMaxLength(6)
    self._input:setPlaceHolder("仙门名称(最多六个字)")
    self._input:setFont("res/dxyCocosStudio/font/MicosoftBlack.ttf",25)
    self._input:setPosition(posx, posy)  
    
    local txtNeed = self._csb:getChildByName("txtNeed")
    local root = AutocephalyValueConfig:getValueByContent("SociatyRmb")
    txtNeed:setString(root)
    
--btn    
    local btnCreate = self._csb:getChildByName("btn_create")
    btnCreate:addTouchEventListener(function(target,type)
        if type == 2 then
            SoundsFunc_playSounds(SoundsType.OPEN_PAGE,false)
            local group = self._input:getText()
            if group == "" or group == nil then
                cn:TipsSchedule("请输入仙门名称")
            elseif cn:CheckSpecialChar(group,{" ","\n"}) then 
                cn:TipsSchedule("不符合命名规则")
            else
                zzc.GroupController:createGroup(group)
                self:removeFromParent()
            end
        end
    end)
    
    local btnBack = self._csb:getChildByName("Image"):getChildByName("btn_back")
    btnBack:addTouchEventListener(function(target,type)
        if type == 2 then
            SoundsFunc_playSounds(SoundsType.CLOSE_PAGE,false)
            self:removeFromParent()
        end
    end)
end