local AnnouncementModel = class("AnnouncementModel")
AnnouncementModel.__index = AnnouncementModel

function AnnouncementModel:ctor()
    self.isFirstLogin = true
    self._isInStartLayer = true
    self.announcementList = {}
    self:initModel()
end

function AnnouncementModel:initModel()
    self.announcementList = {
        {id=1, title = "23456677",content = "cfsgafikghosidhjelhjljhogi\nhkdsahsklhg;jgslagj;skog\nhgikshgkugdskhgodhgiig" },
        {id=2, title = "fhuidyghi",content = "c87250680690568-086-7964\nfsgafikghosidhjelhjljhogi\nhkdsahsklhg;jgslagj;skog\nhgikshgkugdskhgodhgiig" },
        {id=3, title = "23ksjhuioeh456677",content = "cfsgafikghosidhjelhjlgmoishglksggskjlbslkjhnskjhskjlnsbjnskljhogi\nhkdsahsklhg;jgslagj;skog\nhgikshgkugdskhgodhgiig" },
    }
end

function AnnouncementModel:getLength()
    return #self.announcementList
end


function AnnouncementModel:setAnnouncementList(data)
--    for key, var in ipairs(data) do
--        table.insert(self.announcementList,#self.announcementList + 1,var)
--    end
    self.announcementList = data
end

return AnnouncementModel