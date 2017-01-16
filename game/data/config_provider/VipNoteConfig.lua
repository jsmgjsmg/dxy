VipNoteConfig = VipNoteConfig or class("VipNoteConfig")

function VipNoteConfig:getVipNote(lv)
    local list = luacf.VipNote.VipNoteConfig.VipNote
    for key, var in pairs(list) do
    	if var.Lv == lv then
    	    return var
    	end
    end
end

