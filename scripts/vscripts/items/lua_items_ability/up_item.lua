--物品升级
function item_up(params)
    local item_name =params.ability:GetAbilityName()
    local caster = params.caster
    if string.find(item_name,"bone") then
        item_exchange(caster,item_name,"item_custom_sword_iron_0",1)
	elseif string.find(item_name,"sword_iron") then
        item_exchange(caster,item_name,"item_custom_sword_silver_0",2)
    elseif string.find(item_name,"sword_silver") then
        item_exchange(caster,item_name,"item_custom_sword_gold_0",3)
    elseif string.find(item_name,"sword_gold") then
        item_exchange(caster,item_name,"item_custom_sword_wangzhe_0",4)
    elseif string.find(item_name,"sword_wangzhe") then
        item_exchange(caster,item_name,"item_custom_sword_wangzhe_0",5)
    elseif string.find(item_name,"armor_cloth") then
        item_exchange(caster,item_name,"item_custom_armor_fur_0",1)
    elseif string.find(item_name,"armor_fur") then
        item_exchange(caster,item_name,"item_custom_armor_iron_0",2)
    elseif string.find(item_name,"armor_iron") then
        item_exchange(caster,item_name,"item_custom_armor_gold_0",3)
    elseif string.find(item_name,"armor_gold") then
        item_exchange(caster,item_name,"item_custom_armor_wangzhe_0",4)
    elseif string.find(item_name,"armor_wangzhe") then
        item_exchange(caster,item_name,"item_custom_armor_wangzhe_0",5)
    elseif string.find(item_name,"ring_wood") then
        item_exchange(caster,item_name,"item_custom_ring_iron_0",1)
    elseif string.find(item_name,"ring_iron") then
        item_exchange(caster,item_name,"item_custom_ring_copper_0",2)
    elseif string.find(item_name,"ring_copper") then
        item_exchange(caster,item_name,"item_custom_ring_gold_0",3)
    elseif string.find(item_name,"ring_gold") then
        item_exchange(caster,item_name,"item_custom_ring_wangzhe_0",4)
    elseif string.find(item_name,"ring_wangzhe") then
        item_exchange(caster,item_name,"item_custom_ring_wangzhe_0",5)
	end
	-- body
	--RemoveItem 	Removes a modifier.
	--GetItemInSlot  index
	--SwapItems(int nSlot1, int nSlot2)
	--TakeItem 删除
    --AddItem
end

-- 临时记录每个玩家的装备升级额外成功率
local levelup_chance = {
    -- [player_id] = 0,
}

function item_exchange(caster,item_name,new_item_name,item_quality)
    local item_name_pre = string.sub(item_name,0,string.len(item_name)-1)
    local level = tonumber(string.sub(item_name,-1))
    if item_name == "item_custom_sword_wangzhe_5" or item_name == "item_custom_armor_wangzhe_5" 
        or item_name == "item_custom_ring_wangzhe_5" then 
        return
    end
    --  if item_name == "item_custom_sword_gold_5" or item_name == "item_custom_armor_gold_5" 
    --     or item_name == "item_custom_ring_gold_5" then 
    --     return
    -- end
    local casterHero = caster
    if not caster:IsRealHero(  ) then
        casterHero = caster:GetOwner(  )
    end
    local gold_cost = 0
    if level == 5 then 
        gold_cost = config_item:get_item_up_cost(item_quality,true)
    else
        gold_cost = config_item:get_item_up_cost(item_quality,false)
    end
    local player_id= casterHero:GetPlayerID()
    
    local gold = game_playerinfo:get_player_gold(player_id)
    if gold < gold_cost then 
        send_error_tip(player_id,"error_nomoney")
        return
    end
    local steam_id = PlayerResource:GetSteamAccountID(player_id)
    local chance = 100
    if item_quality == 1 then 
        --chance = 90
    elseif item_quality == 2 then
        chance = 80
    elseif item_quality == 3 then
        chance = 60
    elseif item_quality == 4 then
        chance = 40
    elseif item_quality == 5 then
        chance = 20
    end
    if casterHero:GetUnitName() == "npc_dota_hero_rubick" then
        chance = 100
    end
    if not levelup_chance[player_id] then
        levelup_chance[player_id] = 0
    end
    if chance < 100 then
        chance = chance + levelup_chance[player_id]
        if chance >= 100 then
            chance = 100
        end
    end
    for i=0,8 do 
        local item_handle =  caster:GetItemInSlot(i)
        if item_handle and item_handle:GetAbilityName() == item_name then
            item_handle:EmitSound("hero.duanzao")
            if level < 5 then
                game_playerinfo:set_player_gold(player_id,-gold_cost)
                local is_up = false
                if item_handle.level_count and item_handle.level_count>=4 then
                    chance = 100
                end
                if RollPercentage(chance) then 
                    -- send_tips_message(player_id,"升级成功")
                    is_up = true
                    ParticleManager:CreateParticle("particles/econ/events/ti9/hero_levelup_ti9.vpcf",PATTACH_POINT_FOLLOW,caster)
                    -- caster:TakeItem(item_handle)
                    UTIL_Remove(item_handle)
                    local add_item = caster:AddItemByName(item_name_pre..level+1)
                    add_item:SetPurchaseTime(0)
                    local new_name = add_item:GetAbilityName()
                    game_playerinfo:resetquipmentname(player_id, item_name, new_name)
                    
                    levelup_chance[player_id] = 0
                else 
                    if string.find(item_name,"_wangzhe_") then
                        item_handle.level_count = (item_handle.level_count or 0) + 1
                    end
                    -- send_tips_message(player_id,"升级失败")
                    local player_count = global_var_func.all_player_amount
                    local haslaohaoren = false
                    local haslvmaoxia = false
                    if "npc_dota_hero_bristleback" == casterHero:GetUnitName() then
                        -- 绿帽侠
                        haslvmaoxia = true
                    end
                    for playerid = 0, player_count-1 do
                        local player = PlayerResource:GetPlayer(playerid)
                        if player:IsNull() then
                            break
                        end
                        if not player then
                            break
                        end
                        
                        local hero = player:GetAssignedHero()
                        local hero_name = hero:GetUnitName()
                        if "npc_dota_hero_rattletrap" == hero_name then
                            -- 坏心眼
                            local add_value = 0
                            if hero:FindAbilityByName("sublime_xingzailehuo_lua") then
                                add_value = gold_cost*0.001
                            end
                            
                            SetBaseStrength(hero, 15+add_value)
                            SetBaseAgility(hero, 15+add_value)
                            SetBaseIntellect(hero, 15+add_value)
                        end
                        if "npc_dota_hero_riki" == hero_name then
                            haslaohaoren = true
                            -- 老好人额外获得20%金钱返还
                            game_playerinfo:set_player_gold(playerid, gold_cost*0.2)
                        end
                        if haslvmaoxia then
                            -- 场上有绿帽侠,每人获得15点全属性
                            SetBaseStrength(hero, 15)
                            SetBaseAgility(hero, 15)
                            SetBaseIntellect(hero, 15)
                        end
                    end
                    if haslaohaoren then
                        -- 场上有老好人,失败的人获得35%金钱返还
                        game_playerinfo:set_player_gold(player_id, gold_cost*0.35)
                    end
                    -- local steam_id = PlayerResource:GetSteamAccountID(player_id)
                    -- local _info = game_playerinfo:get_player_store()[steam_id]
                    -- if _info then
                    --     if _info.vip_2 == 1 then
                    --         -- 黄金祝福,升级失败返还金币
                    --         local randpm_return = RandomInt(1, 5) * 0.1
                    --         local return_gold = gold_cost * randpm_return
                    --         casterHero:ModifyGold(return_gold, true, DOTA_ModifyGold_CreepKill)
                    --     end
                    -- end
                    levelup_chance[player_id] = levelup_chance[player_id] + game_playerinfo:get_dynamic_properties_by_key(steam_id, "extra_success_rate")
                end
                CustomGameEventManager:Send_ServerToPlayer(PlayerResource:GetPlayer(player_id),"item_up_tip",{is_up = is_up})
                break
            elseif level==5 then
                local hero_kill_key = item_name_pre..player_id
         
                --判断是否召唤升级怪
                if item_handle.advance_boss == nil or item_handle.advance_boss:IsNull() or item_handle.advance_boss:IsAlive() ==false then 
                    --召唤升级怪
                    game_playerinfo:set_player_gold(player_id,-gold_cost)
                    local callunit = rule_unit_spawn: CreateTaskUnit ( player_id, item_name, item_quality)
                    item_handle.advance_boss = callunit
                end
                -- casterHero:AddItemByName(new_item_name)
                break
            end
        end
    end
end