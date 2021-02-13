---------------------------------------------------------------------------
-- 宝物：疾风之匕
---------------------------------------------------------------------------

if modifier_treasure_rapid_dagger == nil then 
    modifier_treasure_rapid_dagger = class({})
end

function modifier_treasure_rapid_dagger:GetTexture()
    return "buff/modifier_treasure_rapid_dagger"
end

function modifier_treasure_rapid_dagger:IsPurgable()
    return false
end
 
function modifier_treasure_rapid_dagger:RemoveOnDeath()
    return false
end

function modifier_treasure_rapid_dagger:DeclareFunctions()
    return {
        MODIFIER_PROPERTY_STATS_AGILITY_BONUS,
    }
end

function modifier_treasure_rapid_dagger:GetModifierBonusStats_Agility()
    return 160
end

function modifier_treasure_rapid_dagger:OnCreated(kv)
    if IsServer() then
        local parent = self:GetParent()
        if parent:HasModifier("modifier_treasure_rapid_bayonet") and parent:HasModifier("modifier_treasure_rapid_sword") then
            parent:AddNewModifier(parent, nil, "modifier_treasure_rapid_tao", nil)
        end
    end
end

function modifier_treasure_rapid_dagger:OnDestroy()
    if IsServer() then
        self:GetParent():RemoveModifierByName("modifier_treasure_rapid_tao")
    end
end