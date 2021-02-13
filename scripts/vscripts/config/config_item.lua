if config_item ==nil then 
    config_item=class({})
end
local gold_rod = {
    ["item_custom_gold_rod_0"]= {
        ["kill_num"]=400,
        ["add_pop_min"]=10,
        ["add_pop_max"]=30,
        ["gain_gold_min"]=5000,
        ["gain_gold_max"]=10000,
        ["gain_gold_speed"]=10,
    },
    ["item_custom_gold_rod_1"] = {
        ["kill_num"]=400,
        ["add_pop_min"]=15,
        ["add_pop_max"]=35,
        ["gain_gold_min"]=6000,
        ["gain_gold_max"]=11000,
        ["gain_gold_speed"]=15,
    },
    ["item_custom_gold_rod_2"] = {
        ["kill_num"]=400,
        ["add_pop_min"]=20,
        ["add_pop_max"]=40,
        ["gain_gold_min"]=7000,
        ["gain_gold_max"]=12000,
        ["gain_gold_speed"]=20,
    },
    ["item_custom_gold_rod_3"] = {
        ["kill_num"]=400,
        ["add_pop_min"]=25,
        ["add_pop_max"]=50,
        ["gain_gold_min"]=8000,
        ["gain_gold_max"]=13000,
        ["gain_gold_speed"]=25,
    },
    ["item_custom_gold_rod_4"] = {
        ["kill_num"]=400,
        ["add_pop_min"]=35,
        ["add_pop_max"]=60,
        ["gain_gold_min"]=9000,
        ["gain_gold_max"]=14000,
        ["gain_gold_speed"]=30,
    },
}



--碎片阶梯等级加成信息
local bead_add_config = {
    -- 生命回复百分比
    ["heroEquipmentSpeciaiweapon"] = {2, 4, 8, 16, 32,},
    -- 攻击力百分比
    ["heroEquipmentMainweapon"] = {2, 4, 8, 16, 32,},
    -- 护甲
    ["heroEquipmentArmor"] = {2, 4, 8, 16, 32,},
    -- 额外真实伤害
    ["heroEquipmentLegguard"] = {100, 200, 400, 800, 1600, },
    -- 敏捷百分比
    ["heroEquipmentShoes"] = {1, 2, 4, 8, 16},
    -- 智力百分比
    ["heroEquipmentLeg"] = {1, 2, 4, 8, 16},
    -- 力量百分比
    ["heroEquipmentHead"] = {1, 2, 4, 8, 16},
}

--碎片每次升级加成信息
local bead_add_eachlevel_config = {
    -- 吸血
    ["heroEquipmentSpeciaiweapon"] = {
        4,6,8,10,12,
    },
    -- 攻击力
    ["heroEquipmentMainweapon"] = {
        40,50,60,70,80,
    },
    -- 减伤
    ["heroEquipmentArmor"] = {
        5,8,11,14,17,
    },
    -- 额外物理伤害
    ["heroEquipmentLegguard"] = {
        50,70,90,110,130,
    },
    -- 敏捷
    ["heroEquipmentShoes"] = {
        3,5,7,9,11,
    },
    -- 智力
    ["heroEquipmentLeg"] = {
        3,5,7,9,11,
    },
    -- 力量
    ["heroEquipmentHead"] = {
        3,5,7,9,11,
    },
}

--属性基础加成关系表
local dynamic_properties_table = {
    ["heroEquipmentSpeciaiweapon"] = "attack_heal",
    ["heroEquipmentMainweapon"] = "add_baseattack",
    ["heroEquipmentArmor"] = "reduce_attack_point",
    ["heroEquipmentLegguard"] = "extra_attack_physics",
    ["heroEquipmentShoes"] = "add_agility",
    ["heroEquipmentLeg"] = "add_intellect",
    ["heroEquipmentHead"] = "add_strength",
}

--属性等级阶梯加成关系表
local dynamic_properties_ladder_table = {
    ["heroEquipmentSpeciaiweapon"] = "percent_regen_heal",
    ["heroEquipmentMainweapon"] = "physics_attack_scale",
    ["heroEquipmentArmor"] = "add_armor",
    ["heroEquipmentLegguard"] = "extra_attack_pure",
    ["heroEquipmentShoes"] = "add_agility_scale",
    ["heroEquipmentLeg"] = "add_intellect_scale",
    ["heroEquipmentHead"] = "add_strength_scale",
}

local item_up_cost = {
    ["level_1"]=1000,
    ["level_2"]=2500,
    ["level_3"]=10000,
    ["level_4"]=20000,
    ["level_5"]=50000,
    ["level_up_1"]=5000,
    ["level_up_2"]=10000,
    ["level_up_3"]=20000,
    ["level_up_4"]=100000,
    ["level_up_5"]=99999,
}

function config_item:get_gold_rod()
    return gold_rod
end



-- function config_item:get_wood_item_price(item)
--     return wood_item_price[item]
-- end


function config_item:get_item_up_cost(key,is_up)
    if is_up then 
        return item_up_cost["level_up_"..key]
    else
        return item_up_cost["level_"..key]
    end
end

function config_item:get_bead_add_config()
    return bead_add_config;
end

function config_item:get_bead_add_config_by_stage(item, stage)
    local properties = 0
    for i = 1, stage do
        properties = properties + bead_add_config[item][i]
    end
    return properties;
end

function config_item:get_bead_add_eachlevel_config(item, stage)
    -- print(" >>>>>>>>>>>>>>>>> item: "..item)
    -- print(" >>>>>>>>>>>>>>>>> stage: "..stage)
    -- DeepPrintTable(bead_add_eachlevel_config)
    return bead_add_eachlevel_config[item][stage];
end

function config_item:get_dynamic_properties_value(item)
    return dynamic_properties_table[item];
end

function config_item:get_dynamic_properties_ladder_value(item)
    return dynamic_properties_ladder_table[item];
end

---------------- 图腾升级需求碎片配置
local totem_unlock_config = {
    ["totemCf"] = 4,
    ["totemDz"] = 4,
    ["totemDj"] = 3,
    ["totemSj"] = 4,
    ["totemSw"] = 3,
    ["totemYx"] = 3,
    ["totemBw"] = 6,
    ["totemJh"] = 6,
    ["totemZf"] = 4,
    ["totemMl"] = 4,
    ["totemSm"] = 4,
    ["totemSd"] = 4,
    ["totemMh"] = 4,
    ["totemAy"] = 4,
    ["totemFy"] = 3,
}

local totem_levelup_config = {
    2,3,4,5,6,7,8,9,10,11
}

-- 图腾升级所需经验
function config_item:get_totem_need_number(totemName, level)
    local needNumber = 0
    if level == -1 then
        -- body
        needNumber = totem_unlock_config[totemName]
    elseif level < 50 then
        needNumber = totem_levelup_config[math.floor(level/5) + 1]
    end
    
    return needNumber
end

local totem_stage_add = {
    ["totemCf"] = {2, 4, 8, 16, 32,},
    ["totemDz"] = {1, 2, 4, 8, 16,},
    ["totemDj"] = {2, 4, 8, 16, 32,},
    ["totemSj"] = {5, 10, 20, 40, 80,},
    ["totemZf"] = {1, 2, 4, 8, 16,},
    ["totemMl"] = {2, 4, 8, 16, 32,},
    ["totemSm"] = {2, 4, 8, 16, 32,},
    ["totemSd"] = {1, 2, 4, 8, 16,},
    ["totemMh"] = {3, 6, 12, 24, 48,},
    ["totemAy"] = {2, 4, 8, 16, 32,},
    ["totemFy"] = {5, 10, 15, 20, 25,},
    ["totemJh"] = {1, 2, 4, 8, 16,},
}

-- 返回当前阶段
function config_item:totem_stage_add(item, stage)
    if stage == 0 then
        -- body
        return 0
    end
    return totem_stage_add[item][stage];
end

function config_item:get_totem_alladd_by_stage(item, stage)
    if stage == 0 then
        -- body
        return 0
    end
    local properties = 0
    for i = 1, stage do
        properties = properties + totem_stage_add[item][i]
    end
    return properties;
end