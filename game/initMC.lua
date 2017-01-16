-- Controller and Model is The singleton pattern
initMC = class("initMC")
zzc = {}
zzm = {}
zza = {}
zzm.LoginModel = require("game/login/LoginModel.lua").new()
zzc.LoginController = require("game/login/LoginController.lua").new()
zzm.AnnouncementModel = require("game/announcement/AnnouncementModel.lua").new()
zzc.AnnouncementController = require("game/announcement/AnnouncementController.lua").new()

_G.backPack = nil

function initMC:ctor()

    zzm.PLATFORM = cc.Application:getInstance():getTargetPlatform()

    -- 游戏部分全局数据存储Model
    zzm.GlobalModel = require("game/manager/dxyGlobalModel.lua").new()
    -- 游戏资源加载数据Model
    zzm.LoadingModel = require("game/loading/LoadingModel.lua").new()
    -- 游戏登录模块数据Model
    --zzm.LoginModel = require("game/login/LoginModel.lua").new()
    -- 游戏公告数据Model
--    zzm.AnnouncementModel = require("game/announcement/AnnouncementModel.lua").new()
    -- 游戏关卡选择数据Model
    zzm.CopySelectModel = require("game/chapter/CopySelectModel.lua").new()
    -- 游戏角色，装备，背包数据Model
    zzm.CharacterModel = require("game/equip.CharacterModel.lua").new()
    -- 角色信息数据Model
    zzm.RoleinfoModel = require("game/roleinfo/RoleinfoModel.lua").new()
    -- 任务Model
    zzm.TaskModel = require ("game/task/TaskModel.lua").new()
    -- 仙女Model
    zzm.FairyModel = require ("game/fairy/FairyModel.lua").new()

    --器灵Model
    zzm.SpiritModel = require("game.spirit.SpiritModel").new()
    --好友Model
    zzm.FriendModel = require("game/friend/FriendModel.lua").new()
    --技能Model
    zzm.SkillModel = require("game.skill.SkillModel").new()
    --神将
    zzm.GeneralModel = require("game/general/GeneralModel.lua").new()
    --仙门
    zzm.GroupModel = require("game/group/GroupModel.lua").new()
    --元神
    zzm.YuanShenModel = require("game/yuanshen/YuanShenModel.lua").new()
    --充值
    zzm.RechargeModel = require("game.recharge.RechargeModel.lua").new()
    --排行榜
    zzm.RankingModel = require("game.ranking.RankingModel").new()

    --演武场
    zzm.PkModel = require("game.pk.PkModel").new()

    --财神宝库
    zzm.CornucopiaModel = require("game.cornucopia.CornucopiaModel").new()

    --试练塔
    zzm.TowerModel = require("game.tower.TowerModel").new()

    --聊天Model
    zzm.ChatModel = require("game.chat.ChatModel").new()

    zzm.GuideModel = require("game/guide/GuideModel").new()

    --世界Boss
    zzm.WorldBossModel = require("game.worldboss.WorldBossModel").new()

    zzm.TalkingDataModel = require("game.manager.TalkingDataManager").new()

    --招财进宝
    zzm.RecruitMoneyModel = require("game.recruitMoney.RecruitMoneyModel").new()
    
    --扫荡
    zzm.SweepModel = require("game/sweep/SweepModel.lua").new()

    --设置
    zzm.SetupModel = require("game.setup.SetupModel").new()
    
    --活动
    zzm.ActivityModel = require("game.activity.ActivityModel").new()
    
    --仙门功能
    zzm.GroupFuncModel = require("game.group.GroupFuncModel").new()
    
    --走马灯
    zzm.MarqueeModel = require("game.marquee.MarqueeModel").new()
    
    zzm.LotteryDrawModel = require("game/lotterydraw/LotteryDrawModel").new()
    
    --小助手
    zzm.HelperModel = require("game.helper.HelperModel").new()
    
    --仙域界面
    zzm.ImmortalFieldModel = require("game.tilemap.immortalfield.ImmortalFieldModel").new()
    
    --tileMap 第二步
    zzm.StepTwoModel = require("game.tilemap.steptwo.StepTwoModel").new()
    
    --仙域
    zzm.TilemapModel = require("game.tilemap.TilemapModel").new()
    
    ---Sounds
    require "game.soundeffect.SoundsType"
    require "game.soundeffect.SoundsFunc"
    require "game.soundeffect.SoundsInit"

    zzc.LoadingController = require("game/loading/LoadingController.lua").new()
    --
    --zzc.LoginController = require("game/login/LoginController.lua").new()

--    zzc.AnnouncementController = require("game/announcement/AnnouncementController.lua").new()

    zzc.CopySelectController = require("game/chapter/CopySelectController.lua").new()

    zzc.CharacterController = require("game/equip/CharacterController.lua").new()

    zzc.RoleinfoController = require("game/roleinfo/RoleinfoController.lua").new()
    -- 任务Ctr
    zzc.TaskController = require("game/task/TaskController.lua").new()
    --仙女Ctr
    zzc.FairyController = require("game/fairy/FairyController.lua").new()
    --vipCtr
    --zzc.VipController = require ("game/vip/VipController.lua").new()
    --神将Ctr
    zzc.GeneralController = require ("game/general/GeneralController.lua").new()
    --仙门Ctr
    zzc.GroupController = require("game/group/GroupController.lua").new()
    --元神Ctr
    zzc.YuanShenController = require("game/yuanshen/YuanShenController.lua").new()
    --充值Ctr
    zzc.RechargeController = require("game/recharge/RechargeController.lua").new()
    --排行榜
    zzc.RankingController = require("game.ranking.RankingController").new()

    --器灵
    zzc.SpiritController = require("game/spirit/SpiritController.lua").new()

    --技能
    zzc.SkillController = require("game.skill.SkillController").new()

    --聊天
    zzc.ChatController = require("game.chat.ChatController").new()

    zzc.GuideController = require("game/guide/GuideController").new()

    --演武场
    zzc.PkController = require("game.pk.PkController").new()

    --财神宝库
    zzc.CornucopiaController = require("game.cornucopia.CornucopiaController").new()

    --试练塔
    zzc.TowerController = require("game.tower.TowerController").new()

    --好友Controller
    zzc.FriendController = require("game/friend/FriendController.lua").new()
    zzskill = {}
    zzskill.skillPage = nil
    zzskill.ctSkillLayer = nil

    --世界BossCtrl
    zzc.WorldBossController = require("game.worldboss.WorldBossController").new()

    --招财进宝
    zzc.RecruitMoneyController = require("game.recruitMoney.RecruitMoneyController").new()

    --购买体力
    zzc.PhysicalTipsController = require("game.commonUI.PhysicalTipsController").new()
    
    --扫荡
    zzc.SweepController = require("game.sweep.SweepController").new()
    
    --活动
    zzc.ActivityController = require("game.activity.ActivityController").new()
    
    --仙门功能
    zzc.GroupFuncCtrl = require("game.group.GroupFuncCtrl").new()
    
    --走马灯
    zzc.MarqueeController = require("game.marquee.MarqueeController").new()
    
    zzc.LotteryDrawController = require("game/lotterydraw/LotteryDrawController").new()
    
    --小助手
    zzc.HelperController = require("game.helper.HelperController").new()
    
    --仙域界面
    zzc.ImmortalFieldController = require("game.tilemap.immortalfield.ImmortalFieldController").new()
    
    --tileMap第二步
    zzc.StepTwoController = require("game.tilemap.steptwo.StepTwoController").new()
    
    --仙域
    zzc.TilemapController = require("game.tilemap.TilemapController").new()
    
    --self:reLoadHero() 不要放在这里，卡死了
    
end

function initMC:reLoadHero()   ---预加载角色
    local data = HeroConfig:getConfig()
    for key, var in pairs(data) do
        mc.SkeletonDataCash:getInstance():addData(var["CreateBone"],false)
        mc.SkeletonDataCash:getInstance():addData(var["BoneEffect"],false)
    end
end
return initMC
