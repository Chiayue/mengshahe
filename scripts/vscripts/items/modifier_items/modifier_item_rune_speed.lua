if modifier_item_rune_speed == nil then 
    modifier_item_rune_speed = class({})
end

--移速modifier
function modifier_item_rune_speed:DeclareFunctions()
    local funcs = {
        MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
    }
    return funcs
end


function modifier_item_rune_speed:GetTexture()
    return "buff/energy4"
end

function modifier_item_rune_speed:GetModifierMoveSpeedBonus_Percentage(param)
    return 100
end