---------------------------------------------------------------------------
-- 凑齐听说名字取得很长的宝物都很厉害，短，增加英雄【30%】全属性（不显示给玩家）
---------------------------------------------------------------------------

if modifier_treasure_so_buff == nil then 
    modifier_treasure_so_buff = class({})
end

function modifier_treasure_so_buff:IsHidden()
    return true
end

function modifier_treasure_so_buff:IsPurgable()
    return false
end

function modifier_treasure_so_buff:RemoveOnDeath()
    return false
end

function modifier_treasure_so_buff:OnCreated(kv)
    if IsServer() then
        local parent = self:GetParent()
        parent:AddNewModifier(parent, nil, "modifier_treasure_so_buff_s", nil):SetStackCount(math.ceil(parent:GetStrength() * 0.3))
        parent:AddNewModifier(parent, nil, "modifier_treasure_so_buff_a", nil):SetStackCount(math.ceil(parent:GetAgility() * 0.3))
        parent:AddNewModifier(parent, nil, "modifier_treasure_so_buff_i", nil):SetStackCount(math.ceil(parent:GetIntellect() * 0.3))
    end
end

function modifier_treasure_so_buff:OnDestroy()
    if IsServer() then
        local parent = self:GetParent()
        parent:RemoveModifierByName("modifier_treasure_so_buff_s")
        parent:RemoveModifierByName("modifier_treasure_so_buff_a")
        parent:RemoveModifierByName("modifier_treasure_so_buff_i")
    end
end

-------------------------------------------------------------------------------

LinkLuaModifier("modifier_treasure_so_buff_s", "treasuresystem/treasure_lua/modifier_treasure_so_buff", LUA_MODIFIER_MOTION_NONE)

if modifier_treasure_so_buff_s == nil then 
    modifier_treasure_so_buff_s = class({})
end

function modifier_treasure_so_buff_s:DeclareFunctions()
	return {
        MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
    }
end

function modifier_treasure_so_buff_s:GetModifierBonusStats_Strength()
    return self:GetStackCount()
end

function modifier_treasure_so_buff_s:IsHidden()
    return true
end

function modifier_treasure_so_buff_s:IsPurgable()
    return false
end

function modifier_treasure_so_buff_s:RemoveOnDeath()
    return false
end

-------------------------------------------------------------------------------

LinkLuaModifier("modifier_treasure_so_buff_a","treasuresystem/treasure_lua/modifier_treasure_so_buff", LUA_MODIFIER_MOTION_NONE)

if modifier_treasure_so_buff_a == nil then 
    modifier_treasure_so_buff_a = class({})
end

function modifier_treasure_so_buff_a:DeclareFunctions()
	return {
        MODIFIER_PROPERTY_STATS_AGILITY_BONUS,
    }
end

function modifier_treasure_so_buff_a:GetModifierBonusStats_Agility()
    return self:GetStackCount()
end

function modifier_treasure_so_buff_a:IsHidden()
    return true
end

function modifier_treasure_so_buff_a:IsPurgable()
    return false
end

function modifier_treasure_so_buff_a:RemoveOnDeath()
    return false
end

-------------------------------------------------------------------------------

LinkLuaModifier("modifier_treasure_so_buff_i","treasuresystem/treasure_lua/modifier_treasure_so_buff", LUA_MODIFIER_MOTION_NONE)

if modifier_treasure_so_buff_i == nil then 
    modifier_treasure_so_buff_i = class({})
end

function modifier_treasure_so_buff_i:DeclareFunctions()
	return {
        MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,
    }
end

function modifier_treasure_so_buff_i:GetModifierBonusStats_Intellect()
    return self:GetStackCount()
end

function modifier_treasure_so_buff_i:IsHidden()
    return true
end

function modifier_treasure_so_buff_i:IsPurgable()
    return false
end

function modifier_treasure_so_buff_i:RemoveOnDeath()
    return false
end