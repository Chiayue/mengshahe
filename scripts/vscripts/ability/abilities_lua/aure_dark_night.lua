aure_dark_night = class({})

function aure_dark_night:GetIntrinsicModifierName()
	return "modifier_aure_dark_night"
end

------------------------------------------------------------------------------------------------------------

LinkLuaModifier("modifier_aure_dark_night","ability/abilities_lua/aure_dark_night" ,LUA_MODIFIER_MOTION_NONE)

modifier_aure_dark_night = class({})

function modifier_aure_dark_night:IsHidden()
    return true
end

function modifier_aure_dark_night:IsAura()
    return true
end

function modifier_aure_dark_night:GetAuraRadius()
    return 1200
end

function modifier_aure_dark_night:GetModifierAura()
    return "modifier_aure_dark_night_debuff"
end

function modifier_aure_dark_night:GetAuraSearchTeam()
    return DOTA_UNIT_TARGET_TEAM_ENEMY
end

function modifier_aure_dark_night:GetAuraSearchType()
    return DOTA_UNIT_TARGET_ALL
end

function modifier_aure_dark_night:GetAuraSearchFlags()
    return DOTA_UNIT_TARGET_FLAG_NONE
end

------------------------------------------------------------------------------------------------------------

LinkLuaModifier("modifier_aure_dark_night_debuff","ability/abilities_lua/aure_dark_night" ,LUA_MODIFIER_MOTION_NONE)

modifier_aure_dark_night_debuff = class({})

function modifier_aure_dark_night_debuff:DeclareFunctions()
    return {
        MODIFIER_PROPERTY_MISS_PERCENTAGE,
    }
end

function modifier_aure_dark_night_debuff:GetModifierMiss_Percentage(event)
    return self:GetStackCount()
end

function modifier_aure_dark_night_debuff:OnCreated(kv)
    if IsServer() then
        if global_var_func.current_round >=1 and global_var_func.current_round <= 27 then
            self:SetStackCount(10)
        else
            self:SetStackCount(20)
        end
    end
end