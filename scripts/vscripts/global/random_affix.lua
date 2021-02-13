require("herolist")
require("heroabilitylist")

-- 储存全局变量和全局函数
if random_affix == nil then
    random_affix = class({})
end

local random_affix_modifier = {
    ["front"] = {
        "modifier_prefix_anubis_lua",
        "modifier_prefix_ra_lua",
        "modifier_prefix_amon_lua",
        "modifier_prefix_horus_lua",
        "modifier_prefix_osiris_lua",
    },
    ["back"] = {
        "modifier_suffix_desert_lua",
        "modifier_suffix_earth_lua",
        "modifier_suffix_forest_lua",
        "modifier_suffix_sky_lua",
    }
}

function random_affix:get_random_affix(type)
    if type == "f" then
        -- 前缀
        local frontaffix = nil
        if #random_affix_modifier.front >= 1 then
            local randint = RandomInt(1, #random_affix_modifier.front)
            frontaffix = random_affix_modifier.front[randint]
        end
        return frontaffix
    else
        -- 后缀
        local backaffix = nil
        if #random_affix_modifier.back >= 1 then
            local randint = RandomInt(1, #random_affix_modifier.back)
            backaffix = random_affix_modifier.back[randint]
        end
        return backaffix
    end
end

function random_affix:AddNewRandomModifier(hero, ability, parameter, type)
    local modifierName = self:get_random_affix(type)
    hero:AddNewModifier(hero, ability, modifierName, parameter)
    return modifierName
end

-- 激活层数(2,3), 玩家ID, 技能名称, 词缀类型(1前缀2后缀), 修改器名称
function random_affix:show_fix_description(StackCount, playerID, ability_name, fixtype, modifierName)
    -- 刷新
    if StackCount == 1 then
        local ability_tab = {
            fix_name = modifierName.."_".."unactivate",
            fix_Description_1 = modifierName.."_".."unactivate".."_Description_1",
            fix_Description_2 = modifierName.."_".."unactivate".."_Description_2",
        }
        -- print(playerID.."_"..ability_name.."_"..fixtype)
        CustomNetTables:SetTableValue("player_data_table",playerID.."_"..ability_name.."_"..fixtype,ability_tab)
    elseif StackCount == 2 then
        local ability_tab = {
            fix_name = modifierName.."_".."activate",
            fix_Description_1 = modifierName.."_".."activate".."_Description_1",
            fix_Description_2 = modifierName.."_".."unactivate".."_Description_2",
        }
        -- print(playerID.."_"..ability_name.."_"..fixtype)
        CustomNetTables:SetTableValue("player_data_table",playerID.."_"..ability_name.."_"..fixtype,ability_tab)
    elseif StackCount == 3 then
        local ability_tab = {
            fix_name = modifierName.."_".."activate",
            fix_Description_1 = modifierName.."_".."activate".."_Description_1",
            fix_Description_2 = modifierName.."_".."activate".."_Description_2",
        }
        -- print(playerID.."_"..ability_name.."_"..fixtype)
        CustomNetTables:SetTableValue("player_data_table",playerID.."_"..ability_name.."_"..fixtype,ability_tab)
    end
end

-- 更新英雄天赋升华显示
function random_affix:show_hero_subliming_description(playerID, ability_name, modifierName)
    
end