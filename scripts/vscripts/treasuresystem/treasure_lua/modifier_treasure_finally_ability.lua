---------------------------------------------------------------------------
-- 宝物： 最后的技能
---------------------------------------------------------------------------

if modifier_treasure_finally_ability == nil then 
    modifier_treasure_finally_ability = class({})
end

function modifier_treasure_finally_ability:GetTexture()
    if self:GetDuration() < 0 then
        return "buff/modifier_treasure_finally_ability"
    end
    return "buff/modifier_treasure_keep_changing"
end

function modifier_treasure_finally_ability:CheckState()
	return {}
end

function modifier_treasure_finally_ability:DeclareFunctions()
	return {
        MODIFIER_PROPERTY_SPELL_AMPLIFY_PERCENTAGE,
    }
end

function modifier_treasure_finally_ability:GetModifierSpellAmplify_Percentage()
    local parent = self:GetParent()
    if parent:GetMana() < parent:GetMaxMana() * 0.5 then
        return 50
    else
        return 0
    end
end

function modifier_treasure_finally_ability:IsPurgable()
    return false
end
 
function modifier_treasure_finally_ability:RemoveOnDeath()
    return false
end