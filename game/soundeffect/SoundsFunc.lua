---加载声音缓存--------------------------------------------------------------
function SoundsFunc_addSoundFrames()
    local instance = cc.SimpleAudioEngine:getInstance()
    for key, var in pairs(SoundsType) do
        instance:preloadEffect(var)
        print("Sounds: "..var)
    end
end

---播放------------------------------------------------------------------
function SoundsFunc_playSounds(type,bool)
    if _G.isEffect == "on" then
        for key, var in pairs(SoundsType) do
            if var == type then
                local instance = cc.SimpleAudioEngine:getInstance()
                instance:playEffect(type,bool)
                break
            end
        end
    end
end

function SoundsFunc_playEffectOfVS(str)
    if _G.isEffect == "on" then
        cc.SimpleAudioEngine:getInstance():playEffect(str,false)
    end
end

---暂停------------------------------------------------------------------
--暂停背景音乐
function SoundsFunc_stopBackgroundMusic()
    cc.SimpleAudioEngine:getInstance():stopMusic()
end

---恢复------------------------------------------------------------------
--恢复背景音乐
function SoundsFunc_playBackgroundMusic()
    cc.SimpleAudioEngine:getInstance():playMusic("sound/cityBgm.mp3",true)
end

---释放所有音效------------------------------------------------------------------
function SoundsFunc_unloadSounds()
    local instance = cc.SimpleAudioEngine:getInstance()
    for key, var in pairs(SoundsType) do
        instance:unloadEffect(var)
    end
end
