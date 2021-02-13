---------------------------------------------------------------------------
-- 宝物：深渊法典
---------------------------------------------------------------------------

if modifier_treasure_abyss_law == nil then 
    modifier_treasure_abyss_law = class({})
end

function modifier_treasure_abyss_law:GetTexture()
    return "buff/modifier_treasure_abyss_law"
end

function modifier_treasure_abyss_law:IsPurgable()
    return false
end

function modifier_treasure_abyss_law:RemoveOnDeath()
    return false
end

function modifier_treasure_abyss_law:DeclareFunctions()
    return {
        MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,
    }
end

function modifier_treasure_abyss_law:GetModifierBonusStats_Intellect()
    return 200
end

function modifier_treasure_abyss_law:OnCreated(kv)
    if IsServer() then
        local parent = self:GetParent()
        if parent:HasModifier("modifier_treasure_abyss_orb") and parent:HasModifier("modifier_treasure_abyss_sceptre") then
            parent:AddNewModifier(parent, nil, "modifier_treasure_abyss_source", nil)
        end
    end
end

function modifier_treasure_abyss_law:OnDestroy()
    if IsServer() then
        self:GetParent():RemoveModifierByName("modifier_treasure_abyss_source")
    end
end