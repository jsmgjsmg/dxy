local RechargeModel = RechargeModel or class("RechargeModel")

function RechargeModel:ctor()
    self._arrRecList = {}
    self._isFirst = nil
end

--初始化已购买列表
function RechargeModel:initRecList(data)
    table.insert(self._arrRecList,data)
end 

--change
function RechargeModel:changeRecList(data)
    local len = #self._arrRecList
    if len ~= 0 then
        for i=1,len do
            if self._arrRecList[i]["Id"] == data["Id"] then
                self._arrRecList[i]["Num"] = data["Num"]
                break
            else
                table.insert(self._arrRecList,data)
            end
        end
     else
        table.insert(self._arrRecList,data)
     end
    dxyDispatcher_dispatchEvent("RechargeLayer_changeItem",data)
end

function RechargeModel:showFirstPayInt()
    local config = RechargeConfig:getFirstList()
    local data = zzd.RechargeData
    local str = "\n"
    for i=1,#config do
        if config[i].Type == 6 then
            str = str..GoodsConfigProvider:findGoodsById(config[i].Goods.Id).Name.."×"..config[i].Goods.Number.."\n"
        else
            str = str..data[config[i].Type]..config[i].Number.."\n"
        end
    end
    if str ~= "" or str ~= "\n" then
        TipsFrame:create("获得:"..str)
    end
end

return RechargeModel