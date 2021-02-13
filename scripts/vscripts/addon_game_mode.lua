require("custom_event_listen")
require("config/config_enum")
require("global/global_var_func")
require("global/modifier_link")
require("global/modifier_treasure_link")
require("global/timer")
require("rules/rule_unit_spawn")
require("rules/rule_boss_spawn")
require("info/game_playerinfo")
require("config/config_item_drop")
require("filter/game_filter")
require('tg/tg_util/tgutil')
require('tg/util')
require('libraries/talentmanager')
require('libraries/pseudoRandom')
require('libraries/timers')
require('service/service')
local config_hero_xp = require("config/config_hero_xp")

if CAddonTemplateGameMode == nil then
	CAddonTemplateGameMode = class({})
end

function Precache( context )
	PrecacheResource( "soundfile", "soundevents/game_sounds_custom.vsndevts", context )
	PrecacheResource( "soundfile", "soundevents/imba_item_soundevents.vsndevts", context )
	PrecacheResource( "soundfile", "soundevents/imba_soundevents.vsndevts", context )
	PrecacheResource( "soundfile", "soundevents/tg_soundevents.vsndevts", context )
end

function Activate()
	GameRules.AddonTemplate = CAddonTemplateGameMode()
	GameRules.AddonTemplate:InitGameMode()
end

function CAddonTemplateGameMode:InitGameMode()
	SendToServerConsole('dota_max_physical_items_purchase_limit 9999')
	SendToServerConsole('dota_music_battle_enable 0')
	
	-- DeepPrintTable(HeroKV)
	local GameMode = GameRules:GetGameModeEntity()

	-- 设置战前准备时间
	GameRules:SetPreGameTime(9999999)

	-- 镜头距离
	-- GameRules:GetGameModeEntity():SetCameraDistanceOverride(1100)

	--惩罚时间
	GameRules:SetHeroSelectPenaltyTime(0)

	GameRules:SetCustomGameSetupAutoLaunchDelay(0)
    GameRules:SetCustomGameSetupRemainingTime(0)
    GameRules:SetCustomGameSetupTimeout(0)

	--关闭迷雾
	GameMode:SetFogOfWarDisabled(true)
	GameMode:SetUnseenFogOfWarEnabled(false)

	-- 设置起始金钱
	GameRules:SetStartingGold(99999)
	--队伍选择界面时间
	GameRules:SetCustomGameSetupAutoLaunchDelay(600)
	-- 载入界面
	GameRules:SetShowcaseTime(0)

	--策略时间
	GameRules:SetStrategyTime(0)

	--取消背包移出cd
	GameMode:SetCustomBackpackSwapCooldown(0)

	--关闭DOTA2原版属性影响
	GameMode: SetCustomAttributeDerivedStatValue(DOTA_ATTRIBUTE_STRENGTH_DAMAGE, 0)
    GameMode: SetCustomAttributeDerivedStatValue(DOTA_ATTRIBUTE_STRENGTH_HP, 0)
    GameMode: SetCustomAttributeDerivedStatValue(DOTA_ATTRIBUTE_STRENGTH_HP_REGEN, 0.00001)
    GameMode: SetCustomAttributeDerivedStatValue(DOTA_ATTRIBUTE_AGILITY_DAMAGE, 0)
    GameMode: SetCustomAttributeDerivedStatValue(DOTA_ATTRIBUTE_AGILITY_ARMOR, 0)
    GameMode: SetCustomAttributeDerivedStatValue(DOTA_ATTRIBUTE_AGILITY_ATTACK_SPEED, 0)
    GameMode: SetCustomAttributeDerivedStatValue(DOTA_ATTRIBUTE_INTELLIGENCE_DAMAGE, 0)
    GameMode: SetCustomAttributeDerivedStatValue(DOTA_ATTRIBUTE_INTELLIGENCE_MANA, 0)
	GameMode: SetCustomAttributeDerivedStatValue(DOTA_ATTRIBUTE_INTELLIGENCE_MANA_REGEN, 0.00001)
	--设置战争迷雾
	
	GameMode:SetUnseenFogOfWarEnabled(true)

	--注册filter
	GameMode: SetExecuteOrderFilter(Dynamic_Wrap(Filter,"ExecuteOrderFilter"),Filter)
	GameMode: SetDamageFilter(Dynamic_Wrap(Filter,"DamageFilter"),Filter)

	-- 设置战斗双方玩家数量
	GameRules:SetCustomGameTeamMaxPlayers( DOTA_TEAM_GOODGUYS, 4 )
	GameRules:SetCustomGameTeamMaxPlayers( DOTA_TEAM_BADGUYS, 0 )
	
	-- 设置默认游戏难度
	GameRules:SetCustomGameDifficulty(1)

	-- 启动刷怪
	rule_unit_spawn: Start()

	--	初始化掉落配置
	config_item_drop:init()

	--加载监听
	self.custom_listen = CustomListen()
	self.custom_listen:init()
	GameMode:SetThink( "OnThink", self, "GlobalThink", 2 )

	-- 修改买活
	GameMode:SetCustomBuybackCooldownEnabled(true)
	GameMode:SetCustomBuybackCostEnabled(true)
	GameMode:SetLoseGoldOnDeath(false)  -- 设置禁用死亡掉落金钱

	-- 关闭英雄被击杀瓜分赏金的信息
	GameMode:SetHudCombatEventsDisabled(true)

	--设置英雄
	GameMode:SetCustomGameForceHero("npc_dota_hero_crystal_maiden")

	--加载物品kv
	GameMode.ItemKVs = LoadKeyValues("scripts/npc/npc_items_custom.txt")
	GameRules.HeroKV = LoadKeyValues("scripts/npc/npc_heroes_custom.txt")
	GameMode.UnitKV = LoadKeyValues("scripts/npc/npc_units_custom.txt")
	Service:init()

	-- 自定义英雄经验槽
	GameRules:GetGameModeEntity():SetCustomXPRequiredToReachNextLevel(config_hero_xp)
	GameRules:GetGameModeEntity():SetUseCustomHeroLevels(true)
end


local save_time = global_var_func:GloFunc_Getgame_enum().SAVE_FIRST_TIME
local map_exp_time = global_var_func:GloFunc_Getgame_enum().MAP_EXP_FIRST_TIME
-- local event_space = global_var_func:GloFunc_Getgame_enum().RANDOM_EVENT_SPACE_TIME
function CAddonTemplateGameMode:OnThink()
	local time = GameRules:GetDOTATime(false, false)
	if time >= save_time then
		-- save_time = save_time + global_var_func:GloFunc_Getgame_enum().SAVE_SPACE_TIME
		-- local player_count = global_var_func.all_player_amount
		-- for playerid = 0, player_count-1 do
		-- 	local steam_id =  PlayerResource:GetSteamAccountID(playerid)
		-- 	local hero_name = PlayerResource:GetSelectedHeroName(playerid)
		-- 	-- game_playerinfo:update_hero_exp(steam_id, global_var_func:gethero_index_by_name(hero_name), global_var_func:GloFunc_Getgame_enum().HERO_EXP_INCRE*(GameRules:GetCustomGameDifficulty()+1) * global_var_func.hero_exp_rate)
			
		-- 	-- game_playerinfo:change_player_result(steam_id, "heroExp", global_var_func:GloFunc_Getgame_enum().HERO_EXP_INCRE * global_var_func.hero_exp_rate)

		-- 	local hero = PlayerResource:GetPlayer(playerid):GetAssignedHero()
		-- 	hero:AddNewModifier(hero, nil, "modifier_get_exp_lua", { duration = 5 })
		-- end
	end
	if time >= map_exp_time then
		map_exp_time = map_exp_time + global_var_func:GloFunc_Getgame_enum().MAP_EXP_SPACE_TIME
		local player_count = global_var_func.all_player_amount
		for playerid = 0, player_count-1 do
			if not global_var_func.player_base_info[playerid] then
				global_var_func.player_base_info[playerid] = {}
				global_var_func.player_base_info[playerid]["steam_id"] = 0
				global_var_func.player_base_info[playerid]["heroname"] = ""
			end
			local steam_id =  global_var_func.player_base_info[playerid]["steam_id"]
			if steam_id~=0 then
				game_playerinfo:update_map_exp(steam_id, global_var_func:GloFunc_Getgame_enum().MAP_EXP_INCRE * global_var_func.map_exp_rate)
				game_playerinfo:change_player_result(steam_id, "mapExp", global_var_func:GloFunc_Getgame_enum().MAP_EXP_INCRE * global_var_func.map_exp_rate)
			end
		end
	end
	-- if time >= event_space then
		-- event_space = event_space + global_var_func:GloFunc_Getgame_enum().RANDOM_EVENT_SPACE_TIME
		-- global_var_func.treasure_round = global_var_func.treasure_round + 1
		-- local player_count = global_var_func.all_player_amount
		-- for playerid = 0, player_count-1 do
		-- 	CustomGameEventManager:Send_ServerToPlayer(PlayerResource:GetPlayer(playerid),"show_treasure_select",{})
		-- end
	-- end

	if GameRules:State_Get() == DOTA_GAMERULES_STATE_GAME_IN_PROGRESS then
	elseif GameRules:State_Get() >= DOTA_GAMERULES_STATE_POST_GAME then
		return nil
	end
	return 1
end

function CAddonTemplateGameMode:OnEntityKilled(event)
	
end

function IsValidAlive(entity)
    return entity and IsValidEntity(entity) and not entity:IsNull() and entity:IsAlive()
end