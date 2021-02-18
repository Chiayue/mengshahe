require("herolist")
require("global/global_var_func")
require("treasuresystem/treasuresystem")

if game_playerinfo == nil then
    game_playerinfo = class({})
end

local need_exp = {
50,
125,
225,
350,
500,
675,
875,
1100,
1350,
1625,
1925,
2250,
2600,
2975,
3375,
3800,
4250,
4725,
5225,
5750,
6300,
6875,
7475,
8100,
8750,
9425,
10125,
10850,
11600,
12375,
13175,
14000,
14850,
15725,
16625,
17550,
18500,
19475,
20475,
21500,
22550,
23625,
24725,
25850,
27000,
28175,
29375,
30600,
31850,
33125,
34425,
35750,
37100,
38475,
39875,
41300,
42750,
44225,
45725,
47250,
48800,
50375,
51975,
53600,
55250,
56925,
58625,
60350,
62100,
63875,
65675,
67500,
69350,
71225,
73125,
75050,
77000,
78975,
80975,
83000,
85050,
87125,
89225,
91350,
93500,
95675,
97875,
100100,
102350,
104625,
106925,
109250,
111600,
113975,
116375,
118800,
121250,
123725,
126225,
128750,
}

function game_playerinfo:get_need_exp(level)
    if level == 0 then
        return 0
    end
    return need_exp[level]
end
local steam_id_hero = {

}

function game_playerinfo:set_steam_id_hero(steam_id, hero)
    steam_id_hero[steam_id] = hero
end

function game_playerinfo:get_steam_id_hero(steam_id)
    if steam_id_hero[steam_id] then
        return steam_id_hero[steam_id]
    else
        return nil
    end
end

local player_info = {
     --模拟数据,测试用
    -- [1123123414] = {    -- steam_id
        -- ["hero_exp"] = {        -- 英雄升经验
        --     128,          -- 对应ID的英雄升华次数
        --     83,          -- 对应ID的英雄升华次数
        --     64,          -- 对应ID的英雄升华次数
        -- },
        -- ["hero_sublime"] = {        -- 英雄升华次数
        --     0,          -- 对应ID的英雄升华次数
        --     0,          -- 对应ID的英雄升华次数
        --     0,          -- 对应ID的英雄升华次数
        -- },
        -- ["hero_level"] = {        -- 英雄等级表
        --     1,          -- 对应ID的英雄的等级
        --     0,          -- 对应ID的英雄的等级
        --     1,          -- 对应ID的英雄的等级
        -- },
        -- ["mapExp"] = 0,
        -- ["mapLevel"] = 0,
        -- ["passLevel"] = 0,
        -- ["isSave"] = 0,
        -- ["universalExp"] = 0,   -- 当前通用英雄经验
        -- ["allUniversalExp"] = 0,   -- 总共获取的通用英雄经验
        -- ["useHeroExp"] = 0,   -- 用于提升英雄等级的经验值useHeroExp
        -- ["relicsExp"] = 0,   -- 用于提升神之遗物等级的经验值
        -- ["chipNumber"] = 0,   -- 宝物分解后的碎片数量

        -- ["compensationLevel"] = 0,   -- 服务器补偿等级

        -- ["itemCallMaterialsLefthand"] = 0,   -- 法老王左手
        -- ["itemCallMaterialsRighthand"] = 0,   -- 法老王右手
        -- ["itemCallMaterialsEyes"] = 0,   -- 法老王之眼
        -- ["itemCallMaterialsSoul"] = 0,   -- 法老王魂魄
        -- ["itemCallMaterialsHeart"] = 0,   -- 法老王心脏

        -- ["itemAdvancedMaterialsZhui"] = 0,   -- 千年锥
        -- ["itemAdvancedMaterialsEyes"] = 0,   -- 千年之眼
        -- ["itemAdvancedMaterialsTianping"] = 0,   -- 千年天平
        -- ["itemAdvancedMaterialsKey"] = 0,   -- 千年钥匙
        -- ["itemAdvancedMaterialsChochma"] = 0,   -- 千年智慧轮
        -- ["itemAdvancedMaterialsCane"] = 0,   -- 千年锡杖
        -- ["itemAdvancedMaterialsJewelry"] = 0,   -- 千年首饰
        
    -- },
}


---------------------------------------------玩家图腾信息---------------------------------------------
local player_totem_data = {
    -- [461183939] = {
        -- ["totemCfLevel"] = 0,
        -- ["totemCfNumber"] = 0,
        -- ["totemDzLevel"] = 0,
        -- ["totemDzNumber"] = 0,
        -- ["totemDjLevel"] = 0,
        -- ["totemDjNumber"] = 0,
        -- ["totemSjLevel"] = 0,
        -- ["totemSjNumber"] = 0,
        -- ["swLevel"] = 0,
        -- ["swNumber"] = 0,
        -- ["yxLevel"] = 0,
        -- ["yxNumber"] = 0,
        -- ["bwLevel"] = 0,
        -- ["bwNumber"] = 0,
        -- ["jhLevel"] = 0,
        -- ["jhNumber"] = 0,
        -- ["zfLevel"] = 0,
        -- ["zfNumber"] = 0,
        -- ["mlLevel"] = 0,
        -- ["mlNumber"] = 0,
        -- ["smLevel"] = 0,
        -- ["smNumber"] = 0,
        -- ["sdLevel"] = 0,
        -- ["sdNumber"] = 0,
        -- ["mhLevel"] = 0,
        -- ["mhNumber"] = 0,
        -- ["ayLevel"] = 0,
        -- ["ayNumber"] = 0,
        -- ["fyLevel"] = 0,
        -- ["fyNumber"] = 0,
    -- },
}

local totem_config = {
    "totemCf",
    "totemDz",
    "totemDj",
    "totemSj",
    "totemZf",
    "totemMl",
    "totemSm",
    "totemSd",
    "totemMh",
    "totemAy",
    "totemFy",
    "totemJh",
}

-- 随机一个图腾碎片
function game_playerinfo:RandomTotem()
    local rdIndex = RandomInt(1, #totem_config)
    return totem_config[rdIndex]
end

--获取碎片信息
function game_playerinfo:get_totem_data(steam_id)
    return player_totem_data[steam_id]
end

-- 修改碎片数量
function game_playerinfo:update_totem_data(steam_id, totemName, number)
    if not player_totem_data[steam_id] then
        player_totem_data[steam_id] = {}
        player_totem_data[steam_id]["totem"] = {}
    end
    local indename = totemName.."Number"
    if not player_totem_data[steam_id]["totem"][indename] then
        player_totem_data[steam_id]["totem"][indename] = 0
    end
    player_totem_data[steam_id]["totem"][indename] = player_totem_data[steam_id]["totem"][indename] + number

    -- print(indename)
    -- DeepPrintTable(player_totem_data[steam_id])
end

-- 获得碎片数量
function game_playerinfo:get_totem_number(steam_id, totemName)
    if not player_totem_data[steam_id] then
        player_totem_data[steam_id] = {}
        player_totem_data[steam_id]["totem"] = {}
    end
    local indename = totemName.."Number"
    if not player_totem_data[steam_id]["totem"][indename] then
        player_totem_data[steam_id]["totem"][indename] = 0
    end
    return player_totem_data[steam_id]["totem"][indename]

    -- print(indename)
    -- DeepPrintTable(player_totem_data[steam_id])
end

-- 修改图腾等级
function game_playerinfo:update_totem_level(steam_id, totemName)
    if not player_totem_data[steam_id] then
        player_totem_data[steam_id] = {}
        player_totem_data[steam_id]["totem"] = {}
    end
    local indename = totemName.."Level"
    if not player_totem_data[steam_id]["totem"][indename] then
        player_totem_data[steam_id]["totem"][indename] = 0
    end
    player_totem_data[steam_id]["totem"][indename] = player_totem_data[steam_id]["totem"][indename] + 1

    -- print(indename)
    -- DeepPrintTable(player_totem_data[steam_id])
end

-- 获得图腾等级
function game_playerinfo:get_totem_level(steam_id, totemName)
    if not player_totem_data[steam_id] then
        player_totem_data[steam_id] = {}
        player_totem_data[steam_id]["totem"] = {}
    end
    local indename = totemName.."Level"
    if not player_totem_data[steam_id]["totem"][indename] then
        player_totem_data[steam_id]["totem"][indename] = 0
    end
    return player_totem_data[steam_id]["totem"][indename]
    -- print(indename)
    -- DeepPrintTable(player_totem_data[steam_id])
end

-----------------------------------------------------------------------------------------------------------------------------------
function game_playerinfo:OnPlayerData(evt)
    local playerID = evt.PlayerID
    game_playerinfo:sendplayerData2client(playerID)
end

function game_playerinfo:sendplayerData2client(playerID)
    local send_table = {}
    local steam_id = PlayerResource:GetSteamAccountID(playerID)
    send_table["mapExp"] = player_info[steam_id]["mapExp"]-- 地图经验
    send_table["mapLevel"] = player_info[steam_id]["mapLevel"]-- 地图等级
    send_table["universalExp"] = (player_info[steam_id]["universalExp"] or 0)-- 通用经验
    send_table["relicsExp"] = (player_info[steam_id]["relicsExp"] or 0)-- 遗物经验
    send_table["chipNumber"] = (player_info[steam_id]["chipNumber"] or 0)-- 宝物碎片
    send_table["game_time"] = player_info[steam_id]["mapExp"]*60-- 游戏时长
    send_table["passLevel"] = player_info[steam_id]["passLevel"]-- 通关难度
    local mapLevel = player_info[steam_id]["mapLevel"]
    local crt_map_exp = game_playerinfo:get_need_exp(mapLevel)
    local next_map_exp = game_playerinfo:get_need_exp(mapLevel+1)
    send_table["up_map_exp"] = next_map_exp - crt_map_exp   -- 升下1级所需经验
    send_table["crt_map_exp"] =  send_table["mapExp"] - crt_map_exp  -- 当前等级多出来的经验

    send_table["killYanmo"] =  (player_info[steam_id]["killYanmo"] or 0)-- 击杀炎魔计数
    send_table["killBoss"] =  (player_info[steam_id]["killBoss"] or 0)-- 击杀BOSS计数
    send_table["onceBoxNumber"] =  (player_info[steam_id]["onceBoxNumber"] or 0)-- 单抽宝箱计数
    send_table["getMonthCard"] =  (player_info[steam_id]["getMonthCard"] or 0)-- 当日月卡领奖资格

    send_table["mapRewardsCount"] =  (player_info[steam_id]["mapRewardsCount"] or 0)-- 地图奖励领取计数
    send_table["levelRewardsLists"] =  (player_info[steam_id]["levelRewardsLists"] or {0,0,0,0,0,0,0,0,0,0,10})-- 难度首通奖励领取计数

    CustomGameEventManager:Send_ServerToPlayer(PlayerResource:GetPlayer(playerID),"response_player_data",send_table)
end
-- 数据项查阅匹配,并且补全
function game_playerinfo:check_player_datas(nPlayerID)
    local steam_id = PlayerResource:GetSteamAccountID(nPlayerID)
    if not player_info[steam_id]["hero_sublime"] then
        player_info[steam_id]["hero_sublime"] = {}
        self:check_hero_level(player_info[steam_id]["hero_sublime"])
    end
    if not player_info[steam_id]["hero_level"] then
        player_info[steam_id]["hero_level"] = {}
        self:check_hero_level(player_info[steam_id]["hero_level"])
    end
    if not player_info[steam_id]["mapExp"] then
        player_info[steam_id]["mapExp"] = 0
    end
    if not player_info[steam_id]["mapLevel"] then
        player_info[steam_id]["mapLevel"] = 0
    end
    if not player_info[steam_id]["passLevel"] then
        player_info[steam_id]["passLevel"] = 0
    end
    if not player_info[steam_id]["isSave"] then
        player_info[steam_id]["isSave"] = 0
    end
    if not player_info[steam_id]["compensationLevel"] then
        player_info[steam_id]["compensationLevel"] = 0
    end
    if not player_info[steam_id]["universalExp"] then
        player_info[steam_id]["universalExp"] = 0
    end
    if not player_info[steam_id]["allUniversalExp"] then
        player_info[steam_id]["allUniversalExp"] = 0
    end
    if not player_info[steam_id]["useHeroExp"] then
        player_info[steam_id]["useHeroExp"] = 0
    end
    if not player_info[steam_id]["relicsExp"] then
        player_info[steam_id]["relicsExp"] = 0
    end
    if not player_info[steam_id]["chipNumber"] then
        player_info[steam_id]["chipNumber"] = 0
    end
    if not player_info[steam_id]["itemCallMaterialsLefthand"] then
        player_info[steam_id]["itemCallMaterialsLefthand"] = 0
    end
    if not player_info[steam_id]["itemCallMaterialsRighthand"] then
        player_info[steam_id]["itemCallMaterialsRighthand"] = 0
    end
    if not player_info[steam_id]["itemCallMaterialsEyes"] then
        player_info[steam_id]["itemCallMaterialsEyes"] = 0
    end
    if not player_info[steam_id]["itemCallMaterialsSoul"] then
        player_info[steam_id]["itemCallMaterialsSoul"] = 0
    end
    if not player_info[steam_id]["itemCallMaterialsHeart"] then
        player_info[steam_id]["itemCallMaterialsHeart"] = 0
    end
    if not player_info[steam_id]["itemAdvancedMaterialsZhui"] then
        player_info[steam_id]["itemAdvancedMaterialsZhui"] = 0
    end
    if not player_info[steam_id]["itemAdvancedMaterialsEyes"] then
        player_info[steam_id]["itemAdvancedMaterialsEyes"] = 0
    end
    if not player_info[steam_id]["itemAdvancedMaterialsTianping"] then
        player_info[steam_id]["itemAdvancedMaterialsTianping"] = 0
    end
    if not player_info[steam_id]["itemAdvancedMaterialsKey"] then
        player_info[steam_id]["itemAdvancedMaterialsKey"] = 0
    end
    if not player_info[steam_id]["itemAdvancedMaterialsChochma"] then
        player_info[steam_id]["itemAdvancedMaterialsChochma"] = 0
    end
    if not player_info[steam_id]["itemAdvancedMaterialsCane"] then
        player_info[steam_id]["itemAdvancedMaterialsCane"] = 0
    end
    if not player_info[steam_id]["itemAdvancedMaterialsJewelry"] then
        player_info[steam_id]["itemAdvancedMaterialsJewelry"] = 0
    end
    if not treasuresystem:get_player_treasures(nPlayerID) then
        treasuresystem:player_inittreasures(nPlayerID)
    end
end

--玩家碎片信息
local player_equipment_data = {
    -- [461183939] = {
        -- "heroEquipmentHead",
        -- "heroEquipmentArmor",
        -- "heroEquipmentLegguard",
        -- "heroEquipmentLeg",
        -- "heroEquipmentShoes",
        -- "heroEquipmentMainweapon",
        -- "heroEquipmentSpeciaiweapon",
        -- "heroEquipmentHeadExp",
        -- "heroEquipmentArmorExp",
        -- "heroEquipmentLegguardExp",
        -- "heroEquipmentLegExp",
        -- "heroEquipmentShoesExp",
        -- "heroEquipmentMainweaponExp",
        -- "heroEquipmentSpeciaiweaponExp",
    -- },

}

--玩家宝物轮数
local player_treasure_round = {
    -- [0] = 1,
    -- [1] = 0,
}

function game_playerinfo:get_player_treasure_round(nPlayerID)
    if not player_treasure_round[nPlayerID] then
        player_treasure_round[nPlayerID] = 0
    end
    return player_treasure_round[nPlayerID]
end

function game_playerinfo:update_player_treasure_round(nPlayerID)
    if not player_treasure_round[nPlayerID] then
        player_treasure_round[nPlayerID] = 0
    end
    player_treasure_round[nPlayerID] = player_treasure_round[nPlayerID] + 1
end

--玩家宝物数量
local player_treasure_number = {
    -- [0] = {"modifier_treasure_nuclear_thieves",},
    -- [1] = {"modifier_treasure_nuclear_thieves",},
}

function game_playerinfo:get_treasure_number(PlayerID)
    return #player_treasure_number[PlayerID]
end

function game_playerinfo:get_treasures_by_id(PlayerID)
    return player_treasure_number[PlayerID]
end

function game_playerinfo:inster_treasure_name(PlayerID, name)
    if not player_treasure_number[PlayerID] then
        player_treasure_number[PlayerID] = {}
    end
    table.insert(player_treasure_number[PlayerID], name)
    return player_treasure_number[PlayerID]
end

function game_playerinfo:remove_treasure_name(PlayerID, name)
    if not player_treasure_number[PlayerID] then
        return
    end
    for i = 1, #player_treasure_number[PlayerID] do
        if player_treasure_number[PlayerID][i] == name then
            table.remove(player_treasure_number[PlayerID], i)
            return
        end
    end
end

function game_playerinfo:save_archive()
    local nPlayerCount = global_var_func.all_player_amount
    for nPlayerID = 0,nPlayerCount - 1 do
        game_playerinfo:save_archiveby_playerid(nPlayerID)
    end
    -- Archive:SaveProfile()
end

function game_playerinfo:save_storecoinby_playerid(playerID, prize_list)
    for i = 1, #prize_list do
        if prize_list[i][1] == "score" then
            self:update_score(playerID, prize_list[i][2])
        end
    end
end

function game_playerinfo:save_herosby_playerid(playerID)
    local ArchiveTable = {
        "heroes",
    }
    self:SaveArchiveTable(playerID, ArchiveTable)

    Archive:SaveProfileByID(playerID)
end

function game_playerinfo:save_archiveby_playerid(playerID)
    local ArchiveTable = {
        "heroes",
        "treasures",
        "treasureConfigs",
        "mapExp",
        "mapLevel",
        "passLevel",
        "universalExp",
        "allUniversalExp",
        "useHeroExp",
        "relicsExp",
        "chipNumber",
        "killYanmo",
        "killBoss",
        "onceBoxNumber",
        -- "getMonthCard",
        "mapRewardsCount",
        "levelRewardsLists",
        "compensationLevel",
        "itemCallMaterialsLefthand",
        "itemCallMaterialsRighthand",
        "itemCallMaterialsEyes",
        "itemCallMaterialsSoul",
        "itemCallMaterialsHeart",
        "itemAdvancedMaterialsZhui",
        "itemAdvancedMaterialsEyes",
        "itemAdvancedMaterialsTianping",
        "itemAdvancedMaterialsKey",
        "itemAdvancedMaterialsChochma",
        "itemAdvancedMaterialsCane",
        "itemAdvancedMaterialsJewelry",
        "player_equipment_data",
    }
    self:SaveArchiveTable(playerID, ArchiveTable)

    Archive:SaveProfileByID(playerID)
end

function game_playerinfo:save_archive_for_create(playerID)
    local ArchiveTable = {
        "heroes",
        "treasures",
        "treasureConfigs",
        "mapExp",
        "mapLevel",
        "passLevel",
        "universalExp",
        "allUniversalExp",
        "useHeroExp",
        "relicsExp",
        "chipNumber",
        "killYanmo",
        "killBoss",
        "onceBoxNumber",
        "getMonthCard",
        "mapRewardsCount",
        "levelRewardsLists",
        "compensationLevel",
        "itemCallMaterialsLefthand",
        "itemCallMaterialsRighthand",
        "itemCallMaterialsEyes",
        "itemCallMaterialsSoul",
        "itemCallMaterialsHeart",
        "itemAdvancedMaterialsZhui",
        "itemAdvancedMaterialsEyes",
        "itemAdvancedMaterialsTianping",
        "itemAdvancedMaterialsKey",
        "itemAdvancedMaterialsChochma",
        "itemAdvancedMaterialsCane",
        "itemAdvancedMaterialsJewelry",
        "player_equipment_data",
    }
    self:SaveArchiveTable(playerID, ArchiveTable)

    Archive:SaveProfileByID(playerID)
end

function game_playerinfo:save_compensationLevel(playerID)
    local ArchiveTable = {
        "compensationLevel",
    }
    self:SaveArchiveTable(playerID, ArchiveTable)

    Archive:SaveProfileByID(playerID)
end

function game_playerinfo:save_resolveby_playerid(playerID)
    local ArchiveTable = {
        "treasures",
        "relicsExp",
        "chipNumber",
    }
    self:SaveArchiveTable(playerID, ArchiveTable)

    Archive:SaveProfileByID(playerID)
end

function game_playerinfo:save_rewardsby_playerid(playerID)
    local ArchiveTable = {
        "treasures",
        "relicsExp",
        "chipNumber",
        "levelRewardsLists",
    }
    self:SaveArchiveTable(playerID, ArchiveTable)

    Archive:SaveProfileByID(playerID)
end

-- 根据存档列表来进行对应数据存档
function game_playerinfo:SaveArchiveTable(playerID, ArchiveTable)
    local nSteamID = PlayerResource:GetSteamAccountID(playerID)
    if player_info[nSteamID].isSave==0 then
        return
    end
    Archive:ClearPlayerProfile(playerID)

    for key, value in pairs(ArchiveTable) do
        if value == "treasures" then
            -- print("save treasures")
            -- local ChangedTreasures = treasuresystem:getChangedTreasures(playerID)
            Archive:EditPlayerProfile(playerID,value,treasuresystem:send_server_treasures(playerID))
            -- treasuresystem:clearChangedTreasures(playerID)
        elseif value == "treasureConfigs" then
            -- print("save treasureConfigs")
            Archive:EditPlayerProfile(playerID,value,treasuresystem:send_server_treasureConfigs(playerID))
        elseif value == "levelRewardsLists" then
            Archive:EditPlayerProfile(playerID,value,game_playerinfo:sendLevelRewardsSignToSave(nSteamID))   -- 领取首通奖励
        elseif value == "player_equipment_data" then
            if player_equipment_data[nSteamID] then
                for key, value in pairs(player_equipment_data[nSteamID]) do
                    Archive:EditPlayerProfile(playerID,key,value)
                end
            end
        elseif value == "player_totem_data" then
            -- print(" >>>>>>>>>>>>>>>>>> nSteamID: ")
            -- DeepPrintTable(player_totem_data)
            if player_totem_data[nSteamID]["totem"] then
                for key, value in pairs(player_totem_data[nSteamID]["totem"]) do
                    Archive:EditPlayerProfile(playerID,key,value)
                end
            end
        else
            if not player_info[nSteamID][value] then
                player_info[nSteamID][value] = 0
            end
            Archive:EditPlayerProfile(playerID,value,player_info[nSteamID][value])
        end
    end
    
    -- Archive:SaveProfileByID(playerID)
end


function game_playerinfo:save_treasures(playerID)
    local ArchiveTable = {
        "treasures",
        "treasureConfigs",
    }
    self:SaveArchiveTable(playerID, ArchiveTable)

    Archive:SaveProfileByID(playerID)
end

function game_playerinfo:save_totem(playerID)
    local ArchiveTable = {
        "player_totem_data",
    }
    self:SaveArchiveTable(playerID, ArchiveTable)

    Archive:SavePlayerTotem(playerID)
end

-- 宝物读档
function game_playerinfo:load_treasures(playerID, treasures_archive)
    treasuresystem:set_player_treasures(playerID, treasures_archive)
end

-- 宝物配置读档
function game_playerinfo:load_treasureConfigs(playerID, treasureConfigs_archive)
    treasuresystem:set_player_treasureConfigs(playerID, treasureConfigs_archive)
end

-- 通关奖励读档
function game_playerinfo:load_levelRewardsList(steam_id, levelRewardsLists)
    player_info[steam_id]["levelRewardsLists"] = {}
    for i = 1, #levelRewardsLists do
        table.insert(player_info[steam_id]["levelRewardsLists"], levelRewardsLists[i]["isGet"])
    end
    if #levelRewardsLists < 10 then
        table.remove(player_info[steam_id]["levelRewardsLists"], #player_info[steam_id]["levelRewardsLists"])
        for i = 1, (10-#player_info[steam_id]["levelRewardsLists"]) do
            table.insert(player_info[steam_id]["levelRewardsLists"], 0)
        end
        table.insert(player_info[steam_id]["levelRewardsLists"], 10)
    end
end

function game_playerinfo:get_all_hero_info(steam_id)
    -- {
    --     {
    --         heroName,
    --         lv,upExp
    --     },
    --     {
    --         heroName,
    --         lv,upExp
    --     },
    -- }
    local hero_info = {}
    for i = 1, #CustomHeroList do
        local info = {}
        table.insert(info , CustomHeroList[i])
        table.insert(info , player_info[steam_id].heroes[i].heroLevel)
        table.insert(info , game_playerinfo:get_need_exp(player_info[steam_id].heroes[i].heroLevel + 1))

        table.insert(hero_info, info)
    end
    return hero_info
end

function game_playerinfo:gethero_info_by_name(steam_id, heroname)
    -- {
    --     {
    --         heroName:
    --         {lv,upExp}
    --     },
    --     {
    --         heroName:
    --         {lv,upExp}
    --     },
    -- }
    for i = 1, #CustomHeroList do
        if heroname == CustomHeroList[i] then
            local info = {}
            table.insert(info , CustomHeroList[i])
            table.insert(info, player_info[steam_id].heroes[i].heroLevel)
            table.insert(info, game_playerinfo:get_need_exp(player_info[steam_id].heroes[i].heroLevel + 1))
            
            return info
        end
    end
end

function game_playerinfo:update_save_item_number(steam_id, item_name, number)
    if not player_info[steam_id][item_name] then
        player_info[steam_id][item_name] = 0
    end
    player_info[steam_id][item_name] = player_info[steam_id][item_name] + number
end


-- 商城道具,包括货币存档
local player_store = {
    -- [1123123414] = {
    --     ["score"] = 0,
    --     ["bull_coin"] = 0,
    --     ["vip_1"] = 0,
    --     ["vip_2"] = 0,
    --     ["vip_3"] = 0,
    --     ["vip_4"] = 0,
    -- }
}

local player_ability = {
    -- [steam_id] = {
    --     ["active"] = "",    -- 主动技能位
    --     ["passive"] = "",   -- 被动技能位
    --     ["chaos"] = "",      -- 混乱技能位
    --     ["innateskill"] = "",   -- 神职天赋槽位
    -- }
}

function game_playerinfo:get_hero_exp_by_name(steam_id, hero_name)
    -- print(">>>>>>>>>>>>>> steam_id: "..steam_id.." hero_name: "..hero_name)
    -- DeepPrintTable(player_info)
    local hero_index = 0
    for key, value in ipairs(CustomHeroList) do
        if hero_name == value then
            hero_index = key
        end
    end
    return player_info[steam_id].hero_exp[hero_index] or 0
end

function game_playerinfo:get_universal_exp(steam_id)
    return player_info[steam_id]["universalExp"] or 0
end

function game_playerinfo:get_all_universal_exp(steam_id)
    return player_info[steam_id]["allUniversalExp"] or 0
end

function game_playerinfo:get_useHeroExp(steam_id)
    return player_info[steam_id]["useHeroExp"] or 0
end

function game_playerinfo:get_relicsExp(steam_id)
    return player_info[steam_id]["relicsExp"] or 0
end

function game_playerinfo:get_chipNumber(steam_id)
    return player_info[steam_id]["chipNumber"] or 0
end

function game_playerinfo:get_compensation_level(steam_id)
    return player_info[steam_id]["compensationLevel"] or 0
end

function game_playerinfo:get_hero_level_by_name(steam_id, hero_name)
    -- print(">>>>>>>>>>>>>> steam_id: "..steam_id.." hero_name: "..hero_name)
    -- DeepPrintTable(player_info)
    local hero_index = 0
    for key, value in ipairs(CustomHeroList) do
        if hero_name == value then
            hero_index = key
        end
    end
    if player_info[steam_id].heroes[hero_index] then
        return player_info[steam_id].heroes[hero_index].heroLevel or 0
    else
        return 0
    end
end

function game_playerinfo:get_hero_index_by_name(steam_id, hero_name)
    -- print(">>>>>>>>>>>>>> steam_id: "..steam_id.." hero_name: "..hero_name)
    -- DeepPrintTable(player_info)
    local hero_index = 0
    for key, value in ipairs(CustomHeroList) do
        if hero_name == value then
            hero_index = key
        end
    end
    return hero_index
end

function game_playerinfo:add_hero_winnumber_by_name(steam_id, hero_name, value)
    -- print(">>>>>>>>>>>>>> steam_id: "..steam_id.." hero_name: "..hero_name)
    -- DeepPrintTable(player_info)
    if value < 0 then
        value = 0
    end
    local hero_index = 0
    for key, value in ipairs(CustomHeroList) do
        if hero_name == value then
            hero_index = key
        end
    end
    if player_info[steam_id].heroes[hero_index] then
        player_info[steam_id].heroes[hero_index]["heroWin"] = player_info[steam_id].heroes[hero_index]["heroWin"] + value
    end
end

function game_playerinfo:add_hero_select_by_name(steam_id, hero_name, value)
    -- print(">>>>>>>>>>>>>> steam_id: "..steam_id.." hero_name: "..hero_name)
    -- DeepPrintTable(player_info)
    if value < 0 then
        value = 0
    end
    local hero_index = 0
    for key, value in ipairs(CustomHeroList) do
        if hero_name == value then
            hero_index = key
        end
    end
    if player_info[steam_id].heroes[hero_index] then
        player_info[steam_id].heroes[hero_index]["heroSelect"] = player_info[steam_id].heroes[hero_index]["heroSelect"] + value
    end
end

function game_playerinfo:get_map_exp_by_id(steam_id)
    -- print(">>>>>>>>>>>>>> steam_id: "..steam_id.." hero_name: "..hero_name)
    -- DeepPrintTable(player_info)
    return player_info[steam_id].mapExp or 0
end

function game_playerinfo:get_map_level_by_id(steam_id)
    -- print(">>>>>>>>>>>>>> steam_id: "..steam_id.." hero_name: "..hero_name)
    -- DeepPrintTable(player_info)
    return player_info[steam_id].mapLevel or 0
end

function game_playerinfo:get_player_active(steam_id)
    if not player_ability[steam_id] then
        player_ability[steam_id] = {}
        player_ability[steam_id].active = ""
        player_ability[steam_id].passive = ""
        player_ability[steam_id].chaos = ""
        player_ability[steam_id].innateskill = ""
    end
    return player_ability[steam_id].active
end

-- 绑定主动技能
function game_playerinfo:set_player_active(steam_id, active)
    if not player_ability[steam_id] then
        player_ability[steam_id] = {}
        player_ability[steam_id].active = ""
        player_ability[steam_id].passive = ""
        player_ability[steam_id].chaos = ""
        player_ability[steam_id].innateskill = ""
    end
    player_ability[steam_id].active = active
end

function game_playerinfo:get_player_passive(steam_id)
    if not player_ability[steam_id] then
        player_ability[steam_id] = {}
        player_ability[steam_id].active = ""
        player_ability[steam_id].passive = ""
        player_ability[steam_id].chaos = ""
        player_ability[steam_id].innateskill = ""
    end
    return player_ability[steam_id].passive
end

-- 绑定被动技能
function game_playerinfo:set_player_passive(steam_id, passive)
    if not player_ability[steam_id] then
        player_ability[steam_id] = {}
        player_ability[steam_id].active = ""
        player_ability[steam_id].passive = ""
        player_ability[steam_id].chaos = ""
        player_ability[steam_id].innateskill = ""
    end
    player_ability[steam_id].passive = passive
end

function game_playerinfo:get_player_chaos(steam_id)
    if not player_ability[steam_id] then
        player_ability[steam_id] = {}
        player_ability[steam_id].active = ""
        player_ability[steam_id].passive = ""
        player_ability[steam_id].chaos = ""
        player_ability[steam_id].innateskill = ""
    end
    return player_ability[steam_id].chaos
end

-- 绑定混乱技能
function game_playerinfo:set_player_chaos(steam_id, chaos)
    if not player_ability[steam_id] then
        player_ability[steam_id] = {}
        player_ability[steam_id].active = ""
        player_ability[steam_id].passive = ""
        player_ability[steam_id].chaos = ""
        player_ability[steam_id].innateskill = ""
    end
    player_ability[steam_id].chaos = chaos
end

function game_playerinfo:get_player_innateskill(steam_id)
    if not player_ability[steam_id] then
        player_ability[steam_id] = {}
        player_ability[steam_id].active = ""
        player_ability[steam_id].passive = ""
        player_ability[steam_id].chaos = ""
        player_ability[steam_id].innateskill = ""
    end
    return player_ability[steam_id].innateskill
end

-- 绑定第二天赋技
function game_playerinfo:set_player_innateskill(steam_id, innateskill)
    if not player_ability[steam_id] then
        player_ability[steam_id] = {}
        player_ability[steam_id].active = ""
        player_ability[steam_id].passive = ""
        player_ability[steam_id].chaos = ""
        player_ability[steam_id].innateskill = ""
    end
    player_ability[steam_id].innateskill = innateskill
end

-- 玩家动态基础属性,可以通过各种道具附加的
local dynamic_properties = {
    -- 回蓝
    -- [steam_id] = {
    --     ["mana_regen"] = 0,          -- 额外回蓝
    --     ["respawn_time"] = 0,        -- 复活时间减少百分比
    --     ["invincible_time"] = 0,     -- 无敌时间增加百分比
    --     ["exp_scale"] = 0,           -- 额外增加经验比例
    --     ["re_pick"] = 0,             -- 额外重选英雄的次数
    --     ["max_monster"] = 0,             -- 额外怪物上限
    --     ["gold_scale"] = 0,              -- 刷钱效率额外百分比
    --     ["extra_exp"] = 0,               -- 杀怪额外经验值
    --     ["drop_scale"] = 0,              -- 额外掉落率
    --     ["drop_scale_unit"] = 0,         -- 小怪额外掉落率
    --     ["drop_scale_boss"] = 0,         -- boss额外掉落率
    --     ["score_scale"] = 0,             -- 通关积分倍数
    --     ["attack_heal"] = 0,             -- 攻击吸血
    --     ["attack_critical"] = 0,         -- 攻击暴击几率
    --     ["add_armor"] = 0,               -- 护甲
    --     ["add_resistance"] = 0,          -- 魔抗
    --     ["move_speed"] = 0,              -- 移速
    --     ["extra_hero_exp"] = 0,          -- 额外英雄熟练度倍率
    --     ["extra_attack_scale"] = 0,             -- 额外增伤比例
    --     ["extra_attack_speed"] = 0,             -- 攻速
    -- }
}

function game_playerinfo:init_dynamic_properties(steam_id)
    dynamic_properties[steam_id] = {
        ["attack_critical_damage"] = 2.5,  -- 初始暴击伤害
        ["magic_critical_damage"] = 2.5,  -- 初始暴击伤害
        ["max_mana"] = 0,                -- 魔法值上限
        ["extra_health_percent"] = 0,    -- 额外百分比血量上限
        ["respawn_time"] = 0,            -- 复活时间减少百分比
        ["respawn_second"] = 0,          -- 复活时间减少秒数
        ["invincible_time"] = 0,         -- 无敌时间增加百分比
        ["exp_scale"] = 0,               -- 额外增加经验比例
        ["re_pick"] = 0,                 -- 额外重选英雄的次数
        ["max_monster"] = 0,             -- 额外怪物上限
        ["gold_scale"] = 0,              -- 金钱获取额外百分比
        ["extra_exp"] = 0,               -- 杀怪额外经验值
        ["kill_gold_scale"] = 0,              -- 杀怪金钱获取额外百分比
        ["drop_scale"] = 0,              -- 额外掉落率
        ["drop_scale_unit"] = 0,         -- 小怪额外掉落率
        ["drop_scale_boss"] = 0,         -- boss额外掉落率
        ["score_scale"] = 0,             -- 通关积分倍数
        ["attack_heal"] = 0,             -- 攻击吸血
        ["attack_heal_percent"] = 0,     -- 攻击百分比吸血
        ["attack_critical"] = 5,         -- 攻击暴击几率 %
        ["magic_critical"] = 5,         -- 魔法暴击几率 %
        ["add_baseattack"] = 0,          -- 额外基础攻击力   100
        ["add_armor"] = 0,               -- 护甲
        ["add_resistance"] = 0,          -- 魔抗
        ["move_speed"] = 0,              -- 移速
        ["extra_hero_exp"] = 0,          -- 额外英雄熟练度倍率
        ["extra_attack_scale"] = 0,      -- 额外增伤比例 %
        ["reduce_attack_scale"] = 0,     -- 额外减伤比例
        ["magic_attack_scale"] = 0,      -- 额外技能增伤比例  10
        ["physics_attack_scale"] = 0,      -- 额外物理攻击比例  10
        ["reduce_attack_point"] = 0,     -- 额外伤害格挡
        ["extra_attack_speed"] = 0,      -- 攻速
        ["base_attack_speed_percent"] = 0,      -- 基础攻速百分比
        ["percent_regen_heal"] = 0,      -- 额外百分比回血
        ["heal_regen"] = 0,              -- 额外回血
        ["percent_regen_mana"] = 0,      -- 额外百分比回蓝
        ["mana_regen"] = 0,              -- 额外回蓝
        ["call_shadow"] = 0,             -- 召唤影子
        ["call_rolling_stone"] = 0,      -- 召唤陨石
        ["strength_up_temporary"] = 0,  -- 力量暂时提升
        ["call_human_army"] = 0,         -- 召唤人族部队
        ["kill_immediately"] = 0,        -- 秒杀目标（boss百分比伤害）
        ["add_strength"] = 0,            -- 额外力量
        ["add_intellect"] = 0,           -- 额外智力
        ["add_agility"] = 0,             -- 额外敏捷
        ["attack_and_move"] = 0,         -- 攻速+移速(弃用)
        ["temp_multiple_spell"] = 0,     -- 临时多重施法(触发后归0)
        ["call_unit_durationtime_percent"] = 0,          -- 召唤物持续时间百分比
        ["call_unit_damage_percent"] = 0,       -- 召唤物伤害增幅
        ["abnormal_damage_scale"] = 0,   -- 异常状态额外增伤
        ["maoyi_increase"] = 0,         -- 贸易增幅
        ["touzi_increase"] = 0,         -- 投资增幅
        ["lueduo_increase"] = 0,         -- 掠夺增幅
        ["shalu_increase"] = 0,         -- 杀戮增幅
        ["extra_treasure_select"] = 0,  -- 额外宝物选项
        ["extra_universal_exp"] = 0,    -- 额外通用经验倍率
        ["persent_treasure"] = 0,                 -- 第一波刷怪赠送宝物书标记
        ["extra_begin_golds"] = 0,                 -- 额外的开局金钱
        ["extra_begin_wood"] = 0,                 -- 额外的开局金砖
        ["extra_addgold_second"] = 0,                 -- 额外的每秒加钱
        ["extra_success_rate"] = 0,         -- 额外装备升级成功率
        ["ability_cd_percent"] = 0,         -- 技能冷却降低
        ["extra_attack_physics"] = 0,         -- 附加物理伤害
        ["extra_attack_pure"] = 0,            -- 附加真实伤害
        ["add_strength_scale"] = 0,            -- 额外基础力量比例
        ["add_intellect_scale"] = 0,           -- 额外基础智力比例
        ["add_agility_scale"] = 0,             -- 额外基础敏捷比例
        ["extra_mapexp"] = 0,             -- 地图等级经验额外奖励点数
        ["physics_piercing"] = 0,      -- 物理减甲
        ["maxlevel_totem"] = 0,         -- 图腾满级套装属性添加
    }
end

function game_playerinfo:get_dynamic_properties(steam_id)
    if not dynamic_properties[steam_id] then
        dynamic_properties[steam_id] = {}
    end
    return dynamic_properties[steam_id]
end

function game_playerinfo:get_dynamic_properties_by_key(steam_id, key)
    if not dynamic_properties[steam_id] then
        dynamic_properties[steam_id] = {}
    end
    return dynamic_properties[steam_id][key] or 0
end

function game_playerinfo:set_dynamic_properties(steam_id, key, value)
    if not dynamic_properties[steam_id] then 
        dynamic_properties[steam_id]  = {}
    end
    if dynamic_properties[steam_id][key] then 
        if key == "reduce_attack_scale" and (dynamic_properties[steam_id][key] + value > 80) then
            dynamic_properties[steam_id][key] = 80
        elseif key == "respawn_time" then
            if dynamic_properties[steam_id][key] == 0 then
                dynamic_properties[steam_id][key] = value
            else
                dynamic_properties[steam_id][key] = dynamic_properties[steam_id][key] + (dynamic_properties[steam_id][key]*value)
            end
        elseif key == "move_speed" and (dynamic_properties[steam_id][key] + value > 450) then
            dynamic_properties[steam_id][key] = 450
        elseif key == "extra_universal_exp" then
            dynamic_properties[steam_id][key] = value
        else
            dynamic_properties[steam_id][key] = dynamic_properties[steam_id][key] + value
        end
    else
        dynamic_properties[steam_id][key] = value
    end
end

function game_playerinfo:clear_dynamic_properties(steam_id, key)
    if not dynamic_properties[steam_id] then 
        dynamic_properties[steam_id]  = {}
    end
    dynamic_properties[steam_id][key] = 0
end

-- 获取玩家当前VIP的状态
function game_playerinfo:get_player_store(steam_id)
    return player_store[steam_id]
end

-- 根据单项VIP 状态附加属性
function game_playerinfo:update_vip_single_properties(steam_id, hero, key)
    if key == "vip_1" then
        hero:SetBaseStrength(hero:GetBaseStrength() + 10)
        hero:SetBaseAgility(hero:GetBaseAgility() + 10)
        hero:SetBaseIntellect(hero:GetBaseIntellect() + 10)

        self:set_dynamic_properties(steam_id, "extra_hero_exp", 0.05)
    elseif key == "vip_2" then
        self:set_dynamic_properties(steam_id, "mana_regen", 100)-- 额外攻击力
        self:set_dynamic_properties(steam_id, "mana_regen", 1)-- 回蓝
        self:set_dynamic_properties(steam_id, "move_speed", 30)-- 移速
        self:set_dynamic_properties(steam_id, "add_resistance", 10)-- 魔抗
        self:set_dynamic_properties(steam_id, "extra_attack_speed", 5)-- 攻速
        self:set_dynamic_properties(steam_id, "extra_hero_exp", 0.08)-- 额外经验获取
    elseif key == "vip_3" then
        self:set_dynamic_properties(steam_id, "mana_regen", 100)-- 攻击附带3点减甲
        self:set_dynamic_properties(steam_id, "magic_attack_scale", 10)-- 技能增伤
        self:set_dynamic_properties(steam_id, "heal_regen", 200)-- 生命回复
        self:set_dynamic_properties(steam_id, "extra_hero_exp", 0.12)-- 额外经验获取
        -- self:set_dynamic_properties(steam_id, "extra_treasure_select", 1)-- 额外宝物选项
    elseif key == "vip_4" then
        -- local rand_num = RandomInt(1,7)
        -- local item_name = "heroEquipment_"..tostring(rand_num)
        -- hero:AddItemByName(item_name)

        -- self:set_dynamic_properties(steam_id, "respawn_time", 0.5)
        
        self:set_dynamic_properties(steam_id, "invincible_time", 1)

        self:set_dynamic_properties(steam_id, "extra_hero_exp", 1)

        self:set_dynamic_properties(steam_id, "extra_attack_scale", 10)
        
        self:set_dynamic_properties(steam_id, "re_pick", 1)

        -- hero:AddNewModifier(nil, nil, "modifier_vip_show_buff_lua", { duration = 99999.0 })
    end

    common_item_ability:refresh_dynamic_to_tablevalue(hero)
end

-- 根据VIP 状态附加属性
function game_playerinfo:update_vip_properties_by_playerid(player_id, key)
    local player = PlayerResource:GetPlayer( player_id )
    local hero = player:GetAssignedHero()
    local steam_id = PlayerResource:GetSteamAccountID(player_id)
    self:update_vip_single_properties(steam_id, hero, key)
end

-- 根据VIP 状态附加属性
function game_playerinfo:update_vip_properties(steam_id, hero)
    local _info = player_store[steam_id]
    -- print(">>>>>>>>>>>>> steam_id: "..steam_id.."  info: ")
    -- DeepPrintTable(player_info)
    if _info then
        if _info.vip_1 == 1 then
            self:update_vip_single_properties(steam_id, hero, "vip_1")
        end
        if _info.vip_2 == 1 then
            self:update_vip_single_properties(steam_id, hero, "vip_2")
        end
        if _info.vip_3 == 1 then
            
            self:update_vip_single_properties(steam_id, hero, "vip_3")
        end
        if _info.vip_4 == 1 then
            self:update_vip_single_properties(steam_id, hero, "vip_4")
        end
        if _info.Experience_double_card then
            -- 获取双倍通用经验
            
        end
    end
end


-- 根据地图等级附加属性
function game_playerinfo:update_maplv_properties(steam_id, hero)

    if not player_info[steam_id].mapLevel then
        player_info[steam_id].mapLevel = 0
    end
    -- 根据地图等级增加初始金钱
    game_playerinfo:set_player_gold(hero:GetPlayerID(),player_info[steam_id].mapLevel*100)

    -- 根据地图等级增加初始三围
    
    SetBaseStrength(hero, player_info[steam_id].mapLevel)
    SetBaseAgility(hero, player_info[steam_id].mapLevel)
    SetBaseIntellect(hero, player_info[steam_id].mapLevel)
end

function game_playerinfo:set_subliming(steam_id, value)
    -- player_info[steam_id].hero_level[heroindex]
end

-- 根据英雄等级附加属性
function game_playerinfo:update_herolv_properties(steam_id, hero_name, hero)
    local heroindex = global_var_func:gethero_index_by_name(hero_name)
    if not player_info[steam_id].hero_level then
        return
    end
    local hero_level = player_info[steam_id].hero_level[heroindex]
    if hero_level then
        -- 根据英雄等级增加初始三围
        
        SetBaseStrength(hero, hero_level*2)
        SetBaseAgility(hero, hero_level*2)
        SetBaseIntellect(hero, hero_level*2)
        if hero_level == global_var_func:GloFunc_Getgame_enum().MAX_HERO_LEVEL then
            local attack_scale = 20
            -- print(" >>>>>>>>>>>>>>>>>>> attack_scale: "..attack_scale)
            self:set_dynamic_properties(steam_id, "extra_attack_scale", attack_scale)
            -- hero:AddNewModifier(hero, nil, "modifier_extra_attack_scale_lua", {duration = 9999999, hero_level = hero_level})
        elseif hero_level == (global_var_func:GloFunc_Getgame_enum().MAX_HERO_LEVEL*0.5) then
            -- game_playerinfo:set_subliming(steam_id, 1)
        end
    end
end

--随机属性表 金色
local random_properties_1 = {
    {"add_strength",1000},--力量(暴击！)
    {"add_intellect",1000},--智力(暴击！)
    {"add_agility",1000},--敏捷(暴击！)
    {"attack_and_move_1",160,300},--提升160攻速及200移速(暴击！)
    {"kill_immediately",3},--攻击有几率直接秒杀目标(BOOS为百分比伤害
    {"add_baseattack",10000},--额外基础攻击力(暴击！)
    {"armor_and_resistance_1",100,50},--护甲魔抗(暴击！)
    {"attack_heal_percent",10}, --攻击吸血(暴击！)
    {"attack_heal",500},--吸血(暴击！)
    {"attack_critical",35},--暴击几率(暴击！)
    {"attack_critical_damage",4.0},--暴击伤害(暴击！)
    {"magic_critical", 20},--魔法暴击几率(暴击！)
    {"magic_critical_damage", 2.0},--魔法暴击伤害(暴击！)
    {"reduce_attack_scale",50},--伤害减免(暴击！)
    {"reduce_attack_point",500},--抵消伤害(暴击！)
    {"extra_attack_scale",100},--最终伤害(暴击！)
    {"magic_attack_scale",150},--技能伤害(暴击！)
    -- {"add_resistance", 50},--魔抗(暴击！)
    -- {"move_speed",300},--移动速度(暴击！)
    {"exp_scale",2.0},--额外经验(暴击！)
    {"drop_scale",1},--额外掉率
    {"percent_regen_heal",12},--每秒恢复最大生命值(暴击！)
    {"percent_regen_mana",3},--每秒恢复最大魔法值(暴击！)
    {"call_shadow",1},--攻击15%几率召唤影子
    {"call_rolling_stone",1},--攻击15%召唤一个陨石
    {"strength_up_temporary",1},--受攻击10%使力量暂时提高
    {"call_human_army",1},--每过40秒自动召唤树人部队
    {"max_mana",300},--魔法值上限(暴击！)
    {"ability_cd_percent",60},--技能冷却降低
}

-- 紫色
local random_properties_2 = {
    {"add_strength",500},--力量
    {"add_intellect",500},--智力
    {"add_agility",500},--敏捷
    {"attack_and_move_2",80,200},--提升80攻速及100移速
    {"add_baseattack",5000},--额外基础攻击力 
    {"armor_and_resistance_2",50,20},--护甲魔抗
    {"attack_heal_percent",7},--攻击吸血
    {"attack_heal",250},--吸血
    {"attack_critical",20},--暴击几率
    {"attack_critical_damage",2.00},--暴击伤害
    {"magic_critical", 10},--魔法暴击几率(暴击！)
    {"magic_critical_damage", 1.0},--魔法暴击伤害(暴击！)
    {"reduce_attack_scale",20},--伤害减免
    {"reduce_attack_point",200},--抵消伤害
    {"extra_attack_scale",50},--最终伤害
    {"magic_attack_scale",60},--技能伤害
    -- {"add_resistance", 20},--魔抗
    -- {"move_speed",100},--移动速度
    {"exp_scale",1.0},--额外经验
    {"percent_regen_heal",6},--每秒恢复最大生命值
    {"percent_regen_mana",2},--每秒恢复最大魔法值
    {"max_mana",200},--魔法值上限
    {"ability_cd_percent",30},--技能冷却降低
}

-- 蓝色
local random_properties_3 = {
    {"add_strength",200},--力量
    {"add_intellect",200},--智力
    {"add_agility",200},--敏捷
    {"attack_and_move_3",40,100},--提升80攻速及100移速
    {"add_baseattack",2000},--额外基础攻击力
    {"armor_and_resistance_3",20,10},--护甲魔抗
    {"attack_heal_percent",3},--攻击吸血
    {"attack_heal",120},--吸血
    {"attack_critical",10},--暴击几率
    {"attack_critical_damage",1.0},--暴击伤害
    {"magic_critical", 5},--魔法暴击几率(暴击！)
    {"magic_critical_damage", 0.5},--魔法暴击伤害(暴击！)
    {"reduce_attack_scale",10},--伤害减免
    {"reduce_attack_point",100},--抵消伤害
    {"extra_attack_scale",25},--最终伤害
    {"magic_attack_scale",30},--技能伤害
    -- {"add_resistance", 10},--魔抗
    -- {"move_speed",50},--移动速度
    {"exp_scale",0.5},--额外经验
    {"percent_regen_heal",3},--每秒恢复最大生命值
    {"percent_regen_mana",1},--每秒恢复最大魔法值
    {"max_mana",100},--魔法值上限
    {"ability_cd_percent",10},--技能冷却降低

}

function game_playerinfo:get_player_random_properties()
    local tables = {}
    tables["pool1"]=random_properties_1
    tables["pool2"]=random_properties_2
    tables["pool3"]=random_properties_3
    return tables
end

--玩家金砖
local player_wood = {}
--玩家金币
-- local player_gold = {}
--金币 炎魔 金矿 心魔 冷却时间
local boss_cool_down = {}

function game_playerinfo:http_load_playerinfo_by_server(nPlayerID, key, info_value)
    -- 读取并保存玩家的数据,只在每个玩家连接成功后调用一次
    local steam_id = PlayerResource:GetSteamAccountID(nPlayerID)
    if not player_info[steam_id] then
        player_info[steam_id] = {}
        -- player_info[steam_id].store = {}
        -- player_info[steam_id].store.vip = {}
    end
    if not player_info[steam_id]["universalExp"] then
        player_info[steam_id]["universalExp"] = 0
    end
    if not player_info[steam_id]["allUniversalExp"] then
        player_info[steam_id]["allUniversalExp"] = 0
    end
    local heroes = info_value
    if key == "heroes" then
        player_info[steam_id][key] = heroes
    elseif key == "treasures" then
        local treasures = info_value
        self:load_treasures(nPlayerID, treasures)
    elseif key == "treasureConfigs" then
        local treasureConfigs = info_value
        self:load_treasureConfigs(nPlayerID, treasureConfigs)
    elseif string.match(key, "heroEquipment") then
        if not player_equipment_data[steam_id] then
            player_equipment_data[steam_id] = {}
        end
        player_equipment_data[steam_id][key] = info_value
    elseif string.match(key, "totem") then
        if not player_totem_data[steam_id] then
            player_totem_data[steam_id] = {}
        end
        local totemDate = {}
        for key, value in pairs(info_value) do
            if string.find(key, "totem") then
                totemDate[key] = value
            end
        end
        player_totem_data[steam_id][key] = totemDate
        -- DeepPrintTable(totemDate)
    elseif key == "universalExp" then
        if player_info[steam_id][key] == 0 then
            player_info[steam_id][key] = player_info[steam_id][key] + info_value
        end
    elseif key == "allUniversalExp" then
        if player_info[steam_id][key] == 0 then
            player_info[steam_id][key] = player_info[steam_id][key] + info_value
        end
    elseif key == "levelRewardsLists" then
        if info_value == "''" then
            player_info[steam_id]["levelRewardsLists"] = {0,0,0,0,0,0,0,0,0,0,10}
            -- print("11111111111111111")
        else
            -- print(info_value)
            self:load_levelRewardsList(steam_id, info_value)
        end
    else
        player_info[steam_id][key] = info_value
    end
    player_info[steam_id].isSave = 1
    player_wood[steam_id] = 0
    self:init_dynamic_properties(steam_id)
end

-- 商城数据初始化
function game_playerinfo:http_load_playerstore_by_server(steam_id, info_value)
    if not player_store[steam_id] then
        player_store[steam_id] = {}
    end
    for key, value in pairs(info_value) do
        player_store[steam_id][value.keyword] = value.value
    end
    -- game_playerinfo:UpdateDoubleExperience(steam_id)
end

-- 重新读取商城商品
function game_playerinfo:reload_playerstore_by_server(steam_id, info_value)
    player_store[steam_id] = {}
    for key, value in pairs(info_value) do
        player_store[steam_id][value.keyword] = value.value
    end
    -- game_playerinfo:UpdateDoubleExperience(steam_id)
end

-- 更新双倍通用经验的状态
function game_playerinfo:UpdateDoubleExperience(steam_id)
    if player_store[steam_id]["Experience_double_card"] then
        game_playerinfo:set_dynamic_properties(steam_id, "extra_universal_exp", 1)
    end
end

function game_playerinfo:check_vip(steam_id)
    if not player_store[steam_id].vip then
        player_store[steam_id].vip_1 = 0
        player_store[steam_id].vip_2 = 0
        player_store[steam_id].vip_3 = 0
        player_store[steam_id].vip_4 = 0
    end
end
---------------------------------------------------------------------------------------------------
-- 商城数据初始化
function game_playerinfo:init_playerstore(steam_id)
    if not player_store[steam_id] then
        player_store[steam_id] = {}

        player_store[steam_id]["vip_1"] = 0
        player_store[steam_id]["vip_2"] = 0
        player_store[steam_id]["vip_3"] = 0
        player_store[steam_id]["vip_4"] = 0
        player_store[steam_id]["bull_coin"] = 0
        player_store[steam_id]["score"] = 0
    end
    return player_store[steam_id]
end

function game_playerinfo:get_playerbull_coin(steam_id)
    if not player_store[steam_id]["bull_coin"] then
        player_store[steam_id]["bull_coin"] = 0
    end
    return player_store[steam_id]["bull_coin"]
end
-- 直接赋值
function game_playerinfo:set_playerbull_coin(steam_id, value)
    player_store[steam_id]["bull_coin"] = value
end
-- 增加值,可以为负值
function game_playerinfo:update_playerbull_coin(steam_id, value)
    if not player_store[steam_id]["bull_coin"] then
        player_store[steam_id]["bull_coin"] = 0
    end
    player_store[steam_id]["bull_coin"] = player_store[steam_id]["bull_coin"] + value
end

--  积分更新
function game_playerinfo:update_score(nPlayerID, nQuantity)
    if nQuantity <= 0 then
        -- body
        return
    end
    Account:AddCustomCoinValue(nPlayerID,1,nQuantity)
end

-- 获取当前积分
function game_playerinfo:get_score(nPlayerID)
    local score = Account:GetData(nPlayerID,"score")
    return score
end

-- function game_playerinfo:get_playerscore(steam_id)
--     if not player_store[steam_id]["score"] then
--         player_store[steam_id]["score"] = 0
--     end
--     return player_store[steam_id]["score"]
-- end
-- -- 直接赋值
-- function game_playerinfo:set_playerscore(steam_id, value)
--     player_store[steam_id]["score"] = value
-- end
-- -- 增加值,可以为负值
-- function game_playerinfo:update_playerscore(steam_id, value)
--     if not player_store[steam_id]["score"] then
--         player_store[steam_id]["score"] = 0
--     end
--     player_store[steam_id]["score"] = player_store[steam_id]["score"] + value
-- end

function game_playerinfo:get_player_store()
    return player_store
end

function game_playerinfo:hasplayerinfo(steam_id)
    if not player_info[steam_id] then
        return false
    end
    return true
end

function game_playerinfo:create_playerinfo(nPlayerID, isSave)
    -- 初次建档的玩家数据初始化
    local steam_id = PlayerResource:GetSteamAccountID(nPlayerID)
    if not player_info[steam_id] then
        player_info[steam_id] = {}
        -- player_info[steam_id]["hero_exp"] = {}
        -- player_info[steam_id]["hero_level"] = {}
        -- player_info[steam_id]["hero_sublime"] = {}
        -- for key, value in ipairs(CustomHeroList) do
        --     player_info[steam_id].hero_exp[key] = 0
        --     player_info[steam_id].hero_level[key] = 0
        --     player_info[steam_id].hero_sublime[key] = 0
        -- end
        player_info[steam_id]["heroes"] = {}
        for key, value in ipairs(CustomHeroList) do
            player_info[steam_id]["heroes"][key] = {}
            player_info[steam_id]["heroes"][key]["heroId"] = key
            player_info[steam_id]["heroes"][key]["heroExp"] = 0
            player_info[steam_id]["heroes"][key]["heroLevel"] = 0
            player_info[steam_id]["heroes"][key]["heroSublime"] = 0
            player_info[steam_id]["heroes"][key]["heroSelect"] = 0
            player_info[steam_id]["heroes"][key]["heroWin"] = 0
        end
        -- 技能统计初始化
        player_info[steam_id]["skills"] = {}
        player_info[steam_id]["mapExp"] = 0
        player_info[steam_id]["mapLevel"] = 0
        player_info[steam_id]["passLevel"] = 0
        player_info[steam_id]["universalExp"] = 0
        player_info[steam_id]["allUniversalExp"] = 0
        player_info[steam_id]["useHeroExp"] = 0
        player_info[steam_id]["relicsExp"] = 0
        player_info[steam_id]["chipNumber"] = 0
        player_info[steam_id]["compensationLevel"] = 0

        player_info[steam_id]["itemCallMaterialsLefthand"] = 0
        player_info[steam_id]["itemCallMaterialsRighthand"] = 0
        player_info[steam_id]["itemCallMaterialsEyes"] = 0
        player_info[steam_id]["itemCallMaterialsSoul"] = 0
        player_info[steam_id]["itemCallMaterialsHeart"] = 0

        player_info[steam_id]["itemAdvancedMaterialsZhui"] = 0
        player_info[steam_id]["itemAdvancedMaterialsEyes"] = 0
        player_info[steam_id]["itemAdvancedMaterialsTianping"] = 0
        player_info[steam_id]["itemAdvancedMaterialsKey"] = 0
        player_info[steam_id]["itemAdvancedMaterialsChochma"] = 0
        player_info[steam_id]["itemAdvancedMaterialsCane"] = 0
        player_info[steam_id]["itemAdvancedMaterialsJewelry"] = 0
        player_info[steam_id].isSave = isSave
        player_info[steam_id].verification = 1
        -- 装备部位等级和经验
        player_equipment_data[steam_id] = {}
        player_equipment_data[steam_id]["heroEquipmentHead"] = 1
        player_equipment_data[steam_id]["heroEquipmentArmor"] = 1
        player_equipment_data[steam_id]["heroEquipmentLegguard"] = 1
        player_equipment_data[steam_id]["heroEquipmentLeg"] = 1
        player_equipment_data[steam_id]["heroEquipmentShoes"] = 1
        player_equipment_data[steam_id]["heroEquipmentMainweapon"] = 1
        player_equipment_data[steam_id]["heroEquipmentSpeciaiweapon"] = 1
        player_equipment_data[steam_id]["heroEquipmentHeadExp"] = 0
        player_equipment_data[steam_id]["heroEquipmentArmorExp"] = 0
        player_equipment_data[steam_id]["heroEquipmentLegguardExp"] = 0
        player_equipment_data[steam_id]["heroEquipmentLegExp"] = 0
        player_equipment_data[steam_id]["heroEquipmentShoesExp"] = 0
        player_equipment_data[steam_id]["heroEquipmentMainweaponExp"] = 0
        player_equipment_data[steam_id]["heroEquipmentSpeciaiweaponExp"] = 0
        -- 数据统计初始化
        
        player_info[steam_id]["killYanmo"] = 0
        player_info[steam_id]["killBoss"] = 0
        
        -- 单抽宝箱计数
        player_info[steam_id]["onceBoxNumber"] = 0
        -- 领取每日月卡奖励资格
        player_info[steam_id]["getMonthCard"] = 0
        -- 领取地图奖励计数
        player_info[steam_id]["mapRewardsCount"] = 0
        -- 领取首通奖励
        player_info[steam_id]["levelRewardsLists"] = {0,0,0,0,0,0,0,0,0,0,10}
        -- 图腾数据初始化
        player_totem_data[steam_id] = {}
        player_totem_data[steam_id]["totem"] = {}
        player_totem_data[steam_id]["totem"]["totemCfLevel"] = -1
        player_totem_data[steam_id]["totem"]["totemCfNumber"] = 0
        player_totem_data[steam_id]["totem"]["totemDzLevel"] = -1
        player_totem_data[steam_id]["totem"]["totemDzNumber"] = 0
        player_totem_data[steam_id]["totem"]["totemDjLevel"] = -1
        player_totem_data[steam_id]["totem"]["totemDjNumber"] = 0
        player_totem_data[steam_id]["totem"]["totemSjLevel"] = -1
        player_totem_data[steam_id]["totem"]["totemSjNumber"] = 0
        player_totem_data[steam_id]["totem"]["totemSwLevel"] = -1
        player_totem_data[steam_id]["totem"]["totemSwNumber"] = 0
        player_totem_data[steam_id]["totem"]["totemYxLevel"] = -1
        player_totem_data[steam_id]["totem"]["totemYxNumber"] = 0
        player_totem_data[steam_id]["totem"]["totemBwLevel"] = -1
        player_totem_data[steam_id]["totem"]["totemBwNumber"] = 0
        player_totem_data[steam_id]["totem"]["totemJhLevel"] = -1
        player_totem_data[steam_id]["totem"]["totemJhNumber"] = 0
        player_totem_data[steam_id]["totem"]["totemZfLevel"] = -1
        player_totem_data[steam_id]["totem"]["totemZfNumber"] = 0
        player_totem_data[steam_id]["totem"]["totemMlLevel"] = -1
        player_totem_data[steam_id]["totem"]["totemMlNumber"] = 0
        player_totem_data[steam_id]["totem"]["totemSmLevel"] = -1
        player_totem_data[steam_id]["totem"]["totemSmNumber"] = 0
        player_totem_data[steam_id]["totem"]["totemSdLevel"] = -1
        player_totem_data[steam_id]["totem"]["totemSdNumber"] = 0
        player_totem_data[steam_id]["totem"]["totemMhLevel"] = -1
        player_totem_data[steam_id]["totem"]["totemMhNumber"] = 0
        player_totem_data[steam_id]["totem"]["totemAyLevel"] = -1
        player_totem_data[steam_id]["totem"]["totemAyNumber"] = 0
        player_totem_data[steam_id]["totem"]["totemFyLevel"] = -1
        player_totem_data[steam_id]["totem"]["totemFyNumber"] = 0
    end
    -- DeepPrintTable(player_info)
    player_wood[steam_id] = 0
    self:init_dynamic_properties(steam_id)
    self:InitTotemAttribute(nPlayerID)
    return player_info[steam_id]
end

--  神之遗物数据请求
function game_playerinfo:OnGodEquipmentData(data)
    local player_id = data.PlayerID
    local nSteamID = PlayerResource:GetSteamAccountID(player_id)
    local equipment_data = game_playerinfo:get_equipment_data(nSteamID)
    -- local bead_config =  config_item:get_bead_add_config()
    
    local send_table = {}
    send_table["relicsExp"] = (player_info[nSteamID].relicsExp or 0)
    for key, value in pairs(equipment_data) do
        if string.match(key, "Exp") then
            local name = string.sub(key, 1, -4)
            if not send_table[name] then
                send_table[name] = {}
            end
            send_table[name]["exp"] = value
        else
            local bead_eachlevel_config =  config_item:get_bead_add_eachlevel_config(key, (math.floor(value*0.1)+1))
            if not send_table[key] then
                send_table[key] = {}
            end
            send_table[key]["level"] = value
            send_table[key]["adddata"] = bead_eachlevel_config
            if send_table[key]["level"] >= 50 then
                send_table[key]["maxexp"] = 0
            else
                send_table[key]["maxexp"] = 20 + (1 + (value-1) * 2 * (value-1)) * 5
            end
            if send_table[key]["level"] > 0 then
                send_table[key]["nowdata"] = 0
                for i = 1, send_table[key]["level"] do
                    local add_properties =  config_item:get_bead_add_eachlevel_config(key, (math.floor((i-1)*0.1)+1))
                    send_table[key]["nowdata"] = send_table[key]["nowdata"] + add_properties
                end
            else
                send_table[key]["nowdata"] = 0
            end
        end
    end
    -- DeepPrintTable(send_table)
    CustomGameEventManager:Send_ServerToPlayer(PlayerResource:GetPlayer(player_id), "response_equipment_data",send_table)
end

--  神之遗物升级
function game_playerinfo:OnLevelUpGodEquipment(data)
    local player_id = data.PlayerID
    local EquipmentName = data.name
    local steam_id = PlayerResource:GetSteamAccountID(player_id)
    local nowLevel = player_equipment_data[steam_id][EquipmentName]
    local nowExp = player_equipment_data[steam_id][EquipmentName.."Exp"]
    local needExp = 20+(1+(nowLevel-1)*(nowLevel-1)*2)*5
    if nowLevel >= 50 then
        CustomGameEventManager:Send_ServerToAllClients("response_lvup_godequipment",{result = "error_levelequipment_maxlevel", })
        return
    end
    if nowExp > needExp then
        player_equipment_data[steam_id][EquipmentName] = player_equipment_data[steam_id][EquipmentName] + 1
        player_equipment_data[steam_id][EquipmentName.."Exp"] = player_equipment_data[steam_id][EquipmentName.."Exp"] - needExp
        if player_equipment_data[steam_id][EquipmentName] >= 10 then
            needExp = 0
        else
            needExp = 20+(1+(player_equipment_data[steam_id][EquipmentName] - 1)*2*(player_equipment_data[steam_id][EquipmentName] - 1))*5
        end
        
        CustomGameEventManager:Send_ServerToAllClients("response_lvup_godequipment",{result = "tip_levelequipment", newlevel = player_equipment_data[steam_id][EquipmentName], needexp = needExp, relicsExp = player_info[steam_id]["relicsExp"]})
        
        common_item_ability:refresh_dynamic_properties(PlayerResource:GetPlayer(player_id):GetAssignedHero(),EquipmentName)
        local ArchiveTable = {
            "player_equipment_data",
            "relicsExp",
        }
        game_playerinfo:SaveArchiveTable(player_id, ArchiveTable)
    
        Archive:SaveProfileByID(player_id)
    else
        if (needExp - nowExp) <= player_info[steam_id]["relicsExp"] then
            player_info[steam_id]["relicsExp"] = player_info[steam_id]["relicsExp"] - (needExp - nowExp)
            player_equipment_data[steam_id][EquipmentName] = player_equipment_data[steam_id][EquipmentName] + 1
            player_equipment_data[steam_id][EquipmentName.."Exp"] = 0
            if player_equipment_data[steam_id][EquipmentName] >= 10 then
                needExp = 0
            else
                needExp = 20+(1+(player_equipment_data[steam_id][EquipmentName] - 1)*2*(player_equipment_data[steam_id][EquipmentName] - 1))*5
            end
            CustomGameEventManager:Send_ServerToAllClients("response_lvup_godequipment",{result = "tip_levelequipment", newlevel = player_equipment_data[steam_id][EquipmentName], needexp = needExp, relicsExp = player_info[steam_id]["relicsExp"]})
            
            common_item_ability:refresh_dynamic_properties(PlayerResource:GetPlayer(player_id):GetAssignedHero(),EquipmentName)
            local ArchiveTable = {
                "player_equipment_data",
                "relicsExp",
            }
            game_playerinfo:SaveArchiveTable(player_id, ArchiveTable)
        
            Archive:SaveProfileByID(player_id)
        else
            -- 经验不足
            CustomGameEventManager:Send_ServerToAllClients("response_lvup_godequipment",{result = "error_levelequipment_noexp", })
        end
    end
end



--  图腾数据请求
function game_playerinfo:OnTotemData(data)
    local player_id = data.PlayerID
    local nSteamID = PlayerResource:GetSteamAccountID(player_id)
    local totem_data = game_playerinfo:get_totem_data(nSteamID)
    print("OnTotemData>>>>>>>>>>>>>>>>>>")
    -- DeepPrintTable(totem_data)
    
    local send_table = {}
    
    for key, value in pairs(totem_data["totem"]) do
        if string.match(key, "totem") then
            local name = string.sub(key, 1, 7)
            if string.match(key, "Number") then
                if not send_table[name] then
                    send_table[name] = {}
                end
                send_table[name]["Number"] = value
            else
                if not send_table[name] then
                    send_table[name] = {}
                end
                send_table[name]["Level"] = value
                send_table[name]["NeedNumber"] = config_item:get_totem_need_number(name, send_table[name]["Level"])
            end
        end
    end
    -- DeepPrintTable(send_table)
    CustomGameEventManager:Send_ServerToPlayer(PlayerResource:GetPlayer(player_id), "response_totem_data",send_table)
end

--  图腾升级
function game_playerinfo:OnLevelUpTotem(data)
    local player_id = data.PlayerID
    local totemName = data.name
    
    local steam_id = PlayerResource:GetSteamAccountID(player_id)
    local totem_data = game_playerinfo:get_totem_data(steam_id)
    local nowLevel = totem_data["totem"][totemName.."Level"]
    if (totemName == "totemSw" or totemName == "totemYx" or totemName == "totemBw") and nowLevel == 0 then
        -- body
        return
    end
    local nowNumber = totem_data["totem"][totemName.."Number"]
    local needNumber = config_item:get_totem_need_number(totemName, nowLevel)
    if nowLevel >= 50 then
        -- 该图腾等级已经最大
        CustomGameEventManager:Send_ServerToPlayer(PlayerResource:GetPlayer(player_id), "response_errortext",{errortext = "error_levelequipment_maxlevel", })
        return
    end
    if nowNumber < needNumber then
        -- 升级所需图腾碎片不足
        CustomGameEventManager:Send_ServerToPlayer(PlayerResource:GetPlayer(player_id), "response_errortext",{errortext = "error_noenough_totemnumber", })
        return
    end
    game_playerinfo:update_totem_data(steam_id, totemName, -needNumber)
    game_playerinfo:update_totem_level(steam_id, totemName)
    local send_table = {result = "tip_leveltotem", name = totemName, newlevel = game_playerinfo:get_totem_level(steam_id, totemName), needexp = config_item:get_totem_need_number(totemName, game_playerinfo:get_totem_level(steam_id, totemName)), newnumber = game_playerinfo:get_totem_number(steam_id, totemName)}
    -- print(send_table)
    CustomGameEventManager:Send_ServerToPlayer(PlayerResource:GetPlayer(player_id), "response_lvup_totem", send_table)

    -- game_playerinfo:RushTotemAttribute(player_id)
    game_playerinfo:UpdateTotemAttribute(player_id, totemName)
    game_playerinfo:save_totem(player_id)
end

--  图腾融合
function game_playerinfo:OnFusionTotem(data)
    local player_id = data.PlayerID
    local steam_id = PlayerResource:GetSteamAccountID(player_id)
    local totem_data = game_playerinfo:get_totem_data(steam_id)
    local materials_data = data.materials
    local finishName = data.finishName
    if finishName == "totemSw" or finishName == "totemYx" or finishName == "totemBw" or finishName == "" then
        -- body
        return
    end
    local need_materials = {}
    for key, value in pairs(materials_data) do
        if value == "" then
            -- body
            CustomGameEventManager:Send_ServerToPlayer(PlayerResource:GetPlayer(player_id), "response_errortext",{errortext = "error_no_enough_materials", })
            return
        end
        if not need_materials[value] then
            -- body
            need_materials[value] = 1
        else
            need_materials[value] = need_materials[value] + 1
        end
    end
    -- if #materials_data < 3 then
    --     -- body
    --     CustomGameEventManager:Send_ServerToPlayer(PlayerResource:GetPlayer(player_id), "response_fusion_totem",{result = "error_no_enough_materials", })
    --     return
    -- end
    for key, value in pairs(need_materials) do
        -- body
        local totemNumber = totem_data["totem"][key.."Number"]
        if totemNumber <= 0 or totemNumber < value then
            -- body
            CustomGameEventManager:Send_ServerToPlayer(PlayerResource:GetPlayer(player_id), "response_errortext",{errortext = "error_no_enough_materials", })
            return
        end
    end
    -- print(materialsTypes)
    
    local result_data = {}
    for key, value in pairs(need_materials) do
        game_playerinfo:update_totem_data(steam_id, key, -value)
        result_data[key] = -value
    end
    game_playerinfo:update_totem_data(steam_id, finishName, 1)
    result_data[finishName] = 1
    CustomGameEventManager:Send_ServerToPlayer(PlayerResource:GetPlayer(player_id), "response_fusion_totem",{result = "error_succed_fusion", data = result_data, })
    -- game_playerinfo:RushTotemAttribute(player_id)
    game_playerinfo:save_totem(player_id)
end

--  
function game_playerinfo:InitTotemAttribute(player_id)
    
    local steam_id = PlayerResource:GetSteamAccountID(player_id)
    local totem_data = game_playerinfo:get_totem_data(steam_id)
    for key, value in pairs(totem_data["totem"]) do
        if key == "totemCfLevel" then
            -- 
            if value >= 0 then
                self:set_dynamic_properties(steam_id, "gold_scale", (30+value*2))
                if value >= 10 then
                    -- body
                    -- 杀怪加钱
                    local properties = config_item:get_totem_alladd_by_stage("totemCf", (math.floor((value-10)*0.1)+1))
                    self:set_dynamic_properties(steam_id, "kill_gold_scale", properties)
                end
            end
        elseif key == "totemDzLevel" then
            -- 解锁后每次装备升级失败，每升1级，下次成功几率+0.2%
            if value >= 0 then
                self:set_dynamic_properties(steam_id, "extra_success_rate", value*0.2)
                if value >= 10 then
                    -- body
                    -- 魔法暴击
                    local properties = config_item:get_totem_alladd_by_stage("totemDz", (math.floor((value-10)*0.1)+1))
                    self:set_dynamic_properties(steam_id, "magic_critical", properties)
                end
            end
        elseif key == "totemDjLevel" then
            -- 解锁后，每升1级，额外获得成长的20%属性 每升1级，经验获取+2%
            if value >= 0 then
                self:set_dynamic_properties(steam_id, "exp_scale", value*0.02)
                if value >= 10 then
                    -- body
                    local properties = config_item:get_totem_alladd_by_stage("totemDj", (math.floor((value-10)*0.1)+1))
                    self:set_dynamic_properties(steam_id, "add_intellect_scale", properties)
                end
            end
        elseif key == "totemSjLevel" then
            -- 解锁后，神之遗物经验获取+20% 每升1级，神之遗物经验获取+2%
            if value >= 0 then
                self:set_dynamic_properties(steam_id, "extra_universal_exp", ((20+value*2)*0.01))
                if value >= 10 then
                    -- body
                    local properties = config_item:get_totem_alladd_by_stage("totemSj", (math.floor((value-10)*0.1)+1))
                    self:set_dynamic_properties(steam_id, "extra_mapexp", properties)
                end
            end
        elseif key == "totemSwLevel" then
            -- 解锁后，复活时间缩短3秒
            if value >= 0 then
                self:set_dynamic_properties(steam_id, "respawn_second", 3)
            end
        elseif key == "totemYxLevel" then
            -- 解锁后，开局可重新随机英雄1次
            if value >= 0 then
                self:set_dynamic_properties(steam_id, "re_pick", 1)
            end
        elseif key == "totemBwLevel" then
            -- 通过第一波后，立即赠送一个宝物书
            if value >= 0 then
                self:set_dynamic_properties(steam_id, "persent_treasure", 1)
            end
        elseif key == "totemJhLevel" then
            -- 暴击伤害+30% 每升1级，暴击伤害+5%
            if value >= 0 then
                self:set_dynamic_properties(steam_id, "attack_critical_damage", (0.3+value*0.05))
                if value >= 10 then
                    -- body
                    local properties = config_item:get_totem_alladd_by_stage("totemJh", (math.floor((value-10)*0.1)+1))
                    self:set_dynamic_properties(steam_id, "attack_critical", properties)
                end
            end
        elseif key == "totemZfLevel" then
            -- 每秒获得金钱+5。开局金钱+200。初始金砖+1 每升1级，每秒金钱+2，开局金钱+100。每5级，金砖+1
            if value >= 0 then
                self:set_dynamic_properties(steam_id, "extra_addgold_second", (5+value*2))
                self:set_dynamic_properties(steam_id, "extra_begin_golds", (200+value*100))
                self:set_dynamic_properties(steam_id, "extra_begin_wood", (1+(math.floor(value*0.1))))
                if value >= 10 then
                    -- body
                    local properties = config_item:get_totem_alladd_by_stage("totemZf", (math.floor((value-10)*0.1)+1))
                    self:set_dynamic_properties(steam_id, "add_intellect_scale", properties)
                    self:set_dynamic_properties(steam_id, "add_agility_scale", properties)
                    self:set_dynamic_properties(steam_id, "add_strength_scale", properties)
                end
            end
        elseif key == "totemMlLevel" then
            -- 解锁后，蓝量上限+50，每秒回蓝+1  每升1级，蓝量上限+4，每秒回蓝+0.2
            if value >= 0 then
                self:set_dynamic_properties(steam_id, "max_mana", (50+value*4))
                self:set_dynamic_properties(steam_id, "mana_regen", (1+value*0.1))
                if value >= 10 then
                    -- body
                    local properties = config_item:get_totem_alladd_by_stage("totemMl", (math.floor((value-10)*0.1)+1))
                    self:set_dynamic_properties(steam_id, "magic_attack_scale", properties)
                end
            end
        elseif key == "totemSmLevel" then
            -- 血量上限+5%，每秒回血+10 每升1级，血量上限+1%，每秒回血+10
            if value >= 0 then
                self:set_dynamic_properties(steam_id, "extra_health_percent", (5+value*1))
                self:set_dynamic_properties(steam_id, "heal_regen", (10+value*10))
                if value >= 10 then
                    -- body
                    local properties = config_item:get_totem_alladd_by_stage("totemSm", (math.floor((value-10)*0.1)+1))
                    self:set_dynamic_properties(steam_id, "extra_health_percent", properties)
                end
            end
        elseif key == "totemSdLevel" then
            -- 解锁后，攻速+10  每升1级，移速+10，攻速+3
            if value >= 0 then
                self:set_dynamic_properties(steam_id, "extra_attack_speed", (10+value*3))
                self:set_dynamic_properties(steam_id, "move_speed", value*10)
                if value >= 10 then
                    -- body
                    local properties = config_item:get_totem_alladd_by_stage("totemSd", (math.floor((value-10)*0.1)+1))
                    self:set_dynamic_properties(steam_id, "physics_piercing", properties)
                    -- local nPlayer = PlayerResource:GetPlayer(player_id)
                    -- if nPlayer and not nPlayer:IsNull() then
                    --     -- body
                    --     local nHero = nPlayer:GetAssignedHero()
                    --     nHero:AddNewModifier(nHero, nil, "modifier_physics_piercing_lua", {count = math.floor(value/10)*5})
                    -- end
                end
            end
        elseif key == "totemMhLevel" then
            -- 解锁后，物理输出+10% 每升1级，物理输出+2%
            if value >= 0 then
                self:set_dynamic_properties(steam_id, "physics_attack_scale", (10+value*2))
                if value >= 10 then
                    -- body
                    local properties = config_item:get_totem_alladd_by_stage("totemMh", (math.floor((value-10)*0.1)+1))
                    self:set_dynamic_properties(steam_id, "physics_attack_scale", properties)
                end
            end
        elseif key == "totemAyLevel" then
            -- 解锁后，魔法伤害+10% 每升1级，魔法输出+2%
            if value >= 0 then
                self:set_dynamic_properties(steam_id, "magic_attack_scale", (10+value*2))
                if value >= 10 then
                    -- body
                    local properties = config_item:get_totem_alladd_by_stage("totemAy", (math.floor((value-10)*0.1)+1))
                    self:set_dynamic_properties(steam_id, "magic_attack_scale", properties)
                end
            end
        elseif key == "totemFyLevel" then
            -- 解锁后，获得5点护甲以及10%的魔法抗性 每升1级，护甲+0.5，魔法抗性+2%
            if value >= 0 then
                self:set_dynamic_properties(steam_id, "add_armor", (5+value*0.5))
                self:set_dynamic_properties(steam_id, "add_resistance", (10+value*1))
                if value >= 10 then
                    -- body
                    local properties = config_item:get_totem_alladd_by_stage("totemFy", (math.floor((value-10)*0.1)+1))
                    self:set_dynamic_properties(steam_id, "reduce_attack_scale", properties)
                end
            end
        end
    end
end

--  更新图腾增加的属性
function game_playerinfo:UpdateTotemAttribute(player_id, totemName)
    
    local steam_id = PlayerResource:GetSteamAccountID(player_id)
    local level = game_playerinfo:get_totem_level(steam_id, totemName)
    local nPlayer = PlayerResource:GetPlayer(player_id) 
    if not nPlayer or nPlayer:IsNull() then
        return
    end
    local isRecount = false
    local hero = nPlayer:GetAssignedHero()
    if totemName == "totemCf" then
        -- 解锁后金币获取+30% 每升1级，金币获取+2%
        if level == 0 then
            self:set_dynamic_properties(steam_id, "gold_scale", 30)
        elseif level > 0 then
            self:set_dynamic_properties(steam_id, "gold_scale", 2)
        end
        if level >= 10 and 0==level%10 then
            -- body
            local properties = config_item:totem_stage_add("totemCf", (math.floor((level-10)*0.1)+1))
            self:set_dynamic_properties(steam_id, "kill_gold_scale", properties)
            isRecount = true
        end
    elseif totemName == "totemDz" then
        -- 解锁后每次装备升级失败，每升1级，下次成功几率+0.2%
        self:set_dynamic_properties(steam_id, "extra_success_rate", 0.2)
        if level >= 10 and 0==level%10 then
            -- body
            local properties = config_item:totem_stage_add("totemDz", (math.floor((level-10)*0.1)+1))
            self:set_dynamic_properties(steam_id, "magic_critical", properties)
            isRecount = true
        end
    elseif totemName == "totemDj" then
        -- 解锁后，每升1级，额外获得成长的20%属性 每升1级，经验获取+2%
        self:set_dynamic_properties(steam_id, "exp_scale", 0.02)
        if level >= 10 and 0==level%10 then
            -- body
            local properties = config_item:totem_stage_add("totemDj", (math.floor((level-10)*0.1)+1))
            self:set_dynamic_properties(steam_id, "add_intellect_scale", properties)
            isRecount = true
        end
        
    elseif totemName == "totemSj" then
        -- 解锁后，神之遗物经验获取+20% 每升1级，通用经验获取+2%
        if level == 0 then
            self:set_dynamic_properties(steam_id, "extra_universal_exp", 0.2)
        elseif level > 0 then
            self:set_dynamic_properties(steam_id, "extra_universal_exp", 0.02)
        end
        if level >= 10 and 0==level%10 then
            -- body
            local properties = config_item:totem_stage_add("totemSj", (math.floor((level-10)*0.1)+1))
            self:set_dynamic_properties(steam_id, "extra_mapexp", properties)
            isRecount = true
        end
        
    elseif totemName == "totemJh" then
        -- 暴击伤害+30% 每升1级，暴击伤害+5%
        if level == 0 then
            self:set_dynamic_properties(steam_id, "attack_critical_damage", 0.3)
        elseif level > 0 then
            self:set_dynamic_properties(steam_id, "attack_critical_damage", 0.05)
        end
        if level >= 10 and 0==level%10 then
            -- body
            local properties = config_item:totem_stage_add("totemJh", (math.floor((level-10)*0.1)+1))
            self:set_dynamic_properties(steam_id, "attack_critical", properties)
            isRecount = true
        end
        
    elseif totemName == "totemZf" then
        -- 每秒获得金钱+5。开局金钱+200。初始金砖+1 每升1级，每秒金钱+2，开局金钱+100。每5级，金砖+1
        if level == 0 then
            self:set_dynamic_properties(steam_id, "extra_addgold_second", 5)
            self:set_dynamic_properties(steam_id, "extra_begin_golds", 200)
            self:set_dynamic_properties(steam_id, "extra_begin_wood", 1)
        elseif level > 0 then
            self:set_dynamic_properties(steam_id, "extra_addgold_second", 2)
            self:set_dynamic_properties(steam_id, "extra_begin_golds", 100)
            if 0==level%10 then
                -- body
                self:set_dynamic_properties(steam_id, "extra_begin_wood", 1)
            end
        end
        if level >= 10 and 0==level%10 then
            -- body
            local properties = config_item:totem_stage_add("totemZf", (math.floor((level-10)*0.1)+1))
            self:set_dynamic_properties(steam_id, "add_intellect_scale", properties)
            self:set_dynamic_properties(steam_id, "add_agility_scale", properties)
            self:set_dynamic_properties(steam_id, "add_strength_scale", properties)
            isRecount = true
        end
        
    elseif totemName == "totemMl" then
        -- 解锁后，蓝量上限+50，每秒回蓝+1  每升1级，蓝量上限+4，每秒回蓝+0.2
        if level == 0 then
            self:set_dynamic_properties(steam_id, "max_mana", 50)
            self:set_dynamic_properties(steam_id, "mana_regen", 1)
        elseif level > 0 then
            self:set_dynamic_properties(steam_id, "max_mana", 4)
            self:set_dynamic_properties(steam_id, "mana_regen", 0.1)
        end
        if level >= 10 and 0==level%10 then
            -- body
            local properties = config_item:totem_stage_add("totemMl", (math.floor((level-10)*0.1)+1))
            self:set_dynamic_properties(steam_id, "magic_attack_scale", properties)
            isRecount = true
        end
        
    elseif totemName == "totemSm" then
        -- 血量上限+5%，每秒回血+10 每升1级，血量上限+1%，每秒回血+10
        if level == 0 then
            self:set_dynamic_properties(steam_id, "extra_health_percent", 5)
            self:set_dynamic_properties(steam_id, "heal_regen", 10)
        elseif level > 0 then
            self:set_dynamic_properties(steam_id, "extra_health_percent", 1)
            self:set_dynamic_properties(steam_id, "heal_regen", 10)
        end
        if level >= 10 and 0==level%10 then
            -- body
            local properties = config_item:totem_stage_add("totemSm", (math.floor((level-10)*0.1)+1))
            self:set_dynamic_properties(steam_id, "extra_health_percent", properties)
            isRecount = true
        end
        
    elseif totemName == "totemSd" then
        -- 解锁后，攻速+10  每升1级，移速+10，攻速+5
        if level == 0 then
            self:set_dynamic_properties(steam_id, "extra_attack_speed", 10)
            self:set_dynamic_properties(steam_id, "move_speed", level*10)
        elseif level > 0 then
            self:set_dynamic_properties(steam_id, "extra_attack_speed", 5)
            self:set_dynamic_properties(steam_id, "move_speed", 10)
        end
        if level >= 10 and 0==level%10 then
            -- body
            local properties = config_item:totem_stage_add("totemSd", (math.floor((level-10)*0.1)+1))
            self:set_dynamic_properties(steam_id, "physics_piercing", properties)
            local nModifier = hero:FindModifierByName("modifier_physics_piercing_lua")
            if nModifier then
                -- body
                hero:SetModifierStackCount("modifier_physics_piercing_lua", hero, math.floor(level/10)*5)
            else
                hero:AddNewModifier(hero, nil, "modifier_physics_piercing_lua", {count = math.floor(level/10)*5})
            end
            isRecount = true
        end
    elseif totemName == "totemMh" then
        -- 解锁后，物理输出+10% 每升1级，物理输出+2%
        if level == 0 then
            self:set_dynamic_properties(steam_id, "physics_attack_scale", 10)
        elseif level > 0 then
            self:set_dynamic_properties(steam_id, "physics_attack_scale", 2)
        end
        if level >= 10 and 0==level%10 then
            -- body
            local properties = config_item:totem_stage_add("totemMh", (math.floor((level-10)*0.1)+1))
            self:set_dynamic_properties(steam_id, "physics_attack_scale", properties)
            isRecount = true
        end
        
    elseif totemName == "totemAy" then
        -- 解锁后，魔法伤害+10% 每升1级，魔法输出+2%
        if level == 0 then
            self:set_dynamic_properties(steam_id, "magic_attack_scale", 10)
        elseif level > 0 then
            self:set_dynamic_properties(steam_id, "magic_attack_scale", 2)
        end
        if level >= 10 and 0==level%10 then
            -- body
            local properties = config_item:totem_stage_add("totemAy", (math.floor((level-10)*0.1)+1))
            self:set_dynamic_properties(steam_id, "magic_attack_scale", properties)
            isRecount = true
        end
        
    elseif totemName == "totemFy" then
        -- 解锁后，获得5点护甲以及10%的魔法抗性 每升1级，护甲+0.5，魔法抗性+1%
        if level == 0 then
            self:set_dynamic_properties(steam_id, "add_armor", 5)
            self:set_dynamic_properties(steam_id, "add_resistance", 10)
        elseif level > 0 then
            self:set_dynamic_properties(steam_id, "add_armor", 0.5)
            self:set_dynamic_properties(steam_id, "add_resistance", 1)
        end
        if level >= 10 and 0==level%10 then
            -- body
            local properties = config_item:totem_stage_add("totemFy", (math.floor((level-10)*0.1)+1))
            self:set_dynamic_properties(steam_id, "reduce_attack_scale", properties)
            isRecount = true
        end
        
    end
    if isRecount then
        -- 重新统计套装属性
        -- print(": "..self:get_dynamic_properties_by_key(steam_id, "maxlevel_totem"))
        hero:SetBaseStrength(hero:GetBaseStrength() - self:get_dynamic_properties_by_key(steam_id, "maxlevel_totem"))
        hero:SetBaseAgility(hero:GetBaseAgility() - self:get_dynamic_properties_by_key(steam_id, "maxlevel_totem"))
        hero:SetBaseIntellect(hero:GetBaseIntellect() - self:get_dynamic_properties_by_key(steam_id, "maxlevel_totem"))

        self:InitMaxLevelTotemAttribute(player_id)
    end
end

-- 图腾满级套装属性添加
function game_playerinfo:InitMaxLevelTotemAttribute(player_id)
    -- 所有图腾满10级套装属性
    -- 白字全属性+100
    local steam_id = PlayerResource:GetSteamAccountID(player_id)
    local totem_data = game_playerinfo:get_totem_data(steam_id)
    local nPlayer = PlayerResource:GetPlayer(player_id) 
    if not nPlayer or nPlayer:IsNull() then
        return
    end
    local hero = nPlayer:GetAssignedHero()
    local count_1 = 0
    local count_2 = 0
    local count_3 = 0
    local count_4 = 0
    local count_5 = 0
    for key, value in pairs(totem_data["totem"]) do
        if string.match(key, "Level")then
            if value >= 10 then
                count_1 = count_1 + 1
            end
            if value >= 20 then
                count_2 = count_2 + 1
            end
            if value >= 30 then
                count_3 = count_3 + 1
            end
            if value >= 40 then
                count_4 = count_4 + 1
            end
            if value >= 50 then
                count_5 = count_5 + 1
            end
        end
    end
    local add_properties = 0
    if count_1 >= 12 then
        -- body
        add_properties = add_properties + 20
    end
    if count_2 >= 12 then
        -- body
        add_properties = add_properties + 50
    end
    if count_3 >= 12 then
        -- body
        add_properties = add_properties + 100
    end
    if count_4 >= 12 then
        -- body
        add_properties = add_properties + 200
    end
    if count_5 >= 12 then
        -- body
        add_properties = add_properties + 500
    end

    hero:SetBaseStrength(hero:GetBaseStrength() + add_properties)
    hero:SetBaseAgility(hero:GetBaseAgility() + add_properties)
    hero:SetBaseIntellect(hero:GetBaseIntellect() + add_properties)
    
    self:set_dynamic_properties(steam_id, "maxlevel_totem", -(self:get_dynamic_properties_by_key(steam_id, "maxlevel_totem")))
    self:set_dynamic_properties(steam_id, "maxlevel_totem", add_properties)
end
--  地图经验更新
function game_playerinfo:update_map_exp(steam_id, exp)
    if not player_info[steam_id].mapExp then
        player_info[steam_id].mapExp = 0
    end
    local mapExp = player_info[steam_id].mapExp
    player_info[steam_id].mapExp = mapExp + exp

    self:update_map_level(steam_id)

    return player_info[steam_id].mapExp
end

--  地图等级更新
function game_playerinfo:update_map_level(steam_id)
    if not player_info[steam_id].mapLevel then
        player_info[steam_id].mapLevel = 0
    end
    local mapLevel = player_info[steam_id].mapLevel

    local lvup_need_exp = need_exp[mapLevel+1]
    if player_info[steam_id].mapExp >= lvup_need_exp then
        player_info[steam_id].mapLevel = player_info[steam_id].mapLevel + 1
    end

    return player_info[steam_id].mapLevel
end

--  获取当前通关难度
function game_playerinfo:get_pass_level(steam_id)
    if not player_info[steam_id].passLevel then
        player_info[steam_id].passLevel = 0
    end
    return player_info[steam_id].passLevel
end

--  通关难度更新
function game_playerinfo:update_pass_level(steam_id)
    if not player_info[steam_id].passLevel then
        player_info[steam_id].passLevel = 0
    end
    local map_Difficulty = GameRules:GetCustomGameDifficulty()
    if map_Difficulty > player_info[steam_id].passLevel then
        player_info[steam_id].passLevel = player_info[steam_id].passLevel + 1
    end
    return player_info[steam_id].passLevel
end

--  英雄经验更新
function game_playerinfo:update_hero_exp(steam_id, hero_index, exp)
    if not player_info[steam_id].hero_exp then
        player_info[steam_id].hero_exp = {}
    end
    local hero_exp = player_info[steam_id].hero_exp[hero_index]
    player_info[steam_id].hero_exp[hero_index] = hero_exp + exp

    self:update_hero_level(steam_id,hero_index)

    return player_info[steam_id].hero_exp[hero_index]
end

--  英雄等级更新
function game_playerinfo:update_hero_level(steam_id, hero_index)
    if not player_info[steam_id].hero_level then
        player_info[steam_id].hero_level = {}
    end
    local hero_level = player_info[steam_id].hero_level[hero_index]
    local lvup_need_exp = need_exp[hero_level+1]
    if player_info[steam_id].hero_exp[hero_index] >= lvup_need_exp then
        player_info[steam_id].hero_level[hero_index] = player_info[steam_id].hero_level[hero_index] + 1
    end
    return player_info[steam_id].hero_level[hero_index]
end

--  全局经验更新
function game_playerinfo:update_universal_exp(steam_id, exp)
    if not player_info[steam_id]["universalExp"] then
        player_info[steam_id]["universalExp"] = 0
    end
    player_info[steam_id]["universalExp"] = player_info[steam_id]["universalExp"] + exp
    if exp > 0 then
        player_info[steam_id]["allUniversalExp"] = player_info[steam_id]["allUniversalExp"] + exp
    end
    return player_info[steam_id]["universalExp"]
end

--  英雄可用经验更新
function game_playerinfo:update_useHeroExp(steam_id, exp)
    if not player_info[steam_id]["useHeroExp"] then
        player_info[steam_id]["useHeroExp"] = 0
    end
    player_info[steam_id]["useHeroExp"] = player_info[steam_id]["useHeroExp"] + exp
    
    return player_info[steam_id]["useHeroExp"]
end

--  遗物经验更新
function game_playerinfo:update_relicsExp(steam_id, exp)
    if not player_info[steam_id]["relicsExp"] then
        player_info[steam_id]["relicsExp"] = 0
    end
    player_info[steam_id]["relicsExp"] = player_info[steam_id]["relicsExp"] + exp
    
    return player_info[steam_id]["relicsExp"]
end

--  宝物碎片数量更新
function game_playerinfo:update_chipNumber(steam_id, number)
    if not player_info[steam_id]["chipNumber"] then
        player_info[steam_id]["chipNumber"] = 0
    end
    player_info[steam_id]["chipNumber"] = player_info[steam_id]["chipNumber"] + number
    
    return player_info[steam_id]["chipNumber"]
end

--  获取宝物碎片数量
function game_playerinfo:get_chipNumber(steam_id)
    if not player_info[steam_id]["chipNumber"] then
        player_info[steam_id]["chipNumber"] = 0
    end
    return player_info[steam_id]["chipNumber"]
end

--  领取补偿
function game_playerinfo:get_compensation(player_id)
    local steam_id = PlayerResource:GetSteamAccountID(player_id)
    if player_info[steam_id]["compensationLevel"] then
        -- print(" >>>>>>>>>>>>>>>>> compensationLevel: "..(player_info[steam_id]["compensationLevel"]+1))
        -- print(" >>>>>>>>>>>>>>>>> COMPENSATION: "..(global_var_func:GloFunc_Getgame_enum().COMPENSATION))
        for i = player_info[steam_id]["compensationLevel"]+1, global_var_func:GloFunc_Getgame_enum().COMPENSATION do
            -- print(" >>>>>>>>>> i: "..i)
            for key, value in pairs(global_var_func.compensation[i]) do
                -- print(" >>>>>>>>>> key: "..key)
                -- print(" >>>>>>>>>> value: "..value)
                if key=="universalExp" then
                    -- 补偿通用经验
                    player_info[steam_id][key] = player_info[steam_id][key] + value
                    player_info[steam_id]["allUniversalExp"] = player_info[steam_id]["allUniversalExp"] + value
                elseif key=="score" then
                    -- 补偿钻石
                    game_playerinfo:update_score(player_id, value)
                end
            end
        end
        player_info[steam_id]["compensationLevel"] = global_var_func:GloFunc_Getgame_enum().COMPENSATION
        game_playerinfo:save_compensationLevel(player_id)
    end
end

-- 升级英雄
function game_playerinfo:levelup_hero(playerID, hero_index)
    local steam_id = PlayerResource:GetSteamAccountID(playerID)
    if not player_info[steam_id].heroes[hero_index].heroLevel then
        player_info[steam_id].heroes[hero_index].heroLevel = 0
    end
    local hero_level = player_info[steam_id].heroes[hero_index].heroLevel
    local lvup_need_exp = need_exp[hero_level+1]
    if lvup_need_exp > game_playerinfo:get_universal_exp(steam_id) or hero_level >= global_var_func:GloFunc_Getgame_enum().MAX_HERO_LEVEL then
        return false
    end
    -- print(" >>>>>>>>>>>lvup_need_exp: "..lvup_need_exp)
    -- print(" >>>>>>>>>>>get_universal_exp: "..game_playerinfo:get_universal_exp(steam_id))
    player_info[steam_id].heroes[hero_index].heroLevel = player_info[steam_id].heroes[hero_index].heroLevel + 1
    game_playerinfo:update_universal_exp(steam_id, -lvup_need_exp)
    self:save_archiveby_playerid(playerID)
    return true
end

--  对比存档英雄数量和配置英雄数量是否对等,如超出,则添加数据补齐.数据自适应
function game_playerinfo:check_hero_number(hero_exp)
    if #hero_exp < #CustomHeroList then
        for i = 1, (#CustomHeroList-#hero_exp) do
            table.insert(hero_exp, 0)
        end
    end
end

function game_playerinfo:check_hero_level(hero_level)
    if #hero_level < #CustomHeroList then
        for i = 1, (#CustomHeroList-#hero_level) do
            table.insert(hero_level, 0)
        end
    end
end

function game_playerinfo:get_player_info()
    return player_info
end

--获取碎片信息
function game_playerinfo:get_equipment_data(steam_id)
    return player_equipment_data[steam_id]
end

--更新碎片信息
-- function game_playerinfo:updata_bead_data(steam_id,item_name,hero)
--     if not game_playerinfo:get_equipment_data(steam_id) then
--         player_equipment_data[steam_id] = {}
--     end
--     if game_playerinfo:get_equipment_data(steam_id)[item_name] then 
--         game_playerinfo:get_equipment_data(steam_id)[item_name] = game_playerinfo:get_equipment_data(steam_id)[item_name] + 1
--     else
--         player_equipment_data[steam_id][item_name] = 1
--     end
--     CustomNetTables:SetTableValue("player_data_table","player_"..hero:GetPlayerID(),player_equipment_data[steam_id])
--     common_item_ability:refresh_dynamic_properties(hero,item_name)
-- end

-- 获取玩家木头数量
function game_playerinfo:get_player_wood(player_id)
    -- local player_wood =  CustomNetTables:GetTableValue("wood_table","wood_table")["wood_"..player_id]
    -- if player_wood == nil then
    --     game_playerinfo:change_player_wood(hero, change_num)
    -- end
    return CustomNetTables:GetTableValue("wood_table","wood_table")["wood_"..player_id]
end

-- 修改玩家木头数量
function game_playerinfo:change_player_wood(hero, change_num)
    -- local wood_num = 0
    -- if hero.wood_num then
    --     wood_num = hero.wood_num 
    -- end
    -- wood_num = wood_num + change_num
    -- hero.wood_num = wood_num
    local wood_key = "wood_"..hero:GetPlayerID()
    local wood_net_table = CustomNetTables:GetTableValue("wood_table","wood_table")
    if not wood_net_table then
        wood_net_table = {}
    end
    wood_net_table[wood_key] = wood_net_table[wood_key] + change_num
    CustomNetTables:SetTableValue("wood_table","wood_table",wood_net_table)
    return wood_num
end

--获取玩家金币
function game_playerinfo:get_player_gold(player_id)
    if player_id then 
        local table_key = "gold_"..player_id
        local gold_table = CustomNetTables:GetTableValue("gold_table",table_key)
        return gold_table[table_key] or 0
    end
end

local player_gold_gain = {
    -- [player_id] = 213123123123,
}
--设置玩家金币
function game_playerinfo:set_player_gold(player_id,value)
    if not value then
        value = 0
    end
    if player_id then 
        local hero = PlayerResource:GetPlayer(player_id):GetAssignedHero()
        -- 玩家在拥有对应宝物的情况下,不到条件没有金币收益
        if value > 0 then
            local treasure = hero:FindModifierByName("modifier_treasure_nenglipengzhang")
            if treasure then
                if treasure:GetStackCount() < 1000 then
                    return
                end
            end
            -- 获取金钱
            hero:EmitSound("coins_big")
            -- if not hero:HasModifier("modifier_sale_lua") then
            --     -- 没有steam的打折天赋
            --     print(" >>>>>>>>>>>>>>>>> no steam ")
                local goldscale = game_playerinfo:get_dynamic_properties(PlayerResource:GetSteamAccountID(player_id)).gold_scale*0.01
                if hero:HasModifier("modifier_sale_lua") then
                    if goldscale > 1.3 then
                        goldscale = 1.3
                    end
                end
                value = value * (1+goldscale)
            -- end
        end
        if value < 0 then
            if hero:HasModifier("modifier_treasure_no_number") then
                value = value * 0.8
            end
        end
        
        local table_key = "gold_"..player_id
        local gold_table = CustomNetTables:GetTableValue("gold_table",table_key)
        gold_table[table_key] = math.ceil(gold_table[table_key] + value)
        CustomNetTables:SetTableValue("gold_table",table_key,gold_table)

        -- 记录玩家收益
        if value > 0 then
            if not player_gold_gain[player_id] then
                player_gold_gain[player_id] = 0
            end
            player_gold_gain[player_id] = player_gold_gain[player_id] + value
        end
    end
end

function game_playerinfo:getplayer_gold_gain(player_id)
    return player_gold_gain[player_id] or 0
end

--设置物品冷却
function game_playerinfo:set_item_cool_down(player_id,item_name)    
    if player_id then
        -- if string.find(item_name,"_call") then
        --     local table_key = item_name.."_"..player_id
        --     local bossCD = CustomNetTables:GetTableValue("boss_cool_down","boss_cool_down")
        --     bossCD[table_key] = global_var_func[item_name]
        --     CustomNetTables:SetTableValue("boss_cool_down","boss_cool_down",bossCD)
        -- else
        --     local cd =  global_var_func.shop_item_init[item_name][3]
        --     if cd > 0 then
        --         global_var_func.shop_item_cooldown["player"..player_id][item_name] = cd
        --     end
            
        -- end
        local cd =global_var_func.player_shop_item["player"..player_id][item_name][3]   
        -- local cd2 =global_var_func.shop_item_init[item_name][3]
        -- print(cd.."----"..cd2)
        if cd > 0 then
            global_var_func.shop_item_cooldown["player"..player_id][item_name] = cd
        end
    end
end

--获取boss冷却表
function game_playerinfo:get_boss_cool_down()
    return CustomNetTables:GetTableValue("boss_cool_down","boss_cool_down")
end


function game_playerinfo:random_properties(playerKey)
    -- local index = RandomInt(1,#random_properties)
    -- return random_properties[index]
    -- return {"call_shadow",1}
    local pool = global_var_func.player_random_properties[playerKey]
    local randomPool
    local getProperty
    local chance = RandomInt(0, 100)
    local index
    local level 
    if 0 <= chance and chance < 10 then 
        index = RandomInt(1, #pool["pool1"])
        randomPool = pool.pool1[index]
        level = 1
        table.remove(pool.pool1, index)
    elseif 10 <= chance and chance < 40 then
        index = RandomInt(1, #pool["pool2"])
        randomPool = pool.pool2[index]
        level = 2
        table.remove(pool.pool2, index)
    elseif 40 <= chance and chance <= 100 then
        index = RandomInt(1, #pool["pool3"])
        randomPool = pool.pool3[index]
        level =3
        table.remove(pool.pool3, index)
    end
    if randomPool == nil then
        return nil
    end
    return {[level] = randomPool}
end


-- 玩家通关奖励累计
local player_result = {
    -- [steam_id] = {
    --     ["heroLevel"] = 1,
    --     ["heroNowExp"] = 1,
    --     ["heroExp"] = 1,     本轮获取的英雄经验
    --     ["mapLevel"] = 1,
    --     ["mapNowExp"] = 1,   
    --     ["mapExp"] = 1,      本轮获取的地图经验
    --     ["score"] = 15,
    --     ["universalExp"] = 1,    本轮获取的通用经验
    --     ["relicsExp"] = 1,    本轮获取的神之遗物
    -- }
}

function game_playerinfo:change_player_result(steam_id, key, value)
    if not player_result[steam_id] then
        player_result[steam_id] = {}
    end
    if not player_result[steam_id][key] then
        -- body
        player_result[steam_id][key] = value
    else
        player_result[steam_id][key] = player_result[steam_id][key] + value
    end
end

function game_playerinfo:get_player_result(steam_id)
    if not player_result[steam_id] then
        player_result[steam_id] = {}
    end
    return player_result[steam_id]
end


-- 玩家各类统计
local player_data_statistics = {
    -- [playerid] = {
    --     ["damage"] = 0,
    --     ["economic"] = 0,
    -- }
}

-- 初始化玩家统计表
function game_playerinfo:init_statistics()
    for i=1, 4 do
        player_data_statistics[i] = {}
    end
end

-- 玩家的本局伤害数值
function game_playerinfo:update_player_damage(player_id, damage)
    if not player_data_statistics[player_id].damage then
        player_data_statistics[player_id].damage = 0
    end
    player_data_statistics[player_id].damage = player_data_statistics[player_id].damage + damage
end

function game_playerinfo:get_player_damage(player_id)
    if not player_data_statistics[player_id] then
        player_data_statistics[player_id] = {}
    end
    return player_data_statistics[player_id].damage
end

-- 玩家的本局经济收益
function game_playerinfo:update_player_economic(player_id, economic)
    if not player_data_statistics[player_id].economic then
        player_data_statistics[player_id].economic = 0
    end
    player_data_statistics[player_id].economic = player_data_statistics[player_id].economic + economic
end

function game_playerinfo:get_player_economic(player_id)
    if not player_data_statistics[player_id] then
        player_data_statistics[player_id] = {}
    end
    return player_data_statistics[player_id].economic
end


local Random_treasure_list  = {
    "gem_break_then_set_lua",
    "gem_poison_the_rose_lua",
    "gem_zuizhongzhijian_lua",
    "gem_xunjizhijian_lua",
    "gem_shixue_lua",
    "gem_xuyuanshi_lua",
    "gem_sishen_liandao_lua",
    "gem_time_sword_lua",
    "gem_xueshiyuanbo_lua",
    "gem_power_source_lua",
    "gem_arrow_of_aeolus",
    "gem_bow_of_aeolus",
    "gem_god_left_hand",
    "gem_god_right_hand",
    "gem_blacksmith_left_wristbands",
    "gem_blacksmith_right_wristbands",
    "gem_chainmail",
    "gem_platemail",
    "gem_qicai_shi",
    "gem_gold_shi",
    "gem_shuangren_fu",
    "gem_huiguang_fu",
    "gem_budao_fu",
    "gem_archon_passive_shadow_quiet",
    "gem_archon_passive_earth_burst",
    "gem_archon_passive_raging_fire_interrogate",
    "gem_archon_passive_die_venom",
    "gem_archon_passive_void_lock",
    "gem_archon_passive_Ice_storm",
    "gem_one_two_three",
  }

-- 玩家抽取的宝物数据
local treasure_select_tab = {

}

function game_playerinfo:init_treasure_select_tab(player_id)
    if not treasure_select_tab[player_id] then
        treasure_select_tab[player_id] = {}
        for key, value in ipairs(Random_treasure_list) do
            table.insert(treasure_select_tab[player_id], value)
        end
    end
end

function game_playerinfo:random_treasure(player_id)
    local result_tab = {}
    if not treasure_select_tab[player_id] then
        return result_tab
    end
    
    local random_select_tab = deepcopy(treasure_select_tab[player_id])
    
    local randindex1 = RandomInt(1, #random_select_tab)
    table.insert(result_tab, random_select_tab[randindex1])
    table.remove(random_select_tab, randindex1)

    local randindex2 = RandomInt(1, #random_select_tab)
    table.insert(result_tab, random_select_tab[randindex2])
    table.remove(random_select_tab, randindex2)

    local randindex3 = RandomInt(1, #random_select_tab)
    table.insert(result_tab, random_select_tab[randindex3])
    table.remove(random_select_tab, randindex3)

    return result_tab
end

function game_playerinfo:remove_treasure(player_id, treasurename)
    for key, value in pairs(treasure_select_tab[player_id]) do
        if value == treasurename then
            table.remove(treasure_select_tab[player_id], key)
            return
        end
    end
end

function game_playerinfo:find_treasure(player_id, treasurename)
    for key, value in pairs(treasure_select_tab[player_id]) do
        if value == treasurename then
            return true
        end
    end
    return false
end

-- 玩家装备缓存
local player_equipment_tab = {
    -- [1] = {
    --     name1,name2,name3,
    -- },
    -- [2] = {
    --     name1,name2,name3,
    -- },
    -- [3] = {
    --     name1,name2,name3,
    -- },
    -- [4] = {
    --     name1,name2,name3,
    -- },
}

function game_playerinfo:add_heroquipment(hero, equipment_name)
    local playerID = hero:GetPlayerID()
    if not player_equipment_tab[playerID] then
        player_equipment_tab[playerID] = {}
    end
    table.insert(player_equipment_tab[playerID], equipment_name)
end

function game_playerinfo:get_heroquipment(playerID)
    if not player_equipment_tab[playerID] then
        player_equipment_tab[playerID] = {}
    end
    return player_equipment_tab[playerID]
end

function game_playerinfo:resetquipmentname(playerID, lastname, newname)
    if not player_equipment_tab[playerID] then
        return
    end
    local changekey = 0
    for key, value in pairs(player_equipment_tab[playerID]) do
        if lastname==value then
            changekey = key
            break
        end
    end
    if changekey~=0 then
        player_equipment_tab[playerID][changekey] = newname
    end
end

-- 输入验证码
function game_playerinfo:OnWriteTestPassword(data)
    local player_id = data.PlayerID
    local code = data.code
    Service:WriteTestPassword(player_id, code)
end

function game_playerinfo:CheckPlayerIsEnterGame(nPlayerID)
    local nSteamID = PlayerResource:GetSteamAccountID(nPlayerID)
    local verification = self:get_player_info()[nSteamID].verification
    -- print(">>>>>>>>>>>>> verification: "..verification)
    if verification == 0 then
        self:showTestPaswordUI(nPlayerID)
    else
        self:closeTestPaswordUI(nPlayerID)
    end
    if global_var_func.end_load >= global_var_func.all_player_amount then
        self:closeLoadingUI()
    end
    -- CustomGameEventManager:Send_ServerToPlayer(PlayerResource:GetPlayer(nPlayerID), "show_game_level_ui",{ level = GameRules:GetCustomGameDifficulty(), passlevel = self:get_pass_level(nSteamID) + 1})
end
-- 弹窗输入验证码
function game_playerinfo:showTestPaswordUI(nPlayerID)
    CustomGameEventManager:Send_ServerToPlayer(PlayerResource:GetPlayer(nPlayerID), "show_game_level_ui",{})
end
-- 关闭验验证码界面
function game_playerinfo:closeTestPaswordUI(nPlayerID)
    local isclose = 1
    for key,value in pairs(player_info) do
        if value.verification == 0 then
            isclose = 0
            break;
        end
    end
    CustomGameEventManager:Send_ServerToPlayer(PlayerResource:GetPlayer(nPlayerID), "response_close_passwordui",{isclose = isclose})
end

-- 关闭loading界面
function game_playerinfo:closeLoadingUI()
    local passLeveltable = {}
    for i = 0, global_var_func.all_player_amount-1 do
        local nSteamID = PlayerResource:GetSteamAccountID(i)
        local passLevel = self:get_pass_level(nSteamID) + 1
        table.insert(passLeveltable, passLevel)
    end
    CustomGameEventManager:Send_ServerToAllClients("response_close_loading",{level = GameRules:GetCustomGameDifficulty(), passlevel = passLeveltable})
end

build_record = {

}


-------------------------------------------- 玩家商城相关 ------------------------------------------------


-- local player_store = {
--     -- [1123123414] = {
--     --     ["score"] = 0,
--     --     ["coin"] = 0,
--     --     ["vip_1"] = 0,
--     --     ["vip_2"] = 0,
--     --     ["vip_3"] = 0,
--     --     ["vip_4"] = 0,
--     -- }
-- }

-- -- 移除玩家商城道具
-- function game_playerinfo:RemoveStoreItem(steam_id, GoodsName, number)
--     if player_store[steam_id][GoodsName] then
--         if player_store[steam_id][GoodsName] > number then
--             player_store[steam_id][GoodsName] = player_store[steam_id][GoodsName] - number
--         elseif player_store[steam_id][GoodsName] == number then
--             player_store[steam_id][GoodsName] = nil
--         end
--     end
-- end

-- -- 
-- function game_playerinfo:RemoveStoreItem(steam_id, GoodsName, number)
--     if player_store[steam_id][GoodsName] then
--         if player_store[steam_id][GoodsName] > number then
--             player_store[steam_id][GoodsName] = player_store[steam_id][GoodsName] - number
--         elseif player_store[steam_id][GoodsName] == number then
--             player_store[steam_id][GoodsName] = nil
--         end
--     end
-- end

-- 查找对应玩家是否有这个商城道具
function game_playerinfo:FindGoodsByID(steam_id, GoodsName, number)
	local result = false
	local goods_list = player_store[steam_id]
	for key, value in pairs(goods_list) do
		if key == GoodsName and value >= number then
			result = true
			break;
		end
	end
	return result
end

-- 响应商城道具使用
function game_playerinfo:OnUsedShopGoods(data)
    local args = {}
    args.PlayerID = data.PlayerID
    args.GoodsName = data.GoodsName
    args.UseNumber = data.UseNumber
    if args.UseNumber <= 0 then
        -- body
        return
    end
    if global_var_func.useGoodsLock[args.PlayerID + 1] then
		return
	end
	global_var_func.useGoodsLock[args.PlayerID + 1] = true
    local steam_id = PlayerResource:GetSteamAccountID(args.PlayerID)
    if not game_playerinfo:FindGoodsByID(steam_id, args.GoodsName, args.UseNumber) then
        CustomGameEventManager:Send_ServerToPlayer(PlayerResource:GetPlayer(args.PlayerID),"response_errortext",{errortext = "error_noenoughnumber"})
        return
    end
    args.AddItemKey, args.prize_list = game_playerinfo:UseGoodsByID(data.PlayerID,data.GoodsName,data.UseNumber)
    -- DeepPrintTable(args)
    Store:UsedGoods(args)
end

-- 开启宝箱
function game_playerinfo:OnOpenBox(data)
    local args = {}
    args.PlayerID = data.PlayerID
    args.GoodsName = "Sand_sea_pursuit"
    args.UseNumber = data.UseNumber
    args.prize_list = {}
    if global_var_func.useGoodsLock[args.PlayerID + 1] then
		return
	end
	global_var_func.useGoodsLock[args.PlayerID + 1] = true
    local single = true
    if args.UseNumber == 10 then
        single = false
        args.UseNumber = 9
    end
    local steam_id = PlayerResource:GetSteamAccountID(args.PlayerID)
    if not game_playerinfo:FindGoodsByID(steam_id, args.GoodsName, args.UseNumber) then
        CustomGameEventManager:Send_ServerToPlayer(PlayerResource:GetPlayer(args.PlayerID),"response_errortext",{errortext = "error_noenoughnumber"})
        return
    end
    args.AddItemKey = useSandseapursuit(args.PlayerID, args.prize_list, single)
    
    Store:UsedGoods(args)
    game_playerinfo:save_rewardsby_playerid(args.PlayerID)
    game_playerinfo:save_totem(args.PlayerID)
end

-- 领取通关奖励
function game_playerinfo:OnCollectRewards(data)
    local args = {}
    args.PlayerID = data.PlayerID
    args.difficulty = data.difficulty
    args.GoodsName = "0"
    args.UseNumber = 0
    args.AddItemKey, args.prize_list = game_playerinfo:ReceivePassLevelRewards(args.PlayerID, args.difficulty)
    -- if (not args.AddItemKey) or (not args.prize_list) then
    --     return
    -- end
    local nSteamID = PlayerResource:GetSteamAccountID(args.PlayerID)
    -- DeepPrintTable(args)
    if #args.AddItemKey > 0 then
        Store:UsedGoods(args)
    else
        CustomGameEventManager:Send_ServerToPlayer(PlayerResource:GetPlayer(args.PlayerID),"UseItemCallback",{levelRewardsList = game_playerinfo:GetLevelRewardsSign(nSteamID), prize_list = args.prize_list})
    end
    -- local ArchiveTable = {
    --     "levelRewardsLists",
    -- }
    -- game_playerinfo:SaveArchiveTable(args.PlayerID, ArchiveTable)
    -- 钻石
    game_playerinfo:save_storecoinby_playerid(args.PlayerID, args.prize_list)
    -- 奖励神之遗物经验
    -- 奖励图腾碎片
    -- 奖励宝物卡
    game_playerinfo:save_rewardsby_playerid(args.PlayerID)
    game_playerinfo:save_totem(args.PlayerID)
end

-- 领取月卡奖励
function game_playerinfo:OnMonthcardRewards(data)
    local args = {}
    args.PlayerID = data.PlayerID
    local steam_id = PlayerResource:GetSteamAccountID(args.PlayerID)
    local playerinfo = game_playerinfo:get_player_info()[steam_id]
    if playerinfo["getMonthCard"] ~= 1 then
        CustomGameEventManager:Send_ServerToPlayer(PlayerResource:GetPlayer(args.PlayerID),"response_errortext",{errortext = "error_noMonthcardRewards"})
        return
    end
    playerinfo["getMonthCard"] = 0
    Account:AddCustomCoinValue(args.PlayerID,3,0)
    CustomGameEventManager:Send_ServerToPlayer(PlayerResource:GetPlayer(args.PlayerID),"response_monthcard_rewards",{})
end

-- 地图等级奖励表
local map_rewards = {
    1000,
    3000,
    7000,
    13000,
    21000,
    31000,
    43000,
    57000,
    73000,
    91000,
    111000,
    133000,
    157000,
    183000,
    211000,
    241000,
    273000,
    307000,
    343000,
    381000,
    421000,
    463000,
    507000,
    553000,
    601000,
    651000,
    703000,
    757000,
    813000,
    871000,
    931000,
    993000,
    1057000,
    1123000,
    1191000,
    1261000,
    1333000,
    1407000,
    1483000,
    1561000,
}
-- 领取地图等级奖励
function game_playerinfo:OnMaplevelRewards(data)
    
    local PlayerID = data.PlayerID
    
    local prize_list = game_playerinfo:ReceiveMapLevelRewards(PlayerID)
    if not prize_list then
        -- body
        return
    end
    local nSteamID = PlayerResource:GetSteamAccountID(PlayerID)
    
    CustomGameEventManager:Send_ServerToPlayer(PlayerResource:GetPlayer(PlayerID),"UseItemCallback",{mapRewardsList = game_playerinfo:GetmapRewardsCount(nSteamID), prize_list = prize_list})
    
    game_playerinfo:save_storecoinby_playerid(PlayerID, prize_list)

    local ArchiveTable = {
        "mapRewardsCount",
    }
    game_playerinfo:SaveArchiveTable(PlayerID, ArchiveTable)

    Archive:SaveProfileByID(PlayerID)
    -- end
end

-- 道具回滚
function game_playerinfo:RollBackBagItem(nPlayerID,prize_list)
    local steam_id = global_var_func.player_base_info[nPlayerID].steam_id
    for key, value in pairs(prize_list) do
        if value[1] == "universalExp" then
            game_playerinfo:update_universal_exp(steam_id, -value[2])
        elseif value[1] == "useHeroExp" then
            game_playerinfo:update_useHeroExp(steam_id, -value[2])
        elseif value[1] == "relics_Amount" then
            game_playerinfo:update_relicsExp(steam_id, -value[2])
        elseif string.match(value[1], "totem") then
            game_playerinfo:update_totem_data(steam_id, value[1], -value[2])
        else
            local treasurIndex = treasuresystem:get_treasure_id(value[1])
            treasuresystem:update_treasureinarchive_byID(nPlayerID, treasurIndex, -value[2])
        end
    end
end
-- 使用道具
function game_playerinfo:UseGoodsByID(nPlayerID,GoodsName,number)
    local steam_id = PlayerResource:GetSteamAccountID(nPlayerID)
    local useNumber = number
    if GoodsName == "Sand_sea_pursuit" then
        if number == 10 then
            useNumber = 9
        end
    end
    if not game_playerinfo:FindGoodsByID(steam_id, GoodsName, useNumber) then
        CustomGameEventManager:Send_ServerToPlayer(PlayerResource:GetPlayer(nPlayerID),"response_errortext",{errortext = "error_noenoughnumber"})
        return
    end
	-- 奖励数据,发送给客户端显示
	local prize_list = {
		-- {"name", 123123,},
		-- {"name", 123123,},
		-- {"name", 123123,},
    }
    -- 奖励的商城物品
    local store_item = {}
	-- if GoodsName == "Sand_sea_pursuit" then
    --     -- 沙海寻踪礼包
    --     local single = true
    --     if number == 10 then
    --         single = false
    --     end
    --     store_item = useSandseapursuit(nPlayerID, prize_list, single)

    -- else
    if GoodsName == "Novice_benefits" then
		-- 新手10连礼包
        useNovicebenefits(nPlayerID, prize_list, store_item)
        
    elseif GoodsName == "Experience_double_card_30_days" then
        -- 经验双倍卡（30天）
        store_item = useExperiencedoublecard30days(nPlayerID, prize_list, number)

    elseif GoodsName == "Gift_pack_for_novice_hero" then
        -- 新手英雄助力礼包
        store_item = useGiftpackfornovicehero(nPlayerID, prize_list)

    elseif GoodsName == "Gift_bag_with_Gods_relic" then
        -- 神之遗物助力礼包
        store_item = useGiftbagwithGodsrelic(nPlayerID, prize_list)
    elseif GoodsName == "newyear_bag" then
        -- 新春礼包
        store_item = usenewyearBag(nPlayerID, prize_list, useNumber)
    elseif GoodsName == "bignewyear_bag" then
        -- 拜年大礼包
        useBignewyearBag(nPlayerID, prize_list, store_item)
    elseif GoodsName == "wangzhe_bag" then
        -- 王者大礼包
        useWangZheBag(nPlayerID, prize_list)
    -- elseif GoodsName == "The_gift_of_the_Pharaoh_1" then
    --     -- 恩赐 1
    --     store_item = onceTheGiftOfThePharaoh(nPlayerID, 1, prize_list)
    -- elseif GoodsName == "The_gift_of_the_Pharaoh_2" then
    --     -- 恩赐 2
    --     store_item = onceTheGiftOfThePharaoh(nPlayerID, 2, prize_list)
    -- elseif GoodsName == "The_gift_of_the_Pharaoh_3" then
    --     -- 恩赐 3
    --     store_item = onceTheGiftOfThePharaoh(nPlayerID, 3, prize_list)
    -- elseif GoodsName == "The_gift_of_the_Pharaoh_4" then
    --     -- 恩赐 4
    --     store_item = onceTheGiftOfThePharaoh(nPlayerID, 4, prize_list)
    -- elseif GoodsName == "The_gift_of_the_Pharaoh_5" then
    --     -- 恩赐 5
    --     store_item = onceTheGiftOfThePharaoh(nPlayerID, 5, prize_list)
    -- elseif GoodsName == "The_gift_of_the_Pharaoh_6" then
    --     -- 恩赐 6
    --     store_item = onceTheGiftOfThePharaoh(nPlayerID, 6, prize_list)
    -- elseif GoodsName == "The_gift_of_the_Pharaoh_7" then
    --     -- 恩赐 7
    --     store_item = onceTheGiftOfThePharaoh(nPlayerID, 7, prize_list)
    end

    -- -- 消耗对应道具数量
	-- if #prize_list > 0 then
	-- 	CustomGameEventManager:Send_ServerToPlayer(PlayerResource:GetPlayer(nPlayerID), "response_used_gift_bag",prize_list)
    -- end
    return store_item, prize_list
end

-- 领取通关奖励
function game_playerinfo:ReceivePassLevelRewards(nPlayerID, level)
    local steam_id = PlayerResource:GetSteamAccountID(nPlayerID)
    if not player_info[steam_id]["levelRewardsLists"] then
        player_info[steam_id]["levelRewardsLists"] = {0,0,0,0,0,0,0,0,0,0,10}
    end
    if not player_info[steam_id]["levelRewardsLists"][11] then
        player_info[steam_id]["levelRewardsLists"][11] = 10
    end

    if level <= 10 then
        -- body
        if player_info[steam_id]["levelRewardsLists"][level] == 1 then
            return
        end
    else
        if player_info[steam_id]["levelRewardsLists"][11] >= level then
            return
        end
    end
    
    -- 奖励数据,发送给客户端显示
	local prize_list = {
		-- {"name", 123123,},
		-- {"name", 123123,},
		-- {"name", 123123,},
    }
    -- 奖励的商城物品
    local store_item = {}

    store_item = onceTheGiftOfThePharaoh(nPlayerID, level, prize_list)

    return store_item, prize_list
end

-- 领取地图等级奖励
function game_playerinfo:ReceiveMapLevelRewards(nPlayerID)
    local steam_id = PlayerResource:GetSteamAccountID(nPlayerID)

    if player_info[steam_id]["mapRewardsCount"] >= player_info[steam_id]["mapLevel"] then
        return nil
    end
    -- 奖励数据,发送给客户端显示
	local prize_list = {
		-- {"name", 123123,},
		-- {"name", 123123,},
		-- {"name", 123123,},
    }
    -- 奖励的商城物品

    usemapRewards(nPlayerID, player_info[steam_id]["mapRewardsCount"]+1, prize_list)

    return prize_list
end

-- 使用沙海寻踪礼包
function useSandseapursuit(playerID, prize_list, single)
    local store_item = {}
    local steam_id = PlayerResource:GetSteamAccountID(playerID)
    local number = 1
    if not single then
        -- 10连
        number = 9
        -- 获得图腾包的奖励
        game_playerinfo:essentialtotempackage(steam_id, prize_list)
    else
        -- 单抽
        local player_info = game_playerinfo:get_player_info()[steam_id]
        if not player_info["onceBoxNumber"] then
            player_info["onceBoxNumber"] = 0
        end
        if player_info["onceBoxNumber"] == 9 then
            -- 获得图腾包的奖励
            game_playerinfo:essentialtotempackage(steam_id, prize_list)
            player_info["onceBoxNumber"] = 0
            return store_item
        else
            player_info["onceBoxNumber"] = player_info["onceBoxNumber"] + 1
        end
    end
	for i=1, number do
		local randint = RandomInt(1, 10000)
        if 0 < randint and randint <= 1000 then
			-- 钻石
			local Diamond = RandomInt(15000, 25000)
            
            local sendtable = {}
            table.insert(sendtable, "score")
            table.insert(sendtable, Diamond)
            local extra_relicsExp = RandomInt(15, 28)
            game_playerinfo:update_relicsExp(steam_id, extra_relicsExp)
            table.insert(sendtable, extra_relicsExp)

            table.insert(prize_list, sendtable)
            game_playerinfo:change_player_result(steam_id, "score", Diamond)
            game_playerinfo:update_score(playerID, Diamond)
		elseif 1000 < randint and randint <= 1500 then
			-- 
			local Diamond = RandomInt(80000, 120000)
            
            local sendtable = {}
            table.insert(sendtable, "score")
            table.insert(sendtable, Diamond)
            local extra_relicsExp = RandomInt(15, 28)
            game_playerinfo:update_relicsExp(steam_id, extra_relicsExp)
            table.insert(sendtable, extra_relicsExp)

            table.insert(prize_list, sendtable)
            game_playerinfo:change_player_result(steam_id, "score", Diamond)
            game_playerinfo:update_score(playerID, Diamond)
		elseif 1500 < randint and randint <= 1501 then
			-- 大量钻石
			local Diamond = 1000000
            
            local sendtable = {}
            table.insert(sendtable, "score")
            table.insert(sendtable, Diamond)
            local extra_relicsExp = RandomInt(15, 28)
            game_playerinfo:update_relicsExp(steam_id, extra_relicsExp)
            table.insert(sendtable, extra_relicsExp)

            table.insert(prize_list, sendtable)
            game_playerinfo:change_player_result(steam_id, "score", Diamond)
            game_playerinfo:update_score(playerID, Diamond)
		elseif 1501 < randint and randint <= 2101 then
			-- 一张SSR卡
			local Diamond = RandomInt(20000, 60000)
            
            local sendtable = {}
            table.insert(sendtable, "score")
            table.insert(sendtable, Diamond)
            local extra_relicsExp = RandomInt(15, 28)
            game_playerinfo:update_relicsExp(steam_id, extra_relicsExp)
            table.insert(sendtable, extra_relicsExp)

            table.insert(prize_list, sendtable)
            game_playerinfo:change_player_result(steam_id, "score", Diamond)
            game_playerinfo:update_score(playerID, Diamond)
        elseif 2101 < randint and randint <= 2111 then
            -- 神之遗物经验
            local relicsExp = RandomInt(1000*2, 1888*2)

            game_playerinfo:update_relicsExp(steam_id, relicsExp)
			local sendtable = {}
			table.insert(sendtable, "relics_Amount")
			table.insert(sendtable, relicsExp)
            local extra_relicsExp = RandomInt(15, 28)
            game_playerinfo:update_relicsExp(steam_id, extra_relicsExp)
            table.insert(sendtable, extra_relicsExp)

			table.insert(prize_list, sendtable)

			-- -- 获得双倍经验卡(3天)
			-- table.insert(sendtable, "Experience_double_card_Day")
			-- table.insert(sendtable, 3)
            

            -- table.insert(prize_list, sendtable)

            -- local itemtable = {}
            -- itemtable["itemKey"] = "Experience_double_card"
            -- itemtable["number"] = 3
			-- table.insert(store_item, itemtable)
		-- elseif 80 < randint and randint <= 88 then
		-- 	-- 1200英雄经验
		-- 	game_playerinfo:update_useHeroExp(steam_id, 1200)
		-- 	local sendtable = {}
		-- 	table.insert(sendtable, "useHero_Amount")
		-- 	table.insert(sendtable, 1200)

		-- 	table.insert(prize_list, sendtable)
		elseif 2111 < randint and randint <= 5111 then
            -- 神之遗物经验
            local relicsExp = RandomInt(300*2, 488*2)

			game_playerinfo:update_relicsExp(steam_id, relicsExp)
			local sendtable = {}
			table.insert(sendtable, "relics_Amount")
			table.insert(sendtable, relicsExp)
            local extra_relicsExp = RandomInt(15, 28)
            game_playerinfo:update_relicsExp(steam_id, extra_relicsExp)
            table.insert(sendtable, extra_relicsExp)

            table.insert(prize_list, sendtable)
        elseif 5111 < randint and randint <= 6611 then
            -- 神之遗物经验
            local relicsExp = RandomInt(500*2, 688*2)

			game_playerinfo:update_relicsExp(steam_id, relicsExp)
			local sendtable = {}
			table.insert(sendtable, "relics_Amount")
			table.insert(sendtable, relicsExp)
            local extra_relicsExp = RandomInt(15, 28)
            game_playerinfo:update_relicsExp(steam_id, extra_relicsExp)
            table.insert(sendtable, extra_relicsExp)

            table.insert(prize_list, sendtable)
        elseif 6611 < randint and randint <= 7111 then
            -- 神之遗物经验
            local relicsExp = RandomInt(700*2, 988*2)

			game_playerinfo:update_relicsExp(steam_id, relicsExp)
			local sendtable = {}
			table.insert(sendtable, "relics_Amount")
			table.insert(sendtable, relicsExp)
            local extra_relicsExp = RandomInt(15, 28)
            game_playerinfo:update_relicsExp(steam_id, extra_relicsExp)
            table.insert(sendtable, extra_relicsExp)

			table.insert(prize_list, sendtable)
        elseif 7111 < randint and randint <= 7161 then
            -- 图腾碎片
            local totemName = "totemCf"
            local number = 2

			game_playerinfo:update_totem_data(steam_id, totemName, number)

            local sendtable = {}
            table.insert(sendtable, totemName)
            table.insert(sendtable, number)
            local extra_relicsExp = RandomInt(15, 28)
            game_playerinfo:update_relicsExp(steam_id, extra_relicsExp)
            table.insert(sendtable, extra_relicsExp)
            table.insert(prize_list, sendtable)
        elseif 7161 < randint and randint <= 7211 then
            -- 图腾碎片
            local totemName = "totemDz"
            local number = 2

			game_playerinfo:update_totem_data(steam_id, totemName, number)

            local sendtable = {}
            table.insert(sendtable, totemName)
            table.insert(sendtable, number)
            local extra_relicsExp = RandomInt(15, 28)
            game_playerinfo:update_relicsExp(steam_id, extra_relicsExp)
            table.insert(sendtable, extra_relicsExp)
            table.insert(prize_list, sendtable)
        elseif 7211 < randint and randint <= 7271 then
            -- 图腾碎片
            local totemName = "totemDj"
            local number = 2

			game_playerinfo:update_totem_data(steam_id, totemName, number)

            local sendtable = {}
            table.insert(sendtable, totemName)
            table.insert(sendtable, number)
            local extra_relicsExp = RandomInt(15, 28)
            game_playerinfo:update_relicsExp(steam_id, extra_relicsExp)
            table.insert(sendtable, extra_relicsExp)
            table.insert(prize_list, sendtable)
        elseif 7271 < randint and randint <= 7306 then
            -- 图腾碎片
            local totemName = "totemSj"
            local number = 2

			game_playerinfo:update_totem_data(steam_id, totemName, number)

            local sendtable = {}
            table.insert(sendtable, totemName)
            table.insert(sendtable, number)
            local extra_relicsExp = RandomInt(15, 28)
            game_playerinfo:update_relicsExp(steam_id, extra_relicsExp)
            table.insert(sendtable, extra_relicsExp)
            table.insert(prize_list, sendtable)
        elseif 7306 < randint and randint <= 7334 then
            -- 图腾碎片
            local totemName = "totemSw"
            local number = 2

			game_playerinfo:update_totem_data(steam_id, totemName, number)

            local sendtable = {}
            table.insert(sendtable, totemName)
            table.insert(sendtable, number)
            local extra_relicsExp = RandomInt(15, 28)
            game_playerinfo:update_relicsExp(steam_id, extra_relicsExp)
            table.insert(sendtable, extra_relicsExp)
            table.insert(prize_list, sendtable)
        elseif 7334 < randint and randint <= 7364 then
            -- 图腾碎片
            local totemName = "totemYx"
            local number = 2

			game_playerinfo:update_totem_data(steam_id, totemName, number)

            local sendtable = {}
            table.insert(sendtable, totemName)
            table.insert(sendtable, number)
            local extra_relicsExp = RandomInt(15, 28)
            game_playerinfo:update_relicsExp(steam_id, extra_relicsExp)
            table.insert(sendtable, extra_relicsExp)
            table.insert(prize_list, sendtable)
        elseif 7364 < randint and randint <= 7399 then
            -- 图腾碎片
            local totemName = "totemBw"
            local number = 2

			game_playerinfo:update_totem_data(steam_id, totemName, number)

            local sendtable = {}
            table.insert(sendtable, totemName)
            table.insert(sendtable, number)
            local extra_relicsExp = RandomInt(15, 28)
            game_playerinfo:update_relicsExp(steam_id, extra_relicsExp)
            table.insert(sendtable, extra_relicsExp)
            table.insert(prize_list, sendtable)
        elseif 7399 < randint and randint <= 7449 then
            -- 图腾碎片
            local totemName = "totemJh"
            local number = 2

			game_playerinfo:update_totem_data(steam_id, totemName, number)

            local sendtable = {}
            table.insert(sendtable, totemName)
            table.insert(sendtable, number)
            local extra_relicsExp = RandomInt(15, 28)
            game_playerinfo:update_relicsExp(steam_id, extra_relicsExp)
            table.insert(sendtable, extra_relicsExp)
            table.insert(prize_list, sendtable)
        elseif 7449 < randint and randint <= 7494 then
            -- 图腾碎片
            local totemName = "totemZf"
            local number = 2

			game_playerinfo:update_totem_data(steam_id, totemName, number)

            local sendtable = {}
            table.insert(sendtable, totemName)
            table.insert(sendtable, number)
            local extra_relicsExp = RandomInt(15, 28)
            game_playerinfo:update_relicsExp(steam_id, extra_relicsExp)
            table.insert(sendtable, extra_relicsExp)
            table.insert(prize_list, sendtable)
        elseif 7494 < randint and randint <= 7549 then
            -- 图腾碎片
            local totemName = "totemMl"
            local number = 2

			game_playerinfo:update_totem_data(steam_id, totemName, number)

            local sendtable = {}
            table.insert(sendtable, totemName)
            table.insert(sendtable, number)
            local extra_relicsExp = RandomInt(15, 28)
            game_playerinfo:update_relicsExp(steam_id, extra_relicsExp)
            table.insert(sendtable, extra_relicsExp)
            table.insert(prize_list, sendtable)
        elseif 7549 < randint and randint <= 7595 then
            -- 图腾碎片
            local totemName = "totemSm"
            local number = 2

			game_playerinfo:update_totem_data(steam_id, totemName, number)

            local sendtable = {}
            table.insert(sendtable, totemName)
            table.insert(sendtable, number)
            local extra_relicsExp = RandomInt(15, 28)
            game_playerinfo:update_relicsExp(steam_id, extra_relicsExp)
            table.insert(sendtable, extra_relicsExp)
            table.insert(prize_list, sendtable)
        elseif 7595 < randint and randint <= 7650 then
            -- 图腾碎片
            local totemName = "totemSd"
            local number = 2

			game_playerinfo:update_totem_data(steam_id, totemName, number)

            local sendtable = {}
            table.insert(sendtable, totemName)
            table.insert(sendtable, number)
            local extra_relicsExp = RandomInt(15, 28)
            game_playerinfo:update_relicsExp(steam_id, extra_relicsExp)
            table.insert(sendtable, extra_relicsExp)
            table.insert(prize_list, sendtable)
        elseif 7650 < randint and randint <= 7725 then
            -- 图腾碎片
            local totemName = "totemMh"
            local number = 2

			game_playerinfo:update_totem_data(steam_id, totemName, number)

            local sendtable = {}
            table.insert(sendtable, totemName)
            table.insert(sendtable, number)
            local extra_relicsExp = RandomInt(15, 28)
            game_playerinfo:update_relicsExp(steam_id, extra_relicsExp)
            table.insert(sendtable, extra_relicsExp)
            table.insert(prize_list, sendtable)
        elseif 7725 < randint and randint <= 7805 then
            -- 图腾碎片
            local totemName = "totemAy"
            local number = 2

			game_playerinfo:update_totem_data(steam_id, totemName, number)

            local sendtable = {}
            table.insert(sendtable, totemName)
            table.insert(sendtable, number)
            local extra_relicsExp = RandomInt(15, 28)
            game_playerinfo:update_relicsExp(steam_id, extra_relicsExp)
            table.insert(sendtable, extra_relicsExp)
            table.insert(prize_list, sendtable)
        elseif 7805 < randint and randint <= 7900 then
            -- 图腾碎片
            local totemName = "totemFy"
            local number = 2

			game_playerinfo:update_totem_data(steam_id, totemName, number)

            local sendtable = {}
            table.insert(sendtable, totemName)
            table.insert(sendtable, number)
            local extra_relicsExp = RandomInt(15, 28)
            game_playerinfo:update_relicsExp(steam_id, extra_relicsExp)
            table.insert(sendtable, extra_relicsExp)
            table.insert(prize_list, sendtable)
		elseif 7900 < randint and randint <= 8300 then
            -- 获得图腾包的奖励
            game_playerinfo:randomrewardstotempackage(steam_id, prize_list)
        else
            -- 获得单独图腾的奖励
            game_playerinfo:randomrewardstotem(steam_id, prize_list)
		end
    end
    -- print("prize_list: "..#prize_list)
    return store_item
end

-- 使用新春礼包
function usenewyearBag(playerID, prize_list, number)
    local store_item = {}
    local steam_id = PlayerResource:GetSteamAccountID(playerID)
    if number == 20 then
        -- 10连
        number = 19
        -- 获得保底升华卡
        local card_name = treasuresystem:AddTreasureToPlayerByName(playerID, treasuresystem:random_sublim_treasure())
        local sendtable = {}
        table.insert(sendtable, card_name)
        table.insert(sendtable, 1)

        table.insert(prize_list, sendtable)
    end
	for i=1, number do
		local randint = RandomInt(1, 1000)
        if 0 < randint and randint <= 100 then
			-- 钻石
			local Diamond = RandomInt(5000, 10000)
            
            local sendtable = {}
            table.insert(sendtable, "score")
            table.insert(sendtable, Diamond)
            -- local extra_relicsExp = RandomInt(15, 28)
            -- game_playerinfo:update_relicsExp(steam_id, extra_relicsExp)
            -- table.insert(sendtable, extra_relicsExp)

            table.insert(prize_list, sendtable)
            game_playerinfo:change_player_result(steam_id, "score", Diamond)
            game_playerinfo:update_score(playerID, Diamond)
		elseif 100 < randint and randint <= 235 then
			-- 钻石
			local Diamond = RandomInt(20000, 50000)
            
            local sendtable = {}
            table.insert(sendtable, "score")
            table.insert(sendtable, Diamond)
            -- local extra_relicsExp = RandomInt(15, 28)
            -- game_playerinfo:update_relicsExp(steam_id, extra_relicsExp)
            -- table.insert(sendtable, extra_relicsExp)

            table.insert(prize_list, sendtable)
            game_playerinfo:change_player_result(steam_id, "score", Diamond)
            game_playerinfo:update_score(playerID, Diamond)
		elseif 235 < randint and randint <= 255 then
			-- 钻石
			local Diamond = RandomInt(60000, 100000)
            
            local sendtable = {}
            table.insert(sendtable, "score")
            table.insert(sendtable, Diamond)
            -- local extra_relicsExp = RandomInt(15, 28)
            -- game_playerinfo:update_relicsExp(steam_id, extra_relicsExp)
            -- table.insert(sendtable, extra_relicsExp)

            table.insert(prize_list, sendtable)
            game_playerinfo:change_player_result(steam_id, "score", Diamond)
            game_playerinfo:update_score(playerID, Diamond)
		elseif 255 < randint and randint <= 260 then
			-- 钻石
			local Diamond = RandomInt(200000, 500000)
            
            local sendtable = {}
            table.insert(sendtable, "score")
            table.insert(sendtable, Diamond)
            -- local extra_relicsExp = RandomInt(15, 28)
            -- game_playerinfo:update_relicsExp(steam_id, extra_relicsExp)
            -- table.insert(sendtable, extra_relicsExp)

            table.insert(prize_list, sendtable)
            game_playerinfo:change_player_result(steam_id, "score", Diamond)
            game_playerinfo:update_score(playerID, Diamond)
		elseif 260 < randint and randint <= 560 then
            -- 神之遗物经验
            local relicsExp = RandomInt(300, 488)

			game_playerinfo:update_relicsExp(steam_id, relicsExp)
			local sendtable = {}
			table.insert(sendtable, "relics_Amount")
			table.insert(sendtable, relicsExp)
            
            table.insert(prize_list, sendtable)
        elseif 560 < randint and randint <= 639 then
            -- 神之遗物经验
            local relicsExp = RandomInt(500, 688)

			game_playerinfo:update_relicsExp(steam_id, relicsExp)
			local sendtable = {}
			table.insert(sendtable, "relics_Amount")
			table.insert(sendtable, relicsExp)
            
            table.insert(prize_list, sendtable)
        elseif 639 < randint and randint <= 679 then
            -- 神之遗物经验
            local relicsExp = RandomInt(700, 988)

			game_playerinfo:update_relicsExp(steam_id, relicsExp)
			local sendtable = {}
			table.insert(sendtable, "relics_Amount")
			table.insert(sendtable, relicsExp)
            
            table.insert(prize_list, sendtable)
        elseif 679 < randint and randint <= 699 then
            -- 神之遗物经验
            local relicsExp = RandomInt(1000, 1888)

			game_playerinfo:update_relicsExp(steam_id, relicsExp)
			local sendtable = {}
			table.insert(sendtable, "relics_Amount")
			table.insert(sendtable, relicsExp)
            
            table.insert(prize_list, sendtable)
        elseif 699 < randint and randint <= 849 then
            -- N级宝物卡
            local card_name = treasuresystem:AddHappyNewYearTreasureToPlayer(playerID, "N")
            local sendtable = {}
            table.insert(sendtable, card_name)
            table.insert(sendtable, 1)

            table.insert(prize_list, sendtable)
        elseif 849 < randint and randint <= 929 then
            -- R级宝物卡
            local card_name = treasuresystem:AddHappyNewYearTreasureToPlayer(playerID, "R")
            local sendtable = {}
            table.insert(sendtable, card_name)
            table.insert(sendtable, 1)

            table.insert(prize_list, sendtable)
        elseif 929 < randint and randint <= 969 then
            -- SR级宝物卡
            local card_name = treasuresystem:AddHappyNewYearTreasureToPlayer(playerID, "SR")
            local sendtable = {}
            table.insert(sendtable, card_name)
            table.insert(sendtable, 1)

            table.insert(prize_list, sendtable)
        else
            -- SSR级宝物卡
            local card_name = treasuresystem:AddHappyNewYearTreasureToPlayer(playerID, "SSR")
            local sendtable = {}
            table.insert(sendtable, card_name)
            table.insert(sendtable, 1)

            table.insert(prize_list, sendtable)
		end
    end
    -- print("prize_list: "..#prize_list)
    return store_item
end

-- 拜年大礼包
function useBignewyearBag(playerID, prize_list, store_item)
    local steam_id = PlayerResource:GetSteamAccountID(playerID)
    -- 奖励春节红包
    game_playerinfo:rewardsHappyNewYearBag(steam_id, 20, prize_list, store_item)
end

-- 王者大礼包
function useWangZheBag(playerID, prize_list)
    local steam_id = PlayerResource:GetSteamAccountID(playerID)
    -- 王者双卡
    
    local card_name = treasuresystem:AddTreasureToPlayerByName(playerID, "modifier_treasure_king_glory")
    local sendtable = {}
    table.insert(sendtable, card_name)
    table.insert(sendtable, 1)

    table.insert(prize_list, sendtable)

    local card_name1 = treasuresystem:AddTreasureToPlayerByName(playerID, "modifier_treasure_king_brilliant")
    local sendtable = {}
    table.insert(sendtable, card_name1)
    table.insert(sendtable, 1)

    table.insert(prize_list, sendtable)
end

-- 新手10连礼包
function useNovicebenefits(playerID, prize_list, store_item)
    local steam_id = PlayerResource:GetSteamAccountID(playerID)
    -- 奖励沙海寻踪
    game_playerinfo:rewardssandseapursuit(steam_id, 10, prize_list,store_item)
end

-- 经验双倍卡（30天）礼包
function useExperiencedoublecard30days(playerID, prize_list, number)
    local store_item = {}
    -- local steam_id = PlayerResource:GetSteamAccountID(playerID)
    local sendtable = {}
    table.insert(sendtable, "Experience_double_card_Day")
	-- 获得双倍经验卡(30天)
    table.insert(sendtable, 30*number)
    local itemtable = {}
    itemtable["itemKey"] = "Experience_double_card"
    itemtable["number"] = 30*number
    table.insert(prize_list, sendtable)
    table.insert(store_item, itemtable)
    
    return store_item
end

-- 新手英雄助力礼包
function useGiftpackfornovicehero(playerID, prize_list)
    local store_item = {}
    local steam_id = PlayerResource:GetSteamAccountID(playerID)
	
	game_playerinfo:update_useHeroExp(steam_id, 2000)
    local sendtable = {}
    table.insert(sendtable, "useHero_Amount")
    table.insert(sendtable, 2000)

    table.insert(prize_list, sendtable)
    return store_item
end

-- 神之遗物助力礼包
function useGiftbagwithGodsrelic(playerID, prize_list)
    local store_item = {}
    local steam_id = PlayerResource:GetSteamAccountID(playerID)
	-- 2000 神之遗物经验
    game_playerinfo:update_relicsExp(steam_id, 2000)
    local sendtable = {}
    table.insert(sendtable, "relics_Amount")
    table.insert(sendtable, 2000)

    table.insert(prize_list, sendtable)
    return store_item
end

-- 奖励钻石
function game_playerinfo:rewardsDiamond(steam_id, score, prize_list)
    -- game_playerinfo:update_score(steam_id, score)
    local sendtable = {}
    table.insert(sendtable, "score")
    table.insert(sendtable, score)

    table.insert(prize_list, sendtable)
end

-- 奖励神之遗物经验
function game_playerinfo:rewardsrelicsExp(steam_id, exp, prize_list)
    game_playerinfo:update_relicsExp(steam_id, exp)
    local sendtable = {}
    table.insert(sendtable, "relics_Amount")
    table.insert(sendtable, exp)

    table.insert(prize_list, sendtable)
end

-- 奖励宝物碎片
function game_playerinfo:rewardschipNumber(steam_id, number, prize_list)
    game_playerinfo:update_chipNumber(steam_id, number)
    local sendtable = {}
    table.insert(sendtable, "chip_Amount")
    table.insert(sendtable, number)

    table.insert(prize_list, sendtable)
end

-- 通关奖励图腾碎片
function game_playerinfo:passLevelrewardstotem(steam_id, level, prize_list)

    local number = 0

    if level == 5 then
        if RollPercentage(10) then
            number = RandomInt(0,1)
        end
    elseif level == 6 then
        if RollPercentage(20) then
            number = RandomInt(0,2)
        end
    elseif level == 7 then
        if RollPercentage(30) then
            number = RandomInt(0,3)
        end
    elseif level > 7 then
        if RollPercentage(30) then
            number = RandomInt(0,(3 + (level - 7)))
        end
    end
    
    for i = 1, number do
        local totemName = ""
        local random = RandomInt(1, 1000)

        if 0 < random and random <= 60 then
            totemName = "totemCf"
        elseif 60 < random and random <= 110 then
            totemName = "totemDz"
        elseif 110 < random and random <= 180 then
            totemName = "totemDj"
        elseif 180 < random and random <= 260 then
            totemName = "totemSj"
        elseif 260 < random and random <= 290 then
            totemName = "totemSw"
        elseif 290 < random and random <= 380 then
            totemName = "totemYx"
        elseif 380 < random and random <= 410 then
            totemName = "totemBw"
        elseif 410 < random and random <= 440 then
            totemName = "totemJh"
        elseif 440 < random and random <= 515 then
            totemName = "totemZf"
        elseif 515 < random and random <= 600 then
            totemName = "totemMl"
        elseif 600 < random and random <= 675 then
            totemName = "totemSm"
        elseif 675 < random and random <= 750 then
            totemName = "totemSd"
        elseif 750 < random and random <= 820 then
            totemName = "totemMh"
        elseif 820 < random and random <= 910 then
            totemName = "totemAy"
        else
            totemName = "totemFy"
        end

        game_playerinfo:update_totem_data(steam_id, totemName, 1)
        local isSame = false
        for index, value in ipairs(prize_list) do
            if value[1] == totemName then
                -- body
                value[2] = value[2] + 1
                isSame = true
                break
            end
        end
        if not isSame then
            -- body
            local sendtable = {}
            table.insert(sendtable, totemName)
            table.insert(sendtable, 1)

            table.insert(prize_list, sendtable)
        end
    end
end

-- 奖励图腾碎片
function game_playerinfo:rewardstotem(steam_id, number, prize_list)

    local totemName = self:RandomTotem()

    game_playerinfo:update_totem_data(steam_id, totemName, number)

    local sendtable = {}
    table.insert(sendtable, totemName)
    table.insert(sendtable, number)

    table.insert(prize_list, sendtable)
end

-- 首通奖励图腾碎片
function game_playerinfo:rewardfirststotem(steam_id, number, prize_list)

    local totemName = self:RandomTotem()

    game_playerinfo:update_totem_data(steam_id, totemName, number)

    local sendtable = {}
    table.insert(sendtable, totemName)
    table.insert(sendtable, number)

    table.insert(prize_list, sendtable)
end

-- 获得图腾包的奖励
function game_playerinfo:randomrewardstotempackage(steam_id, prize_list)

    local totemName = ""
    local number = 0

    local random = RandomInt(1, 400)

    if 0 < random and random <= 24 then
        totemName = "totemCf"
        number = 4
    elseif 24 < random and random <= 42 then
        totemName = "totemDz"
        number = 4
    elseif 42 < random and random <= 70 then
        totemName = "totemDj"
        number = 3
    elseif 70 < random and random <= 100 then
        totemName = "totemSj"
        number = 4
    elseif 100 < random and random <= 112 then
        totemName = "totemSw"
        number = 3
    elseif 112 < random and random <= 148 then
        totemName = "totemYx"
        number = 3
    elseif 148 < random and random <= 160 then
        totemName = "totemBw"
        number = 6
    elseif 160 < random and random <= 172 then
        totemName = "totemJh"
        number = 6
    elseif 172 < random and random <= 202 then
        totemName = "totemZf"
        number = 4
    elseif 202 < random and random <= 236 then
        totemName = "totemMl"
        number = 4
    elseif 236 < random and random <= 266 then
        totemName = "totemSm"
        number = 4
    elseif 266 < random and random <= 296 then
        totemName = "totemSd"
        number = 4
    elseif 296 < random and random <= 327 then
        totemName = "totemMh"
        number = 4
    elseif 327 < random and random <= 360 then
        totemName = "totemAy"
        number = 4
    elseif 360 < random and random <= 400 then
        totemName = "totemFy"
        number = 3
    end

    game_playerinfo:update_totem_data(steam_id, totemName, number)

    local sendtable = {}
    table.insert(sendtable, totemName)
    table.insert(sendtable, number)
    local extra_relicsExp = RandomInt(15, 28)
    game_playerinfo:update_relicsExp(steam_id, extra_relicsExp)
    table.insert(sendtable, extra_relicsExp)
    table.insert(prize_list, sendtable)
end

-- 获得10连必中的图腾包奖励
function game_playerinfo:essentialtotempackage(steam_id, prize_list)

    local totemName = ""
    local number = 0

    local random = RandomInt(1, 100)

    if 0 < random and random <= 6 then
        totemName = "totemCf"
        number = 4
    elseif 6 < random and random <= 12 then
        totemName = "totemDz"
        number = 4
    elseif 12 < random and random <= 17 then
        totemName = "totemDj"
        number = 3
    elseif 17 < random and random <= 22 then
        totemName = "totemSj"
        number = 4
    elseif 22 < random and random <= 28 then
        totemName = "totemSw"
        number = 3
    elseif 28 < random and random <= 37 then
        totemName = "totemYx"
        number = 3
    elseif 37 < random and random <= 40 then
        totemName = "totemBw"
        number = 6
    elseif 40 < random and random <= 46 then
        totemName = "totemJh"
        number = 6
    elseif 46 < random and random <= 52 then
        totemName = "totemZf"
        number = 4
    elseif 52 < random and random <= 58 then
        totemName = "totemMl"
        number = 4
    elseif 58 < random and random <= 64 then
        totemName = "totemSm"
        number = 4
    elseif 64 < random and random <= 70 then
        totemName = "totemSd"
        number = 4
    elseif 70 < random and random <= 79 then
        totemName = "totemMh"
        number = 4
    elseif 79 < random and random <= 88 then
        totemName = "totemAy"
        number = 4
    else
        totemName = "totemFy"
        number = 3
    end

    game_playerinfo:update_totem_data(steam_id, totemName, number)

    local sendtable = {}
    table.insert(sendtable, totemName)
    table.insert(sendtable, number)
    local extra_relicsExp = RandomInt(15, 28)
    game_playerinfo:update_relicsExp(steam_id, extra_relicsExp)
    table.insert(sendtable, extra_relicsExp)
    table.insert(prize_list, sendtable)
end

-- 获得单独图腾的奖励
function game_playerinfo:randomrewardstotem(steam_id, prize_list)

    local totemName = ""
    local number = 1

    local random = RandomInt(1, 170)

    if 0 < random and random <= 10 then
        totemName = "totemCf"
    elseif 10 < random and random <= 20 then
        totemName = "totemDz"
    elseif 20 < random and random <= 32 then
        totemName = "totemDj"
    elseif 32 < random and random <= 40 then
        totemName = "totemSj"
    elseif 40 < random and random <= 50 then
        totemName = "totemSw"
    elseif 50 < random and random <= 63 then
        totemName = "totemYx"
    elseif 63 < random and random <= 70 then
        totemName = "totemBw"
    elseif 70 < random and random <= 80 then
        totemName = "totemJh"
    elseif 80 < random and random <= 89 then
        totemName = "totemZf"
    elseif 89 < random and random <= 100 then
        totemName = "totemMl"
    elseif 100 < random and random <= 109 then
        totemName = "totemSm"
    elseif 109 < random and random <= 120 then
        totemName = "totemSd"
    elseif 120 < random and random <= 135 then
        totemName = "totemMh"
    elseif 135 < random and random <= 151 then
        totemName = "totemAy"
    else
        totemName = "totemFy"
    end

    game_playerinfo:update_totem_data(steam_id, totemName, number)

    local sendtable = {}
    table.insert(sendtable, totemName)
    table.insert(sendtable, number)
    local extra_relicsExp = RandomInt(15, 28)
    game_playerinfo:update_relicsExp(steam_id, extra_relicsExp)
    table.insert(sendtable, extra_relicsExp)
    table.insert(prize_list, sendtable)
end

-- 奖励随机宝物卡
function game_playerinfo:rewardstreasures(playerID, prize_list, passlevel)
    -- game_playerinfo:update_relicsExp(steam_id, number)
    -- local sendtable = {}
    -- table.insert(sendtable, "relics_Amount")
    -- table.insert(sendtable, number)

    -- table.insert(prize_list, sendtable)
    -- print(" playerID: "..playerID)
    local random1 = 75
    local random2 = 99
    if passlevel >= 7 then
        random1 = 74
        random2 = 98
    end
    local randint = RandomInt(1, 100)
    if 0 < randint and randint <= random1 then
        -- 一张N卡
        local card_name = treasuresystem:AddTreasureToPlayer(playerID, "N")
        local sendtable = {}
        table.insert(sendtable, card_name)
        table.insert(sendtable, 1)

        table.insert(prize_list, sendtable)
    elseif random1 < randint and randint <= random2 then
        -- 一张R卡
        local card_name = treasuresystem:AddTreasureToPlayer(playerID, "R")
        local sendtable = {}
        table.insert(sendtable, card_name)
        table.insert(sendtable, 1)

        table.insert(prize_list, sendtable)
    elseif random2 < randint and randint <= 100 then
        -- 一张SR卡
        local card_name = treasuresystem:AddTreasureToPlayer(playerID, "SR")
        local sendtable = {}
        table.insert(sendtable, card_name)
        table.insert(sendtable, 1)

        table.insert(prize_list, sendtable)
    end
end

-- 奖励沙海寻踪
function game_playerinfo:rewardssandseapursuit(steam_id, number, prize_list, store_item)
    -- 沙海寻踪
    local sendtable = {}
    table.insert(sendtable, "Sand_sea_pursuit")
    table.insert(sendtable, number)

    table.insert(prize_list, sendtable)
    local itemtable = {}
    itemtable["itemKey"] = "Sand_sea_pursuit"
    itemtable["number"] = number
    table.insert(store_item, itemtable)
end

-- 奖励新春礼包
function game_playerinfo:rewardsHappyNewYearBag(steam_id, number, prize_list, store_item)
    -- 新春礼包
    local sendtable = {}
    table.insert(sendtable, "newyear_bag")
    table.insert(sendtable, number)

    table.insert(prize_list, sendtable)
    local itemtable = {}
    itemtable["itemKey"] = "newyear_bag"
    itemtable["number"] = number
    table.insert(store_item, itemtable)
end

-- 设置领取首通奖励标记
function game_playerinfo:SetLevelRewardsSign(steam_id, passlevel)
    if not player_info[steam_id]["levelRewardsLists"] then
        player_info[steam_id]["levelRewardsLists"] = {0,0,0,0,0,0,0,0,0,0,10}
    end
    
    if passlevel > 10 then
        -- body
        if not player_info[steam_id]["levelRewardsLists"][11] then
            -- body
            player_info[steam_id]["levelRewardsLists"][11] = 11
        else
            player_info[steam_id]["levelRewardsLists"][11] = passlevel
        end
    else
        player_info[steam_id]["levelRewardsLists"][passlevel] = 1
    end
    -- print(" >>>>>>>>>>>>>> levelRewardsLists: "..player_info[steam_id]["levelRewardsLists"][passlevel])
end

function game_playerinfo:GetLevelRewardsSign(steam_id)
    if not player_info[steam_id]["levelRewardsLists"] then
        player_info[steam_id]["levelRewardsLists"] = {0,0,0,0,0,0,0,0,0,0,10}
    end
    if not player_info[steam_id]["levelRewardsLists"][11] then
        player_info[steam_id]["levelRewardsLists"][11] = 10
    end
    return player_info[steam_id]["levelRewardsLists"]
end

function game_playerinfo:SetmapRewardsCount(steam_id)
    if not player_info[steam_id]["mapRewardsCount"] then
        player_info[steam_id]["mapRewardsCount"] = 0
    end
    player_info[steam_id]["mapRewardsCount"] = player_info[steam_id]["mapRewardsCount"] + 1
end

function game_playerinfo:GetmapRewardsCount(steam_id)
    if not player_info[steam_id]["mapRewardsCount"] then
        player_info[steam_id]["mapRewardsCount"] = 0
    end
    return player_info[steam_id]["mapRewardsCount"]
end

function game_playerinfo:sendLevelRewardsSignToSave(steam_id)
    if not player_info[steam_id]["levelRewardsLists"] then
        player_info[steam_id]["levelRewardsLists"] = {0,0,0,0,0,0,0,0,0,0,10}
    end
    if not player_info[steam_id]["levelRewardsLists"][11] then
        player_info[steam_id]["levelRewardsLists"][11] = 10
    end
    local send_table = {}
    -- DeepPrintTable(player_info[steam_id]["levelRewardsLists"])
    for i = 1, #player_info[steam_id]["levelRewardsLists"] do
        local temp_table = {}
        temp_table["isGet"] = player_info[steam_id]["levelRewardsLists"][i]
        -- if i==8 then
        --     -- body
        --     if player_info[steam_id]["passLevel"] > player_info[steam_id]["levelRewardsLists"][i] then
        --         temp_table["isGet"] = 0
        --     else
        --         temp_table["isGet"] = 1
        --     end
        -- else
        --     temp_table["isGet"] = player_info[steam_id]["levelRewardsLists"][i]
        -- end
        table.insert(send_table, temp_table)
    end
    return send_table
end

-- 首次通关奖励礼包
function onceTheGiftOfThePharaoh(playerID, passlevel, prize_list)
    local store_item = {}
    local steam_id = PlayerResource:GetSteamAccountID(playerID)
    if passlevel==1 then
        -- 奖励钻石
        game_playerinfo:rewardsDiamond(steam_id, 8000, prize_list)
        game_playerinfo:rewardsDiamond(steam_id, 12000, prize_list)
        game_playerinfo:rewardsDiamond(steam_id, 6000, prize_list)

        -- 奖励神之遗物经验
        game_playerinfo:rewardsrelicsExp(steam_id, 20, prize_list)
        game_playerinfo:rewardsrelicsExp(steam_id, 40, prize_list)
        game_playerinfo:rewardsrelicsExp(steam_id, 50, prize_list)
        game_playerinfo:rewardsrelicsExp(steam_id, 20, prize_list)
        game_playerinfo:rewardsrelicsExp(steam_id, 30, prize_list)
        -- 奖励图腾碎片
        game_playerinfo:rewardfirststotem(steam_id, 1, prize_list)
        -- 奖励宝物卡
        game_playerinfo:rewardstreasures(playerID, prize_list, 1)
    elseif passlevel==2 then
        game_playerinfo:rewardsDiamond(steam_id, 9000, prize_list)
        game_playerinfo:rewardsDiamond(steam_id, 14000, prize_list)
        game_playerinfo:rewardsDiamond(steam_id, 8000, prize_list)
        -- 奖励神之遗物经验
        game_playerinfo:rewardsrelicsExp(steam_id, 30, prize_list)
        game_playerinfo:rewardsrelicsExp(steam_id, 50, prize_list)
        game_playerinfo:rewardsrelicsExp(steam_id, 60, prize_list)
        game_playerinfo:rewardsrelicsExp(steam_id, 30, prize_list)
        game_playerinfo:rewardsrelicsExp(steam_id, 40, prize_list)
        -- 奖励图腾碎片
        game_playerinfo:rewardfirststotem(steam_id, 3, prize_list)
        -- 奖励宝物卡
        game_playerinfo:rewardstreasures(playerID, prize_list, 2)
    elseif passlevel==3 then
        game_playerinfo:rewardsDiamond(steam_id, 10000, prize_list)
        game_playerinfo:rewardsDiamond(steam_id, 16000, prize_list)
        game_playerinfo:rewardsDiamond(steam_id, 10000, prize_list)
        -- 奖励神之遗物经验
        game_playerinfo:rewardsrelicsExp(steam_id, 40, prize_list)
        game_playerinfo:rewardsrelicsExp(steam_id, 60, prize_list)
        game_playerinfo:rewardsrelicsExp(steam_id, 70, prize_list)
        game_playerinfo:rewardsrelicsExp(steam_id, 40, prize_list)
        game_playerinfo:rewardsrelicsExp(steam_id, 50, prize_list)
        -- 奖励图腾碎片
        game_playerinfo:rewardfirststotem(steam_id, 5, prize_list)
        -- 奖励宝物卡
        game_playerinfo:rewardstreasures(playerID, prize_list, 3)
        game_playerinfo:rewardstreasures(playerID, prize_list, 3)
    elseif passlevel==4 then
        game_playerinfo:rewardsDiamond(steam_id, 11000, prize_list)
        game_playerinfo:rewardsDiamond(steam_id, 18000, prize_list)
        game_playerinfo:rewardsDiamond(steam_id, 12000, prize_list)
        -- 奖励神之遗物经验
        game_playerinfo:rewardsrelicsExp(steam_id, 50, prize_list)
        game_playerinfo:rewardsrelicsExp(steam_id, 70, prize_list)
        game_playerinfo:rewardsrelicsExp(steam_id, 80, prize_list)
        game_playerinfo:rewardsrelicsExp(steam_id, 50, prize_list)
        game_playerinfo:rewardsrelicsExp(steam_id, 60, prize_list)
        -- 奖励图腾碎片
        game_playerinfo:rewardfirststotem(steam_id, 7, prize_list)
        -- 奖励宝物卡
        game_playerinfo:rewardstreasures(playerID, prize_list, 4)
        game_playerinfo:rewardstreasures(playerID, prize_list, 4)
    elseif passlevel==5 then
        game_playerinfo:rewardsDiamond(steam_id, 12000, prize_list)
        game_playerinfo:rewardsDiamond(steam_id, 20000, prize_list)
        game_playerinfo:rewardsDiamond(steam_id, 14000, prize_list)
        -- 奖励神之遗物经验
        game_playerinfo:rewardsrelicsExp(steam_id, 60, prize_list)
        game_playerinfo:rewardsrelicsExp(steam_id, 80, prize_list)
        game_playerinfo:rewardsrelicsExp(steam_id, 90, prize_list)
        game_playerinfo:rewardsrelicsExp(steam_id, 60, prize_list)
        game_playerinfo:rewardsrelicsExp(steam_id, 70, prize_list)
        -- 奖励图腾碎片
        game_playerinfo:rewardfirststotem(steam_id, 9, prize_list)
        -- 奖励宝物卡
        game_playerinfo:rewardstreasures(playerID, prize_list, 5)
        game_playerinfo:rewardstreasures(playerID, prize_list, 5)
        -- 奖励沙海寻踪
        game_playerinfo:rewardssandseapursuit(steam_id, 1, prize_list, store_item)
    elseif passlevel==6 then
        game_playerinfo:rewardsDiamond(steam_id, 13000, prize_list)
        game_playerinfo:rewardsDiamond(steam_id, 22000, prize_list)
        game_playerinfo:rewardsDiamond(steam_id, 16000, prize_list)
        -- 奖励神之遗物经验
        game_playerinfo:rewardsrelicsExp(steam_id, 70, prize_list)
        game_playerinfo:rewardsrelicsExp(steam_id, 90, prize_list)
        game_playerinfo:rewardsrelicsExp(steam_id, 100, prize_list)
        game_playerinfo:rewardsrelicsExp(steam_id, 70, prize_list)
        game_playerinfo:rewardsrelicsExp(steam_id, 80, prize_list)
        -- 奖励图腾碎片
        game_playerinfo:rewardfirststotem(steam_id, 11, prize_list)
        game_playerinfo:rewardfirststotem(steam_id, 3, prize_list)
        -- 奖励宝物卡
        game_playerinfo:rewardstreasures(playerID, prize_list, 6)
        game_playerinfo:rewardstreasures(playerID, prize_list, 6)
        game_playerinfo:rewardstreasures(playerID, prize_list, 6)
        -- 奖励沙海寻踪
        game_playerinfo:rewardssandseapursuit(steam_id, 3, prize_list,store_item)
        game_playerinfo:rewardssandseapursuit(steam_id, 1, prize_list,store_item)
    elseif passlevel==7 then
        game_playerinfo:rewardsDiamond(steam_id, 14000, prize_list)
        game_playerinfo:rewardsDiamond(steam_id, 24000, prize_list)
        game_playerinfo:rewardsDiamond(steam_id, 18000, prize_list)
        -- 奖励神之遗物经验
        game_playerinfo:rewardsrelicsExp(steam_id, 80, prize_list)
        game_playerinfo:rewardsrelicsExp(steam_id, 100, prize_list)
        game_playerinfo:rewardsrelicsExp(steam_id, 110, prize_list)
        game_playerinfo:rewardsrelicsExp(steam_id, 80, prize_list)
        game_playerinfo:rewardsrelicsExp(steam_id, 90, prize_list)
        -- 奖励图腾碎片
        game_playerinfo:rewardfirststotem(steam_id, 13, prize_list)
        game_playerinfo:rewardfirststotem(steam_id, 6, prize_list)
        game_playerinfo:rewardfirststotem(steam_id, 3, prize_list)
        -- 奖励宝物卡
        game_playerinfo:rewardstreasures(playerID, prize_list, 7)
        game_playerinfo:rewardstreasures(playerID, prize_list, 7)
        game_playerinfo:rewardstreasures(playerID, prize_list, 7)
        -- 奖励沙海寻踪
        game_playerinfo:rewardssandseapursuit(steam_id, 5, prize_list,store_item)
        game_playerinfo:rewardssandseapursuit(steam_id, 3, prize_list,store_item)
        game_playerinfo:rewardssandseapursuit(steam_id, 1, prize_list,store_item)
    else
        local sacle = (passlevel - 7)*(0.05)
        game_playerinfo:rewardsDiamond(steam_id, math.floor(14000*(1+sacle)), prize_list)
        game_playerinfo:rewardsDiamond(steam_id, math.floor(24000*(1+sacle)), prize_list)
        game_playerinfo:rewardsDiamond(steam_id, math.floor(18000*(1+sacle)), prize_list)
        -- 奖励神之遗物经验
        game_playerinfo:rewardsrelicsExp(steam_id, math.floor(80*(1+sacle)), prize_list)
        game_playerinfo:rewardsrelicsExp(steam_id, math.floor(100*(1+sacle)), prize_list)
        game_playerinfo:rewardsrelicsExp(steam_id, math.floor(110*(1+sacle)), prize_list)
        game_playerinfo:rewardsrelicsExp(steam_id, math.floor(80*(1+sacle)), prize_list)
        game_playerinfo:rewardsrelicsExp(steam_id, math.floor(90*(1+sacle)), prize_list)
        -- 奖励图腾碎片
        game_playerinfo:rewardfirststotem(steam_id, math.floor(13*(1+sacle)), prize_list)
        game_playerinfo:rewardfirststotem(steam_id, math.floor(6*(1+sacle)), prize_list)
        game_playerinfo:rewardfirststotem(steam_id, math.floor(3*(1+sacle)), prize_list)
        -- 奖励宝物卡
        -- if passlevel~=8 then
            game_playerinfo:rewardstreasures(playerID, prize_list, passlevel)
            game_playerinfo:rewardstreasures(playerID, prize_list, passlevel)
            game_playerinfo:rewardstreasures(playerID, prize_list, passlevel)
        -- else
            -- -- 难8 奖励
            -- local sendtable = {}
            -- table.insert(sendtable, "modifier_treasure_back_off_a")
            -- table.insert(sendtable, 1)

            -- table.insert(prize_list, sendtable)
            -- local addTreasureIndex = treasuresystem:get_treasure_id("modifier_treasure_back_off_a")
            -- treasuresystem:update_treasureinarchive_byID(playerID, addTreasureIndex, 1)

            -- table.insert(sendtable, "modifier_treasure_back_off_b")
            -- table.insert(sendtable, 1)

            -- table.insert(prize_list, sendtable)
            -- local addTreasureIndex = treasuresystem:get_treasure_id("modifier_treasure_back_off_b")
            -- treasuresystem:update_treasureinarchive_byID(playerID, addTreasureIndex, 1)

            -- table.insert(sendtable, "modifier_treasure_back_off_c")
            -- table.insert(sendtable, 1)

            -- table.insert(prize_list, sendtable)
            -- local addTreasureIndex = treasuresystem:get_treasure_id("modifier_treasure_back_off_c")
            -- treasuresystem:update_treasureinarchive_byID(playerID, addTreasureIndex, 1)
        -- end
        
        -- 奖励沙海寻踪
        game_playerinfo:rewardssandseapursuit(steam_id, math.floor(5*(1+sacle)), prize_list,store_item)
        game_playerinfo:rewardssandseapursuit(steam_id, math.floor(3*(1+sacle)), prize_list,store_item)
        game_playerinfo:rewardssandseapursuit(steam_id, math.floor(1*(1+sacle)), prize_list,store_item)
    end
    game_playerinfo:SetLevelRewardsSign(steam_id, passlevel)
    return store_item
end

-- 地图等级奖励礼包
function usemapRewards(playerID, maplevel, prize_list)
    if not map_rewards[maplevel] then
        return
    end
    local amount = map_rewards[maplevel]
    
    local steam_id = PlayerResource:GetSteamAccountID(playerID)
    -- print(amount)
    game_playerinfo:rewardsDiamond(steam_id, amount, prize_list)
    game_playerinfo:SetmapRewardsCount(steam_id)
end


-- 通关普通奖励 
function TheGiftOfThePharaohWin(playerID, passlevel, prize_list, store_item)
    local steam_id = PlayerResource:GetSteamAccountID(playerID)
    local rdDiamond = 0
    if passlevel>=4 then
        if RollPercentage(10) then
            -- 难4以上
            GiftHardOtherTreasures(playerID, prize_list)
        end
        if RollPercentage(10) then
            -- 难4以上
            GiftOtherTreasures(playerID, prize_list)
        end
    else
        if RollPercentage(10) then
            -- 难以下
            GiftOtherTreasures(playerID, prize_list) 
        end
    end
    if global_var_func.createPlayer[playerID] then
        -- 新玩家
        -- 赠送宝物
        GiftOtherTreasures(playerID, prize_list) 
        -- 赠送10W钻石
        local Diamond1 = 100000
        game_playerinfo:rewardsDiamond(steam_id, Diamond1, prize_list)
        game_playerinfo:change_player_result(steam_id, "score", Diamond1)
        game_playerinfo:update_score(playerID, Diamond1)
        -- 赠送随机图腾碎片
        game_playerinfo:rewardstotem(steam_id, 1, prize_list)
    end
    if passlevel==1 then
        -- 奖励钻石
        local Diamond1 = RandomInt(6000, 9000)
        local Diamond2 = RandomInt(9000, 15000)
        game_playerinfo:rewardsDiamond(steam_id, Diamond1, prize_list)
        game_playerinfo:rewardsDiamond(steam_id, Diamond2, prize_list)
        local KillDiamond1 = 0
        local KillDiamond2 = 0
        if global_var_func.killde_final_boss then
            KillDiamond1 = RandomInt(13000, 16000)
            KillDiamond2 = RandomInt(5000, 8000)
            game_playerinfo:rewardsDiamond(steam_id, KillDiamond1, prize_list)
            game_playerinfo:rewardsDiamond(steam_id, KillDiamond2, prize_list)
            game_playerinfo:rewardsHappyNewYearBag(steam_id, 1, prize_list, store_item)
        end
        rdDiamond = (Diamond1 + Diamond2)+(KillDiamond1 + KillDiamond2)
        game_playerinfo:change_player_result(steam_id, "score", rdDiamond)
        game_playerinfo:update_score(playerID, rdDiamond)
        -- 奖励神之遗物经验
        local Exp1 = RandomInt(40, 80)
        game_playerinfo:rewardsrelicsExp(steam_id, math.floor(Exp1*(1+(game_playerinfo:get_dynamic_properties(steam_id).extra_universal_exp or 0))), prize_list)
    elseif passlevel==2 then
        -- 奖励钻石
        local Diamond1 = RandomInt(9000, 15000)
        local Diamond2 = RandomInt(12000, 15000)
        game_playerinfo:rewardsDiamond(steam_id, Diamond1, prize_list)
        game_playerinfo:rewardsDiamond(steam_id, Diamond2, prize_list)
        local KillDiamond1 = 0
        local KillDiamond2 = 0
        local KillDiamond3 = 0
        if global_var_func.killde_final_boss then
            KillDiamond1 = RandomInt(23000, 26000)
            KillDiamond2 = RandomInt(5000, 8000)
            KillDiamond3 = RandomInt(1000, 3000)
            game_playerinfo:rewardsDiamond(steam_id, KillDiamond1, prize_list)
            game_playerinfo:rewardsDiamond(steam_id, KillDiamond2, prize_list)
            game_playerinfo:rewardsDiamond(steam_id, KillDiamond3, prize_list)
            game_playerinfo:rewardsHappyNewYearBag(steam_id, 1, prize_list, store_item)
        end
        rdDiamond = (Diamond1 + Diamond2)+(KillDiamond1 + KillDiamond2 + KillDiamond3)
        game_playerinfo:change_player_result(steam_id, "score", rdDiamond)
        game_playerinfo:update_score(playerID, rdDiamond)

        -- 奖励神之遗物经验
        local Exp1 = RandomInt(40, 80)
        local Exp2 = RandomInt(20, 40)
        game_playerinfo:rewardsrelicsExp(steam_id, math.floor(Exp1*(1+(game_playerinfo:get_dynamic_properties(steam_id).extra_universal_exp or 0))), prize_list)
        game_playerinfo:rewardsrelicsExp(steam_id, math.floor(Exp2*(1+(game_playerinfo:get_dynamic_properties(steam_id).extra_universal_exp or 0))), prize_list)
    elseif passlevel==3 then
        -- 奖励钻石
        local Diamond1 = RandomInt(15000, 21000)
        local Diamond2 = RandomInt(12000, 15000)
        game_playerinfo:rewardsDiamond(steam_id, Diamond1, prize_list)
        game_playerinfo:rewardsDiamond(steam_id, Diamond2, prize_list)
        local KillDiamond1 = 0
        local KillDiamond2 = 0
        local KillDiamond3 = 0
        local KillDiamond4 = 0
        if global_var_func.killde_final_boss then
            KillDiamond1 = RandomInt(33000, 36000)
            KillDiamond2 = RandomInt(5000, 8000)
            KillDiamond3 = RandomInt(1000, 3000)
            KillDiamond4 = RandomInt(5000, 9000)
            game_playerinfo:rewardsDiamond(steam_id, KillDiamond1, prize_list)
            game_playerinfo:rewardsDiamond(steam_id, KillDiamond2, prize_list)
            game_playerinfo:rewardsDiamond(steam_id, KillDiamond3, prize_list)
            game_playerinfo:rewardsDiamond(steam_id, KillDiamond4, prize_list)
            game_playerinfo:rewardsHappyNewYearBag(steam_id, 1, prize_list, store_item)
        end
        rdDiamond = (Diamond1 + Diamond2)+(KillDiamond1 + KillDiamond2 + KillDiamond3 + KillDiamond4)
        game_playerinfo:change_player_result(steam_id, "score", rdDiamond)
        game_playerinfo:update_score(playerID, rdDiamond)

        -- 奖励神之遗物经验
        local Exp1 = RandomInt(40, 80)
        local Exp2 = RandomInt(20, 40)
        local Exp3 = RandomInt(1, 20)
        game_playerinfo:rewardsrelicsExp(steam_id, math.floor(Exp1*(1+(game_playerinfo:get_dynamic_properties(steam_id).extra_universal_exp or 0))), prize_list)
        game_playerinfo:rewardsrelicsExp(steam_id, math.floor(Exp2*(1+(game_playerinfo:get_dynamic_properties(steam_id).extra_universal_exp or 0))), prize_list)
        game_playerinfo:rewardsrelicsExp(steam_id, math.floor(Exp3*(1+(game_playerinfo:get_dynamic_properties(steam_id).extra_universal_exp or 0))), prize_list)
    elseif passlevel==4 then
        -- 奖励钻石
        local Diamond1 = RandomInt(21000, 27000)
        local Diamond2 = RandomInt(12000, 15000)
        game_playerinfo:rewardsDiamond(steam_id, Diamond1, prize_list)
        game_playerinfo:rewardsDiamond(steam_id, Diamond2, prize_list)
        local KillDiamond1 = 0
        local KillDiamond2 = 0
        local KillDiamond3 = 0
        local KillDiamond4 = 0
        local KillDiamond5 = 0
        if global_var_func.killde_final_boss then
            KillDiamond1 = RandomInt(43000, 46000)
            KillDiamond2 = RandomInt(5000, 8000)
            KillDiamond3 = RandomInt(1000, 3000)
            KillDiamond4 = RandomInt(9000, 11000)
            KillDiamond5 = RandomInt(5000, 9000)
            game_playerinfo:rewardsDiamond(steam_id, KillDiamond1, prize_list)
            game_playerinfo:rewardsDiamond(steam_id, KillDiamond2, prize_list)
            game_playerinfo:rewardsDiamond(steam_id, KillDiamond3, prize_list)
            game_playerinfo:rewardsDiamond(steam_id, KillDiamond4, prize_list)
            game_playerinfo:rewardsDiamond(steam_id, KillDiamond5, prize_list)
            game_playerinfo:rewardsHappyNewYearBag(steam_id, 1, prize_list, store_item)
        end
        rdDiamond = (Diamond1 + Diamond2)+(KillDiamond1 + KillDiamond2 + KillDiamond3 + KillDiamond4 + KillDiamond5)
        game_playerinfo:change_player_result(steam_id, "score", rdDiamond)
        game_playerinfo:update_score(playerID, rdDiamond)

        -- 奖励神之遗物经验
        local Exp1 = RandomInt(40, 80)
        local Exp2 = RandomInt(20, 40)
        local Exp3 = RandomInt(20, 40)
        local Exp4 = RandomInt(1, 20)
        game_playerinfo:rewardsrelicsExp(steam_id, math.floor(Exp1*(1+(game_playerinfo:get_dynamic_properties(steam_id).extra_universal_exp or 0))), prize_list)
        game_playerinfo:rewardsrelicsExp(steam_id, math.floor(Exp2*(1+(game_playerinfo:get_dynamic_properties(steam_id).extra_universal_exp or 0))), prize_list)
        game_playerinfo:rewardsrelicsExp(steam_id, math.floor(Exp3*(1+(game_playerinfo:get_dynamic_properties(steam_id).extra_universal_exp or 0))), prize_list)
        game_playerinfo:rewardsrelicsExp(steam_id, math.floor(Exp4*(1+(game_playerinfo:get_dynamic_properties(steam_id).extra_universal_exp or 0))), prize_list)
    elseif passlevel==5 then
        -- 奖励钻石
        local Diamond1 = RandomInt(27000, 33000)
        local Diamond2 = RandomInt(15000, 18000)
        game_playerinfo:rewardsDiamond(steam_id, Diamond1, prize_list)
        game_playerinfo:rewardsDiamond(steam_id, Diamond2, prize_list)
        local KillDiamond1 = 0
        local KillDiamond2 = 0
        local KillDiamond3 = 0
        local KillDiamond4 = 0
        local KillDiamond5 = 0
        local KillDiamond6 = 0
        if global_var_func.killde_final_boss then
            KillDiamond1 = RandomInt(53000, 66000)
            KillDiamond2 = RandomInt(5000, 8000)
            KillDiamond3 = RandomInt(5000, 9000)
            KillDiamond4 = RandomInt(11000, 13000)
            KillDiamond5 = RandomInt(9000, 11000)
            KillDiamond6 = RandomInt(1000, 3000)
            game_playerinfo:rewardsDiamond(steam_id, KillDiamond1, prize_list)
            game_playerinfo:rewardsDiamond(steam_id, KillDiamond2, prize_list)
            game_playerinfo:rewardsDiamond(steam_id, KillDiamond3, prize_list)
            game_playerinfo:rewardsDiamond(steam_id, KillDiamond4, prize_list)
            game_playerinfo:rewardsDiamond(steam_id, KillDiamond5, prize_list)
            game_playerinfo:rewardsDiamond(steam_id, KillDiamond6, prize_list)
            game_playerinfo:rewardsHappyNewYearBag(steam_id, 1, prize_list, store_item)
        end
        rdDiamond = (Diamond1 + Diamond2)+(KillDiamond1 + KillDiamond2 + KillDiamond3 + KillDiamond4 + KillDiamond5 + KillDiamond6)
        game_playerinfo:change_player_result(steam_id, "score", rdDiamond)
        game_playerinfo:update_score(playerID, rdDiamond)

        -- 奖励神之遗物经验
        local Exp1 = RandomInt(40, 80)
        local Exp2 = RandomInt(20, 40)
        local Exp3 = RandomInt(20, 40)
        local Exp4 = RandomInt(20, 40)
        local Exp5 = RandomInt(1, 20)
        game_playerinfo:rewardsrelicsExp(steam_id, math.floor(Exp1*(1+(game_playerinfo:get_dynamic_properties(steam_id).extra_universal_exp or 0))), prize_list)
        game_playerinfo:rewardsrelicsExp(steam_id, math.floor(Exp2*(1+(game_playerinfo:get_dynamic_properties(steam_id).extra_universal_exp or 0))), prize_list)
        game_playerinfo:rewardsrelicsExp(steam_id, math.floor(Exp3*(1+(game_playerinfo:get_dynamic_properties(steam_id).extra_universal_exp or 0))), prize_list)
        game_playerinfo:rewardsrelicsExp(steam_id, math.floor(Exp4*(1+(game_playerinfo:get_dynamic_properties(steam_id).extra_universal_exp or 0))), prize_list)
        game_playerinfo:rewardsrelicsExp(steam_id, math.floor(Exp5*(1+(game_playerinfo:get_dynamic_properties(steam_id).extra_universal_exp or 0))), prize_list)

        -- 奖励图腾碎片
        game_playerinfo:passLevelrewardstotem(steam_id, 5, prize_list)
    elseif passlevel==6 then
        -- 奖励钻石
        local Diamond1 = RandomInt(33000, 39000)
        local Diamond2 = RandomInt(18000, 21000)
        game_playerinfo:rewardsDiamond(steam_id, Diamond1, prize_list)
        game_playerinfo:rewardsDiamond(steam_id, Diamond2, prize_list)
        local KillDiamond1 = 0
        local KillDiamond2 = 0
        local KillDiamond3 = 0
        local KillDiamond4 = 0
        local KillDiamond5 = 0
        local KillDiamond6 = 0
        local KillDiamond7 = 0
        if global_var_func.killde_final_boss then
            KillDiamond1 = RandomInt(73000, 76000)
            KillDiamond2 = RandomInt(5000, 8000)
            KillDiamond3 = RandomInt(5000, 9000)
            KillDiamond4 = RandomInt(13000, 16000)
            KillDiamond5 = RandomInt(9000, 11000)
            KillDiamond6 = RandomInt(11000, 13000)
            KillDiamond7 = RandomInt(1000, 3000)
            game_playerinfo:rewardsDiamond(steam_id, KillDiamond1, prize_list)
            game_playerinfo:rewardsDiamond(steam_id, KillDiamond2, prize_list)
            game_playerinfo:rewardsDiamond(steam_id, KillDiamond3, prize_list)
            game_playerinfo:rewardsDiamond(steam_id, KillDiamond4, prize_list)
            game_playerinfo:rewardsDiamond(steam_id, KillDiamond5, prize_list)
            game_playerinfo:rewardsDiamond(steam_id, KillDiamond6, prize_list)
            game_playerinfo:rewardsDiamond(steam_id, KillDiamond7, prize_list)
            game_playerinfo:rewardsHappyNewYearBag(steam_id, 1, prize_list, store_item)
        end
        rdDiamond = (Diamond1 + Diamond2)+(KillDiamond1 + KillDiamond2 + KillDiamond3 + KillDiamond4 + KillDiamond5 + KillDiamond6 + KillDiamond7)
        game_playerinfo:change_player_result(steam_id, "score", rdDiamond)
        game_playerinfo:update_score(playerID, rdDiamond)

        -- 奖励神之遗物经验
        local Exp1 = RandomInt(40, 80)
        local Exp2 = RandomInt(20, 40)
        local Exp3 = RandomInt(20, 40)
        local Exp4 = RandomInt(20, 40)
        local Exp5 = RandomInt(20, 40)
        local Exp6 = RandomInt(1, 20)
        game_playerinfo:rewardsrelicsExp(steam_id, math.floor(Exp1*(1+(game_playerinfo:get_dynamic_properties(steam_id).extra_universal_exp or 0))), prize_list)
        game_playerinfo:rewardsrelicsExp(steam_id, math.floor(Exp2*(1+(game_playerinfo:get_dynamic_properties(steam_id).extra_universal_exp or 0))), prize_list)
        game_playerinfo:rewardsrelicsExp(steam_id, math.floor(Exp3*(1+(game_playerinfo:get_dynamic_properties(steam_id).extra_universal_exp or 0))), prize_list)
        game_playerinfo:rewardsrelicsExp(steam_id, math.floor(Exp4*(1+(game_playerinfo:get_dynamic_properties(steam_id).extra_universal_exp or 0))), prize_list)
        game_playerinfo:rewardsrelicsExp(steam_id, math.floor(Exp5*(1+(game_playerinfo:get_dynamic_properties(steam_id).extra_universal_exp or 0))), prize_list)
        game_playerinfo:rewardsrelicsExp(steam_id, math.floor(Exp6*(1+(game_playerinfo:get_dynamic_properties(steam_id).extra_universal_exp or 0))), prize_list)

        -- 奖励图腾碎片
        game_playerinfo:passLevelrewardstotem(steam_id, 6, prize_list)
    elseif passlevel==7 then
        -- 奖励钻石
        local Diamond1 = RandomInt(39000, 50000)
        local Diamond2 = RandomInt(21000, 24000)
        game_playerinfo:rewardsDiamond(steam_id, Diamond1, prize_list)
        game_playerinfo:rewardsDiamond(steam_id, Diamond2, prize_list)
        local KillDiamond1 = 0
        local KillDiamond2 = 0
        local KillDiamond3 = 0
        local KillDiamond4 = 0
        local KillDiamond5 = 0
        local KillDiamond6 = 0
        local KillDiamond7 = 0
        local KillDiamond8 = 0
        if global_var_func.killde_final_boss then
            KillDiamond1 = RandomInt(83000, 86000)
            KillDiamond2 = RandomInt(5000, 8000)
            KillDiamond3 = RandomInt(5000, 9000)
            KillDiamond4 = RandomInt(9000, 11000)
            KillDiamond5 = RandomInt(11000, 13000)
            KillDiamond6 = RandomInt(13000, 16000)
            KillDiamond7 = RandomInt(16000, 19000)
            KillDiamond8 = RandomInt(1000, 3000)
            game_playerinfo:rewardsDiamond(steam_id, KillDiamond1, prize_list)
            game_playerinfo:rewardsDiamond(steam_id, KillDiamond2, prize_list)
            game_playerinfo:rewardsDiamond(steam_id, KillDiamond3, prize_list)
            game_playerinfo:rewardsDiamond(steam_id, KillDiamond4, prize_list)
            game_playerinfo:rewardsDiamond(steam_id, KillDiamond5, prize_list)
            game_playerinfo:rewardsDiamond(steam_id, KillDiamond6, prize_list)
            game_playerinfo:rewardsDiamond(steam_id, KillDiamond7, prize_list)
            game_playerinfo:rewardsDiamond(steam_id, KillDiamond8, prize_list)
            game_playerinfo:rewardsHappyNewYearBag(steam_id, 1, prize_list, store_item)
        end
        rdDiamond = (Diamond1 + Diamond2)+(KillDiamond1 + KillDiamond2 + KillDiamond3 + KillDiamond4 + KillDiamond5 + KillDiamond6 + KillDiamond7 + KillDiamond8)
        game_playerinfo:change_player_result(steam_id, "score", rdDiamond)
        game_playerinfo:update_score(playerID, rdDiamond)

        -- 奖励神之遗物经验
        local Exp1 = RandomInt(40, 80)
        local Exp2 = RandomInt(20, 40)
        local Exp3 = RandomInt(20, 40)
        local Exp4 = RandomInt(20, 40)
        local Exp5 = RandomInt(20, 40)
        local Exp6 = RandomInt(20, 40)
        local Exp7 = RandomInt(1, 20)
        game_playerinfo:rewardsrelicsExp(steam_id, math.floor(Exp1*(1+(game_playerinfo:get_dynamic_properties(steam_id).extra_universal_exp or 0))), prize_list)
        game_playerinfo:rewardsrelicsExp(steam_id, math.floor(Exp2*(1+(game_playerinfo:get_dynamic_properties(steam_id).extra_universal_exp or 0))), prize_list)
        game_playerinfo:rewardsrelicsExp(steam_id, math.floor(Exp3*(1+(game_playerinfo:get_dynamic_properties(steam_id).extra_universal_exp or 0))), prize_list)
        game_playerinfo:rewardsrelicsExp(steam_id, math.floor(Exp4*(1+(game_playerinfo:get_dynamic_properties(steam_id).extra_universal_exp or 0))), prize_list)
        game_playerinfo:rewardsrelicsExp(steam_id, math.floor(Exp5*(1+(game_playerinfo:get_dynamic_properties(steam_id).extra_universal_exp or 0))), prize_list)
        game_playerinfo:rewardsrelicsExp(steam_id, math.floor(Exp6*(1+(game_playerinfo:get_dynamic_properties(steam_id).extra_universal_exp or 0))), prize_list)
        game_playerinfo:rewardsrelicsExp(steam_id, math.floor(Exp7*(1+(game_playerinfo:get_dynamic_properties(steam_id).extra_universal_exp or 0))), prize_list)

        -- 奖励图腾碎片
        game_playerinfo:passLevelrewardstotem(steam_id, 7, prize_list)
    else
        -- 奖励钻石
        local Diamond1 = math.floor(RandomInt(39000, 50000)*(1+(passlevel-7)*0.2))
        local Diamond2 = math.floor(RandomInt(21000, 24000)*(1+(passlevel-7)*0.2))
        game_playerinfo:rewardsDiamond(steam_id, Diamond1, prize_list)
        game_playerinfo:rewardsDiamond(steam_id, Diamond2, prize_list)
        local KillDiamond1 = 0
        local KillDiamond2 = 0
        local KillDiamond3 = 0
        local KillDiamond4 = 0
        local KillDiamond5 = 0
        local KillDiamond6 = 0
        local KillDiamond7 = 0
        local KillDiamond8 = 0
        if global_var_func.killde_final_boss then
            KillDiamond1 = math.floor(RandomInt(83000, 86000)*(1+(passlevel-7)*0.2))
            KillDiamond2 = math.floor(RandomInt(5000, 8000)*(1+(passlevel-7)*0.2))
            KillDiamond3 = math.floor(RandomInt(5000, 9000)*(1+(passlevel-7)*0.2))
            KillDiamond4 = math.floor(RandomInt(9000, 11000)*(1+(passlevel-7)*0.2))
            KillDiamond5 = math.floor(RandomInt(11000, 13000)*(1+(passlevel-7)*0.2))
            KillDiamond6 = math.floor(RandomInt(13000, 16000)*(1+(passlevel-7)*0.2))
            KillDiamond7 = math.floor(RandomInt(16000, 19000)*(1+(passlevel-7)*0.2))
            KillDiamond8 = math.floor(RandomInt(1000, 3000)*(1+(passlevel-7)*0.2))
            game_playerinfo:rewardsDiamond(steam_id, KillDiamond1, prize_list)
            game_playerinfo:rewardsDiamond(steam_id, KillDiamond2, prize_list)
            game_playerinfo:rewardsDiamond(steam_id, KillDiamond3, prize_list)
            game_playerinfo:rewardsDiamond(steam_id, KillDiamond4, prize_list)
            game_playerinfo:rewardsDiamond(steam_id, KillDiamond5, prize_list)
            game_playerinfo:rewardsDiamond(steam_id, KillDiamond6, prize_list)
            game_playerinfo:rewardsDiamond(steam_id, KillDiamond7, prize_list)
            game_playerinfo:rewardsDiamond(steam_id, KillDiamond8, prize_list)
            game_playerinfo:rewardsHappyNewYearBag(steam_id, 1, prize_list, store_item)
        end
        rdDiamond = (Diamond1 + Diamond2)+(KillDiamond1 + KillDiamond2 + KillDiamond3 + KillDiamond4 + KillDiamond5 + KillDiamond6 + KillDiamond7 + KillDiamond8)
        game_playerinfo:change_player_result(steam_id, "score", rdDiamond)
        game_playerinfo:update_score(playerID, rdDiamond)

        -- 奖励神之遗物经验
        local Exp1 = RandomInt(40, 80)*(1+(passlevel-7)*0.2)
        local Exp2 = RandomInt(20, 40)*(1+(passlevel-7)*0.2)
        local Exp3 = RandomInt(20, 40)*(1+(passlevel-7)*0.2)
        local Exp4 = RandomInt(20, 40)*(1+(passlevel-7)*0.2)
        local Exp5 = RandomInt(20, 40)*(1+(passlevel-7)*0.2)
        local Exp6 = RandomInt(20, 40)*(1+(passlevel-7)*0.2)
        local Exp7 = RandomInt(1, 20)*(1+(passlevel-7)*0.2)
        local Exp8 = RandomInt(20, 40)*(1+(passlevel-7)*0.2)
        game_playerinfo:rewardsrelicsExp(steam_id, math.floor(Exp1*(1+(game_playerinfo:get_dynamic_properties(steam_id).extra_universal_exp or 0))), prize_list)
        game_playerinfo:rewardsrelicsExp(steam_id, math.floor(Exp2*(1+(game_playerinfo:get_dynamic_properties(steam_id).extra_universal_exp or 0))), prize_list)
        game_playerinfo:rewardsrelicsExp(steam_id, math.floor(Exp3*(1+(game_playerinfo:get_dynamic_properties(steam_id).extra_universal_exp or 0))), prize_list)
        game_playerinfo:rewardsrelicsExp(steam_id, math.floor(Exp4*(1+(game_playerinfo:get_dynamic_properties(steam_id).extra_universal_exp or 0))), prize_list)
        game_playerinfo:rewardsrelicsExp(steam_id, math.floor(Exp5*(1+(game_playerinfo:get_dynamic_properties(steam_id).extra_universal_exp or 0))), prize_list)
        game_playerinfo:rewardsrelicsExp(steam_id, math.floor(Exp6*(1+(game_playerinfo:get_dynamic_properties(steam_id).extra_universal_exp or 0))), prize_list)
        game_playerinfo:rewardsrelicsExp(steam_id, math.floor(Exp7*(1+(game_playerinfo:get_dynamic_properties(steam_id).extra_universal_exp or 0))), prize_list)
        game_playerinfo:rewardsrelicsExp(steam_id, math.floor(Exp8*(1+(game_playerinfo:get_dynamic_properties(steam_id).extra_universal_exp or 0))), prize_list)

        -- 奖励图腾碎片
        game_playerinfo:passLevelrewardstotem(steam_id, passlevel, prize_list)
    end
end

-- 关卡失败奖励 
function TheGiftOfThePharaohLose(playerID, passlevel, secondtime, prize_list)
    local steam_id = PlayerResource:GetSteamAccountID(playerID)
    local rewardsExp = 0
    if global_var_func.createPlayer[playerID] then
        -- 新玩家
        -- 赠送宝物
        GiftOtherTreasures(playerID, prize_list) 
        -- 赠送10W钻石
        local Diamond1 = 100000
        game_playerinfo:rewardsDiamond(steam_id, Diamond1, prize_list)
        game_playerinfo:change_player_result(steam_id, "score", Diamond1)
        game_playerinfo:update_score(playerID, Diamond1)
        -- 赠送随机图腾碎片
        game_playerinfo:rewardstotem(steam_id, 1, prize_list)
    end
    if secondtime <= 5 then
        local Exp1 = 1
        rewardsExp = math.floor(Exp1*(1+(game_playerinfo:get_dynamic_properties(steam_id).extra_universal_exp or 0)))
        game_playerinfo:change_player_result(steam_id, "score", 0)
        -- 奖励神之遗物经验
        game_playerinfo:rewardsrelicsExp(steam_id, rewardsExp, prize_list)
    elseif secondtime >= 20 then
        local Exp1 = RandomInt(10, 30)*(1+(passlevel-1)*0.2)*(1+(math.floor((secondtime/5)+0.5)-1)*0.2)
        rewardsExp = math.floor(Exp1*(1+(game_playerinfo:get_dynamic_properties(steam_id).extra_universal_exp or 0)))
        -- 奖励神之遗物经验
        game_playerinfo:rewardsrelicsExp(steam_id, rewardsExp, prize_list)
        -- 钻石奖励 2分之一
        local rdDiamond = 0
        if passlevel==1 then
            -- 奖励钻石
            local Diamond1 = RandomInt(3000, 4500)
            local Diamond2 = RandomInt(4500, 7500)
            game_playerinfo:rewardsDiamond(steam_id, Diamond1, prize_list)
            game_playerinfo:rewardsDiamond(steam_id, Diamond2, prize_list)
            
            rdDiamond = (Diamond1 + Diamond2)
            game_playerinfo:change_player_result(steam_id, "score", rdDiamond)
            game_playerinfo:update_score(playerID, rdDiamond)
        
        elseif passlevel==2 then
            -- 奖励钻石
            local Diamond1 = RandomInt(4500, 7500)
            local Diamond2 = RandomInt(6000, 7500)
            game_playerinfo:rewardsDiamond(steam_id, Diamond1, prize_list)
            game_playerinfo:rewardsDiamond(steam_id, Diamond2, prize_list)
            
            rdDiamond = (Diamond1 + Diamond2)
            game_playerinfo:change_player_result(steam_id, "score", rdDiamond)
            game_playerinfo:update_score(playerID, rdDiamond)
        elseif passlevel==3 then
            -- 奖励钻石
            local Diamond1 = RandomInt(7500, 10500)
            local Diamond2 = RandomInt(6000, 7500)
            game_playerinfo:rewardsDiamond(steam_id, Diamond1, prize_list)
            game_playerinfo:rewardsDiamond(steam_id, Diamond2, prize_list)
            
            rdDiamond = (Diamond1 + Diamond2)
            game_playerinfo:change_player_result(steam_id, "score", rdDiamond)
            game_playerinfo:update_score(playerID, rdDiamond)
        elseif passlevel==4 then
            -- 奖励钻石
            local Diamond1 = RandomInt(10500, 13500)
            local Diamond2 = RandomInt(6000, 7500)
            game_playerinfo:rewardsDiamond(steam_id, Diamond1, prize_list)
            game_playerinfo:rewardsDiamond(steam_id, Diamond2, prize_list)
            
            rdDiamond = (Diamond1 + Diamond2)
            game_playerinfo:change_player_result(steam_id, "score", rdDiamond)
            game_playerinfo:update_score(playerID, rdDiamond)
        elseif passlevel==5 then
            -- 奖励钻石
            local Diamond1 = RandomInt(13500, 16500)
            local Diamond2 = RandomInt(7500, 9000)
            game_playerinfo:rewardsDiamond(steam_id, Diamond1, prize_list)
            game_playerinfo:rewardsDiamond(steam_id, Diamond2, prize_list)
            
            rdDiamond = (Diamond1 + Diamond2)
            game_playerinfo:change_player_result(steam_id, "score", rdDiamond)
            game_playerinfo:update_score(playerID, rdDiamond)
        elseif passlevel==6 then
            -- 奖励钻石
            local Diamond1 = RandomInt(16500, 19500)
            local Diamond2 = RandomInt(9000, 10500)
            game_playerinfo:rewardsDiamond(steam_id, Diamond1, prize_list)
            game_playerinfo:rewardsDiamond(steam_id, Diamond2, prize_list)
            
            rdDiamond = (Diamond1 + Diamond2)
            game_playerinfo:change_player_result(steam_id, "score", rdDiamond)
            game_playerinfo:update_score(playerID, rdDiamond)
        elseif passlevel==7 then
            -- 奖励钻石
            local Diamond1 = RandomInt(19500, 25000)
            local Diamond2 = RandomInt(10500, 12000)
            game_playerinfo:rewardsDiamond(steam_id, Diamond1, prize_list)
            game_playerinfo:rewardsDiamond(steam_id, Diamond2, prize_list)
            
            rdDiamond = (Diamond1 + Diamond2)
            game_playerinfo:change_player_result(steam_id, "score", rdDiamond)
            game_playerinfo:update_score(playerID, rdDiamond)
        else
            -- 无尽难度
            -- 奖励钻石
            local Diamond1 = math.floor(RandomInt(19500, 25000)*(1+(passlevel-7)*0.2))
            local Diamond2 = math.floor(RandomInt(10500, 12000)*(1+(passlevel-7)*0.2))
            game_playerinfo:rewardsDiamond(steam_id, Diamond1, prize_list)
            game_playerinfo:rewardsDiamond(steam_id, Diamond2, prize_list)
            
            rdDiamond = (Diamond1 + Diamond2)
            game_playerinfo:change_player_result(steam_id, "score", rdDiamond)
            game_playerinfo:update_score(playerID, rdDiamond)
        end
        -- 宝物书奖励
        if passlevel>=4 then
            if RollPercentage(5) then
                -- 难4以上
                GiftHardOtherTreasures(playerID, prize_list)
            end
            if RollPercentage(5) then
                -- 难4以上
                GiftOtherTreasures(playerID, prize_list)
            end
        else
            if RollPercentage(5) then
                -- 难以下
                GiftOtherTreasures(playerID, prize_list) 
            end
        end
    else
        local Exp1 = RandomInt(10, 30)*(1+(passlevel-1)*0.2)*(1+(math.floor((secondtime/5)+0.5)-1)*0.2)
        rewardsExp = math.floor(Exp1*(1+(game_playerinfo:get_dynamic_properties(steam_id).extra_universal_exp or 0)))
        -- 奖励神之遗物经验
        game_playerinfo:rewardsrelicsExp(steam_id, rewardsExp, prize_list)

        -- 钻石奖励 4分之一
        local rdDiamond = 0
        if passlevel==1 then
            -- 奖励钻石
            local Diamond1 = RandomInt(600, 900)
            local Diamond2 = RandomInt(900, 1500)
            game_playerinfo:rewardsDiamond(steam_id, Diamond1, prize_list)
            game_playerinfo:rewardsDiamond(steam_id, Diamond2, prize_list)
            
            rdDiamond = (Diamond1 + Diamond2)
            game_playerinfo:change_player_result(steam_id, "score", rdDiamond)
            game_playerinfo:update_score(playerID, rdDiamond)
        
        elseif passlevel==2 then
            -- 奖励钻石
            local Diamond1 = RandomInt(900, 1500)
            local Diamond2 = RandomInt(1200, 1500)
            game_playerinfo:rewardsDiamond(steam_id, Diamond1, prize_list)
            game_playerinfo:rewardsDiamond(steam_id, Diamond2, prize_list)
            
            rdDiamond = (Diamond1 + Diamond2)
            game_playerinfo:change_player_result(steam_id, "score", rdDiamond)
            game_playerinfo:update_score(playerID, rdDiamond)
        elseif passlevel==3 then
            -- 奖励钻石
            local Diamond1 = RandomInt(1500, 2100)
            local Diamond2 = RandomInt(1200, 1500)
            game_playerinfo:rewardsDiamond(steam_id, Diamond1, prize_list)
            game_playerinfo:rewardsDiamond(steam_id, Diamond2, prize_list)
            
            rdDiamond = (Diamond1 + Diamond2)
            game_playerinfo:change_player_result(steam_id, "score", rdDiamond)
            game_playerinfo:update_score(playerID, rdDiamond)
        elseif passlevel==4 then
            -- 奖励钻石
            local Diamond1 = RandomInt(2100, 2700)
            local Diamond2 = RandomInt(1200, 1500)
            game_playerinfo:rewardsDiamond(steam_id, Diamond1, prize_list)
            game_playerinfo:rewardsDiamond(steam_id, Diamond2, prize_list)
            
            rdDiamond = (Diamond1 + Diamond2)
            game_playerinfo:change_player_result(steam_id, "score", rdDiamond)
            game_playerinfo:update_score(playerID, rdDiamond)
        elseif passlevel==5 then
            -- 奖励钻石
            local Diamond1 = RandomInt(2700, 3300)
            local Diamond2 = RandomInt(1500, 1800)
            game_playerinfo:rewardsDiamond(steam_id, Diamond1, prize_list)
            game_playerinfo:rewardsDiamond(steam_id, Diamond2, prize_list)
            
            rdDiamond = (Diamond1 + Diamond2)
            game_playerinfo:change_player_result(steam_id, "score", rdDiamond)
            game_playerinfo:update_score(playerID, rdDiamond)
        elseif passlevel==6 then
            -- 奖励钻石
            local Diamond1 = RandomInt(3300, 3900)
            local Diamond2 = RandomInt(1800, 2100)
            game_playerinfo:rewardsDiamond(steam_id, Diamond1, prize_list)
            game_playerinfo:rewardsDiamond(steam_id, Diamond2, prize_list)
            
            rdDiamond = (Diamond1 + Diamond2)
            game_playerinfo:change_player_result(steam_id, "score", rdDiamond)
            game_playerinfo:update_score(playerID, rdDiamond)
        elseif passlevel==7 then
            -- 奖励钻石
            local Diamond1 = RandomInt(3900, 5000)
            local Diamond2 = RandomInt(2100, 2400)
            game_playerinfo:rewardsDiamond(steam_id, Diamond1, prize_list)
            game_playerinfo:rewardsDiamond(steam_id, Diamond2, prize_list)
            
            rdDiamond = (Diamond1 + Diamond2)
            game_playerinfo:change_player_result(steam_id, "score", rdDiamond)
            game_playerinfo:update_score(playerID, rdDiamond)
        else
            -- 无尽难度
            -- 奖励钻石
            local Diamond1 = math.floor(RandomInt(3900, 5000)*(1+(passlevel-7)*0.2))
            local Diamond2 = math.floor(RandomInt(2100, 2400)*(1+(passlevel-7)*0.2))
            game_playerinfo:rewardsDiamond(steam_id, Diamond1, prize_list)
            game_playerinfo:rewardsDiamond(steam_id, Diamond2, prize_list)
            
            rdDiamond = (Diamond1 + Diamond2)
            game_playerinfo:change_player_result(steam_id, "score", rdDiamond)
            game_playerinfo:update_score(playerID, rdDiamond)
        end
        -- 宝物书奖励
        if passlevel>=4 then
            if RollPercentage(3) then
                -- 难4以上
                GiftHardOtherTreasures(playerID, prize_list)
            end
            if RollPercentage(3) then
                -- 难4以上
                GiftOtherTreasures(playerID, prize_list)
            end
        else
            if RollPercentage(3) then
                -- 难以下
                GiftOtherTreasures(playerID, prize_list) 
            end
        end
    end
end

-- 奖励额外的宝物卡
function GiftOtherTreasures(playerID, prize_list)
    local card_name = treasuresystem:DropOtherTreasures()
    -- 添加到卡池
    local addTreasureIndex = treasuresystem:get_treasure_id(card_name)
    treasuresystem:update_treasureinarchive_byID(playerID, addTreasureIndex, 1)

    local sendtable = {}
    table.insert(sendtable, card_name)
    table.insert(sendtable, 1)

    table.insert(prize_list, sendtable)
end

-- 奖励高难度额外的宝物卡
function GiftHardOtherTreasures(playerID, prize_list)
    local card_name = treasuresystem:DropHardOtherTreasures()
    -- 添加到卡池
    local addTreasureIndex = treasuresystem:get_treasure_id(card_name)
    treasuresystem:update_treasureinarchive_byID(playerID, addTreasureIndex, 1)

    local sendtable = {}
    table.insert(sendtable, card_name)
    table.insert(sendtable, 1)

    table.insert(prize_list, sendtable)
end