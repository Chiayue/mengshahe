---------------------------------------------------------------------------
-- 宝物：疾风之道
---------------------------------------------------------------------------

if modifier_treasure_rapid_tao == nil then 
    modifier_treasure_rapid_tao = class({})
end

function modifier_treasure_rapid_tao:IsHidden()
    return true
end

function modifier_treasure_rapid_tao:IsPurgable()
    return false
end
 
function modifier_treasure_rapid_tao:RemoveOnDeath()
    return false
end

function modifier_treasure_rapid_tao:DeclareFunctions()
    return {
        MODIFIER_PROPERTY_STATS_AGILITY_BONUS,
    }
end

function modifier_treasure_rapid_tao:GetModifierBonusStats_Agility()
    return self:GetStackCount()
end

function modifier_treasure_rapid_tao:OnCreated(kv)
    if IsServer() then
        self:SetStackCount(math.ceil(self:GetParent():GetAgility() * 0.4))
    end
end