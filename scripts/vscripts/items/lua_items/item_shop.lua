if item_shop ==nil then
    item_shop = ({})
end
--自定义商店
function item_shop:shopping(evt)
    local player_id = evt.PlayerID
    local item_name = evt.item_name
    local hero = PlayerResource:GetPlayer(player_id):GetAssignedHero()
    local item_cost_table = global_var_func.player_shop_item["player"..player_id] 
    local wood_price = item_cost_table[item_name][1]
    local gold_price = item_cost_table[item_name][2]
    local player_wood = CustomNetTables:GetTableValue("wood_table","wood_table")["wood_"..player_id] or 0
    local player_gold = game_playerinfo:get_player_gold(player_id)
    local message_text = "召唤了"
    local local_key = item_name.."_"..player_id

    --校验冷却时间
    local itemCd = global_var_func.shop_item_cooldown["player"..player_id][item_name]
    if itemCd ~= nill and itemCd >0 then
        local player = PlayerResource:GetPlayer( player_id )
        CustomGameEventManager:Send_ServerToPlayer(PlayerResource:GetPlayer(player_id),"updateItemPrice",{itemName = item_name,itemCD = itemCd,
                ItemInfo = global_var_func.player_shop_item["player"..player_id][item_name],IsCD = 1})
        send_error_tip(player_id,"tip_is_cooldown")
        return
    end
    if not player_wood then 
        player_wood =0
    end
    if player_wood < wood_price then 
        send_error_tip(player_id,"error_nogolden")
        return
    end
    if player_gold < gold_price then 
        send_error_tip(player_id,"error_nomoney")
        return
    end
    --判断购买物品类型
    if string.find(item_name,"_call") then 
        if item_name == "item_cancer_call" then
            local gold = 10000 + 1000 * hero:GetLevel()
            game_playerinfo:set_player_gold(player_id,gold)
            global_var_func.task_call_count_log[tostring(player_id)]["cancer"] = global_var_func.task_call_count_log[tostring(player_id)]["cancer"] + 1
        else
            rule_unit_spawn: CreateTaskUnit(evt.PlayerID,evt.item_name,nil)
        end
    elseif string.find(item_name,"item_noItem") then
        if hero.baowuLimit < 1 then
            send_error_tip(player_id,"error_purchaseLimit")
            return
        end
        item_cost_table[item_name][2] = gold_price +  global_var_func.shop_item_init[item_name][2]
        item_cost_table[item_name][1] = wood_price + global_var_func.shop_item_init[item_name][1] 
        OpenTreasureWindow(player_id)
        hero.baowuLimit = hero.baowuLimit - 1
    else
        if string.find(item_name,"item_book_") then
            --判断购买数量
            local shop_limit = global_var_func.shop_limit[player_id]
            if shop_limit and shop_limit[item_name] and shop_limit[item_name] >= global_var_func.charge_book_limit then
                send_error_tip(player_id,"error_purchaseLimit")
                return
            else
                if not global_var_func.shop_limit[player_id] then
                    global_var_func.shop_limit[player_id] = {}
                end
                if not global_var_func.shop_limit[player_id][item_name] then
                    global_var_func.shop_limit[player_id][item_name] = 0
                end
                global_var_func.shop_limit[player_id][item_name] = 1 + global_var_func.shop_limit[player_id][item_name]
            end
            --更新技能书价格
            item_cost_table[item_name][2] = gold_price + global_var_func.shop_item_init[item_name][2]
        end
        local charge_item = hero:AddItemByName(item_name)
        if not charge_item then
            charge_item = CreateItem(item_name,nil,nil)
            CreateItemOnPositionForLaunch(hero:GetOrigin()+RandomVector(150),charge_item)
        end
    end
    global_var_func.player_shop_item["player"..player_id] = item_cost_table
    --修改木头
    if wood_price > 0 then 
        game_playerinfo:change_player_wood(hero, -wood_price)
    end
    if gold_price >0 then
        --还价佬
        if hero:GetUnitName() == "npc_dota_hero_keeper_of_the_light" and not string.find(item_name,"_call") then
            gold_price = gold_price * 0.3
        end
        game_playerinfo:set_player_gold(player_id,-gold_price)
    end
    --设置冷却时间
    game_playerinfo:set_item_cool_down(player_id,item_name)
    --刷新商店价格/CD
    local itemCD = global_var_func.shop_item_cooldown["player"..player_id][item_name]
    CustomGameEventManager:Send_ServerToPlayer(PlayerResource:GetPlayer(player_id),"updateItemPrice",{itemName = item_name,itemCD = itemCD,ItemInfo = global_var_func.player_shop_item["player"..player_id][item_name]})
    if item_name == "item_custom_gold_call" then 
        send_tips_message_challenge(player_id,nil,PlayerResource:GetPlayerName(player_id),"tip_challenge_gold")
        send_tips_message_challenge(player_id,global_var_func.task_call_count_log[tostring(player_id)]["task_coin"],nil,"tip_challenge_difficulty")
        send_tips_message_challenge(player_id,nil,"DOTA_Tooltip_ability_item_custom_gold_call_reward","tip_challenge_reward")
    elseif item_name == "item_custom_yanmo_call" then 
        send_tips_message_challenge(player_id,nil,PlayerResource:GetPlayerName(player_id),"tip_challenge_yanmo")
        send_tips_message_challenge(player_id,global_var_func.task_call_count_log[tostring(player_id)]["task_golem"],nil,"tip_challenge_difficulty")
        send_tips_message_challenge(player_id,nil,"DOTA_Tooltip_ability_item_custom_guazui_citiao","tip_challenge_reward")
    elseif item_name == "item_custom_ore_call" then 
        send_tips_message_challenge(player_id,nil,PlayerResource:GetPlayerName(player_id),"tip_challenge_ore")
        send_tips_message_challenge(player_id,global_var_func.task_call_count_log[tostring(player_id)]["task_box"],nil,"tip_challenge_difficulty")
        send_tips_message_challenge(player_id,nil,"DOTA_Tooltip_ability_item_custom_ore_call_reward","tip_challenge_reward")
    end
end

function GetItemWoodCost(itemName)
    local itemKvs = GameRules:GetGameModeEntity().ItemKVs
    for k,v in pairs(itemKvs) do
        if k == itemName then 
           return v.ItemWoodCost
        end
    end
end
--挑战提示信息
function send_tips_message_challenge(playerID,int_value,locstring_value,message_text)
    local gameEvent = {}
    gameEvent["player_id"] = playerID
    gameEvent["locstring_value"] = locstring_value
	gameEvent["teamnumber"] = -1
	gameEvent["int_value"] = int_value
	gameEvent["message"] = message_text
	FireGameEvent( "dota_combat_event_message", gameEvent )
end
