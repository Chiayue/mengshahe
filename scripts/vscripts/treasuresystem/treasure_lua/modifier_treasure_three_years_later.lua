---------------------------------------------------------------------------
-- 宝物：三年之期已到
---------------------------------------------------------------------------

if modifier_treasure_three_years_later == nil then 
    modifier_treasure_three_years_later = class({})
end

function modifier_treasure_three_years_later:GetTexture()
    if self:GetDuration() < 0 then
        return "buff/modifier_treasure_three_years_later"
    end
    return "buff/modifier_treasure_keep_changing"
end

function modifier_treasure_three_years_later:IsHidden()
    return false
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

function modifier_treasure_three_years_later:OnCreated(kv)
    if IsServer() then
        local parent = self:GetParent()
        parent:RemoveModifierByName("modifier_treasure_matrilocal_debuff")
        parent:RemoveModifierByName("modifier_treasure_tolerance_debuff")
        parent:RemoveModifierByName("modifier_treasure_tolerance")
        parent:RemoveModifierByName("modifier_treasure_matrilocal")
    end
end