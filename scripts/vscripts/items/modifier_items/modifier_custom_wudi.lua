
if modifier_custom_wudi == nil then 
    modifier_custom_wudi = class({})
end

--暴击modifier
function modifier_custom_wudi:DeclareFunctions()
    local funcs = {
        MODIFIER_STATE_INVULNERABLE,
    }
    return funcs
end

function modifier_custom_wudi:GetTexture()
    return "buff/invincible"
end

function modifier_custom_wudi:CheckState()
    local states = {
        [MODIFIER_STATE_INVULNERABLE] = true,
    }
    return states
end


