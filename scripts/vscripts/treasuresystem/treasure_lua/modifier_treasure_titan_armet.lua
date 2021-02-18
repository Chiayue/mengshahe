---------------------------------------------------------------------------
-- 宝物：泰坦头盔
---------------------------------------------------------------------------

if modifier_treasure_titan_armet == nil then 
    modifier_treasure_titan_armet = class({})
end

function modifier_treasure_titan_armet:GetTexture()
    if self:GetDuration() < 0 then
        return "buff/modifier_treasure_titan_armet"
    end
    return "buff/modifier_treasure_keep_changing"
end

function modifier_treasure_titan_armet:IsPurgable()
    return false
end
 
function modifier_treasure_titan_armet:RemoveOnDeath()
    return false
end

function modifier_treasure_titan_armet:DeclareFunctions()
    return {
        MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
    }
end

function modifier_treasure_titan_armet:GetModifierBonusStats_Strength()
    return 120
end

function modifier_treasure_titan_armet:OnCreated(kv)
    if IsServer() then
        self:StartIntervalThink(1)
    end
end

function modifier_treasure_titan_armet:OnIntervalThink()
    local parent = self:GetParent()
    if parent:HasModifier("modifier_treasure_titan_hammer") and parent:HasModifier("modifier_treasure_titan_shield") then           
        parent:AddNewModifier(parent, nil, "modifier_treasure_titan_power", nil)
    end
    self:StartIntervalThink(-1)
end
-- function modifier_treasure_titan_armet:OnDestroy()
--     if IsServer() then
--         self:GetParent():RemoveModifierByName("modifier_treasure_titan_power")
--     end
-- end