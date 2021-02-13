aura_increase_attack_damage = class({})

function aura_increase_attack_damage:GetIntrinsicModifierName()
	return "modifier_aura_increase_attack_damage"
end

------------------------------------------------------------------------------------------------------------

LinkLuaModifier("modifier_aura_increase_attack_damage","ability/abilities_lua/aura_increase_attack_damage" ,LUA_MODIFIER_MOTION_NONE)

modifier_aura_increase_attack_damage = class({})

function modifier_aura_increase_attack_damage:IsHidden()
    return true
end

function modifier_aura_increase_attack_damage:IsAura()
    return true
end

function modifier_aura_increase_attack_damage:GetAuraRadius()
    return 1200
end

function modifier_aura_increase_attack_damage:GetModifierAura()
    return "modifier_aura_increase_attack_damage_buff"
end

function modifier_aura_increase_attack_damage:GetAuraSearchTeam()
    return DOTA_UNIT_TARGET_TEAM_FRIENDLY
end

function modifier_aura_increase_attack_damage:GetAuraSearchType()
    return DOTA_UNIT_TARGET_ALL
end

function modifier_aura_increase_attack_damage:GetAuraSearchFlags()
    return DOTA_UNIT_TARGET_FLAG_NONE
end

------------------------------------------------------------------------------------------------------------

LinkLuaModifier("modifier_aura_increase_attack_damage_buff","ability/abilities_lua/aura_increase_attack_damage" ,LUA_MODIFIER_MOTION_NONE)

modifier_aura_increase_attack_damage_buff = class({})

function modifier_aura_increase_attack_damage_buff:DeclareFunctions()
    return {
        MODIFIER_PROPERTY_DAMAGEOUTGOING_PERCENTAGE,
    }
end

function modifier_aura_increase_attack_damage_buff:GetModifierDamageOutgoing_Percentage(event)
    return self:GetStackCount()
end

function modifier_aura_increase_attack_damage_buff:OnCreated(kv)
    if IsServer() then
        if global_var_func.current_round >=1 and global_var_func.current_round <= 27 then
            self:SetStackCount(50)
        else
            self:SetStackCount(150)
        end
    end
end