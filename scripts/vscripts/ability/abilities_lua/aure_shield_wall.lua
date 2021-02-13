aure_shield_wall = class({})

function aure_shield_wall:GetIntrinsicModifierName()
	return "modifier_aure_shield_wall"
end

------------------------------------------------------------------------------------------------------------

LinkLuaModifier("modifier_aure_shield_wall","ability/abilities_lua/aure_shield_wall" ,LUA_MODIFIER_MOTION_NONE)

modifier_aure_shield_wall = class({})

function modifier_aure_shield_wall:IsHidden()
    return true
end

function modifier_aure_shield_wall:IsAura()
    return true
end

function modifier_aure_shield_wall:GetAuraRadius()
    return 1200
end

function modifier_aure_shield_wall:GetModifierAura()
    return "modifier_aure_shield_wall_buff"
end

function modifier_aure_shield_wall:GetAuraSearchTeam()
    return DOTA_UNIT_TARGET_TEAM_FRIENDLY
end

function modifier_aure_shield_wall:GetAuraSearchType()
    return DOTA_UNIT_TARGET_ALL
end

function modifier_aure_shield_wall:GetAuraSearchFlags()
    return DOTA_UNIT_TARGET_FLAG_NONE
end

------------------------------------------------------------------------------------------------------------

LinkLuaModifier("modifier_aure_shield_wall_buff","ability/abilities_lua/aure_shield_wall" ,LUA_MODIFIER_MOTION_NONE)

modifier_aure_shield_wall_buff = class({})

function modifier_aure_shield_wall_buff:DeclareFunctions()
    return {
        MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE,
    }
end

function modifier_aure_shield_wall_buff:GetModifierIncomingDamage_Percentage()
    return self:GetStackCount()
end

function modifier_aure_shield_wall_buff:OnCreated(kv)
    if IsServer() then
        if global_var_func.current_round >=1 and global_var_func.current_round <= 27 then
            self:SetStackCount(-5)
        else
            self:SetStackCount(-20)
        end
    end
end