-- 技能相关脚本

-- 加载随机技能的配置
local ability_config = require("ability/config_random_ability")

if not system_ability then
    system_ability = class({});
end

-- 
function system_ability:Start()
    -- 注册 Thinker https://developer.valvesoftware.com/wiki/Dota_2_Workshop_Tools/Scripting/ThinkerFunctions
    -- GameRules:GetGameModeEntity():SetThink("OnThink", self);
    -- self.wave = 0;
    -- self.next_time = ability_config.spawn_start_time;
    -- print(mobnumber)
end

-- 设置随机技能 (技能品质), 返回获取的技能的名称
function system_ability:setability(quality, type, steam_id)
    local ability_info = ability_config[quality];
    if ability_info then
        -- print("SpawnerNextWave ======= : "..self.wave);
        if type == "passive" then
            -- 如果是混乱技能
            local current_passive = game_playerinfo:get_player_passive(steam_id)
            local current_chaos = game_playerinfo:get_player_chaos(steam_id)
            local randpool = deepcopy(ability_info["passivepool"])
            for i = 1, #randpool do
                if randpool[i] == current_passive then
                    -- body
                    table.remove(randpool, i)
                    break
                end
            end
            for i = 1, #randpool do
                if randpool[i] == current_chaos then
                    -- body
                    table.remove(randpool, i)
                    break
                end
            end
            local rand_int = RandomInt(1, #randpool);
            local name = randpool[rand_int];
            -- local rand_int = RandomInt(1, #ability_info["passivepool"]);
            -- local name = ability_info["passivepool"][rand_int];
            -- local comparecurrent = string.sub(current_passive, 1, -2)
            -- local comparename = string.sub(name, 1, -2)
            -- local rdtype = RandomInt(1, 2);   -- 
            -- if comparecurrent == comparename then
            --     -- 技能相同,则替换另外一个
                
            --     if rdtype==1 then
            --         -- 取后面一个
            --         if rand_int<#ability_info["passivepool"] then
            --             rand_int = rand_int+1
            --             name = ability_info["passivepool"][rand_int]
            --         else
            --             rand_int = 1;
            --             name = ability_info["passivepool"][rand_int]
            --         end
            --     else
            --         -- 取前面一个
            --         if rand_int>1 then
            --             rand_int = rand_int-1
            --             name = ability_info["passivepool"][rand_int]
            --         else
            --             rand_int = #ability_info["passivepool"];
            --             name = ability_info["passivepool"][rand_int]
            --         end
            --     end
            -- end
            return name
        else
            local current_active = game_playerinfo:get_player_active(steam_id)
            local current_chaos = game_playerinfo:get_player_chaos(steam_id)

            local randpool = deepcopy(ability_info["activepool"])
            for i = 1, #randpool do
                if randpool[i] == current_active then
                    -- body
                    table.remove(randpool, i)
                    break
                end
            end
            for i = 1, #randpool do
                if randpool[i] == current_chaos then
                    -- body
                    table.remove(randpool, i)
                    break
                end
            end
            local rand_int = RandomInt(1, #randpool);
            local name = randpool[rand_int];

            -- local rand_int = RandomInt(1, #ability_info["activepool"]);
            -- local name = ability_info["activepool"][rand_int];
            -- -- local comparecurrent = string.sub(current_active, 1, -2)
            -- -- local comparename = string.sub(name, 1, -2)
            -- local rdtype = RandomInt(1, 2);
            -- if current_active == name then
            --     -- 技能相同,则替换另外一个
            --     if rdtype==1 then
            --         -- 取后面一个
            --         if rand_int<#ability_info["activepool"] then
            --             rand_int = rand_int+1
            --             name = ability_info["activepool"][rand_int]
            --         else
            --             rand_int = 1
            --             name = ability_info["activepool"][rand_int]
            --         end
            --     else
            --         -- 取前面一个
            --         if rand_int>1 then
            --             rand_int = rand_int-1
            --             name = ability_info["activepool"][rand_int]
            --         else
            --             rand_int = #ability_info["activepool"]
            --             name = ability_info["activepool"][rand_int]
            --         end
            --     end
            -- end
            return name
        end
    else
        -- print("game over!");
        return nil;
    end
end

