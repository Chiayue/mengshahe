

require("info/game_playerinfo")
require("info/shop_iteminfo")

local JSON = require("dkjson")

local server_url = "http://47.108.61.165:80" 
-- local server_url = "http://192.168.250.92:80"

if not shop_request then
    shop_request = class({})
end



function shop_request:pay_item(player_id, goods_id, pay_type)
    -- 付费购买道具
    local steam_id = PlayerResource:GetSteamAccountID(player_id)
    local dataParams = {}
    -- dataParams.gameCode = global_var_func:GloFunc_Getgame_enum().GAME_CODE
    dataParams.playerId = steam_id
    dataParams.goodsId = goods_id
    dataParams.payWay = pay_type

    local request = CreateHTTPRequest("POST", server_url.."/system/order/buyGoods")
    request:SetHTTPRequestHeaderValue("Content-Type", "application/json;charset=uft-8")
    request:SetHTTPRequestRawPostBody("application/json", JSON.encode(dataParams))
    request:Send(
        function(result)
            local re_code = result.StatusCode;
            if 200==re_code then
                local req_Body = JSON.decode(result.Body);
                if not req_Body then
                    return
                end
                self:pay_item_result(player_id, req_Body)
            end
        end
    )
end

function shop_request:pay_item_result(player_id, req_Body)
    if req_Body.code == 200 then
        send_tips_message(player_id, "购买成功")
    else
        send_tips_message(player_id, req_Body.msg)
    end
    -- DeepPrintTable(data)
end

function shop_request:load_shop_list()
    -- 读取商品列表
    local dataParams = {}
    dataParams.gameCode = global_var_func:GloFunc_Getgame_enum().GAME_CODE
    -- dataParams.gameCode = "archers_survive"

    local request = CreateHTTPRequest("POST", server_url.."/system/goods/getGoodList")
    request:SetHTTPRequestHeaderValue("Content-Type", "application/json;charset=uft-8")
    request:SetHTTPRequestRawPostBody("application/json", JSON.encode(dataParams))
    request:Send(
        function(result)
            local re_code = result.StatusCode;
            if 200==re_code then
                local req_Body = JSON.decode(result.Body);
                if not req_Body then
                    return
                end
                -- DeepPrintTable(req_Body.data)
                for key, value in ipairs(req_Body.data) do
                    shop_iteminfo:update_item_list(value)
                end
                -- print(">>>>>>>>>>>>>>>>>>>>>分割线>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>")
                -- DeepPrintTable(shop_iteminfo:get_shop_item_list())
            end
        end
    )
end