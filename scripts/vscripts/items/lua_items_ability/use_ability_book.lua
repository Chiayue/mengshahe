require("info/game_playerinfo")
require("global/random_affix")
local player_affix = {
    [0] = {
        active_affix = {

        },
        passive_affix = {
            
        },
        chaos__affix = {
            
        },
    },
    [1] = {
        active_affix = {

        },
        passive_affix = {
            
        },
        chaos__affix = {
            
        },
    },
    [2] = {
        active_affix = {

        },
        passive_affix = {
            
        },
        chaos__affix = {
            
        },
    },
    [3] = {
        active_affix = {

        },
        passive_affix = {
            
        },
        chaos__affix = {
            
        },
    },
}
--使用技能书随机技能
function item_book_use(params)
    local item_name = params.ability:GetAbilityName()
    local caster = params.caster
    local casterHero = caster
    if not caster:IsRealHero(  ) then
        casterHero = caster:GetOwner( )
    end
    local player_id= casterHero:GetPlayerID() 
    -- local player = PlayerResource:GetPlayer(player_id)
    local steam_id = PlayerResource:GetSteamAccountID(player_id)
    for i=0,5 do
        local item_handle = caster:GetItemInSlot(i)
        if item_handle and item_handle:GetAbilityName() == item_name then
            --判断物品数量
            local item_charges = item_handle:GetCurrentCharges()
            if item_charges > 1 then
                item_handle:SetCurrentCharges(item_charges-1)
            else
                UTIL_Remove(item_handle)
                -- caster:TakeItem(item_handle)
            end
            --随机技能
            if string.find(item_name,"passive") then
                -- 先将原本技能洗掉,替换成默认空格技能
                local old_name = game_playerinfo:get_player_passive(steam_id)
                -- print(" >>>>>>>>>>>>> old_name: "..old_name)
                if old_name~="passive_position_lua" then
                    casterHero:SwapAbilities("passive_position_lua", old_name, true, false)
                    casterHero:RemoveAbility(old_name)
                    if player_affix[player_id].passive_affix.front then
                        casterHero:AddNewModifier(casterHero, nil, player_affix[player_id].passive_affix.front, {type = 2, abilityname = old_name})
                    end
                    if player_affix[player_id].passive_affix.back then
                        casterHero:AddNewModifier(casterHero, nil, player_affix[player_id].passive_affix.back, {type = 2, abilityname = old_name})
                    end
                    old_name = "passive_position_lua"
                end
                
                local new_name = system_ability:setability(string.sub(item_name,-1),"passive", steam_id)
                if not new_name then
                    send_error_tip(player_id, "error_useabilitybook")
                    return
                end
                -- print(" >>>>>>>>>>>>> new_name: "..new_name)
                local new_ability = casterHero:AddAbility(new_name)
                new_ability:SetLevel(1)
                casterHero:SwapAbilities(new_name, old_name, true, false)
                casterHero:RemoveAbility(old_name)
                
                game_playerinfo:set_player_passive(steam_id, new_name)
                -- local modifierName = random_affix:AddNewRandomModifier(casterHero, nil, {type = 1, abilityname = new_name}, "f")
                -- player_affix[player_id].passive_affix.front = modifierName
                -- modifierName = random_affix:AddNewRandomModifier(casterHero, nil, {type = 1, abilityname = new_name}, "b")
                -- player_affix[player_id].passive_affix.back = modifierName
                --移除技能提供modifier
                local allModifier = casterHero:FindAllModifiers()
                for _,md in pairs(allModifier) do
                    if md:GetAbility() ~= nil then
                        local mdAbility = md:GetAbility():GetAbilityName()
                        if mdAbility == old_name then
                            md:Destroy()
                            print(mdAbility)
                        end
                    end
                end
            elseif string.find(item_name,"initiative") then
                local old_name = game_playerinfo:get_player_active(steam_id)
                if old_name~="active_position_lua" then
                    casterHero:SwapAbilities("active_position_lua", old_name, true, false)
                    casterHero:RemoveAbility(old_name)
                    if player_affix[player_id].active_affix.front then
                        casterHero:AddNewModifier(casterHero, nil, player_affix[player_id].active_affix.front, {type = 2, abilityname = old_name})
                    end
                    if player_affix[player_id].active_affix.back then
                        casterHero:AddNewModifier(casterHero, nil, player_affix[player_id].active_affix.back, {type = 2, abilityname = old_name})
                    end
                    old_name = "active_position_lua"
                end

                local new_name = system_ability:setability(string.sub(item_name,-1),"initiative",steam_id)
                if not new_name then
                    send_error_tip(player_id, "error_useabilitybook")
                    return
                end
                local new_ability = casterHero:AddAbility(new_name)
                new_ability:SetLevel(1)
                casterHero:SwapAbilities(new_name, old_name, true, false)
                casterHero:RemoveAbility(old_name)

                game_playerinfo:set_player_active(steam_id, new_name)
                -- local modifierName = random_affix:AddNewRandomModifier(casterHero, nil, {type = 1, abilityname = new_name}, "f")
                -- player_affix[player_id].active_affix.front = modifierName
                -- modifierName = random_affix:AddNewRandomModifier(casterHero, nil, {type = 1, abilityname = new_name}, "b")
                -- player_affix[player_id].active_affix.back = modifierName
            elseif string.find(item_name,"chaos") then
                local randint = RandomInt(0,1)
                local old_name = game_playerinfo:get_player_chaos(steam_id)
                if old_name~="composite_position_lua" then
                    casterHero:SwapAbilities("composite_position_lua", old_name, true, false)
                    casterHero:RemoveAbility(old_name)
                    if player_affix[player_id].chaos__affix.front then
                        casterHero:AddNewModifier(casterHero, nil, player_affix[player_id].chaos__affix.front, {type = 2, abilityname = old_name})
                    end
                    if player_affix[player_id].chaos__affix.back then
                        casterHero:AddNewModifier(casterHero, nil, player_affix[player_id].chaos__affix.back, {type = 2, abilityname = old_name})
                    end
                    old_name = "composite_position_lua"
                end

                local new_name = system_ability:setability(string.sub(item_name,-1),"initiative",steam_id)
                if not new_name then
                    send_error_tip(player_id, "error_useabilitybook")
                    return
                end
                if randint==1 then
                    new_name = system_ability:setability(string.sub(item_name,-1),"passive",steam_id)
                    if not new_name then
                        send_error_tip(player_id, "error_useabilitybook")
                        return
                    end
                end
                local new_ability = casterHero:AddAbility(new_name)
                new_ability:SetLevel(1)
                casterHero:SwapAbilities(new_name, old_name, true, false)
                casterHero:RemoveAbility(old_name)

                game_playerinfo:set_player_chaos(steam_id, new_name)
                -- local modifierName = random_affix:AddNewRandomModifier(casterHero, nil, {type = 1, abilityname = new_name}, "f")
                -- player_affix[player_id].chaos__affix.front = modifierName
                -- modifierName = random_affix:AddNewRandomModifier(casterHero, nil, {type = 1, abilityname = new_name}, "b")
                -- player_affix[player_id].chaos__affix.back = modifierName
            end
            break
        end
    end
end

--使用神职卷轴随机天赋
function item_innateskill_book_use(params)
    local item_name = params.ability:GetAbilityName()
    local caster = params.caster
    local casterHero = caster
    if not caster:IsRealHero(  ) then
        casterHero = caster:GetOwner( )
    end
    local player_id= casterHero:GetPlayerID() 
    -- local player = PlayerResource:GetPlayer(player_id)
    local steam_id = PlayerResource:GetSteamAccountID(player_id)
    local heroName = casterHero:GetUnitName()
    for i=0,5 do
        local item_handle = caster:GetItemInSlot(i)
        if item_handle and item_handle:GetAbilityName() == item_name then
            --判断物品数量
            local item_charges = item_handle:GetCurrentCharges()
            if item_charges > 1 then
                item_handle:SetCurrentCharges(item_charges-1)
            else
                UTIL_Remove(item_handle)
                -- caster:TakeItem(item_handle)
            end
            if string.find(item_name,"item_book_innateskill") then
                --随机技能
                local innateskill_drop_config = deepcopy(config_item_drop:get_innateskill_drop_item())
                if innateskill_drop_config then
                    -- body
                    local nowinnateskill = game_playerinfo:get_player_innateskill(steam_id)
                    -- print(nowinnateskill)
                    -- 排除本身天赋技
                    local heroList = deepcopy(global_var_func:get_hero_ability())
                    if heroList[heroName] then
                        local abilityName = heroList[heroName]["Ability1"]
                        -- print(">>>>>>>>>>>> abilityName: "..abilityName)
                        for index, value in ipairs(innateskill_drop_config) do
                            for i, v in ipairs(value) do
                                if v==abilityName then
                                    -- body
                                    table.remove(value, i)
                                    break
                                end
                            end
                        end
                        -- DeepPrintTable(innateskill_drop_config)
                        local randomInt = RandomInt(1, 100)
                        local newName = ""
                        if 1 <= randomInt and randomInt <= 5 then
                            local rdindex = RandomInt(1, #(innateskill_drop_config[1]))
                            newName = innateskill_drop_config[1][rdindex]
                        elseif 5 < randomInt and randomInt <= 30 then
                            local rdindex = RandomInt(1, #(innateskill_drop_config[2]))
                            newName = innateskill_drop_config[2][rdindex]
                        else 
                            local rdindex = RandomInt(1, #(innateskill_drop_config[3]))
                            newName = innateskill_drop_config[3][rdindex]
                        end
                        if newName then
                            if newName ~= nowinnateskill then
                                --移除原有技能buff
                                local allBuff = casterHero:FindAllModifiers()
                                for _,v in pairs(allBuff) do
                                    local buffAbility = v:GetAbility(  )
                                    if buffAbility and nowinnateskill == buffAbility:GetAbilityName() then
                                        v:Destroy()
                                    end
                                end
                                local new_ability = casterHero:AddAbility(newName)
                                new_ability:SetLevel(1)
                                casterHero:SwapAbilities(newName, nowinnateskill, true, false)
                                casterHero:RemoveAbility(nowinnateskill)
                                game_playerinfo:set_player_innateskill(steam_id, newName)
                            end
                            if not casterHero.hasInnateskill then
                                -- 添加特效
                                -- local nFXIndex = ParticleManager:CreateParticle( "particles/custom_particles/yuzhouxinghe.vpcf", PATTACH_POINT_FOLLOW, casterHero);
                                local nFXIndex = ParticleManager:CreateParticle( "particles/econ/items/slardar/slardar_ti10_head/slardar_ti10_gold_amp_damage.vpcf", PATTACH_POINT_FOLLOW, casterHero);
                                ParticleManager:SetParticleControlEnt(nFXIndex, 0, casterHero, PATTACH_POINT_FOLLOW, "", casterHero:GetOrigin(), true);
                                ParticleManager:SetParticleControlEnt(nFXIndex, 1, casterHero, PATTACH_POINT_FOLLOW, "", casterHero:GetOrigin(), true);
                                ParticleManager:ReleaseParticleIndex(nFXIndex)
                                casterHero.hasInnateskill = 1
                            end
                        end
                    end
                end
            end
            break
        end
    end
end