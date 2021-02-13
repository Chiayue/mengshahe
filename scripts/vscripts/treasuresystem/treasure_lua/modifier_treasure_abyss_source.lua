---------------------------------------------------------------------------
-- 宝物：来自深渊
---------------------------------------------------------------------------

if modifier_treasure_abyss_source == nil then 
    modifier_treasure_abyss_source = class({})
end

function modifier_treasure_abyss_source:IsHidden()
    return true
end

function modifier_treasure_abyss_source:IsPurgable()
    return false
end
 
function modifier_treasure_abyss_source:RemoveOnDeath()
    return false
end

function modifier_treasure_abyss_source:DeclareFunctions()
    return {
        MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,
    }
end

function modifier_treasure_abyss_source:GetModifierBonusStats_Intellect()
    return self:GetStackCount()
end

function modifier_treasure_abyss_source:OnCreated(kv)
    if IsServer() then
        self:SetStackCount(math.ceil(self:GetParent():GetIntellect() * 0.4))
    end
end