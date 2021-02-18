local JSON = require("dkjson")

if Store == nil then
	Store = class({})
end

ACTION_STORE_LOAD_GOODS_LIST = "store/load_goods_list"			-- 获取商品列表
ACTION_STORE_LOAD_ACCOUNT = "store/load_account"				-- 获取玩家商品存档
ACTION_STORE_PAY_GOODS = "store/pay_goods"						-- 支付商品
ACTION_STORE_ADD_CURRENCY = "store/add_currency" 				-- 增加自定义货币 [每天都有一定上限，在服务端设置]
ACTION_STORE_USED_GOODS = "store/used_goods"						-- 使用商品
ACTION_STORE_LOAD_EXCHANGE_LIST = "store/load_day_config"			-- 获取兑换列表

local goods_list = {}
local spend_archive = {}
local exchange_list = {}

function Store:Init()
	ListenToGameEvent( "game_rules_state_change" ,Dynamic_Wrap( self, 'StageChange' ), self )
	CustomGameEventManager:RegisterListener( "pay_service_item", self.PayGoods )
end

function Store:StageChange()
	if GameRules:State_Get() == DOTA_GAMERULES_STATE_CUSTOM_GAME_SETUP then
		self:LoadAllGoodsList()
		self:LoadAllPlayerGoods()
	elseif GameRules:State_Get() == DOTA_GAMERULES_STATE_WAIT_FOR_MAP_TO_LOAD then
		CustomNetTables:SetTableValue("service", "goods", self:GetGoodsList())
		CustomNetTables:SetTableValue("service", "player_store", self:GetData())
	end
end

-- 读取商品相关存档
function Store:LoadAllPlayerGoods()
	--print("LoadAllAccount")
	local nPlayerCount = global_var_func.all_player_amount
	for nPlayerID = 0,nPlayerCount - 1 do
		local nSteamID = PlayerResource:GetSteamAccountID(nPlayerID)
		print("nSteamID:",nSteamID)
		if nSteamID > 0 then
			if spend_archive[nPlayerID] == nil then
				spend_archive[nPlayerID] = {}
			end
			self:LoadPlayerGoods(nPlayerID)
		end
	end
end

function Store:LoadAllGoodsList()
	--print("LoadAllAccount")
	local nPlayerCount = global_var_func.all_player_amount
	for nPlayerID = 0,nPlayerCount - 1 do
		self:LoadGoodsList(nPlayerID)
	end
	self:LoadExchangeList()
end

-- 读取商品列表
function Store:LoadGoodsList(playerID)
	local nSteamID = PlayerResource:GetSteamAccountID(playerID)
	local tParams = {
		steamId = nSteamID,
	}
	Service:HTTPRequest("POST", ACTION_STORE_LOAD_GOODS_LIST, tParams, function(iStatusCode, sBody)
		print("LoadGoodsList:",iStatusCode)
		if iStatusCode == 200 then
			local hBody = JSON.decode(sBody)
			-- DeepPrintTable(hBody.data)
			goods_list[playerID] = hBody.data
			CustomNetTables:SetTableValue("service", "store_goods_list", goods_list)
		else
			-- Store:LoadGoodsList(playerID)
		end
	end, REQUEST_TIME_OUT)

end

-- 读取兑换列表
function Store:LoadExchangeList()
	local tParams = {
	}
	Service:HTTPRequest("POST", ACTION_STORE_LOAD_EXCHANGE_LIST, tParams, function(iStatusCode, sBody)
		print("LoadExchangeList:",iStatusCode)
		if iStatusCode == 200 then
			local hBody = JSON.decode(sBody)
			local exTable = {}
			for index, value in ipairs(hBody.data) do
				local name = treasuresystem:get_treasure_name(value.treasureId)
				local quality = treasuresystem:get_treasure_quality(value.treasureId)
				local temptab = {}
				table.insert(temptab, name)
				table.insert(temptab, quality)
				table.insert(exTable, temptab)
			end
			exchange_list = exTable
			-- DeepPrintTable(exchange_list)
			CustomNetTables:SetTableValue("service", "store_exchange_list", exchange_list)
		else
			-- Store:LoadGoodsList(playerID)
		end
	end, REQUEST_TIME_OUT)
end

-- 
function Store:GetGoodsList()
	return goods_list
end

function Store:GetExchangeList()
	return exchange_list
end

-- 购买物品
function Store:PayGoods(args)
	-- DeepPrintTable(args)
	local nPlayerID = args.PlayerID
	if global_var_func.buyGoodsLock[nPlayerID + 1] then
		return
	end
	global_var_func.buyGoodsLock[nPlayerID + 1] = true
	local nSteamID = PlayerResource:GetSteamAccountID(nPlayerID)
	local tParams = {
		steamId = nSteamID,
		itemKey = args.goods_id,
		payType = args.pay_type, -- 支付方式 0 沙河币 1 碎钻
		quantity = args.quantity,
	}
	
	-- DeepPrintTable(tParams)
	-- 发送请求
	Service:HTTPRequest("POST", ACTION_STORE_PAY_GOODS, tParams, function(iStatusCode, sBody)
		print("PayGoods:",iStatusCode)
		if iStatusCode == 200 then
			global_var_func.buyGoodsLock[nPlayerID + 1] = false
			local hBody = JSON.decode(sBody)
			-- DeepPrintTable(hBody)
			if 401 == hBody.code then
				-- 购买失败
				CustomGameEventManager:Send_ServerToAllClients("response_errortext",{errortext = "error_buy_error", })
				return
			elseif 501 == hBody.code then
				-- body
				CustomGameEventManager:Send_ServerToAllClients("response_errortext",{errortext = "error_only_buyonce", })
				return
			elseif 502 == hBody.code then
				-- body
				CustomGameEventManager:Send_ServerToAllClients("response_errortext",{errortext = "error_no_enought_coin", })
				return
			elseif 503 == hBody.code then
				-- body
				CustomGameEventManager:Send_ServerToAllClients("response_errortext",{errortext = "error_no_enought_passlevel", })
				return
			elseif 504 == hBody.code then
				-- body
				CustomGameEventManager:Send_ServerToAllClients("response_errortext",{errortext = "error_no_enought_maplevel", })
				return
			end
			-- 商城物品更新
			game_playerinfo:http_load_playerstore_by_server(nSteamID, hBody.data.archiveSpends)
			spend_archive[nPlayerID] = hBody.data.archiveSpends
			print(">>>>>>>>>>>>>>>>>>>>>> itemKey: "..tParams.itemKey)
			-- DeepPrintTable(goods_list)
			for key, value in pairs(goods_list) do
				if value.id == tParams.itemKey and value.once == true then
					value.canBuy = 0
					break
				end
			end
			CustomNetTables:SetTableValue("service", "store_goods_list", goods_list)
			CustomNetTables:SetTableValue("service", "player_store", Store:GetData())
			CustomGameEventManager:Send_ServerToPlayer(PlayerResource:GetPlayer(nPlayerID),"PayServiceItemCallback",hBody.data)
			-- DeepPrintTable(Store:GetData())
			-- 商城货币更新
			Account:UpAccountByPlayerID(nPlayerID, hBody.data.account)
			if tParams.itemKey == "78" then
				-- 自动使用月卡
				local iargs = {}
				iargs.PlayerID = nPlayerID
				iargs.GoodsName = "Experience_double_card_30_days"
				iargs.UseNumber = 1
				
				iargs.AddItemKey, iargs.prize_list = game_playerinfo:UseGoodsByID(iargs.PlayerID,iargs.GoodsName,iargs.UseNumber)
				-- DeepPrintTable(iargs)
				Store:UsedGoods(iargs)
			elseif tParams.itemKey == "97" then
				--自动使用王者大礼包
				local iargs = {}
				iargs.PlayerID = nPlayerID
				iargs.GoodsName = "wangzhe_bag"
				iargs.UseNumber = 1
				
				iargs.AddItemKey, iargs.prize_list = game_playerinfo:UseGoodsByID(iargs.PlayerID,iargs.GoodsName,iargs.UseNumber)
				-- DeepPrintTable(iargs)
				Store:UsedGoods(iargs)
			end
		else
			local hBody = {code=0,msg="error"}
			CustomGameEventManager:Send_ServerToPlayer(PlayerResource:GetPlayer(nPlayerID),"PayServiceItemCallback",hBody)
		end
		global_var_func.buyGoodsLock[nPlayerID + 1] = false
	end, REQUEST_TIME_OUT)
end

-- 使用物品
function Store:UsedGoods(args)
	--DeepPrintTable(args)
	local nPlayerID = args.PlayerID
	
	local nSteamID = PlayerResource:GetSteamAccountID(nPlayerID)
	local tParams = {
		steamId = nSteamID,						--  玩家steamid
		useItemKey = args.GoodsName,			--	使用的物品的key
		useNumber = args.UseNumber,				--	使用的物品数量
		addItemKey = args.AddItemKey,				--	增加的物品列表  {ItemKey, Number}
	}
	local nargs = args
	-- print(" >>>>>>>>>>>>>>> UsedGoods: ")
	-- DeepPrintTable(tParams)
	-- 发送请求
	Service:HTTPRequest("POST", ACTION_STORE_USED_GOODS, tParams, function(iStatusCode, sBody)
		print("UsedGoods:",iStatusCode)
		local hBody = JSON.decode(sBody)
		if iStatusCode == 200 then
			global_var_func.useGoodsLock[nPlayerID + 1] = false
			if 401 == hBody.code then
				-- 购买失败
				game_playerinfo:RollBackBagItem(nPlayerID,args.prize_list)
				CustomGameEventManager:Send_ServerToAllClients("response_errortext",{errortext = "error_buy_error", })
				return
			elseif 501 == hBody.code then
				-- body
				game_playerinfo:RollBackBagItem(nPlayerID,args.prize_list)
				CustomGameEventManager:Send_ServerToAllClients("response_errortext",{errortext = "error_only_buyonce", })
				return
			elseif 502 == hBody.code then
				-- body
				game_playerinfo:RollBackBagItem(nPlayerID,args.prize_list)
				CustomGameEventManager:Send_ServerToAllClients("response_errortext",{errortext = "error_no_enought_coin", })
				return
			elseif 503 == hBody.code then
				-- body
				game_playerinfo:RollBackBagItem(nPlayerID,args.prize_list)
				CustomGameEventManager:Send_ServerToAllClients("response_errortext",{errortext = "error_no_enought_passlevel", })
				return
			elseif 504 == hBody.code then
				-- body
				game_playerinfo:RollBackBagItem(nPlayerID,args.prize_list)
				CustomGameEventManager:Send_ServerToAllClients("response_errortext",{errortext = "error_no_enought_maplevel", })
				return
			end
			
			game_playerinfo:reload_playerstore_by_server(nSteamID, hBody.data.archiveSpends)
			spend_archive[nPlayerID] = hBody.data.archiveSpends

			CustomNetTables:SetTableValue("service", "player_store", Store:GetData())
			-- print(" useItemKey: "..tParams.useItemKey)
			if not string.find(tParams.useItemKey, "finishBoss") then
				if tParams.useItemKey~="Sand_sea_pursuit" then
					CustomGameEventManager:Send_ServerToPlayer(PlayerResource:GetPlayer(nPlayerID),"UseItemCallback",{levelRewardsList = game_playerinfo:GetLevelRewardsSign(nSteamID), prize_list = args.prize_list})
				else
					local player_info = game_playerinfo:get_player_info()[tParams.steamId]
			
					CustomGameEventManager:Send_ServerToPlayer(PlayerResource:GetPlayer(nPlayerID),"response_open_box",{onceNumber = (player_info["onceBoxNumber"] or 0), prize_list = args.prize_list})
				end
			end
			-- DeepPrintTable(Store:GetData())
			-- 商城货币更新
			Account:UpAccountByPlayerID(nPlayerID, hBody.data.account)
			-- 使用道具后要存档
			game_playerinfo:save_archiveby_playerid(args.PlayerID)
		else
			-- 使用失败,道具回滚
			game_playerinfo:RollBackBagItem(nPlayerID,args.prize_list)
			if hBody then
				-- body
				CustomGameEventManager:Send_ServerToPlayer(PlayerResource:GetPlayer(nPlayerID),"response_errortext",{errortext = hBody.code})
			end
		end
		global_var_func.useGoodsLock[nPlayerID + 1] = false
	end, REQUEST_TIME_OUT)
end


function Store:UpdatePlayerGoods(nPlayerID)
	local nSteamID = PlayerResource:GetSteamAccountID(nPlayerID)
	Service:HTTPRequest("POST", ACTION_STORE_LOAD_ACCOUNT, { steamId = nSteamID }, function(iStatusCode, sBody)
		if iStatusCode == 200 then
			local hBody = JSON.decode(sBody)
			spend_archive[nPlayerID] = hBody.data
			-- print(">>>>>>>>>>>>>>>>>>>  UpdatePlayerGoods: ")
			-- DeepPrintTable(hBody.data)
			game_playerinfo:http_load_playerstore_by_server(nSteamID, hBody.data)
			-- for key, value in pairs(hBody.data) do
			-- 	game_playerinfo:update_vip_properties_by_playerid(nPlayerID, key)
			-- end
			-- 更新账号晶石情况
			print("UpdatePlayerGoods & Account:UpAccount")
			CustomNetTables:SetTableValue("service", "player_store", Store:GetData())
			CustomGameEventManager:Send_ServerToPlayer(PlayerResource:GetPlayer(nPlayerID),"PayServiceItemCallback",hBody)
			Account:UpAccount(nPlayerID);
		end
	end, REQUEST_TIME_OUT)

end

function Store:LoadPlayerGoods(nPlayerID)
	local nSteamID = PlayerResource:GetSteamAccountID(nPlayerID)
	Service:HTTPRequest("POST", ACTION_STORE_LOAD_ACCOUNT, { steamId = nSteamID }, function(iStatusCode, sBody)
		-- print(">>>>>>>>>>>>>>>>>>>  LoadPlayerGoods iStatusCode: "..iStatusCode)
		if iStatusCode == 200 then
			local hBody = JSON.decode(sBody)
			-- print(">>>>>>>>>>>>>>>>>>>  spend_archive: "..#hBody.data)
			-- DeepPrintTable(hBody)
			game_playerinfo:init_playerstore(nSteamID)
			if hBody then
				game_playerinfo:http_load_playerstore_by_server(nSteamID, hBody.data)
			end
			spend_archive[nPlayerID] = hBody.data
			
			CustomNetTables:SetTableValue("service", "player_store", Store:GetData())
			CustomGameEventManager:Send_ServerToPlayer(PlayerResource:GetPlayer(nPlayerID),"UpdatPlayerStore",hBody)
		else
			game_playerinfo:init_playerstore(nSteamID)
		end
	end, REQUEST_TIME_OUT)
end

-- 清理对应玩家存档字段
function Store:ClearPlayerProfile(nPlayerID)
	if spend_archive[nPlayerID] then
		spend_archive[nPlayerID] = {}
	end
end

function Store:GetData(nPlayerID)
	if nPlayerID == nil then
		return spend_archive
	else 
		return spend_archive[nPlayerID]
	end
end

-- 对应货币增加值
function Store:AddCoinToArchive(nPlayerID, key, value)
	if not spend_archive[nPlayerID] then
		spend_archive[nPlayerID] = {}
	end
	if not spend_archive[nPlayerID][key] then
		spend_archive[nPlayerID][key] = value
	else
		spend_archive[nPlayerID][key] = spend_archive[nPlayerID][key] + value
	end
end

-- 对应字段新增值，只能是货币类型
function Store:AddCustomGoodsValue(nPlayerID,sCurrency,nQuantity)
	-- body
	local nSteamID = PlayerResource:GetSteamAccountID(nPlayerID)
	Service:HTTPRequest("POST", ACTION_STORE_ADD_CURRENCY, { steamId = nSteamID, currency = sCurrency, quantity = nQuantity}, function(iStatusCode, sBody)
		if iStatusCode == 200 then
			local hBody = JSON.decode(sBody)
			spend_archive[nPlayerID] = hBody.data
			CustomNetTables:SetTableValue("service", "player_store", Store:GetData())
			CustomGameEventManager:Send_ServerToPlayer(PlayerResource:GetPlayer(nPlayerID),"UpdatPlayerStore",hBody)
		end
	end, REQUEST_TIME_OUT)
end
