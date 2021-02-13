require("global/global_var_func")
if drop_config == nil then
    drop_config = ({})
end

local drop_table = {
    [global_var_func.flag_creep.."_1"]={
        ["ItemSet"]={
            {"item_book_initiative_d",0.01},
            {"item_book_passive_d",0.01},
        },
        ["Multiple"]=1,
        ["DropLimit"]=-1,
        ["common_drop"] = {"rune","fragment","callMaterial","attributeBook"},
    },
    [global_var_func.flag_creep.."_2"]={
        ["ItemSet"]={
            {"item_book_passive_b",0.0014},
            {"item_book_passive_c",0.0028},
            {"item_book_initiative_b",0.0014},
            {"item_book_initiative_c",0.0028},
            -- {"item_book_chaos_b",0.0014},
            -- {"item_book_chaos_c",0.0028},
        },
        ["Multiple"]=1,
        ["DropLimit"]=-1,
        ["common_drop"] = {"rune","fragment","callMaterial","attributeBook"},
    },
    [global_var_func.flag_creep.."_3"]={
        ["ItemSet"]={
            {"item_book_passive_b",0.0014},
            {"item_book_passive_a",0.0003},
            {"item_book_passive_s",0.0001},
            {"item_book_initiative_b",0.0014},
            {"item_book_initiative_a",0.0003},
            {"item_book_initiative_s",0.0001},
            -- {"item_book_chaos_b",0.0014},
            -- {"item_book_chaos_a",0.0003},
            -- {"item_book_chaos_s",0.0001},
        },
        ["Multiple"]=1,
        ["DropLimit"]=-1,
        ["common_drop"] = {"rune","fragment","callMaterial","attributeBook"},
    },
    [global_var_func.flag_boss_general]={
        ["ItemSet"]={
            {"item_add_strength_1",0.12},
            {"item_add_strength_2",0.06},
            {"item_add_strength_3",0.02},
            {"item_add_agility_1",0.12},
            {"item_add_agility_2",0.06},
            {"item_add_agility_3",0.02},
            {"item_add_intellect_1",0.12},
            {"item_add_intellect_2",0.06},
            {"item_add_intellect_3",0.02},
            {"item_add_health_1",0.12},
            {"item_add_health_2",0.06},
            {"item_add_health_3",0.02},
            {"item_add_aggressivity_1",0.12},
            {"item_add_aggressivity_1",0.06},
            {"item_add_aggressivity_1",0.02},
        },
        ["Multiple"]=99,
        ["DropLimit"]=10,
    },
    [global_var_func.flag_boss_finally]={
        ["ItemSet"]={
        },
        ["Multiple"]=1,
        ["DropLimit"]=-1,
    },
    -- [global_var_func.flag_creep_jk]={
    --     ["ItemSet"]={
    --         {"item_custom_gold_rod_4",1},
    --     },
    --     ["Multiple"]=1,
    --     ["DropLimit"]=-1,
    -- },
    [global_var_func.flag_boss_call_difficulty_1]={
        ["ItemSet"]={
            {"item_box_bronze", 1},
        },
        ["Multiple"]=1,
        ["DropLimit"]=-1,
    },
    [global_var_func.flag_boss_call_difficulty_2]={
        ["ItemSet"]={
            {"item_box_silver", 1},
        },
        ["Multiple"]=1,
        ["DropLimit"]=-1,
    },
    [global_var_func.flag_boss_call_difficulty_3]={
        ["ItemSet"]={
            {"item_box_gold", 1},
        },
        ["Multiple"]=1,
        ["DropLimit"]=-1,
    },
    [global_var_func.flag_boss_talent]={
        ["ItemSet"]={
            {"item_book_innateskill", 1},
        },
        ["Multiple"]=1,
        ["DropLimit"]=-1,
    },
}

drop_config.rune = {
    {"item_custom_regeneration01",0.0002},
    {"item_custom_rune_haste01",0.0002},
    {"item_rune_gold",0.0002},
    {"item_rune_magice",0.0002},
    {"item_rune_yinshen",0.0002},
    {"item_rune_double",0.0002},
    {"item_rune_speed",0.0002},
}

drop_config.fragment = {
    {"heroEquipmentHead",0.0006},
    {"heroEquipmentArmor",0.0006},
    {"heroEquipmentLegguard",0.0006},
    {"heroEquipmentLeg",0.0006},
    {"heroEquipmentShoes",0.0006},
    {"heroEquipmentMainweapon",0.0006},
    {"heroEquipmentSpeciaiweapon",0.0006},
}

drop_config.callMaterial={
    {"itemCallMaterialsHeart",0.005},
    {"itemCallMaterialsEyes",0.005},
    {"itemCallMaterialsSoul",0.005},
}
drop_config.attributeBook = {
    {"item_add_strength_1",0.0018},
    {"item_add_strength_2",0.0006},
    {"item_add_strength_3",0.0001},
    {"item_add_agility_1",0.0018},
    {"item_add_agility_2",0.0006},
    {"item_add_agility_3",0.0001},
    {"item_add_intellect_1",0.0018},
    {"item_add_intellect_2",0.0006},
    {"item_add_intellect_3",0.0001},
    {"item_add_health_1",0.0018},
    {"item_add_health_2",0.0006},
    {"item_add_health_3",0.0001},
    {"item_add_aggressivity_1",0.0018},
    {"item_add_aggressivity_1",0.0006},
    {"item_add_aggressivity_1",0.0001},
}
function drop_config:GetDropTable(key)
    return drop_table[key]
end

function drop_config:GetCommonDrop(key)
    return drop_config[key]
end

--许愿蛋随机道具
local xuyuan_drop_item = {
    "item_red_bottle_large_egg",
    "item_blue_bottle_large_egg",
    "item_blue_bottle_moment_egg",
} 

function drop_config:get_xuyuan_random_name()
    local rand = RandomInt(1,#xuyuan_drop_item)
    return xuyuan_drop_item[rand]
end

function drop_config:get_random_rune_name()
    local rand = RandomInt(1,#drop_config.rune)
    return drop_config.rune[rand][1]
end
