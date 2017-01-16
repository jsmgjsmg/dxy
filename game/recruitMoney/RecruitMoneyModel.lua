local RecruitMoneyModel = class("RecruitMoneyModel")
RecruitMoneyModel.__index = RecruitMoneyModel

function RecruitMoneyModel:ctor()
    self:initModel()
end

function RecruitMoneyModel:initModel()
    self.lucky_count = 0
    self.lucky_limit = 0
    self.box_list = {}
    
    self.tips_list = {}
end

--暴击提示
function RecruitMoneyModel:critTips(data)
    require("game.recruitMoney.view.RecruitCritLayer")
    table.insert(self.tips_list,data)
    if not self._myTimer then
        self._myTimer = self._myTimer or require("game.utils.MyTimer").new()
        local function tick()
            if self.tips_list[1] then
                if self.tips_list[1].rate == 1 then
                    dxyFloatMsg:show("招财成功,获得铜钱"..self.tips_list[1].gold)
                else                   
                    RecruitCritLayer:create(self.tips_list[1])
                end
                table.remove(self.tips_list,1)
            else
                self._myTimer:stop()
                self._myTimer = nil
            end
        end
        self._myTimer:start(0.6, tick)
    end
end


return RecruitMoneyModel