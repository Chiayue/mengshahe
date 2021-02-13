require("items/lua_items_ability/item_ability")
require("info/game_playerinfo")
if Filter == nil then 
    Filter = ({})
end

-- function Filter:ModifyGoldFilter( params )
--     game_playerinfo:get_player_gold(params.player_id_const)
-- 	return true
-- end
-- function Filter:init()

-- end
local book_purchase_record = {}

function Filter:ExecuteOrderFilter(params)
    -- print(">>>>>>>>>>>>>>>>>>>>>>>>>> ExecuteOrderFilter: ")
    -- DeepPrintTable(params)
    local player_id = params.issuer_player_id_const
    -- local hero = PlayerResource:GetPlayer(player_id):GetAssignedHero()
    local order_type = params.order_type
    if order_type == DOTA_UNIT_ORDER_PURCHASE_ITEM  then
     
    elseif order_type == DOTA_UNIT_ORDER_SELL_ITEM  then
        local entity = EntIndexToHScript(params.entindex_ability)
        local item_amount = entity:GetCurrentCharges() or 1
        local gain_gold
        local hero = PlayerResource:GetPlayer(player_id):GetAssignedHero()
        if not hero:IsAlive() then
            return
        end
        -- if hero:GetUnitName() == "npc_dota_hero_keeper_of_the_light" then
            gain_gold = entity:GetCost() * 0.3 * item_amount
        -- else
            -- gain_gold = entity:GetCost()/2 * item_amount
        -- end
        game_playerinfo:set_player_gold(player_id, gain_gold)
    elseif order_type == DOTA_UNIT_ORDER_CAST_POSITION or
            order_type == DOTA_UNIT_ORDER_CAST_TARGET or
            order_type == DOTA_UNIT_ORDER_CAST_TARGET_TREE or
            order_type == DOTA_UNIT_ORDER_CAST_NO_TARGET or
            order_type == DOTA_UNIT_ORDER_CAST_TOGGLE then 
        local entity = EntIndexToHScript(params.entindex_ability)
        if not entity then
            return true
        end
        --奥术
        local hero = PlayerResource:GetPlayer(player_id):GetAssignedHero()
        if hero:HasModifier("modifier_item_rune_magice") then
            hero:GiveMana(entity:GetManaCost(-1) * 0.2)
        end
        local ent_name = entity:GetName()
        if ent_name == "item_more_and_more" or
            ent_name == "item_blue_bottle_small" or
            ent_name == "item_blue_bottle_large" or
            ent_name == "item_red_bottle_large" or
            ent_name == "item_red_bottle_small" or
            ent_name == "item_wudi_small" or
            ent_name == "item_wudi_big" then
            -- local player_count = global_var_func.all_player_amount
            for playerid = 0, global_var_func.all_player_amount - 1 do
                if PlayerResource:GetConnectionState(playerid) == DOTA_CONNECTION_STATE_CONNECTED then
                    local shero = PlayerResource: GetPlayer(playerid): GetAssignedHero()
                    -- 判断技能
                    if shero:HasAbility("yaoshui_lua") then
                        SetBaseStrength(shero, 3)
                        SetBaseAgility(shero, 3)
                        SetBaseIntellect(shero, 3)
                    end 
                end
            end
        end
    elseif order_type == DOTA_UNIT_ORDER_BUYBACK then
        --买活
        
    end
	return true
end

function Filter:DamageFilter(params)
    -- 伤害监听
        -- damagetype_const                	= 1 (number)
        -- damage                          	= 158.40000915527 (number)
        -- entindex_attacker_const         	= 206 (number)
        -- entindex_victim_const           	= 341 (number)
    -- local increase = game_playerinfo:get_dynamic_properties_by_key(self.steam_id, "abnormal_damage_scale")
    -- print(" >>>>>>>>>>>>>>>> increase: "..increase)
    -- DeepPrintTable(params)
    if DAMAGE_TYPE_NONE == params.damagetype_const then
        return true
    end
    -- 攻击者
    local attacker = EntIndexToHScript(params.entindex_attacker_const)
    if not attacker then
        return true
    end
    -- 受害者
    local victim = EntIndexToHScript(params.entindex_victim_const)
    if not victim then
        return true
    end
    local victimname = victim:GetUnitName()
    if victimname=="npc_dota_hero_spirit_breaker" then
        -- 判断是否为致死伤害
        if params.damage >= victim:GetHealth() then
            -- 致死伤害
            params.damage = victim:GetHealth() - 10
            victim:AddNewModifier(victim, nil, "modifier_damagevoid_lua", {duration = 12})
        end
    end
    if attacker:GetTeamNumber() ~= DOTA_TEAM_GOODGUYS then
        return true
    end

    if not attacker:IsRealHero() then
        attacker = attacker:GetOwner()
    end
    if not attacker then
        return true
    end
    local attacker_steamID = PlayerResource:GetSteamAccountID(attacker:GetPlayerID())
    local increase = game_playerinfo:get_dynamic_properties_by_key(attacker_steamID, "abnormal_damage_scale")
    -- print(" >>>>>>>>>>>>>>>> increase: "..increase)
    for i = 0, 3 do
        if PlayerResource:GetConnectionState(i) == DOTA_CONNECTION_STATE_CONNECTED then
            local hero = PlayerResource:GetPlayer(i):GetAssignedHero()
            local modifierhandle = hero:FindModifierByName("modifier_sublime_shouling_kexing_lua")
            if modifierhandle then
                modifierhandle:SetStackCount(math.floor(params.damage))
            end
        end
    end
    if attacker:GetUnitName() == "npc_dota_hero_slardar" then
        -- 对精英怪和BOSS的伤害增加30%
        if ContainUnitTypeFlag(victim, DOTA_UNIT_TYPE_FLAG_CREEP + DOTA_UNIT_TYPE_FLAG_GENERAL + DOTA_UNIT_TYPE_FLAG_ELITE) or ContainUnitTypeFlag(victim, DOTA_UNIT_TYPE_FLAG_BOSS + DOTA_UNIT_TYPE_FLAG_GENERAL) then
            params.damage = params.damage * 1.3
        end
    end
    --法术暴击
    if params.damagetype_const == DAMAGE_TYPE_MAGICAL then
        if attacker.dynamic_properties.magic_critical > 0 then
            if RollPercentage(attacker.dynamic_properties.magic_critical) then
                params.damage = math.ceil(params.damage * attacker.dynamic_properties.magic_critical_damage)
                utils_popups:ShowCriticalDamage2(victim,params.damage )
            end
        end
    end
    -----------------------------额外增伤计算,放到最后面,下面不要插入其他逻辑--------------------------------------------
    if increase == 0 then
        -- 玩家伤害统计
        game_playerinfo:update_player_damage(attacker:GetPlayerID(), params.damage)
        return true
    else
        local modifier_tab = victim:FindAllModifiers()
        local count = 0
        for key, value in pairs(modifier_tab) do
            if value:IsDebuff() then
                count = count + 1
            end
        end
        -- print(" >>>>>>>>>>>>>>>> front.damage: "..params.damage)
        params.damage = math.ceil(params.damage*(increase*count + 100)/100)
    end
    
    -- 玩家伤害统计
    game_playerinfo:update_player_damage(attacker:GetPlayerID(), params.damage)
    return true
end


function Filter:AddedToInventoryFilter(params)
    return false
end

function Filter:ExecuteModifyGoldFilter(params)
    -- DeepPrintTable(params)
end
