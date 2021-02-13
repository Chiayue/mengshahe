-- 宝物: 假发

LinkLuaModifier( "modifier_treasure_attack_miss","treasuresystem/treasure_lua/modifier_treasure_wig", LUA_MODIFIER_MOTION_NONE )

----------------------------------------------------------------------------------

modifier_treasure_wig = class({})

function modifier_treasure_wig:DeclareFunctions()
    local funcs = {
    }
    return funcs
end

function modifier_treasure_wig:GetTexture()
    if self:GetDuration() < 0 then
        return "buff/modifier_treasure_wig"
    end
    return "buff/modifier_treasure_keep_changing"
end

function modifier_treasure_wig:IsAura()
    return true
end

function modifier_treasure_wig:IsAuraActiveOnDeath()
    return true
end

function modifier_treasure_wig:GetAuraRadius()
    return 900
end

function modifier_treasure_wig:GetModifierAura()
    return "modifier_treasure_attack_miss"
end

function modifier_treasure_wig:GetAuraSearchTeam()
    return DOTA_UNIT_TARGET_TEAM_ENEMY
end

function modifier_treasure_wig:GetAuraSearchType()
    return DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC
end

function modifier_treasure_wig:GetAuraSearchFlags()
    return DOTA_UNIT_TARGET_FLAG_NONE
end

function modifier_treasure_wig:OnCreated( kv )
    if not IsServer() then
        return
    end
end

--------------------------------------------------------------------------------
modifier_treasure_attack_miss = class({})

function modifier_treasure_attack_miss:IsHidden()
    return true
end

function modifier_treasure_attack_miss:DeclareFunctions()
    local funcs = {
        MODIFIER_PROPERTY_MISS_PERCENTAGE,
    }
    return funcs
end


function modifier_treasure_attack_miss:OnCreated( kv )
    if not IsServer( ) then
        return
    end
    self.caster = self:GetParent();
end

function modifier_treasure_attack_miss:GetModifierMiss_Percentage(params)
	return 15
end