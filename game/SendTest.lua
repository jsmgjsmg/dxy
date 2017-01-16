SendTest = SendTest or class("SendTest",function()
	return cc.Node:create()
end)

function SendTest:create()
	local node = SendTest:new()
	return node
end


function SendTest:ctor()
    self.txtField_send = nil
    self.btn_send = ccui.Button
    self.bg = nil
	self:initUI()
	self:initEvent()
end

function SendTest:initUI()
	local sendTest = cc.CSLoader:createNode("dxyCocosStudio/csd/SendLayer.csb")
	self:addChild(sendTest)
    SceneManager:getCurrentScene():addChild(self) 

    self.visibleSize = cc.Director:getInstance():getVisibleSize()
    self.origin = cc.Director:getInstance():getVisibleOrigin()

    self:setPosition(self.origin.x + self.visibleSize.width/2 , self.origin.y + self.visibleSize.height/2)
	
	self.txtField_send = sendTest:getChildByName("sendTxtField")
	self.btn_send = sendTest:getChildByName("sendBtn")
    self.bg = sendTest:getChildByName("bg")
	
end

function SendTest:initEvent()
	self.btn_send:addTouchEventListener(function(target,type)
	   if type == 2 then
	   	print("发送按钮")
	   	local text = self.txtField_send:getString()
	   	print(text)
	   	if text ~= "" then
	   		print("不为空")
                local gm = text
                local msg = mc.packetData:createWritePacket(800); --编写发送包
                msg:writeString(gm)
                mc.NetMannager:getInstance():sendMsg(msg); --发送 包
	   	end
        self:removeFromParent()
	   end
	end) 
	
    -- 拦截
    dxySwallowTouches(self,self.bg)
	  
end