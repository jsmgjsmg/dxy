zzd = {}

zzd.CharacterData = require("game/data/CharacterData.lua")

zzd.GoodsData = require("game/data/GoodsData.lua")

zzd.FriendData = require("game/data/FriendData")

zzd.VipData = require "game.data.VipData"

zzd.GroupData = require "src.game.data.GroupData"

zzd.RechargeData = require "src.game.data.RechargeData"

zzd.TaskData = require ("src/game/data/TaskData.lua").new()

zzd.RankingData = require ("src.game.data.RankingData").new()

zzd.GodGeneralData = require "game.data.GodGeneralData"

zzd.ActivityData = require("game.data.ActivityData").new()

require("game.data.BaseData")
----------------------------------------------------
--require Config Provider

_G.RoleData = {}
_G.DiffTimer = nil
_G.FairyData = {}
_G.GeneralData = {}
_G.GroupData = {}
_G.RankData = {}

require("game.data.config_provider.TipsConfigProvider")
require "game.data.config_provider.SceneConfigProvider"
require("game.data.config_provider.GoodsConfigProvider")
require "src.game.data.config_provider.YuanGodConfig"
require "src.game.data.config_provider.TaskConfig"
require("game.data.config_provider.MagicSoulConfigProvider")
require("game.data.config_provider.MagicSoulConfigProvider")
require "src.game.data.config_provider.FairyConfig"
require "src.game.data.config_provider.VipConfig"
require "src.game.data.config_provider.GodGeneralConfig"
require ("src.game.data.config_provider.GroupConfig")
GroupConfig:initPrayConfig()
GroupConfig:initSkyPagoda()
require("game.data.config_provider.EquipStrengthenConfig")
require("game.data.config_provider.AutocephalyValueConfig")
require("game.data.config_provider.EquipQualityConfig")
require("game.data.config_provider.EquipBaseConfig")
require("game.data.config_provider.HeroConfig")
require("game.data.config_provider.NameConfig")
require("game.data.config_provider.PhysicalConfig")
require("game.data.config_provider.TowerConfig")
require("game.data.config_provider.GodGeneralSceneConfig")
require("game.data.config_provider.PkConfig")
require "src.game.data.config_provider.YuanShenConfig"
require "game.data.config_provider.MoneySceneConfig"
require("game.data.config_provider.RecruitMoneyConfig")
require("game.data.config_provider.PeentoConfig")
local rechargeConfig = require "src.game.data.config_provider.RechargeConfig"
RechargeConfig = rechargeConfig.new()
require "src.game.data.config_provider.WorldBossConfig"
require "game.data.config_provider.VipNoteConfig"
require("game.data.config_provider.NewFunctionConfig")
require("game.data.config_provider.ActivityConfig")
--ActivityConfig:init()
require("game.data.config_provider.MoveNewsConfig")
require("game.data.config_provider.StarRewardConfig")
require("game.data.config_provider.SkyPagodaConfig")

require("game.data.config_provider.HelperConfig")
--SociatyWarTiledMapConfig
require "game.data.config_provider.SociatyWarTiledMapConfig"


--
local heroSkill = require("game/data/config_provider/HeroSkill")
HeroSkill = heroSkill:new()
local skillConfig = require("game.data.config_provider.SkillConfig")
SkillConfig = skillConfig:new()
local ctskillitem = require("game.data.config_provider.CTSkillConfig")
CTSkillConfig = ctskillitem:new()

_G.gSkillParameter = AutocephalyValueConfig:getValueByContent("SkillParameter")

-- 让两个表的id值对应起来
_G.SkillConfigId_SkillAmId = {}

for key, var in pairs( luacf.Skill.SkillConfig.SkillBase ) do
--for key, var in pairs( skillConfig.SkillConfig.SkillBase ) do
    _G.SkillConfigId_SkillAmId[var.Id] = var.SonSkill.AnimationId
end