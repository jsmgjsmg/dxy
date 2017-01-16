--help function

--将 config 中的单项改成多项（可遍历）
function dxyConfig_toList(configtable)
    local ret = {}
    if configtable[1] then
        ret = configtable
	else
        ret[1] = configtable
	end
	return ret
end

function dxySwallowTouches(instance,image)
    if instance then
        -- 拦截
        local function onTouchBegan(touch, event)
            return true
        end
        
        local function onTouchMoved(touch, event)
        end
        
        local function onTouchEnded(touch, event)
            if image then
                local location = touch:getLocation()
    
                local point = image:convertToNodeSpace(location)
                local rect = cc.rect(0,0,image:getContentSize().width,image:getContentSize().height)
                if cc.rectContainsPoint(rect,point) == false then
                    if instance.whenClose then
                        instance:whenClose()
                    end
                    instance:removeFromParent()
                end
            end
        end

        local listener = cc.EventListenerTouchOneByOne:create()
        listener:registerScriptHandler(onTouchBegan,cc.Handler.EVENT_TOUCH_BEGAN )
        listener:registerScriptHandler(onTouchMoved,cc.Handler.EVENT_TOUCH_MOVED )
        listener:registerScriptHandler(onTouchEnded,cc.Handler.EVENT_TOUCH_ENDED )
        local eventDispatcher = instance:getEventDispatcher()
        eventDispatcher:addEventListenerWithSceneGraphPriority(listener, instance)
        listener:setSwallowTouches(true)
    end
end

function dxyExtendEvent(instance)
    if instance then
    	if instance.initEvent and instance.removeEvent then
    		function onEventBack(eventName)
    			if eventName == "enter" then
    				instance:initEvent()
    			elseif eventName == "exit" then
    		        instance:removeEvent()
    			end
    		end
    		instance:registerScriptHandler(onEventBack)
    	end
    end
end


function dxyStringSplit(s, delim)-- path,"/"
    if type(delim) ~= "string" or string.len(delim) <= 0 then
        return
    end
    local start = 1
    local t = {}
    while true do
        local pos = string.find (s, delim, start, true)
        if not pos then
            break
        end
        table.insert (t, string.sub (s, start, pos - 1))
        start = pos + string.len (delim)
    end
    table.insert (t, string.sub (s, start))

    return t
end

--把obj添加到数组（有下标）里，但保证table只有一个obj
function array_addObject(arr, obj)
    for i,v in pairs(arr) do
        if v==obj then
            return
        end
    end
    table.insert(arr, obj)
end

--从数组（有下标）中删除一个obj
function array_removeObject(arr, obj)
    for i,v in pairs(arr) do
        if v==obj then
            table.remove(arr,i)
            return
        end
    end
end

--从数组里（有下标）中查找一个obj，返回index；找不到返回0
function array_findObject(arr, obj)
    for i,v in pairs(arr) do
        if v==obj then
            return i
        end
    end
    return 0
end