require("info/game_playerinfo")
if custom_thinker ==nil then
    custom_thinker = ({})
end


function custom_thinker:init_after_select_hero()
    local game_model = GameRules:GetGameModeEntity()
    --更新ui金币
    -- game_model:SetContextThink("update_gold_thinker",function()
    --     update_ui_gold()
    --     return 0.05
    -- end,0)
    
    
    --更新游戏剩余时间时间
    game_model:SetContextThink("update_game_time_ui",function()
        return update_game_time_ui()
    end,0)
    
    --检测游戏时间,更改属性
    game_model:SetContextThink("update_player_treasure_number",function()
        return update_player_treasure_number()
    end,0)
end


function custom_thinker:init_at_pre_game()
    local gameModel = GameRules:GetGameModeEntity()
    --更新召唤冷却时间
    gameModel:SetContextThink("update_boss_cool_down",function()
        if GameRules:IsGamePaused() then 
            return 1
        end
        -- update_boss_cool_down()
        update_shop_item_cooldown()
        return 1
    end,0)
    -- -- 更新玩家连接信息
    -- gameModel:SetContextThink("wait_player_connect",function()
    --     return wait_player_connect()
    -- end,0)
end

function update_shop_item_cooldown()
    for k,v in pairs(global_var_func.shop_item_cooldown) do
        for item,cd in pairs(v) do
            if cd > 0 then
                cd = cd -1
            else
               cd = nil
            end
            global_var_func.shop_item_cooldown[k][item] = cd
        end
    end
end

function update_ui_gold()
	local player_count = global_var_func.all_player_amount
	for i = 0, player_count-1 do
		game_playerinfo:get_player_gold(i)
	end
end


--更新游戏结束时间
function update_game_time_ui()
    if GameRules:IsGamePaused() then 
        return 1
    end
    if GameRules:GetDOTATime(false,false) < 1 then 
        return 1
    end
    if Tutorial:GetTimeFrozen() then 
        return 1
    end
    global_var_func.last_time = global_var_func.last_time - 1
    CustomGameEventManager:Send_ServerToAllClients("update_game_time",{gameTime = global_var_func.last_time})
    if global_var_func.last_time <= 0 then
        return nil
    end
    return 1
end

--玩家链接
function wait_player_connect()
     if PlayerResource:HaveAllPlayersJoined() then
        CustomGameEventManager:Send_ServerToAllClients("update_player_connect_state",{})
     end
     if GameRules:State_Get() == DOTA_GAMERULES_STATE_PRE_GAME then
        return nil
     end
     return 1
end

--刷新宝物随机几率
function update_player_treasure_number()
    if GameRules:IsGamePaused() then 
        return 1
    end
    if GameRules:GetDOTATime(false,false) < 1 then 
        return 1
    end
    if Tutorial:GetTimeFrozen() then 
        return 1
    end
    if global_var_func.last_time == 1200 then
        global_var_func.treasure_drop_max = global_var_func.treasure_drop_max + 1
    end
    if global_var_func.last_time == 600 then
        global_var_func.treasure_drop_max = global_var_func.treasure_drop_max + 1
    end
    if global_var_func.last_time <= 0 then
        return nil
    end
    return 1
end