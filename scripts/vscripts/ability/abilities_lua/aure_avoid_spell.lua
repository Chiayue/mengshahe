aure_avoid_spell = class({})

function aure_avoid_spell:GetIntrinsicModifierName()
	return "modifier_aure_avoid_spell"
end

------------------------------------------------------------------------------------------------------------

LinkLuaModifier("modifier_aure_avoid_spell","ability/abilities_lua/aure_avoid_spell" ,LUA_MODIFIER_MOTION_NONE)

modifier_aure_avoid_spell = class({})

function modifier_aure_avoid_spell:IsHidden()
    return true
end

function modifier_aure_avoid_spell:IsAura()
    return true
end

function modifier_aure_avoid_spell:GetAuraRadius()
    return 1200
end

function modifier_aure_avoid_spell:GetModifierAura()
    return "modifier_aure_avoid_spell_buff"
end

function modifier_aure_avoid_spell:GetAuraSearchTeam()
    return DOTA_UNIT_TARGET_TEAM_FRIENDLY
end

function modifier_aure_avoid_spell:GetAuraSearchType()
    return DOTA_UNIT_TARGET_ALL
end

function modifier_aure_avoid_spell:GetAuraSearchFlags()
    return DOTA_UNIT_TARGET_FLAG_NONE
end

------------------------------------------------------------------------------------------------------------

LinkLuaModifier("modifier_aure_avoid_spell_buff","ability/abilities_lua/aure_avoid_spell" ,LUA_MODIFIER_MOTION_NONE)

modifier_aure_avoid_spell_buff = class({})

function modifier_aure_avoid_spell_buff:DeclareFunctions()
    return {
        MODIFIER_PROPERTY_AVOID_DAMAGE,
    }
end

function modifier_aure_avoid_spell_buff:GetModifierAvoidDamage(event)
    if event.damage_category == DOTA_DAMAGE_CATEGORY_SPELL and RollPercentage(10) then
        return 1
    end
    return 0
end