aura_decrease_move_speed = class({})

function aura_decrease_move_speed:GetIntrinsicModifierName()
	return "modifier_aura_decrease_move_speed"
end

------------------------------------------------------------------------------------------------------------

LinkLuaModifier("modifier_aura_decrease_move_speed","ability/abilities_lua/aura_decrease_move_speed" ,LUA_MODIFIER_MOTION_NONE)

modifier_aura_decrease_move_speed = class({})

function modifier_aura_decrease_move_speed:IsHidden()
    return true
end

function modifier_aura_decrease_move_speed:IsAura()
    return true
end

function modifier_aura_decrease_move_speed:GetAuraRadius()
    return 1200
end

function modifier_aura_decrease_move_speed:GetModifierAura()
    return "modifier_aura_decrease_move_speed_debuff"
end

function modifier_aura_decrease_move_speed:GetAuraSearchTeam()
    return DOTA_UNIT_TARGET_TEAM_ENEMY
end

function modifier_aura_decrease_move_speed:GetAuraSearchType()
    return DOTA_UNIT_TARGET_ALL
end

function modifier_aura_decrease_move_speed:GetAuraSearchFlags()
    return DOTA_UNIT_TARGET_FLAG_NONE
end

------------------------------------------------------------------------------------------------------------

LinkLuaModifier("modifier_aura_decrease_move_speed_debuff","ability/abilities_lua/aura_decrease_move_speed" ,LUA_MODIFIER_MOTION_NONE)

modifier_aura_decrease_move_speed_debuff = class({})

function modifier_aura_decrease_move_speed_debuff:DeclareFunctions()
    return {
        MODIFIER_PROPERTY_MOVESPEED_BONUS_CONSTANT,
    }
end

function modifier_aura_decrease_move_speed_debuff:GetModifierMoveSpeedBonus_Constant(event)
    return self:GetStackCount()
end

function modifier_aura_decrease_move_speed_debuff:OnCreated(kv)
    if IsServer() then
        if global_var_func.current_round >=1 and global_var_func.current_round <= 27 then
            self:SetStackCount(-50)
        else
            self:SetStackCount(-200)
        end
    end
end