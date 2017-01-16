local GroupFuncData = class("GroupFuncData")

function GroupFuncData:ctor()
    self.arrStr = {}
end

function GroupFuncData:addStr(str)
    table.insert(self.arrStr,str)
end