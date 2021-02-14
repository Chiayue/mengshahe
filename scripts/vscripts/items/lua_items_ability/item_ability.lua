require("ability/system_ability")
require("config/config_item")
-- require("items/lua_items_ability/drop_item")
require("items/lua_items/item_drop")
require("info/game_playerinfo")
require("global/utils_popups")
require("items/lua_items_ability/up_item")

if common_item_ability == nil then
	common_item_ability = class({})
end

--hero_kill_id 击杀数量
--item_name_pre_id 物品进阶boss标识
local table_data = {}

--根据力量造成范围伤害
-- function common_item_ability:damage_by_strength(attacker,killed)
--     if not killed then
--         return
--     end
--     -- ParticleManager:CreateParticle("particles/econ/items/lifestealer/ls_ti10_immortal/ls_ti10_immortal_infest_gold.vpcf",PATTACH_POINT,killed)
--     local pindex = ParticleManager:CreateParticle("particles/econ/events/fall_major_2016/blink_dagger_end_fm06.vpcf",PATTACH_POINT,killed)
--     ParticleManager:ReleaseParticleIndex(pindex)
--     local aList = Entities:FindAllByClassnameWithin("npc_dota_creature",killed:GetLocalOrigin(),250)
--     local attacker_team =  attacker:GetTeam()
-- 	--伤害表
-- 	local damageTable = {
-- 		victim = {},
-- 		damage = attacker:GetStrength() * 6, 
-- 		damage_type = DAMAGE_TYPE_PHYSICAL,
--         damage_flags = DOTA_DAMAGE_FLAG_NONE, --Optional.
--         attacker = attacker,
-- 		ability = nil, --Optional.
-- 	}
--     for i,v in pairs(aList) do
--         if v:IsAlive() then 
--             local unit_team = v:GetTeam()
--             if attacker_team ~= unit_team then
--                 damageTable.victim = v
--                 ApplyDamage(damageTable)
--             end
-- 		end
-- 	end
-- end



--物品进阶
function item_advance(player_id,item_name)
    local item_name_pre = string.sub(item_name,0,string.len(item_name)-1)
    local playerHero = PlayerResource:GetPlayer(player_id):GetAssignedHero(  )
    for i=0,8 do 
        local item_handle =  playerHero:GetItemInSlot(i)
        if item_handle and item_handle:GetAbilityName() == item_name then
            -- playerHero:TakeItem(item_handle)
            UTIL_Remove(item_handle)
            local new_item_name = "";
            if string.find(item_name,"bone") then
                new_item_name="item_custom_sword_iron_0"
            elseif string.find(item_name,"sword_iron") then
                new_item_name="item_custom_sword_silver_0"
            elseif string.find(item_name,"sword_silver") then
                new_item_name="item_custom_sword_gold_0"
            elseif string.find(item_name,"sword_gold") then
                new_item_name="item_custom_sword_wangzhe_0"
            elseif string.find(item_name,"armor_cloth") then
                new_item_name="item_custom_armor_fur_0"
            elseif string.find(item_name,"armor_fur") then
                new_item_name="item_custom_armor_iron_0"
            elseif string.find(item_name,"armor_iron") then
                new_item_name="item_custom_armor_gold_0"
            elseif string.find(item_name,"armor_gold") then
                new_item_name="item_custom_armor_wangzhe_0"
            elseif string.find(item_name,"ring_wood") then
                new_item_name="item_custom_ring_iron_0"
            elseif string.find(item_name,"ring_iron") then
                new_item_name="item_custom_ring_copper_0"
            elseif string.find(item_name,"ring_copper") then
                new_item_name="item_custom_ring_gold_0"
            elseif string.find(item_name,"ring_gold") then
                new_item_name="item_custom_ring_wangzhe_0"
            end
            local add_item = playerHero:AddItemByName(new_item_name)
            add_item:SetPurchaseTime(0)
            local new_name = add_item:GetAbilityName()
            game_playerinfo:resetquipmentname(player_id, item_name, new_name)
        end
    end
    --重置召唤升级怪标识
    table_data[item_name_pre..player_id] = 0
end


 

--物品拾取
function common_item_ability:item_rune_pickup(item_name,hero)
    local rand_int =  0     
    if item_name == "item_custom_regeneration01" then
        --恢复
        -- hero:SetHealth(hero:GetMaxHealth())
        -- hero:SetMana(hero:GetMaxMana())
    elseif item_name == "item_custom_rune_haste01" then
        --狂暴
        -- hero:AddNewModifier(hero,nil,"modifier_item_custom_rune_haste02", {Duration=20})
    elseif item_name == "item_rune_gold" then 
        --金币
        -- local player_count = global_var_func.all_player_amount
        -- for i = 0, player_count-1 do
        --     local player = PlayerResource:GetPlayer( i )
        --     if player then 
        --         player_hero = player:GetAssignedHero()
        --         game_playerinfo:set_player_gold(i,500)
        --         utils_popups:ShowGoldGain(player_hero, 500)
        --         local pindex = ParticleManager:CreateParticle( "particles/econ/courier/courier_flopjaw_gold/flopjaw_death_gold.vpcf", PATTACH_ABSORIGIN_FOLLOW, player_hero )
        --         ParticleManager:ReleaseParticleIndex(pindex)
        --     end
        -- end
    -- elseif string.find(item_name,"item_add_strength") then
    --     if(item_name == "item_add_strength_1") then
    --         utils_popups:ShowDamageOverTime(hero, 1)
    --         hero:ModifyStrength(1)
    --     elseif(item_name == "item_add_strength_2") then
    --         utils_popups:ShowDamageOverTime(hero, 2)
    --         hero:ModifyStrength(2)
    --     elseif(item_name == "item_add_strength_2") then
    --         utils_popups:ShowDamageOverTime(hero, 3)
    --         hero:ModifyStrength(3)
    --     end
       
    -- elseif string.find(item_name,"item_add_agility") then
    --     if(item_name == "item_add_agility_1") then
    --         utils_popups:ShowDamageOverTime(hero, 1)
    --         hero:ModifyAgility(1)
    --     elseif(item_name == "item_add_agility_2") then
    --         utils_popups:ShowDamageOverTime(hero, 2)
    --         hero:ModifyAgility(2)
    --     elseif(item_name == "item_add_agility_3") then
    --         utils_popups:ShowDamageOverTime(hero, 3)
    --         hero:ModifyAgility(3)
    --     end
     
    -- elseif string.find(item_name,"item_add_intellect") then
    --     if(item_name == "item_add_intellect_1") then
    --         utils_popups:ShowDamageOverTime(hero, 1)
    --         hero:ModifyIntellect(1)
    --     elseif(item_name == "item_add_intellect_2") then
    --         utils_popups:ShowDamageOverTime(hero, 2)
    --         hero:ModifyIntellect(2)
    --     elseif(item_name == "item_add_intellect_3") then
    --         utils_popups:ShowDamageOverTime(hero, 3)
    --         hero:ModifyIntellect(3)
    --     end
     
    -- elseif string.find(item_name,"item_add_health") then
    --     if(item_name == "item_add_health_1") then
          
    --         rand_int = RandomInt(20, 30);
    --         utils_popups:ShowDamageOverTime(hero, rand_int)
    --         hero:AddNewModifier( hero, nil, "modifier_hero_add_health", {add_health = rand_int}  )
    --     elseif(item_name == "item_add_health_2") then
    --         rand_int = RandomInt(30, 40);
    --         utils_popups:ShowDamageOverTime(hero, rand_int)
    --         hero:AddNewModifier( hero, nil, "modifier_hero_add_health", {add_health = rand_int}  )
    --     elseif(item_name == "item_add_health_3") then
    --         rand_int = RandomInt(40, 50);
    --         utils_popups:ShowDamageOverTime(hero, rand_int)
    --         hero:AddNewModifier( hero, nil, "modifier_hero_add_health", {add_health = rand_int}  )
    --     end
    -- elseif string.find(item_name,"item_add_aggressivity") then
    --     if(item_name == "item_add_aggressivity_1") then
    --         rand_int = RandomInt(1, 2);
    --         utils_popups:ShowDamageOverTime(hero, rand_int)
    --         local steam_id = PlayerResource:GetSteamAccountID(hero:GetPlayerID()) 
    --         game_playerinfo:set_dynamic_properties(steam_id, "add_baseattack", rand_int)
    --     elseif(item_name == "item_add_aggressivity_2") then
  
    --         rand_int = RandomInt(3, 4);
    --         utils_popups:ShowDamageOverTime(hero, rand_int)
    --         local steam_id = PlayerResource:GetSteamAccountID(hero:GetPlayerID()) 
    --         game_playerinfo:set_dynamic_properties(steam_id, "add_baseattack", rand_int)
    --     elseif(item_name == "item_add_aggressivity_3") then
    --         utils_popups:ShowDamageOverTime(hero, 5)
    --         local steam_id = PlayerResource:GetSteamAccountID(hero:GetPlayerID()) 
    --         game_playerinfo:set_dynamic_properties(steam_id, "add_baseattack", 5)
 
    --     end
    -- elseif string.sub(item_name,0,16) == "heroEquipment" then 
    --    local steam_id = PlayerResource:GetSteamAccountID(hero:GetPlayerID()) 
    --    --更新碎片信息
    --    game_playerinfo:updata_bead_data(steam_id,item_name,hero)
    end
    --刷新属性
    hero:CalculateStatBonus(true)
end

--移除英雄物品
function common_item_ability:remove_item_by_name(hero,item_name)
    for i=0,17 do 
        local item_handle =  hero:GetItemInSlot(i)
        if item_handle and item_handle:GetAbilityName() == item_name then
            UTIL_Remove(item_handle)
            break
        end
    end
end

--击杀事件
function common_item_ability:add_property_item(evt)
    if not IsServer( ) then
        return
    end 

    local hero = EntIndexToHScript(evt.entindex_attacker)
    if not hero:IsRealHero() then
        local owner = hero:GetOwner()
        if not owner or not owner:IsHero() then
            return
        end
        hero = owner
    end

    local killed_unit = EntIndexToHScript(evt.entindex_killed)
    
    if string.find(killed_unit:GetUnitName(), "company_build_") then
        for key, value in pairs(build_record) do
            if value==killed_unit:GetUnitName() then
                table.remove(build_record, key)
                break
            end
        end
    end

    -- 添加死亡特效
    -- killuniteffect(hero, killed_unit, 400, 0.1)
    
    --------------------------------------------------------------
    local hero_kill_key = "hero_kill"..evt.entindex_attacker
    if not table_data[hero_kill_key] then 
        table_data[hero_kill_key] = 0
    end
    local gold_rod = config_item:get_gold_rod()
    for i=0,5 do 
        local item_handle =  hero:GetItemInSlot(i)
        if item_handle then
            local item_name = item_handle:GetAbilityName()
            --黄金背包
            if gold_rod[item_name] then
                local killed_num = item_handle:GetCurrentCharges() or 0
                killed_num = killed_num + 1
                if killed_num >= gold_rod[item_name].kill_num then
                    local add_pop_min = gold_rod[item_name].add_pop_min
                    local add_pop_max = gold_rod[item_name].add_pop_max
                    local add_pop = RandomInt(add_pop_min,add_pop_max)
                    local gain_gold_min = gold_rod[item_name].gain_gold_min
                    local gain_gold_max = gold_rod[item_name].gain_gold_max
                    local gain_gold = RandomInt(gain_gold_min,gain_gold_max)
                    UTIL_RemoveImmediate(item_handle)
                    hero:ModifyStrength(add_pop)
                    hero:ModifyIntellect(add_pop)
                    hero:ModifyAgility(add_pop)
                    game_playerinfo:set_player_gold(hero:GetPlayerID(), gain_gold)
                    table_data[hero_kill_key] = 0
                    break
                end
                item_handle:SetCurrentCharges(killed_num)
                break
            end
        end
    end
    for i=0,5 do 
        local item_handle =  hero:GetItemInSlot(i)
        if item_handle then 
            local item_name = item_handle:GetAbilityName()
             --无尽药水
            if item_name == "item_more_and_more" then
                local local_charges = item_handle:GetCurrentCharges()
                if local_charges == 79 then 
                    item_handle:SetCurrentCharges(0)
                    hero:ModifyStrength(1)
                    hero:ModifyAgility(1)
                    hero:ModifyIntellect(1)
                    hero:CalculateStatBonus(true)
                else
                    item_handle:SetCurrentCharges(local_charges+1)
                end
            end
        end
    end
    --物品进阶
    
    local killed_unit_name = killed_unit:GetUnitName()
    if killed_unit_name and killed_unit_name == "task_smith"then
        local player_id = killed_unit.player_id
        local itemName = killed_unit.item_name
        item_advance(player_id,itemName)
    end

    -- 击杀召唤BOSS
    if ContainUnitTypeFlag(killed_unit, global_var_func.flag_boss_call) then
        local player = PlayerResource:GetPlayer(killed_unit.player_id)
        if player then
            local belong_hero = player:GetAssignedHero()
            if killed_unit.difficulty == 1 then
                game_playerinfo:set_player_gold(killed_unit.player_id, 5000)
            elseif killed_unit.difficulty == 2 then
                game_playerinfo:set_player_gold(killed_unit.player_id, 10000)
            elseif killed_unit.difficulty == 3 then
                game_playerinfo:set_player_gold(killed_unit.player_id, 15000)
            end
            local attack_steam_id = PlayerResource:GetSteamAccountID(hero:GetPlayerID())
            local player_info = game_playerinfo:get_player_info()[attack_steam_id]
            if player_info then
                player_info["killBoss"] = player_info["killBoss"] + 1
            end
        end
    end

    -- 击杀BOSS
    if ContainUnitTypeFlag(killed_unit, DOTA_UNIT_TYPE_FLAG_BOSS + DOTA_UNIT_TYPE_FLAG_GENERAL) then
        local player_id = killed_unit.player_id
        if hero:GetUnitName() == "npc_dota_hero_slardar" then
            game_playerinfo:set_player_gold(hero:GetPlayerID(), killed_unit:GetGoldBounty())
            local temp_value = 10
            SetBaseStrength(hero, temp_value)
            SetBaseAgility(hero, temp_value)
            SetBaseIntellect(hero, temp_value)
            if player_id~=hero:GetPlayerID() then
                -- 怪物归属和击杀者不是同一人
                local unitOwner = PlayerResource:GetPlayer(player_id):GetAssignedHero()
                if unitOwner then
                    game_playerinfo:set_player_gold(player_id, killed_unit:GetGoldBounty() * 2)
                    
                    SetBaseStrength(unitOwner, 5)
                    SetBaseAgility(unitOwner, 5)
                    SetBaseIntellect(unitOwner, 5)
                end
            end
        end
        if hero:GetUnitName() == "npc_dota_hero_rubick" then
            -- 随机升级一件装备
            local random = RandomInt(1,3)

            local equipment_tab = game_playerinfo:get_heroquipment(hero:GetPlayerID())
            if #equipment_tab > 0 then
                local item_name = equipment_tab[random]
                if string.find(item_name, "_5") then
                    for key, value in pairs(equipment_tab) do
                        if not string.find(value, "_5") then
                            item_name = value
                            item_level_up_free(item_name, hero)
                            break
                        end
                    end
                else
                    item_level_up_free(item_name, hero)
                end
            end
        end
        OpenTreasureWindow(player_id, 3)
        local attack_steam_id = PlayerResource:GetSteamAccountID(hero:GetPlayerID())
        local player_info = game_playerinfo:get_player_info()[attack_steam_id]
        if player_info then
            player_info["killBoss"] = player_info["killBoss"] + 1
        end
        -- 击杀BOSS升一级
        PlayerResource:GetPlayer(killed_unit.player_id):GetAssignedHero():HeroLevelUp(true)
        player_info["killBoss"] = player_info["killBoss"] + 1
    end
    --击杀炎魔
    if killed_unit_name == "task_golem" then
        local own_hero = PlayerResource:GetPlayer(killed_unit.player_id):GetAssignedHero()
        local isExsit = false
        for i=0,8 do 
            local item_handle =  own_hero:GetItemInSlot(i)
            if item_handle then
                local item_name = item_handle:GetAbilityName()
                if item_name == "item_custom_guazui" then
                    isExsit = true
                    break
                end
            end
        end
        if not isExsit then
            own_hero:AddItemByName("item_custom_guazui")
        end
        common_item_ability:random_property_yanmo(own_hero)
        local attack_steam_id = PlayerResource:GetSteamAccountID(hero:GetPlayerID())
        local player_info = game_playerinfo:get_player_info()[attack_steam_id]
        if player_info then
            player_info["killYanmo"] = player_info["killYanmo"] + 1
        end
    end
    local ext_chance = 0
    if hero.dynamic_properties then 
        --额外经验
        if hero.dynamic_properties.exp_scale then
            local xp = killed_unit:GetDeathXP()
            xp = math.ceil(xp * hero.dynamic_properties.exp_scale)
            hero:AddExperience(xp,DOTA_ModifyXP_Unspecified,false,false)
        end
    end
    --物品掉落
    item_drop:RollDrops(killed_unit,hero)
    --精英怪加木头
    if ContainUnitTypeFlag(killed_unit, DOTA_UNIT_TYPE_FLAG_CREEP + DOTA_UNIT_TYPE_FLAG_GENERAL + DOTA_UNIT_TYPE_FLAG_ELITE) then 
        game_playerinfo:change_player_wood(hero, 1)
        if hero:GetUnitName() == "npc_dota_hero_slardar" then
            game_playerinfo:change_player_wood(hero, 1)
        end
    end
    --金矿
    if killed_unit:GetUnitName() == "task_box" then
        local player = PlayerResource:GetPlayer(killed_unit.player_id)
        if player then
            game_playerinfo:change_player_wood(player:GetAssignedHero(), 10)
        end
    end
    --金币怪
    if killed_unit:GetUnitName() == "task_coin" then
        local player = PlayerResource:GetPlayer(killed_unit.player_id)
        local nhero = player:GetAssignedHero()
        --金币怪悬赏令
        if nhero:HasModifier("modifier_treasure_goldmon_attribute_one") then
            local random = math.random(1,3)
            if random == 1 then
                game_playerinfo:set_dynamic_properties(PlayerResource:GetSteamAccountID(killed_unit.player_id), "add_strength", 1)
            elseif random == 2 then
                game_playerinfo:set_dynamic_properties(PlayerResource:GetSteamAccountID(killed_unit.player_id), "add_agility", 1)
            elseif random == 3 then
                game_playerinfo:set_dynamic_properties(PlayerResource:GetSteamAccountID(killed_unit.player_id), "add_intellect", 1)
            end
        end
        --金币怪杀手
        if nhero:HasModifier("modifier_treasure_goldmon_attribute_two") then
            local random = math.random(1,3)
            if random == 1 then
                game_playerinfo:set_dynamic_properties(PlayerResource:GetSteamAccountID(killed_unit.player_id), "add_strength", 2)
            elseif random == 2 then
                game_playerinfo:set_dynamic_properties(PlayerResource:GetSteamAccountID(killed_unit.player_id), "add_agility", 2)
            elseif random == 3 then
                game_playerinfo:set_dynamic_properties(PlayerResource:GetSteamAccountID(killed_unit.player_id), "add_intellect", 2)
            end
        end
    end
    -- if ContainUnitTypeFlag(killed_unit, DOTA_UNIT_TYPE_FLAG_CREEP + DOTA_UNIT_TYPE_FLAG_GENERAL) then
    --     -- 普通小怪也有几率掉落宝物书
    --     local player_id = killed_unit.player_id
    --     if treasuresystem:DropTreasureBook(player_id) then
    --         OpenTreasureWindow(player_id, 3)
    --     end
    -- end
    --奖励金钱
    local rd_gold = killed_unit:GetGoldBounty()
    if killed_unit.player_id then
        rd_gold = rd_gold * (1 + (game_playerinfo:get_dynamic_properties(PlayerResource:GetSteamAccountID(killed_unit.player_id)).kill_gold_scale * 0.01))
    end
    game_playerinfo:set_player_gold(killed_unit.player_id, rd_gold)
end

--物品免费升级
function item_level_up_free(item_name, caster)
    if string.find(item_name,"bone") then
        item_exchange_free(caster,item_name)
	elseif string.find(item_name,"sword_iron") then
        item_exchange_free(caster,item_name)
    elseif string.find(item_name,"sword_silver") then
        item_exchange_free(caster,item_name)
    elseif string.find(item_name,"sword_gold") then
        item_exchange_free(caster,item_name)
    elseif string.find(item_name,"sword_wangzhe") then
        item_exchange_free(caster,item_name)
    elseif string.find(item_name,"armor_cloth") then
        item_exchange_free(caster,item_name)
    elseif string.find(item_name,"armor_fur") then
        item_exchange_free(caster,item_name)
    elseif string.find(item_name,"armor_iron") then
        item_exchange_free(caster,item_name)
    elseif string.find(item_name,"armor_gold") then
        item_exchange_free(caster,item_name)
    elseif string.find(item_name,"armor_wangzhe") then
        item_exchange_free(caster,item_name)
    elseif string.find(item_name,"ring_wood") then
        item_exchange_free(caster,item_name)
    elseif string.find(item_name,"ring_iron") then
        item_exchange_free(caster,item_name)
    elseif string.find(item_name,"ring_copper") then
        item_exchange_free(caster,item_name)
    elseif string.find(item_name,"ring_gold") then
        item_exchange_free(caster,item_name)
    elseif string.find(item_name,"ring_wangzhe") then
        item_exchange_free(caster,item_name)
	end
end

function item_exchange_free(caster,item_name)
    local item_name_pre = string.sub(item_name,0,string.len(item_name)-1)
    local level = tonumber(string.sub(item_name,-1))
    if item_name == "item_custom_sword_wangzhe_5" or item_name == "item_custom_armor_wangzhe_5" 
        or item_name == "item_custom_ring_wangzhe_5" then 
        return
    end
    local casterHero = caster
    if not caster:IsRealHero(  ) then
        casterHero = caster:GetOwner(  )
    end
    local player_id= casterHero:GetPlayerID()
    local item_handle = casterHero:FindItemInInventory(item_name)
    item_handle:EmitSound("hero.duanzao")

    if level < 5 then
        ParticleManager:CreateParticle("particles/econ/events/ti9/hero_levelup_ti9.vpcf",PATTACH_POINT_FOLLOW,caster)
        UTIL_Remove(item_handle)
        local add_item = caster:AddItemByName(item_name_pre..level+1)
        add_item:SetPurchaseTime(0)
        local new_name = add_item:GetAbilityName()
        game_playerinfo:resetquipmentname(player_id, item_name, new_name)
        CustomGameEventManager:Send_ServerToPlayer(PlayerResource:GetPlayer(player_id),"item_up_tip",{is_up = true})
    end

    -- for i=0,8 do 
    --     local item_handle = caster:GetItemInSlot(i)
    --     if item_handle and item_handle:GetAbilityName() == item_name then
    --         item_handle:EmitSound("hero.duanzao")
    --         if level < 5 then
    --             local is_up = false
    --             is_up = true
    --             ParticleManager:CreateParticle("particles/econ/events/ti9/hero_levelup_ti9.vpcf",PATTACH_POINT_FOLLOW,caster)
    --             UTIL_Remove(item_handle)
    --             local add_item = caster:AddItemByName(item_name_pre..level+1)
    --             add_item:SetPurchaseTime(0)
    --             local new_name = add_item:GetAbilityName() 
    --             game_playerinfo:resetquipmentname(player_id, item_name, new_name)
    --             CustomGameEventManager:Send_ServerToPlayer(PlayerResource:GetPlayer(player_id),"item_up_tip",{is_up = is_up})
    --             break
    --         end
    --     end
    -- end
end



function item_spent(evt)
    local duration_time = evt.ability:GetSpecialValueFor( "item_duration" )
    local modifier_name = "modifier_"..evt.ability:GetAbilityName()
    local caster = evt.caster
    local item_charges = evt.ability:GetCurrentCharges()
            
    local hero 
    if caster:IsHero() then
        hero = caster
    else
        hero = caster:GetOwner(  )
    end
    hero:AddNewModifier(hero,nil,modifier_name,{ Duration = duration_time } )
    hero:EmitSound("hero.eatdrug1")
    -- print(item_charges)
    if item_charges > 1 then
        evt.ability:SetCurrentCharges(item_charges-1)
    else
        UTIL_Remove(evt.ability)
    end
    -- caster:RemoveItem(evt.ability)
end

function item_spent_moment_mana(evt)
    -- 瞬间回蓝
    local caster = evt.caster
    local item_charges = evt.ability:GetCurrentCharges()
    local hero = nil
    if caster:IsHero() then
        hero = caster
    else
        hero = caster:GetOwner(  )
    end

    hero:EmitSound("hero.eatdrug1")
    hero:GiveMana(60)
    if item_charges > 1 then
        evt.ability:SetCurrentCharges(item_charges-1)
    else
        UTIL_Remove(evt.ability)
    end
end

function item_rune_prop(evt)
    evt.caster:ModifyStrength(2)
    evt.caster:RemoveItem(evt.ability)
end

--初始化碎片属性
function common_item_ability:init_bead(hero)
    local heroindex = hero:GetEntityIndex()
    local steam_id = PlayerResource:GetSteamAccountID( hero:GetPlayerID() )
    local bead_info = game_playerinfo:get_equipment_data(steam_id) or {}
    
    -- local bead_eachlevel_config =  config_item:get_bead_add_eachlevel_config()
    -- print(" >>>>>>>>>>>>> init_bead: ")
    -- DeepPrintTable(bead_info)
    if bead_info then
        -- 吸血
        if bead_info.heroEquipmentSpeciaiweapon and bead_info.heroEquipmentSpeciaiweapon >0 then
            -- print(" >>>>>>>>>>>>> heroEquipmentSpeciaiweapon: "..bead_info.heroEquipmentSpeciaiweapon)
            local property_name = config_item:get_dynamic_properties_value("heroEquipmentSpeciaiweapon")
            local property_ladder_name = config_item:get_dynamic_properties_ladder_value("heroEquipmentSpeciaiweapon")
            -- 每级附加属性
            local add_properties = 0
            for i = 1, bead_info.heroEquipmentSpeciaiweapon do
                local bead_eachlevel_config =  config_item:get_bead_add_eachlevel_config("heroEquipmentSpeciaiweapon", (math.floor((i-1)*0.1)+1))
                add_properties = add_properties + bead_eachlevel_config
            end
            -- print(" >>>>>>>>>>>>> "..property_name..": "..add_properties)
            game_playerinfo:set_dynamic_properties(steam_id, property_name, add_properties)
            if bead_info.heroEquipmentSpeciaiweapon >= 10 then
                local bead_property =  config_item:get_bead_add_config_by_stage("heroEquipmentSpeciaiweapon", (math.floor((bead_info.heroEquipmentSpeciaiweapon-10)*0.1)+1))
                game_playerinfo:set_dynamic_properties(steam_id, property_ladder_name, bead_property)
            end
        end
        -- 攻击力
        if bead_info.heroEquipmentMainweapon and bead_info.heroEquipmentMainweapon >0 then
            -- print(" >>>>>>>>>>>>> heroEquipmentMainweapon: "..bead_info.heroEquipmentMainweapon)
            local property_name = config_item:get_dynamic_properties_value("heroEquipmentMainweapon")
            local property_ladder_name = config_item:get_dynamic_properties_ladder_value("heroEquipmentMainweapon")
            -- 每级附加属性
            local add_properties = 0
            for i = 1, bead_info.heroEquipmentMainweapon do
                local bead_eachlevel_config =  config_item:get_bead_add_eachlevel_config("heroEquipmentMainweapon", (math.floor((i-1)*0.1)+1))
                add_properties = add_properties + bead_eachlevel_config
            end
            -- print(" >>>>>>>>>>>>> "..property_name..": "..add_properties)

            game_playerinfo:set_dynamic_properties(steam_id, property_name, add_properties)
            if bead_info.heroEquipmentMainweapon >= 10 then
                local bead_property =  config_item:get_bead_add_config_by_stage("heroEquipmentMainweapon", (math.floor((bead_info.heroEquipmentMainweapon-10)*0.1)+1))
                game_playerinfo:set_dynamic_properties(steam_id, property_ladder_name, bead_property)
            end
        end

        -- 减伤
        if bead_info.heroEquipmentArmor and bead_info.heroEquipmentArmor >0 then
            -- print(" >>>>>>>>>>>>> heroEquipmentArmor: "..bead_info.heroEquipmentArmor)
            local property_name = config_item:get_dynamic_properties_value("heroEquipmentArmor")
            local property_ladder_name = config_item:get_dynamic_properties_ladder_value("heroEquipmentArmor")
            -- 每级附加属性
            local add_properties = 0
            for i = 1, bead_info.heroEquipmentArmor do
                local bead_eachlevel_config =  config_item:get_bead_add_eachlevel_config("heroEquipmentArmor", (math.floor((i-1)*0.1)+1))
                add_properties = add_properties + bead_eachlevel_config
            end
            -- print(" >>>>>>>>>>>>> "..property_name..": "..add_properties)
            
            game_playerinfo:set_dynamic_properties(steam_id, property_name, add_properties)
            if bead_info.heroEquipmentArmor >= 10 then
                local bead_property =  config_item:get_bead_add_config_by_stage("heroEquipmentArmor", (math.floor((bead_info.heroEquipmentArmor-10)*0.1)+1))
                game_playerinfo:set_dynamic_properties(steam_id, property_ladder_name, bead_property)
            end
        end

        -- 额外伤害
        if bead_info.heroEquipmentLegguard and bead_info.heroEquipmentLegguard >0 then
            -- print(" >>>>>>>>>>>>> heroEquipmentLegguard: "..bead_info.heroEquipmentLegguard)
            local property_name = config_item:get_dynamic_properties_value("heroEquipmentLegguard")
            local property_ladder_name = config_item:get_dynamic_properties_ladder_value("heroEquipmentLegguard")
            -- 每级附加属性
            local add_properties = 0
            for i = 1, bead_info.heroEquipmentLegguard do
                local bead_eachlevel_config =  config_item:get_bead_add_eachlevel_config("heroEquipmentLegguard", (math.floor((i-1)*0.1)+1))
                add_properties = add_properties + bead_eachlevel_config
            end
            -- print(" >>>>>>>>>>>>> "..property_name..": "..add_properties)

            game_playerinfo:set_dynamic_properties(steam_id, property_name, add_properties)
            if bead_info.heroEquipmentLegguard >= 10 then
                local bead_property =  config_item:get_bead_add_config_by_stage("heroEquipmentLegguard", (math.floor((bead_info.heroEquipmentLegguard-10)*0.1)+1))
                game_playerinfo:set_dynamic_properties(steam_id, property_ladder_name, bead_property)
            end
        end

        -- 敏捷
        if bead_info.heroEquipmentShoes and bead_info.heroEquipmentShoes >0 then
            -- print(" >>>>>>>>>>>>> heroEquipmentShoes: "..bead_info.heroEquipmentShoes)
            local property_name = config_item:get_dynamic_properties_value("heroEquipmentShoes")
            local property_ladder_name = config_item:get_dynamic_properties_ladder_value("heroEquipmentShoes")
            -- 每级附加属性
            local add_properties = 0
            for i = 1, bead_info.heroEquipmentShoes do
                local bead_eachlevel_config =  config_item:get_bead_add_eachlevel_config("heroEquipmentShoes", (math.floor((i-1)*0.1)+1))
                add_properties = add_properties + bead_eachlevel_config
            end
            -- print(" >>>>>>>>>>>>> "..property_name..": "..add_properties)

            game_playerinfo:set_dynamic_properties(steam_id, property_name, add_properties)
            if bead_info.heroEquipmentShoes >= 10 then
                local bead_property =  config_item:get_bead_add_config_by_stage("heroEquipmentShoes", (math.floor((bead_info.heroEquipmentShoes-10)*0.1)+1))
                game_playerinfo:set_dynamic_properties(steam_id, property_ladder_name, bead_property)
            end
        end

        -- 智力
        if bead_info.heroEquipmentLeg and bead_info.heroEquipmentLeg >0 then
            -- print(" >>>>>>>>>>>>> heroEquipmentLeg: "..bead_info.heroEquipmentLeg)
            local property_name = config_item:get_dynamic_properties_value("heroEquipmentLeg")
            local property_ladder_name = config_item:get_dynamic_properties_ladder_value("heroEquipmentLeg")
            -- 每级附加属性
            local add_properties = 0
            for i = 1, bead_info.heroEquipmentLeg do
                local bead_eachlevel_config =  config_item:get_bead_add_eachlevel_config("heroEquipmentLeg", (math.floor((i-1)*0.1)+1))
                add_properties = add_properties + bead_eachlevel_config
            end
            -- print(" >>>>>>>>>>>>> "..property_name..": "..add_properties)

            game_playerinfo:set_dynamic_properties(steam_id, property_name, add_properties)
            if bead_info.heroEquipmentLeg >= 10 then
                local bead_property =  config_item:get_bead_add_config_by_stage("heroEquipmentLeg", (math.floor((bead_info.heroEquipmentLeg-10)*0.1)+1))
                game_playerinfo:set_dynamic_properties(steam_id, property_ladder_name, bead_property)
            end
        end

        -- 力量
        if bead_info.heroEquipmentHead and bead_info.heroEquipmentHead >0 then
            -- print(" >>>>>>>>>>>>> heroEquipmentHead: "..bead_info.heroEquipmentHead)
            local property_name = config_item:get_dynamic_properties_value("heroEquipmentHead")
            local property_ladder_name = config_item:get_dynamic_properties_ladder_value("heroEquipmentHead")
            -- 每级附加属性
            local add_properties = 0
            for i = 1, bead_info.heroEquipmentHead do
                local bead_eachlevel_config =  config_item:get_bead_add_eachlevel_config("heroEquipmentHead", (math.floor((i-1)*0.1)+1))
                add_properties = add_properties + bead_eachlevel_config
            end
            -- print(" >>>>>>>>>>>>> "..property_name..": "..add_properties)

            game_playerinfo:set_dynamic_properties(steam_id, property_name, add_properties)
            if bead_info.heroEquipmentHead >= 10 then
                local bead_property =  config_item:get_bead_add_config_by_stage("heroEquipmentHead", (math.floor((bead_info.heroEquipmentHead-10)*0.1)+1))
                game_playerinfo:set_dynamic_properties(steam_id, property_ladder_name, bead_property)
            end
        end
        
    end
    -- print(" >>>>>>>>>>>>>>>>>>>>>>  end ?????????????????????????????????")
    local dynamic_properties = game_playerinfo:get_dynamic_properties(steam_id) or {}
    hero.dynamic_properties = dynamic_properties
    local table_key = "bead"..heroindex
    CustomNetTables:SetTableValue("dynamic_properties",table_key,dynamic_properties)
    CustomNetTables:SetTableValue("player_data_table","player_"..hero:GetPlayerID(),bead_info)
end

--刷新加成属性
function common_item_ability:refresh_dynamic_properties(hero,item)
    local heroindex = hero:GetEntityIndex()
    local steam_id = PlayerResource:GetSteamAccountID( hero:GetPlayerID() )
    local bead_info = game_playerinfo:get_equipment_data(steam_id) or {}
    local property_name = config_item:get_dynamic_properties_value(item)
    local bead_eachlevel_config =  config_item:get_bead_add_eachlevel_config(item, (math.floor((bead_info[item]-1)*0.1)+1))
    local property_ladder_name = config_item:get_dynamic_properties_ladder_value(item)
    local bead_config =  config_item:get_bead_add_config()
    game_playerinfo:set_dynamic_properties(steam_id, property_name, bead_eachlevel_config)

    -- 检测是否刚好达到等级阶段
    if bead_info[item] >= 10 and 0 == bead_info[item]%10 then
        -- 升级后刚好达到等级阶段
        local value = bead_config[item][(math.floor((bead_info[item]-1)*0.1)+1)]
        game_playerinfo:set_dynamic_properties(steam_id, property_ladder_name, value)
    end

    -- 更新到网表
    local dynamic_properties = game_playerinfo:get_dynamic_properties(steam_id) or {}
    hero.dynamic_properties[property_name] = dynamic_properties[property_name]
    CustomNetTables:SetTableValue("dynamic_properties","bead"..heroindex,dynamic_properties)
end

--刷新加成属性到网表
function common_item_ability:refresh_dynamic_to_tablevalue(hero)
    local heroindex = hero:GetEntityIndex()
    local steam_id = PlayerResource:GetSteamAccountID( hero:GetPlayerID() )
    local dynamic_properties = game_playerinfo:get_dynamic_properties(steam_id) or {}
    CustomNetTables:SetTableValue("dynamic_properties","bead"..heroindex,dynamic_properties)
end


function common_item_ability:init_vip(player_id)
    local steam_id = PlayerResource:GetSteamAccountID(player_id)
    local player_store = game_playerinfo:get_player_store()[steam_id]
    if not player_store then
        return
    end
    local vip_data = {}
    table.insert(vip_data, player_store.vip_1)
    table.insert(vip_data, player_store.vip_2)
    table.insert(vip_data, player_store.vip_3)
    table.insert(vip_data, player_store.vip_4)
    CustomGameEventManager:Send_ServerToPlayer(PlayerResource:GetPlayer(player_id),"load_vip_data",vip_data)
end

-- function OnSwordAttackLanded(params)
--     local attacker = params.attacker
--     if not attacker:IsHero() then 
--         return
--     end
--     local killed = attacker:GetAttackTarget()
--     if not killed then 
--         return
--     end
--     if RollPercentage(20)  then
--         local ability = params.ability
--         local pindex = ParticleManager:CreateParticle("particles/econ/items/crystal_maiden/crystal_maiden_cowl_of_ice/maiden_crystal_nova_n_cowlofice.vpcf",PATTACH_POINT,killed)
--         ParticleManager:ReleaseParticleIndex(pindex)
--         local aList = Entities:FindAllByClassnameWithin("npc_dota_creature",killed:GetLocalOrigin(),250)
--         local attacker_team =  attacker:GetTeam()
        
--         --伤害表
--         local damageTable = {
--             victim = {},
--             damage = attacker:GetStrength() * ability:GetSpecialValueFor("damage_multiple"), 
--             damage_type = DAMAGE_TYPE_PHYSICAL,
--             damage_flags = DOTA_DAMAGE_FLAG_NONE, --Optional.
--             attacker = attacker,
--             ability = nil, --Optional.
--         }
--         for i,v in pairs(aList) do
--             if v:IsAlive() then 
--                 local unit_team = v:GetTeam()
--                 if attacker_team ~= unit_team then
--                     damageTable.victim = v
--                     ApplyDamage(damageTable)
--                 end
--             end
--         end
--     end
-- end

--消息提示
function send_tips_message(playerID,message_text)
    local gameEvent = {}
    gameEvent["player_id"] = playerID
    gameEvent["locstring_value"]="升级啦"
    gameEvent["teamnumber"] =-1
    gameEvent["message"] = "{s:player_name}"..message_text
    FireGameEvent( "dota_combat_event_message", gameEvent )
end

local count = 0
function send_error_tip(player_id,message)
    count = count== 9 and 0 or count +1
    local err_key = "err_"..player_id
    local err_data = {["message"]=message..count}
    CustomNetTables:SetTableValue("erro_message_table",err_key,err_data)
end

function call_score_shop()
end

function add_modifier(params)
    local caster = params.caster 
    local ability = params.ability
    caster:AddNewModifier(caster,ability,"modifier_sword_damage",{})
end

function ring_change_equip(params)
    local caster = params.caster 
    if caster:IsRealHero() then
        local steam_id = PlayerResource:GetSteamAccountID(caster:GetPlayerID())
        local ability = params.ability
        local critical_chance = ability:GetSpecialValueFor("critical_chance")
        local critical_damage = ability:GetSpecialValueFor("critical_damage") /100
        local magic_critical_chance = ability:GetSpecialValueFor("magic_critical_chance")
        local magic_critical_damage = ability:GetSpecialValueFor("magic_critical_damage") /100
        local dynamic_properties = game_playerinfo:get_dynamic_properties(steam_id)  or {}
        if critical_chance then 
            game_playerinfo:set_dynamic_properties(steam_id, "attack_critical", critical_chance)
            caster.dynamic_properties["attack_critical"] = dynamic_properties["attack_critical"]
        end
        if critical_damage then
            game_playerinfo:set_dynamic_properties(steam_id, "attack_critical_damage", critical_damage)
            caster.dynamic_properties["attack_critical_damage"] = dynamic_properties["attack_critical_damage"]
        end
        if magic_critical_chance then
            game_playerinfo:set_dynamic_properties(steam_id, "magic_critical", magic_critical_chance)
            caster.dynamic_properties["magic_critical"] = dynamic_properties["magic_critical"]
        end
        if magic_critical_damage then
            game_playerinfo:set_dynamic_properties(steam_id, "magic_critical_damage", magic_critical_damage)
            caster.dynamic_properties["magic_critical_damage"] = dynamic_properties["attack_critical_damage"]
        end
    end
end

function ring_change_unequip(params)
    local caster = params.caster 
    if caster:IsRealHero() then
        local steam_id = PlayerResource:GetSteamAccountID(caster:GetPlayerID())
        local ability = params.ability
        local critical_chance = -ability:GetSpecialValueFor("critical_chance")
        local critical_damage = -ability:GetSpecialValueFor("critical_damage")/100
        local magic_critical_chance = -ability:GetSpecialValueFor("magic_critical_chance")
        local magic_critical_damage = -ability:GetSpecialValueFor("magic_critical_damage") /100
        local dynamic_properties = game_playerinfo:get_dynamic_properties(steam_id) or {}
        if critical_chance then 
            game_playerinfo:set_dynamic_properties(steam_id, "attack_critical", critical_chance)
            caster.dynamic_properties["attack_critical"] = dynamic_properties["attack_critical"]
        end
        if critical_damage then
            game_playerinfo:set_dynamic_properties(steam_id, "attack_critical_damage", critical_damage)
            caster.dynamic_properties["attack_critical_damage"] = dynamic_properties["attack_critical_damage"]
        end
        if magic_critical_chance then
            game_playerinfo:set_dynamic_properties(steam_id, "magic_critical", magic_critical_chance)
            caster.dynamic_properties["magic_critical"] = dynamic_properties["magic_critical"]
        end
        if magic_critical_damage then
            game_playerinfo:set_dynamic_properties(steam_id, "magic_critical_damage", magic_critical_damage)
            caster.dynamic_properties["magic_critical_damage"] = dynamic_properties["attack_critical_damage"]
        end
    end
end

function common_item_ability:random_property_yanmo(hero)
    local player_id = hero:GetPlayerID()
    local steam_id = PlayerResource:GetSteamAccountID(player_id)
    local ramdom_property = game_playerinfo:random_properties("player"..player_id)
    if ramdom_property == nil then
        return
    end
    local key 
    local value 
    local value_2
    for _,v in pairs(ramdom_property) do
        key = v[1]
        value = v[2]
        value_2 = v[3]
    end
    game_playerinfo:set_dynamic_properties(steam_id, key, value)
    --双属性额外设值
    if string.find(key,"attack_and_move") then
        game_playerinfo:set_dynamic_properties(steam_id, "extra_attack_speed",  value)
        game_playerinfo:set_dynamic_properties(steam_id, "move_speed",  value_2)
    elseif string.find(key,"armor_and_resistance") then
        game_playerinfo:set_dynamic_properties(steam_id, "add_armor",  value)
        game_playerinfo:set_dynamic_properties(steam_id, "add_resistance",  value_2)
    end
    hero.dynamic_properties = game_playerinfo:get_dynamic_properties(steam_id)
    --所有属性加成
    CustomNetTables:SetTableValue("dynamic_properties","bead"..hero:GetEntityIndex(),hero.dynamic_properties)
    --记录随机属性 
    local table_key = "player_"..player_id
    local random_properties = global_var_func.player_own_random_properties
    if random_properties["player"..player_id] == nil then
        random_properties["player"..player_id] = {}
    end
    --  local new_value 
    -- if random_properties[key] ~= nil then 
    --     if key == "reduce_attack_scale" and (random_properties[key] + value>80) then
    --         new_value = 80
    --     else
    --         new_value = random_properties[key] + value
    --     end
    -- else
    --     new_value = value
    -- end
    -- random_properties[key] = new_value
    -- DeepPrintTable(ramdom_property)
    
    table.insert(random_properties["player"..player_id],ramdom_property)
    -- DeepPrintTable(random_properties)
    CustomNetTables:SetTableValue( "random_properties", "shahe_property", random_properties)
end

function DoSwordHit(params)
    local mult = params.ability:GetSpecialValueFor("damage_multiple") or 1
    params.caster.sputterDamageInfo.victim = params.target
    params.caster.sputterDamageInfo.damage = params.caster:GetAverageTrueAttackDamage(params.target) * mult
    -- local attackdamage = params.ability:GetSpecialValueFor("attack_damage")
    -- params.caster.sputterDamageInfo.damage =  attackdamage*mult
    ApplyDamage(params.caster.sputterDamageInfo)
end