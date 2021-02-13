require("herolist")
require("global/global_var_func")
require("info/game_playerinfo")
require("rules/rule_boss_spawn")

if herosublimesys == nil then
    herosublimesys = class({})
end

local sublimeMaterialList = {
        "itemAdvancedMaterialsZhui",
        "itemAdvancedMaterialsEyes",
        "itemAdvancedMaterialsTianping",
        "itemAdvancedMaterialsKey",
        "itemAdvancedMaterialsChochma",
        "itemAdvancedMaterialsCane",
        "itemAdvancedMaterialsJewelry",
}

local sublimegroup = {
    -- {
    --     -- 测试材料需求,不要材料
    --     ["itemAdvancedMaterialsZhui"] = 0,
    --     ["itemAdvancedMaterialsEyes"] = 0,
    --     ["itemAdvancedMaterialsTianping"] = 0,
    --     ["itemAdvancedMaterialsKey"] = 0,
    --     ["itemAdvancedMaterialsChochma"] = 0,
    --     ["itemAdvancedMaterialsCane"] = 0,
    --     ["itemAdvancedMaterialsJewelry"] = 0,
    -- },
    {
        -- 总共要6个材料
        ["itemAdvancedMaterialsZhui"] = 10,
        ["itemAdvancedMaterialsEyes"] = 10,
        ["itemAdvancedMaterialsTianping"] = 10,
        ["itemAdvancedMaterialsKey"] = 10,
        ["itemAdvancedMaterialsChochma"] = 10,
        ["itemAdvancedMaterialsCane"] = 10,
        ["itemAdvancedMaterialsJewelry"] = 0,
    },
    {
        -- 总共要6个材料
        ["itemAdvancedMaterialsZhui"] = 10,
        ["itemAdvancedMaterialsEyes"] = 10,
        ["itemAdvancedMaterialsTianping"] = 10,
        ["itemAdvancedMaterialsKey"] = 10,
        ["itemAdvancedMaterialsChochma"] = 10,
        ["itemAdvancedMaterialsCane"] = 0,
        ["itemAdvancedMaterialsJewelry"] = 10,
    },
    {
        -- 总共要6个材料
        ["itemAdvancedMaterialsZhui"] = 10,
        ["itemAdvancedMaterialsEyes"] = 10,
        ["itemAdvancedMaterialsTianping"] = 10,
        ["itemAdvancedMaterialsKey"] = 10,
        ["itemAdvancedMaterialsChochma"] = 0,
        ["itemAdvancedMaterialsCane"] = 10,
        ["itemAdvancedMaterialsJewelry"] = 10,
    },
    {
        -- 总共要6个材料
        ["itemAdvancedMaterialsZhui"] = 10,
        ["itemAdvancedMaterialsEyes"] = 10,
        ["itemAdvancedMaterialsTianping"] = 10,
        ["itemAdvancedMaterialsKey"] = 0,
        ["itemAdvancedMaterialsChochma"] = 10,
        ["itemAdvancedMaterialsCane"] = 10,
        ["itemAdvancedMaterialsJewelry"] = 10,
    },
    {
        -- 总共要6个材料
        ["itemAdvancedMaterialsZhui"] = 10,
        ["itemAdvancedMaterialsEyes"] = 10,
        ["itemAdvancedMaterialsTianping"] = 0,
        ["itemAdvancedMaterialsKey"] = 10,
        ["itemAdvancedMaterialsChochma"] = 10,
        ["itemAdvancedMaterialsCane"] = 10,
        ["itemAdvancedMaterialsJewelry"] = 10,
    },
    {
        -- 总共要6个材料
        ["itemAdvancedMaterialsZhui"] = 10,
        ["itemAdvancedMaterialsEyes"] = 0,
        ["itemAdvancedMaterialsTianping"] = 10,
        ["itemAdvancedMaterialsKey"] = 10,
        ["itemAdvancedMaterialsChochma"] = 10,
        ["itemAdvancedMaterialsCane"] = 10,
        ["itemAdvancedMaterialsJewelry"] = 10,
    },
    {
        -- 总共要6个材料
        ["itemAdvancedMaterialsZhui"] = 0,
        ["itemAdvancedMaterialsEyes"] = 10,
        ["itemAdvancedMaterialsTianping"] = 10,
        ["itemAdvancedMaterialsKey"] = 10,
        ["itemAdvancedMaterialsChochma"] = 10,
        ["itemAdvancedMaterialsCane"] = 10,
        ["itemAdvancedMaterialsJewelry"] = 10,
    },
    {
        -- 总共要6个材料
        ["itemAdvancedMaterialsZhui"] = 20,
        ["itemAdvancedMaterialsEyes"] = 20,
        ["itemAdvancedMaterialsTianping"] = 20,
        ["itemAdvancedMaterialsKey"] = 0,
        ["itemAdvancedMaterialsChochma"] = 0,
        ["itemAdvancedMaterialsCane"] = 0,
        ["itemAdvancedMaterialsJewelry"] = 0,
    },
    {
        -- 总共要6个材料
        ["itemAdvancedMaterialsZhui"] = 0,
        ["itemAdvancedMaterialsEyes"] = 20,
        ["itemAdvancedMaterialsTianping"] = 20,
        ["itemAdvancedMaterialsKey"] = 20,
        ["itemAdvancedMaterialsChochma"] = 0,
        ["itemAdvancedMaterialsCane"] = 0,
        ["itemAdvancedMaterialsJewelry"] = 0,
    },
    {
        -- 总共要6个材料
        ["itemAdvancedMaterialsZhui"] = 0,
        ["itemAdvancedMaterialsEyes"] = 0,
        ["itemAdvancedMaterialsTianping"] = 20,
        ["itemAdvancedMaterialsKey"] = 20,
        ["itemAdvancedMaterialsChochma"] = 20,
        ["itemAdvancedMaterialsCane"] = 0,
        ["itemAdvancedMaterialsJewelry"] = 0,
    },
    {
        -- 总共要6个材料
        ["itemAdvancedMaterialsZhui"] = 0,
        ["itemAdvancedMaterialsEyes"] = 0,
        ["itemAdvancedMaterialsTianping"] = 0,
        ["itemAdvancedMaterialsKey"] = 20,
        ["itemAdvancedMaterialsChochma"] = 20,
        ["itemAdvancedMaterialsCane"] = 20,
        ["itemAdvancedMaterialsJewelry"] = 0,
    },
    {
        -- 总共要6个材料
        ["itemAdvancedMaterialsZhui"] = 0,
        ["itemAdvancedMaterialsEyes"] = 0,
        ["itemAdvancedMaterialsTianping"] = 0,
        ["itemAdvancedMaterialsKey"] = 0,
        ["itemAdvancedMaterialsChochma"] = 20,
        ["itemAdvancedMaterialsCane"] = 20,
        ["itemAdvancedMaterialsJewelry"] = 20,
    },
}

local HeroNeedMaterials = { 
    ["npc_dota_hero_alchemist"] = 1,
    ["npc_dota_hero_rattletrap"] = 2,
    ["npc_dota_hero_keeper_of_the_light"] = 3,
    ["npc_dota_hero_void_spirit"] = 4,
    ["npc_dota_hero_chen"] = 5,
    ["npc_dota_hero_tinker"] = 6,
    ["npc_dota_hero_ancient_apparition"] = 7,
    ["npc_dota_hero_huskar"] = 8,
    ["npc_dota_hero_storm_spirit"] = 9,
    ["npc_dota_hero_lina"] = 10,
    ["npc_dota_hero_wisp"] = 1,
    ["npc_dota_hero_chaos_knight"] = 12,
    ["npc_dota_hero_nyx_assassin"] = 11,
    ["npc_dota_hero_drow_ranger"] = 10,
    ["npc_dota_hero_windrunner"] = 9,
    ["npc_dota_hero_bounty_hunter"] = 8,
    ["npc_dota_hero_antimage"] = 7,
    ["npc_dota_hero_gyrocopter"] = 6,
    ["npc_dota_hero_monkey_king"] = 5,
    ["npc_dota_hero_nevermore"] = 4,
    ["npc_dota_hero_pudge"] = 3,
    ["npc_dota_hero_arc_warden"] = 2,
    ["npc_dota_hero_tusk"] = 1,
    ["npc_dota_hero_centaur"] = 2,
    ["npc_dota_hero_broodmother"] = 3,
    ["npc_dota_hero_phantom_assassin"] = 4,
    ["npc_dota_hero_techies"] = 5,
    ["npc_dota_hero_necrolyte"] = 6,
    ["npc_dota_hero_dragon_knight"] = 7,
    ["npc_dota_hero_bristleback"] = 8,
    ["npc_dota_hero_axe"] = 9,
    ["npc_dota_hero_elder_titan"] = 9,
    ["npc_dota_hero_beastmaster"] = 10,
    ["npc_dota_hero_zuus"] = 11,
    ["npc_dota_hero_witch_doctor"] = 12,
    ["npc_dota_hero_warlock"] = 11,
    ["npc_dota_hero_viper"] = 10,
    ["npc_dota_hero_venomancer"] = 9,
    ["npc_dota_hero_ursa"] = 8,
    ["npc_dota_hero_undying"] = 7,
    ["npc_dota_hero_lycan"] = 6,
    ["npc_dota_hero_treant"] = 5,
    ["npc_dota_hero_tiny"] = 4,
    ["npc_dota_hero_tidehunter"] = 3,
    ["npc_dota_hero_terrorblade"] = 2,
    ["npc_dota_hero_templar_assassin"] = 1,
    ["npc_dota_hero_sven"] = 1,
    ["npc_dota_hero_ogre_magi"] = 2,
    ["npc_dota_hero_meepo"] = 3,
    ["npc_dota_hero_slardar"] = 11,
    ["npc_dota_hero_visage"] = 4,
    ["npc_dota_hero_bane"] = 5,
    ["npc_dota_hero_batrider"] = 6,
    ["npc_dota_hero_weaver"] = 7,
    ["npc_dota_hero_vengefulspirit"] = 8,
    ["npc_dota_hero_troll_warlord"] = 9,
    ["npc_dota_hero_spirit_breaker"] = 10,
    ["npc_dota_hero_spectre"] = 11,
    ["npc_dota_hero_enchantress"] = 1,
    ["npc_dota_hero_shredder"] = 2,
    ["npc_dota_hero_omniknight"] = 3,
    ["npc_dota_hero_abaddon"] = 4,
    ["npc_dota_hero_skeleton_king"] = 5,
    ["npc_dota_hero_razor"] = 6,
    ["npc_dota_hero_riki"] = 7,
    ["npc_dota_hero_phoenix"] = 4,
    ["npc_dota_hero_life_stealer"] = 1,
    ["npc_dota_hero_earth_spirit"] = 5,
  }

-- 响应英雄升华
function herosublimesys:Onherosublime(playerID, heroName)
    -- print("=====>>>>>>>>> heroName: "..heroName)
    local steam_id = PlayerResource:GetSteamAccountID(playerID)
    local hero = PlayerResource:GetPlayer(playerID):GetAssignedHero()
    local Groupindex = HeroNeedMaterials[heroName]
    local heroIndex = global_var_func:gethero_index_by_name(heroName)
    local MaterialsTab = sublimegroup[Groupindex]
    local result = true
    local playerinfo = game_playerinfo:get_player_info()[steam_id]
    -- DeepPrintTable(playerinfo)
    for key, value in pairs(MaterialsTab) do
        -- print("============== key: "..key)
        if playerinfo[key] < value then
            send_error_tip(playerID,"error_nomaterials")
            result = false
            break
        end
        if playerinfo.hero_level[heroIndex] < 10 then
            send_error_tip(playerID,"error_nolevel")
            result = false
            break
        end
    end
    
    if result then
        -- 替换技能操作
        local innate_ability = hero:GetAbilityByIndex(0)
        local abilityName = innate_ability:GetAbilityName()
        -- print("============== abilityName: "..abilityName)
        if string.find(abilityName, "sublime_") then
            send_error_tip(playerID,"error_Norepetition")
            return
        end
        local newabilityName = "sublime_"..abilityName
        local new_ability = hero:AddAbility(newabilityName)
        if new_ability then
            new_ability:SetLevel(1)
            hero:SwapAbilities(newabilityName, abilityName, true, false)
            hero:RemoveAbility(abilityName)
            playerinfo.hero_sublime[heroIndex] = playerinfo.hero_sublime[heroIndex] + 1  -- 记录升华次数
            for key, value in pairs(MaterialsTab) do
                playerinfo[key] = playerinfo[key] - value
            end
            hero:EmitSound("game.shixue")
            hero:SetModelScale(hero:GetModelScale() + 0.5)
            local nFXIndex = ParticleManager:CreateParticle( "particles/ambient/abilty1.vpcf", PATTACH_ABSORIGIN_FOLLOW, hero )
            ParticleManager:SetParticleControl( nFXIndex, 1, Vector( 0, 0, 0 ) )
            -- hero:AddParticle( nFXIndex, false, false, -1, false, false )
            game_playerinfo:save_archiveby_playerid(playerID)
        else
            send_error_tip(playerID,"error_heronoskill")
            return false
        end
    end
    return result
end

-- 宝物卡直接升华
function herosublimesys:Treasureherosublime(playerID, heroName)
    -- print("=====>>>>>>>>> heroName: "..heroName)
    local steam_id = PlayerResource:GetSteamAccountID(playerID)
    local hero = PlayerResource:GetPlayer(playerID):GetAssignedHero()
    local heroIndex = global_var_func:gethero_index_by_name(heroName)
    
    -- local playerinfo = game_playerinfo:get_player_info()[steam_id]
    -- DeepPrintTable(playerinfo)

    -- 替换技能操作
    local innate_ability = hero:GetAbilityByIndex(0)
    local abilityName = innate_ability:GetAbilityName()
    -- print("============== abilityName: "..abilityName)
    if string.find(abilityName, "sublime_") then
        send_error_tip(playerID,"error_Norepetition")
        return
    end
    local newabilityName = "sublime_"..abilityName
    local new_ability = hero:AddAbility(newabilityName)
    if new_ability then
        new_ability:SetLevel(1)
        hero:SwapAbilities(newabilityName, abilityName, true, false)
        hero:RemoveAbility(abilityName)
        -- playerinfo.hero_sublime[heroIndex] = playerinfo.hero_sublime[heroIndex] + 1  -- 记录升华次数
        
        hero:EmitSound("game.shixue")
        hero:SetModelScale(hero:GetModelScale() + 0.5)
        local nFXIndex = ParticleManager:CreateParticle( "particles/ambient/abilty1.vpcf", PATTACH_ABSORIGIN_FOLLOW, hero )
        ParticleManager:SetParticleControl( nFXIndex, 1, Vector( 0, 0, 0 ) )
        -- hero:AddParticle( nFXIndex, false, false, -1, false, false )
        -- game_playerinfo:save_archiveby_playerid(playerID)
    else
        send_error_tip(playerID,"error_heronoskill")
    end
end

-- 永久升华
function herosublimesys:Foreverherosublime(playerID, heroName)
    local steam_id = PlayerResource:GetSteamAccountID(playerID)
    local playerinfo = game_playerinfo:get_player_info()[steam_id]
    -- DeepPrintTable(playerinfo)
    local hero = PlayerResource:GetPlayer(playerID):GetAssignedHero()
    local self_ability = hero:GetAbilityByIndex(0)
	local self_abilityName = self_ability:GetAbilityName()
	local heroIndex = global_var_func:gethero_index_by_name(heroName)
	if playerinfo.hero_sublime[heroIndex] >= 5 then
		local newabilityName = "sublime_"..self_abilityName
		local new_ability = hero:AddAbility(newabilityName)
		if new_ability then
			new_ability:SetLevel(1)
			hero:SwapAbilities(newabilityName, self_abilityName, true, false)
			hero:RemoveAbility(self_abilityName)
            return true
		end
    end
    return false
end

-- BOSS召唤相关材料
local callBossmaterials = {
    {
        -- 总共要10个材料
        ["itemCallMaterialsLefthand"] = 2,
        ["itemCallMaterialsRighthand"] = 2,
        ["itemCallMaterialsEyes"] = 2,
        ["itemCallMaterialsSoul"] = 2,
        ["itemCallMaterialsHeart"] = 2,
    },
    {
        -- 总共要10个材料
        ["itemCallMaterialsLefthand"] = 3,
        ["itemCallMaterialsRighthand"] = 2,
        ["itemCallMaterialsEyes"] = 2,
        ["itemCallMaterialsSoul"] = 2,
        ["itemCallMaterialsHeart"] = 1,
    },
    {
        -- 总共要10个材料
        ["itemCallMaterialsLefthand"] = 1,
        ["itemCallMaterialsRighthand"] = 3,
        ["itemCallMaterialsEyes"] = 2,
        ["itemCallMaterialsSoul"] = 2,
        ["itemCallMaterialsHeart"] = 2,
    },
    {
        -- 总共要10个材料
        ["itemCallMaterialsLefthand"] = 2,
        ["itemCallMaterialsRighthand"] = 1,
        ["itemCallMaterialsEyes"] = 3,
        ["itemCallMaterialsSoul"] = 2,
        ["itemCallMaterialsHeart"] = 2,
    },
    {
        -- 总共要10个材料
        ["itemCallMaterialsLefthand"] = 2,
        ["itemCallMaterialsRighthand"] = 2,
        ["itemCallMaterialsEyes"] = 1,
        ["itemCallMaterialsSoul"] = 3,
        ["itemCallMaterialsHeart"] = 2,
    },
    {
        -- 总共要10个材料
        ["itemCallMaterialsLefthand"] = 2,
        ["itemCallMaterialsRighthand"] = 2,
        ["itemCallMaterialsEyes"] = 2,
        ["itemCallMaterialsSoul"] = 1,
        ["itemCallMaterialsHeart"] = 3,
    },
}

local BossNeedMaterials = { 
    {["name"] = "boss_god_metal",["needindex"] = 1},
    {["name"] = "boss_god_wood",["needindex"] = 1},
    {["name"] = "boss_god_water",["needindex"] = 1},
    {["name"] = "boss_god_fire",["needindex"] = 1},
    {["name"] = "boss_god_earth",["needindex"] = 1},
}

-- 响应BOSS召唤
function herosublimesys:OnCallBoss(playerID)
    local needtable = BossNeedMaterials[RandomInt(1, #BossNeedMaterials)]
    local bossName = needtable.name
    local steam_id = PlayerResource:GetSteamAccountID(playerID)
    -- local hero = PlayerResource:GetPlayer(playerID):GetAssignedHero()
    local MaterialsTab = callBossmaterials[needtable.needindex]
    local result = true
    local playerinfo = game_playerinfo:get_player_info()[steam_id]
    for key, value in pairs(MaterialsTab) do
        if playerinfo[key] < value then
            result = false
        end
    end
    
    if result then
        -- 召唤BOSS bossName
        -- rule_boss_spawn: SpawnWorldBoss(bossName)
        send_tips_message(playerID, "成功召唤远古神灵")
        for key, value in pairs(MaterialsTab) do
            playerinfo[key] = playerinfo[key] - value
        end
        game_playerinfo:save_archiveby_playerid(playerID)
    end
    
    return result
end

function herosublimesys:getCallBossmaterials()
    return callBossmaterials[1]
end

function herosublimesys:sublimeNeedMaterials(heroName)
    return sublimegroup[HeroNeedMaterials[heroName]]
end

function herosublimesys:GetSublimeMaterialList()
    return sublimeMaterialList
end

function herosublimesys:get_store_item_info(steam_id)
    local playerinfo = game_playerinfo:get_player_info()[steam_id]
	local ck_data_sh = {}
	local ck_data_zh = {}
	ck_data_zh["itemCallMaterialsLefthand"] = playerinfo["itemCallMaterialsLefthand"]
	ck_data_zh["itemCallMaterialsRighthand"] = playerinfo["itemCallMaterialsRighthand"]
	ck_data_zh["itemCallMaterialsEyes"] = playerinfo["itemCallMaterialsEyes"]
	ck_data_zh["itemCallMaterialsSoul"] = playerinfo["itemCallMaterialsSoul"]
	ck_data_zh["itemCallMaterialsHeart"] = playerinfo["itemCallMaterialsHeart"]

	ck_data_sh["itemAdvancedMaterialsZhui"] = playerinfo["itemAdvancedMaterialsZhui"]
	ck_data_sh["itemAdvancedMaterialsEyes"] = playerinfo["itemAdvancedMaterialsEyes"]
	ck_data_sh["itemAdvancedMaterialsTianping"] = playerinfo["itemAdvancedMaterialsTianping"]
	ck_data_sh["itemAdvancedMaterialsKey"] = playerinfo["itemAdvancedMaterialsKey"]
	ck_data_sh["itemAdvancedMaterialsChochma"] = playerinfo["itemAdvancedMaterialsChochma"]
	ck_data_sh["itemAdvancedMaterialsCane"] = playerinfo["itemAdvancedMaterialsCane"]
	ck_data_sh["itemAdvancedMaterialsJewelry"] = playerinfo["itemAdvancedMaterialsJewelry"]
	return ck_data_sh,ck_data_zh
end