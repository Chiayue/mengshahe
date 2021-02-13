---------------------------------------------------------------------------
-- 宝物：遗失之物 - 折断的拐杖
---------------------------------------------------------------------------

if modifier_treasure_lost_stick == nil then 
    modifier_treasure_lost_stick = class({})
end

function modifier_treasure_lost_stick:GetTexture()
    if self:GetDuration() < 0 then
        return "buff/modifier_treasure_lost_stick"
    end
    return "buff/modifier_treasure_keep_changing"
end

function modifier_treasure_lost_stick:CheckState()
	return {}
end

function modifier_treasure_lost_stick:DeclareFunctions()
	return {
        MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,
        MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
    }
end

function modifier_treasure_lost_stick:GetModifierPreAttack_BonusDamage()
    return 1000
end

function modifier_treasure_lost_stick:GetModifierMoveSpeedBonus_Percentage()
    return -10
end

function modifier_treasure_lost_stick:IsPurgable()
    return false
end
 
function modifier_treasure_lost_stick:RemoveOnDeath()
    return false
end