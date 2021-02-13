
-- 商城系统,管理所有商城相关的道具

if shop_iteminfo == nil then
    shop_iteminfo = class({})
end

-- 所有玩家都能看到的统一模板
local shop_info = {
    --  模拟数据,测试用
    -- {    
    --     ["name"] = "青铜",       -- 道具名称
    --     ["value_1"] = 1,            -- 模拟道具数据1
    --     ["value_2"] = 4,            -- 模拟道具数据2
    --     ["value_3"] = 7,            -- 模拟道具数据3
    -- },
}

function shop_iteminfo:update_item_list(info_value)
    -- 更新商城道具列表
    local shop_item = {}
    -- DeepPrintTable(info_value)
    for key, value in pairs(info_value) do
        if key~="params" then
            shop_item[key] = value
        end
    end
    table.insert(shop_info, shop_item)
end

function shop_iteminfo:get_shop_item_list()
    -- 获取道具列表
    return shop_info
end

function shop_iteminfo:get_goods_info(goods_id)
    -- 获取对应ID道具的属性
    for key, value in ipairs(shop_info) do
        if value.id == goods_id then
            return value
        end
    end
    return nil
end