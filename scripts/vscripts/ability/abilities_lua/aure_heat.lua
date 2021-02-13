aure_heat = class({})

function aure_heat:GetIntrinsicModifierName()
	return "modifier_aure_heat"
end

------------------------------------------------------------------------------------------------------------

LinkLuaModifier("modifier_aure_heat","ability/abilities_lua/aure_heat" ,LUA_MODIFIER_MOTION_NONE)

modifier_aure_heat = class({})

function modifier_aure_heat:IsHidden()
    return true
end

function modifier_aure_heat:IsAura()
    return true
end

function modifier_aure_heat:GetAuraRadius()
    return 1200
end

function modifier_aure_heat:GetModifierAura()
    return "modifier_aure_heat_buff"
end

function modifier_aure_heat:GetAuraSearchTeam()
    return DOTA_UNIT_TARGET_TEAM_FRIENDLY
end

function modifier_aure_heat:GetAuraSearchType()
    return DOTA_UNIT_TARGET_ALL
end

function modifier_aure_heat:GetAuraSearchFlags()
    return DOTA_UNIT_TARGET_FLAG_NONE
end

------------------------------------------------------------------------------------------------------------

LinkLuaModifier("modifier_aure_heat_buff","ability/abilities_lua/aure_heat" ,LUA_MODIFIER_MOTION_NONE)

modifier_aure_heat_buff = class({})

function modifier_aure_heat_buff:DeclareFunctions()
    return {
        MODIFIER_PROPERTY_TOTALDAMAGEOUTGOING_PERCENTAGE,
    }
end

function modifier_aure_heat_buff:GetModifierTotalDamageOutgoing_Percentage()
    return 5
end