---------------------------------------------------------------------------
-- 宝物：深渊宝珠
---------------------------------------------------------------------------

if modifier_treasure_abyss_orb == nil then 
    modifier_treasure_abyss_orb = class({})
end

function modifier_treasure_abyss_orb:GetTexture()
    return "buff/modifier_treasure_abyss_orb"
end

function modifier_treasure_abyss_orb:IsPurgable()
    return false
end
 
function modifier_treasure_abyss_orb:RemoveOnDeath()
    return false
end

function modifier_treasure_abyss_orb:DeclareFunctions()
    return {
        MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,
    }
end

function modifier_treasure_abyss_orb:GetModifierBonusStats_Intellect()
    return 120
end

function modifier_treasure_abyss_orb:OnCreated(kv)
    if IsServer() then
        local parent = self:GetParent()
        if parent:HasModifier("modifier_treasure_abyss_sceptre") and parent:HasModifier("modifier_treasure_abyss_law") then
            parent:AddNewModifier(parent, nil, "modifier_treasure_abyss_source", nil)
        end
    end
end

function modifier_treasure_abyss_orb:OnDestroy()
    if IsServer() then
        self:GetParent():RemoveModifierByName("modifier_treasure_abyss_source")
    end
end