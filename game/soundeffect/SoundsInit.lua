SoundsInit = SoundsInit or class("SoundsInit")

function SoundsInit:ctor()
    _G.isMusic = cc.UserDefault:getInstance():getStringForKey(UserDefaulKey.isMusic)
    if _G.isMusic ~= "on" and _G.isMusic ~= "off" then
        self:setMusic("on")
    end
    
    
    _G.isEffect = cc.UserDefault:getInstance():getStringForKey(UserDefaulKey.isEffect)
    if _G.isEffect ~= "on" and _G.isEffect ~= "off" then
        self:setEffect("on")
    end 
     
    if _G.isMusic == "on"  then
        SoundsFunc_playBackgroundMusic()
        _G.isMusicVaule = 1
    else
        SoundsFunc_stopBackgroundMusic()
        _G.isMusicVaule = 2
    end
    
    if _G.isEffect == "on" then
        _G.isEffectVaule = 1
    elseif _G.isEffect == "off" then
        _G.isEffectVaule = 2
    end
end

function SoundsInit:setMusic(str)
    cc.UserDefault:getInstance():setStringForKey(UserDefaulKey.isMusic,str)
    _G.isMusic = str
    if str == "on" then
        _G.isMusicVaule = 1
    elseif str == "off" then
        _G.isMusicVaule = 2
    end
end

function SoundsInit:setEffect(str)
    cc.UserDefault:getInstance():setStringForKey(UserDefaulKey.isEffect,str)
    _G.isEffect = str
    if str == "on" then
        _G.isEffectVaule = 1
    elseif str == "off" then
        _G.isEffectVaule = 2
    end
end
