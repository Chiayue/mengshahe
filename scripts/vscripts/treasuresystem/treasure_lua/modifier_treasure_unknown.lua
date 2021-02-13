---------------------------------------------------------------------------
-- 宝物：未知宝物
---------------------------------------------------------------------------

if modifier_treasure_unknown == nil then 
    modifier_treasure_unknown = class({})
end

function modifier_treasure_unknown:GetTexture()
    return "buff/modifier_treasure_touzi"
end

function modifier_treasure_unknown:IsHidden()
    return true
end

function modifier_treasure_unknown:IsPurgable()
    return false
end

function modifier_treasure_unknown:RemoveOnDeath()
    return false
end

function modifier_treasure_unknown:OnCreated(table)
    
end