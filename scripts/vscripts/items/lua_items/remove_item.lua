require("custom_event_listen")
require("info/game_playerinfo")

if remove_item == nil then 
    remove_item =({})
end

function remove_self(param)
    UTIL_RemoveImmediate(param.ability)
end

function remove_dragon_bead(param)
    local abilityname = param.ability:GetAbilityName()
    if string.sub(abilityname,0,16) == "heroEquipment" then
        local caster = param.caster
        local hero 
        if caster:IsRealHero() then
            hero = caster
        else 
            hero = caster:GetOwner()
        end
       local steam_id = PlayerResource:GetSteamAccountID(hero:GetPlayerID()) 
       --更新碎片信息
    --    game_playerinfo:updata_bead_data(steam_id,abilityname,hero)
       --刷新属性
       hero:CalculateStatBonus(true)
    --    ParticleManager:CreateParticle("particles/econ/events/battlecup/battle_cup_summer2016_destroy.vpcf",PATTACH_OVERHEAD_FOLLOW,param.caster)
    --  ParticleManager:CreateParticle("particles/units/heroes/hero_omniknight/omniknight_guardian_angel_wings_buff_rubick.vpcf",PATTACH_OVERHEAD_FOLLOW,param.caster)
       local pindex= ParticleManager:CreateParticle("particles/econ/items/axe/axe_ti9_immortal/axe_ti9_gold_call.vpcf",PATTACH_OVERHEAD_FOLLOW,hero)
       ParticleManager:ReleaseParticleIndex(pindex)
    end
    UTIL_RemoveImmediate(param.ability)
end

function remove_illusions(param)
    local caster =param.caster
    local hero;
    if caster:IsRealHero() then
        hero = caster
    else
        hero = caster:GetOwner()
    end
    if hero:IsAlive() then
        local illusions = CreateIllusions(hero, hero, {
            outgoing_damage = 50,	-- 造成50%的伤害
            incoming_damage = 300,	-- 受到300%的伤害
            bounty_base = 15,	-- 击杀获得15金钱
            outgoing_damage_structure = 10,	-- 对建筑造成10%伤害
            outgoing_damage_roshan = 60	-- 对肉山造成60%伤害
        }, 1, 50, true, true)
        for k,v in pairs(illusions) do
            v:SetOwner(hero)
            v:AddNewModifier(nil, nil, "modifier_item_rune_illusions", { duration = 15 })
        end
    end
    UTIL_RemoveImmediate(param.ability)
end

function rune_remove_self(param)
    if IsServer() then
        local caster =param.caster
        local hero;
        if caster:IsRealHero() then
            hero = caster
        else
            hero = caster:GetOwner()
        end
        local item_name = param.ability:GetAbilityName()
        local duration = 10
        local itemKvs = GameRules:GetGameModeEntity().ItemKVs
        local break_flag = false
        for k,v in pairs(itemKvs) do
            if break_flag then
                break
            end
            if k == item_name then 
                for ak,av in pairs(v.AbilitySpecial) do
                    for _ak,_av in pairs(av) do
                        if _ak == "duration" then 
                            duration = _av
                        end
                    end
                end
                break_flag = true
            end
        end
        local modifier_name = "modifier_"..item_name
        hero:AddNewModifier(hero,nil,modifier_name,{duration = duration})
        UTIL_RemoveImmediate(param.ability)
    end
end

function remove_wudi(params)
    local ability = params.ability
    local ability_name = ability:GetAbilityName()
    local caster = params.caster
    for i=0 ,5 do 
        local item = caster:GetItemInSlot(i)
        if item then
            if ability_name == item:GetAbilityName() then
                if item:GetCurrentCharges() > 1 then
                    local local_charges = item:GetCurrentCharges()-1
                    item:SetCurrentCharges(local_charges)
                else
                    UTIL_Remove(item)
                end
                break
            end
        end
    end
end

local index = 1
local heroList = nil

function do_function(evt)
    -- local level = evt.caster:AddAbility("call_shebang_d")
    -- level:SetLevel(1)
    -- sendresult(false, rule_unit_spawn:GetGameTime())
    -- evt.caster:CalculateStatBonus(true)
    -- print(">>>><<<<<<<<>>>>>>>>>>>>><<<<<<<<<<<<")
    -- AddTreasureForHero(evt.caster, "modifier_treasure_nuyi", {})
    
    -- if index ==1 then
    --     evt.caster:AddItemByName("item_custom_guazui")
    -- end
    -- index = index + 1
    -- common_item_ability:random_property_yanmo(evt.caster)
    -- AddTreasureForHero(evt.caster, "modifier_treasure_osiris_3", {duration=10})
    -- OpenTreasureWindow(evt.caster:GetPlayerID(), 3)
    -- evt.caster:AddAbility("sublime_jindan"):SetLevel(1)
end

function do_ability(evt)
    -- local vims = FindUnitsInRadius( evt.caster:GetTeam(), evt.caster:GetOrigin(), nil, 500, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_ALL, 0, 0, false )
    -- if vims[1] then
    --     vims[1]:AddNewModifier(evt.caster,nil,"modifier_passive_lightning_chain_unit_thinker",{basedamage = 1000,damage = 10}) 
    -- end
    -- evt.caster:AddNewModifier(evt.caster, nil, "modifier_treasure_convoy", {})
    
    local level = evt.caster:AddAbility("call_shebang_s")
    level:SetLevel(1)
end

function remove_call_materials(params)
    local ability = params.ability
    local ability_name = ability:GetAbilityName()
    local caster = params.caster
    if not caster:IsHero() then
        caster = caster:GetOwner()
    end
    local player_id = caster:GetPlayerID()
    local steam_id = PlayerResource:GetSteamAccountID(player_id)
    game_playerinfo:update_save_item_number(steam_id, ability_name, 1)
    local amount = ability:GetCurrentCharges()
    if amount > 1 then
        ability:SetCurrentCharges(amount-1)
    else
        UTIL_Remove(ability)
    end
    local ck_data_sh,ck_data_zh = herosublimesys:get_store_item_info(steam_id)
	CustomGameEventManager:Send_ServerToPlayer(PlayerResource:GetPlayer(player_id), "response_take_item",{ck_data_sh = ck_data_sh,ck_data_zh = ck_data_zh,take_name="do_call_boss"})
end

function remove_advanced_materials(params)
    local ability = params.ability
    local ability_name = ability:GetAbilityName()
    local steam_id = PlayerResource:GetSteamAccountID(params.caster:GetPlayerID())
    game_playerinfo:update_save_item_number(steam_id, ability_name, 1)
    UTIL_Remove(ability)
end

function remove_boss_marterial(params)
    local item = params.ability
    local caster = params.caster
    if not caster:IsHero() then
        caster = caster:GetOwner()
    end
    local amount = item:GetCurrentCharges()
    if  amount > 1 then
        item:SetCurrentCharges(amount-1)
    else
        UTIL_Remove(item)
    end
    local steam_id =  PlayerResource:GetSteamAccountID(caster:GetPlayerID())
    local dropAmount = random_marterial_amount(GameRules:GetCustomGameDifficulty())
    for i=1,dropAmount do
        local materialList = herosublimesys:GetSublimeMaterialList()
        local itemName = herosublimesys:GetSublimeMaterialList()[RandomInt(1,#materialList)]
        game_playerinfo:update_save_item_number(steam_id, itemName, 1)
    end
	local ck_data_sh,ck_data_zh = herosublimesys:get_store_item_info(steam_id)
    CustomGameEventManager:Send_ServerToPlayer(PlayerResource:GetPlayer(caster:GetPlayerID()), "response_take_item",{ck_data_sh = ck_data_sh,ck_data_zh = ck_data_zh,take_name="do_sublime",ability_refresh="noRefresh"})
    caster:EmitSound("drop.fireworks")
end

function random_marterial_amount(max)
    local dropItem = max * 10
    if max == 1 then
        return dropItem 
    else
        return RandomInt(dropItem-5 , dropItem + 5)
    end
end

function remove_jindan(params)
    local caster = params.caster
    if not caster:IsHero() then
        caster = caster:GetOwner()
    end
    local chance = RandomInt(1, 100)
    if chance==1 then
        game_playerinfo:set_player_gold(caster:GetPlayerID(),60000)
    else
        game_playerinfo:set_player_gold(caster:GetPlayerID(),RandomInt(5000, 13000))
    end
    UTIL_Remove(params.ability)
end

function remove_parts(params)
    local caster = params.caster
    if caster.last_parts and caster.last_parts == params.ability:GetEntityIndex() then
        UTIL_Remove(params.ability)
        return
    end
    caster.last_parts = params.ability:GetEntityIndex()
    if not caster:IsHero() then
        caster = caster:GetOwner()
    end
    caster:Heal(caster:GetMaxHealth()*0.1,caster)
    caster:GiveMana(caster:GetMaxMana()*0.05)
    local mdf = caster:FindModifierByName("modifier_mechanical_modification_add")
    mdf:SetStackCount(mdf:GetStackCount() + 3)
    UTIL_Remove(params.ability)
end

function remove_collection(params)
    -- 使用珍藏道具的结果
    local caster = params.caster
    if not caster:IsHero() then
        caster = caster:GetOwner()
    end
    game_playerinfo:change_player_wood(caster, 1)
    PopupWoodGain(caster, 1)
    UTIL_Remove(params.ability)
end

function remove_regeneration(params)
    local caster = params.caster
    if caster:IsHero() == false then
        caster = caster:GetOwner()
    end
    if caster.last_regeneration and caster.last_regeneration == params.ability:GetEntityIndex() then
        UTIL_Remove(params.ability)
        return
    end
    caster.last_regeneration = params.ability:GetEntityIndex()
    caster:SetHealth(caster:GetMaxHealth())
    caster:SetMana(caster:GetMaxMana())
    UTIL_Remove(params.ability)
end


function remove_haste(params)
    local caster = params.caster
    if caster:IsHero() == false then
        caster = caster:GetOwner()
    end
    if caster.last_haste and caster.last_haste == params.ability:GetEntityIndex() then
        UTIL_Remove(params.ability)
        return
    end
    caster.last_haste = params.ability:GetEntityIndex()
    caster:AddNewModifier(caster,params.ability,"modifier_item_custom_rune_haste02", {Duration=20})
    UTIL_Remove(params.ability)
end

function remove_rune_gold(params)
    local caster = params.caster
    if caster:IsHero() == false then
        caster = caster:GetOwner()
    end
    if caster.last_rune_gold and caster.last_rune_gold == params.ability:GetEntityIndex() then
        UTIL_Remove(params.ability)
        return
    end
    caster.last_rune_gold = params.ability:GetEntityIndex()
    local player_count = global_var_func.all_player_amount
    for i = 0, player_count-1 do
        local player = PlayerResource:GetPlayer( i )
        if player ~= nil then 
            local player_hero = player:GetAssignedHero()
            game_playerinfo:set_player_gold(i,500)
            utils_popups:ShowGoldGain(player_hero, 500)
            local pindex = ParticleManager:CreateParticle( "particles/econ/courier/courier_flopjaw_gold/flopjaw_death_gold.vpcf", PATTACH_ABSORIGIN_FOLLOW, player_hero )
            ParticleManager:ReleaseParticleIndex(pindex)
        end
    end
    UTIL_Remove(params.ability)
end

function remove_rune_magice(params)
    local caster = params.caster
    if caster:IsHero() == false then
        caster = caster:GetOwner()
    end
    if caster.last_rune_magice and caster.last_rune_magice == params.ability:GetEntityIndex() then
        UTIL_Remove(params.ability)
        return
    end
    caster.last_rune_magice = params.ability:GetEntityIndex()
    local duration = params.ability:GetSpecialValueFor("duration")
    caster:AddNewModifier(caster,params.ability,"modifier_item_rune_magice",{duration = duration})
    UTIL_Remove(params.ability)
end

function remove_rune_yinshen(params)
    local caster = params.caster
    if caster:IsHero() == false then
        caster = caster:GetOwner()
    end
    if caster.last_rune_yinshen and caster.last_rune_yinshen == params.ability:GetEntityIndex() then
        UTIL_Remove(params.ability)
        return
    end
    caster.last_rune_yinshen = params.ability:GetEntityIndex()
    local duration = params.ability:GetSpecialValueFor("duration")
    caster:AddNewModifier(caster,params.ability,"modifier_item_rune_yinshen",{duration = duration})
    UTIL_Remove(params.ability)
end

function remove_rune_speed(params)
    local caster = params.caster
    if caster:IsHero() == false then
        caster = caster:GetOwner()
    end
    if caster.last_rune_speed and caster.last_rune_speed == params.ability:GetEntityIndex() then
        UTIL_Remove(params.ability)
        return
    end
    caster.last_rune_speed = params.ability:GetEntityIndex()
    local duration = params.ability:GetSpecialValueFor("duration")
    caster:AddNewModifier(caster,params.ability,"modifier_item_rune_speed",{duration = duration})
    UTIL_Remove(params.ability)
end

function remove_rune_abook(params)
    local caster = params.caster
    if caster:IsHero() == false then
        caster = caster:GetOwner()
    end
    if caster.last_rune_abook and caster.last_rune_abook == params.ability:GetEntityIndex() then
        UTIL_Remove(params.ability)
        return
    end
    local rand_int = 0
    caster.last_rune_abook = params.ability:GetEntityIndex()
    local item_name = params.ability:GetName()
    if string.find(item_name,"item_add_strength") then
        if(item_name == "item_add_strength_1") then
            utils_popups:ShowDamageOverTime(caster, 1)
            caster:ModifyStrength(1)
        elseif(item_name == "item_add_strength_2") then
            utils_popups:ShowDamageOverTime(caster, 2)
            caster:ModifyStrength(2)
        elseif(item_name == "item_add_strength_3") then
            utils_popups:ShowDamageOverTime(caster, 3)
            caster:ModifyStrength(3)
        end
       
    elseif string.find(item_name,"item_add_agility") then
        if(item_name == "item_add_agility_1") then
            utils_popups:ShowDamageOverTime(caster, 1)
            caster:ModifyAgility(1)
        elseif(item_name == "item_add_agility_2") then
            utils_popups:ShowDamageOverTime(caster, 2)
            caster:ModifyAgility(2)
        elseif(item_name == "item_add_agility_3") then
            utils_popups:ShowDamageOverTime(caster, 3)
            caster:ModifyAgility(3)
        end
     
    elseif string.find(item_name,"item_add_intellect") then
        if(item_name == "item_add_intellect_1") then
            utils_popups:ShowDamageOverTime(caster, 1)
            caster:ModifyIntellect(1)
        elseif(item_name == "item_add_intellect_2") then
            utils_popups:ShowDamageOverTime(caster, 2)
            caster:ModifyIntellect(2)
        elseif(item_name == "item_add_intellect_3") then
            utils_popups:ShowDamageOverTime(caster, 3)
            caster:ModifyIntellect(3)
        end
     
    elseif string.find(item_name,"item_add_health") then
        if(item_name == "item_add_health_1") then
          
            rand_int = RandomInt(20, 30);
            utils_popups:ShowDamageOverTime(caster, rand_int)
            caster:AddNewModifier( caster, nil, "modifier_hero_add_health", {add_health = rand_int}  )
        elseif(item_name == "item_add_health_2") then
            rand_int = RandomInt(30, 40);
            utils_popups:ShowDamageOverTime(caster, rand_int)
            caster:AddNewModifier( caster, nil, "modifier_hero_add_health", {add_health = rand_int}  )
        elseif(item_name == "item_add_health_3") then
            rand_int = RandomInt(40, 50);
            utils_popups:ShowDamageOverTime(caster, rand_int)
            caster:AddNewModifier( caster, nil, "modifier_hero_add_health", {add_health = rand_int}  )
        end
    elseif string.find(item_name,"item_add_aggressivity") then
        if(item_name == "item_add_aggressivity_1") then
            rand_int = RandomInt(1, 2);
            utils_popups:ShowDamageOverTime(caster, rand_int)
            local steam_id = PlayerResource:GetSteamAccountID(caster:GetPlayerID()) 
            game_playerinfo:set_dynamic_properties(steam_id, "add_baseattack", rand_int)
        elseif(item_name == "item_add_aggressivity_2") then
  
            rand_int = RandomInt(3, 4);
            utils_popups:ShowDamageOverTime(caster, rand_int)
            local steam_id = PlayerResource:GetSteamAccountID(caster:GetPlayerID()) 
            game_playerinfo:set_dynamic_properties(steam_id, "add_baseattack", rand_int)
        elseif(item_name == "item_add_aggressivity_3") then
            utils_popups:ShowDamageOverTime(caster, 5)
            local steam_id = PlayerResource:GetSteamAccountID(caster:GetPlayerID()) 
            game_playerinfo:set_dynamic_properties(steam_id, "add_baseattack", 5)
 
        end
    -- elseif string.sub(item_name,0,16) == "heroEquipment" then 
    --    local steam_id = PlayerResource:GetSteamAccountID(hero:GetPlayerID()) 
    --    --更新碎片信息
    --    game_playerinfo:updata_bead_data(steam_id,item_name,hero)
    end
   
    -- local duration = params.ability:GetSpecialValueFor("duration")
    -- caster:AddNewModifier(caster,params.ability,"modifier_item_rune_magice",{duration = duration})
    UTIL_Remove(params.ability)

end


function remove_rune_double(params)
    local caster = params.caster
    if caster:IsHero() == false then
        caster = caster:GetOwner()
    end
    if caster.last_rune_double and caster.last_rune_double == params.ability:GetEntityIndex() then
        UTIL_Remove(params.ability)
        return
    end
    caster.last_rune_double = params.ability:GetEntityIndex()
    local duration = params.ability:GetSpecialValueFor("duration")
    caster:AddNewModifier(caster,params.ability,"modifier_item_rune_double",{duration = duration})
    UTIL_Remove(params.ability)
end

-- function random_book(params)
--     if IsServer() then
--         deep_log(params)
--     end
-- end

function remove_box_bronze(params)
    if params.caster.last_box_bronze and params.caster.last_box_bronze == params.ability:GetEntityIndex() then
        UTIL_Remove(params.ability)
        return
    end
    params.caster.last_box_bronze = params.ability:GetEntityIndex()
    UTIL_Remove(params.ability)
    -- 法老王的馈赠
    local item = CreateItem("item_noItem_baoWu_book", nil, nil)
    item:SetPurchaser(params.caster)
    local pos = params.caster:GetOrigin()
    CreateItemOnPositionSync(pos, item)
    item:LaunchLoot(false, 200, 0.75, pos + RandomVector(RandomFloat(150,200)))
end

function remove_box_silver(params)
    if params.caster.last_box_silver and params.caster.last_box_silver == params.ability:GetEntityIndex() then
        UTIL_Remove(params.ability)
        return
    end
    params.caster.last_box_silver = params.ability:GetEntityIndex()
    UTIL_Remove(params.ability)
    -- 法老王的馈赠
    local item = CreateItem("item_noItem_baoWu_book", nil, nil)
    item:SetPurchaser(params.caster)
    local pos = params.caster:GetOrigin()
    CreateItemOnPositionSync(pos, item)
    item:LaunchLoot(false, 200, 0.75, pos + RandomVector(RandomFloat(150,200)))
    -- 杀神之心
    item = CreateItem("item_killing_heart_2", nil, nil)
    pos = params.caster:GetOrigin()
    CreateItemOnPositionSync(pos, item)
    item:LaunchLoot(false, 200, 0.75, pos + RandomVector(RandomFloat(150,200)))
end

function remove_box_gold(params)
    if params.caster.last_box_gold and params.caster.last_box_gold == params.ability:GetEntityIndex() then
        UTIL_Remove(params.ability)
        return
    end
    params.caster.last_box_gold = params.ability:GetEntityIndex()
    UTIL_Remove(params.ability)
    local books = {
        ["item_add_strength_1"] = 12,
        ["item_add_strength_2"] = 6,
        ["item_add_strength_3"] = 2,
        ["item_add_agility_1"] = 12,
        ["item_add_agility_2"] = 6,
        ["item_add_agility_3"] = 2,
        ["item_add_intellect_1"] = 12,
        ["item_add_intellect_2"] = 6,
        ["item_add_intellect_3"] = 2,
        ["item_add_health_1"] = 12,
        ["item_add_health_2"] = 6,
        ["item_add_health_3"] = 2,
        ["item_add_aggressivity_1"] = 12,
        ["item_add_aggressivity_2"] = 6,
        ["item_add_aggressivity_3"] = 2,
    }
    local max = RandomInt(32, 44)
    local count = 0
    while count < max do
        for key, value in pairs(books) do
            if RollPercentage(value) then
                local item = CreateItem(key, nil, nil)
                local pos = params.caster:GetOrigin()
                CreateItemOnPositionSync(pos, item)
                item:LaunchLoot(false, 200, 0.75, pos + RandomVector(RandomFloat(150,200)))
                count = count + 1
                if count >= max then
                    break
                end
            end
        end 
    end
    -- 法老王的馈赠
    local item = CreateItem("item_noItem_baoWu_book", nil, nil)
    item:SetPurchaser(params.caster)
    local pos = params.caster:GetOrigin()
    CreateItemOnPositionSync(pos, item)
    item:LaunchLoot(false, 200, 0.75, pos + RandomVector(RandomFloat(150,200)))
    -- 杀神之心
    item = CreateItem("item_killing_heart_3", nil, nil)
    pos = params.caster:GetOrigin()
    CreateItemOnPositionSync(pos, item)
    item:LaunchLoot(false, 200, 0.75, pos + RandomVector(RandomFloat(150,200)))
end

function remove_killing_heart_1(params)
    if params.caster.last_killing_heart and params.caster.last_killing_heart == params.ability:GetEntityIndex() then
        UTIL_Remove(params.ability)
        return
    end
    params.caster.last_killing_heart = params.ability:GetEntityIndex()
    UTIL_Remove(params.ability)
    if params.caster:IsHero() == false then
        params.caster = params.caster:GetOwner()
    end
    local mdf = params.caster:FindModifierByName("modifier_killing_heart")
    mdf:SetStackCount(mdf:GetStackCount() + 0)
end

function remove_killing_heart_2(params)
    if params.caster.last_killing_heart and params.caster.last_killing_heart == params.ability:GetEntityIndex() then
        UTIL_Remove(params.ability)
        return
    end
    params.caster.last_killing_heart = params.ability:GetEntityIndex()
    UTIL_Remove(params.ability)
    if params.caster:IsHero() == false then
        params.caster = params.caster:GetOwner()
    end
    local mdf = params.caster:FindModifierByName("modifier_killing_heart")
    mdf:SetStackCount(mdf:GetStackCount() + 5)
end

function remove_killing_heart_3(params)
    if params.caster.last_killing_heart and params.caster.last_killing_heart == params.ability:GetEntityIndex() then
        UTIL_Remove(params.ability)
        return
    end
    params.caster.last_killing_heart = params.ability:GetEntityIndex()
    UTIL_Remove(params.ability)
    if params.caster:IsHero() == false then
        params.caster = params.caster:GetOwner()
    end
    local mdf = params.caster:FindModifierByName("modifier_killing_heart")
    mdf:SetStackCount(mdf:GetStackCount() + 15)
end