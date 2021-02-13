
require("info/game_playerinfo")

LinkLuaModifier("modifier_aure_health_lua","ability/abilities_lua/aure_health_lua",LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier("modifier_aure_return_health_lua","ability/abilities_lua/aure_health_lua",LUA_MODIFIER_MOTION_NONE )

--------------------------------------------------------------------------------

aure_health_lua = class({})

function aure_health_lua:GetIntrinsicModifierName()
	return "modifier_aure_health_lua"
end
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------

modifier_aure_health_lua = class({})

--------------------------------------------------------------------------------

function modifier_aure_health_lua:DeclareFunctions()
    local funcs = {
		
    }
    return funcs
end

function modifier_aure_health_lua:IsHidden()
    return true
end

function modifier_aure_health_lua:IsAura()
    return true
end

function modifier_aure_health_lua:IsAuraActiveOnDeath()
    return true
end

function modifier_aure_health_lua:GetAuraRadius()
    return 1200
end

function modifier_aure_health_lua:GetModifierAura()
    return "modifier_aure_return_health_lua"
end

function modifier_aure_health_lua:GetAuraSearchTeam()
    return DOTA_UNIT_TARGET_TEAM_FRIENDLY
end

function modifier_aure_health_lua:GetAuraSearchType()
    return DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC
end

function modifier_aure_health_lua:GetAuraSearchFlags()
    return DOTA_UNIT_TARGET_FLAG_NONE
end

function modifier_aure_health_lua:OnCreated( kv )
    if not IsServer() then
        return
    end
end

modifier_aure_return_health_lua = class({})
--------------------------------------------------------------------------------

function modifier_aure_return_health_lua:DeclareFunctions()
    local funcs = {
        MODIFIER_PROPERTY_HEALTH_REGEN_CONSTANT,
    }
    return funcs
end


function modifier_aure_return_health_lua:OnCreated( kv )
    if not IsServer( ) then
        return
    end
end

function modifier_aure_return_health_lua:GetModifierConstantHealthRegen()
    if not IsServer( ) then
        local HealthRegen = CustomNetTables:GetTableValue("dynamic_properties", "HealthRegen"..tostring(self:GetParent():GetPlayerOwnerID())) or { HealthRegen = 0 }
        return HealthRegen.HealthRegen
    end
    local HealthRegen = self:GetParent():GetMaxHealth()*0.02
    CustomNetTables:SetTableValue("dynamic_properties", "HealthRegen"..tostring(self:GetParent():GetPlayerOwnerID()), { HealthRegen = HealthRegen})
    return HealthRegen
end
