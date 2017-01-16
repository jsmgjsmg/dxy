dxyEventType = {
--固定不变的事件ID
    GAME_UPDATE = 1, --游戏更新 进度
    GAME_FINISH = 2, --游戏更新 完成
    
    AUTO_EVENT_START = 10,
    
--自动生成事件ID
    --登录相关
    Login_UpdateLastServer = 0, -- 更新最后登录服务器
    Login_UpdateIdentify = 0,   -- 更新验证码
    --角色相关
    Character_AttrUpdate = 0, -- 角色属性变更
    --背包相关
    UserItem_DelItem = 0,    -- 删除物品
    UserItem_AddItem = 0,    -- 添加物品
    UserItem_Replace = 0,     -- 物品发生改变（强化）
    
    UserItem_CastEquip = 0,    -- 脱装备
    UserItem_WearEquip = 0,    -- 穿装备
    UserItem_ReplaceEquip = 0,     -- 装备属性改变
    
    RoleView_OpenSubView = 0,   --打开背包子界面，参数：
    
    RoleInfo_OpenTypeView = 0,  --角色信息界面,参数
    
    Backpack_Refresh = 0,       --整理背包
    
    Swallow_reSelected = 0,     --一键填充装备高亮
    
    --强化相关
    EquipStrengthen_SetItemIn = 0,  -- 放入物品
    EquipStrengthen_ResultBackj = 0,-- 结果返回
    EquipStrengthen_SwallowBtn = 0, --强化按钮
    EquipStrengthen_RecommendBtn = 0,   --一键填充按钮
    EquipStrengthen_Effect = 0, --强化成功特效
    
    --熔炼
    EquipSmelting_Confirm = 0,  --熔炼确认界面
    EquipSmelting_Close = 0,    --关闭熔炼界面
    
    --器灵界面
    Spirit_Layer = 0,   --器灵的相关界面
    Spirit_Strength = 0,    --器灵强化界面
    
    --好友界面
    Friend_List_Update = 0,    --好友界面
    
    --技能界面
    Skill_Layer = 0,    --技能更新
    ctSkill_Layer = 0,  --连招更新
    Skill_Info = 0,     --技能信息更新
    SoulSkill_Info = 0, --法器技能信息更新
    ctSkill_Info = 0,   --连招信息更新
    SoulctSkill_Info = 0,   --连招法器技能信息更新
    Skill_Unlock = 0,   --技能界面解锁
    SoulSkill_Unlock = 0,   --法器技能界面解锁
    SkillLayer_Reset = 0,   --技能界面重置
    baseSkill_Equiped = 0,  --已装备基础技能更新
    soulSkill_Equiped = 0,  --已装备法器技能更新
    Skill_AutoSelect = 0,   --打开装备技能界面自动选中已装备的技能
    Skill_Unlock_Effect = 0,    --技能解锁特效
    Skill_Update_Effect = 0,    --技能升级特效
    ctSkill_Unlock_Effect = 0,  --技能链解锁特效
    
    NextNewPlayerGuide =0, -- 下一步新手引导
    
    Pk_Data_Upgrade = 0,    --更新竞技场玩家数据
    Pk_Ranking_Upgrade = 0, --更新竞技场排行榜
    
    Spirit_Copy_Update = 0, --更新器灵副本数据
    
    Recruit_Money_Update = 0,   --更新招财数据
    
    Sweep_Data_Update = 0,  --蟠桃园数据更新
    Sweep_Result_Update = 0,    --扫荡结果更新 
    Sweep_Ripening_Update = 0,  --催熟界面更新
}

function dxyEventType_Initial()
    local index = dxyEventType.AUTO_EVENT_START
    for k,v in pairs(dxyEventType) do
        if dxyEventType[k] == 0 then
        	dxyEventType[k] = index
        	index = index + 1
        end
    end
end

dxyEventType_Initial()