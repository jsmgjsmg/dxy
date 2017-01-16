local WorldBossConfig = {
		["WorldBossConfig"] = {["BuffGroup"] = {["Buff"] = {
								[1] = {["AttAdd"] = 20,["Rmb"] = 5,["Num"] = 1,["SociatyAttAdd"] = 1},
								[2] = {["AttAdd"] = 20,["Rmb"] = 10,["Num"] = 2,["SociatyAttAdd"] = 1},
								[3] = {["AttAdd"] = 20,["Rmb"] = 15,["Num"] = 3,["SociatyAttAdd"] = 1},
								[4] = {["AttAdd"] = 20,["Rmb"] = 20,["Num"] = 4,["SociatyAttAdd"] = 1},
								[5] = {["AttAdd"] = 20,["Rmb"] = 25,["Num"] = 5,["SociatyAttAdd"] = 1},
								[6] = {["AttAdd"] = 20,["Rmb"] = 30,["Num"] = 6,["SociatyAttAdd"] = 1},
								[7] = {["AttAdd"] = 20,["Rmb"] = 35,["Num"] = 7,["SociatyAttAdd"] = 1},
								[8] = {["AttAdd"] = 20,["Rmb"] = 40,["Num"] = 8,["SociatyAttAdd"] = 1},
								[9] = {["AttAdd"] = 20,["Rmb"] = 45,["Num"] = 9,["SociatyAttAdd"] = 1},
								[10] = {["AttAdd"] = 20,["Rmb"] = 50,["Num"] = 10,["SociatyAttAdd"] = 1},
								[11] = {["AttAdd"] = 20,["Rmb"] = 55,["Num"] = 11,["SociatyAttAdd"] = 1},
								[12] = {["AttAdd"] = 20,["Rmb"] = 60,["Num"] = 12,["SociatyAttAdd"] = 1},
								[13] = {["AttAdd"] = 20,["Rmb"] = 65,["Num"] = 13,["SociatyAttAdd"] = 1},
								[14] = {["AttAdd"] = 20,["Rmb"] = 70,["Num"] = 14,["SociatyAttAdd"] = 1},
								[15] = {["AttAdd"] = 20,["Rmb"] = 75,["Num"] = 15,["SociatyAttAdd"] = 1},
								[16] = {["AttAdd"] = 20,["Rmb"] = 80,["Num"] = 16,["SociatyAttAdd"] = 1},
								[17] = {["AttAdd"] = 20,["Rmb"] = 85,["Num"] = 17,["SociatyAttAdd"] = 1},
								[18] = {["AttAdd"] = 20,["Rmb"] = 90,["Num"] = 18,["SociatyAttAdd"] = 1}
						}},
				["ResourceGroup"] = {["Resource"] = {["ModelId"] = 1001,["UpTime"] = 300,["Lv"] = 28,["SkeletonId"] = 902,["SceneId"] = 90205}},
				["EventGroup"] = {["Event"] = {["Explain"] = "挑战BOSS获得大量奖励",["StartTime"] = 73200,["EndTime"] = 74400,["ReviveTime"] = 30,["WarTime"] = 73800,["RefreshTime"] = 1}},
				["RewardGroup"] = {["KillReward"] = {["Id"] = 111307},
						["RankingReward"] = {
								[1] = {["Range"] = 1,["Renown"] = 50000,["Gold"] = 300000,["Amulet"] = 20},
								[2] = {["Range"] = 2,["Renown"] = 30000,["Gold"] = 200000,["Amulet"] = 15},
								[3] = {["Range"] = 3,["Renown"] = 20000,["Gold"] = 150000,["Amulet"] = 10},
								[4] = {["Range"] = 4,["Renown"] = 19100,["Gold"] = 145000,["Amulet"] = 9},
								[5] = {["Range"] = 5,["Renown"] = 18200,["Gold"] = 140000,["Amulet"] = 9},
								[6] = {["Range"] = 6,["Renown"] = 17300,["Gold"] = 135000,["Amulet"] = 9},
								[7] = {["Range"] = 7,["Renown"] = 16400,["Gold"] = 130000,["Amulet"] = 9},
								[8] = {["Range"] = 8,["Renown"] = 15500,["Gold"] = 125000,["Amulet"] = 8},
								[9] = {["Range"] = 9,["Renown"] = 14600,["Gold"] = 120000,["Amulet"] = 8},
								[10] = {["Range"] = 10,["Renown"] = 13700,["Gold"] = 115000,["Amulet"] = 8},
								[11] = {["Range"] = 11,["Renown"] = 12800,["Gold"] = 110000,["Amulet"] = 8},
								[12] = {["Range"] = 12,["Renown"] = 11900,["Gold"] = 105000,["Amulet"] = 7},
								[13] = {["Range"] = 13,["Renown"] = 11000,["Gold"] = 100000,["Amulet"] = 7},
								[14] = {["Range"] = 14,["Renown"] = 10100,["Gold"] = 95000,["Amulet"] = 7},
								[15] = {["Range"] = 15,["Renown"] = 9200,["Gold"] = 90000,["Amulet"] = 7},
								[16] = {["Range"] = 16,["Renown"] = 8300,["Gold"] = 85000,["Amulet"] = 6},
								[17] = {["Range"] = 17,["Renown"] = 7400,["Gold"] = 80000,["Amulet"] = 6},
								[18] = {["Range"] = 18,["Renown"] = 6500,["Gold"] = 75000,["Amulet"] = 6},
								[19] = {["Range"] = 19,["Renown"] = 5600,["Gold"] = 70000,["Amulet"] = 6},
								[20] = {["Range"] = 20,["Renown"] = 4700,["Gold"] = 65000,["Amulet"] = 5}
						},
						["ParticipateReward"] = {
								[1] = {["HighRange"] = 21,["Renown"] = 3800,["LowRange"] = 30,["Gold"] = 60000},
								[2] = {["HighRange"] = 31,["Renown"] = 2900,["LowRange"] = 50,["Gold"] = 55000},
								[3] = {["HighRange"] = 51,["Renown"] = 2000,["LowRange"] = 100,["Gold"] = 50000},
								[4] = {["HighRange"] = 101,["Renown"] = 1100,["Gold"] = 45000}
						}}}
}
return WorldBossConfig