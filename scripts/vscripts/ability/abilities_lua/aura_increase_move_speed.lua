aura_increase_move_speed = class({})

function aura_increase_move_speed:GetIntrinsicModifierName()
	return "modifier_aura_increase_move_speed"
end

------------------------------------------------------------------------------------------------------------

LinkLuaModifier("modifier_aura_increase_move_speed","ability/abilities_lua/aura_increase_move_speed" ,LUA_MODIFIER_MOTION_NONE)

modifier_aura_increase_move_speed = class({})

function modifier_aura_increase_move_speed:IsHidden()
    return true
end

function modifier_aura_increase_move_speed:IsAura()
    return true
end

function modifier_aura_increase_move_speed:GetAuraRadius()
    return 1200
end

function modifier_aura_increase_move_speed:GetModifierAura()
    return "modifier_aura_increase_move_speed_buff"
end

function modifier_aura_increase_move_speed:GetAuraSearchTeam()
    return DOTA_UNIT_TARGET_TEAM_FRIENDLY
end

function modifier_aura_increase_move_speed:GetAuraSearchType()
    return DOTA_UNIT_TARGET_ALL
end

function modifier_aura_increase_move_speed:GetAuraSearchFlags()
    return DOTA_UNIT_TARGET_FLAG_NONE
end

------------------------------------------------------------------------------------------------------------

LinkLuaModifier("modifier_aura_increase_move_speed_buff","ability/abilities_lua/aura_increase_move_speed" ,LUA_MODIFIER_MOTION_NONE)

modifier_aura_increase_move_speed_buff = class({})

function modifier_aura_increase_move_speed_buff:DeclareFunctions()
    return {
        MODIFIER_PROPERTY_MOVESPEED_BONUS_CONSTANT,
    }
end

function modifier_aura_increase_move_speed_buff:GetModifierMoveSpeedBonus_Constant(event)
    return self:GetStackCount()
end

function modifier_aura_increase_move_speed_buff:OnCreated(kv)
    if IsServer() then
        if global_var_func.current_round >=1 and global_var_func.current_round <= 27 then
            self:SetStackCount(50)
        else
            self:SetStackCount(150)
        end
    end
end