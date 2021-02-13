require("service/archive")
require("service/store")
require("service/account")

local JSON = require("dkjson")
local sha = require("libraries/sha")

if Service == nil then
	Service = class({})
end


KEY = "GAMEMSHDH"
-- Address = "http://47.108.61.165/service"

-- Address2 = "http://api.woteng.cqgo.net"		-- 测试服
Address2 = "http://online.api.mirage.woaiwandota2.com/"

-- ServerKey = GetDedicatedServerKeyV2(KEY)
--ServerKey = "test"

-- 服务列表
-- MAP_CODE = "mirage_of_the_fall"									-- 地图编码

-- 其他常量
REQUEST_TIME_OUT = 30

function Service:init()
	print("Service:Init...")
	Archive:Init()
	Account:Init()
	Store:Init()
end

-- function Service:HTTPRequest2(sMethod, sAction, hParams, hFunc, fTimeout)
-- 	local szURL = Address .."/" ..sAction .. "?"
-- 	local handle = CreateHTTPRequestScriptVM(sMethod, szURL)
-- 	handle:SetHTTPRequestHeaderValue("Content-Type", "application/json;charset=uft-8")
-- 	if hParams == nil then hParams = {} end
-- 	hParams.serverKey = ServerKey
-- 	hParams.mapCode = global_var_func:GloFunc_Getgame_enum().GAME_CODE
-- 	-- print(JSON.encode(hParams))
-- 	-- DeepPrintTable(hParams)
-- 	handle:SetHTTPRequestRawPostBody("application/json", JSON.encode(hParams))
-- 	handle:SetHTTPRequestAbsoluteTimeoutMS((fTimeout or REQUEST_TIME_OUT) * 1000)
-- 	handle:Send(function(response)
-- 		--print(response.Body)
-- 		hFunc(response.StatusCode, response.Body, response)
-- 	end)
-- end

function Service:HTTPRequest(sMethod, sAction, hParams, hFunc, fTimeout)
	local szURL = Address2 .."/" ..sAction .. "?"
	local handle = CreateHTTPRequestScriptVM(sMethod, szURL)
	handle:SetHTTPRequestHeaderValue("Content-Type", "application/json;charset=uft-8")
	if hParams == nil then hParams = {} end
	hParams.randomCode = tostring(RandomInt(1, 99999999))
	local shakey = sha.sha256(hParams.randomCode..GetDedicatedServerKey(KEY))
	-- local shakey2 = sha.sha256(hParams.randomCode..GetDedicatedServerKeyV2(KEY))
	hParams.serverKey = shakey
	-- hParams.serverKey2 = shakey2
	hParams.mapCode = global_var_func:GloFunc_Getgame_enum().GAME_CODE
	-- hParams.dedicatedServerKey = GetDedicatedServerKey(KEY)
	-- hParams.dedicatedServerKey2 = GetDedicatedServerKeyV2(KEY)
	-- print(JSON.encode(hParams))
	handle:SetHTTPRequestRawPostBody("application/json", JSON.encode(hParams))
	handle:SetHTTPRequestAbsoluteTimeoutMS((fTimeout or REQUEST_TIME_OUT) * 1000)
	handle:Send(function(response)
		hFunc(response.StatusCode, response.Body, response)
	end)
end

function Service:HTTPRequestSync(sMethod, sAction, hParams, fTimeout)
	local co = coroutine.running()
	self:HTTPRequest(sMethod, sAction, hParams, function(iStatusCode, sBody, hResponse)
		print("HTTPRequestSync")
		coroutine.resume(co, iStatusCode, sBody, hResponse)
	end, fTimeout)
	return coroutine.yield()
end

function Service:LoadPlayerProfile(nPlayerID)
	Archive:LoadPlayerProfile(nPlayerID)
end

function Service:LoadPlayerGoods(nPlayerID)
	Store:LoadPlayerGoods(nPlayerID)
end

function Service:WriteTestPassword(nPlayerID,Password)
	Archive:WriteTestPassword(nPlayerID,Password)
end