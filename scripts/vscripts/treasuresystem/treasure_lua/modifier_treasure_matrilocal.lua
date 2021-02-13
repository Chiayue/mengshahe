---------------------------------------------------------------------------
-- 宝物：赘婿
---------------------------------------------------------------------------

if modifier_treasure_matrilocal == nil then 
    modifier_treasure_matrilocal = class({})
end

function modifier_treasure_matrilocal:GetTexture()
    return "buff/modifier_treasure_matrilocal"
end

function modifier_treasure_matrilocal:IsPurgable()
    return false
end
 
function modifier_treasure_matrilocal:RemoveOnDeath()
    return false
end

function modifier_treasure_matrilocal:OnCreated(kv)
    if IsServer() then
        local parent = self:GetParent()
        if parent:HasModifier("modifier_treasure_tolerance") then
            parent:RemoveModifierByName("modifier_treasure_matrilocal_debuff")
            parent:RemoveModifierByName("modifier_treasure_tolerance_debuff")
            parent:AddNewModifier(parent, nil, "modifier_treasure_three_years_later", nil)
        else
            parent:AddNewModifier(parent, nil, "modifier_treasure_matrilocal_debuff", nil)
        end
    end
end

function modifier_treasure_matrilocal:OnDestroy()
    if IsServer() then
        local parent = self:GetParent()
        parent:RemoveModifierByName("modifier_treasure_matrilocal_debuff")
        parent:RemoveModifierByName("modifier_treasure_three_years_later")
        parent:AddNewModifier(parent, nil, "modifier_treasure_tolerance_debuff", nil)
    end
end

----------------------------------------------------------------------------------------------------------------------

LinkLuaModifier("modifier_treasure_matrilocal_debuff","treasuresystem/treasure_lua/modifier_treasure_matrilocal", LUA_MODIFIER_MOTION_NONE)

if modifier_treasure_matrilocal_debuff == nil then 
    modifier_treasure_matrilocal_debuff = class({})
end

function modifier_treasure_matrilocal_debuff:IsHidden()
    return true
end

function modifier_treasure_matrilocal_debuff:IsPurgable()
    return false
end
 
function modifier_treasure_matrilocal_debuff:RemoveOnDeath()
    return false
end

function modifier_treasure_matrilocal_debuff:DeclareFunctions()
    return {
        MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
        MODIFIER_PROPERTY_STATS_AGILITY_BONUS,
        MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,
    }
end

function modifier_treasure_matrilocal_debuff:GetModifierBonusStats_Strength()
    return -100
end

function modifier_treasure_matrilocal_debuff:GetModifierBonusStats_Agility()
    return -100
end

function modifier_treasure_matrilocal_debuff:GetModifierBonusStats_Intellect()
    return -100
end