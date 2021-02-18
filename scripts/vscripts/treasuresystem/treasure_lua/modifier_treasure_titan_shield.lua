---------------------------------------------------------------------------
-- 宝物：泰坦神盾
---------------------------------------------------------------------------

if modifier_treasure_titan_shield == nil then
    modifier_treasure_titan_shield = class({})
end

function modifier_treasure_titan_shield:GetTexture()
    if self:GetDuration() < 0 then
        return "buff/modifier_treasure_titan_shield"
    end
    return "buff/modifier_treasure_keep_changing"
end

function modifier_treasure_titan_shield:IsPurgable()
    return false
end
 
function modifier_treasure_titan_shield:RemoveOnDeath()
    return false
end

function modifier_treasure_titan_shield:DeclareFunctions()
    return {
        MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
    }
end

function modifier_treasure_titan_shield:GetModifierBonusStats_Strength()
    return 200
end

function modifier_treasure_titan_shield:OnCreated(kv)
    if IsServer() then
        self:StartIntervalThink(1)
    end
end

function modifier_treasure_titan_shield:OnIntervalThink()
    local parent = self:GetParent()
    if parent:HasModifier("modifier_treasure_titan_armet") and parent:HasModifier("modifier_treasure_titan_hammer") then           
        parent:AddNewModifier(parent, nil, "modifier_treasure_titan_power", nil)
    end
    self:StartIntervalThink(-1)
end
-- function modifier_treasure_titan_shield:OnDestroy()
--     if IsServer() then
--         self:GetParent():RemoveModifierByName("modifier_treasure_titan_power")
--     end
-- end