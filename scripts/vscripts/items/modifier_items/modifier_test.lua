require("items/lua_items_ability/item_ability")

if modifier_test == nil then 
    modifier_test = class({})
end

--暴击modifier
function modifier_test:DeclareFunctions()
    local funcs = {
        MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE,
        MODIFIER_PROPERTY_DAMAGEOUTGOING_PERCENTAGE,
    }
    return funcs
end

function modifier_test:GetModifierIncomingDamage_Percentage(params)
    return -10
end

function modifier_test:GetModifierDamageOutgoing_Percentage(params)
    return 20
end

