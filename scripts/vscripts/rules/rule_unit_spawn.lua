require("custom_event_listen")
require("info/game_playerinfo")
require('service/service')

if rule_unit_spawn == nil then
    rule_unit_spawn = class({})
end

-- 启动
function rule_unit_spawn: Start ()
    self: SetListen()
    self: SetThink()
end

-- 设置监听
function rule_unit_spawn: SetListen ()
    ListenToGameEvent("entity_killed", Dynamic_Wrap(rule_unit_spawn, "OnEntityKilled"), self)
end

-- 设置计时器
function rule_unit_spawn: SetThink ()
    GameRules:GetGameModeEntity():SetThink("GameOverThink", self, "GameOverThink", 0);
    GameRules:GetGameModeEntity():SetThink("KeepUnitMoveThink", self, "KeepUnitMoveThink", 0);
    GameRules:GetGameModeEntity():SetThink("NextRoundThink", self, "NextRoundThink", 0);
    GameRules:GetGameModeEntity():SetThink("UnitReturnThink", self, "UnitReturnThink", 0);
    GameRules:GetGameModeEntity():SetThink("FindClearSpaceThink", self, "FindClearSpaceThink", 0);
    GameRules:GetGameModeEntity():SetThink("UpdateDynamicDataThink", self, "UpdateDynamicDataThink", 0);
end

-- 更新动态数据
function rule_unit_spawn: UpdateDynamicDataThink ()
    local player_0_kill_count = #global_var_func.player_0_kill_count
    local player_1_kill_count = #global_var_func.player_1_kill_count
    local player_2_kill_count = #global_var_func.player_2_kill_count
    local player_3_kill_count = #global_var_func.player_3_kill_count
    CustomGameEventManager:Send_ServerToAllClients("update_dynamic_data_event",{
        spawn_all_unit_count = #global_var_func.spawn_all_unit_count,
        player_0_kill_count = player_0_kill_count,
        player_1_kill_count = player_1_kill_count,
        player_2_kill_count = player_2_kill_count,
        player_3_kill_count = player_3_kill_count,
        player_0_current_count = #global_var_func.player_0_current_count,
        player_1_current_count = #global_var_func.player_1_current_count,
        player_2_current_count = #global_var_func.player_2_current_count,
        player_3_current_count = #global_var_func.player_3_current_count,
        player_0_damage = game_playerinfo:get_player_damage(0) or 0,
        player_1_damage = game_playerinfo:get_player_damage(1) or 0,
        player_2_damage = game_playerinfo:get_player_damage(2) or 0,
        player_3_damage = game_playerinfo:get_player_damage(3) or 0,
        player_0_economic = game_playerinfo:getplayer_gold_gain(0),
        player_1_economic = game_playerinfo:getplayer_gold_gain(1),
        player_2_economic = game_playerinfo:getplayer_gold_gain(2),
        player_3_economic = game_playerinfo:getplayer_gold_gain(3),
        alive_unit = count_unit_table_num(),
        deadline = global_var_func.unit_total,
        player_0_call_boss_value = player_0_kill_count - global_var_func.call_boss_kill_node[1],
        player_1_call_boss_value = player_1_kill_count - global_var_func.call_boss_kill_node[2],
        player_2_call_boss_value = player_2_kill_count - global_var_func.call_boss_kill_node[3],
        player_3_call_boss_value = player_3_kill_count - global_var_func.call_boss_kill_node[4],
    })
    return 0.5
end

-- 击杀事件
function rule_unit_spawn:OnEntityKilled(event)
    local attacker = EntIndexToHScript(event.entindex_attacker)
    if attacker: IsHero() then
        local player_id = attacker:GetPlayerID()
        -- 每个玩家总杀怪物数量
        add_player_kill_count(player_id)
    else
        if attacker:GetOwner() then
            local hero = attacker:GetOwner()
            if hero:IsHero() then
                local player_id = hero:GetPlayerID()
                -- 每个玩家总杀怪物数量
                add_player_kill_count(player_id)
            end
        end
    end
    -- 每个玩家当前怪物数量
    local unit = EntIndexToHScript(event.entindex_killed)

    if unit:GetUnitName() == "boss_finally" then
        global_var_func.final_boss = true
        global_var_func.killde_final_boss = true
        return
    end

    local unit_owner = unit.player_id
    if not unit_owner then
        return
    end
    self: RemoveUnitTable(event.entindex_killed)
    del_player_current_count(unit_owner)
end

-- 游戏结束计时器
function rule_unit_spawn: GameOverThink ()
    local now = self:GetGameTime()
    local is_winner = false

    if GameRules:IsGamePaused() then
        -- 关闭相关背景音乐
        if global_var_func.background_musicplayer then
            StopGlobalSound(global_var_func.background_musicplayer)
            global_var_func.background_musicplayer = nil
            global_var_func.replay_musicplayer = true
        end
        return 1
    end

    if global_var_func.replay_musicplayer==true then
        global_var_func.replay_musicplayer = false
        CreateModifierThinker( nil, nil, "modifier_backround_music", {}, Vector(0, 0, 0), 1, false )
    end
    
    if now == 60 then
        local player_count = global_var_func.all_player_amount
        for playerid = 0, player_count-1 do
            if game_playerinfo:get_dynamic_properties(PlayerResource:GetSteamAccountID(playerid)).persent_treasure==1 then
                AddItemByName(PlayerResource:GetPlayer(playerid):GetAssignedHero(), "item_noItem_baoWu_book")
            end
        end
    end

    -- 胜利
    if GameRules: State_Get() == DOTA_GAMERULES_STATE_GAME_IN_PROGRESS and now >= global_var_func.game_time and global_var_func.final_boss then
        -- GameRules: SetGameWinner(DOTA_TEAM_GOODGUYS)
        local sendprize_list = {}
        local player_count = global_var_func.all_player_amount
        for playerid = 0, player_count-1 do
            local prize_list = {}
            if not global_var_func.player_base_info[playerid] then
                global_var_func.player_base_info[playerid] = {}
                global_var_func.player_base_info[playerid]["steam_id"] = 0
                global_var_func.player_base_info[playerid]["heroname"] = ""
            end
            local steam_id =  global_var_func.player_base_info[playerid]["steam_id"]
			local hero_name = global_var_func.player_base_info[playerid]["heroname"]
            -- game_playerinfo:update_hero_exp(steam_id, global_var_func:gethero_index_by_name(hero_name), global_var_func:GloFunc_Getgame_enum().HERO_EXP_INCRE*(GameRules:GetCustomGameDifficulty()+1)*2*(1+(game_playerinfo:get_dynamic_properties(steam_id).extra_hero_exp or 0)))
            -- 发送普通通关奖励
            local iargs = {}
            iargs.PlayerID = playerid
            iargs.GoodsName = "finishBoss"
            iargs.UseNumber = 0
            iargs.AddItemKey = {}
            -- DeepPrintTable(iargs)
            
            TheGiftOfThePharaohWin(playerid, GameRules:GetCustomGameDifficulty(), prize_list, iargs.AddItemKey)
            Store:UsedGoods(iargs)

            game_playerinfo:update_map_exp(steam_id, game_playerinfo:get_dynamic_properties_by_key(steam_id, "extra_mapexp"))
            game_playerinfo:change_player_result(steam_id, "mapExp", game_playerinfo:get_dynamic_properties_by_key(steam_id, "extra_mapexp"))
            -- game_playerinfo:update_score(steam_id, 10)
            -- game_playerinfo:change_player_result(steam_id, "score",10)
            game_playerinfo:change_player_result(steam_id, "heroLevel",game_playerinfo:get_hero_level_by_name(steam_id, hero_name))
            -- game_playerinfo:change_player_result(steam_id, "heroNowExp",game_playerinfo:get_hero_exp_by_name(steam_id, hero_name))
            game_playerinfo:change_player_result(steam_id, "mapLevel",game_playerinfo:get_map_level_by_id(steam_id))
            -- game_playerinfo:change_player_result(steam_id, "mapExp",game_playerinfo:get_map_exp_by_id(steam_id))
            game_playerinfo:update_pass_level(steam_id)
            game_playerinfo:add_hero_winnumber_by_name(steam_id, hero_name, 1)
            game_playerinfo:add_hero_select_by_name(steam_id, hero_name, 1)

            -- local hero = PlayerResource:GetPlayer(playerid):GetAssignedHero()
            -- hero:AddNewModifier(hero, nil, "modifier_get_exp_lua", { duration = 5 })
            if global_var_func.background_musicplayer then
                StopGlobalSound(global_var_func.background_musicplayer)
            end
            -- EmitGlobalSound("game.win")
            sendprize_list["player_"..playerid] = prize_list
            
            game_playerinfo:save_totem(playerid)
        end
        game_playerinfo:save_archive()
        is_winner = true
        print(">>>>>>>>> game win <<<<<<<<<<<<<<")
        -- 冻结游戏
        Tutorial:SetTimeFrozen(true)
        EmitGlobalSound("game.over.victory")
        sendresult(is_winner, self:GetGameTime(), sendprize_list)
        CustomGameEventManager:Send_ServerToAllClients("close_game_over_warning_time",nil)
        return nil
    end

    -- 失败
    if GameRules: State_Get() == DOTA_GAMERULES_STATE_GAME_IN_PROGRESS and count_unit_table_num() > global_var_func.unit_total then
        if global_var_func.game_over_warning_time <= 0 then
            -- GameRules: SetGameWinner(DOTA_TEAM_BADGUYS)
            local sendprize_list = {}
            local player_count = global_var_func.all_player_amount
            for playerid = 0, player_count-1 do
                local prize_list = {}
                if not global_var_func.player_base_info[playerid] then
                    global_var_func.player_base_info[playerid] = {}
                    global_var_func.player_base_info[playerid]["steam_id"] = 0
                    global_var_func.player_base_info[playerid]["heroname"] = ""
                end
                local steam_id =  global_var_func.player_base_info[playerid]["steam_id"]
                local hero_name = global_var_func.player_base_info[playerid]["heroname"]
                -- 普通关卡失败奖励
                TheGiftOfThePharaohLose(playerid, GameRules:GetCustomGameDifficulty(), math.floor(now/60), prize_list)

                game_playerinfo:change_player_result(steam_id, "heroLevel",game_playerinfo:get_hero_level_by_name(steam_id, hero_name))
                -- game_playerinfo:change_player_result(steam_id, "heroNowExp",game_playerinfo:get_hero_exp_by_name(steam_id, hero_name))
                game_playerinfo:change_player_result(steam_id, "mapLevel",game_playerinfo:get_map_level_by_id(steam_id))
                -- game_playerinfo:change_player_result(steam_id, "mapExp",game_playerinfo:get_map_exp_by_id(steam_id))
                game_playerinfo:add_hero_select_by_name(steam_id, hero_name, 1)
                sendprize_list["player_"..playerid] = prize_list
                game_playerinfo:save_totem(playerid)
            end
            game_playerinfo:save_archive()
            if global_var_func.background_musicplayer then
                StopGlobalSound(global_var_func.background_musicplayer)
            end
            -- EmitGlobalSound("game.lose")
            print(">>>>>>>>> game lose <<<<<<<<<<<<<<")
            -- 冻结游戏
            Tutorial:SetTimeFrozen(true)
            EmitGlobalSound("game.over.Defeated")
            sendresult(is_winner, self:GetGameTime(), sendprize_list)
            CustomGameEventManager:Send_ServerToAllClients("close_game_over_warning_time",nil)
            return nil
        end
        CustomGameEventManager:Send_ServerToAllClients("show_game_over_warning_time",{warning_time = global_var_func.game_over_warning_time})
        global_var_func.game_over_warning_time = global_var_func.game_over_warning_time - 1
        return 1
    end

    -- 倒计时
    if global_var_func.game_over_warning_time < 10 then
        global_var_func.game_over_warning_time = 10
        CustomGameEventManager:Send_ServerToAllClients("close_game_over_warning_time",nil)
    end

    return 1
end

-- 在所有英雄死亡后，保证怪物移动
function rule_unit_spawn: KeepUnitMoveThink ()
    for _, unit in pairs(global_var_func.unit_table) do
        if not(unit:IsNull()) and not(unit.independ) and unit: IsAlive() and not(unit: IsMoving()) and not(unit: IsAttacking()) and not unit:IsChanneling() then
            if unit.is_reach then
                if unit.start_position then
                    unit: MoveToPositionAggressive(unit.start_position)
                end
            else
                if unit.end_position then
                    unit: MoveToPositionAggressive(unit.end_position)
                end
            end
        end
    end
    return 1
end

-- 下一轮刷怪
function rule_unit_spawn: NextRoundThink ()
    if not GameRules:IsGamePaused() then
        if GameRules: State_Get() == DOTA_GAMERULES_STATE_GAME_IN_PROGRESS then
            if self:GetGameTime() > global_var_func.next_round_time then
                -- 根据掉线玩家重新计算怪物上限数
                give_premium()
                CountDeadLine()
                global_var_func.current_round = global_var_func.current_round + 1
                -- 难五之后休息时间改为5秒
                if GameRules:GetCustomGameDifficulty() >= 5 then
                    global_var_func.rest_time = 5
                end
                -- 最后一轮一直刷兵
                if IsFinalRound() then
                    global_var_func.rest_time = 0
                end
                -- 倒数第二轮休息8秒
                if IsFinalSecondRound() then
                    global_var_func.rest_time = 8
                end
                -- 难7之后休息时间改为0秒
                -- if GameRules:GetCustomGameDifficulty() >= 8 then
                --     global_var_func.rest_time = 0
                -- end
                global_var_func.next_round_time = global_var_func.next_round_time + global_var_func.round_interval
                -- 刷怪
                self: CreateGreeps()
                self: CreateBoss()
                return global_var_func.round_interval
            end
            -- 关底boss
            if global_var_func.last_time <= 0 then
                if RollPercentage(global_var_func.show_final_boss) then
                    self:FinalBattle()
                else 
                    global_var_func.final_boss = true
                end
                return nil
            end
        end
    end
    return 1
end

function rule_unit_spawn:FinalBattle()
    global_var_func.current_game_step = DOTA_GAME_STEP_FINALLY_BOSS
    -- 清理单位
    for _, unit in pairs(global_var_func.unit_table) do
        if unit and not unit:IsNull() and unit:IsAlive() then
            unit:ForceKill(false)
        end
    end
    -- 英雄复位
    for _, hero in pairs(HeroList:GetAllHeroes()) do
         if hero and not hero:IsNull() and hero:IsAlive() then
             local player_id = hero:GetPlayerID()
             FindClearSpaceForUnit(hero, Entities:FindByName(nil, global_var_func.corner[player_id + 1].hero_corner):GetOrigin(), true)
         end
    end
    -- 关门
    for i = 1 ,4 do
        Entities:FindByName(nil,"door00"..i.."o"):Trigger(nil,nil)
        local door = Entities:FindByName(nil,"door0"..i)
        local position = door:GetOrigin()
        door:SetContextThink(DoUniqueString("open_the_door"), function ()
            position.z = position.z + 5 
            door:SetOrigin(position)
            if position.z >= 0 then 
                return nil
            end
            return 0.01
        end, 0)
    end
    local lg = Entities:FindByName(nil,"jinzita001c")
    if lg then
        lg:Trigger(nil,nil)
    end
    -- boss
    local index = ParticleManager:CreateParticle("particles/ambient/warning1.vpcf", PATTACH_WORLDORIGIN, nil)
    ParticleManager:ReleaseParticleIndex(index)
    GameRules:GetGameModeEntity():SetContextThink(DoUniqueString("boss_show"), function ()
        self:SpawnFinallyBoss()
    end, 5)
end

function rule_unit_spawn: SpawnFinallyBoss()
    local boss = CreateUnitByName(
        "boss_finally",
        Vector(0, 0, -1000),
        true,
        nil,
        nil,
        DOTA_TEAM_BADGUYS
    )
    AppendUnitTypeFlag(boss, global_var_func.flag_boss_finally)
    SetUnitBaseValue(boss)
    boss:AddNewModifier(nil, nil, "modifier_conmon_boss", nil)
    local health = boss:GetHealth()
    CustomGameEventManager:Send_ServerToAllClients("show_boss_health_bar", {
        name = boss:GetUnitName(),
        num = self:GetHPNum(health),
        loss = self:GetCurrentLoss(health),
        time = global_var_func.final_boss_alive_time,
    })
    boss:SetOrigin(GetGroundPosition(Vector(-1184.66,-1026.62,568.624), boss))
    boss:StartGesture(ACT_DOTA_SPAWN)
    GameRules:GetGameModeEntity():SetContextThink(DoUniqueString("finally_boss"), function ()
        if GameRules:IsGamePaused() then
            return 1
        end
        if not boss.alive_time then
            boss.alive_time = global_var_func.final_boss_alive_time
            return 1
        end
        boss.alive_time = boss.alive_time - 1
        if not boss:IsAlive() or boss.alive_time <= 0 then
            CustomGameEventManager:Send_ServerToAllClients("close_boss_health_bar", nil)
            global_var_func.final_boss = true
            return nil
        end
        return 1
    end, 0)
    GameRules:GetGameModeEntity():SetContextThink(DoUniqueString("update_finally_boss"), function ()
        if GameRules:IsGamePaused() then
            return 1
        end
        if boss and not boss:IsNull() and boss:IsAlive() then
            local health1 = boss:GetHealth()
            CustomGameEventManager:Send_ServerToAllClients("update_boss_hp", {
                name = boss:GetUnitName(),
                num = self:GetHPNum(health1),
                loss = self:GetCurrentLoss(health1),
                time = boss.alive_time,
            })
            return 1 / 60
        end
        return nil
    end, 0)
end

function rule_unit_spawn: GetHPNum(health)
    if health < global_var_func.final_boss_hp_each then
        return 0
    end
    if math.fmod(health, global_var_func.final_boss_hp_each) == 0 then
        return math.floor(health / global_var_func.final_boss_hp_each) - 1
    end
    return math.floor(health / global_var_func.final_boss_hp_each)
end

function rule_unit_spawn: GetCurrentLoss(health)
    local loss = math.fmod(health, global_var_func.final_boss_hp_each)
    if health ~= 0 and loss == 0 then
        loss = global_var_func.final_boss_hp_each
    end
    return math.floor(loss * 100 / global_var_func.final_boss_hp_each)
end

function rule_unit_spawn:GetGameTime()
    return global_var_func.game_time - global_var_func.last_time
end

-- 怪物返回
function rule_unit_spawn:UnitReturnThink()
    for i=1, 4 do
        local unit_table = FindUnitsInRadius(
            DOTA_TEAM_BADGUYS,
            Entities:FindByName(nil, global_var_func.corner[i].end_corner):GetOrigin(),
            nil,
            200,
            DOTA_UNIT_TARGET_TEAM_BOTH,
            DOTA_UNIT_TARGET_ALL,
            DOTA_UNIT_TARGET_FLAG_NONE,
            FIND_ANY_ORDER,
            false)
        for _,unit in pairs(unit_table) do
            if not unit:IsNull() and not unit:IsHero() and not unit.independ and unit:IsAlive() and not unit:IsMoving() and not unit:IsAttacking() then
                unit.is_reach = true
                unit:AddNewModifier(nil, nil, "modifier_phased", {duration = 3})
                if unit.start_position then
                    unit:MoveToPositionAggressive(unit.start_position)
                end
            end
        end
    end
    return 0.3
end

local temp_unit_table = {}
-- 防止卡怪
function rule_unit_spawn:FindClearSpaceThink()
    for i = 1, #temp_unit_table do
        local unit = table.remove(temp_unit_table)
        FindClearSpaceForUnit(unit, unit:GetAbsOrigin(), true)
    end
    return 1/144
end

-- 创建小怪
function rule_unit_spawn: CreateGreeps ()
    -- 小怪技能
    local creep_ability_name = nil
    local witch_ability_name = nil
    local ability_percent = nil
    if GameRules:GetCustomGameDifficulty() >= 2 then
        creep_ability_name = RandomCreepAbility()
        witch_ability_name = RandomWitchAbility()
        ability_percent = (GameRules:GetCustomGameDifficulty() - 1) * 2
    end
    for playerid=0, 3 do
        Timers(function()
            if GameRules: State_Get() == DOTA_GAMERULES_STATE_GAME_IN_PROGRESS and global_var_func.last_time > 0 and self:GetGameTime() <= global_var_func.next_round_time - global_var_func.rest_time then
                if OnLine(playerid) then
                    local unit_name = self:RandomCreepName()
                    local unit = self: CreateUnit({
                        name = unit_name,
                        start_position =  Entities:FindByName(nil, global_var_func.corner[playerid + 1].start_corner):GetOrigin() + RandomVector(RandomFloat(0, 800)),
                        end_position = Entities:FindByName(nil, global_var_func.corner[playerid + 1].end_corner):GetOrigin(),
                        team = DOTA_TEAM_BADGUYS,
                        player_id = playerid,
                    })
                    for _, value in pairs(rule_unit_spawn.creep) do
                        if value[1] == unit_name then
                            AppendUnitTypeFlag(unit, value[2])
                        end
                    end
                    unit.player_id = playerid
                    SetUnitBaseValue(unit)
                    if ability_percent and RollPercentage(ability_percent) then
                        if unit_name == "creep_witcher" then
                            if witch_ability_name then
                                unit:AddAbility(witch_ability_name):SetLevel(1)
                            end
                        else
                            if creep_ability_name then
                                unit:AddAbility(creep_ability_name):SetLevel(1)
                            end
                        end 
                    end
                end
                return SpawnTimeInterval(playerid)
            end
        end)
    end
end

rule_unit_spawn.creep = 
{
    -- 僵尸
    {
        "creep_zombie",
        global_var_func.flag_creep_js_1,
    },
    -- 骷髅
    {
        "creep_skeleton",
        global_var_func.flag_creep_kl_1,
    },
    -- 巨魔
    {
        "creep_troll",
        global_var_func.flag_creep_jm_1,
    },
    -- 巫师
    {
        "creep_witcher",
        global_var_func.flag_creep_ws_1,
    },
}
local random_value = 0
-- 随机小怪
function rule_unit_spawn:RandomCreepName()
    if  global_var_func.current_round < 10 then
        random_value = RandomInt(1, 3)
        return rule_unit_spawn.creep[random_value][1]
    else
        random_value = RandomInt(1, 4)
        return rule_unit_spawn.creep[random_value][1]
    end
end

-- 创建Boss
function rule_unit_spawn: CreateBoss ()
    local round = IsBossRound()
    if round then
        local boss_table = {
            "boss_undying",
            "boss_lich",
            "boss_medusa",
            "boss_tiny",
            "boss_sand_king",
            "boss_wraith_king",
        }
        for i=1, 4 do
            if OnLine(i - 1) then
                local unit = self: CreateUnit({
                    name = boss_table[round],
                    start_position = Entities:FindByName(nil, global_var_func.corner[i].start_corner):GetAbsOrigin(),
                    end_position = Entities:FindByName(nil, global_var_func.corner[i].end_corner):GetAbsOrigin(),
                    team = DOTA_TEAM_BADGUYS,
                    player_id = i - 1,
                })
                AppendUnitTypeFlag(unit, global_var_func.flag_boss_general)
                unit.player_id = i - 1
                SetUnitBaseValue(unit)
                if GameRules:GetCustomGameDifficulty() >= 4 then
                    unit:AddAbility("passive_hit_fly"):SetLevel(1)
                    AppendUnitTypeFlag(unit, DOTA_UNIT_TYPE_FLAG_ABILITY)
                end
            end
        end
    end
end

-- 创建任务怪
function rule_unit_spawn: CreateTaskUnit(playerId, itemName, itemLevel)
    if itemName == "item_custom_gold_call" then -- 金币
        global_var_func.task_call_count_log[tostring(playerId)]["task_coin"] = global_var_func.task_call_count_log[tostring(playerId)]["task_coin"] + 1
        local coin_table = {}
        local num = 20
        if PlayerResource:GetPlayer(playerId):GetAssignedHero():HasModifier("modifier_treasure_midas_collection") then
            num = num + 4
        end
        if PlayerResource:GetPlayer(playerId):GetAssignedHero():HasModifier("modifier_treasure_more") then
            num = num + 7
        end
        if PlayerResource:GetPlayer(playerId):GetAssignedHero():HasModifier("modifier_treasure_more_more") then
            num = num + 10
        end
        Timers(function ()
            if #coin_table < num then
                local start_position =  Entities:FindByName(nil, global_var_func.corner[playerId + 1].start_corner):GetAbsOrigin() + RandomVector(RandomFloat(0, 800))
                local end_position = Entities:FindByName(nil, global_var_func.corner[playerId + 1].end_corner):GetAbsOrigin()
                local unit = CreateUnitByName("task_coin", start_position, true, nil, nil, DOTA_TEAM_BADGUYS)
                table.insert(temp_unit_table, unit)
                unit.is_reach = false
                unit.start_position = start_position
                unit.end_position = end_position
                -- 添加相位效果,重新计算碰撞体积
                unit: AddNewModifier(nil, nil, "modifier_phased", {duration = 0.1})
                unit: MoveToPositionAggressive(end_position)
                self: AddUnitTable(unit)
                -- 总共刷怪物数量
                add_spawn_all_unit_count()
                -- 每个玩家当前怪物数量
                add_player_current_count(playerId)
                AppendUnitTypeFlag(unit, global_var_func.flag_creep_jb)
                unit.player_id = playerId
                unit.task_index = itemName
                SetUnitBaseValue(unit)
                table.insert(coin_table, unit)
                return 0.5
            end
            Timers:CreateTimer(60, function ()
                for _,unit in pairs(coin_table) do
                    if unit and not unit:IsNull() and unit:IsAlive() then
                        unit:AddNewModifier(nil, nil, "modifier_common_tp", nil)
                        self: RemoveUnitTable(unit.index)
                        del_player_current_count(playerId)
                    end
                end
            end)
        end)
    elseif itemName == "item_custom_yanmo_call" then -- 炎魔
        local index = ParticleManager:CreateParticle("particles/ambient/warning1.vpcf", PATTACH_WORLDORIGIN, nil)
        ParticleManager:ReleaseParticleIndex(index)
        global_var_func.task_call_count_log[tostring(playerId)]["task_golem"] = global_var_func.task_call_count_log[tostring(playerId)]["task_golem"] + 1
        local position = Entities:FindByName(nil, global_var_func.corner[playerId + 1].start_corner):GetOrigin()
        local count = 0
        Timers(function ()
            local t_position = position + RandomVector(RandomInt(0, 500))
            t_position.z = t_position.z - 300
            local s_position = Vector(t_position.x - 1000, t_position.y + 1000, 2000)
            local nIndex = ParticleManager:CreateParticle("particles/units/heroes/hero_invoker/invoker_chaos_meteor_fly.vpcf", PATTACH_WORLDORIGIN, nil)
            ParticleManager:SetParticleControl(nIndex, 0, s_position)
            ParticleManager:SetParticleControl(nIndex, 1, t_position)
            ParticleManager:ReleaseParticleIndex(nIndex)
            Timers:CreateTimer(1, function()
                local nIndex2 = ParticleManager:CreateParticle("particles/heroes/invoker/combination_t29_sun_strike.vpcf", PATTACH_WORLDORIGIN, nil)
                t_position.z = t_position.z + 300
                ParticleManager:SetParticleControlEnt(nIndex2, 0, nil, PATTACH_WORLDORIGIN, "", t_position, true)
                ParticleManager:ReleaseParticleIndex(nIndex2)
            end)
            count = count + 1
            if count < 10 then
                return 0.2
            end
        end)
        Timers:CreateTimer(2.5, function()
            local unit = self: CreateUnit({
                name = "task_golem",
                start_position = Entities:FindByName(nil, global_var_func.corner[playerId + 1].start_corner):GetAbsOrigin(),
                end_position = Entities:FindByName(nil, global_var_func.corner[playerId + 1].end_corner):GetAbsOrigin(),
                team = DOTA_TEAM_BADGUYS,
                player_id = playerId,
            })
            AppendUnitTypeFlag(unit, global_var_func.flag_boss_ym)
            unit.player_id = playerId
            unit.task_index = itemName
            SetUnitBaseValue(unit)
            -- 双倍快乐
            if PlayerResource:GetPlayer(playerId):GetAssignedHero():HasModifier("modifier_treasure_double_fire") and RollPercentage(15) then
                unit = self: CreateUnit({
                    name = "task_golem",
                    start_position = Entities:FindByName(nil, global_var_func.corner[playerId + 1].start_corner):GetAbsOrigin(),
                    end_position = Entities:FindByName(nil, global_var_func.corner[playerId + 1].end_corner):GetAbsOrigin(),
                    team = DOTA_TEAM_BADGUYS,
                    player_id = playerId,
                })
                AppendUnitTypeFlag(unit, global_var_func.flag_boss_ym)
                unit.player_id = playerId
                unit.task_index = itemName
                SetUnitBaseValue(unit)
            end
        end)
    elseif itemName == "item_custom_ore_call" then -- 金矿
        global_var_func.task_call_count_log[tostring(playerId)]["task_box"] = global_var_func.task_call_count_log[tostring(playerId)]["task_box"] + 1
        local name = "task_box"
        local start_position = Entities:FindByName(nil, global_var_func.corner[playerId + 1].start_corner):GetAbsOrigin()
        local temp_player_id = playerId + 2
        if temp_player_id > 3 then
            temp_player_id = temp_player_id - 4
        end
        local end_position = Entities:FindByName(nil, global_var_func.corner[temp_player_id + 1].start_corner):GetAbsOrigin()
        local unit = CreateUnitByName(name, start_position, true, nil, nil, DOTA_TEAM_BADGUYS)
        AppendUnitTypeFlag(unit, global_var_func.flag_creep_jk)
        unit.player_id = playerId
        unit.task_index = itemName
        unit.independ = true  -- 独立运动轨迹
        table.insert(temp_unit_table, unit)
        SetUnitBaseValue(unit)
        -- 添加相位效果,重新计算碰撞体积
        unit: AddNewModifier(nil, nil, "modifier_phased", {duration = 3})
        unit: MoveToPositionAggressive(end_position)
        self: AddUnitTable(unit)
        -- 总共刷怪物数量
        add_spawn_all_unit_count()
        -- 每个玩家当前怪物数量
        add_player_current_count(playerId)
        unit:SetContextThink(DoUniqueString("jk_independ_think"),
            function()
                local current_position = unit:GetAbsOrigin()
                local c_x = current_position.x
                local c_y = current_position.y
                local e_x = end_position.x
                local e_y = end_position.y
                local temp = math.abs(c_x - e_x) * math.abs(c_x - e_x) + math.abs(c_y - e_y) * math.abs(c_y - e_y)
                if math.sqrt(temp) < 300 then
                    if not unit:IsNull() then
                        local nIndex = ParticleManager:CreateParticle("particles/diy_particles/run.vpcf", PATTACH_OVERHEAD_FOLLOW, unit)
                        unit:AddNewModifier(nil, nil, "modifier_common_tp", nil):AddParticle(nIndex, false, false, 15, false, false)
                        self: RemoveUnitTable(unit.index) 
                        del_player_current_count(playerId)
                    end
                    return nil
                end
                if not(unit: IsMoving()) then
                    unit: MoveToPositionAggressive(end_position)
                end
                return 0.5
            end
        , 0)
    elseif itemName == "item_custom_talent_call" then
        global_var_func.task_call_count_log[tostring(playerId)]["task_talent"] = global_var_func.task_call_count_log[tostring(playerId)]["task_talent"] + 1
        local unit = self: CreateUnit({
            name = "task_talent",
            start_position = Entities:FindByName(nil, global_var_func.corner[playerId + 1].start_corner):GetAbsOrigin(),
            end_position = Entities:FindByName(nil, global_var_func.corner[playerId + 1].end_corner):GetAbsOrigin(),
            team = DOTA_TEAM_BADGUYS,
            player_id = playerId,
        })
        AppendUnitTypeFlag(unit, global_var_func.flag_boss_talent)
        unit.player_id = playerId
        unit.task_index = itemName
        SetUnitBaseValue(unit)
    else -- 铁匠
        local unit = self: CreateUnit({
            name = "task_smith",
            start_position = Entities:FindByName(nil, global_var_func.corner[playerId + 1].start_corner):GetAbsOrigin(),
            end_position = Entities:FindByName(nil, global_var_func.corner[playerId + 1].end_corner):GetAbsOrigin(),
            team = DOTA_TEAM_BADGUYS,
            player_id = playerId,
        })
        AppendUnitTypeFlag(unit, global_var_func.flag_boss_tj)
        unit.player_id = playerId
        unit.task_index = "tiejiang"
        unit.item_name = itemName
        unit.item_level = itemLevel
        SetUnitBaseValue(unit)
        -- 等级越高颜色越绿
        unit: SetRenderColor(255 - 50 * itemLevel, 255, 255 - 50 * itemLevel)
        return unit
    end
end

-- 创建单位
function rule_unit_spawn: CreateUnit (info)
    local unit = CreateUnitByName(info.name, info.start_position, true, nil, nil, info.team)
    table.insert(temp_unit_table, unit)
    unit.is_reach = false
    unit.start_position = info.start_position
    unit.end_position = info.end_position
    -- 添加相位效果,重新计算碰撞体积
    unit: AddNewModifier(nil, nil, "modifier_phased", {duration = 0.1})
    unit: MoveToPositionAggressive(info.end_position)
    self: AddUnitTable(unit)
    -- 总共刷怪物数量
    add_spawn_all_unit_count()
    -- 每个玩家当前怪物数量
    add_player_current_count(info.player_id)
    return unit
end

-- 怪物列表减少
function rule_unit_spawn: RemoveUnitTable (index)
    global_var_func.unit_table[tostring(index)] = nil
end

-- 游戏难度加成
function rule_unit_spawn: GameDifficultyBounty(unit)
    local difficulty = GameRules:GetCustomGameDifficulty()
    -- 攻击力
    local damage = unit: GetBaseDamageMin() * (1 + 0.5 * (difficulty - 1))
    unit: SetBaseDamageMin(damage)
    unit: SetBaseDamageMax(damage)
    -- 血量
    local health = unit: GetBaseMaxHealth() * difficulty
    if health >= 21 * 10000 * 10000 then
        health = 21 * 10000 * 10000 - 1
    end
    unit: SetBaseMaxHealth(health)
    unit: SetMaxHealth(health)
    unit: SetHealth(health)
end

-- 超负荷
function rule_unit_spawn: RequestOverload(event)
    if not event.record 
    or (event.record == 1 and global_var_func.overload_record[event.PlayerID + 1] >= 4 and event.record == 1) 
    or (event.record == -1 and global_var_func.overload_record[event.PlayerID + 1] <= 0 ) then
        event.record = 0
    end
    global_var_func.overload_record[event.PlayerID + 1] = global_var_func.overload_record[event.PlayerID + 1] + event.record
    local temp = global_var_func.overload_data[tostring(global_var_func.overload_record[event.PlayerID + 1])]
    temp["record"] = global_var_func.overload_record[event.PlayerID + 1]
    temp["stackcount"] = 0
    local hero = PlayerResource:GetPlayer(event.PlayerID):GetAssignedHero()
    if event.record == 1 then
        EmitSoundOn("overload.increase", hero)
    elseif event.record == -1 then
        EmitSoundOn("overload.decrease", hero)
    end
    if hero then
        local mdf = hero:FindModifierByName("modifier_treasure_back_off_a")
        if mdf then
            if event.record == -1 and mdf:GetStackCount() > 0 then
                event.record = 0
                mdf:DecrementStackCount()
            end
            temp["stackcount"] = temp["stackcount"] + mdf:GetStackCount()
        end
        mdf = hero:FindModifierByName("modifier_treasure_back_off_b")
        if mdf then
            if event.record == -1 and mdf:GetStackCount() > 0 then
                event.record = 0
                mdf:DecrementStackCount()
            end
            temp["stackcount"] = temp["stackcount"] + mdf:GetStackCount()
        end
        mdf = hero:FindModifierByName("modifier_treasure_back_off_c")
        if mdf then
            if event.record == -1 and mdf:GetStackCount() > 0 then
                event.record = 0
                mdf:DecrementStackCount()
            end
            temp["stackcount"] = temp["stackcount"] + mdf:GetStackCount()
        end
    end
    CustomGameEventManager:Send_ServerToPlayer(PlayerResource:GetPlayer(event.PlayerID), "response_overload", temp)
end

-- 召唤BOSS
function rule_unit_spawn: RequestCallBoss(event)
    if global_var_func.call_boss_record[event.PlayerID + 1] >= #global_var_func.call_boss_max then
        return
    end
    if event.difficulty then
        if event.PlayerID == 0 then
            if #global_var_func.player_0_kill_count < global_var_func.call_boss_kill_node[event.PlayerID + 1] + global_var_func.call_boss_max[global_var_func.call_boss_record[event.PlayerID + 1] + 1] then
                CustomGameEventManager:Send_ServerToPlayer(PlayerResource:GetPlayer(event.PlayerID), "response_errortext",{errortext = "不满足条件"})
                return
            end
            global_var_func.call_boss_kill_node[event.PlayerID + 1] = #global_var_func.player_0_kill_count
        elseif event.PlayerID == 1 then
            if #global_var_func.player_1_kill_count < global_var_func.call_boss_kill_node[event.PlayerID + 1] + global_var_func.call_boss_max[global_var_func.call_boss_record[event.PlayerID + 1] + 1] then
                CustomGameEventManager:Send_ServerToPlayer(PlayerResource:GetPlayer(event.PlayerID), "response_errortext",{errortext = "不满足条件"})
                return
            end
            global_var_func.call_boss_kill_node[event.PlayerID + 1] = #global_var_func.player_1_kill_count
        elseif event.PlayerID == 2 then
            if #global_var_func.player_2_kill_count < global_var_func.call_boss_kill_node[event.PlayerID + 1] + global_var_func.call_boss_max[global_var_func.call_boss_record[event.PlayerID + 1] + 1] then
                CustomGameEventManager:Send_ServerToPlayer(PlayerResource:GetPlayer(event.PlayerID), "response_errortext",{errortext = "不满足条件"})
                return
            end
            global_var_func.call_boss_kill_node[event.PlayerID + 1] = #global_var_func.player_2_kill_count
        elseif event.PlayerID == 3 then
            if #global_var_func.player_3_kill_count < global_var_func.call_boss_kill_node[event.PlayerID + 1] + global_var_func.call_boss_max[global_var_func.call_boss_record[event.PlayerID + 1] + 1] then
                CustomGameEventManager:Send_ServerToPlayer(PlayerResource:GetPlayer(event.PlayerID), "response_errortext",{errortext = "不满足条件"})
                return
            end
            global_var_func.call_boss_kill_node[event.PlayerID + 1] = #global_var_func.player_3_kill_count
        end
        local next_record = global_var_func.call_boss_record[event.PlayerID + 1] + 1
        local unit = CreateUnitByName(
            "boss_call_"..next_record,
            Entities:FindByName(nil, global_var_func.corner[event.PlayerID + 1].start_corner):GetOrigin(),
            true,
            nil,
            nil,
            DOTA_TEAM_BADGUYS
        )
        AppendUnitTypeFlag(unit, global_var_func.flag_boss_call)
        unit.player_id = event.PlayerID
        unit.difficulty = event.difficulty
        if unit.difficulty == 1 then
            AppendUnitTypeFlag(unit, DOTA_UNIT_TYPE_FLAG_DIFFICULTY_1)
        elseif unit.difficulty == 2 then
            AppendUnitTypeFlag(unit, DOTA_UNIT_TYPE_FLAG_DIFFICULTY_2)
        elseif unit.difficulty == 3 then
            AppendUnitTypeFlag(unit, DOTA_UNIT_TYPE_FLAG_DIFFICULTY_3)
        end
        SetUnitBaseValue(unit)
        rule_unit_spawn:AddUnitTable(unit)
        -- 总共刷怪物数量
        add_spawn_all_unit_count()
        -- 每个玩家当前怪物数量
        add_player_current_count(event.PlayerID)
        global_var_func.call_boss_record[event.PlayerID + 1] = next_record
    end
    local call_boss_info = {}
    if global_var_func.call_boss_record[event.PlayerID + 1] < #global_var_func.call_boss_max then
        local next_record = global_var_func.call_boss_record[event.PlayerID + 1] + 1
        call_boss_info["record"] = next_record
        call_boss_info["max"] = global_var_func.call_boss_max[next_record]
        local boss_1 = CalculateCallBoseValue(1, next_record)
        local boss_2 = CalculateCallBoseValue(2, next_record )
        local boss_3 = CalculateCallBoseValue(3, next_record)
        call_boss_info["boss_info"] = {
            ["boss_call_1"] = {
                ["boss_call_attack"] = boss_1[1],
                ["boss_call_hp"] = boss_1[2],
                ["boss_call_armor"] = boss_1[3],
            },
            ["boss_call_2"] = {
                ["boss_call_attack"] = boss_2[1],
                ["boss_call_hp"] = boss_2[2],
                ["boss_call_armor"] = boss_2[3],
            },
            ["boss_call_3"] = {
                ["boss_call_attack"] = boss_3[1],
                ["boss_call_hp"] = boss_3[2],
                ["boss_call_armor"] = boss_3[3],
            }
        }
        call_boss_info["ability"] = {}
        local UnitKV = GameRules:GetGameModeEntity().UnitKV
        for i = 1, 3 do
            local temp = {}
            for j = 1, 40 do
                local name = UnitKV["boss_call_"..i]['Ability'..j]
                if name and name ~= "" then
                    temp[tostring(j)] = name
                end
            end
            call_boss_info["ability"][tostring(i)] = temp
        end
    end
    CustomGameEventManager:Send_ServerToPlayer(PlayerResource:GetPlayer(event.PlayerID), "response_call_boss", call_boss_info)
    if event.difficulty and event.difficulty ~= 0 then
        send_tips_message_challenge(event.PlayerID,nil,PlayerResource:GetPlayerName(event.PlayerID),"tip_challenge_boss")
        send_tips_message_challenge(event.PlayerID,event.difficulty,nil,"tip_challenge_difficulty")
        send_tips_message_challenge(event.PlayerID,nil,"DOTA_Tooltip_challenge_boss_reward","tip_challenge_reward")
    end
end

-- 怪物列表增加
function rule_unit_spawn: AddUnitTable (unit)
    global_var_func.unit_table[tostring(unit: entindex())] = unit
end