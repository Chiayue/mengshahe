---------------------------------------------------------------------------
-- 宝物：抗毒MAX
---------------------------------------------------------------------------

if modifier_treasure_resistance_max == nil then 
    modifier_treasure_resistance_max = class({})
end

function modifier_treasure_resistance_max:GetTexture()
    if self:GetDuration() < 0 then
        return "buff/modifier_treasure_resistance_max"
    end
    return "buff/modifier_treasure_keep_changing"
end

function modifier_treasure_resistance_max:DeclareFunctions()
	return {
        MODIFIER_PROPERTY_STATS_AGILITY_BONUS,
        MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
        MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,
    }
end

function modifier_treasure_resistance_max:GetModifierBonusStats_Agility()
    return 500
end

function modifier_treasure_resistance_max:GetModifierBonusStats_Strength()
    return 500
end

function modifier_treasure_resistance_max:GetModifierBonusStats_Intellect()
    return 500
end

function modifier_treasure_resistance_max:IsHidden() 
    return false
end

function modifier_treasure_resistance_max:IsPurgable()
    return false
end
 
function modifier_treasure_resistance_max:RemoveOnDeath()
    return false
end

function modifier_treasure_resistance_max:OnCreated(kv) 
    if IsServer() then
        local parent = self:GetParent()
        parent:RemoveModifierByName("modifier_treasure_green_pill_debuff")
        parent:RemoveModifierByName("modifier_treasure_blue_pill_debuff")
        parent:RemoveModifierByName("modifier_treasure_red_pill_debuff")
        parent:RemoveModifierByName("modifier_treasure_green_pill")
        parent:RemoveModifierByName("modifier_treasure_blue_pill")
        parent:RemoveModifierByName("modifier_treasure_red_pill")
    end
end