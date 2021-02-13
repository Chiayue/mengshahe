---------------------------------------------------------------------------
-- 宝物：泰坦战锤
---------------------------------------------------------------------------

if modifier_treasure_titan_hammer == nil then
    modifier_treasure_titan_hammer = class({})
end

function modifier_treasure_titan_hammer:GetTexture()
    return "buff/modifier_treasure_titan_hammer"
end

function modifier_treasure_titan_hammer:IsPurgable()
    return false
end
 
function modifier_treasure_titan_hammer:RemoveOnDeath()
    return false
end

function modifier_treasure_titan_hammer:DeclareFunctions()
    return {
        MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
    }
end

function modifier_treasure_titan_hammer:GetModifierBonusStats_Strength()
    return 140
end

function modifier_treasure_titan_hammer:OnCreated(kv)
    if IsServer() then
        local parent = self:GetParent()
        if parent:HasModifier("modifier_treasure_titan_armet") and parent:HasModifier("modifier_treasure_titan_shield") then
            parent:AddNewModifier(parent, nil, "modifier_treasure_titan_power", nil)
        end
    end
end

function modifier_treasure_titan_hammer:OnDestroy()
    if IsServer() then
        self:GetParent():RemoveModifierByName("modifier_treasure_titan_power")
    end
end