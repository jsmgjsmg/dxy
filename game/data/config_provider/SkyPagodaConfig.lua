--组队爬塔

SkyPagodaConfig = {
  }

--通过层数Id，重天数Sky查找奖励
--function SkyPagodaConfig:findRwardByIdAndSky(Id,sky)
--    for key, var in pairs(luacf.SkyPagoda.SkyPagodaConfig.Copy.CopyConfig) do
--		
--	end
--end

--返回倒计时
function SkyPagodaConfig:getCountDownTime()
    return luacf.SkyPagoda.SkyPagodaConfig.Base.BaseConfig.CountDown
end