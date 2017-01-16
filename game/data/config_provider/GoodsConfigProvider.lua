--物品表 数据提供器

GoodsConfigProvider = {
}

--通过物品ID查找物品基本数据，没有找到返回nil
function GoodsConfigProvider:findGoodsById(id)
    local list = luacf.Goods.GoodsConfig.Information
    for key, item in pairs(list) do
        if item.Id == id then
	   	   return item
	    end
    end
    return nil
end

--通过物品基本属性ID查找物品基本属性，没有找到返回nil
function GoodsConfigProvider:findBaseAttrById(id)
    local list = luacf.Goods.GoodsConfig.BaseAttr
    for key, var in pairs(list) do
        if var.ID == id then
            return var
        end
    end
    return nil
end