---------------------------------------------------------------------------
-- 宝物：遗失之物 - 残缺的书籍
---------------------------------------------------------------------------

if modifier_treasure_lost_book == nil then 
    modifier_treasure_lost_book = class({})
end

function modifier_treasure_lost_book:GetTexture()
    if self:GetDuration() < 0 then
        return "buff/modifier_treasure_lost_book"
    end
    return "buff/modifier_treasure_keep_changing"
end

function modifier_treasure_lost_book:CheckState()
	return {}
end

function modifier_treasure_lost_book:DeclareFunctions()
	return {
        MODIFIER_PROPERTY_MANA_BONUS,
        MODIFIER_PROPERTY_SPELL_AMPLIFY_PERCENTAGE,
    }
end

function modifier_treasure_lost_book:GetModifierManaBonus()
    return -50
end

function modifier_treasure_lost_book:GetModifierSpellAmplify_Percentage()
    return 30
end

function modifier_treasure_lost_book:IsPurgable()
    return false
end
 
function modifier_treasure_lost_book:RemoveOnDeath()
    return false
end