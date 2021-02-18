require("info/game_playerinfo")
local JSON = require("dkjson")

if Archive == nil then
	Archive = class({})
end

local game_archive = {}
-- ACTION_ARCHIVE_LOAD = "archive/load_profile" 					-- 获取游戏存档
ACTION_ARCHIVE_LOAD = "player/load_player" 					-- 获取游戏存档
-- ACTION_ARCHIVE_SAVE = "archive/save_profile" 					-- 保存游戏存档存档
ACTION_ARCHIVE_SAVE = "player/update_player"
ACTION_ARCHIVE_NEW_MATCH = "archive/new_match" 					-- 保存游戏存档存档
ACTION_ARCHIVE_TOTEM = "totem/update_totem"						-- 图腾数据存档

ACTION_ARCHIVE_TEST_PASSWORD = "player/test_code" 					-- 验证码
function Archive:Init() 
	ListenToGameEvent( "game_rules_state_change" ,Dynamic_Wrap( self, 'StageChange' ), self )
end

function Archive:StageChange()
	if GameRules:State_Get() == DOTA_GAMERULES_STATE_CUSTOM_GAME_SETUP then
		self:LoadProfile()
		-- self.new_match()
	elseif GameRules:State_Get() == DOTA_GAMERULES_STATE_WAIT_FOR_MAP_TO_LOAD then
		CustomNetTables:SetTableValue("service", "player_archive", self:GetData())
	end
end

-- 比赛ID写入
function Archive:new_match()
	local match_id = tonumber(GameRules:GetMatchID()) or 0
	Service:HTTPRequest("POST", ACTION_ARCHIVE_NEW_MATCH, {match_id = match_id  }, function(iStatusCode, sBody)
		--print("LoadPlayerProfile iStatusCode:",iStatusCode)
	end, REQUEST_TIME_OUT)

end
-- 读取地图存档
function Archive:LoadProfile()
	local nPlayerCount = global_var_func.all_player_amount
	for nPlayerID = 0,nPlayerCount - 1 do
		if game_archive[nPlayerID] == nil then
			game_archive[nPlayerID] = {}
		end
		local steamID = PlayerResource:GetSteamAccountID(nPlayerID)
		if not game_playerinfo:hasplayerinfo(steamID) then
			self:LoadPlayerProfile(nPlayerID)
		end
	end
end

function Archive:LoadPlayerProfile(nPlayerID)
	local nSteamID = PlayerResource:GetSteamAccountID(nPlayerID)
	print(">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>nSteamID: "..nSteamID)
	Service:HTTPRequest("POST", ACTION_ARCHIVE_LOAD, { steamId = nSteamID }, function(iStatusCode, sBody)
		print("LoadPlayerProfile iStatusCode:",iStatusCode)
		if iStatusCode == 200 then
			-- body
			global_var_func.createPlayer[nPlayerID] = false
			local hBody = JSON.decode(sBody)
			-- DeepPrintTable(hBody)
			if hBody.code == 200 then
				-- print(">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>LoadPlayerProfile: "..sBody)
				-- local hBody = JSON.decode(sBody)
				-- DeepPrintTable(hBody.data)
				if not hBody.data then
					game_playerinfo:create_playerinfo(nPlayerID, 1)
					if not treasuresystem:get_player_treasures(nPlayerID) then
						treasuresystem:player_inittreasures(nPlayerID)
					end
					global_var_func.createPlayer[nPlayerID] = true
				else
					for key, value in pairs(hBody.data) do
						game_playerinfo:http_load_playerinfo_by_server(nPlayerID, key, value)
					end
					if not treasuresystem:get_player_treasures(nPlayerID) then
						treasuresystem:player_inittreasures(nPlayerID)
					end
					game_playerinfo:InitTotemAttribute(nPlayerID)
					-- 补缺宝物卡
					treasuresystem:fill_lack_treasures(nPlayerID)
					-- 补充缺失宝物
					treasuresystem:fill_lack_pool_treasures(nPlayerID)
					-- 检查数据,查漏补缺
					-- game_playerinfo:check_player_datas(nPlayerID)
				end
				global_var_func.end_load = global_var_func.end_load + 1
			else
				-- 请求失败,不是在官方服务器进行游戏
				GameRules: SetGameWinner(DOTA_TEAM_BADGUYS)
				return
			end

			-- 加载难度选择UI、只返回主机难度
			if nPlayerID == 0 then
				local level = game_playerinfo:get_pass_level(nSteamID) + 1
				if not GameRules:GetCustomGameDifficulty() then
					GameRules:SetCustomGameDifficulty(1)
				end
				if level > GameRules:GetCustomGameDifficulty() then
					-- if level > 7 then
					-- 	level = 7
					-- end
					GameRules:SetCustomGameDifficulty(level)
				end
			end
			-- 加载界面判断
			game_playerinfo:CheckPlayerIsEnterGame(nPlayerID)
			if global_var_func.createPlayer[nPlayerID] then
				print(" >>>>>>>>>>>>>>>> save_archive")
				game_playerinfo:save_archive_for_create(nPlayerID)
				game_playerinfo:save_totem(nPlayerID)
			end
		else
			-- Archive:LoadPlayerProfile(nPlayerID)
		end
		-- 	GameRules:SetCustomGameDifficulty(7)
	end, REQUEST_TIME_OUT)
end

function Archive:WriteTestPassword(nPlayerID,Password)
	local nSteamID = PlayerResource:GetSteamAccountID(nPlayerID)
	Service:HTTPRequest("POST", ACTION_ARCHIVE_TEST_PASSWORD, { steamId = nSteamID, testCode = Password }, function(iStatusCode, sBody)
		print("WriteTestPassword iStatusCode:",iStatusCode)
		if iStatusCode == 200 then
			local hBody = JSON.decode(sBody)
			print(">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>WriteTestPassword: "..sBody)
			if hBody.code==200 then
				local player_info = game_playerinfo:get_player_info()[nSteamID]
				player_info.verification = 1
				game_playerinfo:closeTestPaswordUI(nPlayerID)
			end
		end
	end, REQUEST_TIME_OUT)
end

function Archive:SaveProfile()
	print("SaveProfile")
	local nPlayerCount = global_var_func.all_player_amount
	for nPlayerID = 0,nPlayerCount - 1 do
		self:SavePlayerProfile(nPlayerID)
	end
end

-- 单个玩家存档
function Archive:SaveProfileByID(PlayerID)
	self:SavePlayerProfile(PlayerID)
end

function Archive:SavePlayerProfile(nPlayerID)
	local nSteamID = PlayerResource:GetSteamAccountID(nPlayerID)
	local rows = self:GetData(nPlayerID)
	print(" >>>>>>>>>>> saveheros: ")
	-- DeepPrintTable(rows)
	Service:HTTPRequest("POST", ACTION_ARCHIVE_SAVE, { steamId = nSteamID, rows = rows }, function(iStatusCode, sBody)
		-- print("SavePlayerProfile:",iStatusCode)
		-- print(sBody)
		if iStatusCode == 0 then
			-- Archive:SavePlayerProfile(nPlayerID)
		end 
	end, REQUEST_TIME_OUT)
end

-- 图腾存档
function Archive:SavePlayerTotem(nPlayerID)
	local nSteamID = PlayerResource:GetSteamAccountID(nPlayerID)
	local rows = self:GetData(nPlayerID)
	-- print(" >>>>>>>>>>> SavePlayerTotem: "..nSteamID)
	-- DeepPrintTable(rows)
	Service:HTTPRequest("POST", ACTION_ARCHIVE_TOTEM, { steamId = nSteamID, rows = rows }, function(iStatusCode, sBody)
		-- print(" >>>>>>>>>>>>>>>>>>>>> TotemiStatusCode")
		if iStatusCode == 0 then
			-- Archive:SavePlayerTotem(nPlayerID)
		end 
	end, REQUEST_TIME_OUT)
end

function Archive:EditPlayerProfile(nPlayerID,sKeyword,sValue)
	if not game_archive[nPlayerID] then
		game_archive[nPlayerID] = {}
	end
	game_archive[nPlayerID][sKeyword] = sValue
end

-- 清理对应玩家存档字段
function Archive:ClearPlayerProfile(nPlayerID)
	if game_archive[nPlayerID] then
		game_archive[nPlayerID] = {}
	end
end

-- 指定字段值自增
function Archive:SetIncPlayerProfile(nPlayerID,sKeyword,sValue)
	if type(sValue) == "number" then
		if game_archive[nPlayerID][sKeyword] == nil then
			game_archive[nPlayerID][sKeyword] = sValue
		else
			game_archive[nPlayerID][sKeyword] = game_archive[nPlayerID][sKeyword] + sValue
		end
	end
end

-- 获取存档数据
function Archive:GetData(nPlayerID,sKeyword)
	if nPlayerID == nil then
		return game_archive
	elseif sKeyword == nil then
		return game_archive[nPlayerID]
	else 
		if game_archive[nPlayerID][sKeyword] == nil then
			return 0
		else
			return game_archive[nPlayerID][sKeyword]
		end
	end
end