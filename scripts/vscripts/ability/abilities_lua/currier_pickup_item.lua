function pick_up_drop_item(params)
    local caster = params.caster
    local vc = caster:GetOrigin()
    local entities = Entities:FindAllByClassnameWithin("dota_item_drop",vc,300)
    
    local nFXIndex = ParticleManager:CreateParticle( "particles/econ/events/ti10/soccer_ball/soccer_ball_impact.vpcf", PATTACH_ABSORIGIN_FOLLOW,caster)
    ParticleManager:SetParticleControlForward( nFXIndex, 0, caster:GetOrigin())
    ParticleManager:ReleaseParticleIndex( nFXIndex )
    caster:EmitSound("xingshi.shiqu")
    local itemName 
    for _,v in pairs(entities) do 
        local pickItem = v:GetContainedItem()
        local hasSlot= false
        for i=0,8 do
            local item = caster:GetItemInSlot(i)
            if item == nil  then
                hasSlot = true
                break
            end
        end
        if hasSlot then
            if pickItem:IsCastOnPickup() == false then
                caster:AddItem(pickItem)
            else
                itemName = pickItem:GetName()
                OnPickupCast(caster:GetOwner(),itemName, caster)
            end
            UTIL_Remove(v)
        else
            return
        end
    end
    local hero = caster:GetOwner()
    for i=0 , 8 do 
        local item_handle =  caster:GetItemInSlot(i)
        if item_handle and string.find(item_handle:GetAbilityName(),"item_book_") then
            item_handle:SetPurchaser( hero )
            item_handle:SetSellable(true)
        end
        local hero_item_handle =  hero:GetItemInSlot(i)
        if hero_item_handle and string.find(hero_item_handle:GetAbilityName(),"item_book_") then
            hero_item_handle:SetPurchaser( hero )
            hero_item_handle:SetSellable(true)
        end
    end
end

function send_item_to_hero(params)
    local caster = params.caster
    caster:AddNewModifier( caster, nil, "modifier_currier_send_item", {} )
    -- local owner = caster:GetOwner()
    -- for i=0,5 do
    --     local item = caster:GetItemInSlot(i)
    --     if item then 
    --         caster:MoveToNPCToGiveItem(owner,item)
    --     end
    -- end
end

function OnPickupCast(caster, item_name, currier)
    local rand_int = 0
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
    elseif item_name == "item_box_bronze" then
        -- 法老王的馈赠
        local item = CreateItem("item_noItem_baoWu_book", nil, nil)
        item:SetPurchaser(caster)
        local pos = currier:GetOrigin()
        CreateItemOnPositionSync(pos, item)
        item:LaunchLoot(false, 200, 0.75, pos + RandomVector(RandomFloat(150,200)))
    elseif item_name == "item_box_silver" then
        -- 法老王的馈赠
        local item = CreateItem("item_noItem_baoWu_book", nil, nil)
        item:SetPurchaser(caster)
        local pos = currier:GetOrigin()
        CreateItemOnPositionSync(pos, item)
        item:LaunchLoot(false, 200, 0.75, pos + RandomVector(RandomFloat(150,200)))
        -- 杀神之心
        item = CreateItem("item_killing_heart_2", nil, nil)
        CreateItemOnPositionSync(pos, item)
        item:LaunchLoot(false, 200, 0.75, pos + RandomVector(RandomFloat(150,200)))
    elseif item_name == "item_box_gold" then
        local pos = currier:GetOrigin()
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
        item:SetPurchaser(caster)
        CreateItemOnPositionSync(pos, item)
        item:LaunchLoot(false, 200, 0.75, pos + RandomVector(RandomFloat(150,200)))
        -- 杀神之心
        item = CreateItem("item_killing_heart_3", nil, nil)
        CreateItemOnPositionSync(pos, item)
        item:LaunchLoot(false, 200, 0.75, pos + RandomVector(RandomFloat(150,200)))
    elseif item_name == "item_killing_heart_1" then
    elseif item_name == "item_killing_heart_2" then
        if caster:IsHero() == false then
            caster = caster:GetOwner()
        end
        local mdf = caster:FindModifierByName("modifier_killing_heart")
        mdf:SetStackCount(mdf:GetStackCount() + 5)
    elseif item_name == "item_killing_heart_3" then
        if caster:IsHero() == false then
            caster = caster:GetOwner()
        end
        local mdf = caster:FindModifierByName("modifier_killing_heart")
        mdf:SetStackCount(mdf:GetStackCount() + 15)
    elseif item_name == "item_custom_regeneration01" then
        caster:SetHealth(caster:GetMaxHealth())
        caster:SetMana(caster:GetMaxMana())
    elseif item_name == "item_custom_rune_haste01" then
        caster:AddNewModifier(caster,nil,"modifier_item_custom_rune_haste02", {Duration=20})
    elseif item_name == "item_rune_speed" then
        caster:AddNewModifier(caster,nil,"modifier_item_rune_speed",{duration = 20})
    elseif item_name == "item_rune_double" then
        caster:AddNewModifier(caster,nil,"modifier_item_rune_double",{duration = 20})
    elseif item_name == "item_rune_gold" then
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
    elseif item_name == "item_rune_magice" then
        caster:AddNewModifier(caster,nil,"modifier_item_rune_magice",{duration = 20})
    elseif item_name == "item_consum_money_bag" then
        local time = GameRules:GetDOTATime(false, false)
        if not caster.chanceTable then
            caster.chanceTable = {5,10}
        end
        if 600 < time and time <= 1200 then
            caster.chanceTable[1] = 10
            caster.chanceTable[2] = 30
        elseif 1200 < time then
            caster.chanceTable[1] = 15
            caster.chanceTable[2] = 40
        end
        caster.award_gold = 0
        local chance = RandomInt(0, 100)
        if chance < caster.chanceTable[1] then
            caster.award_gold = 10000 
        elseif caster.chanceTable[1] <= chance  and chance < caster.chanceTable[2] then
            caster.award_gold = 1000
        else
            caster.award_gold = 100
        end
        game_playerinfo:set_player_gold(caster:GetPlayerID(),caster.award_gold)
    end
end