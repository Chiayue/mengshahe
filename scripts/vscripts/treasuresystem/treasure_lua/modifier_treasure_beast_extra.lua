-- 兽王
if modifier_treasure_beast_extra == nil then 
    modifier_treasure_beast_extra = class({})
end

function modifier_treasure_beast_extra:IsHidden() return true end
function modifier_treasure_beast_extra:RemoveOnDeath() return false end

function modifier_treasure_beast_extra:DeclareFunctions()
    local funcs = {
        MODIFIER_PROPERTY_DAMAGEOUTGOING_PERCENTAGE,
        MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
    }
    return funcs
end

function modifier_treasure_beast_extra:GetModifierDamageOutgoing_Percentage()
    return 100 
end

function modifier_treasure_beast_extra:GetModifierAttackSpeedBonus_Constant()
    return 100 
end

if modifier_treasure_beast_extra_hero == nil then 
    modifier_treasure_beast_extra_hero = class({})
end

function modifier_treasure_beast_extra_hero:IsHidden() return false end
function modifier_treasure_beast_extra_hero:IsAuraActiveOnDeath() return true end
function modifier_treasure_beast_extra_hero:RemoveOnDeath() return false end
function modifier_treasure_beast_extra_hero:IsAura() return true end
function modifier_treasure_beast_extra_hero:GetAuraDuration() return 0.1 end
function modifier_treasure_beast_extra_hero:GetAuraRadius() return 999999 end
function modifier_treasure_beast_extra_hero:GetAuraSearchFlags() return DOTA_UNIT_TARGET_FLAG_INVULNERABLE end
function modifier_treasure_beast_extra_hero:GetAuraSearchTeam() return DOTA_UNIT_TARGET_TEAM_FRIENDLY end
function modifier_treasure_beast_extra_hero:GetAuraSearchType() return DOTA_UNIT_TARGET_BASIC end
function modifier_treasure_beast_extra_hero:GetModifierAura() return "modifier_treasure_beast_extra" end

function modifier_treasure_beast_extra_hero:CheckState() 
    return {[MODIFIER_STATE_DISARMED] = true} 
end