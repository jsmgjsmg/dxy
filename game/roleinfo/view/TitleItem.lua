TitleItem = TitleItem or class("TitleItem",function()
    local path = "dxyCocosStudio/png/roleinfo/rename/name_box.png"
    return ccui.Button:create(path,path,path)
end)

function TitleItem:create()
	local layer = TitleItem:new()
	return layer
end

function TitleItem:ctor()
    self.txt_title = nil
    self.txt_condition = nil
    self.ckb_use = ccui.CheckBox

	self:initUI()
	
	self:initEvent()
end

function TitleItem:initUI()
	local titleItem = cc.CSLoader:createNode("dxyCocosStudio/csd/ui/roleinfo/titleItem.csb")
	self:addChild(titleItem)
	
    local x = self:getContentSize().width / 2
    local y = self:getContentSize().height / 2 

    titleItem:setPosition(cc.p(x,y))
	
    self.frame = titleItem:getChildByName("bg")
	
    self.txt_title = titleItem:getChildByName("titleTxt")
    self.txt_condition = titleItem:getChildByName("conditionTxt")
    
    self.ckb_use = titleItem:getChildByName("useCkb")
    
end

function TitleItem:getFrameSize()
    local size = self.frame:getContentSize()
    return size
end

function TitleItem:initEvent()

    self:addTouchEventListener(function(target,type)
        if type == 2 then
        	
        end
    end)

--    self.ckb_use:addEventListener(function(target,type)
--	   if type == ccui.CheckBoxEventType.selected then
--	   	   
--	   	else
--	   	   
--	   end
--	end)
end

function TitleItem:update(data)
	self.m_data = data
end

function TitleItem:setTitleTxt(title)
	self.txt_title:setString(title)
end

function TitleItem:setBtnState(state)
    self.ckb_use:setSelected(state)
    self.ckb_use:setTouchEnabled(not state)
end