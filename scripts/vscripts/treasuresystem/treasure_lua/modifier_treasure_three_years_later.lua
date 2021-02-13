---------------------------------------------------------------------------
-- 宝物：三年之期已到
---------------------------------------------------------------------------

if modifier_treasure_three_years_later == nil then 
    modifier_treasure_three_years_later = class({})
end

function modifier_treasure_three_years_later:IsHidden()
    return true
end

function modifier_treasure_three_years_later:IsPurgable()
    return false
end
 
function modifier_treasure_three_years_later:RemoveOnDeath()
    return false
end

function modifier_treasure_three_years_later:DeclareFunctions()
    return {
        MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
        MODIFIER_PROPERTY_STATS_AGILITY_BONUS,
        MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,
    }
end

function modifier_treasure_three_years_later:GetModifierBonusStats_Strength()
    return 500
end

function modifier_treasure_three_years_later:GetModifierBonusStats_Agility()
    return 500
end

function modifier_treasure_three_years_later:GetModifierBonusStats_Intellect()
    return 500
end