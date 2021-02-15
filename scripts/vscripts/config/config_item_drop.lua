if config_item_drop == nil then 
    config_item_drop=class({})
end
-- 随机范围0-1
local drop_table = {
    --小怪
    ["npc_xiaoguai"]= {
        {
            ["ItemSets"]={
                {"item_book_initiative_d",0.01,1},
                {"item_book_passive_d",0.01,1},
            },
            ["addCommon"]=true,
        },
        {
            ["ItemSets"]={
                {"item_book_passive_b", 0.001,1},
                {"item_book_passive_c",0.002,1},
                {"item_book_initiative_b",0.005,1},
                {"item_book_initiative_c",0.005,1},
            },
            ["addCommon"]=true,
        },
        {
            ["ItemSets"]={
                {"item_book_passive_b",0.002,1},
                {"item_book_passive_a",0.0006,1},
                {"item_book_passive_s",0.0002,1},
                {"item_book_initiative_b",0.002,1},
                {"item_book_initiative_a",0.0006,1},
                {"item_book_initiative_s",0.0002,1},
            },
            ["addCommon"]=true,
        }
    },
    --boss
    ["npc_boss"]= {
        {
            ["ItemSets"]={
                {"item_add_strength",1,1},
                {"item_add_agility",1,1},
                {"item_add_intellect",1,1},
                -- {"itemCallMaterialsLefthand",0.1,1},
                -- {"itemCallMaterialsRighthand",0.1,1},
                -- {"itemCallMaterialsEyes",0.1,1},
                -- {"itemCallMaterialsSoul",0.1,1},
                -- {"itemCallMaterialsHeart",0.1,1},
            },
            ["addCommon"]=false,
        },
    },
    --任务怪
    ["npc_dota_creature_creep_roshan_2"] = {
        {
            ["ItemSets"]={
                {"item_add_strength",1,1},
                {"item_add_agility",1,1},
                {"item_add_intellect",1,1},
            },
            ["addCommon"]=false,
        },
    },
    -- ["task_golem"] = {
    --     {
    --         ["ItemSets"]={
    --             {"item_custom_gold_necklace",1},
    --         },
    --         ["Multiple"]=1,
    --         ["addCommon"]=false,
    --     },
    -- },
    ["task_box"] = {
        {
            ["ItemSets"]={
                {"item_custom_gold_rod_4",1,1},
            },
            ["addCommon"]=false,
        },
    },
    --世界boss
    ["world_boss"]= {
        {
            ["ItemSets"]={
                {"item_add_strength",1,1},
                {"item_add_agility",1,1},
                {"item_add_intellect",1,1},
            },
            ["Multiple"]=0,
            ["extraDrop"]={
                {"item_world_boss",1,1},
            },
            ["ExtMultiple"]=1,
            ["addCommon"]=false,
        },
    },
    
}

--公共掉落物品
local common_drop_item = {
    {"item_custom_regeneration01",0.004,1},
    {"item_custom_rune_haste01",0.004,1},
    {"item_rune_gold",0.004,1},
    {"item_rune_magice",0.004,1},
    {"item_rune_yinshen",0.004,1},
    {"item_rune_double",0.004,1},
    {"item_rune_speed",0.004,1},
    {"heroEquipmentHead",0.0006,1},
    {"heroEquipmentArmor",0.0006,1},
    {"heroEquipmentLegguard",0.0006,1},
    {"heroEquipmentLeg",0.0006,1},
    {"heroEquipmentShoes",0.0006,1},
    {"heroEquipmentMainweapon",0.0006,1},
    {"heroEquipmentSpeciaiweapon",0.0006,1},
    -- {"itemCallMaterialsLefthand",0.0025,1},
    -- {"itemCallMaterialsRighthand",0.0025,1},
    -- {"itemCallMaterialsEyes",0.0025,1},
    -- {"itemCallMaterialsSoul",0.0025,1},
    -- {"itemCallMaterialsHeart",0.0025,1},
} 

--福娃随机神符
local common_drop_rune = {
    {"item_custom_rune_haste01",0.004,1},
    {"item_rune_gold",0.004,1},
    {"item_rune_magice",0.004,1},
    {"item_rune_yinshen",0.004,1},
    {"item_rune_double",0.004,1},
    {"item_rune_speed",0.004,1},
} 


function config_item_drop:init()
    for i,v in pairs(drop_table) do 
        for j ,vi in pairs(v) do
            if vi.addCommon then 
                local npc_drop_info = vi.ItemSets
                for k,vj in pairs(common_drop_item) do
                    table.insert(npc_drop_info,vj)
                end
            end
        end
    end
end

function config_item_drop:get_random_rune_name()
    local rand = RandomInt(1,#common_drop_rune)
    return common_drop_rune[rand][1]
end

function config_item_drop:get_drop_table(unit_name,index)
    if drop_table[unit_name] then 
        if drop_table[unit_name][index] then
            return  drop_table[unit_name][index]   
        else
            return  drop_table[unit_name][1]   
        end
        
    end
end

function config_item_drop:get_common_drop()
    return common_drop_item
end

--许愿蛋随机道具
local xuyuan_drop_item = {
    "item_red_bottle_large_egg",
    "item_blue_bottle_large_egg",
    "item_blue_bottle_moment_egg",
} 

function config_item_drop:get_xuyuan_random_name()
    local rand = RandomInt(1,#xuyuan_drop_item)
    return xuyuan_drop_item[rand]
end

--神职天赋随机掉落的天赋技能
local innateskill_drop_item = {
    {
        "siwan_zhili_lua",     -- 死亡之力
        "yanbao_lua",     -- 尸爆
        -- "bukezhansheng_lua",     --我们老干爹是不可战胜的
    },
    {
        "passive_purification",     --圣光照射
        "lilian_lua",     --历练
        "jiangdi_fangyu_lua",     --NMYSL
        "yu_zhan_yu_yong",     --愈战愈勇
        "return_datadriven",     --铁甲反伤
        "touzhi_hongzha_lua",     --投掷轰炸
    },
    {
        "wofang_fuzhu_lua",     --都闪开，我去下路保敌法
        "blueflash_blink_datadriven",     --闪烁
        -- "ambulance_lua",     --救护车
        -- "kaishi_kaoshi",     --开始考试
        -- "ragged_moneybag",     --破洞的钱袋
        "i_am_carray",     --队友由我罩
        "sex_assassin",     --疾
        "tancai_lua",     --贪财不可耻
        "yinyueyongshi",   --萨特爸爸
    },
}

function config_item_drop:get_innateskill_drop_item()
    return innateskill_drop_item
end