aura_decrease_physical_armor = class({})

function aura_decrease_physical_armor:GetIntrinsicModifierName()
	return "modifier_aura_decrease_physical_armor"
end

------------------------------------------------------------------------------------------------------------

LinkLuaModifier("modifier_aura_decrease_physical_armor","ability/abilities_lua/aura_decrease_physical_armor" ,LUA_MODIFIER_MOTION_NONE)

modifier_aura_decrease_physical_armor = class({})

function modifier_aura_decrease_physical_armor:IsHidden()
    return true
end

function modifier_aura_decrease_physical_armor:IsAura()
    return true
end

function modifier_aura_decrease_physical_armor:GetAuraRadius()
    return 1200
end

function modifier_aura_decrease_physical_armor:GetModifierAura()
    return "modifier_aura_decrease_physical_armor_debuff"
end

function modifier_aura_decrease_physical_armor:GetAuraSearchTeam()
    return DOTA_UNIT_TARGET_TEAM_ENEMY
end

function modifier_aura_decrease_physical_armor:GetAuraSearchType()
    return DOTA_UNIT_TARGET_ALL
end

function modifier_aura_decrease_physical_armor:GetAuraSearchFlags()
    return DOTA_UNIT_TARGET_FLAG_NONE
end

------------------------------------------------------------------------------------------------------------

LinkLuaModifier("modifier_aura_decrease_physical_armor_debuff","ability/abilities_lua/aura_decrease_physical_armor" ,LUA_MODIFIER_MOTION_NONE)

modifier_aura_decrease_physical_armor_debuff = class({})

function modifier_aura_decrease_physical_armor_debuff:DeclareFunctions()
    return {
        MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
    }
end

function modifier_aura_decrease_physical_armor_debuff:GetModifierPhysicalArmorBonus(event)
    return self:GetStackCount()
end

function modifier_aura_decrease_physical_armor_debuff:OnCreated(kv)
    if IsServer() then
        if global_var_func.current_round >=1 and global_var_func.current_round <= 27 then
            self:SetStackCount(-5)
        else
            self:SetStackCount(-15)
        end
    end
end