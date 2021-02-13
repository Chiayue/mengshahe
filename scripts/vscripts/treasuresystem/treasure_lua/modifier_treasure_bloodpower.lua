---------------------------------------------------------------------------
-- 鲜血之力
---------------------------------------------------------------------------

if modifier_treasure_bloodpower == nil then 
    modifier_treasure_bloodpower = class({})
end

function modifier_treasure_bloodpower:IsHidden()
    return true
end

function modifier_treasure_bloodpower:IsPurgable()
    return false
end

function modifier_treasure_bloodpower:RemoveOnDeath()
    return false
end

function modifier_treasure_bloodpower:OnCreated(kv)
    if IsServer() then
        local parent = self:GetParent()
        parent:AddNewModifier(parent, nil, "modifier_treasure_bloodpower_s", nil):SetStackCount(math.ceil(parent:GetStrength() * 0.15))
        parent:AddNewModifier(parent, nil, "modifier_treasure_bloodpower_a", nil):SetStackCount(math.ceil(parent:GetAgility() * 0.15))
        parent:AddNewModifier(parent, nil, "modifier_treasure_bloodpower_i", nil):SetStackCount(math.ceil(parent:GetIntellect() * 0.15))
    end
end

function modifier_treasure_bloodpower:OnDestroy()
    if IsServer() then
        local parent = self:GetParent()
        parent:RemoveModifierByName("modifier_treasure_bloodpower_s")
        parent:RemoveModifierByName("modifier_treasure_bloodpower_a")
        parent:RemoveModifierByName("modifier_treasure_bloodpower_i")
    end
end

-------------------------------------------------------------------------------

LinkLuaModifier("modifier_treasure_bloodpower_s", "treasuresystem/treasure_lua/modifier_treasure_bloodpower", LUA_MODIFIER_MOTION_NONE)

if modifier_treasure_bloodpower_s == nil then 
    modifier_treasure_bloodpower_s = class({})
end

function modifier_treasure_bloodpower_s:DeclareFunctions()
	return {
        MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
    }
end

function modifier_treasure_bloodpower_s:GetModifierBonusStats_Strength()
    return self:GetStackCount()
end

function modifier_treasure_bloodpower_s:IsHidden()
    return true
end

function modifier_treasure_bloodpower_s:IsPurgable()
    return false
end

function modifier_treasure_bloodpower_s:RemoveOnDeath()
    return false
end

-------------------------------------------------------------------------------

LinkLuaModifier("modifier_treasure_bloodpower_a","treasuresystem/treasure_lua/modifier_treasure_bloodpower", LUA_MODIFIER_MOTION_NONE)

if modifier_treasure_bloodpower_a == nil then 
    modifier_treasure_bloodpower_a = class({})
end

function modifier_treasure_bloodpower_a:DeclareFunctions()
	return {
        MODIFIER_PROPERTY_STATS_AGILITY_BONUS,
    }
end

function modifier_treasure_bloodpower_a:GetModifierBonusStats_Agility()
    return self:GetStackCount()
end

function modifier_treasure_bloodpower_a:IsHidden()
    return true
end

function modifier_treasure_bloodpower_a:IsPurgable()
    return false
end

function modifier_treasure_bloodpower_a:RemoveOnDeath()
    return false
end

-------------------------------------------------------------------------------

LinkLuaModifier("modifier_treasure_bloodpower_i","treasuresystem/treasure_lua/modifier_treasure_bloodpower", LUA_MODIFIER_MOTION_NONE)

if modifier_treasure_bloodpower_i == nil then 
    modifier_treasure_bloodpower_i = class({})
end

function modifier_treasure_bloodpower_i:DeclareFunctions()
	return {
        MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,
    }
end

function modifier_treasure_bloodpower_i:GetModifierBonusStats_Intellect()
    return self:GetStackCount()
end

function modifier_treasure_bloodpower_i:IsHidden()
    return true
end

function modifier_treasure_bloodpower_i:IsPurgable()
    return false
end

function modifier_treasure_bloodpower_i:RemoveOnDeath()
    return false
end