---------------------------------------------------------------------------
-- 宝物：恶魔耳钉
---------------------------------------------------------------------------

if modifier_treasure_devil_earing == nil then 
    modifier_treasure_devil_earing = class({})
end

function modifier_treasure_devil_earing:GetTexture()
    if self:GetDuration() < 0 then
        return "buff/modifier_treasure_devil_earing"
    end
    return "buff/modifier_treasure_keep_changing"
end

function modifier_treasure_devil_earing:DeclareFunctions()
	return {
        MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
        MODIFIER_PROPERTY_STATS_AGILITY_BONUS,
        MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,
    }
end

function modifier_treasure_devil_earing:GetModifierBonusStats_Strength()
    return 50
end

function modifier_treasure_devil_earing:GetModifierBonusStats_Agility()
    return 50
end

function modifier_treasure_devil_earing:GetModifierBonusStats_Intellect()
    return 50
end

function modifier_treasure_devil_earing:IsPurgable()
    return false
end

function modifier_treasure_devil_earing:RemoveOnDeath()
    return false
end

function modifier_treasure_devil_earing:OnCreated(kv)
    if IsServer() then
        self:StartIntervalThink(1)
    end
end

function modifier_treasure_devil_earing:OnIntervalThink()
    if global_var_func.current_game_step == DOTA_GAME_STEP_FINALLY_BOSS then
        local parent = self:GetParent()
        parent:AddNewModifier(parent, nil, "modifier_treasure_devil_earing_buff_s", nil):SetStackCount(math.ceil(parent:GetBaseStrength() * 0.5))
        parent:AddNewModifier(parent, nil, "modifier_treasure_devil_earing_buff_a", nil):SetStackCount(math.ceil(parent:GetBaseAgility() * 0.5))
        parent:AddNewModifier(parent, nil, "modifier_treasure_devil_earing_buff_i", nil):SetStackCount(math.ceil(parent:GetBaseIntellect() * 0.5))
        self:StartIntervalThink(-1)
    end
end

function modifier_treasure_devil_earing:OnDestroy()
    if IsServer() then
        local parent = self:GetParent()
        parent:RemoveModifierByName("modifier_treasure_devil_earing_buff_s")
        parent:RemoveModifierByName("modifier_treasure_devil_earing_buff_a")
        parent:RemoveModifierByName("modifier_treasure_devil_earing_buff_i")
    end
end

-------------------------------------------------------------------------------

LinkLuaModifier("modifier_treasure_devil_earing_buff_s", "treasuresystem/treasure_lua/modifier_treasure_devil_earing", LUA_MODIFIER_MOTION_NONE)

if modifier_treasure_devil_earing_buff_s == nil then 
    modifier_treasure_devil_earing_buff_s = class({})
end

function modifier_treasure_devil_earing_buff_s:DeclareFunctions()
	return {
        MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
    }
end

function modifier_treasure_devil_earing_buff_s:GetModifierBonusStats_Strength()
    return self:GetStackCount()
end

function modifier_treasure_devil_earing_buff_s:IsHidden()
    return true
end

function modifier_treasure_devil_earing_buff_s:IsPurgable()
    return false
end

function modifier_treasure_devil_earing_buff_s:RemoveOnDeath()
    return false
end

-------------------------------------------------------------------------------

LinkLuaModifier("modifier_treasure_devil_earing_buff_a","treasuresystem/treasure_lua/modifier_treasure_devil_earing", LUA_MODIFIER_MOTION_NONE)

if modifier_treasure_devil_earing_buff_a == nil then 
    modifier_treasure_devil_earing_buff_a = class({})
end

function modifier_treasure_devil_earing_buff_a:DeclareFunctions()
	return {
        MODIFIER_PROPERTY_STATS_AGILITY_BONUS,
    }
end

function modifier_treasure_devil_earing_buff_a:GetModifierBonusStats_Agility()
    return self:GetStackCount()
end

function modifier_treasure_devil_earing_buff_a:IsHidden()
    return true
end

function modifier_treasure_devil_earing_buff_a:IsPurgable()
    return false
end

function modifier_treasure_devil_earing_buff_a:RemoveOnDeath()
    return false
end

-------------------------------------------------------------------------------

LinkLuaModifier("modifier_treasure_devil_earing_buff_i","treasuresystem/treasure_lua/modifier_treasure_devil_earing", LUA_MODIFIER_MOTION_NONE)

if modifier_treasure_devil_earing_buff_i == nil then 
    modifier_treasure_devil_earing_buff_i = class({})
end

function modifier_treasure_devil_earing_buff_i:DeclareFunctions()
	return {
        MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,
    }
end

function modifier_treasure_devil_earing_buff_i:GetModifierBonusStats_Intellect()
    return self:GetStackCount()
end

function modifier_treasure_devil_earing_buff_i:IsHidden()
    return true
end

function modifier_treasure_devil_earing_buff_i:IsPurgable()
    return false
end

function modifier_treasure_devil_earing_buff_i:RemoveOnDeath()
    return false
end