-- 宝物系统

if treasuresystem == nil then
    treasuresystem = class({})
end

-- 玩家当局宝物数量
local player_roundtreasures = 50
-- 阶段停留倒计时
local stay_time = 120
-- 开始倒计时
local gamestart_time = 10
-- 锁定选卡界面的玩家数量
local lock_players = 0
-- 高等宝物上限设置
local SSR_max = 5
local SR_max = 10
local R_max = 15
-- 所有的宝物池
local global_treasures = {
    -- 基础宝物
    {"modifier_treasure_beast_magic","N"},-- 幻兽大师1
    {"modifier_treasure_beasts_royal","N"},-- 御兽大师2
    {"modifier_treasure_red_pill","N"},-- 红色药丸3
    {"modifier_treasure_blue_pill","N"},-- 蓝色药丸4
    {"modifier_treasure_green_pill","N"},-- 绿色药丸5
    {"modifier_treasure_extra_exp","N"},-- 经验加3 6
    {"modifier_treasure_goodbyes","N"},-- 告辞7
    {"modifier_treasure_stone_ghost_mask","N"},--石鬼面具8
    {"modifier_treasure_evil_mask","N"},-- 邪恶面具9
    {"modifier_treasure_risto_vault","N"},-- 瑞斯托王庭金库10
    {"modifier_treasure_beerbung","N"},-- 啤酒桶盖11
    {"modifier_treasure_leviathan_skin","N"},-- 利维坦外壳12
    {"modifier_treasure_blackmail","N"},-- 碰瓷13
    {"modifier_treasure_lost_mirror","N"},-- 遗失之物：残破小镜14
    {"modifier_treasure_holiday_beach_shorts","N"},-- 休假用品：沙滩裤15
    {"modifier_treasure_holiday_aloha_shirt","N"},-- 休假用品：夏威夷衬衫16
    {"modifier_treasure_legion_flag","N"},-- 军团旗帜17
    {"modifier_treasure_legion_drum","N"},-- 军团战鼓18
    {"modifier_treasure_legion_mystique","N"},-- 军团秘法19
    {"modifier_treasure_legion_arcanum","N"},-- 军团秘药20
    {"modifier_treasure_protect_weak","N"},-- 捍卫弱者21
    {"modifier_treasure_feast","N"},-- 盛宴22
    {"modifier_treasure_lost_pen","N"},-- 遗失之物：无墨之笔23
    {"modifier_treasure_lost_stick","N"},-- 遗失之物：折断的拐杖24
    {"modifier_treasure_lost_book","N"},-- 遗失之物：残缺的书籍25
    {"modifier_treasure_lost_knife","N"},-- 遗失之物：生锈的小刀26
    {"modifier_treasure_lost_armor","N"},-- 遗失之物：腐蚀护甲27
    {"modifier_treasure_wile","N"},-- 狡诈计谋28
    {"modifier_treasure_selfish_doctor","N"},-- 自私医师29
    {"modifier_treasure_small_gold_bag","N"},-- 小金袋30
    {"modifier_treasure_risto_heraldry","N"},-- 瑞斯托纹章31
    {"modifier_treasure_sacrificial_wristband","N"},-- 牺牲护腕32
    {"modifier_treasure_emperor_qin","N"},-- 我，秦始皇，打钱33
    {"modifier_treasure_tolerance","N"},-- 隐忍34
    {"modifier_treasure_matrilocal","N"},-- 赘婿35
    {"modifier_treasure_no_number","R"},-- RNM退钱36
    {"modifier_treasure_nuyi","R"},-- 怒意37
    {"modifier_treasure_finally_ability","R"},-- 最后的查克拉38
    {"modifier_treasure_money_power","R"},-- 金钱就是力量39
    {"modifier_treasure_decay_mana","R"},-- 腐朽圣剑40
    {"modifier_treasure_holy_cloak","R"},-- 神圣斗篷41
    {"modifier_treasure_devil_earing","R"},-- 恶魔耳钉42
    {"modifier_treasure_stone_hall_city_spear","R"},-- 石堂城长枪43
    {"modifier_treasure_stone_hall_city_cloak","R"},-- 石堂城斗篷44
    {"modifier_treasure_stone_hall_city_armor","R"},-- 石堂城板甲45
    {"modifier_treasure_devil_transaction","R"},-- 恶魔交易46
    {"modifier_treasure_assassin_secret","R"},-- 刺客秘籍47
    {"modifier_treasure_brave_the_shield","R"},-- 英勇盾牌48
    {"modifier_treasure_aghanim_crystal","R"},-- 阿哈利姆结晶49
    {"modifier_treasure_pot_of_greed","SR"},-- 强欲之壶50

    -- 额外获取宝物
    {"modifier_treasure_wizardry_mask","R"},-- 巫术面具51
    {"modifier_treasure_rapid_bayonet","N"},-- 疾风之刺52
    {"modifier_treasure_rapid_dagger","R"},-- 疾风之匕53
    {"modifier_treasure_rapid_sword","SR"},-- 疾风之剑54
    {"modifier_treasure_titan_armet","N"},-- 泰坦头盔55
    {"modifier_treasure_titan_hammer","R"},-- 泰坦战锤56
    {"modifier_treasure_titan_shield","SR"},-- 泰坦神盾57
    {"modifier_treasure_abyss_orb","N"},-- 深渊宝珠58
    {"modifier_treasure_abyss_sceptre","R"},-- 深渊权杖59
    {"modifier_treasure_abyss_law","SR"},-- 深渊法典60
    {"modifier_treasure_dragon_king_come_back","SSR"},-- 龙王归来61
    {"modifier_treasure_nenglipengzhang","SSR"},-- 能力膨胀62
    {"modifier_treasure_so_long","N"},-- 听说名字取得长的宝物都很厉害63
    {"modifier_treasure_so_short","N"},-- 短64
    {"modifier_treasure_bloodthirster","N"},-- 饮血剑65
    {"modifier_treasure_bloodaxe","R"},-- 饮血斧66
    {"modifier_treasure_bloodknife","SR"},-- 饮血刀67
    {"modifier_treasure_intimidate","N"},-- 恫吓68
    {"modifier_treasure_turbulence_mana","SSR"},-- 法力乱流69
    {"modifier_treasure_five_thousand_exp","R"},-- 5000经验70
    {"modifier_treasure_holiday_beach_slippers","R"},-- 休假用品：沙滩拖鞋71
    {"modifier_treasure_holiday_sunglasses","R"},-- 休假用品：墨镜72
    {"modifier_treasure_holiday_icecola","R"},-- 休假用品：冰可乐73
    {"modifier_treasure_aghanim_scepter","R"},-- 阿哈利姆神杖74
    {"modifier_treasure_three_phase_power_s","R"},-- 三项碎片【上】75
    {"modifier_treasure_three_phase_power_a","R"},-- 三项碎片【中】76
    {"modifier_treasure_three_phase_power_i","R"},-- 三项碎片【下】77
    {"modifier_treasure_apocalypse_a","R"},-- 启示录【上】78
    {"modifier_treasure_apocalypse_b","R"},-- 启示录【中】79
    {"modifier_treasure_apocalypse_c","R"},-- 启示录【下】80

    {"modifier_treasure_taiji_disciples","N"},-- 太极门徒81
    {"modifier_treasure_taiji_intermediate","R"},-- 太极大师82
    {"modifier_treasure_taiji_master","SR"},-- 太极宗师83
    {"modifier_treasure_mhzl","R"},-- 蛮荒之力84
    {"modifier_treasure_ltzl","R"},-- 雷霆之力85
    {"modifier_treasure_xwzl","R"},-- 虚无之力86
    {"modifier_treasure_smallmoney","R"},-- 富二代87
    {"modifier_treasure_mhll","SR"},-- 蛮荒灵力88
    {"modifier_treasure_ltll","SR"},-- 雷霆灵力89
    {"modifier_treasure_xwll","SR"},-- 虚无灵力90
    {"modifier_treasure_moremoney","SR"},-- 大富翁91
    {"modifier_treasure_mhsl","SSR"},-- 蛮荒神力92
    {"modifier_treasure_ltsl","SSR"},-- 雷霆神力93
    {"modifier_treasure_xwsl","SSR"},-- 虚无神力94
    {"modifier_treasure_gfatmoney","SSR"},-- G胖的钱包95

    {"modifier_treasure_back_off_a","R"},-- 手动挡96
    {"modifier_treasure_back_off_b","R"},-- 自动挡97
    {"modifier_treasure_back_off_c","SSR"},-- 请注意,倒车98

    -- 春节新上的卡
    {"modifier_treasure_sublime_alchemist", "SSR"},--土豪升华卡99
    {"modifier_treasure_sublime_omniknight", "SSR"},--金蛋100
    {"modifier_treasure_sublime_phantom_assassin", "SSR"},--守望者101
    {"modifier_treasure_sublime_rattletrap", "SSR"},--坏心眼102
    {"modifier_treasure_sublime_shredder", "SSR"},--兵营103
    {"modifier_treasure_sublime_skeleton_king", "SSR"},--支援小炮104
    {"modifier_treasure_sublime_templar_assassin", "SSR"},--主角105
    {"modifier_treasure_sublime_treant", "SSR"},--代码哥106
    {"modifier_treasure_sublime_visage", "SSR"},--超级士兵107
    {"modifier_treasure_sublime_wisp", "SSR"},--黑洞108

    {"modifier_treasure_speed_fire", "R"},--109
    {"modifier_treasure_double_fire", "SR"},--110

    {"modifier_treasure_goldmon_attribute_one", "SR"},	--金币怪悬赏令111
    {"modifier_treasure_goldmon_attribute_two", "SR"},--	金币怪杀手112
    {"modifier_treasure_midas_collection", "SR"},--  迈达斯的珍藏113
    {"modifier_treasure_more", "R"},--  莫多114
    {"modifier_treasure_more_more", "SR"}, -- 莫多莫多115

    -- 王者套装
    {"modifier_treasure_king_brilliant", "R"},      -- 王者辉煌116
    {"modifier_treasure_king_glory", "SR"},         -- 王者荣耀117
}

-- 检测宝物名称真实性
function treasuresystem:checkTreasuresName(treasureName)
    for index, value in ipairs(global_treasures) do
        if value[1] == treasureName then
            -- body
            return true
        end
    end
    return false
end
-- 
local draw_treasures = {
    {"modifier_treasure_wizardry_mask","R"},-- 巫术面具51
    {"modifier_treasure_rapid_bayonet","N"},-- 疾风之刺52
    {"modifier_treasure_rapid_dagger","R"},-- 疾风之匕53
    {"modifier_treasure_rapid_sword","SR"},-- 疾风之剑54
    {"modifier_treasure_titan_armet","N"},-- 泰坦头盔55
    {"modifier_treasure_titan_hammer","R"},-- 泰坦战锤56
    {"modifier_treasure_titan_shield","SR"},-- 泰坦神盾57
    {"modifier_treasure_abyss_orb","N"},-- 深渊宝珠58
    {"modifier_treasure_abyss_sceptre","R"},-- 深渊权杖59
    {"modifier_treasure_abyss_law","SR"},-- 深渊法典60
    {"modifier_treasure_dragon_king_come_back","SSR"},-- 龙王归来61
    {"modifier_treasure_nenglipengzhang","SSR"},-- 能力膨胀62
    {"modifier_treasure_so_long","N"},-- 听说名字取得长的宝物都很厉害63
    {"modifier_treasure_so_short","N"},-- 短64
    {"modifier_treasure_bloodthirster","N"},-- 饮血剑65
    {"modifier_treasure_bloodaxe","R"},-- 饮血斧66
    {"modifier_treasure_bloodknife","SR"},-- 饮血刀67
    -- {"modifier_treasure_intimidate","N"},-- 恫吓68
    {"modifier_treasure_turbulence_mana","SSR"},-- 法力乱流69
    {"modifier_treasure_five_thousand_exp","R"},-- 5000经验70
    {"modifier_treasure_holiday_beach_slippers","R"},-- 休假用品：沙滩拖鞋71
    {"modifier_treasure_holiday_sunglasses","R"},-- 休假用品：墨镜72
    {"modifier_treasure_holiday_icecola","R"},-- 休假用品：冰可乐73
    {"modifier_treasure_aghanim_scepter","R"},-- 阿哈利姆神杖74
    {"modifier_treasure_three_phase_power_s","R"},-- 三项碎片【上】75
    {"modifier_treasure_three_phase_power_a","R"},-- 三项碎片【中】76
    {"modifier_treasure_three_phase_power_i","R"},-- 三项碎片【下】77
    {"modifier_treasure_apocalypse_a","R"},-- 启示录【上】78
    {"modifier_treasure_apocalypse_b","R"},-- 启示录【中】79
    {"modifier_treasure_apocalypse_c","R"},-- 启示录【下】80

    -- 春节新上的卡
    {"modifier_treasure_speed_fire", "R"},--109
    {"modifier_treasure_double_fire", "SR"},--110
    {"modifier_treasure_goldmon_attribute_one", "SR"},	--金币怪悬赏令111
    {"modifier_treasure_goldmon_attribute_two", "SR"},--	金币怪杀手112
    {"modifier_treasure_midas_collection", "SR"},--  迈达斯的珍藏113
    {"modifier_treasure_more", "R"},--  莫多114
    {"modifier_treasure_more_more", "SR"} -- 莫多莫多115
}

-- 其他掉落
local other_drop_treasures = {
    {"modifier_treasure_wizardry_mask","R"},-- 巫术面具51
    {"modifier_treasure_rapid_bayonet","N"},-- 疾风之刺52
    {"modifier_treasure_rapid_dagger","R"},-- 疾风之匕53
    {"modifier_treasure_rapid_sword","SR"},-- 疾风之剑54
    {"modifier_treasure_titan_armet","N"},-- 泰坦头盔55
    {"modifier_treasure_titan_hammer","R"},-- 泰坦战锤56
    {"modifier_treasure_titan_shield","SR"},-- 泰坦神盾57
    {"modifier_treasure_abyss_orb","N"},-- 深渊宝珠58
    {"modifier_treasure_abyss_sceptre","R"},-- 深渊权杖59
    {"modifier_treasure_abyss_law","SR"},-- 深渊法典60
    {"modifier_treasure_so_long","N"},-- 听说名字取得长的宝物都很厉害63
    {"modifier_treasure_so_short","N"},-- 短64
    {"modifier_treasure_bloodthirster","N"},-- 饮血剑65
    {"modifier_treasure_bloodaxe","R"},-- 饮血斧66
    {"modifier_treasure_bloodknife","SR"},-- 饮血刀67
    {"modifier_treasure_five_thousand_exp","R"},-- 5000经验70
    {"modifier_treasure_holiday_beach_slippers","R"},-- 休假用品：沙滩拖鞋71
    {"modifier_treasure_holiday_sunglasses","R"},-- 休假用品：墨镜72
    {"modifier_treasure_holiday_icecola","R"},-- 休假用品：冰可乐73
    {"modifier_treasure_aghanim_scepter","R"},-- 阿哈利姆神杖74
    {"modifier_treasure_three_phase_power_s","R"},-- 三项碎片【上】75
    {"modifier_treasure_three_phase_power_a","R"},-- 三项碎片【中】76
    {"modifier_treasure_three_phase_power_i","R"},-- 三项碎片【下】77
    {"modifier_treasure_apocalypse_a","R"},-- 启示录【上】78
    {"modifier_treasure_apocalypse_b","R"},-- 启示录【中】79
    {"modifier_treasure_apocalypse_c","R"},-- 启示录【下】80

    {"modifier_treasure_taiji_disciples","N"},-- 太极门徒81
    {"modifier_treasure_taiji_intermediate","R"},-- 太极大师82
    {"modifier_treasure_taiji_master","SR"},-- 太极宗师83

    -- 春节新上的卡
    {"modifier_treasure_speed_fire", "R"},--109
    {"modifier_treasure_double_fire", "SR"},--110
}

-- 高难度掉落
local hard_other_drop_treasures = {
    {"modifier_treasure_wizardry_mask","R"},-- 巫术面具51
    {"modifier_treasure_rapid_bayonet","N"},-- 疾风之刺52
    {"modifier_treasure_rapid_dagger","R"},-- 疾风之匕53
    {"modifier_treasure_rapid_sword","SR"},-- 疾风之剑54
    {"modifier_treasure_titan_armet","N"},-- 泰坦头盔55
    {"modifier_treasure_titan_hammer","R"},-- 泰坦战锤56
    {"modifier_treasure_titan_shield","SR"},-- 泰坦神盾57
    {"modifier_treasure_abyss_orb","N"},-- 深渊宝珠58
    {"modifier_treasure_abyss_sceptre","R"},-- 深渊权杖59
    {"modifier_treasure_abyss_law","SR"},-- 深渊法典60
    {"modifier_treasure_so_long","N"},-- 听说名字取得长的宝物都很厉害63
    {"modifier_treasure_so_short","N"},-- 短64
    {"modifier_treasure_bloodthirster","N"},-- 饮血剑65
    {"modifier_treasure_bloodaxe","R"},-- 饮血斧66
    {"modifier_treasure_bloodknife","SR"},-- 饮血刀67
    {"modifier_treasure_five_thousand_exp","R"},-- 5000经验70
    {"modifier_treasure_holiday_beach_slippers","R"},-- 休假用品：沙滩拖鞋71
    {"modifier_treasure_holiday_sunglasses","R"},-- 休假用品：墨镜72
    {"modifier_treasure_holiday_icecola","R"},-- 休假用品：冰可乐73
    {"modifier_treasure_aghanim_scepter","R"},-- 阿哈利姆神杖74
    {"modifier_treasure_three_phase_power_s","R"},-- 三项碎片【上】75
    {"modifier_treasure_three_phase_power_a","R"},-- 三项碎片【中】76
    {"modifier_treasure_three_phase_power_i","R"},-- 三项碎片【下】77
    {"modifier_treasure_apocalypse_a","R"},-- 启示录【上】78
    {"modifier_treasure_apocalypse_b","R"},-- 启示录【中】79
    {"modifier_treasure_apocalypse_c","R"},-- 启示录【下】80

    {"modifier_treasure_mhzl","R"},-- 蛮荒之力84
    {"modifier_treasure_ltzl","R"},-- 雷霆之力85
    {"modifier_treasure_xwzl","R"},-- 虚无之力86
    {"modifier_treasure_smallmoney","R"},-- 富二代87
    {"modifier_treasure_mhll","SR"},-- 蛮荒灵力88
    {"modifier_treasure_ltll","SR"},-- 雷霆灵力89
    {"modifier_treasure_xwll","SR"},-- 虚无灵力90
    {"modifier_treasure_moremoney","SR"},-- 大富翁91
    {"modifier_treasure_mhsl","SSR"},-- 蛮荒神力92
    {"modifier_treasure_ltsl","SSR"},-- 雷霆神力93
    {"modifier_treasure_xwsl","SSR"},-- 虚无神力94
    {"modifier_treasure_gfatmoney","SSR"},-- G胖的钱包95
    -- 春节新上的卡
    {"modifier_treasure_speed_fire", "R"},--109
    {"modifier_treasure_double_fire", "SR"},--110
}

-- 春节卡池保底掉落
local happy_new_year_treasures = {
    {"modifier_treasure_sublime_alchemist", "SSR"},--土豪升华卡99
    {"modifier_treasure_sublime_omniknight", "SSR"},--100
    {"modifier_treasure_sublime_phantom_assassin", "SSR"},--101
    {"modifier_treasure_sublime_rattletrap", "SSR"},--102
    {"modifier_treasure_sublime_shredder", "SSR"},--103
    {"modifier_treasure_sublime_skeleton_king", "SSR"},--104
    {"modifier_treasure_sublime_templar_assassin", "SSR"},--105
    {"modifier_treasure_sublime_treant", "SSR"},--106
    {"modifier_treasure_sublime_visage", "SSR"},--107
    {"modifier_treasure_sublime_wisp", "SSR"},--108
}

-- 随机给一个保底升华卡
function treasuresystem:random_sublim_treasure()
    local randInt = RandomInt(1, #happy_new_year_treasures)
    return happy_new_year_treasures[randInt][1]
end

-- 春节卡池所有掉落
local happy_new_year_all_treasures = {
    -- 额外获取宝物
    {"modifier_treasure_wizardry_mask","R"},-- 巫术面具51
    {"modifier_treasure_rapid_bayonet","N"},-- 疾风之刺52
    {"modifier_treasure_rapid_dagger","R"},-- 疾风之匕53
    {"modifier_treasure_rapid_sword","SR"},-- 疾风之剑54
    {"modifier_treasure_titan_armet","N"},-- 泰坦头盔55
    {"modifier_treasure_titan_hammer","R"},-- 泰坦战锤56
    {"modifier_treasure_titan_shield","SR"},-- 泰坦神盾57
    {"modifier_treasure_abyss_orb","N"},-- 深渊宝珠58
    {"modifier_treasure_abyss_sceptre","R"},-- 深渊权杖59
    {"modifier_treasure_abyss_law","SR"},-- 深渊法典60
    {"modifier_treasure_dragon_king_come_back","SSR"},-- 龙王归来61
    {"modifier_treasure_nenglipengzhang","SSR"},-- 能力膨胀62
    {"modifier_treasure_so_long","N"},-- 听说名字取得长的宝物都很厉害63
    {"modifier_treasure_so_short","N"},-- 短64
    {"modifier_treasure_bloodthirster","N"},-- 饮血剑65
    {"modifier_treasure_bloodaxe","R"},-- 饮血斧66
    {"modifier_treasure_bloodknife","SR"},-- 饮血刀67
    {"modifier_treasure_turbulence_mana","SSR"},-- 法力乱流69
    {"modifier_treasure_five_thousand_exp","R"},-- 5000经验70
    {"modifier_treasure_holiday_beach_slippers","R"},-- 休假用品：沙滩拖鞋71
    {"modifier_treasure_holiday_sunglasses","R"},-- 休假用品：墨镜72
    {"modifier_treasure_holiday_icecola","R"},-- 休假用品：冰可乐73
    {"modifier_treasure_aghanim_scepter","R"},-- 阿哈利姆神杖74
    {"modifier_treasure_three_phase_power_s","R"},-- 三项碎片【上】75
    {"modifier_treasure_three_phase_power_a","R"},-- 三项碎片【中】76
    {"modifier_treasure_three_phase_power_i","R"},-- 三项碎片【下】77
    {"modifier_treasure_apocalypse_a","R"},-- 启示录【上】78
    {"modifier_treasure_apocalypse_b","R"},-- 启示录【中】79
    {"modifier_treasure_apocalypse_c","R"},-- 启示录【下】80

    {"modifier_treasure_taiji_disciples","N"},-- 太极门徒81
    {"modifier_treasure_taiji_intermediate","R"},-- 太极大师82
    {"modifier_treasure_taiji_master","SR"},-- 太极宗师83
    {"modifier_treasure_mhzl","R"},-- 蛮荒之力84
    {"modifier_treasure_ltzl","R"},-- 雷霆之力85
    {"modifier_treasure_xwzl","R"},-- 虚无之力86
    {"modifier_treasure_smallmoney","R"},-- 富二代87
    {"modifier_treasure_mhll","SR"},-- 蛮荒灵力88
    {"modifier_treasure_ltll","SR"},-- 雷霆灵力89
    {"modifier_treasure_xwll","SR"},-- 虚无灵力90
    {"modifier_treasure_moremoney","SR"},-- 大富翁91
    {"modifier_treasure_mhsl","SSR"},-- 蛮荒神力92
    {"modifier_treasure_ltsl","SSR"},-- 雷霆神力93
    {"modifier_treasure_xwsl","SSR"},-- 虚无神力94
    {"modifier_treasure_gfatmoney","SSR"},-- G胖的钱包95

    {"modifier_treasure_back_off_a","R"},-- 手动挡96
    {"modifier_treasure_back_off_b","R"},-- 自动挡97
    {"modifier_treasure_back_off_c","SSR"},-- 请注意,倒车98

    -- 春节新上的卡
    {"modifier_treasure_sublime_alchemist", "SSR"},--土豪升华卡99
    {"modifier_treasure_sublime_omniknight", "SSR"},--100
    {"modifier_treasure_sublime_phantom_assassin", "SSR"},--101
    {"modifier_treasure_sublime_rattletrap", "SSR"},--102
    {"modifier_treasure_sublime_shredder", "SSR"},--103
    {"modifier_treasure_sublime_skeleton_king", "SSR"},--104
    {"modifier_treasure_sublime_templar_assassin", "SSR"},--105
    {"modifier_treasure_sublime_treant", "SSR"},--106
    {"modifier_treasure_sublime_visage", "SSR"},--107
    {"modifier_treasure_sublime_wisp", "SSR"},--108

    {"modifier_treasure_speed_fire", "R"},--109
    {"modifier_treasure_double_fire", "SR"},--110
    {"modifier_treasure_goldmon_attribute_one", "SR"},	--金币怪悬赏令111
    {"modifier_treasure_goldmon_attribute_two", "SR"},--	金币怪杀手112
    {"modifier_treasure_midas_collection", "SR"},--  迈达斯的珍藏113
    {"modifier_treasure_more", "R"},--  莫多114
    {"modifier_treasure_more_more", "SR"} -- 莫多莫多115
}

local global_happy_new_year_quality = {
    -- ["N"] = {
    --     "modifier_treasure_sacrificial_wristband",
    --     "modifier_treasure_risto_heraldry",
    --     ...
    -- }
}

for key, value in pairs(happy_new_year_all_treasures) do
    if not global_happy_new_year_quality[value[2]] then
        global_happy_new_year_quality[value[2]] = {}
    end
    table.insert(global_happy_new_year_quality[value[2]], value[1])
end

-- DeepPrintTable(global_happy_new_year_quality)
local global_treasures_quality = {
    -- ["N"] = {
    --     "modifier_treasure_sacrificial_wristband",
    --     "modifier_treasure_risto_heraldry",
    --     ...
    -- }
}

local global_other_treasures_quality = {
    -- ["N"] = {
    --     "modifier_treasure_sacrificial_wristband",
    --     "modifier_treasure_risto_heraldry",
    --     ...
    -- }
}

for key, value in pairs(draw_treasures) do
    if not global_treasures_quality[value[2]] then
        global_treasures_quality[value[2]] = {}
    end
    table.insert(global_treasures_quality[value[2]], value[1])
end


for key, value in pairs(other_drop_treasures) do
    if not global_other_treasures_quality[value[2]] then
        global_other_treasures_quality[value[2]] = {}
    end
    table.insert(global_other_treasures_quality[value[2]], value[1])
end

-- 玩家初始化宝物 50 个, 序列号,对应上面的全局宝物库的序号
local init_treasures = {
    1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31,32,33,34,35,36,37,38,39,40,41,42,43,44,45,46,47,48,49,50,
}

-- 玩家初始化配置, 序列号,对应上面的全局宝物库的序号
local init_collocation = {
    1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31,32,33,34,35,36,37,38,39,40,41,42,43,44,45,46,47,48,49,50,
}

-- 玩家独立存档宝物池
local player_treasures_archive = {
    -- [0] = {
    --     -- 对应宝物的ID和数量
    --     {1, 2},{2, 1},{3, 1},{5, 1},{7, 1},
    -- },
}

-- 获得发送到存档服务器的宝物列表
function treasuresystem:send_server_treasures(playerID)
    local send_table = {}

    -- for key, value in pairs(ChangedTreasures) do
    for key, value in pairs(player_treasures_archive[playerID+1]) do
        if value[1] and value[2] then
            local temp_table = {}
            temp_table["treasureId"] = value[1]
            temp_table["treasureNumber"] = value[2]
            table.insert(send_table, temp_table)
        end
    end
    -- for i = 1, #player_treasures_archive[playerID+1] do
    --     -- if key == player_treasures_archive[playerID+1][i][1] then
    --         -- body
    --         local temp_table = {}
    --         temp_table["treasureId"] = player_treasures_archive[playerID+1][i][1]
    --         temp_table["treasureNumber"] = player_treasures_archive[playerID+1][i][2]
    --         table.insert(send_table, temp_table)
    --     -- end
    -- end
    -- end
    -- print(" >>>>>>>>>>>>>>>>>>>> send_server_treasures: ")
    -- DeepPrintTable(send_table)
    return send_table
end

-- 设置玩家宝物池
function treasuresystem:set_player_treasures(playerID, treasures_archive)
    -- DeepPrintTable(treasures_archive)
    player_treasures_archive[playerID+1] = {}
    for key, value in pairs(treasures_archive) do
        if value["treasureId"] and value["treasureNumber"] then
            local temp_table = {}
            table.insert(temp_table,value["treasureId"])
            table.insert(temp_table,value["treasureNumber"])

            table.insert(player_treasures_archive[playerID+1], temp_table)
        end
    end

    -- for index, value in ipairs(init_treasures) do
    --     local isHave = treasuresystem:find_treasureinarchive_byID(playerID, value)
    --     local isHave1 = treasuresystem:find_collocation_byID(playerID, value)
        
    --     if not isHave and not isHave1 then
    --         -- 缺基础卡,自动补充
    --         local temp_table = {}
    --         table.insert(temp_table,value)
    --         table.insert(temp_table,1)

    --         table.insert(player_treasures_archive[playerID+1], temp_table)
    --     elseif not isHave1 and isHave then
    --         local number = treasuresystem:get_treasurenumber_byID(playerID, value)
    --         if number == 0 then
    --             treasuresystem:update_treasureinarchive_byID(playerID, value, 1)
    --         end
    --     end
    -- end
    -- for i = 1, #treasures_archive do
    --     local temp_table = {}
    --     table.insert(temp_table,treasures_archive[i]["treasureId"])
    --     table.insert(temp_table,treasures_archive[i]["treasureNumber"])

    --     table.insert(player_treasures_archive[playerID+1], temp_table)
    -- end
end

-- 补缺基础宝物卡
function treasuresystem:fill_lack_treasures(nPlayerID)
    for index, value in ipairs(init_treasures) do
        local isHave = treasuresystem:find_treasureinarchive_byID(nPlayerID, value)
        local isHave1 = treasuresystem:find_collocation_byID(nPlayerID, value)
        if not isHave and not isHave1 then
            -- 缺基础卡,自动补充
            local temp_table = {}
            table.insert(temp_table,value)
            table.insert(temp_table,1)

            table.insert(player_treasures_archive[nPlayerID+1], temp_table)
        elseif not isHave1 and isHave then
            local number = treasuresystem:get_treasurenumber_byID(nPlayerID, value)
            if number == 0 then
                treasuresystem:update_treasureinarchive_byID(nPlayerID, value, 1)
            end
        elseif isHave1 and not isHave then
            -- 缺基础卡,自动补充
            local temp_table = {}
            table.insert(temp_table,value)
            table.insert(temp_table,0)

            table.insert(player_treasures_archive[nPlayerID+1], temp_table)
        end
    end
end

-- 补缺卡池宝物卡
function treasuresystem:fill_lack_pool_treasures(nPlayerID)
    for index, value in ipairs(global_treasures) do
        local archiveNumber = treasuresystem:get_treasurenumber_byID_ex(nPlayerID, index)
        local isHave = treasuresystem:find_collocation_byID(nPlayerID, index)
        if archiveNumber then
            -- body
            if not isHave and archiveNumber==0 then
                -- 缺卡,补足
                treasuresystem:update_treasureinarchive_byID(nPlayerID, index, 1)
            end
        end
    end
end

-- 玩家上场的宝物配置
local player_collocation = {
    -- [0] = {
    --     -- 对应宝物的ID和数量
    --     {1, 2},{2, 1},{3, 1},{5, 1},{7, 1},
    -- },
}

-- 获得发送到存档服务器的宝物配置
function treasuresystem:send_server_treasureConfigs(playerID)
    local send_table = {}

    for i = 1, #player_collocation[playerID+1] do
        local temp_table = {}
        temp_table["treasureId"] = player_collocation[playerID+1][i][1]
        temp_table["treasureNumber"] = player_collocation[playerID+1][i][2]
        table.insert(send_table, temp_table)
    end
    return send_table
end

-- 设置玩家宝物池
function treasuresystem:set_player_treasureConfigs(playerID, treasureConfigs_archive)
    player_collocation[playerID+1] = {}
    for i = 1, #treasureConfigs_archive do
        local temp_table = {}
        table.insert(temp_table,treasureConfigs_archive[i]["treasureId"])
        table.insert(temp_table,treasureConfigs_archive[i]["treasureNumber"])

        table.insert(player_collocation[playerID+1], temp_table)
    end
    self:update_treasures_name(playerID)
end

-- 玩家当局可以使用的宝物名称
local treasures_name = {
    -- [0] = {
    
    -- },
}

-- 玩家当局可以使用的宝物数量计数
local treasures_qualitynumber = {
    -- [0] = {
    --     ["SR"] = 0,
    --     ["SSR"] = 0,
    -- },
}

-- 根据宝物ID得到宝物名称
function treasuresystem:get_treasure_name(treasureid)
    if treasureid > #global_treasures or treasureid <=0 then
        return nil
    end
    return global_treasures[treasureid][1]
end

-- 根据宝物名称得到宝物ID
function treasuresystem:get_treasure_id(treasurename)
    for i = 1, #global_treasures do
        if treasurename == global_treasures[i][1] then
            return i
        end
    end
    return nil
end

-- 根据宝物ID得到宝物品质
function treasuresystem:get_treasure_quality(treasureid)
    if treasureid > #global_treasures or treasureid <=0 then
        return nil
    end
    return global_treasures[treasureid][2]
end

-- 根据宝物index查找存档里面是否有这个宝物
function treasuresystem:find_treasureinarchive_byID(playerID, treasurIndex)
    for key, value in pairs(player_treasures_archive[playerID+1]) do
        if treasurIndex == value[1] then
            return true
        end
    end

    -- for i = 1, #player_treasures_archive[playerID+1] do
    --     if treasurIndex == player_treasures_archive[playerID+1][i][1] then
    --         return true
    --     end
    -- end
    return false
end

-- 根据宝物index得到存档里面宝物的数量
function treasuresystem:get_treasurenumber_byID(playerID, treasurIndex)
    for key, value in pairs(player_treasures_archive[playerID+1]) do
        if treasurIndex == value[1] then
            return value[2]
        end
    end

    -- for i = 1, #player_treasures_archive[playerID+1] do
    --     if treasurIndex == player_treasures_archive[playerID+1][i][1] then
    --         return true
    --     end
    -- end
    return 0
end

-- 根据宝物index得到存档里面宝物的数量
function treasuresystem:get_treasurenumber_byID_ex(playerID, treasurIndex)
    for key, value in pairs(player_treasures_archive[playerID+1]) do
        if treasurIndex == value[1] then
            return value[2]
        end
    end

    -- for i = 1, #player_treasures_archive[playerID+1] do
    --     if treasurIndex == player_treasures_archive[playerID+1][i][1] then
    --         return true
    --     end
    -- end
    return nil
end

-- 根据宝物index查找配置里面是否有这个宝物
function treasuresystem:find_collocation_byID(playerID, treasurIndex)
    for i = 1, #player_collocation[playerID+1] do
        if treasurIndex == player_collocation[playerID+1][i][1] then
            return true
        end
    end
    return false
end

-- 统计玩家宝物品级计数
function treasuresystem:statistics_treasures(playerID)
    treasures_qualitynumber[playerID+1] = {
        ["R"] = 0,
        ["SR"] = 0,
        ["SSR"] = 0,
    }
    for i = 1, #player_collocation[playerID+1] do
        local quality = self:get_treasure_quality(player_collocation[playerID+1][i][1])
        if quality=="SSR" then
            treasures_qualitynumber[playerID+1][quality] = treasures_qualitynumber[playerID+1][quality] + player_collocation[playerID+1][i][2]
        elseif quality=="SR" then
            treasures_qualitynumber[playerID+1][quality] = treasures_qualitynumber[playerID+1][quality] + player_collocation[playerID+1][i][2]
        elseif quality=="R" then
            treasures_qualitynumber[playerID+1][quality] = treasures_qualitynumber[playerID+1][quality] + player_collocation[playerID+1][i][2]
        end
    end
end

-- 统计玩家当前设置的上场所有宝物数量
function treasuresystem:get_collocationNumber(playerID)
    local allNumber = 0
    for i = 1, #player_collocation[playerID+1] do
        allNumber = allNumber + player_collocation[playerID+1][i][2]
    end
    return allNumber
end

-- 第一次没有存档的玩家初始化玩家宝物
function treasuresystem:player_inittreasures(playerID)
    player_treasures_archive[playerID+1] = {}
    for i = 1, #init_treasures do
        local treasure_data = {}
        table.insert(treasure_data, init_treasures[i])
        table.insert(treasure_data, 1)
        table.insert(player_treasures_archive[playerID+1], treasure_data)
    end
    player_collocation[playerID+1] = {}
    treasuresystem:resetcollocation(playerID, 1)
end

-- 获取玩家宝物池
function treasuresystem:get_player_treasures(playerID)
    return player_treasures_archive[playerID+1]
end



-- 获取玩家上场的宝物配置
function treasuresystem:get_player_collocation(playerID)
    if not player_collocation[playerID+1] then
        player_collocation[playerID+1] = {}
    end
    return player_collocation[playerID+1]
end

-- 设置随机卡组
function treasuresystem:initround_random(PlayerID)
    treasures_name[PlayerID+1] = {}
    local N_TB = {}
    local R_TB = {}
    local SR_TB = {}
    local SSR_TB = {}
    local temp_player_treasures = deepcopy(player_treasures_archive[PlayerID+1])
    for i = 1, player_roundtreasures do
        if #temp_player_treasures > 0 then
            local randomindex = RandomInt(1, #temp_player_treasures)
            local treasures_data = {}
            local name = treasuresystem:get_treasure_name(temp_player_treasures[randomindex][1])
            local number = 1
            local quality = self:get_treasure_quality(temp_player_treasures[randomindex][1])
            if temp_player_treasures[randomindex][2] > 1 then
                temp_player_treasures[randomindex][2] = temp_player_treasures[randomindex][2] - 1
            else
                table.remove(temp_player_treasures, randomindex)
            end
            table.insert(treasures_data, name)
            table.insert(treasures_data, number)
            if quality=="N" then
                table.insert(N_TB, treasures_data)
            elseif quality=="R" then
                table.insert(R_TB, treasures_data)
            elseif quality=="SR" then
                table.insert(SR_TB, treasures_data)
            elseif quality=="SSR" then
                table.insert(SSR_TB, treasures_data)
            end
            
        end
    end
    treasures_name[PlayerID+1]["N"] = N_TB
    treasures_name[PlayerID+1]["R"] = R_TB
    treasures_name[PlayerID+1]["SR"] = SR_TB
    treasures_name[PlayerID+1]["SSR"] = SSR_TB
end

-- 自动填充不足的宝物到配置表
function treasuresystem:random_filler(PlayerID)
    local lacknumber = player_roundtreasures - treasuresystem:get_collocationNumber(PlayerID)
    if lacknumber > 0 then
        -- 补充N级卡
        -- for index = 1, #player_treasures_archive[PlayerID+1] do
        for key, value in pairs(player_treasures_archive[PlayerID+1]) do
            if lacknumber == 0 then
                break
            end
            if value[2] > 0 then
                local treasureid = value[1]
                local quality = self:get_treasure_quality(treasureid)
                if quality == "N" then
                    local isinsert = true
                    for i = 1, #player_collocation[PlayerID+1] do
                        if player_collocation[PlayerID+1][i][1] == treasureid then
                            -- player_collocation[PlayerID+1][i][2] = player_collocation[PlayerID+1][i][2] + 1
                            isinsert = false
                            break
                        end
                    end
                    if isinsert then
                        local insertdata = {}
                        table.insert(insertdata, treasureid)
                        table.insert(insertdata, 1)
                        table.insert(player_collocation[PlayerID+1], insertdata)
                        self:update_treasureinarchive_byID(PlayerID, treasureid, -1)
                        lacknumber = lacknumber - 1
                    end
                    -- self:update_treasureinarchive_byID(PlayerID, treasureid, -1)
                    -- lacknumber = lacknumber - 1
                end
            end
        end

        -- 补充R级卡
        -- for index = 1, #player_treasures_archive[PlayerID+1] do
        for key, value in pairs(player_treasures_archive[PlayerID+1]) do
            if lacknumber == 0 then
                break
            end
            if value[2] > 0 then
                local treasureid = value[1]
                local quality = self:get_treasure_quality(treasureid)
                if quality == "R" then
                    local isinsert = true
                    for i = 1, #player_collocation[PlayerID+1] do
                        if player_collocation[PlayerID+1][i][1] == treasureid then
                            -- player_collocation[PlayerID+1][i][2] = player_collocation[PlayerID+1][i][2] + 1
                            isinsert = false
                            break
                        end
                    end
                    if isinsert then
                        local insertdata = {}
                        table.insert(insertdata, treasureid)
                        table.insert(insertdata, 1)
                        table.insert(player_collocation[PlayerID+1], insertdata)
                        self:update_treasureinarchive_byID(PlayerID, treasureid, -1)
                        lacknumber = lacknumber - 1
                    end
                    -- self:update_treasureinarchive_byID(PlayerID, treasureid, -1)
                    -- lacknumber = lacknumber - 1
                end
            end
        end

        -- 补充SR级卡
        -- for index = 1, #player_treasures_archive[PlayerID+1] do
        for key, value in pairs(player_treasures_archive[PlayerID+1]) do
            if lacknumber == 0 then
                break
            end
            if value[2] > 0 then
                local treasureid = value[1]
                local quality = self:get_treasure_quality(treasureid)
                if quality == "SR" then
                    local isinsert = true
                    for i = 1, #player_collocation[PlayerID+1] do
                        if player_collocation[PlayerID+1][i][1] == treasureid then
                            -- player_collocation[PlayerID+1][i][2] = player_collocation[PlayerID+1][i][2] + 1
                            isinsert = false
                            break
                        end
                    end
                    if isinsert then
                        local insertdata = {}
                        table.insert(insertdata, treasureid)
                        table.insert(insertdata, 1)
                        table.insert(player_collocation[PlayerID+1], insertdata)
                        self:update_treasureinarchive_byID(PlayerID, treasureid, -1)
                        lacknumber = lacknumber - 1
                    end
                    -- self:update_treasureinarchive_byID(PlayerID, treasureid, -1)
                    -- lacknumber = lacknumber - 1
                end
            end
        end

        -- 补充SSR级卡
        -- for index = 1, #player_treasures_archive[PlayerID+1] do
        for key, value in pairs(player_treasures_archive[PlayerID+1]) do
            if lacknumber == 0 then
                break
            end
            if value[2] > 0 then
                local treasureid = value[1]
                local quality = self:get_treasure_quality(treasureid)
                if quality == "SSR" then
                    local isinsert = true
                    for i = 1, #player_collocation[PlayerID+1] do
                        if player_collocation[PlayerID+1][i][1] == treasureid then
                            -- player_collocation[PlayerID+1][i][2] = player_collocation[PlayerID+1][i][2] + 1
                            isinsert = false
                            break
                        end
                    end
                    if isinsert then
                        local insertdata = {}
                        table.insert(insertdata, treasureid)
                        table.insert(insertdata, 1)
                        table.insert(player_collocation[PlayerID+1], insertdata)
                        self:update_treasureinarchive_byID(PlayerID, treasureid, -1)
                        lacknumber = lacknumber - 1
                    end
                    -- self:update_treasureinarchive_byID(PlayerID, treasureid, -1)
                    -- lacknumber = lacknumber - 1
                end
            end
        end
    end
    self:update_treasures_name(PlayerID)
end

-- 得到玩家当局宝物池,宝物名称
function treasuresystem:getroundtreasuresname(playerID)
    return treasures_name[playerID+1]
end

-- 随机当前等级的宝物 玩家ID,品级,数量, 返回结果是 宝物名称数组
function treasuresystem:get_randomtreasures_byquality(playerID, quality, number)
    local temp_tab = deepcopy(treasures_name[playerID+1][quality])
    
    local send_tab = {}
    for i = 1, number do
        if #temp_tab < 1 then
            break
        end
        local randomindex = RandomInt(1, #temp_tab)
        if temp_tab[randomindex][2] > 0 then
            table.insert(send_tab, temp_tab[randomindex][1])
            temp_tab[randomindex][2] = temp_tab[randomindex][2] - 1
        end
    end
    return send_tab
end

-- 当局移除当前品质和名称的宝物
function treasuresystem:remove_treasures_byquality(playerID, quality, name)
    if not treasures_name[playerID+1] then
        return false
    end
    for i = 1, #treasures_name[playerID+1][quality] do
        if treasures_name[playerID+1][quality][i][1] == name and treasures_name[playerID+1][quality][i][2] > 0 then
            treasures_name[playerID+1][quality][i][2] = treasures_name[playerID+1][quality][i][2] - 1
            if treasures_name[playerID+1][quality][i][2] == 0 then
                table.remove(treasures_name[playerID+1][quality], i)
            end
            return true
        end
    end
    return false
end

-- 抽取随机宝物给玩家展示
function treasuresystem:get_randomtreasures(playerID, number)
    local send_tab = {}
    local quality_num = {
        ["N"] = 0,
        ["R"] = 0,
        ["SR"] = 0,
        ["SSR"] = 0,
    }
    for i = 1, number do
        local irandom = RandomInt(1, 100)
        if irandom <= 60 then
            -- N级
            quality_num["N"] = quality_num["N"] + 1
        elseif irandom > 60 and irandom <= 90 then
            -- R级
            quality_num["R"] = quality_num["R"] + 1
        elseif irandom > 90 and irandom <= 99 then
            -- SR级
            quality_num["SR"] = quality_num["SR"] + 1
        else
            -- SSR级
            quality_num["SSR"] = quality_num["SSR"] + 1
        end
    end
    for key, value in pairs(quality_num) do
        local re_table = self:get_randomtreasures_byquality(playerID, key, value)
        for i = 1, #re_table do
            table.insert(send_tab, re_table[i])
        end
    end
    return send_tab
end

-- 抽取随机宝物添加给玩家
function treasuresystem:set_randomtreasures_forhero(hero, number)
    local set_tab = self:get_randomtreasures(hero:GetPlayerID(), number)
    for i = 1, #set_tab do
        local quality = self:get_treasure_quality(self:get_treasure_id(set_tab[i]))
        if self:remove_treasures_byquality(hero:GetPlayerID(), quality, set_tab[i]) then
            AddTreasureForHero(hero, set_tab[i], {})
        end
    end
end

-- 平均几率随机抽取宝物展示
function treasuresystem:get_averagerandomtreasures(playerID, number)
    local temp_tab = {}
    for i, value in pairs(treasures_name[playerID+1]) do
        for j = 1, #value do
            if value[j][2] > 0 then
                table.insert(temp_tab, value[j][1])
            end
        end
    end
    local senb_table = {}
    for i = 1, number do
        local randomint = RandomInt(1, #temp_tab)
        table.insert(senb_table, temp_tab[randomint])
        table.remove(temp_tab, randomint)
    end
    return senb_table
end

-- 玩家选择当前宝物
function treasuresystem:remove_treasure(playerID, treasurename)
    local tIndex = self:get_treasure_id(treasurename)
    if not tIndex then
        return
    end
    local quality = self:get_treasure_quality(tIndex)
    if not quality then
        -- body
        return
    end
    self:remove_treasures_byquality(playerID, quality, treasurename)
end

local player_round_treasures = {
    -- [1] = {
    --     "modifier_treasure_aghanim_crystal",
    --     "modifier_treasure_aghanim_crystal",
    --     "modifier_treasure_aghanim_crystal",
    -- },
}

function treasuresystem:setplayer_round_treasures(playerID, round_treasures)
    player_round_treasures[playerID] = round_treasures
end

function treasuresystem:random_round_treasures(playerID)
    local randomint = RandomInt(1, #player_round_treasures[playerID])
    return player_round_treasures[playerID][randomint]
end

-- 检测宝物名称是否真实有效
function treasuresystem:check_round_treasures(playerID, treasuresname)
    if not player_round_treasures[playerID] then
        return false
    end
    for i = 1, #player_round_treasures[playerID] do
        if treasuresname == player_round_treasures[playerID][i] then
            return true
        end
    end
    return false
end

-- 根据配置更新上场宝物的列表
function treasuresystem:update_treasures_name(playerID)
    treasures_name[playerID+1] = {}
    local N_TB = {}
    local R_TB = {}
    local SR_TB = {}
    local SSR_TB = {}

    for i = 1, #player_collocation[playerID+1] do
        local treasures_data = {}
        local name = self:get_treasure_name(player_collocation[playerID+1][i][1])
        local quality = self:get_treasure_quality(player_collocation[playerID+1][i][1])
        local number = player_collocation[playerID+1][i][2]
        table.insert(treasures_data, name)
        table.insert(treasures_data, number)
        if quality=="N" then
            table.insert(N_TB, treasures_data)
        elseif quality=="R" then
            table.insert(R_TB, treasures_data)
        elseif quality=="SR" then
            table.insert(SR_TB, treasures_data)
        elseif quality=="SSR" then
            table.insert(SSR_TB, treasures_data)
        end
    end
    treasures_name[playerID+1]["N"] = N_TB
    treasures_name[playerID+1]["R"] = R_TB
    treasures_name[playerID+1]["SR"] = SR_TB
    treasures_name[playerID+1]["SSR"] = SSR_TB
end

-- 检测宝物是否上场
function treasuresystem:check_treasures_name(playerID, name)
    local treasures = treasures_name[playerID+1]
    if treasures then
        for key, value in pairs(treasures) do
            for index, values in pairs(value) do
                if values[1] == name then
                    -- body
                    return true
                end
            end
        end
    end
    return false
end
-- 得到对应序号的宝物的品质 
function treasuresystem:get_treasure_quality_byindex(treasurIndex)
    return global_treasures[treasurIndex][2]
end

-- 对玩家宝物存档分组处理,名称和数量
function treasuresystem:group_treasures(playerID)
    local send_treasures = {}
    local N_TB = {}
    local R_TB = {}
    local SR_TB = {}
    local SSR_TB = {}
    -- for i = 1, #player_treasures_archive[playerID+1] do
    for key, value in pairs(player_treasures_archive[playerID+1]) do
        local treasure_name = self:get_treasure_name(value[1])
        local treasure_quality = self:get_treasure_quality(value[1])
        local treasure_number = value[2]
        -- if treasuresystem:find_collocation_byID(playerID, value[1]) then
        --     treasure_number = treasure_number + 1
        -- end
        local treasure_data = {}
        table.insert(treasure_data, treasure_name)
        table.insert(treasure_data, treasure_number)
        if treasure_quality=="N" then
            table.insert(N_TB, treasure_data)
        elseif treasure_quality=="R" then
            table.insert(R_TB, treasure_data)
        elseif treasure_quality=="SR" then
            table.insert(SR_TB, treasure_data)
        elseif treasure_quality=="SSR" then
            table.insert(SSR_TB, treasure_data)
        end
    end
    send_treasures["N"] = N_TB
    send_treasures["R"] = R_TB
    send_treasures["SR"] = SR_TB
    send_treasures["SSR"] = SSR_TB
    return send_treasures
end

-- 对玩家宝物存档分组处理,名称和数量
function treasuresystem:group_treasuresex(playerID)
    local send_treasures = {}
    local N_TB = {}
    local R_TB = {}
    local SR_TB = {}
    local SSR_TB = {}
    -- for i = 1, #player_treasures_archive[playerID+1] do
    for key, value in pairs(player_treasures_archive[playerID+1]) do
        local treasure_name = self:get_treasure_name(value[1])
        local treasure_quality = self:get_treasure_quality(value[1])
        local treasure_number = value[2]
        if treasuresystem:find_collocation_byID(playerID, value[1]) then
            treasure_number = treasure_number + 1
        end
        local treasure_data = {}
        table.insert(treasure_data, treasure_name)
        table.insert(treasure_data, treasure_number)
        if treasure_quality=="N" then
            table.insert(N_TB, treasure_data)
        elseif treasure_quality=="R" then
            table.insert(R_TB, treasure_data)
        elseif treasure_quality=="SR" then
            table.insert(SR_TB, treasure_data)
        elseif treasure_quality=="SSR" then
            table.insert(SSR_TB, treasure_data)
        end
    end
    send_treasures["N"] = N_TB
    send_treasures["R"] = R_TB
    send_treasures["SR"] = SR_TB
    send_treasures["SSR"] = SSR_TB
    return send_treasures
end

-- 发送宝物存档数据给客户端
function treasuresystem:sendTreasureData2client(playerID)
    local send_treasures = self:group_treasures(playerID)
    local tmp_tab = {gamedifficulty = GameRules:GetCustomGameDifficulty(), max_player = global_var_func.all_player_amount, R_max=R_max, SR_max=SR_max, SSR_max=SSR_max, player_collocation = treasures_name[playerID + 1], treasures = send_treasures}
    CustomGameEventManager:Send_ServerToPlayer(PlayerResource:GetPlayer(playerID),"response_treasure_data",tmp_tab)

    self:update_treasures_name(playerID)
    self:statistics_treasures(playerID)
end

-- 锁定后正式进入游戏重新发宝物最新数据
function treasuresystem:sendTreasureDataEnterGame(playerID)
    local send_treasures = self:group_treasuresex(playerID)
    local tmp_tab = {treasures = send_treasures}
    -- DeepPrintTable(tmp_tab)
    CustomGameEventManager:Send_ServerToPlayer(PlayerResource:GetPlayer(playerID),"response_treasure_data_EnterGame",tmp_tab)
end

-- 反馈客户端刷新宝物配置请求
function treasuresystem:resetTreasureData2client(playerID)
    local send_treasures = self:group_treasures(playerID)
    local tmp_tab = {max_player = global_var_func.all_player_amount, R_max=R_max, SR_max=SR_max, SSR_max=SSR_max, player_collocation = treasures_name[playerID + 1], treasures = send_treasures}
    CustomGameEventManager:Send_ServerToPlayer(PlayerResource:GetPlayer(playerID),"response_resetcollocation",tmp_tab)
end

-- 设置上场宝物
function treasuresystem:set_roundtreasure(evt)
    if GameRules:GetCustomGameDifficulty() == 1 then
        return
    end
    local playerID = evt.PlayerID
    local treasuresname = evt.treasuresname
    local treasuresindex = treasuresystem:get_treasure_id(treasuresname)
    if treasuresystem:find_collocation_byID(playerID, treasuresindex) then
        -- body
        CustomGameEventManager:Send_ServerToPlayer(PlayerResource:GetPlayer(playerID),"response_errortext",{errortext = "error_nosamecard"})
        return
    end
    -- print(treasuresystem:get_collocationNumber(playerID))
    -- DeepPrintTable(player_collocation[playerID+1])
    if treasuresystem:get_collocationNumber(playerID) >= player_roundtreasures then
        CustomGameEventManager:Send_ServerToPlayer(PlayerResource:GetPlayer(playerID),"response_errortext",{errortext = "error_maxtreasurs"})
        return
    end
    -- print(" >>>>>>>>>>>>> treasuresindex:"..treasuresindex)
    -- DeepPrintTable(player_treasures_archive[playerID+1])
    
    local quality = treasuresystem:get_treasure_quality(treasuresindex)
    -- print(quality..":")
    -- print(treasures_qualitynumber[playerID+1][quality])
    if quality=="SR" then
        if treasures_qualitynumber[playerID+1][quality] >= SR_max then
            CustomGameEventManager:Send_ServerToPlayer(PlayerResource:GetPlayer(playerID),"response_errortext",{errortext = "error_qualitymaxtreasurs"})
            return
        end
    elseif quality=="SSR" then
        if treasures_qualitynumber[playerID+1][quality] >= SSR_max then
            CustomGameEventManager:Send_ServerToPlayer(PlayerResource:GetPlayer(playerID),"response_errortext",{errortext = "error_qualitymaxtreasurs"})
            return
        end
    elseif quality=="R" then
        if treasures_qualitynumber[playerID+1][quality] >= R_max then
            CustomGameEventManager:Send_ServerToPlayer(PlayerResource:GetPlayer(playerID),"response_errortext",{errortext = "error_qualitymaxtreasurs"})
            return
        end
    end
    local isinsert = true
    for i = 1, #player_collocation[playerID+1] do
        if player_collocation[playerID+1][i][1] == treasuresindex then
            player_collocation[playerID+1][i][2] = player_collocation[playerID+1][i][2] + 1
            isinsert = false
            break
        end
    end
    if isinsert then
        local insertdata = {}
        table.insert(insertdata, treasuresindex)
        table.insert(insertdata, 1)
        table.insert(player_collocation[playerID+1], insertdata)
    end
    treasuresystem:update_treasureinarchive_byID(playerID, treasuresindex, -1)
    treasuresystem:update_treasures_name(playerID)
    treasuresystem:statistics_treasures(playerID)
end

-- 取消上场宝物
function treasuresystem:del_roundtreasure(evt)
    -- print(" >>>>>>>>>>>>>del_roundtreasure: "..GameRules:GetCustomGameDifficulty())
    if GameRules:GetCustomGameDifficulty() == 1 then
        return
    end
    local playerID = evt.PlayerID
    local treasuresname = evt.treasuresname
    local treasurIndex = treasuresystem:get_treasure_id(treasuresname)
    if not treasurIndex then
        CustomGameEventManager:Send_ServerToPlayer(PlayerResource:GetPlayer(playerID),"response_errortext",{errortext = "error_treasurindex"})
        return
    end
    local hascard = false
    for i = 1, #player_collocation[playerID+1] do
        if player_collocation[playerID+1][i][1] == treasurIndex and player_collocation[playerID+1][i][2] > 0 then
            hascard = true
            break
        end
    end
    if not hascard then
        CustomGameEventManager:Send_ServerToPlayer(PlayerResource:GetPlayer(playerID),"response_errortext",{errortext = "error_treasurindex"})
        return
    end
    
    for i = 1, #player_collocation[playerID+1] do
        if player_collocation[playerID+1][i][1] == treasurIndex then
            player_collocation[playerID+1][i][2] = player_collocation[playerID+1][i][2] - 1
            if player_collocation[playerID+1][i][2] <= 0 then
                table.remove(player_collocation[playerID+1], i)
            end
            break
        end
    end
    
    treasuresystem:update_treasureinarchive_byID(playerID, treasurIndex, 1)
    treasuresystem:update_treasures_name(playerID)
    treasuresystem:statistics_treasures(playerID)
end

-- 有改动的宝物数据
local changedTreasures = {
    -- [playerID+1] = {treasurIndex, treasurIndex, },
    -- [playerID+1] = {treasurIndex, treasurIndex, },
}

function treasuresystem:updateChangedTreasures(playerID, treasurIndex)
    if not changedTreasures[playerID+1] then
        changedTreasures[playerID+1] = {}
    end
    changedTreasures[playerID+1][treasurIndex] = 1
end

function treasuresystem:getChangedTreasures(playerID)
    if not changedTreasures[playerID+1] then
        -- body
        changedTreasures[playerID+1] = {}
    end
    return changedTreasures[playerID+1]
end

function treasuresystem:clearChangedTreasures(playerID)
    changedTreasures[playerID+1] = {}
end

-- 根据宝物index设置存档里面对应宝物数量
function treasuresystem:update_treasureinarchive_byID(playerID, treasurIndex, number)
    -- treasuresystem:updateChangedTreasures(playerID, treasurIndex)
    for key, value in pairs(player_treasures_archive[playerID+1]) do
        if treasurIndex == value[1] then
            value[2] = value[2] + number
            if value[2] <= 0 then
                value[2]  = 0
            end
            return
        end
    end
    -- for i = 1, #player_treasures_archive[playerID+1] do
    --     if treasurIndex == player_treasures_archive[playerID+1][i][1] then
    --         player_treasures_archive[playerID+1][i][2] = player_treasures_archive[playerID+1][i][2] + number
    --         if player_treasures_archive[playerID+1][i][2] <= 0 then
    --             player_treasures_archive[playerID+1][i][2]  = 0
    --         end
    --         return
    --     end
    -- end
    local insertdata = {}
    table.insert(insertdata, treasurIndex)
    table.insert(insertdata, 1)
    table.insert(player_treasures_archive[playerID+1], insertdata)
    return
end

-- 根据宝物index设置配置里面对应宝物数量
function treasuresystem:update_collocation_byID(playerID, treasurIndex, number)
    for i = 1, #player_collocation[playerID+1] do
        if treasurIndex == player_collocation[playerID+1][i][1] then
            player_collocation[playerID+1][i][2] = player_collocation[playerID+1][i][2] + number
            if player_collocation[playerID+1][i][2] <= 0 then
                table.remove(player_collocation[playerID+1], i)
            end
            return true
        end
    end
    return false
end

-- 清空配置宝物  collocationID 默认写1
function treasuresystem:clearcollocation(playerID, collocationID)
    -- for i = 1, #player_collocation[playerID+1] do
    for key, value in pairs(player_collocation[playerID+1]) do
        -- for j = 1, #player_treasures_archive[playerID+1] do
        for key1, value1 in pairs(player_treasures_archive[playerID+1]) do
            if value[1] == value1[1] then
                value1[2] = value1[2] + value[2]
            end
        end
    end
    player_collocation[playerID+1] = {}
end

-- 重设配置宝物
function treasuresystem:resetcollocation(playerID, collocationID)
    if #player_collocation[playerID+1] > 0 then
        self:clearcollocation(playerID, collocationID)
        self:update_treasures_name(playerID)
        self:statistics_treasures(playerID)
    end
    for i = 1, #init_collocation do
        if self:find_treasureinarchive_byID(playerID, init_collocation[i]) then
            local insertdata = {}
            table.insert(insertdata, init_collocation[i])
            table.insert(insertdata, 1)
            table.insert(player_collocation[playerID+1], insertdata)

            self:update_treasureinarchive_byID(playerID, init_collocation[i], -1)
        end
    end
    self:update_treasures_name(playerID)
    self:statistics_treasures(playerID)
end

-- 获取宝物设置倒计时
function treasuresystem:get_stay_time()
    return stay_time
end

-- 设置倒计时
function treasuresystem:set_stay_time(settime)
    stay_time = settime
    return stay_time
end

-- 倒计时减少
function treasuresystem:reduce_stay_time()
    if stay_time > 0 then
        stay_time = stay_time - 1
    end
    return stay_time
end

-- 游戏准备倒计时
function treasuresystem:get_gamestart_time()
    return gamestart_time
end

-- 设置游戏准备倒计时
function treasuresystem:set_gamestart_time(settime)
    gamestart_time = settime
    return gamestart_time
end

-- 游戏准备倒计时减少
function treasuresystem:reduce_gamestart_time()
    if gamestart_time > 0 then
        gamestart_time = gamestart_time - 1
    end
    return gamestart_time
end

-- 响应锁定宝物选择界面
function treasuresystem:OnLockSelect(data)
    local playerID = data.PlayerID
    if lock_players == global_var_func.all_player_amount then
        return
    end
    if treasuresystem:get_collocationNumber(playerID) > player_roundtreasures then
        CustomGameEventManager:Send_ServerToPlayer(PlayerResource:GetPlayer(playerID),"response_errortext",{errortext = "error_maxtreasurs"})
        return
    end
    if treasures_qualitynumber[playerID+1]["R"] > R_max then
        CustomGameEventManager:Send_ServerToPlayer(PlayerResource:GetPlayer(playerID),"response_errortext",{errortext = "error_qualitymaxtreasurs"})
        return
    end

    if treasures_qualitynumber[playerID+1]["SR"] > SR_max then
        CustomGameEventManager:Send_ServerToPlayer(PlayerResource:GetPlayer(playerID),"response_errortext",{errortext = "error_qualitymaxtreasurs"})
        return
    end

    if treasures_qualitynumber[playerID+1]["SSR"] > SSR_max then
        CustomGameEventManager:Send_ServerToPlayer(PlayerResource:GetPlayer(playerID),"response_errortext",{errortext = "error_qualitymaxtreasurs"})
        return
    end

    local player_id = data.PlayerID
    -- if GameRules:GetCustomGameDifficulty() == 1 then
    --     -- 难度1,全随机模式
    --     -- treasuresystem:clearcollocation(player_id, 1)
    --     treasuresystem:initround_random(player_id)
    -- else
    --     -- 根据配置自动填充
    --     treasuresystem:random_filler(player_id)
    --     game_playerinfo:save_treasures(player_id)
    -- end
    lock_players = lock_players + 1
    if lock_players == (global_var_func.all_player_amount - 1) then
        -- 进入最后倒计时
        treasuresystem:set_stay_time(30)
        GameRules:SetPreGameTime(999999)
    elseif lock_players == global_var_func.all_player_amount then
        treasuresystem:set_stay_time(3)
        GameRules:SetPreGameTime(999999)
    end
    CustomGameEventManager:Send_ServerToAllClients("response_lock_select",{player_id = player_id, ready_count = lock_players})

    -- treasuresystem:sendTreasureDataEnterGame(player_id)
end

function treasuresystem:OnTreasureDataEnterGame(evt)
    local playerID = evt.PlayerID
    -- print(" >>>>>>>>>>>>>>>>>> playerID: "..playerID)
    treasuresystem:sendTreasureDataEnterGame(playerID)
end

-- 
function treasuresystem:Onresetcollocation(evt)
    if GameRules:GetCustomGameDifficulty() == 1 then
        return
    end
    local playerID = evt.PlayerID
    treasuresystem:resetcollocation(playerID, 1)
    treasuresystem:resetTreasureData2client(playerID)
end

function treasuresystem:Onclearcollocation(evt)
    if GameRules:GetCustomGameDifficulty() == 1 then
        return
    end
    local playerID = evt.PlayerID
    treasuresystem:clearcollocation(playerID, 1)
    treasuresystem:update_treasures_name(playerID)
    treasuresystem:statistics_treasures(playerID)
end


-- 玩家独立掉落计数
local drop_scale = {
    -- [playerid] = 0,
    -- [playerid] = 0,
    -- [playerid] = 0,
    -- [playerid] = 0,
}
-- 小怪掉落宝物书
function treasuresystem:DropTreasureBook(playerID)
    if not drop_scale[playerID] then
        drop_scale[playerID] = 0
    end
    if drop_scale[playerID] >= global_var_func.treasure_drop_max then
        return false
    end
    local player_scale = RandomInt(1, 1000)
    if player_scale <= 2 then
        drop_scale[playerID] = drop_scale[playerID] + 1
        return true
    else
        return false
    end
end

-- 获取一张对应品质的卡牌到玩家的卡池
function treasuresystem:AddTreasureToPlayer(playerID, quality)
    local addTreasureName = ""
    local randomList = global_treasures_quality[quality]
    
    if #randomList > 0 then
        local index = RandomInt(1, #randomList)
        addTreasureName = randomList[index]
    end
    if addTreasureName~="" then
        -- 添加到卡池
        local addTreasureIndex = self:get_treasure_id(addTreasureName)
        self:update_treasureinarchive_byID(playerID, addTreasureIndex, 1)
    end
    return addTreasureName
end

-- 获取一张对应品质的春季卡池卡牌到玩家的卡池
function treasuresystem:AddHappyNewYearTreasureToPlayer(playerID, quality)
    local addTreasureName = ""
    local randomList = global_happy_new_year_quality[quality]
    
    if #randomList > 0 then
        local index = RandomInt(1, #randomList)
        addTreasureName = randomList[index]
    end
    if addTreasureName~="" then
        -- 添加到卡池
        local addTreasureIndex = self:get_treasure_id(addTreasureName)
        self:update_treasureinarchive_byID(playerID, addTreasureIndex, 1)
    end
    return addTreasureName
end


-- 获取一张对应名称的卡牌到玩家的卡池
function treasuresystem:AddTreasureToPlayerByName(playerID, addTreasureName)
    if addTreasureName~="" then
        -- 添加到卡池
        local addTreasureIndex = self:get_treasure_id(addTreasureName)
        self:update_treasureinarchive_byID(playerID, addTreasureIndex, 1)
    end
    return addTreasureName
end

-- 其他基础掉落配置
function treasuresystem:DropOtherTreasures()
    local randomIndex = RandomInt(1, #other_drop_treasures)
    local addTreasureName = nil
    if other_drop_treasures[randomIndex] then
        -- body
        addTreasureName = other_drop_treasures[randomIndex][1]
    end
    return addTreasureName
end

-- 高难度掉落配置
function treasuresystem:DropHardOtherTreasures()
    local randomIndex = RandomInt(1, #hard_other_drop_treasures)
    local addTreasureName = nil
    if hard_other_drop_treasures[randomIndex] then
        -- body
        addTreasureName = hard_other_drop_treasures[randomIndex][1]
    end
    return addTreasureName
end


-- 分解配置
local Resolve_config = {
    ["N"] = 10,
    ["R"] = 20,
    ["SR"] = 40,
    ["SSR"] = 80,
}

-- 箱子价格
local Box_cost_config = {
    ["R"] = 40,
    ["SR"] = 80,
    ["SSR"] = 160,
}

-- 宝物卡价格
local Treasures_cost_config = {
    ["N"] = 60,
    ["R"] = 120,
    ["SR"] = 240,
    ["SSR"] = 480,
}

-- 分解兑换的卡池
local Resolve_treasures = {
    -- 额外获取宝物
    {"modifier_treasure_wizardry_mask","R"},-- 巫术面具51
    {"modifier_treasure_rapid_bayonet","N"},-- 疾风之刺52
    {"modifier_treasure_rapid_dagger","R"},-- 疾风之匕53
    {"modifier_treasure_rapid_sword","SR"},-- 疾风之剑54
    {"modifier_treasure_titan_armet","N"},-- 泰坦头盔55
    {"modifier_treasure_titan_hammer","R"},-- 泰坦战锤56
    {"modifier_treasure_titan_shield","SR"},-- 泰坦神盾57
    {"modifier_treasure_abyss_orb","N"},-- 深渊宝珠58
    {"modifier_treasure_abyss_sceptre","R"},-- 深渊权杖59
    {"modifier_treasure_abyss_law","SR"},-- 深渊法典60
    {"modifier_treasure_dragon_king_come_back","SSR"},-- 龙王归来61
    {"modifier_treasure_nenglipengzhang","SSR"},-- 能力膨胀62
    {"modifier_treasure_so_long","N"},-- 听说名字取得长的宝物都很厉害63
    {"modifier_treasure_so_short","N"},-- 短64
    {"modifier_treasure_bloodthirster","N"},-- 饮血剑65
    {"modifier_treasure_bloodaxe","R"},-- 饮血斧66
    {"modifier_treasure_bloodknife","SR"},-- 饮血刀67
    -- {"modifier_treasure_intimidate","N"},-- 恫吓68
    {"modifier_treasure_turbulence_mana","SSR"},-- 法力乱流69
    {"modifier_treasure_five_thousand_exp","R"},-- 5000经验70
    {"modifier_treasure_holiday_beach_slippers","R"},-- 休假用品：沙滩拖鞋71
    {"modifier_treasure_holiday_sunglasses","R"},-- 休假用品：墨镜72
    {"modifier_treasure_holiday_icecola","R"},-- 休假用品：冰可乐73
    {"modifier_treasure_aghanim_scepter","R"},-- 阿哈利姆神杖74
    {"modifier_treasure_three_phase_power_s","R"},-- 三项碎片【上】75
    {"modifier_treasure_three_phase_power_a","R"},-- 三项碎片【中】76
    {"modifier_treasure_three_phase_power_i","R"},-- 三项碎片【下】77
    {"modifier_treasure_apocalypse_a","R"},-- 启示录【上】78
    {"modifier_treasure_apocalypse_b","R"},-- 启示录【中】79
    {"modifier_treasure_apocalypse_c","R"},-- 启示录【下】80

    {"modifier_treasure_taiji_disciples","N"},-- 太极门徒81
    {"modifier_treasure_taiji_intermediate","R"},-- 太极大师82
    {"modifier_treasure_taiji_master","SR"},-- 太极宗师83
    {"modifier_treasure_mhzl","R"},-- 蛮荒之力84
    {"modifier_treasure_ltzl","R"},-- 雷霆之力85
    {"modifier_treasure_xwzl","R"},-- 虚无之力86
    {"modifier_treasure_smallmoney","R"},-- 富二代87
    {"modifier_treasure_mhll","SR"},-- 蛮荒灵力88
    {"modifier_treasure_ltll","SR"},-- 雷霆灵力89
    {"modifier_treasure_xwll","SR"},-- 虚无灵力90
    {"modifier_treasure_moremoney","SR"},-- 大富翁91
    {"modifier_treasure_mhsl","SSR"},-- 蛮荒神力92
    {"modifier_treasure_ltsl","SSR"},-- 雷霆神力93
    {"modifier_treasure_xwsl","SSR"},-- 虚无神力94
    {"modifier_treasure_gfatmoney","SSR"},-- G胖的钱包95

    {"modifier_treasure_back_off_a","R"},-- 手动挡96
    {"modifier_treasure_back_off_b","R"},-- 自动挡97
    {"modifier_treasure_back_off_c","SSR"},-- 请注意,倒车98

    -- 春节新上的卡
    {"modifier_treasure_sublime_alchemist", "SSR"},--土豪升华卡99
    {"modifier_treasure_sublime_omniknight", "SSR"},--金蛋100
    {"modifier_treasure_sublime_phantom_assassin", "SSR"},--守望者101
    {"modifier_treasure_sublime_rattletrap", "SSR"},--坏心眼102
    {"modifier_treasure_sublime_shredder", "SSR"},--兵营103
    {"modifier_treasure_sublime_skeleton_king", "SSR"},--支援小炮104
    {"modifier_treasure_sublime_templar_assassin", "SSR"},--主角105
    {"modifier_treasure_sublime_treant", "SSR"},--代码哥106
    {"modifier_treasure_sublime_visage", "SSR"},--超级士兵107
    {"modifier_treasure_sublime_wisp", "SSR"},--黑洞108

    {"modifier_treasure_speed_fire", "R"},--109
    {"modifier_treasure_double_fire", "SR"},--110

    {"modifier_treasure_goldmon_attribute_one", "SR"},	--金币怪悬赏令111
    {"modifier_treasure_goldmon_attribute_two", "SR"},--	金币怪杀手112
    {"modifier_treasure_midas_collection", "SR"},--  迈达斯的珍藏113
    {"modifier_treasure_more", "R"},--  莫多114
    {"modifier_treasure_more_more", "SR"}, -- 莫多莫多115

    -- 王者套装
    {"modifier_treasure_king_brilliant", "R"},      -- 王者辉煌116
    {"modifier_treasure_king_glory", "SR"},         -- 王者荣耀117
}

local global_Resolve_treasures = {}

for key, value in pairs(Resolve_treasures) do
    if not global_Resolve_treasures[value[2]] then
        global_Resolve_treasures[value[2]] = {}
    end
    table.insert(global_Resolve_treasures[value[2]], value[1])
end

-- 分解宝物
function treasuresystem:OnResolveTreasure(evt)
    local playerID = evt.PlayerID
    local steam_id = PlayerResource:GetSteamAccountID(playerID)
    local treasurename = evt.name
    local isAll = evt.type
    local treasurIndex = treasuresystem:get_treasure_id(treasurename)
    local archivenumber = treasuresystem:get_treasurenumber_byID(playerID, treasurIndex)
    local hascollocation = treasuresystem:find_collocation_byID(playerID, treasurIndex)
    local resolveNumber = 0
    if hascollocation then
        -- 配置里面有, 则数量为0不能分解
        if archivenumber <= 0 then
            CustomGameEventManager:Send_ServerToPlayer(PlayerResource:GetPlayer(playerID),"response_errortext",{errortext = "error_noTreasureNumber"})
            return
        end
        if isAll==1 then
            -- 全部分解
            resolveNumber = archivenumber
        else
            -- 分解1个
            resolveNumber = 1
        end
    else
        -- 配置里面没有, 则数量为1不能分解
        if archivenumber <= 1 then
            CustomGameEventManager:Send_ServerToPlayer(PlayerResource:GetPlayer(playerID),"response_errortext",{errortext = "error_noTreasureNumber"})
            return
        end
        if isAll==1 then
            -- 全部分解
            resolveNumber = archivenumber-1
        else
            -- 分解1个
            resolveNumber = 1
        end
    end

    local quality = treasuresystem:get_treasure_quality(treasurIndex)
    local getNumber = Resolve_config[quality]*resolveNumber
    treasuresystem:update_treasureinarchive_byID(playerID, treasurIndex, -resolveNumber)
    game_playerinfo:update_chipNumber(steam_id, getNumber)

    archivenumber = treasuresystem:get_treasurenumber_byID(playerID, treasurIndex)
    hascollocation = treasuresystem:find_collocation_byID(playerID, treasurIndex)
    if hascollocation then
        archivenumber = archivenumber + 1
    end
    local treasures = {}
    table.insert(treasures, treasurename)
    table.insert(treasures, archivenumber)
    local send_table = {}
    table.insert(send_table, treasures)

    CustomGameEventManager:Send_ServerToPlayer(PlayerResource:GetPlayer(playerID), "response_resolve_treasure",{chipNumber = game_playerinfo:get_chipNumber(steam_id), treasures = send_table})
end

-- 购买对应品质的随机卡包或者直接兑换成卡
function treasuresystem:OnBuyQualityTreasure(evt)
    local playerID = evt.PlayerID
    local steam_id = PlayerResource:GetSteamAccountID(playerID)
    local openname = evt.name
    local nprize_list = {}
    if string.find(openname, "Gift") then
        local cost = 0
        -- 开启对应品级箱子
        -- print(" >>>>>>>>>>>>>>>>> openname: "..openname)
        if string.find(openname, "GiftR") then
            cost = Box_cost_config["R"]
            if cost > game_playerinfo:get_chipNumber(steam_id) then
                CustomGameEventManager:Send_ServerToPlayer(PlayerResource:GetPlayer(playerID),"response_errortext",{errortext = "error_noChipNumber"})
                return
            end
            chipGiftOfTheTreasure(playerID, 1, nprize_list)
        elseif string.find(openname, "GiftSR") then
            cost = Box_cost_config["SR"]
            if cost > game_playerinfo:get_chipNumber(steam_id) then
                CustomGameEventManager:Send_ServerToPlayer(PlayerResource:GetPlayer(playerID),"response_errortext",{errortext = "error_noChipNumber"})
                return
            end
            chipGiftOfTheTreasure(playerID, 2, nprize_list)
        elseif string.find(openname, "GiftSSR") then
            cost = Box_cost_config["SSR"]
            if cost > game_playerinfo:get_chipNumber(steam_id) then
                CustomGameEventManager:Send_ServerToPlayer(PlayerResource:GetPlayer(playerID),"response_errortext",{errortext = "error_noChipNumber"})
                return
            end
            chipGiftOfTheTreasure(playerID, 3, nprize_list)
        end
        if cost > 0 and #nprize_list > 0 then
            game_playerinfo:update_chipNumber(steam_id, -cost)
        end
    else
        -- 直接兑换对应宝物卡
        local treasurIndex = treasuresystem:get_treasure_id(openname)
        local quality = treasuresystem:get_treasure_quality(treasurIndex)
        local cost = Treasures_cost_config[quality]
        if cost > game_playerinfo:get_chipNumber(steam_id) then
            CustomGameEventManager:Send_ServerToPlayer(PlayerResource:GetPlayer(playerID),"response_errortext",{errortext = "error_noChipNumber"})
            return
        end
        local ExchangeList = Store:GetExchangeList()
        -- DeepPrintTable(ExchangeList)
        local isBuy = false
        -- 检测这个卡是否在允许兑换列表中
        for key, value in pairs(ExchangeList) do
            for index, name in pairs(value) do
                if name == openname then
                    isBuy = true
                    break
                end
            end
            if isBuy then
                break
            end
        end
        if not isBuy then
            return
        end
        
        if cost > 0 and cost <= game_playerinfo:get_chipNumber(steam_id) then
            treasuresystem:update_treasureinarchive_byID(playerID, treasurIndex, 1)
            game_playerinfo:update_chipNumber(steam_id, -cost)
            local sendtable = {}
            table.insert(sendtable, openname)
            table.insert(sendtable, 1)

            table.insert(nprize_list, sendtable)
        end
    end
    CustomGameEventManager:Send_ServerToPlayer(PlayerResource:GetPlayer(playerID),"UseItemCallback",{ prize_list = nprize_list})

    -- local send_treasures = self:group_treasuresex(playerID)

    -- CustomGameEventManager:Send_ServerToPlayer(PlayerResource:GetPlayer(playerID), "response_buyquality_treasure",{chipNumber = game_playerinfo:get_chipNumber(steam_id), treasures = send_treasures})

    -- DeepPrintTable(nprize_list)
    local send_table = {}
    for key, value in pairs(nprize_list) do
        if string.find(value[1], "modifier_treasure_") then
            local treasurIndex = treasuresystem:get_treasure_id(value[1])
            local number = treasuresystem:get_treasurenumber_byID(playerID, treasurIndex)
            local hascollocation = treasuresystem:find_collocation_byID(playerID, treasurIndex)
            local quality = treasuresystem:get_treasure_quality(treasurIndex)
            if hascollocation then
                number = number + 1
            end
            local treasures = {}
            table.insert(treasures, value[1])
            table.insert(treasures, number)
            table.insert(treasures, quality)

            table.insert(send_table, treasures)
        elseif value[1] == "score" then
            game_playerinfo:update_score(steam_id, value[2])
        end
    end
    -- DeepPrintTable(send_table)
    CustomGameEventManager:Send_ServerToPlayer(PlayerResource:GetPlayer(playerID), "response_resolve_treasure",{chipNumber = game_playerinfo:get_chipNumber(steam_id), treasures = send_table})
    -- 对应存档
    game_playerinfo:save_resolveby_playerid(playerID)
end


-- 碎片换卡
function treasuresystem:AddChipTreasureToPlayer(playerID, quality)
    local addTreasureName = ""
    local randomList = global_Resolve_treasures[quality]
    -- print(" >>>>>>>>>>>>>>>>> quality: "..quality)
    if #randomList > 0 then
        local index = RandomInt(1, #randomList)
        addTreasureName = randomList[index]
    end
    if addTreasureName~="" then
        -- 添加到卡池
        local addTreasureIndex = self:get_treasure_id(addTreasureName)
        self:update_treasureinarchive_byID(playerID, addTreasureIndex, 1)
    end
    return addTreasureName
end

-- 宝物碎片抽奖
function chipGiftOfTheTreasure(playerID, level, prize_list)
    local steam_id = PlayerResource:GetSteamAccountID(playerID)
    -- print(" >>>>>>>>>>>>>>>>>>>>>> level: "..level)
    if level==1 then
        -- 兑换宝物卡概率
        if RollPercentage(30) then
            -- 出R
            local card_name = treasuresystem:AddChipTreasureToPlayer(playerID, "R")
            local sendtable = {}
            table.insert(sendtable, card_name)
            table.insert(sendtable, 1)

            table.insert(prize_list, sendtable)
        else
            -- 出N
            local card_name = treasuresystem:AddChipTreasureToPlayer(playerID, "N")
            local sendtable = {}
            table.insert(sendtable, card_name)
            table.insert(sendtable, 1)

            table.insert(prize_list, sendtable)
        end

        if RollPercentage(30) then
            if RollPercentage(30) then
                -- 出R
                local card_name = treasuresystem:AddChipTreasureToPlayer(playerID, "R")
                local sendtable = {}
                table.insert(sendtable, card_name)
                table.insert(sendtable, 1)
    
                table.insert(prize_list, sendtable)
            else
                -- 出N
                local card_name = treasuresystem:AddChipTreasureToPlayer(playerID, "N")
                local sendtable = {}
                table.insert(sendtable, card_name)
                table.insert(sendtable, 1)
    
                table.insert(prize_list, sendtable)
            end
        else
            -- 遗物经验,钻石,宝物碎片
            local randint = RandomInt(1, 100)
            if 1 <= randint and randint <= 20 then
                local exp = RandomInt(250, 350)
                game_playerinfo:rewardsrelicsExp(steam_id, exp, prize_list)
            elseif 20 < randint and randint <= 30 then
                local exp = RandomInt(400, 500)
                game_playerinfo:rewardsrelicsExp(steam_id, exp, prize_list)
            elseif 30 < randint and randint <= 50 then
                local zs = RandomInt(5000, 6000)
                game_playerinfo:rewardsDiamond(steam_id, zs, prize_list)
            elseif 50 < randint and randint <= 60 then
                local zs = RandomInt(7000, 8000)
                game_playerinfo:rewardsDiamond(steam_id, zs, prize_list)
            elseif 60 < randint and randint <= 90 then
                local cp = RandomInt(2, 5)
                game_playerinfo:rewardschipNumber(steam_id, cp, prize_list)
            else
                local cp = RandomInt(5, 10)
                game_playerinfo:rewardschipNumber(steam_id, cp, prize_list)
            end
        end
    elseif level==2 then
        -- 兑换宝物卡概率
        if RollPercentage(30) then
            -- 出SR
            local card_name = treasuresystem:AddChipTreasureToPlayer(playerID, "SR")
            local sendtable = {}
            table.insert(sendtable, card_name)
            table.insert(sendtable, 1)

            table.insert(prize_list, sendtable)
        else
            -- 出R
            local card_name = treasuresystem:AddChipTreasureToPlayer(playerID, "R")
            local sendtable = {}
            table.insert(sendtable, card_name)
            table.insert(sendtable, 1)

            table.insert(prize_list, sendtable)
        end

        if RollPercentage(30) then
            if RollPercentage(30) then
                -- 出SR
                local card_name = treasuresystem:AddChipTreasureToPlayer(playerID, "SR")
                local sendtable = {}
                table.insert(sendtable, card_name)
                table.insert(sendtable, 1)
    
                table.insert(prize_list, sendtable)
            else
                -- 出R
                local card_name = treasuresystem:AddChipTreasureToPlayer(playerID, "R")
                local sendtable = {}
                table.insert(sendtable, card_name)
                table.insert(sendtable, 1)
    
                table.insert(prize_list, sendtable)
            end
        else
            -- 遗物经验,钻石,宝物碎片
            local randint = RandomInt(1, 100)
            if 1 <= randint and randint <= 20 then
                local exp = RandomInt(400, 500)
                game_playerinfo:rewardsrelicsExp(steam_id, exp, prize_list)
            elseif 20 < randint and randint <= 30 then
                local exp = RandomInt(500, 600)
                game_playerinfo:rewardsrelicsExp(steam_id, exp, prize_list)
            elseif 30 < randint and randint <= 50 then
                local zs = RandomInt(7000, 8000)
                game_playerinfo:rewardsDiamond(steam_id, zs, prize_list)
            elseif 50 < randint and randint <= 60 then
                local zs = RandomInt(10000, 15000)
                game_playerinfo:rewardsDiamond(steam_id, zs, prize_list)
            elseif 60 < randint and randint <= 90 then
                local cp = RandomInt(5, 10)
                game_playerinfo:rewardschipNumber(steam_id, cp, prize_list)
            else
                local cp = RandomInt(10, 20)
                game_playerinfo:rewardschipNumber(steam_id, cp, prize_list)
            end
        end
    elseif level==3 then
        -- 兑换宝物卡概率
        if RollPercentage(15) then
            -- 出SSR
            local card_name = treasuresystem:AddChipTreasureToPlayer(playerID, "SSR")
            local sendtable = {}
            table.insert(sendtable, card_name)
            table.insert(sendtable, 1)

            table.insert(prize_list, sendtable)
        else
            -- 出SR
            local card_name = treasuresystem:AddChipTreasureToPlayer(playerID, "SR")
            local sendtable = {}
            table.insert(sendtable, card_name)
            table.insert(sendtable, 1)

            table.insert(prize_list, sendtable)
        end

        if RollPercentage(30) then
            if RollPercentage(30) then
                -- 出SSR
                local card_name = treasuresystem:AddChipTreasureToPlayer(playerID, "SSR")
                local sendtable = {}
                table.insert(sendtable, card_name)
                table.insert(sendtable, 1)
    
                table.insert(prize_list, sendtable)
            else
                -- 出SR
                local card_name = treasuresystem:AddChipTreasureToPlayer(playerID, "SR")
                local sendtable = {}
                table.insert(sendtable, card_name)
                table.insert(sendtable, 1)
    
                table.insert(prize_list, sendtable)
            end
        else
            -- 遗物经验,钻石,宝物碎片
            local randint = RandomInt(1, 100)
            if 1 <= randint and randint <= 20 then
                local exp = RandomInt(500, 600)
                game_playerinfo:rewardsrelicsExp(steam_id, exp, prize_list)
            elseif 20 < randint and randint <= 30 then
                local exp = RandomInt(800, 900)
                game_playerinfo:rewardsrelicsExp(steam_id, exp, prize_list)
            elseif 30 < randint and randint <= 50 then
                local zs = RandomInt(10000, 15000)
                game_playerinfo:rewardsDiamond(steam_id, zs, prize_list)
            elseif 50 < randint and randint <= 60 then
                local zs = RandomInt(20000, 25000)
                game_playerinfo:rewardsDiamond(steam_id, zs, prize_list)
            elseif 60 < randint and randint <= 90 then
                local cp = RandomInt(10, 20)
                game_playerinfo:rewardschipNumber(steam_id, cp, prize_list)
            else
                local cp = RandomInt(20, 40)
                game_playerinfo:rewardschipNumber(steam_id, cp, prize_list)
            end
        end
    end
end