---------------------------------------------------------------------------
-- 宝物：启示录【中】
---------------------------------------------------------------------------

if modifier_treasure_apocalypse_b == nil then 
    modifier_treasure_apocalypse_b = class({})
end

function modifier_treasure_apocalypse_b:DeclareFunctions()
	return {
        MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
        MODIFIER_PROPERTY_STATS_AGILITY_BONUS,
        MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,
    }
end

function modifier_treasure_apocalypse_b:GetModifierBonusStats_Strength()
    return 100
end
 
function modifier_treasure_apocalypse_b:GetModifierBonusStats_Agility()
    return 100
end

function modifier_treasure_apocalypse_b:GetModifierBonusStats_Intellect()
    return 100
end

function modifier_treasure_apocalypse_b:GetTexture()
    return "buff/modifier_treasure_apocalypse_b"
end

function modifier_treasure_apocalypse_b:IsHidden()
    return false
end

function modifier_treasure_apocalypse_b:IsPurgable()
    return false
end
 
function modifier_treasure_apocalypse_b:RemoveOnDeath()
    return false
end

function modifier_treasure_apocalypse_b:OnCreated(kv)
    if IsServer() then
        self:StartIntervalThink(1)
    end
end

function modifier_treasure_apocalypse_b:OnIntervalThink()
    local parent = self:GetParent()
    if parent:HasModifier("modifier_treasure_apocalypse_a") and parent:HasModifier("modifier_treasure_apocalypse_c") then
        parent:AddNewModifier(parent, nil, "modifier_treasure_apocalypse", nil)
    end
    self:StartIntervalThink(-1)
end