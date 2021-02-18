---------------------------------------------------------------------------
-- 宝物：隐忍
---------------------------------------------------------------------------

if modifier_treasure_tolerance == nil then 
    modifier_treasure_tolerance = class({})
end

function modifier_treasure_tolerance:GetTexture()
    if self:GetDuration() < 0 then
        return "buff/modifier_treasure_tolerance"
    end
    return "buff/modifier_treasure_keep_changing"
end

function modifier_treasure_tolerance:IsPurgable()
    return false
end
 
function modifier_treasure_tolerance:RemoveOnDeath()
    return false
end

function modifier_treasure_tolerance:OnCreated(kv)
    if IsServer() then
        self:StartIntervalThink(1)
    end
end

function modifier_treasure_tolerance:OnIntervalThink()
    local parent = self:GetParent()
    if parent:HasModifier("modifier_treasure_matrilocal") then
        parent:AddNewModifier(parent, nil, "modifier_treasure_three_years_later", nil)
    else
        parent:AddNewModifier(parent, nil, "modifier_treasure_tolerance_debuff", nil)
    end
    self:StartIntervalThink(-1)
end

-- function modifier_treasure_tolerance:OnDestroy()
--     if IsServer() then
--         local parent = self:GetParent()
--         parent:RemoveModifierByName("modifier_treasure_tolerance_debuff")
--         parent:RemoveModifierByName("modifier_treasure_three_years_later")
--         parent:AddNewModifier(parent, nil, "modifier_treasure_matrilocal_debuff", nil)
--     end
-- end

----------------------------------------------------------------------------------------------------------------------

LinkLuaModifier("modifier_treasure_tolerance_debuff","treasuresystem/treasure_lua/modifier_treasure_tolerance", LUA_MODIFIER_MOTION_NONE)

if modifier_treasure_tolerance_debuff == nil then 
    modifier_treasure_tolerance_debuff = class({})
end

function modifier_treasure_tolerance_debuff:IsHidden()
    return true
end

function modifier_treasure_tolerance_debuff:IsPurgable()
    return false
end
 
function modifier_treasure_tolerance_debuff:RemoveOnDeath()
    return false
end

function modifier_treasure_tolerance_debuff:DeclareFunctions()
    return {
        MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
        MODIFIER_PROPERTY_STATS_AGILITY_BONUS,
        MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,
    }
end

function modifier_treasure_tolerance_debuff:GetModifierBonusStats_Strength()
    return -100
end

function modifier_treasure_tolerance_debuff:GetModifierBonusStats_Agility()
    return -100
end

function modifier_treasure_tolerance_debuff:GetModifierBonusStats_Intellect()
    return -100
end