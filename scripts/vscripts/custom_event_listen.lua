require("items/lua_items_ability/item_ability")
require("items/lua_items/item_shop")
require("http_request/shop_request")
require("info/game_playerinfo")
require("info/custom_thinker")
require("tower/tower_system")
require("herosublime/herosublimesys")
require("examsystem/examsystem")
require("treasuresystem/treasuresystem")
local config_random_ability = require("ability/config_random_ability")

if CustomListen == nil then
    CustomListen = class({})
end

-- local hero_table = {}		-- 玩家基础属性记录

function CustomListen:init()
	ListenToGameEvent("dota_item_picked_up",Dynamic_Wrap(CustomListen,'item_pickup'),self)
	ListenToGameEvent("game_rules_state_change",Dynamic_Wrap(CustomListen,'game_state_change'),self)
	ListenToGameEvent("entity_killed",Dynamic_Wrap(common_item_ability,'add_property_item'),self)
	ListenToGameEvent("dota_player_killed",Dynamic_Wrap(CustomListen,'hero_death'),self)
	-- ListenToGameEvent("dota_item_purchased",Dynamic_Wrap(CustomListen,'hero_buy_item'),self)
	ListenToGameEvent("player_team" ,Dynamic_Wrap(CustomListen,"change_player_team"),self)
	ListenToGameEvent("dota_player_pick_hero", Dynamic_Wrap(CustomListen, "OnHeroPicked"), self)
	ListenToGameEvent("npc_spawned", Dynamic_Wrap(CustomListen, "on_npc_spawned"), self)
	ListenToGameEvent('player_disconnect', Dynamic_Wrap(CustomListen, 'OnPlayerDisconnected'), self)
    ListenToGameEvent('player_reconnected', Dynamic_Wrap(CustomListen, 'OnPlayerReconnected'), self)
	ListenToGameEvent("player_chat", Dynamic_Wrap(CustomListen, "on_player_chated"), self)
	-- ListenToGameEvent("dota_player_used_ability",Dynamic_Wrap(CustomListen,'used_ability'),self)
	ListenToGameEvent("dota_player_gained_level",Dynamic_Wrap(CustomListen,'hero_level_up'),self)

	CustomGameEventManager:RegisterListener("buy_custom_item",Dynamic_Wrap(item_shop,'shopping'))
	CustomGameEventManager:RegisterListener("request_player_selected_hero",Dynamic_Wrap(CustomListen,'selected_hero'))
	-- CustomGameEventManager:RegisterListener("repick_hero",Dynamic_Wrap(CustomListen,'repick_hero'))
	CustomGameEventManager:RegisterListener("create_random_hero_data",Dynamic_Wrap(CustomListen,'random_hero'))
	CustomGameEventManager:RegisterListener("choice_game_level", Dynamic_Wrap(CustomListen,'choice_game_level'))
	CustomGameEventManager:RegisterListener("treasure_selected", Dynamic_Wrap(CustomListen,'OnAddTreasure'))  -- 选择宝物
	CustomGameEventManager:RegisterListener("courier_send_item", Dynamic_Wrap(CustomListen,'courier_send_item'))
	CustomGameEventManager:RegisterListener("customBuyBack", Dynamic_Wrap(CustomListen,'hero_buyback'))
	CustomGameEventManager:RegisterListener("levelup_economic", Dynamic_Wrap(CustomListen,'levelup_economic'))
	CustomGameEventManager:RegisterListener("ui_get_hero_list", Dynamic_Wrap(CustomListen,'ui_get_hero_list'))
	CustomGameEventManager:RegisterListener("ui_heromap_levelup_hero", Dynamic_Wrap(CustomListen,'ui_heromap_levelup_hero'))
	CustomGameEventManager:RegisterListener("request_cangku_data", Dynamic_Wrap(CustomListen,'request_cangku_data'))
	CustomGameEventManager:RegisterListener("take_out_from_store", Dynamic_Wrap(CustomListen,'take_out_from_store'))
	-- CustomGameEventManager:RegisterListener("request_call_boss", Dynamic_Wrap(CustomListen,'request_call_boss'))
	CustomGameEventManager:RegisterListener("request_sublime", Dynamic_Wrap(CustomListen,'request_sublime'))
	CustomGameEventManager:RegisterListener("request_shenghua_data", Dynamic_Wrap(CustomListen,'request_shenghua_data'))
	CustomGameEventManager:RegisterListener("update_player_difficulty_select", Dynamic_Wrap(CustomListen,'update_player_difficulty_select'))
	CustomGameEventManager:RegisterListener("lock_difficulty_select", Dynamic_Wrap(CustomListen,'lock_difficulty_select'))
	CustomGameEventManager:RegisterListener("exam_select_answer", Dynamic_Wrap(examsystem,'CallExamAnswer'))
	CustomGameEventManager:RegisterListener("request_player_data", Dynamic_Wrap(game_playerinfo,'OnPlayerData'))  -- 请求玩家信息
	-- 宝物系统注册函数
	CustomGameEventManager:RegisterListener("request_set_roundtreasure", Dynamic_Wrap(treasuresystem,'set_roundtreasure'))  -- 设置上场宝物
	CustomGameEventManager:RegisterListener("request_del_roundtreasure", Dynamic_Wrap(treasuresystem,'del_roundtreasure'))  -- 取消上场宝物
	CustomGameEventManager:RegisterListener("request_clearcollocation", Dynamic_Wrap(treasuresystem,'Onclearcollocation'))  -- 清空配置宝物
	CustomGameEventManager:RegisterListener("request_resetcollocation", Dynamic_Wrap(treasuresystem,'Onresetcollocation'))  -- 重设配置宝物
	CustomGameEventManager:RegisterListener("request_lock_select", Dynamic_Wrap(treasuresystem,'OnLockSelect'))  -- 锁定设置界面
	-- 神之遗物升级
	CustomGameEventManager:RegisterListener("request_equipment_data", Dynamic_Wrap(game_playerinfo,'OnGodEquipmentData'))  -- 请求神之遗物信息
	CustomGameEventManager:RegisterListener("request_lvup_godequipment", Dynamic_Wrap(game_playerinfo,'OnLevelUpGodEquipment'))  -- 神之遗物升级
	-- 输入内测验证码
	CustomGameEventManager:RegisterListener("request_write_test_password", Dynamic_Wrap(game_playerinfo,'OnWriteTestPassword'))  -- 输入内测验证码
	-- 使用商城道具
	CustomGameEventManager:RegisterListener("request_used_shop_goods", Dynamic_Wrap(game_playerinfo,'OnUsedShopGoods'))  -- 
	-- 开启宝箱
	CustomGameEventManager:RegisterListener("request_open_box", Dynamic_Wrap(game_playerinfo,'OnOpenBox'))  -- 
	-- 领取通关奖励
	CustomGameEventManager:RegisterListener("request_collect_rewards", Dynamic_Wrap(game_playerinfo,'OnCollectRewards'))  -- 
	-- 领取月卡奖励
	CustomGameEventManager:RegisterListener("request_monthcard_rewards", Dynamic_Wrap(game_playerinfo,'OnMonthcardRewards'))  -- 
	-- 领取地图等级奖励
	CustomGameEventManager:RegisterListener("request_maplevel_rewards", Dynamic_Wrap(game_playerinfo,'OnMaplevelRewards'))  -- 
	-- 超负荷
	CustomGameEventManager:RegisterListener("request_overload", Dynamic_Wrap(rule_unit_spawn,'RequestOverload'))
	-- 召唤BOSS
	CustomGameEventManager:RegisterListener("request_call_boss", Dynamic_Wrap(rule_unit_spawn,'RequestCallBoss'))
	-- 获取商店物品列表
	CustomGameEventManager:RegisterListener("request_player_shop_items", Dynamic_Wrap(CustomListen,'RequestPlayerShopItems'))

	CustomGameEventManager:RegisterListener("request_totem_data", Dynamic_Wrap(game_playerinfo,'OnTotemData'))  -- 请求图腾信息
	CustomGameEventManager:RegisterListener("request_lvup_totem", Dynamic_Wrap(game_playerinfo,'OnLevelUpTotem'))  -- 图腾升级
	CustomGameEventManager:RegisterListener("request_fusion_totem", Dynamic_Wrap(game_playerinfo,'OnFusionTotem'))  -- 图腾融合
end

-- local is_select_hero = {}
-- local random_data = {player_0 = {"npc_dota_hero_luna", "npc_dota_hero_bristleback", "npc_dota_hero_kunkka"}}
local random_data = {}
-- 游戏状态切换的逻辑判断
function CustomListen:game_state_change(evt)
	local game_state = GameRules:State_Get()
	local GameMode = GameRules:GetGameModeEntity()
	--加载英雄技能数据
	random_data["hero_ability_list"] = global_var_func:get_hero_ability()
	local playercount = global_var_func.all_player_amount
	if game_state ==DOTA_GAMERULES_STATE_GAME_IN_PROGRESS then 
		global_var_func.current_game_step = DOTA_GAME_STEP_GENERAL
		for i = 0, playercount-1 do
			--没有选择英雄则指定一个英雄
			if not global_var_func.is_select_hero["player_"..i] then 
				if not global_var_func.select_heroname[i] then
					global_var_func.select_heroname[i] = random_data["player_"..i][2]
					game_playerinfo:init_treasure_select_tab(i)
					-- 初始化定时器
					-- custom_thinker:init_after_select_hero()
					CustomGameEventManager:Send_ServerToPlayer(PlayerResource:GetPlayer(i),"close_select_hero_panel",{})
					--初始化英雄召唤单位信息
				end
				set_item(player_id,global_var_func.select_heroname[player_id])
			end
		end
		--开门
		StopGlobalSound("game.beginbgm")
		EmitGlobalSound("game.opendoor")
		CreateModifierThinker( nil, nil, "modifier_backround_music", {}, Vector(0, 0, 0), 1, false )
		for i = 1 ,4 do 
			local doorName = "door0"..i
			local lgName = "door00"..i.."c"
			local door1 = Entities:FindByName(nil,doorName)
			local lg = Entities:FindByName(nil,lgName)
			local v = door1:GetOrigin(  )
			door1:SetContextThink(DoUniqueString("open_the_door"), function ()
				v.z = v.z -5 
				door1 : SetOrigin(v)
				if v.z < -400 then 
					lg:Trigger(nil,nil)
					return nil
				end
				return 0.01
			end, 0)
		end
		if global_var_func.isbeginexam == 1 then
			-- 开启考试系统
			examsystem:InitExamSystem()
		end
	end
	if DOTA_GAMERULES_STATE_PRE_GAME == game_state then
		-- global_var_func.all_player_amount = PlayerResource:GetPlayerCount()
		if GameRules:IsCheatMode() and not IsInToolsMode() then
			GameRules:MakeTeamLose(global_var_func:GloFunc_Getgame_enum().TEAM_TH);
		end
		StopGlobalSound("game.loading")
		EmitGlobalSound("game.beginbgm")
		game_playerinfo:init_statistics()
		GameMode:SetAnnouncerDisabled( true )
		-- CustomGameEventManager:Send_ServerToAllClients("deadline_and_difficulty_event",{
			
		-- })
		
		-- 上限统计
		CountDeadLine()
		-- -- 金字塔上升
		local lg = Entities:FindByName(nil,"jinzita001o")
		if lg then
			lg:Trigger(nil,nil)
		end
		-- local jinzita = Entities:FindByName(nil,"jinzita")
		-- local j_v = jinzita:GetOrigin(  )
		-- jinzita:SetContextThink(DoUniqueString("up_inzita"), function ()
		-- 	j_v.z = j_v.z + 5 
		-- 	jinzita : SetOrigin(j_v)
		-- 	if j_v.z > 512 then 
		-- 		return nil
		-- 	end
		-- 	return 0.01
		-- end, 0)
		-- local jinzita2 = Entities:FindByName(nil,"jinzita2")
		-- local j_v_2 = jinzita2:GetOrigin(  )
		-- jinzita2:SetContextThink(DoUniqueString("up_inzita_2"), function ()
		-- 	j_v_2.z = j_v_2.z + 5 
		-- 	jinzita2 : SetOrigin(j_v_2)
		-- 	if j_v_2.z > 260 then 
		-- 		return nil
		-- 	end
		-- 	return 0.01
		-- end, 0)

		-- for i=0, playercount - 1 do
		-- 	--初始化金钱
		-- 	CustomNetTables:SetTableValue("gold_table","gold_"..i,{["gold_"..i] = 2000})
		-- end
	end
	--初始化商店
	if game_state == DOTA_GAMERULES_STATE_TEAM_SHOWCASE then 
		local itemkv = GameMode.ItemKVs
		-- local wood_shop = global_var_func.custom_shop_item
		-- local gold_shop = global_var_func.custom_gold_shop_item
		local shop_item = global_var_func.custom_shop_item
		local select_difficulty = GameRules:GetCustomGameDifficulty()
		if select_difficulty >= 5 then
			local new_book = {
				"item_book_chaos_d",
				"item_book_chaos_c",
				"item_book_chaos_b",
				"item_book_chaos_a",
			}
			for i = 1, #new_book do
				table.insert(shop_item, new_book[i])
			end
		end
		if select_difficulty > 7 then
			table.insert(shop_item, "item_custom_talent_call")
		end
		--初始化商店物品
		local selectDif = GameRules:GetCustomGameDifficulty()

		for k,v in pairs(itemkv) do 
		   if type(v) == "table" then
				for wk,wv in pairs(shop_item) do
					if wv and wv == k then
						local ItemCost = v.ItemCost or 0
						local ItemWoodCost = v.ItemWoodCost or 0
						local PurchaseCoolDown = v.PurchaseCoolDown or -1
						local PurchaseStartCoolDown = v.PurchaseStartCoolDown or -1
						local ItemPurchasable = v.ItemPurchasable or 1
						if k == "item_custom_gold_call" or k=="item_custom_yanmo_call" or k == "item_custom_ore_call" then
							local dlevel = GameRules:GetCustomGameDifficulty()
							if dlevel >= 7 then
								dlevel = 7
							end
							PurchaseCoolDown = PurchaseCoolDown - 10 * (dlevel-1)
						end
						global_var_func.shop_item_init[k] = {ItemWoodCost,ItemCost,PurchaseCoolDown,PurchaseStartCoolDown,ItemPurchasable}
						for i=0,playercount-1 do
							if PurchaseStartCoolDown > 0 then
								global_var_func.shop_item_cooldown["player"..i][k] = PurchaseStartCoolDown
							end
							global_var_func.player_shop_item["player"..i][k] = {ItemWoodCost,ItemCost,PurchaseCoolDown,PurchaseStartCoolDown,ItemPurchasable}
						end
						break
					end
				end
			end
		end
		--初始化
		if playercount == 1 then
			print("nadu >>>>>"..GameRules:GetCustomGameDifficulty())
			if GameRules:GetCustomGameDifficulty() > 7 then

			end
			treasuresystem:set_stay_time(-1)
		end
		for i=0,playercount-1 do

			-- 发送宝物数据
			treasuresystem:sendTreasureData2client(i)
		end
		Timers(function()
			if treasuresystem:reduce_stay_time() == 0 then
				if treasuresystem:get_gamestart_time() == 10 then
					CustomGameEventManager:Send_ServerToAllClients("response_close_select_card",{time = treasuresystem:get_stay_time()})
					tower_system:init_tower()
					--初始化boss冷却
					local boss_init_cd = {}
					for i = 0, playercount-1 do
						set_item(i,global_var_func.select_heroname[i])
						local table_key = "item_cancer_call_"..i
						boss_init_cd[table_key] = 60
						CustomNetTables:SetTableValue("boss_cool_down","boss_cool_down",boss_init_cd)

						if GameRules:GetCustomGameDifficulty() == 1 then
							-- 难度1,全随机模式
							-- treasuresystem:clearcollocation(player_id, 1)
							treasuresystem:initround_random(i)
						else
							-- 根据配置自动填充
							treasuresystem:random_filler(i)
							game_playerinfo:save_treasures(i)
						end
						local player = PlayerResource:GetPlayer(i)
						if player:IsNull() then
							break
						end
						local nhero = player:GetAssignedHero()
						-- local butian_modif = nhero:FindModifierByName("modifier_butian_kongdong_lua")
						-- if butian_modif then
						-- 	butian_modif:SetStackCount(0)
						-- end
						nhero:AddNewModifier(nil, nil, "modifier_create_hero_lua", {})

						-- 判断宝物池里是否有相应宝物,给与相应属性加成
						local steamID = PlayerResource:GetSteamAccountID(i)
						local selected_hero = PlayerResource:GetSelectedHeroEntity(i)
						local money_num = 0
						local zl_num = 0
						local ll_num = 0
						local sl_num = 0
						--富二代增加1000金币
						if treasuresystem:check_treasures_name(i, "modifier_treasure_smallmoney") then
							game_playerinfo:set_player_gold(i, 1000)
							money_num = money_num + 1
						end
						--大富翁增加1500金币
						if treasuresystem:check_treasures_name(i, "modifier_treasure_moremoney") then
							game_playerinfo:set_player_gold(i, 1500)
							money_num = money_num + 1
						end
						--G胖的钱包增加2000金币
						if treasuresystem:check_treasures_name(i, "modifier_treasure_gfatmoney") then
							game_playerinfo:set_player_gold(i, 2000)
							money_num = money_num + 1
						end
						--同时拥有3个加金币宝物时，额外增加3000金币
						if money_num >= 3 then
							game_playerinfo:set_player_gold(i, 3000)
						end
						--蛮荒之力增加20点力量
						if treasuresystem:check_treasures_name(i, "modifier_treasure_mhzl") then
							game_playerinfo:set_dynamic_properties(steamID, "add_strength", 20)
							zl_num = zl_num + 1
						end
						--雷霆之力增加20点敏捷
						if treasuresystem:check_treasures_name(i, "modifier_treasure_ltzl") then
							game_playerinfo:set_dynamic_properties(steamID, "add_agility", 20)
							zl_num = zl_num + 1
						end
						--虚无之力增加20点智力
						if treasuresystem:check_treasures_name(i, "modifier_treasure_xwzl") then
							game_playerinfo:set_dynamic_properties(steamID, "add_intellect", 20)
							zl_num = zl_num + 1
						end
						--同时拥有3个XX之力宝物时，额外增加6%的属性
						if zl_num >= 3 then
							game_playerinfo:set_dynamic_properties(steamID, "add_strength", selected_hero:GetBaseStrength()*0.06)
							game_playerinfo:set_dynamic_properties(steamID, "add_agility", selected_hero:GetBaseAgility()*0.06)
							game_playerinfo:set_dynamic_properties(steamID, "add_intellect", selected_hero:GetBaseIntellect()*0.06)
						end
						--蛮荒灵力增加30点力量
						if treasuresystem:check_treasures_name(i, "modifier_treasure_mhll") then
							game_playerinfo:set_dynamic_properties(steamID, "add_strength", 30)
							ll_num = ll_num + 1
						end
						--雷霆灵力增加30点敏捷
						if treasuresystem:check_treasures_name(i, "modifier_treasure_ltll") then
							game_playerinfo:set_dynamic_properties(steamID, "add_agility", 30)
							ll_num = ll_num + 1
						end
						--虚无灵力增加30点智力
						if treasuresystem:check_treasures_name(i, "modifier_treasure_xwll") then
							game_playerinfo:set_dynamic_properties(steamID, "add_intellect", 30)
							ll_num = ll_num + 1
						end
						--同时拥有3个XX灵力宝物时，额外增加8%的属性
						if ll_num >= 3 then
							game_playerinfo:set_dynamic_properties(steamID, "add_strength", selected_hero:GetBaseStrength()*0.08)
							game_playerinfo:set_dynamic_properties(steamID, "add_agility", selected_hero:GetBaseAgility()*0.08)
							game_playerinfo:set_dynamic_properties(steamID, "add_intellect", selected_hero:GetBaseIntellect()*0.08)
						end
						--蛮荒神力增加40点力量
						if treasuresystem:check_treasures_name(i, "modifier_treasure_mhsl") then
							game_playerinfo:set_dynamic_properties(steamID, "add_strength", 40)
							sl_num = sl_num + 1
						end
						--雷霆神力增加40点敏捷
						if treasuresystem:check_treasures_name(i, "modifier_treasure_ltsl") then
							game_playerinfo:set_dynamic_properties(steamID, "add_agility", 40)
							sl_num = sl_num + 1
						end
						--虚无神力增加40点智力
						if treasuresystem:check_treasures_name(i, "modifier_treasure_xwsl") then
							game_playerinfo:set_dynamic_properties(steamID, "add_intellect", 40)
							sl_num = sl_num + 1
						end
						--同时拥有3个XX神力宝物时，额外增加10%的属性
						if sl_num >= 3 then
							game_playerinfo:set_dynamic_properties(steamID, "add_strength", selected_hero:GetBaseStrength()*0.1)
							game_playerinfo:set_dynamic_properties(steamID, "add_agility", selected_hero:GetBaseAgility()*0.1)
							game_playerinfo:set_dynamic_properties(steamID, "add_intellect", selected_hero:GetBaseIntellect()*0.1)
						end
						--手动挡倒车，本宝物在宝物池中时候，开局获得1次倒车次数
						if treasuresystem:check_treasures_name(i, "modifier_treasure_back_off_a") then
							local mod_back = nhero:AddNewModifier(nhero,nil,"modifier_treasure_back_off_a",{})
							-- local nhero = self:GetParent()
							mod_back:SetStackCount(1)
							local count = mod_back:GetStackCount()
							if nhero:HasModifier("modifier_treasure_back_off_b") then
								count = count + nhero:FindModifierByName("modifier_treasure_back_off_b"):GetStackCount()
							end
							if nhero:HasModifier("modifier_treasure_back_off_c") then
								count = count + nhero:FindModifierByName("modifier_treasure_back_off_c"):GetStackCount()
							end
							CustomGameEventManager:Send_ServerToPlayer(PlayerResource:GetPlayer(mod_back:GetParent():GetPlayerID()), "response_overload", {
								stackcount = count, 
								record = global_var_func.overload_record[mod_back:GetParent():GetPlayerID() + 1],
							})
						end
						--金币怪悬赏令
						if treasuresystem:check_treasures_name(i, "modifier_treasure_goldmon_attribute_one") then
							nhero:AddNewModifier(nhero,nil,"modifier_treasure_goldmon_attribute_one",{})
						end
						--迈达斯的珍藏
						if treasuresystem:check_treasures_name(i, "modifier_treasure_midas_collection") then
							nhero:AddNewModifier(nhero,nil,"modifier_treasure_midas_collection",{})
						end
					end
					-- game_playerinfo:save_archive()
				end
				if treasuresystem:reduce_gamestart_time() == 0 then
					if global_var_func.CANRUSHMONSTER then
						GameRules:ForceGameStart()
					end
				else
					CustomGameEventManager:Send_ServerToAllClients("update_game_time",{gameTime = treasuresystem:get_gamestart_time()})
					return 1
				end
			else
				CustomGameEventManager:Send_ServerToAllClients("response_select_card_time_update",{time = treasuresystem:get_stay_time()})
				return 1
			end
		end)
		-- 启动自定义商店js监听
		local cus_shop_index = {}
		local jinzita = Vector(-1184.66,-1026.62,568.624)
		local shopVecotrs = {Vector(-1216,896,130.79),Vector(640,-1024,128),Vector(-1216,-3008,130.791),Vector(-3200,-1024,130.79)}
		for _,v in pairs(shopVecotrs) do
			local unit = CreateUnitByName("shangren",v, false, nil,nil, DOTA_TEAM_GOODGUYS)
			unit:FaceTowards(jinzita)
			unit:AddNewModifier(nil,nil,"modifier_shangren",{})
			unit:StartGesture(ACT_DOTA_IDLE)
			-- unit:StartGesture(ACT_DOTA_TAUNT)
			table.insert(cus_shop_index,unit:GetEntityIndex(  ))
		end
		global_var_func.cus_shop_index = cus_shop_index
		CustomNetTables:SetTableValue("dynamic_properties","map_info_data",{cus_shop_index = cus_shop_index,
										menu_list = global_var_func.menu_list,
										menu_body_data = global_var_func.menu_body_data,
										map_difficulty = GameRules:GetCustomGameDifficulty()})
		--初始化挂坠词条库
		for i=0,global_var_func.all_player_amount-1 do
			global_var_func.player_random_properties["player"..i] = game_playerinfo:get_player_random_properties()
		end
		custom_thinker:init_at_pre_game()
		custom_thinker:init_after_select_hero()
	end
	if DOTA_GAMERULES_STATE_CUSTOM_GAME_SETUP == game_state then
		-- 记录玩家数量
		global_var_func.all_player_amount = PlayerResource:GetPlayerCount()
		shop_request:load_shop_list()
		EmitGlobalSound("game.loading")
		local gold_table = {}
		local wood_table = {}
		
		for i = 0, global_var_func.all_player_amount-1 do
			local player = PlayerResource:GetPlayer(i)
			-- local select_hero = player:GetAssignedHero()
			if player then
				PlayerResource:SetCustomTeamAssignment(i, DOTA_TEAM_GOODGUYS)
			end
			local intgold = 2000
			local intwood = 0
			gold_table["gold_"..i] = intgold
			wood_table["wood_"..i] = intwood
			CustomNetTables:SetTableValue("gold_table","gold_"..i,gold_table)
			CustomNetTables:SetTableValue("wood_table","wood_table",wood_table)

			-- 添加图腾每秒加钱
			-- select_hero:AddNewModifier(select_hero, nil, "modifier_addgold_second_lua", {})
		end
	end

	
end

function CustomListen:change_player_team(evt)
	-- local player_count = global_var_func.all_player_amount
	-- for i = 0, player_count-1 do
	-- 	local steam_id = PlayerResource:GetSteamAccountID(i)
	-- 	-- 读取玩家的数据
	-- 	local player_info = game_playerinfo:get_player_info()
	-- 	if not player_info[steam_id] then
	-- 		game_request:Load(steam_id)
	-- 	end
	-- end
	-- game_request:test()
	-- DeepPrintTable(evt)
	-- global_var_func.all_player_amount = global_var_func.all_player_amount
	-- if evt.userid > 0 then
	-- print(" >>>>>>>>>>>>>>>>>>>>>> GetPlayerCount: "..PlayerResource:GetPlayerCount())
	-- global_var_func.all_player_amount = PlayerResource:GetPlayerCount()
	-- local steamID = PlayerResource:GetSteamAccountID(evt.userid - 1)
	-- if not game_playerinfo:hasplayerinfo(steamID) then
	-- 	Service:LoadPlayerProfile(nPlayerID)
	-- 	Service:LoadPlayerGoods(nPlayerID)
	-- end
end


--随机英雄选项
function CustomListen:random_hero(evt)
	local player_id = evt.PlayerID
	local steam_id = PlayerResource:GetSteamAccountID(player_id)
	local key = "player_"..player_id
	print(global_var_func.is_select_hero[key])
	if global_var_func.is_select_hero[key] and global_var_func.is_select_hero[key] ~="npc_dota_hero_crystal_maiden" then
		if evt.repick ~= 1 then -- or game_playerinfo:get_dynamic_properties_by_key(steam_id, "re_pick") ~= 1
			CustomGameEventManager:Send_ServerToPlayer(PlayerResource:GetPlayer( player_id ),"close_select_hero_panel",{reConnect=1})
			return
		end
	end
	if evt.repick == 1 then
		if game_playerinfo:get_totem_level(steam_id, "totemYx") < 0 then
			return
		end
		if global_var_func.repick_hero_count["player"..player_id] == nil then
			global_var_func.repick_hero_count["player"..player_id] = 0
		end
		if global_var_func.repick_hero_count["player"..player_id] >= global_var_func.repick_hero_limit then
			return
		end
		global_var_func.repick_hero_count["player"..player_id] = global_var_func.repick_hero_count["player"..player_id] + 1
	-- elseif random_data[key] ~= nil  then
	-- 	CustomGameEventManager:Send_ServerToPlayer(PlayerResource:GetPlayer( player_id ),"close_select_hero_panel",{reConnect=1})
	-- 	return
	end
	-- local hero_data = CustomNetTables:GetTableValue( "random_hero", "random_hero" )
	random_data[key] = global_var_func:get_rand_hero_list()
	local exp_table = {}
	for k,v in pairs(random_data[key] )  do
		local exp =  0
		local level = game_playerinfo:get_hero_level_by_name(steam_id, v)
		local need_exp = game_playerinfo:get_need_exp(level+1)
		local last_exp = game_playerinfo:get_need_exp(level)
		exp_table[key.."_"..v] = {exp,level,need_exp, last_exp}
	end
	random_data["exp_table"] = exp_table
	random_data["mapLevel"] = game_playerinfo:get_map_level_by_id(steam_id)
	random_data["player_repick"..player_id] = game_playerinfo:get_dynamic_properties_by_key(steam_id, "re_pick")
	--初始化vip信息
	-- print(" >>>>>>>>>>>>>> player_id: "..player_id)
	common_item_ability:init_vip(player_id)
	CustomGameEventManager:Send_ServerToPlayer(PlayerResource:GetPlayer(player_id),"random_hero_data",random_data)
	global_var_func.player_random_hero_data = random_data
	
end

--重随机
-- function CustomListen:repick_hero(evt)
-- 	if 2>1 then
-- 		return
-- 	end
-- 	local player_id = evt.PlayerID
-- 	local random_count = random_data["repick_"..player_id] or 0 
-- 	local steam_id = PlayerResource:GetSteamAccountID(player_id)
-- 	local re_pick = 0
-- 	if random_count <= re_pick then 
-- 		local key = "player_"..player_id
-- 		random_data["repick_"..player_id] = random_count + 1
-- 		local hero_list = global_var_func:get_rand_hero_list()
-- 		random_data[key] = hero_list
-- 		local player = PlayerResource:GetPlayer(player_id)
-- 		local exp_table = {}
-- 		for k,v in pairs(hero_list)  do
-- 			local exp =  0
-- 			local level = game_playerinfo:get_hero_level_by_name(steam_id, v)
-- 			local need_exp = game_playerinfo:get_need_exp(level+1)
-- 			local last_exp = game_playerinfo:get_need_exp(level)
-- 			exp_table[key.."_"..v] = {exp,level,need_exp, last_exp}
-- 		end
-- 		random_data["exp_table"] = exp_table
-- 		random_data["mapLevel"] = game_playerinfo:get_map_level_by_id(steam_id)
-- 		CustomGameEventManager:Send_ServerToPlayer(player,"refresh_choose_panel",random_data )
-- 		global_var_func.player_random_hero_data = random_data
-- 	end
-- end


--选定英雄
function CustomListen:selected_hero(evt)
	local player_id = evt.PlayerID
	local hero_name = evt.hero_name
	local key = "player_"..player_id
	if global_var_func.is_select_hero[key] ~= nil then
		return
	end
	for _,v in pairs(random_data[key]) do
		if hero_name == v then
			global_var_func.is_select_hero[key]= v
			break
		end
	end
	if global_var_func.is_select_hero[key] == nil then
		global_var_func.is_select_hero[key] = random_data[key][2]
		hero_name = random_data[key][2]
	end
	if not global_var_func.select_heroname[player_id] then
		global_var_func.select_heroname[player_id] = hero_name
		game_playerinfo:init_treasure_select_tab(player_id)
		-- 初始化定时器
		-- custom_thinker:init_after_select_hero()
		CustomGameEventManager:Send_ServerToPlayer(PlayerResource:GetPlayer(player_id),"close_select_hero_panel",{})
		--初始化英雄召唤单位信息
	end
	-- set_item(player_id,global_var_func.select_heroname[player_id])
	CountDeadLine()
end

-- 指定英雄物品
function set_item(player_id,hero_name)
	local player = PlayerResource:GetPlayer( player_id )
	if not player then 
		return
	end
	-- game_playerinfo:init_treasure_select_tab(player_id)
	---------------------------- 本地联机,调试代码
	-- if player_id > 0 then	---------------------------------------------------
	-- 	local nHero = CreateHeroForPlayer("npc_dota_hero_crystal_maiden", player)	---------------------------------------------------
	-- 	player:SetAssignedHeroEntity(nHero)	---------------------------------------------------
	-- 	PlayerResource:SetCustomTeamAssignment(player_id, DOTA_TEAM_GOODGUYS)
	-- 	local gold_table = {}
	-- 	local wood_table = CustomNetTables:GetTableValue("wood_table","wood_table")
	-- 	local intgold = 2000
	-- 	local intwood = 0
	-- 	gold_table["gold_"..player_id] = intgold
	-- 	wood_table["wood_"..player_id] = intwood
	-- 	CustomNetTables:SetTableValue("gold_table","gold_"..player_id,gold_table)
	-- 	CustomNetTables:SetTableValue("wood_table","wood_table",wood_table)
	-- end
	---------------------------- 本地联机,调试代码
	local old_hero = player:GetAssignedHero()
	-- print(" >>>>>>>>>>>>>>>> old_hero: "..old_hero:GetUnitName())	---------------------------------------------------
	if old_hero == nil then 
		return
	end
	local hero = PlayerResource:ReplaceHeroWith(player_id,hero_name,99999,0)
	UTIL_Remove( old_hero )
	if hero_name == "npc_dota_hero_grimstroke" then
		global_var_func.isbeginexam = 1
	end
	-- local hero = EntIndexToHScript(evt.heroindex )
	PlayerResource:SetCustomBuybackCost(player_id, 5000)
	PlayerResource:SetCustomBuybackCooldown(player_id, 0)
	local steam_id = PlayerResource:GetSteamAccountID(player_id)
	-- print(" global_var_func.all_player_amount: "..global_var_func.all_player_amount)
	-- 读取玩家的数据
	-- local player_info = game_playerinfo:get_player_info()
	-- if not player_info[steam_id] then
    --     game_request:Load(steam_id, hero)
	-- end
	-- game_playerinfo:update_vip_properties(steam_id, hero)
	-- game_playerinfo:update_maplv_properties(steam_id, hero)
	-- game_playerinfo:update_herolv_properties(steam_id, hero_name, hero)
	
	-- 领取补偿
	game_playerinfo:get_compensation(player_id)
	-- -- 永久升华判定
	-- if not herosublimesys:Foreverherosublime(player_id, hero_name) then
	-- 	local sublime_ability = hero:GetAbilityByIndex(0)
	-- 	sublime_ability:SetLevel(1)
	-- end
	init_player_base_info(player_id, steam_id, hero_name)
	local sublime_ability = hero:GetAbilityByIndex(0)
	sublime_ability:SetLevel(1)

	local self_ability = hero:GetAbilityByIndex(1)
	self_ability:SetLevel(1)

	self_ability = hero:GetAbilityByIndex(2)
	self_ability:SetLevel(1)

	self_ability = hero:GetAbilityByIndex(3)
	self_ability:SetLevel(1)

	self_ability = hero:GetAbilityByIndex(4)
	self_ability:SetLevel(1)

	self_ability = hero:GetAbilityByIndex(5)
	self_ability:SetLevel(1)

	self_ability = hero:GetAbilityByIndex(6)
	self_ability:SetLevel(1)

	-- local ability = hero:AddAbility("go_back")
	-- ability:SetLevel(1)
	-- hero:AddNewModifier(nil, nil, "modifier_create_hero_lua", {})
	local attacktype = hero:IsRangedAttacker()
	if attacktype then
		hero:AddNewModifier(hero, nil, "modifier_rangesound_lua", {})
	else
		hero:AddNewModifier(hero, nil, "modifier_meleesound_lua", {})
	end
	-- local ability = hero:AddAbility("passive_pillage_lua_e")
	-- ability:SetLevel(1)
	
	-- 经济来源
	hero:AddNewModifier(hero, nil, "modifier_base_get_gold", nil)
	-- 添加图腾每秒加钱
	hero:AddNewModifier(hero, nil, "modifier_addgold_second_lua", {})
	-- 添加物理穿甲
	hero:AddNewModifier(hero, nil, "modifier_physics_piercing_lua", {count = game_playerinfo:get_dynamic_properties_by_key(steam_id, "physics_piercing"),})
	-- 属性显示面板
	hero:AddNewModifier(hero, nil, "modifier_show_properties_lua", {})
	-- 杀戮之心
	hero:AddNewModifier(hero, nil, "modifier_killing_heart", nil)
	-- 初始化图腾套装属性
	game_playerinfo:InitMaxLevelTotemAttribute(player_id)

	game_playerinfo:set_player_gold(player_id,game_playerinfo:get_dynamic_properties_by_key(steam_id, "extra_begin_golds"))
	game_playerinfo:change_player_wood(hero,game_playerinfo:get_dynamic_properties_by_key(steam_id, "extra_begin_wood"))
	-- hero:AddNewModifier(hero, nil, "modifier_shalu_lua", {})
	-- hero:AddNewModifier(hero, nil, "modifier_maoyi_lua", {})
	-- hero:AddNewModifier(hero, nil, "modifier_lueduo_lua", {})

	-- >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>用来测试各种特效>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
	-- hero:AddNewModifier(hero, nil, "modifier_treasure_convoy", {})
	-- >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
	-- self_ability = hero:GetAbilityByIndex(4)
	-- self_ability:SetLevel(1)

	game_playerinfo:set_player_active(steam_id, "active_position_lua")
	game_playerinfo:set_player_passive(steam_id, "passive_position_lua")
	game_playerinfo:set_player_chaos(steam_id, "composite_position_lua")
	game_playerinfo:set_player_innateskill(steam_id, "innateskill_second_position_lua")

	-- for i = 0, 23 do
	-- 	local t_ability = hero:GetAbilityByIndex(i)
	-- 	if t_ability then
	-- 		local abilityname = t_ability:GetAbilityName()
	-- 		if abilityname=="tianfu_8_lua" or
	-- 		abilityname=="tianfu_7_lua" or
	-- 		abilityname=="tianfu_6_lua" or
	-- 		abilityname=="tianfu_5_lua" or
	-- 		abilityname=="tianfu_4_lua" or
	-- 		abilityname=="tianfu_3_lua" or
	-- 		abilityname=="tianfu_2_lua" or
	-- 		abilityname=="tianfu_1_lua" then
	-- 			t_ability:UpgradeAbility(true)
	-- 			t_ability:SetLevel(1)
	-- 		end
	-- 	end
	-- end
	if hero_name == "npc_dota_hero_alchemist" then
		game_playerinfo:change_player_wood(hero, 999999)
	end
	-- game_playerinfo:change_player_wood(hero, 999999)

	hero:SetPrimaryAttribute(0)
	-- hero:AddItemByName("item_noItem_baoWu_book")
	-- hero:GetItemInSlot(0):SetCurrentCharges(99)
	-- hero:AddItemByName("item_book_innateskill")
	-- hero:GetItemInSlot(0):SetCurrentCharges(99)
	-- hero:AddItemByName("item_book_chaos_d")
	-- hero:GetItemInSlot(1):SetCurrentCharges(99)
	
	
	-- hero:AddItemByName( "item_noItem_baoWu_book" ):SetCurrentCharges(99)
	-- hero:AddItemByName( "item_wanneng" )
	-- hero:AddItemByName( "item_world_boss" )
	hero:AddItemByName("item_custom_bone_0")
	game_playerinfo:add_heroquipment(hero, "item_custom_bone_0")
	hero:AddItemByName("item_custom_armor_cloth_0")
	game_playerinfo:add_heroquipment(hero, "item_custom_armor_cloth_0")
	hero:AddItemByName("item_custom_ring_wood_0")
	game_playerinfo:add_heroquipment(hero, "item_custom_ring_wood_0")
	hero:AddItemByName( "item_more_and_more" )
	hero:AddItemByName( "item_custom_guazui" )
	-- hero:AddItemByName("item_custom_sword_wangzhe_5")
	-- hero:AddItemByName("item_custom_ring_wangzhe_5")
	-- hero:AddItemByName("item_custom_armor_wangzhe_5")
	
	
	-- hero:AddNewModifier( hero, nil, "modifier_sword_damage", {damage_multiple=6} )
	-- hero:AddItemByName( "item_custom_gold_necklace" )



	-- Add an item to this unit's inventory.
	--初始化碎片信息
	common_item_ability:init_bead(hero)
	hero:AddNewModifier( hero, nil, "modifier_hero_bead_buff", {}  )
	
	--创建信使
	local unit = CreateUnitByName("courier_doom", hero: GetAbsOrigin(), false, hero,player, DOTA_TEAM_GOODGUYS)
	unit: SetOwner( hero )
	unit: SetControllableByPlayer(player_id, false)
	-- unit: AddNewModifier(nil, nil, "modifier_invulnerable", {duration = 9999})
	unit: AddNewModifier(nil, nil, "modifier_currier",nil)
	global_var_func.courier_table[player_id] = unit: entindex()
	CustomNetTables:SetTableValue("courier_table","courier_table_player",global_var_func.courier_table)
	-- -- 初始化定时器
	-- custom_thinker:init_after_select_hero()
	-- CustomGameEventManager:Send_ServerToPlayer(player,"close_select_hero_panel",{})
	-- --初始化英雄召唤单位信息
	hero.call_unit = {}
	--初始化英雄宝物购买数量
	hero.baowuLimit = global_var_func.shop_baowu_limit
	-- game_playerinfo:change_player_wood(hero, 100)
	-- EmitSoundOn("Imba.Background", hero)
	-- EmitSoundOn("Imba.CrystalMaidenLetItGo01", hero)

	-- local temp_ability_name = "active_tornado_lua_s"
	-- hero:AddAbility(temp_ability_name):SetLevel(1)
	-- hero:SwapAbilities(temp_ability_name, "active_position_lua", true, false)
	-- hero:RemoveAbility("active_position_lua")
	-- print(" >>>>>>>>>>>>>>>> steam_id: "..steam_id)
	-- print(" >>>>>>>>>>>>>>>> universalExp: "..game_playerinfo:get_universal_exp(steam_id))
	-- local xindex = ParticleManager:CreateParticle("particles/diy_particles/diy_steam_ambient.vpcf", PATTACH_POINT_FOLLOW, hero)
	-- ParticleManager:SetParticleControlEnt(xindex, 0, hero, PATTACH_POINT_FOLLOW, "attach_hitloc", hero:GetOrigin(), true)
	-- CreateItemOnPositionForLaunch(hero:GetOrigin(), CreateItem("item_rune_gold", nil, nil))

	hero.sputterInfo = {
		-- EffectName = "particles/econ/items/sven/sven_ti7_sword/sven_ti7_sword_spell_great_cleave_crit.vpcf",
		EffectName = "",
		Ability = nil,
		vSpawnOrigin = nil, 
		fStartRadius = 150,
		fEndRadius = 150,
		vVelocity = nil,
		fDistance = 300,
		Source = hero,
		iUnitTargetTeam = DOTA_UNIT_TARGET_TEAM_ENEMY,
		iUnitTargetType = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
		bDeleteOnHit = false,
	}
	hero.sputterDamageInfo = {
		victim =  nil,
		attacker = hero,
		damage = 0,
		damage_type = DAMAGE_TYPE_PHYSICAL,
		ability = nil
	}
end

--拾取物品
function CustomListen:item_pickup(evt)
	-- local player = PlayerResource:GetPlayer(evt.PlayerID )
	local hero 
	local pickUnit
	if(evt.UnitEntityIndex ~= nil) then
		pickUnit = EntIndexToHScript(evt.UnitEntityIndex)
		hero = pickUnit:GetOwnerEntity()
	end
	if(evt.HeroEntityIndex ~= nil) then
		pickUnit = EntIndexToHScript(evt.HeroEntityIndex)
		hero = pickUnit
	end
	if string.find(evt.itemname,"item_book_") then
		for i=0 , 8 do 
			local item_handle =  pickUnit:GetItemInSlot(i)
			if item_handle and evt.itemname == item_handle:GetAbilityName() then
				item_handle:SetPurchaser( hero )
				item_handle:SetSellable(true)
				break
			end
		end
	end
	common_item_ability:item_rune_pickup(evt.itemname ,hero)
end

function CustomListen:hero_death(evt)
	-- 英雄死亡响应
	local player = PlayerResource:GetPlayer(evt.PlayerID)
	local hero = player:GetAssignedHero()
	-- hero:EmitSound("hero.die")
	local steam_id = PlayerResource:GetSteamAccountID(evt.PlayerID)
	local scale = (1-game_playerinfo:get_dynamic_properties_by_key(steam_id, "respawn_time"))
	if scale <= 0 or not scale then
		scale = 1
	end
	-- print(" >>>>>>>>>>>>>>> die time: "..10*scale)
	if hero:GetUnitName() == "npc_dota_hero_sand_king" then
		local fuhuo_time = ((4*scale)-game_playerinfo:get_dynamic_properties_by_key(steam_id, "respawn_second"))
		if fuhuo_time < 0 then
			fuhuo_time = 0
		end
		hero:SetTimeUntilRespawn(fuhuo_time)
	else
		hero:SetTimeUntilRespawn(((8*scale)-game_playerinfo:get_dynamic_properties_by_key(steam_id, "respawn_second")))
	end
	hero:SetRespawnPosition(
		Entities:FindByName(nil, global_var_func.corner[evt.PlayerID + 1].hero_corner):GetAbsOrigin()
	)
	--刷新复活金钱
	CustomGameEventManager:Send_ServerToPlayer(player, "refreshPlayerBuyBackMoney",{need=global_var_func.buy_back_need[evt.PlayerID],})
end

-- function CustomListen:used_ability(evt)
-- 	-- print(" >>>>>>>>>>>>>>>>>>>>  used_ability: ")
-- 	-- DeepPrintTable(evt)
-- end

function CustomListen:hero_buy_item(evt)
	-- 英雄购买商店物品事件
	local player = PlayerResource:GetPlayer(evt.PlayerID)
	local hero = player:GetAssignedHero()
end



-- 设置难度
function CustomListen:choice_game_level(event)
	if event.level == GameRules:GetCustomGameDifficulty() then
		return
	end
	CustomGameEventManager:Send_ServerToAllClients("set_custom_game_difficulty_event", {
		level = event.level,
		current_level = GameRules:GetCustomGameDifficulty()
	})
	GameRules:SetCustomGameDifficulty(event.level)
end

function CustomListen:OnAddTreasure(args)

	local nPlayerID = args.PlayerID
	local treasureName = args.treasure_name
	local nPlayer = PlayerResource:GetPlayer(nPlayerID)
	if nPlayer:IsNull() or not nPlayer then
		-- print(" >>>>>>>>>> 11111111111111 ")
		return
	end
	local hHero = nPlayer:GetAssignedHero()
	if hHero:IsNull() or not hHero then
		-- print(" >>>>>>>>>> 22222222222222 ")
		return
	end

	-- local treasure_round = game_playerinfo:get_player_treasure_round(nPlayerID)
	if not hHero:IsAlive() then
		send_error_tip(nPlayerID,"error_herodie")
		return
	end
	-- if treasure_round >= global_var_func.treasure_round[nPlayerID + 1] then
	-- 	send_error_tip(nPlayerID,"error_nobi")
	-- 	return
	-- end
	-- if type(args.treasure_name) == "table" then
	-- 	CustomGameEventManager:Send_ServerToPlayer(nPlayer, "closed_treasure_select", {})
	-- 	return
	-- end
	-- if treasureName == "modifier_treasure_unknown" or hHero:FindModifierByName("modifier_treasure_angel_gift") then
	-- 	CustomGameEventManager:Send_ServerToPlayer(nPlayer, "closed_treasure_select", {})
	-- 	treasureName = treasuresystem:random_round_treasures(nPlayerID)
	-- else
	-- 	if not treasuresystem:check_round_treasures(nPlayerID, treasureName) then
	-- 		send_error_tip(nPlayerID,"error_repetitive_gem")
	-- 		return
	-- 	end
	-- 	CustomGameEventManager:Send_ServerToPlayer(nPlayer, "closed_treasure_select", {})
	-- end
	if not treasuresystem:checkTreasuresName(treasureName) then
		-- body
		-- print(" >>>>>>>>>> 3333333333333333 ")
		return
	end
	-- print(" >>>>>>>>>> 44444444444444 ")
	AddTreasureForHero(hHero, treasureName, {})
	treasuresystem:remove_treasure(nPlayerID, treasureName)
	game_playerinfo:update_player_treasure_round(nPlayerID)
	
	CustomGameEventManager:Send_ServerToPlayer(nPlayer, "closed_treasure_select", {})
	CustomGameEventManager:Send_ServerToPlayer(nPlayer, "send_hero_treasure_data", {name = treasureName})
end

function CustomListen:OnCloseTreasure(args)

end

function CustomListen:OnHeroPicked(event)
	local hero = EntIndexToHScript(event.heroindex)
	local player_id = hero:GetPlayerID()
	local position = Entities:FindByName(nil, global_var_func.corner[player_id + 1].hero_corner):GetAbsOrigin()
	hero:SetContextThink(DoUniqueString("init_hero_position_think"), function ()
		FindClearSpaceForUnit(hero, position, false)
		CustomGameEventManager:Send_ServerToPlayer(PlayerResource:GetPlayer(player_id), "set_player_camera_event",{
			position = position,
		})
		return nil
	end, 1/144)
end

function CustomListen:courier_send_item(data)
	local courier = EntIndexToHScript(data.unit_index)
	local ability = courier:FindAbilityByName("currier_send_item")
	courier:CastAbilityImmediately(ability,data.unit_index)
end

function CustomListen:on_npc_spawned(event)
	local npc = EntIndexToHScript(event.entindex)
	if npc:IsRealHero() then
		local steam_id = PlayerResource:GetSteamAccountID(npc:GetPlayerID())
		local vip_time = game_playerinfo:get_dynamic_properties_by_key(steam_id, "invincible_time")
		npc: AddNewModifier(nil, nil, "modifier_invulnerable", {duration = 1 * (1 + vip_time)})
	end
end

function CustomListen:hero_buyback(data)
	local player_id = data.PlayerID
	local hero = PlayerResource:GetPlayer(player_id):GetAssignedHero()
	local need = global_var_func.buy_back_need[player_id]
	if game_playerinfo:get_player_gold(player_id) < need then
		send_error_tip(player_id,"error_nomoney")
	else
		game_playerinfo:set_player_gold(player_id,-need)
		global_var_func.buy_back_need[player_id] = need + 5000
		hero:RespawnHero(true, true)
	end
end

function CustomListen:levelup_economic(data)
	local player_id = data.PlayerID
	local modifier_name = data.name
	local hero = PlayerResource:GetPlayer(player_id):GetAssignedHero();
	local gold =  game_playerinfo:get_player_gold(player_id)
	local modifier = hero:FindModifierByName(modifier_name)
	local level = modifier:GetStackCount()
	local need_gold = 500 + global_var_func:GloFunc_Getgame_enum().ECONOMIC * level
	if gold < need_gold then
		send_error_tip(player_id,"error_nomoney")
		return
	end
	hero:EmitSound("drop.gold")
	game_playerinfo:set_player_gold(player_id,-need_gold)
	hero:AddNewModifier(nil,nil,modifier_name,{})
	CustomGameEventManager:Send_ServerToPlayer(PlayerResource:GetPlayer(player_id), "update_touzi_level",{panelId = modifier_name,price = need_gold + global_var_func:GloFunc_Getgame_enum().ECONOMIC})

	------ 测试宝箱特效
	CreateModifierThinker( hero, nil, "modifier_open_baoxiang_lua", {duration = 10, }, hero:GetOrigin(), hero:GetTeamNumber(), false )
end

function CustomListen:ui_get_hero_list(data)
	local player_id = data.PlayerID
	local steam_id =  PlayerResource:GetSteamAccountID(player_id)
	local crt_exp = game_playerinfo:get_universal_exp(steam_id)
	local total_exp = game_playerinfo:get_all_universal_exp(steam_id)
	local hero_list = game_playerinfo:get_all_hero_info(steam_id)
	-- global_var_func:get_hero_ability()
	local hero_amount = #hero_list
	CustomGameEventManager:Send_ServerToPlayer(PlayerResource:GetPlayer(player_id), "send_hero_list_to_ui",
							{heroList = hero_list,crtExp = crt_exp,totalExp = total_exp,heroAmount = hero_amount})
end

function CustomListen:ui_heromap_levelup_hero(data)
	local player_id = data.PlayerID
	local steam_id =  PlayerResource:GetSteamAccountID(player_id)
	local hero = PlayerResource:GetPlayer(player_id):GetAssignedHero()
	local index = tonumber(data.index) 
	local hero_list = game_playerinfo:get_all_hero_info(steam_id)
	if hero_list[index][2] >= 20 then
		send_error_tip(player_id,"error_maxlevel")
		return
	end 
	local is_level_up = game_playerinfo:levelup_hero(player_id, index)
	hero_list = game_playerinfo:get_all_hero_info(steam_id)
	if is_level_up then
		hero:EmitSound("hero.levelup")
		local crt_exp = game_playerinfo:get_universal_exp(steam_id)
		local total_exp = game_playerinfo:get_all_universal_exp(steam_id)
		local hero_amount = #hero_list
		CustomGameEventManager:Send_ServerToPlayer(PlayerResource:GetPlayer(player_id), "send_to_ui_refresh_heromap",
								{heroList = hero_list,crtExp = crt_exp,totalExp = total_exp,heroAmount = hero_amount,index = index})
	else
		send_error_tip(player_id,"error_noexp")
	end
	
end

function CustomListen:request_cangku_data(data)
	local player_id = data.PlayerID
	local steam_id =  PlayerResource:GetSteamAccountID(player_id)
	local ck_data_sh,ck_data_zh = herosublimesys:get_store_item_info(steam_id)
	local call_boss_cost = herosublimesys:getCallBossmaterials()
	CustomGameEventManager:Send_ServerToPlayer(PlayerResource:GetPlayer(player_id), "response_cangku_data",{ck_data_sh = ck_data_sh,ck_data_zh = ck_data_zh,call_boss_cost = call_boss_cost})
end

function CustomListen:take_out_from_store(data)
	local player_id = data.PlayerID
	local steam_id =  PlayerResource:GetSteamAccountID(player_id)
	local playerinfo = game_playerinfo:get_player_info()[steam_id]
	local item_name = data.item_name
	local item_amount = playerinfo[item_name]
	if item_amount < 1 then
		return
	end
	local hero = PlayerResource:GetPlayer(player_id):GetAssignedHero()
	local slot_is_empty = false
	for i=0,14 do
		if not hero:GetItemInSlot(i) then
			slot_is_empty = true
			break
		end
	end
	if slot_is_empty then
		hero:AddItemByName(item_name)
	else
		send_error_tip(player_id,"error_noitembox")
		return
	end
	game_playerinfo:update_save_item_number(steam_id, item_name, -1)
	local ck_data_sh,ck_data_zh = herosublimesys:get_store_item_info(steam_id)
	game_playerinfo:save_archiveby_playerid(player_id)
	CustomGameEventManager:Send_ServerToPlayer(PlayerResource:GetPlayer(player_id), "response_take_item",{ck_data_sh = ck_data_sh,ck_data_zh = ck_data_zh,take_name=item_name})
end



-- function CustomListen:request_call_boss(data)
-- 	local player_id = data.PlayerID
-- 	if global_var_func.call_boss_count > 0 then
-- 		local is_success = herosublimesys:OnCallBoss(player_id)
-- 		if is_success then
-- 			local steam_id =  PlayerResource:GetSteamAccountID(player_id)
-- 			local ck_data_sh,ck_data_zh = herosublimesys:get_store_item_info(steam_id)
-- 			CustomGameEventManager:Send_ServerToPlayer(PlayerResource:GetPlayer(player_id), "response_take_item",{ck_data_sh = ck_data_sh,ck_data_zh = ck_data_zh,take_name="do_call_boss"})
-- 			global_var_func.call_boss_count = global_var_func.call_boss_count - 1
-- 		end
-- 	else
-- 		send_error_tip(player_id,"call_boss_count_not_enough")
-- 	end
-- end

function CustomListen:request_sublime(data)
	local player_id = data.PlayerID
	local heroName = PlayerResource:GetPlayer(player_id):GetAssignedHero():GetUnitName()
	local is_success = herosublimesys:Onherosublime(player_id, heroName)
	if is_success then
		local steam_id =  PlayerResource:GetSteamAccountID(player_id)
		local ck_data_sh,ck_data_zh = herosublimesys:get_store_item_info(steam_id)
		CustomGameEventManager:Send_ServerToPlayer(PlayerResource:GetPlayer(player_id), "response_take_item",{ck_data_sh = ck_data_sh,ck_data_zh = ck_data_zh,take_name="do_sublime"})
	end
end

function CustomListen:request_shenghua_data(data)
	local player_id = data.PlayerID
	local player = PlayerResource:GetPlayer(player_id)
	local hero =  player:GetAssignedHero()
	if hero then
		local hero_name =hero:GetUnitName()
		local sh_marterial = herosublimesys:sublimeNeedMaterials(hero_name)
		local hero_ability = hero:GetAbilityByIndex(0):GetAbilityName()
		CustomGameEventManager:Send_ServerToPlayer(player, "response_hero_need_materails", {sh_marterial = sh_marterial,ability_name = hero_ability,hero_name = hero_name})
	end
end


function CustomListen:update_player_difficulty_select(data)
	if data.PlayerID<0 then
		return
	end
	local selectLevel = data.level
	global_var_func.difficulty_select[data.PlayerID] = selectLevel
	local updataData = {[data.PlayerID]= selectLevel}
	local HaveAllSelect = true
	for i=0,global_var_func.all_player_amount -1 do
		if global_var_func.difficulty_select[i] == nil then
			HaveAllSelect = false
			break;
		end
	end
	CustomGameEventManager:Send_ServerToAllClients("response_player_difficulty_select", {updataData=updataData,HaveAllSelect = HaveAllSelect})
	if HaveAllSelect then
		CustomGameEventManager:Send_ServerToPlayer(PlayerResource:GetPlayer(0),"force_start_game_after_time", {})
	end
	-- print(" >>>>>>>>>>>>>>>>>>>>>> GetPlayerCount: "..PlayerResource:GetPlayerCount())
	-- global_var_func.all_player_amount = PlayerResource:GetPlayerCount()
	---------------------------- 本地联机,调试代码
	-- Archive:LoadProfile()
	-- Store:LoadAllPlayerGoods()
	---------------------------- 本地联机,调试代码
end

function CustomListen:lock_difficulty_select(data)
	local difficulty = {}
	for p,l in pairs(global_var_func.difficulty_select) do
		-- local player = PlayerResource:GetPlayer(p)
		local steam_id = PlayerResource:GetSteamAccountID(p)
		local weight 
		if p == 0 then
			weight=1.5
		else
			weight = 1
		end
		if tonumber(l) > 10  then
			l =  game_playerinfo:get_pass_level(steam_id) + 1
		end
		difficulty[l] = difficulty[l] or 0 + weight
	end
	local maxWight = 0
	local selectedDif = 1
	for level,wt in pairs(difficulty) do
		if wt > maxWight then
			maxWight = wt
			selectedDif = level
		end
	end
	GameRules:SetCustomGameDifficulty(tonumber(selectedDif))
	if GameRules:GetCustomGameDifficulty() >= 7 then
		global_var_func.show_final_boss = 30
	elseif GameRules:GetCustomGameDifficulty() >= 4 then
		global_var_func.show_final_boss = 20
	end
end

-- 玩家掉线
function CustomListen: OnPlayerDisconnected (event)
	for i = 0, 3 do
		if PlayerResource:GetConnectionState(i) ~= DOTA_CONNECTION_STATE_CONNECTED then
			-- 处理掉线玩家英雄和信使
			for _, hero in pairs(HeroList:GetAllHeroes()) do
				if hero:GetPlayerID() == i then
					if hero:IsAlive() then
						hero:SetRespawnsDisabled(true)
						hero:ForceKill(false)
						local courier = EntIndexToHScript(global_var_func.courier_table[i])
						if courier and not courier:IsNull() and courier:IsAlive() then
							courier:SetUnitCanRespawn(true)
							courier:ForceKill(false)   
						end
					end
					break
				end
			end
		end
	end
end

-- 玩家重连
function CustomListen: OnPlayerReconnected (event)
    for i = 0, 3 do
        if PlayerResource:GetConnectionState(i) == DOTA_CONNECTION_STATE_CONNECTED then
            for _, hero in pairs(HeroList:GetAllHeroes()) do
                if hero:GetPlayerID() == i then
                    if hero and not hero:IsNull() and not hero:IsAlive() and hero:GetRespawnsDisabled() then
                        hero:RespawnUnit()
                        if hero:GetUnitName() == "npc_dota_hero_crystal_maiden" and GameRules:State_Get() ==DOTA_GAMERULES_STATE_GAME_IN_PROGRESS then 
							local hero_name = global_var_func.player_random_hero_data["player_"..i][2]
							game_playerinfo:init_treasure_select_tab(i)
							-- 初始化定时器
							-- custom_thinker:init_after_select_hero()
							CustomGameEventManager:Send_ServerToPlayer(PlayerResource:GetPlayer(i),"close_select_hero_panel",{})
							--初始化英雄召唤单位信息
                            set_item(i,hero_name)
                        else
                            local courier = EntIndexToHScript(global_var_func.courier_table[i])
                            if courier and not courier:IsNull() and not courier:IsAlive() then
                                courier:RespawnUnit()
                            end
                        end
                    end
                    break
                end
            end
        end
    end
end

function CustomListen:on_player_chated(event)
	local cheat_command = {
		"-lvlup",
		"-createhero",
		"-item",
		"-refresh",
		"-startgame",
		"-killcreeps",
		"-wtf",
		"-disablecreepspawn",
		"-gold",
		"-respawn",
		"-dota_create_unit",
		"-teleport",
		"-ggsimida",
	}
	for key, value in pairs(cheat_command) do
		if string.find(event.text, value) then
			GameRules:MakeTeamLose(global_var_func:GloFunc_Getgame_enum().TEAM_TH);
			return
		end
	end

	-- local hero = PlayerResource:GetPlayer(event.playerid):GetAssignedHero() 

	-- -- 技能测试
	-- -- 等级
	-- for key1, value1 in pairs(config_random_ability) do
	-- 	if type(value1) == "table" then
	-- 		-- 主被动
	-- 		for key2, value2 in pairs(value1) do
	-- 			if type(value2) == "table" then
	-- 				-- 池子
	-- 				for key3, value3 in pairs(value2) do
	-- 					if event.text == ("-"..value3) then
	-- 						local steam_id = PlayerResource:GetSteamAccountID(event.playerid)
	-- 						if key2 == "activepool" then
	-- 							local old_name = game_playerinfo:get_player_active(steam_id)
	-- 							hero:AddAbility(value3):SetLevel(1)
	-- 							hero:SwapAbilities(value3, old_name, true, false)
	-- 							hero:RemoveAbility(old_name)
	-- 							game_playerinfo:set_player_active(steam_id, value3)
	-- 						end
	-- 						if key2 == "passivepool" then
	-- 							local old_name = game_playerinfo:get_player_passive(steam_id)
	-- 							hero:AddAbility(value3):SetLevel(1)
	-- 							hero:SwapAbilities(value3, old_name, true, false)
	-- 							hero:RemoveAbility(old_name)
	-- 							game_playerinfo:set_player_passive(steam_id, value3)
	-- 						end
	-- 						return
	-- 					end
	-- 				end
	-- 			end
	-- 		end
	-- 	end
	-- end

	-- if event.text == "-addgold" then
	-- 	game_playerinfo:set_player_gold(event.playerid,1000000)
	-- 	game_playerinfo:change_player_wood(PlayerResource:GetPlayer(event.playerid):GetAssignedHero(), 10000000)
	-- 	return
	-- end

	-- if event.text == "-sh" then
	-- 	-- 进行升华操作
	-- 	herosublimesys:Onherosublime(event.playerid, PlayerResource:GetPlayer(event.playerid):GetAssignedHero():GetUnitName())
	-- 	return
	-- end

	-- if event.text == "-addgold" then
	-- 	game_playerinfo:set_player_gold(event.playerid,1000000)
	-- 	game_playerinfo:change_player_wood(PlayerResource:GetPlayer(event.playerid):GetAssignedHero(), 10000000)
	-- 	return
	-- end

	-- if string.find(event.text, "-m ") then
	-- 	local temp = string.sub(event.text, 4)
	-- 	print(temp)
	-- 	hero:AddNewModifier(hero, nil, string.sub(event.text, 4), nil)
	-- 	return
	-- end

	-- if event.text == "-add" then
	-- 	hero:AddNewModifier(hero, nil, "modifier_treasure_sublime_skeleton_king", nil)
	-- 	return
	-- end

	-- if event.text == "-remove" then
	-- 	hero:RemoveModifierByName("modifier_treasure_sublime_treant")
	-- 	return
	-- end

	-- if event.text == "-add1" then
	-- 	hero:AddNewModifier(hero, nil, "modifier_treasure_more", nil)
	-- 	return
	-- end

	-- if event.text == "-remove1" then
	-- 	hero:RemoveModifierByName("modifier_treasure_more")
	-- 	return
	-- end

	-- if event.text == "-add2" then
	-- 	hero:AddNewModifier(hero, nil, "modifier_treasure_more_more", nil)
	-- 	return
	-- end

	-- if event.text == "-remove2" then
	-- 	hero:RemoveModifierByName("modifier_treasure_more_more")
	-- 	return
	-- end

	-- if event.text == "-add3" then
	-- 	hero:AddNewModifier(hero, nil, "modifier_treasure_goldmon_attribute_two", nil)
	-- 	return
	-- end

	-- if event.text == "-remove3" then
	-- 	hero:RemoveModifierByName("modifier_treasure_goldmon_attribute_two")
	-- 	return
	-- end

	-- if event.text == "-addexp" then
	-- 	hero:AddExperience(400, DOTA_ModifyXP_TomeOfKnowledge, false, false)
	-- 	return
	-- end

	-- if event.text == "-property" then
	-- 	SetBaseStrength(hero, 10000)
	-- 	SetBaseAgility(hero, 10000)
	-- 	SetBaseIntellect(hero, 10000)
	-- 	return
	-- end

	-- if event.text == "-particle" then
	-- 	Timers(function()
	-- 		local position = hero:GetOrigin()
	-- 		local index = ParticleManager:CreateParticle("particles/units/heroes/hero_phantom_assassin/phantom_assassin_crit_impact.vpcf", PATTACH_WORLDORIGIN, hero)
	-- 		ParticleManager:SetParticleControl(index, 0, position)
	-- 		ParticleManager:SetParticleControl(index, 1, position - hero:GetForwardVector() * 100)
	-- 		ParticleManager:SetParticleControlForward(index, 1, hero:GetForwardVector())
	-- 		ParticleManager:ReleaseParticleIndex(index)
	-- 		return 1
	-- 	end)
	-- 	return
	-- end
	
	-- if string.find(event.text, "-0.") then
    --     GameRules:SetTimeOfDay(tonumber(string.sub(event.text, 2)))
    --     return
	-- end
	
    -- if event.text == "-heal" then
    --     PlayerResource:GetPlayer(0):GetAssignedHero():Heal(100, nil)
    --     return
	-- end

	-- if event.text == "-health" then
	-- 	hero:SetHealth(hero:GetMaxHealth() * 0.1)
    --     return
	-- end

	-- if event.text == "-wugui" then
	-- 	local unit = CreateUnitByName("wugui", hero:GetOrigin() + hero:GetForwardVector() * 500, true, nil, nil, DOTA_TEAM_BADGUYS)
	-- 	unit:AddNewModifier(unit, nil, "modifier_treasure_holy_cloak", nil)
    --     return
	-- end

	-- if event.text == "-zhangda" then
	-- 	hero:AddNewModifier(hero, nil, "modifier_test", nil)
    --     return
	-- end

	-- if event.text == "-item" then
    --     CreateItemOnPositionForLaunch(hero:GetOrigin() + RandomVector(150), CreateItem("item_rune_box_bronze",nil,nil))
    --     return
	-- end

	-- if event.text == "-unit" then
	-- 	local unit_name = rule_unit_spawn:RandomCreepName()
	-- 	local unit = rule_unit_spawn: CreateUnit({
	-- 		name = unit_name,
	-- 		start_position =  Entities:FindByName(nil, global_var_func.corner[event.playerid + 1].start_corner):GetOrigin() + RandomVector(RandomFloat(0, 800)),
	-- 		end_position = Entities:FindByName(nil, global_var_func.corner[event.playerid + 1].end_corner):GetOrigin(),
	-- 		team = DOTA_TEAM_BADGUYS,
	-- 	})
	-- 	for _, value in pairs(rule_unit_spawn.creep) do
	-- 		if value[1] == unit_name then
	-- 			AppendUnitTypeFlag(unit, value[2])
	-- 		end
	-- 	end
	-- 	unit.player_id = event.playerid
	-- 	SetUnitBaseValue(unit)
    --     return
	-- end

end

function CustomListen:RequestPlayerShopItems(params)
	local player = PlayerResource:GetPlayer( params.PlayerID )
	CustomGameEventManager:Send_ServerToPlayer(player, "ResponsePlayerShopItems",{ShopItemCooldown = global_var_func.shop_item_cooldown["player"..params.PlayerID],
														ShopItem = global_var_func.player_shop_item["player"..params.PlayerID] ,ShopItemOrder = global_var_func.custom_shop_item ,
														CallCount= global_var_func.task_call_count_log[params.PlayerID..""]})
end

--英雄等级提升提示
function CustomListen:hero_level_up(params)
	local player_id = params.player_id
	local player = PlayerResource:GetPlayer(player_id)
	local hero = player:GetAssignedHero()
	local player_name = PlayerResource:GetPlayerName(player_id)
	local int_level = params.level
	local int_strength = hero:GetStrengthGain()
	local int_agility = hero:GetAgilityGain()
	local int_intellect = hero:GetIntellectGain()

	--是否是bug英雄
	if PlayerResource:GetSelectedHeroName(player_id) ~= "npc_dota_hero_void_spirit" then
		send_tips_message_level(player_id,int_level,player_name,"tip_hero_upgrade_level")
		send_tips_message_level(player_id,int_strength,player_name,"tip_hero_upgrade_strength")
		send_tips_message_level(player_id,int_agility,player_name,"tip_hero_upgrade_agility")
		send_tips_message_level(player_id,int_intellect,player_name,"tip_hero_upgrade_intellect")
	else
		send_tips_message_level(player_id,int_level,player_name,"tip_hero_upgrade_bug_level")
		send_tips_message_level(player_id,int_strength,player_name,"tip_hero_upgrade_bug_strength")
		send_tips_message_level(player_id,int_agility,player_name,"tip_hero_upgrade_bug_agility")
		send_tips_message_level(player_id,int_intellect,player_name,"tip_hero_upgrade_bug_intellect")
	end
end

function send_tips_message_level(playerID,int_value,locstring_value,message_text)
    local gameEvent = {}
    gameEvent["player_id"] = playerID
    gameEvent["locstring_value"] = locstring_value
	gameEvent["teamnumber"] = -1
	gameEvent["int_value"] = int_value
	gameEvent["message"] = message_text
	FireGameEvent( "dota_combat_event_message", gameEvent )
end
