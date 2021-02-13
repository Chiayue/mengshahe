require("config/config_item")

if item_custom_gold_necklace == nil then 
    item_custom_gold_necklace = class({})
end


function use_item(params)
    local caster = params.caster;
    local hero
    if caster:IsHero() then 
        hero = caster
    else
        hero = caster:GetOwner()
    end
    local player_id = hero:GetPlayerID()
    local steam_id = PlayerResource:GetSteamAccountID(player_id)
    local ramdom_property = game_playerinfo:random_properties()
    local key = ramdom_property[1]
    local value = ramdom_property[2]
    -- local item_name = params.ability:GetAbilityName()
    game_playerinfo:set_dynamic_properties(steam_id, key, value)
    --双属性额外设值
    if key == "attack_and_move" then
        game_playerinfo:set_dynamic_properties(steam_id, "extra_attack_speed", 80)
        game_playerinfo:set_dynamic_properties(steam_id, "move_speed", 100)
    end
    hero.dynamic_properties = game_playerinfo:get_dynamic_properties(steam_id)
    --所有属性加成
    CustomNetTables:SetTableValue("dynamic_properties","bead"..hero:GetEntityIndex(),hero.dynamic_properties)
    -- ParticleManager:CreateParticle( "particles/econ/courier/courier_donkey_ti7/courier_donkey_ti7_ambient_omni.vpcf", PATTACH_ABSORIGIN_FOLLOW, hero )
    --记录随机属性 
    local table_key = "player_"..player_id
    local random_properties = CustomNetTables:GetTableValue( "random_properties", table_key )
    if not random_properties then 
        random_properties = {}
    end
     local new_value 
    if random_properties[key] then 
        if key == "reduce_attack_scale" and (random_properties[key] + value>80) then
            new_value = 80
        else
            new_value = random_properties[key] + value
        end
    else
        new_value = value
    end
    random_properties[key] = new_value
    CustomNetTables:SetTableValue( "random_properties", table_key, random_properties)
    UTIL_RemoveImmediate(params.ability)
end