---------------------------------------------------------------------------
-- 宝物：泰坦神力
---------------------------------------------------------------------------

if modifier_treasure_titan_power == nil then 
    modifier_treasure_titan_power = class({})
end

function modifier_treasure_titan_power:IsHidden()
    return true
end

function modifier_treasure_titan_power:IsPurgable()
    return false
end
 
function modifier_treasure_titan_power:RemoveOnDeath()
    return false
end

function modifier_treasure_titan_power:DeclareFunctions()
    return {
        MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
    }
end

function modifier_treasure_titan_power:GetModifierBonusStats_Strength()
    return self:GetStackCount()
end

function modifier_treasure_titan_power:OnCreated(kv)
    if IsServer() then
        self:SetStackCount(math.ceil(self:GetParent():GetStrength() * 0.4))
    end
end