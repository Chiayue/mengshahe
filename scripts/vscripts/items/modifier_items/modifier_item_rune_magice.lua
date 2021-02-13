require("items/lua_items_ability/item_ability")

if modifier_item_rune_magice == nil then 
    modifier_item_rune_magice = class({})
end

--暴击modifier
function modifier_item_rune_magice:DeclareFunctions()
    local funcs = {
        MODIFIER_PROPERTY_COOLDOWN_PERCENTAGE,
    }
    return funcs
end


function modifier_item_rune_magice:GetTexture()
    return "buff/energy1"
end

function modifier_item_rune_magice:GetModifierPercentageCooldown(params)
    return 20
end