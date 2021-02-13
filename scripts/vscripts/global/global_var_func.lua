require("herolist")
require("heroabilitylist")
require("config/config_enum")
local config_creep_ability = require("config/config_creep_ability")
local config_witch_ability = require("config/config_witch_ability")
local config_creep_aura = require("config/config_creep_aura")

-- 储存全局变量和全局函数
if global_var_func == nil then
    global_var_func = class({})
end

-- 开发模式标识
DEVELOP_FLAG = false

-- <==============================全局常量================================>
local game_enum = {}
game_enum.GAME_CODE = "mirage_of_the_fall"             -- 游戏名称编码
game_enum.HERO_EXP_INCRE = 1                   -- 英雄熟练度增量
game_enum.TEAM_YY = 1                   -- 夜魇
game_enum.TEAM_TH = 2                   -- 天辉
game_enum.SAVE_FIRST_TIME = 600                   -- 首次存档时间
game_enum.SAVE_SPACE_TIME = 600                   -- 存档间隔时间
game_enum.MAP_EXP_FIRST_TIME = 60                   -- 地图经验增加首次时间
game_enum.MAP_EXP_SPACE_TIME = 60                   -- 地图经验增加间隔时间
game_enum.MAP_EXP_INCRE = 1                   -- 地图经验增量
game_enum.BASE_MANA_REGEN = 2                   -- 基础回蓝
game_enum.RANDOM_EVENT_SPACE_TIME = 10                -- 随机事件间隔时间
game_enum.MAX_HERO_LEVEL = 20                -- 当前最高英雄等级
game_enum.COMPENSATION = 6                -- 服务器当前补偿等级
game_enum.ECONOMIC = 50                -- 投资消耗变量

-- <==============================全局变量================================>
-- 背景音乐名称
global_var_func.background_musicplayer = nil
-- 是否重置背景音乐
global_var_func.replay_musicplayer = false
-- 当前读取完成存档的玩家计数
global_var_func.end_load = 0     
-- 是否允许刷怪           
global_var_func.CANRUSHMONSTER = true                
-- 当前宝物轮数
global_var_func.treasure_round = {0,0,0,0}
-- 当前允许小怪宝物掉落上限           
global_var_func.treasure_drop_max = 1
-- 敏捷攻速上限
global_var_func.max_atk_speed = {300,300,300,300}
-- 总游戏时长
global_var_func.game_time = 1800
-- 游戏倒计时
global_var_func.last_time = global_var_func.game_time
-- 当前第几轮
global_var_func.current_round = 0
-- 怪物列表（包括小怪、boss、任务怪）
global_var_func.unit_table = {}
-- 下一轮刷怪时间
global_var_func.next_round_time = 0
-- 基础怪物数
global_var_func.unit_num_base = 70
-- 每多一个玩家加30
global_var_func.unit_num_bonus = 40
-- 单轮刷怪时长
global_var_func.round_interval = 60
-- 单轮刷怪休息时长
global_var_func.rest_time = 15
-- 精英怪爆率
global_var_func.elite_scale = 2
-- 难度几出现精英怪
global_var_func.show_elite_level = 4
-- 每隔几轮刷boss
global_var_func.spawn_boss_round_interval = 5
-- 关底boss出现概率
global_var_func.show_final_boss = 10
-- 关底BOSS单个血条最大值
global_var_func.final_boss_hp_each = 10000
-- 关底BOSS存活时间
global_var_func.final_boss_alive_time = 240
-- 是否打完关底boss
global_var_func.final_boss = false
-- 是否击杀关底boss
global_var_func.killde_final_boss = false
-- 地图经验倍率
global_var_func.map_exp_rate = 1.0
-- 英雄经验倍率
global_var_func.hero_exp_rate = 1.0
-- 信使玩家映射列表
global_var_func.courier_table = {}
--  金币怪冷却时间
global_var_func.item_custom_gold_call = 240
--炎魔
global_var_func.item_custom_yanmo_call = 240
--金矿
global_var_func.item_custom_ore_call = 300
--心魔
global_var_func.item_custom_shadow_call = 300
-- 刷怪计数
global_var_func.spawn_all_unit_count = {}
-- 玩家击杀计数
global_var_func.player_0_kill_count = {}
-- 玩家击杀计数
global_var_func.player_1_kill_count = {}
-- 玩家击杀计数
global_var_func.player_2_kill_count = {}
-- 玩家击杀计数
global_var_func.player_3_kill_count = {}
-- 玩家当前怪物计数
global_var_func.player_0_current_count = {}
-- 玩家当前怪物计数
global_var_func.player_1_current_count = {}
-- 玩家当前怪物计数
global_var_func.player_2_current_count = {}
-- 玩家当前怪物计数
global_var_func.player_3_current_count = {}
--自定义商店index
global_var_func.cus_shop_index = {}
--额外增加的暴击
global_var_func.extra_ability_crit = {}
--游戏玩家总数
global_var_func.all_player_amount =0
--随机英雄数据
global_var_func.player_random_hero_data ={}
-- 游戏失败预警倒计时
global_var_func.game_over_warning_time = 10
--召唤boss次数
global_var_func.call_boss_count = 1
--已购买物品信息
global_var_func.shop_limit = {}
--宝物书购买上限
global_var_func.shop_baowu_limit = 3
--技能书限额
global_var_func.charge_book_limit = 10
--是否开启考试系统
global_var_func.isbeginexam = 0
--是否正在考试中
global_var_func.isexaming = 0
-- 当前游戏阶段
global_var_func.current_game_step = DOTA_GAME_STEP_NONE
--难度缓存
global_var_func.difficulty_select = {}
-- 刮痧经济基础数值
global_var_func.damage_gold_base = 1
-- 重选英雄计数
global_var_func.repick_hero_count = {}
-- 重选英雄上限
global_var_func.repick_hero_limit = 1
-- 玩家是否新玩家
global_var_func.createPlayer = {}
global_var_func.buy_back_need = {
    [0] = 5000,
    [1] = 5000,
    [2] = 5000,
    [3] = 5000,
}

-- 购买道具锁定
global_var_func.buyGoodsLock = {
	false, false, false, false, 
}

-- 使用道具锁定
global_var_func.useGoodsLock = {
	false, false, false, false, 
}

-- 玩家运营技能额外等级
global_var_func.extra_operate_level = {
    {
        ["modifier_touzi_lua"] = 0,
        ["modifier_maoyi_lua"] = 0,
        ["modifier_lueduo_lua"] = 0,
        ["modifier_shalu_lua"] = 0,
    },
    {
        ["modifier_touzi_lua"] = 0,
        ["modifier_maoyi_lua"] = 0,
        ["modifier_lueduo_lua"] = 0,
        ["modifier_shalu_lua"] = 0,
    },
    {
        ["modifier_touzi_lua"] = 0,
        ["modifier_maoyi_lua"] = 0,
        ["modifier_lueduo_lua"] = 0,
        ["modifier_shalu_lua"] = 0,
    },
    {
        ["modifier_touzi_lua"] = 0,
        ["modifier_maoyi_lua"] = 0,
        ["modifier_lueduo_lua"] = 0,
        ["modifier_shalu_lua"] = 0,
    },
}
-- 所有玩家运营点击次数记录
global_var_func.task_call_count_log = {
    ["0"] = {
        ["task_box"] = 0,
        ["task_golem"] = 0,
        ["cancer"] = 0,
        ["task_coin"] = 0,
        ["task_talent"] = 0,
    },
    ["1"] = {
        ["task_box"] = 0,
        ["task_golem"] = 0,
        ["cancer"] = 0,
        ["task_coin"] = 0,
        ["task_talent"] = 0,
    },
    ["2"] = {
        ["task_box"] = 0,
        ["task_golem"] = 0,
        ["cancer"] = 0,
        ["task_coin"] = 0,
        ["task_talent"] = 0,
    },
    ["3"] = {
        ["task_box"] = 0,
        ["task_golem"] = 0,
        ["cancer"] = 0,
        ["task_coin"] = 0,
        ["task_talent"] = 0,
    },
}
-- 地图设定点
global_var_func.corner = 
{
    {
        start_corner = "start_corner_a",
        end_corner = "end_corner_a",
        hero_corner = "hero_corner_a",
    },
    {
        start_corner = "start_corner_b",
        end_corner = "end_corner_b",
        hero_corner = "hero_corner_b",
    },
    {
        start_corner = "start_corner_c",
        end_corner = "end_corner_c",
        hero_corner = "hero_corner_c",
    },
    {
        start_corner = "start_corner_d",
        end_corner = "end_corner_d",
        hero_corner = "hero_corner_d",
    }
}
--玩家随机词条库
global_var_func.player_random_properties={}
--玩家拥有的词条
global_var_func.player_own_random_properties={}
-- 玩家选定英雄的名称
global_var_func.select_heroname = {}
-- 玩家超负荷记录
global_var_func.overload_record = {0, 0, 0, 0}
-- 超负荷数据
global_var_func.overload_data = {
    ["0"] = {
        ["income"] = {
            ["overload_income_time"] = 0, -- 每轮刷怪间隔减0
            ["overload_display_value"] = 0, -- 界面显示
        },
        ["outgo"] = {
            ["overload_outgo_hp"] = 0, -- 怪物血量成长0%
        },
    },
    ["1"] = {
        ["income"] = {
            ["overload_income_time"] = 0.09, -- 每轮刷怪间隔减0.1
            ["overload_display_value"] = 20, -- 界面显示
        },
        ["outgo"] = {
            ["overload_outgo_hp"] = 10, -- 怪物血量成长10%
        },
    },
    ["2"] = {
        ["income"] = {
            ["overload_income_time"] = 0.16, -- 每轮刷怪间隔减0.17
            ["overload_display_value"] = 40, -- 界面显示
        },
        ["outgo"] = {
            ["overload_outgo_hp"] = 20, -- 怪物血量成长20%
        },
    },
    ["3"] = {
        ["income"] = {
            ["overload_income_time"] = 0.22, -- 每轮刷怪间隔减0.23
            ["overload_display_value"] = 60, -- 界面显示
        },
        ["outgo"] = {
            ["overload_outgo_hp"] = 30, -- 怪物血量成长30%
        },
    },
    ["4"] = {
        ["income"] = {
            ["overload_income_time"] = 0.28, -- 每轮刷怪间隔减0.28
            ["overload_display_value"] = 80, -- 界面显示
        },
        ["outgo"] = {
            ["overload_outgo_hp"] = 40, -- 怪物血量成长40%
        },
    },
}
-- 玩家召唤BOSS记录
global_var_func.call_boss_record = {0, 0, 0, 0}
-- 召唤BOSS击杀数量节点
global_var_func.call_boss_kill_node = {0, 0, 0, 0}
-- 召唤BOSS条件
global_var_func.call_boss_max = {100, 200, 380, 520, 680, 900}
-- 内置CD
global_var_func.split_cd = 0.5
-- 恫吓
global_var_func.intimidate = {false, false, false, false}

-- <===========================s===单位类型标识================================>
-- 小怪
global_var_func.flag_creep = DOTA_UNIT_TYPE_FLAG_CREEP
-- BOSS
global_var_func.flag_boss = DOTA_UNIT_TYPE_FLAG_BOSS
-- 僵尸
global_var_func.flag_creep_js_1 = DOTA_UNIT_TYPE_FLAG_CREEP + DOTA_UNIT_TYPE_FLAG_GENERAL
-- 骷髅
global_var_func.flag_creep_kl_1 = DOTA_UNIT_TYPE_FLAG_CREEP + DOTA_UNIT_TYPE_FLAG_GENERAL
-- 巨魔
global_var_func.flag_creep_jm_1 = DOTA_UNIT_TYPE_FLAG_CREEP + DOTA_UNIT_TYPE_FLAG_GENERAL
-- 巫师
global_var_func.flag_creep_ws_1 = DOTA_UNIT_TYPE_FLAG_CREEP + DOTA_UNIT_TYPE_FLAG_GENERAL
-- 金币怪
global_var_func.flag_creep_jb = DOTA_UNIT_TYPE_FLAG_CREEP + DOTA_UNIT_TYPE_FLAG_OPERATION + DOTA_UNIT_TYPE_FLAG_GOLD
-- 金矿
global_var_func.flag_creep_jk = DOTA_UNIT_TYPE_FLAG_CREEP + DOTA_UNIT_TYPE_FLAG_OPERATION + DOTA_UNIT_TYPE_FLAG_GOLD + DOTA_UNIT_TYPE_FLAG_NO_ATTACK
-- 普通BOSS
global_var_func.flag_boss_general = DOTA_UNIT_TYPE_FLAG_BOSS + DOTA_UNIT_TYPE_FLAG_GENERAL
-- 关底BOSS
global_var_func.flag_boss_finally = DOTA_UNIT_TYPE_FLAG_BOSS + DOTA_UNIT_TYPE_FLAG_FINALLY
-- 炎魔
global_var_func.flag_boss_ym = DOTA_UNIT_TYPE_FLAG_BOSS + DOTA_UNIT_TYPE_FLAG_OPERATION
-- 铁匠
global_var_func.flag_boss_tj = DOTA_UNIT_TYPE_FLAG_BOSS + DOTA_UNIT_TYPE_FLAG_UPGRADE_ITEM
-- 召唤BOSS
global_var_func.flag_boss_call = DOTA_UNIT_TYPE_FLAG_BOSS + DOTA_UNIT_TYPE_FLAG_CALL
--玩家商品列表
global_var_func.player_shop_item = {["player0"]={},["player1"]={},["player2"]={},["player3"]={}}
--商城物品冷却记录
global_var_func.shop_item_cooldown = {["player0"]={},["player1"]={},["player2"]={},["player3"]={}}
--商城物品初始列表
global_var_func.shop_item_init = {}
-- 召唤BOSS简单
global_var_func.flag_boss_call_difficulty_1 = global_var_func.flag_boss_call + DOTA_UNIT_TYPE_FLAG_DIFFICULTY_1
-- 召唤BOSS中等
global_var_func.flag_boss_call_difficulty_2 = global_var_func.flag_boss_call + DOTA_UNIT_TYPE_FLAG_DIFFICULTY_2
-- 召唤BOSS困难
global_var_func.flag_boss_call_difficulty_3 = global_var_func.flag_boss_call + DOTA_UNIT_TYPE_FLAG_DIFFICULTY_3
-- 天赋BOSS
global_var_func.flag_boss_talent = DOTA_UNIT_TYPE_FLAG_BOSS + DOTA_UNIT_TYPE_FLAG_OPERATION + DOTA_UNIT_TYPE_FLAG_TALENT

--伤害标记
--魔法暴击
DOTA_DAMAGE_FLAG_MAGIC_CRIT = 1024

-- <==============================xxxxx================================>
MAXIMUM_ATTACK_SPEED = 700              -- What should we use for the maximum attack speed?
MINIMUM_ATTACK_SPEED = 20               -- What should we use for the minimum attack speed?

--服务器补偿内容
global_var_func.compensation = {
    { 
        ["score"] = 100000,
    },
    { 
        ["score"] = 100000,
    },
    { 
        ["score"] = 100000,
    },
    { 
        ["score"] = 100000,
    },
    { 
        ["score"] = 100000,
    },
    { 
        ["score"] = 100000,
    },
    -- { 
    --     ["newyear_bag"] = 10,
    -- },
}

--金砖商店物品
-- global_var_func.custom_shop_item = {
--     { "item_custom_gold_rod_0" },
--     { "item_custom_gold_rod_1" },
--     { "item_custom_gold_rod_2" },
--     { "item_custom_gold_rod_3" },
--     { "item_custom_gold_call" },
--     { "item_custom_yanmo_call" },
--     { "item_custom_ore_call" },
--     { "item_wudi_small" },
--     { "item_wudi_big" },
--     { "item_cancer_call" },
--     {"item_noItem_baoWu_book"},
-- }

-- --金币商店
-- global_var_func.custom_gold_shop_item = {
--     {"item_book_passive_d"},
--     {"item_book_initiative_d"},
--     {"item_book_passive_c"},
--     {"item_book_initiative_c"},
--     {"item_book_passive_b"},
--     {"item_book_initiative_b"},
--     {"item_book_passive_a"},
--     {"item_book_initiative_a"},
--     {"item_blue_bottle_small"},
--     {"item_red_bottle_small"},
--     {"item_blue_bottle_large"},
--     {"item_red_bottle_large"},
-- }

--商店物品
global_var_func.custom_shop_item = {
    "item_book_passive_d",
    "item_book_initiative_d",
    "item_book_passive_c",
    "item_book_initiative_c",
    "item_book_passive_b",
    "item_book_initiative_b",
    "item_book_passive_a",
    "item_book_initiative_a",
    "item_custom_gold_rod_0" ,
    "item_custom_gold_rod_1" ,
    "item_custom_gold_rod_2" ,
    "item_custom_gold_rod_3" ,
    "item_custom_gold_call" ,
    "item_custom_yanmo_call" ,
    "item_custom_ore_call" ,
    "item_cancer_call" ,
    "item_blue_bottle_small",
    "item_red_bottle_small",
    "item_blue_bottle_large",
    "item_red_bottle_large",
    "item_wudi_small" ,
    "item_wudi_big" ,
    "item_noItem_baoWu_book",
}

--菜单按钮
global_var_func.menu_list = {
    "menu_buff",
    "menu_vip",
    "menu_bead",
}

global_var_func.menu_body_data = {
    ["menu_bead"]={"bead_1","bead_2","bead_3","bead_4","bead_5","bead_6","bead_7",},
    ["menu_vip"]={"VIP_A","VIP_B","VIP_C","VIP_S",},
    ["menu_buff"]={},
}

-- <==============================全局函数================================>
function count_unit_table_num()
    local count = 0
    for _, value in pairs(global_var_func.unit_table) do
        if not value:IsNull() then
            count = count + 1 
        end
    end
    return count
end

-- 获取玩家杀敌数
function getplayerkillnumber(playerID)
    if playerID==0 then
        return #global_var_func.player_0_kill_count
    elseif playerID==1 then
        return #global_var_func.player_1_kill_count
    elseif playerID==2 then
        return #global_var_func.player_2_kill_count
    else
        return #global_var_func.player_3_kill_count
    end
end

function add_spawn_all_unit_count()
    table.insert(global_var_func.spawn_all_unit_count, 1)
end

function add_player_kill_count(player_id)
    if tostring(player_id) == "0" then
        table.insert(global_var_func.player_0_kill_count, 1)
    elseif tostring(player_id) == "1" then
        table.insert(global_var_func.player_1_kill_count, 1)
    elseif tostring(player_id) == "2" then
        table.insert(global_var_func.player_2_kill_count, 1)
    elseif tostring(player_id) == "3" then
        table.insert(global_var_func.player_3_kill_count, 1)
    end
end

function add_player_current_count(player_id)
    if tostring(player_id) == "0" then
        table.insert(global_var_func.player_0_current_count, 1)
    elseif tostring(player_id) == "1" then
        table.insert(global_var_func.player_1_current_count, 1)
    elseif tostring(player_id) == "2" then
        table.insert(global_var_func.player_2_current_count, 1)
    elseif tostring(player_id) == "3" then
        table.insert(global_var_func.player_3_current_count, 1)
    end
end

function del_player_current_count(player_id)
    if tostring(player_id) == "0" then
        table.remove(global_var_func.player_0_current_count)
    elseif tostring(player_id) == "1" then
        table.remove(global_var_func.player_1_current_count)
    elseif tostring(player_id) == "2" then
        table.remove(global_var_func.player_2_current_count)
    elseif tostring(player_id) == "3" then
        table.remove(global_var_func.player_3_current_count)
    end
end

function global_var_func:GloFunc_Getgame_enum()
    return game_enum
end

function global_var_func:gethero_index_by_name(heroname)
    for key, value in pairs(CustomHeroList) do
        if value == heroname then
            return key
        end
    end
    return nil
end

function global_var_func:get_rand_hero_list()
    local hero_list = {}

    local temp_hero = {}
    for key, value in ipairs(CustomHeroList) do
        table.insert(temp_hero, value)
    end
    local rand_inde = RandomInt(1, #temp_hero)
    table.insert(hero_list, temp_hero[rand_inde])
    table.remove(temp_hero,rand_inde)
    rand_inde = RandomInt(1, #temp_hero)
    table.insert(hero_list, temp_hero[rand_inde])
    table.remove(temp_hero,rand_inde)
    rand_inde = RandomInt(1, #temp_hero)
    table.insert(hero_list, temp_hero[rand_inde])

    -- table.insert(hero_list, "npc_dota_hero_phoenix")
    -- table.insert(hero_list, "npc_dota_hero_alchemist")
    -- table.insert(hero_list, "npc_dota_hero_keeper_of_the_light")

    return hero_list
end

function global_var_func:get_hero_ability()
    return CustomHeroAbilityList
end

-------------------------------- 工具类函数-------------------------------------
-- 按照 delimiter 的字符进行字符串分割,返回table
function split(input, delimiter)
    input = tostring(input)
    delimiter = tostring(delimiter)
    if (delimiter=='') then return false end
    local pos,arr = 0, {}
    -- for each divider found
    for st,sp in function() return string.find(input, delimiter, pos, true) end do
        table.insert(arr, tonumber(string.sub(input, pos, st - 1)))
        pos = sp + 1
    end
    table.insert(arr, tonumber(string.sub(input, pos)))
    return arr
end

function table_tostring(table)
    local string = ""
    for i = 1, #table do
        string = string..tostring(table[i])..","
    end
    return string
end

local filter_str = ">>>>"
-- 打印
function deep_log(table)
    print(filter_str.."==================================================")
    if table ~=nil then
        for key, value in pairs(table) do
            print(filter_str, key, value)
        end 
    end
    print(filter_str.."==================================================")
end

-- 聊天框打印
function send_msg(table)
    GameRules:SendCustomMessage("=============================================", DOTA_TEAM_GOODGUYS, 0)
    if table ~=nil then 
        for key, value in pairs(table) do
            GameRules:SendCustomMessage(key..filter_str..value, DOTA_TEAM_GOODGUYS, 0)
        end
    end
    GameRules:SendCustomMessage("=============================================", DOTA_TEAM_GOODGUYS, 0)
end

-- table拷贝
function deepcopy(orig)
    local orig_type = type(orig)
    local copy
    if orig_type == 'table' then
        copy = {}
        for orig_key, orig_value in next, orig, nil do
            copy[deepcopy(orig_key)] = deepcopy(orig_value)
        end
        setmetatable(copy, deepcopy(getmetatable(orig)))
    else -- number, string, boolean, etc
        copy = orig
    end
    return copy
end

-- 击杀怪物特效
function killuniteffect(hero, killed_unit, distance, time)
    -- if hero and not hero:IsNull() and hero:IsAlive() and not hero:IsChanneling() and not hero:IsMoving() and hero:IsAttacking() then
    --     hero:MoveToPosition(hero:GetOrigin())
    -- end
    -- local movecount = 0
    -- killed_unit:SetContextThink(DoUniqueString("killmove"), function ()
    --     if movecount >=time*100 then
    --         return nil
    --     end
    --     movecount = movecount + 1
        local direction = GetDirection2D(hero:GetOrigin(), killed_unit:GetOrigin())
        -- local next_pos = GetGroundPosition(killed_unit:GetOrigin() - direction * (distance/(time*100)), killed_unit)
        local next_pos = GetGroundPosition(killed_unit:GetOrigin() - direction * distance, killed_unit)
        killed_unit:SetOrigin(next_pos)
        -- return time/(time*100)
    -- end, 0)
end

function CopyUnit(unit)
    local new_unit =  CreateUnitByName(unit:GetUnitName(), unit:GetOrigin(), true, nil,nil, unit:GetTeam())
    new_unit:SetBaseMaxHealth(unit:GetBaseMaxHealth())
    new_unit:SetMaxHealth(unit:GetMaxHealth())
    new_unit:SetHealth(unit:GetHealth())
    new_unit:SetBaseDamageMax(unit:GetBaseDamageMax())
    new_unit:SetBaseDamageMin(unit:GetBaseDamageMin())
    new_unit:SetMana(unit:GetMana())
    new_unit:SetMaxMana(unit:GetMaxMana())
    new_unit:SetPhysicalArmorBaseValue(unit:GetPhysicalArmorBaseValue())
    new_unit:SetBaseMagicalResistanceValue(unit:GetMagicalArmorValue())
    new_unit:SetBaseHealthRegen(unit:GetHealthRegen())
    new_unit:SetBaseManaRegen(unit:GetManaRegen())
    new_unit:SetBaseMoveSpeed(unit:GetBaseMoveSpeed())
    return new_unit
end

-- 冠军组合ID
global_var_func.championgroup = {
    -- playerid1, playerid2, playerid3,
}
-- 冠军组合已添加数量
global_var_func.championgroupnumber = 0

-- 给场上所有的贪财哥布林发奖金
function give_premium()
    for i = 0, 3 do
        if PlayerResource:GetConnectionState(i) == DOTA_CONNECTION_STATE_CONNECTED  then
            local hero = PlayerResource:GetPlayer(i):GetAssignedHero()
            if hero and not hero:IsNull() and hero:FindAbilityByName("sublime_tancai_lua") then
                game_playerinfo:set_player_gold(i, game_playerinfo:get_player_gold(i)*0.1)
            end 
        end
    end
end

-- 创建和本局怪一样的单位, 第二参数为几率,生成精英怪
function createcommonunit(playerID, odds)
    if not odds then
        odds = 0
    end
    local player = PlayerResource:GetPlayer(playerID)
    local hero = player:GetAssignedHero()
    -- local postion = Vector(hero:GetOrigin().x + 100, hero:GetOrigin().y, hero:GetOrigin().z)
    local unit = CreateUnitByName(rule_unit_spawn:RandomCreepName(), hero:GetOrigin(), true, hero,player, DOTA_TEAM_GOODGUYS)
    rule_unit_spawn: SetCreepBaseValue(unit)
    rule_unit_spawn: GameDifficultyBounty(unit)
    rule_unit_spawn: GrowsElite(unit)
    rule_unit_spawn: SetCancerBounty(unit)

    if RollPercentage(odds) then
        rule_unit_spawn: CreateGrowsElite (unit)
    end
    unit:AddNewModifier(nil,nil,"modifier_kill_self",{duration = 20})
    FindClearSpaceForUnit(unit, hero:GetOrigin(), true)
end

function CheckBackBagIsFull(player_id)
    local hero = PlayerResource:GetPlayer(player_id):GetAssignedHero()
    for i = 0, 8 do
        local item = hero:GetItemInSlot(i)
        -- print(item:GetItemName())
    end
end

local build_name = {
    "company_build_1",
    "company_build_2",
    "company_build_3",
}
-- 根据随机名称创建一个建筑单位
function createbuild(playerID)
    local player = PlayerResource:GetPlayer(playerID)
    local hero = player:GetAssignedHero()
    local randomindex = RandomInt(1,#build_name)
    -- local postion = Vector(hero:GetOrigin().x + 100, hero:GetOrigin().y, hero:GetOrigin().z)
    local unit = CreateUnitByName(build_name[randomindex], hero:GetOrigin(), true, hero,player, DOTA_TEAM_GOODGUYS)
    unit:SetOwner(hero)
    FindClearSpaceForUnit(unit, hero:GetOrigin(), true)

    return unit
end

--英雄穿戴饰品
function WearForHero(params,hero)
    hero.wear_table = {}
    for _,v in pairs(params) do 
        local item = SpawnEntityFromTableSynchronous("prop_dynamic", {model =v})
        if item then
            item:FollowEntity(hero, true)
            table.insert(hero.wear_table,item)
        end
    end
end

--当前存活英雄数量
function GetOtherHeroAliveCount(except)
    local count = 0
    local hero_table = {}
    for _, hero in pairs(HeroList:GetAllHeroes()) do
        if hero:IsAlive() and hero ~= except then
            count = count + 1
            table.insert(hero_table, hero)
        end
    end
    return count, hero_table
end

-- 设置英雄的基础力量
function SetBaseStrength(hero, value)
    if value > 0 then
        local scale = 1
        local treasure = hero:FindModifierByName("modifier_treasure_nuyi")
        if treasure then
            -- 如果拥有"怒意"的宝物,则获取属性减半
            scale = scale - 0.5
        end
        treasure = hero:FindModifierByName("modifier_treasure_decay_mana")
        if treasure then
            -- 如果拥有"腐蚀圣剑"的宝物,则获取属性减半
            scale = scale - 0.5
        end
        treasure = hero:FindModifierByName("modifier_treasure_ra_1")
        if treasure then
            -- 如果拥有"腐蚀圣剑"的宝物,则获取属性减半
            scale = scale + 0.12
        end
        treasure = hero:FindModifierByName("modifier_treasure_ra_2")
        if treasure then
            -- 如果拥有"腐蚀圣剑"的宝物,则获取属性减半
            scale = scale + 0.15
        end
        treasure = hero:FindModifierByName("modifier_treasure_ra_3")
        if treasure then
            -- 如果拥有"腐蚀圣剑"的宝物,则获取属性减半
            scale = scale + 0.18
        end
        if scale < 0 then
            scale = 0
        end
        value = value * scale
    end
    hero:SetBaseStrength(hero:GetBaseStrength() + value)
end

-- 设置英雄的基础敏捷
function SetBaseAgility(hero, value)
    if value > 0 then
        local scale = 1
        local treasure = hero:FindModifierByName("modifier_treasure_nuyi")
        if treasure then
            -- 如果拥有"怒意"的宝物,则获取属性减半
            scale = scale - 0.5
        end
        treasure = hero:FindModifierByName("modifier_treasure_decay_mana")
        if treasure then
            -- 如果拥有"腐蚀圣剑"的宝物,则获取属性减半
            scale = scale - 0.5
        end
        treasure = hero:FindModifierByName("modifier_treasure_ra_1")
        if treasure then
            -- 如果拥有"腐蚀圣剑"的宝物,则获取属性减半
            scale = scale + 0.12
        end
        treasure = hero:FindModifierByName("modifier_treasure_ra_2")
        if treasure then
            -- 如果拥有"腐蚀圣剑"的宝物,则获取属性减半
            scale = scale + 0.15
        end
        treasure = hero:FindModifierByName("modifier_treasure_ra_3")
        if treasure then
            -- 如果拥有"腐蚀圣剑"的宝物,则获取属性减半
            scale = scale + 0.18
        end
        if scale < 0 then
            scale = 0
        end
        value = value * scale
    end
    hero:SetBaseAgility(hero:GetBaseAgility() + value)
end

-- 设置英雄的基础智力
function SetBaseIntellect(hero, value)
    if value > 0 then
        local scale = 1
        local treasure = hero:FindModifierByName("modifier_treasure_nuyi")
        if treasure then
            -- 如果拥有"怒意"的宝物,则获取属性减半
            scale = scale - 0.5
        end
        treasure = hero:FindModifierByName("modifier_treasure_decay_mana")
        if treasure then
            -- 如果拥有"腐蚀圣剑"的宝物,则获取属性减半
            scale = scale - 0.5
        end
        treasure = hero:FindModifierByName("modifier_treasure_ra_1")
        if treasure then
            -- 如果拥有"腐蚀圣剑"的宝物,则获取属性减半
            scale = scale + 0.12
        end
        treasure = hero:FindModifierByName("modifier_treasure_ra_2")
        if treasure then
            -- 如果拥有"腐蚀圣剑"的宝物,则获取属性减半
            scale = scale + 0.15
        end
        treasure = hero:FindModifierByName("modifier_treasure_ra_3")
        if treasure then
            -- 如果拥有"腐蚀圣剑"的宝物,则获取属性减半
            scale = scale + 0.18
        end
        if scale < 0 then
            scale = 0
        end
        value = value * scale
    end
    hero:SetBaseIntellect(hero:GetBaseIntellect() + value)
end

-- 宝物弹窗(treasure_number表示可选择标物数量)
function OpenTreasureWindow(PlayerID, treasure_number)
    -- 默认可选宝物为三个
    if not treasure_number then
        treasure_number = 3
    end
    
    treasure_number = treasure_number + game_playerinfo:get_dynamic_properties_by_key(PlayerResource:GetSteamAccountID(PlayerID), "extra_treasure_select")
    global_var_func.treasure_round[PlayerID + 1] = game_playerinfo:get_player_treasure_round(PlayerID) + 1
    local treasure_select_tab = treasuresystem:get_averagerandomtreasures(PlayerID, treasure_number)
    treasuresystem:setplayer_round_treasures(PlayerID, treasure_select_tab)
    local send_tab = {}
    local hero = PlayerResource:GetPlayer(PlayerID):GetAssignedHero()
    if #treasure_select_tab > 0 then
        if not hero:FindModifierByName("modifier_treasure_angel_gift") then
            for i = 1, #treasure_select_tab do
                local temp_tab = {}
                local quality = treasuresystem:get_treasure_quality(treasuresystem:get_treasure_id(treasure_select_tab[i]))
                table.insert(temp_tab, treasure_select_tab[i])
                table.insert(temp_tab, quality)
    
                table.insert(send_tab, temp_tab)
            end
        else
            for i = 1, treasure_number do
                local temp_tab = {}
                local quality = "N"
                table.insert(temp_tab, "modifier_treasure_unknown")
                table.insert(temp_tab, quality)
    
                table.insert(send_tab, temp_tab)
            end
        end
    end
	CustomGameEventManager:Send_ServerToPlayer(PlayerResource:GetPlayer(PlayerID),"show_treasure_select", send_tab)
end

-- 添加物品
function AddItemByName(hero, name)
    local item = hero:AddItemByName(name)
    if not item then
        item = CreateItem(name,nil,nil)
        CreateItemOnPositionForLaunch(hero:GetOrigin()+RandomVector(150),item)
    end
    return item
end

-- 是否是我击杀的敌人
function IsMyKilledBadGuys(hero, params)
    if params.unit:GetTeamNumber() ~= DOTA_TEAM_BADGUYS then
        return false
    end
    local attacker = params.attacker
    if hero == attacker then
        return true
    else
        if hero == attacker:GetOwner() then
            return true
        else
            return false
        end
    end
end

-- 创建任务NPC
function CreateTaskNpc(playerId, NpcName, beginpoint, endpoint)
    local name = NpcName
    local start_position = beginpoint
    -- local temp_player_id = playerId + 2
    -- if temp_player_id > 3 then
    --     temp_player_id = temp_player_id - 4
    -- end
    local end_position = endpoint
    local hero = PlayerResource:GetPlayer(playerId):GetAssignedHero()
    local unit = CreateUnitByName(name, start_position, true, nil, nil, DOTA_TEAM_GOODGUYS)
    unit:SetOwner(hero)
    -- unit:SetControllableByPlayer(playerId, false)
    -- table.insert(temp_unit_table, unit)
    unit.independ = true  -- 独立运动轨迹

    -- 添加相位效果,重新计算碰撞体积
    unit: AddNewModifier(nil, nil, "modifier_phased", {duration = 3})
    
    unit:SetBaseMaxHealth((5000 + global_var_func.current_round*1000))
    unit:SetMaxHealth((5000 + global_var_func.current_round*1000))
    unit:SetHealth((5000 + global_var_func.current_round*1000))
    
    FindClearSpaceForUnit(unit, start_position, true)
    -- print(" >>>>>>>start_position: "..unit:GetOrigin().x)
    -- print(" >>>>>>>start_position: "..unit:GetOrigin().y)
    -- print(" >>>>>>>start_position: "..unit:GetOrigin().z)
    
    -- print(" >>>>>>>end_position: "..end_position.x)
    -- print(" >>>>>>>end_position: "..end_position.y)
    -- print(" >>>>>>>end_position: "..end_position.z)
    unit:AddNewModifier(unit, nil, "modifier_unit_move_to_point", {endx = end_position.x, endy = end_position.y, endz = end_position.z})
    -- unit: MoveToPosition(end_position)
    return unit
end

-- 是否是指定单位击杀的敌方单位
function IsMyKilledBadGuys(hero, params)
    if params.unit:GetTeamNumber() ~= DOTA_TEAM_BADGUYS then
        return false
    end
    local attacker = params.attacker
    if hero == attacker then
        return true
    else
        if hero == attacker:GetOwner() then
            return true
        else
            return false
        end
    end
end

-- 是否是晚上
function IsNight()
    local temp = GameRules:GetTimeOfDay()
    -- 相当于是早上6点到晚上6点
    if temp > 0.25 and temp <= 0.75 then
        return false
    else
        return true
    end
end

-- 给英雄添加宝物
function AddTreasureForHero(hero, treasurename, params)
    local Tindex = treasuresystem:get_treasure_id(treasurename)
    if not Tindex then
        local quality = treasuresystem:get_treasure_quality(Tindex)
        if quality then
            -- body
            hero:AddNewModifier(hero, nil, "modifier_show_box_lua", {duration = 3, quality = quality})
        end
    end
    
    game_playerinfo:inster_treasure_name(hero:GetPlayerID(), treasurename)
    hero:AddNewModifier(hero, nil, treasurename, params)
end

-- 给英雄添加对应品质的随机宝物
function AddTreasureForHeroByquality(hero, quality, params)
    -- local treasurindex = treasuresystem:get_treasure_id(treasurename)
    -- if not treasurindex then
    --     return false
    -- end
    -- if not treasuresystem:find_treasureinarchive_byID(hero:GetPlayerID(), treasurindex) then
    --     return false
    -- end
    local send_table = treasuresystem:get_randomtreasures_byquality(hero:GetPlayerID(), quality, 1)
    if treasuresystem:remove_treasures_byquality(hero:GetPlayerID(), quality, send_table[1]) then
        AddTreasureForHero(hero, send_table[1], params)
    end
end

-- 移除英雄宝物
function DeleteTreasureForHero(hero, treasurename)
    local treasurindex = treasuresystem:get_treasure_id(treasurename)
    if not treasurindex then
        return false
    end
    if hero:FindModifierByName(treasurename) then
        game_playerinfo:remove_treasure_name(hero:GetPlayerID(), treasurename)
        hero:RemoveModifierByName(treasurename)
    end
    for i = 1, global_var_func.all_player_amount do
        local hero = PlayerResource:GetPlayer(i-1):GetAssignedHero()
        if hero:FindModifierByName("modifier_treasure_spy") then
            -- 玩家是内鬼
            local lastquality = treasuresystem:get_treasure_quality(treasurindex)
            if lastquality == "SSR" then
                AddTreasureForHeroByquality(hero, "SR", {})
            elseif lastquality == "SR" then
                AddTreasureForHeroByquality(hero, "R", {})
            else
                AddTreasureForHeroByquality(hero, "N", {})
            end
        end
    end
end

-- 计算2个单位面向,返回单位面向角度
function CalculationAngle(attacker, target)
    local attacker_forward = attacker:GetForwardVector()
    local target_forward = target:GetForwardVector()

    local unit_angle = math.abs(AngleDiff(VectorToAngles(attacker_forward).y, VectorToAngles(target_forward).y))

    return unit_angle
end

-- 召唤技能及其召唤单位映射表
local call_ability = {
    {"call_diyuhuo","diyuhuo"},
    {"call_shebang","shebang"},
    {"call_daniu","daniu"},
    {"call_huojian","huojiandan"},
    {"call_bear","bear_xss"},
    {"call_xiaozhuzai","xiaozhuzai"},
    {"didong","shouren_didong"},
}
function CallAbilityContain(ability_name)
    for key, value in pairs(call_ability) do
        if string.find(ability_name, value[1]) then
            return value
        end
    end
    return nil
end

function RandomCreepAbility()
    return table.remove(config_creep_ability, RandomInt(1, #config_creep_ability))
end

function RandomWitchAbility()
    return table.remove(config_witch_ability, RandomInt(1, #config_witch_ability))
end

-- 发送结算数据
function sendresult(is_winner, gameTime, sendprize_list)
    local settlement_data = {}
    
    local playerCount = global_var_func.all_player_amount
    for i= 0 ,playerCount-1 do 
        local steamid = PlayerResource:GetSteamAccountID(i);
        if steamid then
            local game_settle_data = game_playerinfo:get_player_result(steamid)
            local heroLevel = game_settle_data["heroLevel"]
            local crt_level_exp = game_playerinfo:get_need_exp(heroLevel)
            local next_level_exp = game_playerinfo:get_need_exp(heroLevel+1)
            game_settle_data["up_level_exp"] = next_level_exp - crt_level_exp
            game_settle_data["crt_level_exp"] =  crt_level_exp

            local mapLevel = game_settle_data["mapLevel"]
            local crt_map_exp = game_playerinfo:get_need_exp(mapLevel)
            local next_map_exp = game_playerinfo:get_need_exp(mapLevel+1)
            game_settle_data["up_map_exp"] = next_map_exp - crt_map_exp
            game_settle_data["crt_map_exp"] =  crt_map_exp
            game_settle_data["score"] = game_settle_data["score"]

            -- 杀敌数
            game_settle_data["kill_number"] = getplayerkillnumber(i)
            -- 伤害量
            game_settle_data["damage"] = (game_playerinfo:get_player_damage(i) or 0)
            -- 总经济
            game_settle_data["gold_gain"] = game_playerinfo:getplayer_gold_gain(i)

            settlement_data["player_"..i] = game_settle_data

        end
    end
    settlement_data["isWinner"] = is_winner
    settlement_data["gameTime"] = gameTime
    CustomGameEventManager:Send_ServerToAllClients("show_game_over_panel",{settlement_data = settlement_data, sendprize_list = sendprize_list})
end

function IsFinalRound()
    return global_var_func.last_time <= global_var_func.round_interval
end

function IsFinalSecondRound()
    return global_var_func.last_time <= global_var_func.round_interval * 2
end

function IsBossRound()
    if math.fmod(global_var_func.current_round, global_var_func.spawn_boss_round_interval) == 0 then
        return math.floor(global_var_func.current_round / global_var_func.spawn_boss_round_interval)
    end
    return nil
end

function SetUnitBaseValue(unit)
    local name = unit:GetUnitName()
    local damage = nil
    local hp = nil
    local armor = nil
    local resistance = nil
    local xp = nil
    local gold = nil
    local elite_scale_damage = 1
    local elite_scale_hp = 1
    if string.find("creep_zombie,creep_skeleton,creep_troll,creep_witcher", name) then
        local cancer_scale = (global_var_func.task_call_count_log[tostring(unit.player_id)]["cancer"] * 0.15 + 1)
        local overload_scale = (100 + global_var_func.overload_data[tostring(global_var_func.overload_record[unit.player_id + 1])]["outgo"]["overload_outgo_hp"]) / 100
        local damage_scale = 1 + (GameRules:GetCustomGameDifficulty() - 1) * 2
        local hp_scale = 1
        if GameRules:GetCustomGameDifficulty() <= 5 then
            hp_scale = 2 + (GameRules:GetCustomGameDifficulty() - 1) * 1.3 * (1 + (GameRules:GetCustomGameDifficulty() - 1) * 0.4)
        elseif GameRules:GetCustomGameDifficulty() <= 7 then
            hp_scale = 2 + (GameRules:GetCustomGameDifficulty() - 1) * 4
        else
            hp_scale = 2 + (GameRules:GetCustomGameDifficulty() - 1) * 6
        end
        if RollPercentage(global_var_func.elite_scale) then
            AppendUnitTypeFlag(unit, DOTA_UNIT_TYPE_FLAG_ELITE)
            unit:SetModelScale(unit:GetModelScale() * 1.7)
            elite_scale_damage = 3
            elite_scale_hp = 6
            if GameRules:GetCustomGameDifficulty() >= global_var_func.show_elite_level then
                AppendUnitTypeFlag(unit, DOTA_UNIT_TYPE_FLAG_AURA)
                unit:AddAbility(config_creep_aura[RandomInt(1, #config_creep_aura)]):SetLevel(1)
            end
        end
        local bounty_damage = 0
        local bounty_hp = 0
        if name == "creep_zombie" then
            if global_var_func.current_round > 8 and global_var_func.current_round <= 15 then
                bounty_damage = 30
                bounty_hp = 1000
            elseif global_var_func.current_round > 15 and global_var_func.current_round <= 22 then
                bounty_damage = 60
                bounty_hp = 8000
            elseif global_var_func.current_round > 22 and global_var_func.current_round <= 27 then
                bounty_damage = 200
                bounty_hp = 30000
            elseif global_var_func.current_round > 27 then
                bounty_damage = 660
                bounty_hp = 100000
            end
            damage = (1 + 2 * global_var_func.current_round + bounty_damage) * elite_scale_damage * damage_scale * cancer_scale
            hp = (2 + 80 * global_var_func.current_round + bounty_hp) * elite_scale_hp * hp_scale * cancer_scale * overload_scale
        elseif name == "creep_skeleton" then
            if global_var_func.current_round > 8 and global_var_func.current_round <= 15 then
                bounty_damage = 45
                bounty_hp = 1000
            elseif global_var_func.current_round > 15 and global_var_func.current_round <= 22 then
                bounty_damage = 135
                bounty_hp = 6500
            elseif global_var_func.current_round > 22 and global_var_func.current_round <= 27 then
                bounty_damage = 270
                bounty_hp = 20000
            elseif global_var_func.current_round > 27 then
                bounty_damage = 900
                bounty_hp = 90000
            end
            damage = (1 + 3 * global_var_func.current_round + bounty_damage) * elite_scale_damage * damage_scale * cancer_scale
            hp = (1 + 60 * global_var_func.current_round + bounty_hp) * elite_scale_hp * hp_scale * cancer_scale * overload_scale
        elseif name == "creep_troll" then
            if global_var_func.current_round > 8 and global_var_func.current_round <= 15 then
                bounty_damage = 45
                bounty_hp = 1000
            elseif global_var_func.current_round > 15 and global_var_func.current_round <= 22 then
                bounty_damage = 135
                bounty_hp = 6500
            elseif global_var_func.current_round > 22 and global_var_func.current_round <= 27 then
                bounty_damage = 270
                bounty_hp = 20000
            elseif global_var_func.current_round > 27 then
                bounty_damage = 1200
                bounty_hp = 90000
            end
            damage = (2 + 4 * global_var_func.current_round + bounty_damage) * elite_scale_damage * damage_scale * cancer_scale
            hp = (1 + 60 * global_var_func.current_round + bounty_hp) * elite_scale_hp * hp_scale * cancer_scale * overload_scale
        elseif name == "creep_witcher" then
            if global_var_func.current_round >= 10 then
                bounty_damage = (global_var_func.current_round - 10) * 4 + 100
                bounty_hp = (global_var_func.current_round - 10) * 80
                if global_var_func.current_round >= 10 and global_var_func.current_round < 20 then
                    bounty_hp = bounty_hp + 1500
                elseif global_var_func.current_round >= 20 and global_var_func.current_round < 28 then
                    bounty_damage = bounty_damage + 200
                    bounty_hp = bounty_hp + 10000
                elseif global_var_func.current_round >= 28 then
                    bounty_damage = bounty_damage + 1200
                    bounty_hp = bounty_hp + 40000
                end
            end
            damage = bounty_damage * elite_scale_damage * damage_scale * cancer_scale
            hp = bounty_hp * elite_scale_hp * hp_scale * cancer_scale * overload_scale
        end
        xp = 15
        gold = 15
        resistance = CalculateResistance()
    elseif string.find("boss_sand_king,boss_undying,boss_lich,boss_medusa,boss_tiny,boss_wraith_king", name) then
        AppendUnitTypeFlag(unit, DOTA_UNIT_TYPE_FLAG_ABILITY)
        unit:AddAbility("passive_hit_fly"):SetLevel(1)
        local round = IsBossRound()
        gold = 5000 + 2500 * (round - 1)
        local damage_scale = 1 + (GameRules:GetCustomGameDifficulty() - 1) * 4
        local hp_scale = 2 + (GameRules:GetCustomGameDifficulty() - 1) * 5
        if name == "boss_undying" then
            hp_scale = 2 + (GameRules:GetCustomGameDifficulty() - 1) * 2.5
        end
        if round == 1 then
            damage = 100 * damage_scale
            hp = 20000 * hp_scale
        elseif round == 2 then
            damage = 400 * damage_scale
            hp = 10000 * hp_scale
        elseif round == 3 then
            damage = 700 * damage_scale
            hp = 200000 * hp_scale
        elseif round == 4 then
            damage = 1000 * damage_scale
            hp = 400000 * hp_scale
        elseif round == 5 then
            damage = 1500 * damage_scale
            hp = 800000 * hp_scale
        elseif round == 6 then
            damage = 2800 * damage_scale
            hp = 1200000 * hp_scale
        end
        armor = 5
        resistance = CalculateResistance()
    elseif name == "boss_finally" then
        damage = 19500 * (1 + GameRules:GetCustomGameDifficulty() * 0.4)
        hp = 5000000 * global_var_func.all_player_amount * (1 + (GameRules:GetCustomGameDifficulty() - 1) * 0.2)
    elseif name == "task_smith" then
        damage = 200 * math.pow(5, unit.item_level - 1)
        hp = 10000 * math.pow(10, unit.item_level - 1)
    elseif name == "task_coin" then
        local count = global_var_func.task_call_count_log[tostring(unit.player_id)]["task_coin"]
        damage = 50 * math.pow(2, count - 1)
        hp = 3000 * math.pow(2.5, count - 1)
        gold = 200 + 60 * (count - 1)
    elseif name == "task_golem" then
        local record = global_var_func.task_call_count_log[tostring(unit.player_id)]["task_golem"]
        damage = 1000 * math.pow(2, record - 1)
        hp = 50000 * math.pow(3, record - 1)
        armor = 20
        resistance = CalculateResistance()
    elseif name == "task_talent" then
        local record = global_var_func.task_call_count_log[tostring(unit.player_id)]["task_talent"]
        damage = 20000 * ((record - 1) * 5 + 1)
        hp = 5000000 * ((record - 1) * 5 + 1)
        armor = 30
    elseif name == "task_box" then
        local count = global_var_func.task_call_count_log[tostring(unit.player_id)]["task_box"]
        hp = 25000 * math.pow(3, count - 1)
        gold = 6666
    elseif string.find(name, "boss_call_") then
        local temp = CalculateCallBoseValue(unit.difficulty, global_var_func.call_boss_record[unit.player_id + 1] + 1)
        damage = temp[1]
        hp = temp[2]
        armor = temp[3]
        resistance = CalculateResistance()
    end
    if damage then
        unit: SetBaseDamageMin(damage)
        unit: SetBaseDamageMax(damage)
        unit: SetBaseMaxHealth(damage)
    end
    if hp then
        if hp > 21 * 10000 * 10000 then
            hp = 21 * 10000 * 10000
        end
        unit: SetBaseMaxHealth(hp)
        unit: SetMaxHealth(hp)
        unit: SetHealth(hp)
    end
    if armor then
        unit: SetPhysicalArmorBaseValue(armor)
    end
    if resistance then
        unit: SetBaseMagicalResistanceValue(resistance)
    end
    if xp then
        unit: SetDeathXP(xp)
    end
    if unit.player_id and global_var_func.intimidate[unit.player_id + 1] then
        if gold then
            gold = gold + 25
        else
            gold = 25
        end
    end
    if gold then
        unit: SetMinimumGoldBounty(gold)
        unit: SetMaximumGoldBounty(gold)
    end
end

function CalculateCallBoseValue(difficulty, next_record)
    local temp = {}
    local damage = 0
    local hp = 0
    local armor = 0
    if difficulty == 1 then
        damage = 100
        hp = 5000
        armor = 10
    elseif difficulty == 2 then
        damage = 500
        hp = 50000
        armor = 20
    elseif difficulty == 3 then
        damage = 2500
        hp = 500000
        armor = 30
    end
    table.insert(temp, math.floor(damage * math.pow(2.5, next_record - 1)))
    table.insert(temp, math.floor(hp * math.pow(4, next_record - 1)))
    table.insert(temp, math.floor(armor))
    return temp
end

function CalculateResistance()
    if global_var_func.current_round <= 10 then
        return 0
    elseif global_var_func.current_round >= 11 and global_var_func.current_round <= 19 then
        return 15
    elseif global_var_func.current_round >= 20 and global_var_func.current_round <= 27 then
        return 35
    elseif global_var_func.current_round >= 28 then
        return 55
    end
end

-- 统计怪物上线
function CountDeadLine()
    -- 多个玩家时，每多一个玩家，人口奖励
    -- vip人口奖励
    local vip_bouns = 0
    local count = 0
    for i = 0, 3 do
        if PlayerResource:GetConnectionState(i) == DOTA_CONNECTION_STATE_CONNECTED  then
            count = count + 1
            vip_bouns = vip_bouns + game_playerinfo:get_dynamic_properties(PlayerResource:GetSteamAccountID(i)).max_monster
        end
    end
    if count > 0 then
        count = count - 1
    end
    global_var_func.unit_total = global_var_func.unit_num_base + global_var_func.unit_num_bonus * count + vip_bouns
    return global_var_func.unit_total
end

-- 是否存活
function IsAlive(unit)
    if unit and not unit:IsNull() and unit:IsAlive() then
        return true
    end
    return false
end

-- 玩家是否在线
function OnLine(playerid)
    return PlayerResource:GetConnectionState(playerid) == DOTA_CONNECTION_STATE_CONNECTED
end

-- 刷怪间隔
function SpawnTimeInterval(playerid)
    local bonus = 0
    if GameRules:GetCustomGameDifficulty() > 7 and IsFinalRound() then
        bonus = bonus + 0.1
    end
    bonus = bonus + global_var_func.overload_data[tostring(global_var_func.overload_record[playerid + 1])]["income"]["overload_income_time"]
    return 0.8 - 0.01 * global_var_func.current_round - bonus
end

------------------------------------------- 玩家基础数据 -----------------------------------------
global_var_func.player_base_info = {
    -- [playerid] = {
    --     steam_id = 123123123,
    --     heroname = "123123123",
    -- },
    -- [playerid] = {
    --     steam_id = 123123123,
    --     heroname = "123123123",
    -- },
    -- [playerid] = {
    --     steam_id = 123123123,
    --     heroname = "123123123",
    -- },
}

function init_player_base_info(playerid, steam_id, heroname)
    global_var_func.player_base_info[playerid] = {}
    global_var_func.player_base_info[playerid]["steam_id"] = steam_id
    global_var_func.player_base_info[playerid]["heroname"] = heroname
end