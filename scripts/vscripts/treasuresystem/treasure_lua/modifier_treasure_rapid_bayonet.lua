---------------------------------------------------------------------------
-- 宝物：疾风之刺
---------------------------------------------------------------------------

if modifier_treasure_rapid_bayonet == nil then 
    modifier_treasure_rapid_bayonet = class({})
end

function modifier_treasure_rapid_bayonet:GetTexture()
    return "buff/modifier_treasure_rapid_bayonet"
end

function modifier_treasure_rapid_bayonet:IsPurgable()
    return false
end
 
function modifier_treasure_rapid_bayonet:RemoveOnDeath()
    return false
end

function modifier_treasure_rapid_bayonet:DeclareFunctions()
    return {
        MODIFIER_PROPERTY_STATS_AGILITY_BONUS,
    }
end

function modifier_treasure_rapid_bayonet:GetModifierBonusStats_Agility()
    return 120
end

function modifier_treasure_rapid_bayonet:OnCreated(kv)
    if IsServer() then
        local parent = self:GetParent()
        if parent:HasModifier("modifier_treasure_rapid_dagger") and parent:HasModifier("modifier_treasure_rapid_sword") then
            parent:AddNewModifier(parent, nil, "modifier_treasure_rapid_tao", nil)
        end
    end
end

function modifier_treasure_rapid_bayonet:OnDestroy()
    if IsServer() then
        self:GetParent():RemoveModifierByName("modifier_treasure_rapid_tao")
    end
end