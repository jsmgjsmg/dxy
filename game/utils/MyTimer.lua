---
--@module MyMyTimer
--@module_parent zz
local MyTimer = class("MyTimer")
MyTimer.__index = MyTimer


function MyTimer:ctor()
	self.m_schedulerID = nil
end

---
--@function [parent=#MyTimer] start
--@param self
--@param delay flot description
--@param fun function description
function MyTimer:start(delay, fun)
	if self.m_schedulerID ~= nil then
		self:stop()
	end
	
	self.m_schedulerID = cc.Director:getInstance():getScheduler():scheduleScriptFunc(fun, delay, false)
end

---
--@function [parent=#MyTimer] stop
--@param self
function MyTimer:stop()
	if self.m_schedulerID ~= nil then
		cc.Director:getInstance():getScheduler():unscheduleScriptEntry(self.m_schedulerID)
		self.m_schedulerID = nil
	end
end

---
--@function [parent=#MyTimer] isIdle
--@param self
function MyTimer:isIdle()
	return self.m_schedulerID == nil
end

return MyTimer