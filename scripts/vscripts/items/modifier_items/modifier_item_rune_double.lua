if modifier_item_rune_double == nil then 
    modifier_item_rune_double = class({})
end

--暴击modifier
function modifier_item_rune_double:DeclareFunctions()
    local funcs = {
        MODIFIER_PROPERTY_DAMAGEOUTGOING_PERCENTAGE,
    }
    return funcs
end

function modifier_item_rune_double:GetTexture()
    return "buff/energy2"
end

function modifier_item_rune_double:GetModifierDamageOutgoing_Percentage(param)
    return 200
end
