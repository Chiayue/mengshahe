---------------------------------------------------------------------------
-- 听说名字取得长的宝物都很厉害
---------------------------------------------------------------------------

if modifier_treasure_so_long == nil then 
    modifier_treasure_so_long = class({})
end

function modifier_treasure_so_long:GetTexture()
    return "buff/modifier_treasure_so_long"
end

function modifier_treasure_so_long:DeclareFunctions()
    return {
        MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
        MODIFIER_PROPERTY_STATS_AGILITY_BONUS,
        MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,
    }
end

function modifier_treasure_so_long:GetModifierBonusStats_Strength()
    return 1
end

function modifier_treasure_so_long:GetModifierBonusStats_Agility()
    return 1
end

function modifier_treasure_so_long:GetModifierBonusStats_Intellect()
    return 1
end

function modifier_treasure_so_long:IsPurgable()
    return false
end
 
function modifier_treasure_so_long:RemoveOnDeath()
    return false
end

function modifier_treasure_so_long:OnCreated(kv)
    if IsServer() then
        local parent = self:GetParent()
        if parent:HasModifier("modifier_treasure_so_short") then
            parent:AddNewModifier(parent, nil, "modifier_treasure_so_buff", nil)
        end
    end
end

function modifier_treasure_so_long:OnDestroy()
    if IsServer() then
        self:GetParent():RemoveModifierByName("modifier_treasure_so_buff")
    end
end