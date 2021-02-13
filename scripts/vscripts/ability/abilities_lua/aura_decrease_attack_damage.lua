aura_decrease_attack_damage = class({})

function aura_decrease_attack_damage:GetIntrinsicModifierName()
	return "modifier_aura_decrease_attack_damage"
end

------------------------------------------------------------------------------------------------------------

LinkLuaModifier("modifier_aura_decrease_attack_damage","ability/abilities_lua/aura_decrease_attack_damage" ,LUA_MODIFIER_MOTION_NONE)

modifier_aura_decrease_attack_damage = class({})

function modifier_aura_decrease_attack_damage:IsHidden()
    return true
end

function modifier_aura_decrease_attack_damage:IsAura()
    return true
end

function modifier_aura_decrease_attack_damage:GetAuraRadius()
    return 1200
end

function modifier_aura_decrease_attack_damage:GetModifierAura()
    return "modifier_aura_decrease_attack_damage_debuff"
end

function modifier_aura_decrease_attack_damage:GetAuraSearchTeam()
    return DOTA_UNIT_TARGET_TEAM_ENEMY
end

function modifier_aura_decrease_attack_damage:GetAuraSearchType()
    return DOTA_UNIT_TARGET_ALL
end

function modifier_aura_decrease_attack_damage:GetAuraSearchFlags()
    return DOTA_UNIT_TARGET_FLAG_NONE
end

------------------------------------------------------------------------------------------------------------

LinkLuaModifier("modifier_aura_decrease_attack_damage_debuff","ability/abilities_lua/aura_decrease_attack_damage" ,LUA_MODIFIER_MOTION_NONE)

modifier_aura_decrease_attack_damage_debuff = class({})

function modifier_aura_decrease_attack_damage_debuff:DeclareFunctions()
    return {
        MODIFIER_PROPERTY_DAMAGEOUTGOING_PERCENTAGE,
    }
end

function modifier_aura_decrease_attack_damage_debuff:GetModifierDamageOutgoing_Percentage(event)
    return self:GetStackCount()
end

function modifier_aura_decrease_attack_damage_debuff:OnCreated(kv)
    if IsServer() then
        if global_var_func.current_round >=1 and global_var_func.current_round <= 27 then
            self:SetStackCount(-20)
        else
            self:SetStackCount(-80)
        end
    end
end