---------------------------------------------------------------------------
-- 宝物：艾泽红石
---------------------------------------------------------------------------

if modifier_treasure_cast_redstone == nil then 
    modifier_treasure_cast_redstone = class({})
end

function modifier_treasure_cast_redstone:GetTexture()
    if self:GetDuration() < 0 then
        return "buff/modifier_treasure_cast_redstone"
    end
    return "buff/modifier_treasure_keep_changing"
end

function modifier_treasure_cast_redstone:DeclareFunctions()
	return {
        MODIFIER_PROPERTY_TOTALDAMAGEOUTGOING_PERCENTAGE,
        MODIFIER_PROPERTY_HEAL_AMPLIFY_PERCENTAGE_SOURCE,
    }
end

function modifier_treasure_cast_redstone:GetModifierTotalDamageOutgoing_Percentage(params)
    return 30
end
 
function modifier_treasure_cast_redstone:GetModifierHealAmplify_PercentageSource(params)
    return 30
end

function modifier_treasure_cast_redstone:IsPurgable()
    return false
end
 
function modifier_treasure_cast_redstone:RemoveOnDeath()
    return false
end 