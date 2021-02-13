aura_increase_magical_resistance = class({})

function aura_increase_magical_resistance:GetIntrinsicModifierName()
	return "modifier_aura_increase_magical_resistance"
end

------------------------------------------------------------------------------------------------------------

LinkLuaModifier("modifier_aura_increase_magical_resistance","ability/abilities_lua/aura_increase_magical_resistance" ,LUA_MODIFIER_MOTION_NONE)

modifier_aura_increase_magical_resistance = class({})

function modifier_aura_increase_magical_resistance:IsHidden()
    return true
end

function modifier_aura_increase_magical_resistance:IsAura()
    return true
end

function modifier_aura_increase_magical_resistance:GetAuraRadius()
    return 1200
end

function modifier_aura_increase_magical_resistance:GetModifierAura()
    return "modifier_aura_increase_magical_resistance_buff"
end

function modifier_aura_increase_magical_resistance:GetAuraSearchTeam()
    return DOTA_UNIT_TARGET_TEAM_FRIENDLY
end

function modifier_aura_increase_magical_resistance:GetAuraSearchType()
    return DOTA_UNIT_TARGET_ALL
end

function modifier_aura_increase_magical_resistance:GetAuraSearchFlags()
    return DOTA_UNIT_TARGET_FLAG_NONE
end

------------------------------------------------------------------------------------------------------------

LinkLuaModifier("modifier_aura_increase_magical_resistance_buff","ability/abilities_lua/aura_increase_magical_resistance" ,LUA_MODIFIER_MOTION_NONE)

modifier_aura_increase_magical_resistance_buff = class({})

function modifier_aura_increase_magical_resistance_buff:DeclareFunctions()
    return {
        MODIFIER_PROPERTY_MAGICAL_RESISTANCE_BONUS,
    }
end

function modifier_aura_increase_magical_resistance_buff:GetModifierMagicalResistanceBonus(event)
    return self:GetStackCount()
end

function modifier_aura_increase_magical_resistance_buff:OnCreated(kv)
    if IsServer() then
        if global_var_func.current_round >=1 and global_var_func.current_round <= 27 then
            self:SetStackCount(10)
        else
            self:SetStackCount(30)
        end
    end
end