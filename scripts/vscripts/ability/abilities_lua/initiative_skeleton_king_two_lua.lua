require("custom_event_listen")
require("info/game_playerinfo")
require('service/service')
--骷髅王技能2
initiative_skeleton_king_two_lua = class({})


function initiative_skeleton_king_two_lua:OnSpellStart()
    local creep_ability_name = nil
    local witch_ability_name = nil
    local ability_percent = nil
    creep_ability_name = RandomCreepAbility()
    witch_ability_name = RandomWitchAbility()
    ability_percent = (GameRules:GetCustomGameDifficulty() - 1) * 2

    if GameRules: State_Get() == DOTA_GAMERULES_STATE_GAME_IN_PROGRESS then
        self:GetCaster():EmitSound("Hero_SkeletonKing.Attack.call")
        -- for i=1, 4 do
        for i=1, 20 do
            -- if self: OnLine(i - 1) then
            local unit_name = self:RandomCreepName()
            local unit = self: CreateUnit({
                name = unit_name,
                start_position = self:GetStartPosition(),
                end_position = self:GetCaster():GetOrigin(),
                team = DOTA_TEAM_BADGUYS,
                -- team = DOTA_TEAM_FIRST,
            })
            for _, value in pairs(rule_unit_spawn.creep) do
                if value[1] == unit_name then
                    AppendUnitTypeFlag(unit, value[2])
                end
            end
            -- unit.player_id = i - 1
            unit.player_id = 0
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
            -- end
        end
    end
end
-- 玩家是否在线
function initiative_skeleton_king_two_lua: OnLine (player_id) 
    return PlayerResource:GetConnectionState(player_id) == DOTA_CONNECTION_STATE_CONNECTED
end
-- 小怪指定地点刷新规则
function initiative_skeleton_king_two_lua:GetStartPosition()
    local radius = RandomFloat(0, 500)
    -- local start_position = Entities:FindByName(nil, global_var_func.corner[index].start_corner):GetAbsOrigin() + RandomVector(radius)
    local start_position = self:GetCaster():GetAbsOrigin() + RandomVector(radius)
    return start_position
end
-- 随机小怪
function initiative_skeleton_king_two_lua:RandomCreepName()
    if  global_var_func.current_round < 10 then
        random_value = RandomInt(1, 3)
        return rule_unit_spawn.creep[random_value][1]
    else
        random_value = RandomInt(1, 4)
        return rule_unit_spawn.creep[random_value][1]
    end
end
local temp_unit_table = {}
-- 创建单位
function initiative_skeleton_king_two_lua: CreateUnit (info)
    local unit = CreateUnitByName(info.name, info.start_position, true, nil, nil, info.team)
    table.insert(temp_unit_table, unit)
    unit.is_reach = false
    unit.start_position = info.start_position
    unit.end_position = info.end_position
    -- 添加相位效果,重新计算碰撞体积
    unit: AddNewModifier(nil, nil, "modifier_phased", {duration = 0.1})
    unit: MoveToPositionAggressive(info.end_position)
    if not string.find("task_smith,task_coin,task_golem,task_box", unit:GetUnitName()) then
        self: AddUnitTable(unit)
    end
    -- 总共刷怪物数量
    add_spawn_all_unit_count()
    -- 每个玩家当前怪物数量
    add_player_current_count(info.player_id)
    return unit
end
-- 怪物列表增加
function initiative_skeleton_king_two_lua: AddUnitTable (unit)
    global_var_func.unit_table[tostring(unit: entindex())] = unit
end