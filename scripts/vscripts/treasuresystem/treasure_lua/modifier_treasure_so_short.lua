---------------------------------------------------------------------------
-- 短
---------------------------------------------------------------------------

if modifier_treasure_so_short == nil then 
    modifier_treasure_so_short = class({})
end

function modifier_treasure_so_short:GetTexture()
    return "buff/modifier_treasure_so_short"
end

function modifier_treasure_so_short:DeclareFunctions()
    return {
        MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
        MODIFIER_PROPERTY_STATS_AGILITY_BONUS,
        MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,
    }
end

function modifier_treasure_so_short:GetModifierBonusStats_Strength()
    return 1
end

function modifier_treasure_so_short:GetModifierBonusStats_Agility()
    return 1
end

function modifier_treasure_so_short:GetModifierBonusStats_Intellect()
    return 1
end

function modifier_treasure_so_short:IsPurgable()
    return false
end
 
function modifier_treasure_so_short:RemoveOnDeath()
    return false
end

function modifier_treasure_so_short:OnCreated(kv)
    if IsServer() then
        local parent = self:GetParent()
        if parent:HasModifier("modifier_treasure_so_long") then
            parent:AddNewModifier(parent, nil, "modifier_treasure_so_buff", nil)
        end
    end
end

function modifier_treasure_so_short:OnDestroy()
    if IsServer() then
        self:GetParent():RemoveModifierByName("modifier_treasure_so_buff")
    end
end