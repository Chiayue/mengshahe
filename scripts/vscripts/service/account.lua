require("info/game_playerinfo")
local JSON = require("dkjson")
if Account == nil then
	Account = class({})
end

ACTION_ACCOUNT_LOAD = "account/load_account" 						-- 读取账号晶石数据
ACTION_ACCOUNT_GET_RECHARGE_URL = "recharge/payment_url"			-- 支付链接
ACTION_ACCOUNT_GET_RECHARGE_MENU = "recharge/payment_menu"			-- 请求支付菜单,哪些是双倍
ACTION_ACCOUNT_UPDATE_ACCOUNT = "/account/update_account"			-- 更新货币

local account_data = {}

local player_Recharge = {

}
-- 读取资料数据初始化
function Account:Init()
	ListenToGameEvent( "game_rules_state_change" ,Dynamic_Wrap( self, 'StageChange' ), self )
	CustomGameEventManager:RegisterListener( "get_recharge_menu", self.OnGetRechargeMenu )
	CustomGameEventManager:RegisterListener( "get_recharge_url", self.OnGetRechargeUrl )
	CustomGameEventManager:RegisterListener( "refresh_recharge", self.OnRefreshRecharge )

	-------- 正式版不取消注释
	-- CustomGameEventManager:RegisterListener( "repet_refresh_recharge", self.OnRepetRefreshRecharge )
end

function Account:StageChange()
	if GameRules:State_Get() == DOTA_GAMERULES_STATE_CUSTOM_GAME_SETUP then
		local nPlayerCount = global_var_func.all_player_amount
		for nPlayerID = 0,nPlayerCount - 1 do
			if account_data[nPlayerID] == nil then
				account_data[nPlayerID] = {}
			end
			self:LoadPlayer(nPlayerID)
		end
	elseif GameRules:State_Get() == DOTA_GAMERULES_STATE_WAIT_FOR_MAP_TO_LOAD then
		CustomNetTables:SetTableValue("service", "player_account", Account:GetData())
	end
end

--请求充值的菜单
function Account:OnGetRechargeMenu(args)
	print("OnGetRechargeMenu")
	local nPlayerID = args.PlayerID
	local nSteamID = PlayerResource:GetSteamAccountID(nPlayerID)
	
	Service:HTTPRequest("POST", ACTION_ACCOUNT_GET_RECHARGE_MENU, { steamId = nSteamID }, function(iStatusCode, sBody)
			print("OnGetRechargeMenu iStatusCode:",iStatusCode)
			-- print(sBody)
			if iStatusCode == 200 then
				local hBody = JSON.decode(sBody)
				-- DeepPrintTable(hBody)
				CustomGameEventManager:Send_ServerToPlayer(PlayerResource:GetPlayer(nPlayerID),"RechargeMenuCallback",hBody)
			end
		end, 
	REQUEST_TIME_OUT)

end

--请求充值的网页
function Account:OnGetRechargeUrl(args)
	print("OnGetRechargeUrl")
	local nPlayerID = args.PlayerID
	local nSteamID = PlayerResource:GetSteamAccountID(nPlayerID)
	local recharge_type = args.recharge_type or "alipay"
	local amount = args.amount
	local itemtype = 0
	if amount == 6400 then
		itemtype = 1
	elseif amount == 12800 then
		itemtype = 2
	elseif amount == 25600 then
		itemtype = 3
	elseif amount == 64800 then
		itemtype = 4
	end
	Service:HTTPRequest("POST", ACTION_ACCOUNT_GET_RECHARGE_URL, { itemType = itemtype, money = amount, steamId = nSteamID, types = recharge_type }, function(iStatusCode, sBody)
			print("OnGetRechargeUrl iStatusCode:",iStatusCode)
			-- print(sBody)
			if iStatusCode == 200 then
				local hBody = JSON.decode(sBody)
				-- DeepPrintTable(hBody)
				if not player_Recharge[nSteamID] then
					player_Recharge[nSteamID] = 0
				end
				player_Recharge[nSteamID] = 1
				CustomGameEventManager:Send_ServerToPlayer(PlayerResource:GetPlayer(nPlayerID),"RechargeUrlCallback",hBody)
			else
				CustomGameEventManager:Send_ServerToPlayer(PlayerResource:GetPlayer(nPlayerID),"RechargeUrlCallback",{code=0,msg="unknow error"})
			end
		end, 
	REQUEST_TIME_OUT)

end


function Account:LoadPlayer(nPlayerID)
	local nSteamID = PlayerResource:GetSteamAccountID(nPlayerID)
	Service:HTTPRequest("POST", ACTION_ACCOUNT_LOAD, { steamId = nSteamID }, function(iStatusCode, sBody)
		print("LoadPlayerAccount:",iStatusCode)
		--print(sBody)
		if iStatusCode == 200 then
			local hBody = JSON.decode(sBody)
			-- DeepPrintTable(hBody)
			account_data[nPlayerID] = hBody.data
			-- print(" >>>>>>>>>>>>>  Account:LoadPlayer: ")
			CustomNetTables:SetTableValue("service", "player_account", self:GetData())
		else
			-- Account:LoadPlayer(nPlayerID)
		end 
	end, REQUEST_TIME_OUT)
end

function Account:UpAccountByPlayerID(nPlayerID, data)
	account_data[nPlayerID] = data
	CustomNetTables:SetTableValue("service", "player_account", self:GetData())
	CustomGameEventManager:Send_ServerToPlayer(PlayerResource:GetPlayer(nPlayerID),"UpDateAccount",account_data[nPlayerID])
end

function Account:UpAccount(nPlayerID)
	local nSteamID = PlayerResource:GetSteamAccountID(nPlayerID)
	Service:HTTPRequest("POST", ACTION_ACCOUNT_LOAD, { steamId = nSteamID }, function(iStatusCode, sBody)
		-- print("UpAccount:",iStatusCode)
		--print(sBody)
		if iStatusCode == 200 then
			local hBody = JSON.decode(sBody)
			-- DeepPrintTable(hBody)
			account_data[nPlayerID] = hBody.data
			CustomNetTables:SetTableValue("service", "player_account", Account:GetData())
			CustomGameEventManager:Send_ServerToPlayer(PlayerResource:GetPlayer(nPlayerID),"UpDateAccount",hBody)
		elseif iStatusCode == 0 then
			-- Account:UpAccount(nPlayerID)
		end 
	end, REQUEST_TIME_OUT)
end

-- 更新账号充值情况
function Account:OnRefreshRecharge(args)
	local nPlayerID = args.PlayerID
	print("OnRefreshRecharge Player:",nPlayerID)
	Account:UpAccount(nPlayerID)
end

-- 充值过后重复申请更新账号充值情况
function Account:OnRepetRefreshRecharge(args)
	local nPlayerID = args.PlayerID
	local nSteamID = PlayerResource:GetSteamAccountID(nPlayerID)
	if player_Recharge[nSteamID] == 1 then
		print("OnRepetRefreshRecharge Player:",nPlayerID)
		Timers:CreateTimer(0.1, function()
				local result = false
				print(result)
				return 1.0
			end
		)
		-- Timers(function()
		-- 	local nSteamID = PlayerResource:GetSteamAccountID(nPlayerID)
		-- 	local result = false
		-- 	Service:HTTPRequest("POST", ACTION_ACCOUNT_LOAD, { steamId = nSteamID }, function(iStatusCode, sBody)
		-- 		-- print("LoadPlayer:",iStatusCode)
		-- 		--print(sBody)
		-- 		if iStatusCode == 200 then
					
		-- 			local hBody = JSON.decode(sBody)
		-- 			account_data[nPlayerID] = hBody.data
		-- 			print("OnRepetRefreshRecharge Player:",nPlayerID)
		-- 			DeepPrintTable(hBody.data)
		-- 			print(game_playerinfo:get_playerbull_coin(nSteamID))
		-- 			print(hBody.data["bullCoin"])
		-- 			if game_playerinfo:get_playerbull_coin(nSteamID)~=hBody.data["bullCoin"] then
		-- 				result = true
		-- 				player_Recharge[nSteamID] = 0
		-- 				CustomNetTables:SetTableValue("service", "player_account", Account:GetData())
		-- 				CustomGameEventManager:Send_ServerToPlayer(PlayerResource:GetPlayer(nPlayerID),"CloseRechargePayPanel",hBody)
		-- 			end
		-- 		end 
		-- 	end, REQUEST_TIME_OUT)
		-- 	Account:UpAccount(nPlayerID)
		-- 	print(result)
		-- 	if not result then
		-- 		return 1
		-- 	end
		-- end)
	end
end

-- 获取数据
function Account:GetData(nPlayerID,sKeyword)
	if nPlayerID == nil then
		return account_data
	elseif sKeyword == nil then
		return account_data[nPlayerID]
	else 
		if account_data[nPlayerID][sKeyword] == nil then
			return 0
		else
			return account_data[nPlayerID][sKeyword]
		end
	end
end


-- 对应字段新增值，只能是货币类型
function Account:AddCustomCoinValue(nPlayerID,typeCoin,nQuantity)
	-- body
	local nSteamID = PlayerResource:GetSteamAccountID(nPlayerID)
	local ntypeCoin = typeCoin
	local Quantity = nQuantity
	local playerID = nPlayerID
	Service:HTTPRequest("POST", ACTION_ACCOUNT_UPDATE_ACCOUNT, { steamId = nSteamID, typeCoin = typeCoin, quantity = nQuantity}, function(iStatusCode, sBody)
		if iStatusCode == 200 then
			local hBody = JSON.decode(sBody)
			account_data[nPlayerID] = hBody.data
			CustomNetTables:SetTableValue("service", "player_account", Account:GetData())
			CustomGameEventManager:Send_ServerToPlayer(PlayerResource:GetPlayer(nPlayerID),"UpDateAccount",hBody)
		elseif iStatusCode == 0 then
			-- Account:AddCustomCoinValue(playerID,ntypeCoin,Quantity)
		end
	end, REQUEST_TIME_OUT)
end