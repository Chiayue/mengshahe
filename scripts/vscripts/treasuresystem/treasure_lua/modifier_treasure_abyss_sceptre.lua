---------------------------------------------------------------------------
-- 宝物：深渊权杖
---------------------------------------------------------------------------

if modifier_treasure_abyss_sceptre == nil then 
    modifier_treasure_abyss_sceptre = class({})
end

function modifier_treasure_abyss_sceptre:GetTexture()
    return "buff/modifier_treasure_abyss_sceptre"
end

function modifier_treasure_abyss_sceptre:IsPurgable()
    return false
end

function modifier_treasure_abyss_sceptre:RemoveOnDeath()
    return false
end

function modifier_treasure_abyss_sceptre:DeclareFunctions()
    return {
        MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,
    }
end

function modifier_treasure_abyss_sceptre:GetModifierBonusStats_Intellect()
    return 140
end

function modifier_treasure_abyss_sceptre:OnCreated(kv)
    if IsServer() then
        self:StartIntervalThink(1)
    end
end

function modifier_treasure_abyss_sceptre:OnIntervalThink()
    local parent = self:GetParent()
    if parent:HasModifier("modifier_treasure_abyss_orb") and parent:HasModifier("modifier_treasure_abyss_law") then
        parent:AddNewModifier(parent, nil, "modifier_treasure_abyss_source", nil)
    end
    self:StartIntervalThink(-1)
end