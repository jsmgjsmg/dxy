local SociatyWarBaseConfig = {
		["SociatyWarBaseConfig"] = {["SociatyLvConfig"] = {["SociatyLv"] = {
								[1] = {["Lv"] = 1,["OccupyMax"] = 7},
								[2] = {["Lv"] = 2,["OccupyMax"] = 9},
								[3] = {["Lv"] = 3,["OccupyMax"] = 11},
								[4] = {["Lv"] = 4,["OccupyMax"] = 13},
								[5] = {["Lv"] = 5,["OccupyMax"] = 15},
								[6] = {["Lv"] = 6,["OccupyMax"] = 17},
								[7] = {["Lv"] = 7,["OccupyMax"] = 19},
								[8] = {["Lv"] = 8,["OccupyMax"] = 21},
								[9] = {["Lv"] = 9,["OccupyMax"] = 23}
						}},
				["AttrControlConfig"] = {["Lv"] = {
								[1] = {["Lv"] = 0,["AttrRate"] = 1},
								[2] = {["Lv"] = 1,["AttrRate"] = 1.01},
								[3] = {["Lv"] = 2,["AttrRate"] = 1.04},
								[4] = {["Lv"] = 3,["AttrRate"] = 1.09},
								[5] = {["Lv"] = 4,["AttrRate"] = 1.16},
								[6] = {["Lv"] = 5,["AttrRate"] = 1.25},
								[7] = {["Lv"] = 6,["AttrRate"] = 1.36},
								[8] = {["Lv"] = 7,["AttrRate"] = 1.49},
								[9] = {["Lv"] = 8,["AttrRate"] = 1.64},
								[10] = {["Lv"] = 9,["AttrRate"] = 1.81},
								[11] = {["Lv"] = 10,["AttrRate"] = 2},
								[12] = {["Lv"] = 11,["AttrRate"] = 2.21},
								[13] = {["Lv"] = 12,["AttrRate"] = 2.44},
								[14] = {["Lv"] = 13,["AttrRate"] = 2.69},
								[15] = {["Lv"] = 14,["AttrRate"] = 2.96},
								[16] = {["Lv"] = 15,["AttrRate"] = 3.25}
						}},
				["StartTimeConfig"] = {["StartTime"] = {
								[1] = {["EndTime"] = 46800,["StartTime"] = 43200},
								[2] = {["EndTime"] = 75600,["StartTime"] = 72000}
						}},
				["BaseConfig"] = {["Base"] = {
								[1] = {["Type"] = "DefaultLv",["Info"] = "默认仙域等级",["Parameter"] = 25},
								[2] = {["Type"] = "RandomRange",["Info"] = "仙门成员进入后随机格子范围",["Parameter"] = 10},
								[3] = {["Type"] = "Move_ExpendPower",["Info"] = "移动消耗的体力",["Parameter"] = 1},
								[4] = {["Type"] = "Move_ExpendTime",["Info"] = "移动消耗的时间（秒）",["Parameter"] = 2},
								[5] = {["Type"] = "Explore_DeductOccupy",["Info"] = "每次探索减少的势力值",["Parameter"] = 25},
								[6] = {["Type"] = "Explore_GetRmb",["Info"] = "探索敌人势力得到元宝",["Parameter"] = 2},
								[7] = {["Type"] = "Escape_DeductHp",["Info"] = "逃跑后减少的生命值（按生命值上限扣除%）",["Parameter"] = 20},
								[8] = {["Type"] = "Escape_SafeTime",["Info"] = "逃跑后的无敌时间（秒）",["Parameter"] = 10},
								[9] = {["Type"] = "Occupy_ExpendTime",["Info"] = "占领消耗的时间（秒）",["Parameter"] = 10},
								[10] = {["Type"] = "Occupy_ExpendPower",["Info"] = "占领消耗的体力",["Parameter"] = 10},
								[11] = {["Type"] = "Occupy_ExpendRmb",["Info"] = "占领消耗的元宝",["Parameter"] = 10},
								[12] = {["Type"] = "Occupy_MaxValue",["Info"] = "占领成功的势力值上限",["Parameter"] = 100},
								[13] = {["Type"] = "RecoverHp",["Info"] = "在地图上每秒恢复的生命值（%）",["Parameter"] = 2},
								[14] = {["Type"] = "GotoTownTime",["Info"] = "传送出去的时间（秒）",["Parameter"] = 10}
						}}}
}
return SociatyWarBaseConfig