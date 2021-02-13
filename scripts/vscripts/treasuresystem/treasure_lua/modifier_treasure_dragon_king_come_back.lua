---------------------------------------------------------------------------
-- 宝物：龙王归来
---------------------------------------------------------------------------

if modifier_treasure_dragon_king_come_back == nil then 
    modifier_treasure_dragon_king_come_back = class({})
end

function modifier_treasure_dragon_king_come_back:GetTexture()
    if self:GetDuration() < 0 then
        return "buff/modifier_treasure_dragon_king_come_back"
    end
    return "buff/modifier_treasure_keep_changing"
end

function modifier_treasure_dragon_king_come_back:IsPurgable()
    return false
end
 
function modifier_treasure_dragon_king_come_back:RemoveOnDeath()
    return false
end

function modifier_treasure_dragon_king_come_back:OnCreated(params)
    if IsServer() then
        local parent = self:GetParent()
        parent:AddNewModifier(parent, nil, "modifier_treasure_dragon_king_come_back_buff_s", nil):SetStackCount(-50)
        parent:AddNewModifier(parent, nil, "modifier_treasure_dragon_king_come_back_buff_a", nil):SetStackCount(-50)
        parent:AddNewModifier(parent, nil, "modifier_treasure_dragon_king_come_back_buff_i", nil):SetStackCount(-50)
        parent:CalculateStatBonus(true)
        self:SetStackCount(900)
        self:StartIntervalThink(1)
    end
end

function modifier_treasure_dragon_king_come_back:OnIntervalThink()
    self:DecrementStackCount()
    if self:GetStackCount() <= 0 then
        local parent = self:GetParent()
        parent:FindModifierByName("modifier_treasure_dragon_king_come_back_buff_s"):SetStackCount(math.ceil(parent:GetStrength() * 0.5))
        parent:FindModifierByName("modifier_treasure_dragon_king_come_back_buff_a"):SetStackCount(math.ceil(parent:GetAgility() * 0.5))
        parent:FindModifierByName("modifier_treasure_dragon_king_come_back_buff_i"):SetStackCount(math.ceil(parent:GetIntellect() * 0.5))
        parent:CalculateStatBonus(true)
        self:StartIntervalThink(-1)
    end
end

function modifier_treasure_dragon_king_come_back:OnDestroy()
    if IsServer() then
        local parent = self:GetParent()
        parent:RemoveModifierByName("modifier_treasure_dragon_king_come_back_buff_s")
        parent:RemoveModifierByName("modifier_treasure_dragon_king_come_back_buff_a")
        parent:RemoveModifierByName("modifier_treasure_dragon_king_come_back_buff_i")
    end
end

------------------------------------------------------------------------------------------------

LinkLuaModifier("modifier_treasure_dragon_king_come_back_buff_s","treasuresystem/treasure_lua/modifier_treasure_dragon_king_come_back", LUA_MODIFIER_MOTION_NONE)

if modifier_treasure_dragon_king_come_back_buff_s == nil then 
    modifier_treasure_dragon_king_come_back_buff_s = class({})
end

function modifier_treasure_dragon_king_come_back_buff_s:DeclareFunctions()
	return {
        MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
    }
end

function modifier_treasure_dragon_king_come_back_buff_s:GetModifierBonusStats_Strength()
    return self:GetStackCount()
end

function modifier_treasure_dragon_king_come_back_buff_s:IsHidden()
    return true
end

function modifier_treasure_dragon_king_come_back_buff_s:IsPurgable()
    return false
end
 
function modifier_treasure_dragon_king_come_back_buff_s:RemoveOnDeath()
    return false
end

------------------------------------------------------------------------------------------------

LinkLuaModifier("modifier_treasure_dragon_king_come_back_buff_a","treasuresystem/treasure_lua/modifier_treasure_dragon_king_come_back", LUA_MODIFIER_MOTION_NONE)

if modifier_treasure_dragon_king_come_back_buff_a == nil then 
    modifier_treasure_dragon_king_come_back_buff_a = class({})
end

function modifier_treasure_dragon_king_come_back_buff_a:DeclareFunctions()
	return {
        MODIFIER_PROPERTY_STATS_AGILITY_BONUS,
    }
end

function modifier_treasure_dragon_king_come_back_buff_a:GetModifierBonusStats_Agility()
    return self:GetStackCount()
end

function modifier_treasure_dragon_king_come_back_buff_a:IsHidden()
    return true
end

function modifier_treasure_dragon_king_come_back_buff_a:IsPurgable()
    return false
end
 
function modifier_treasure_dragon_king_come_back_buff_a:RemoveOnDeath()
    return false
end

------------------------------------------------------------------------------------------------

LinkLuaModifier("modifier_treasure_dragon_king_come_back_buff_i","treasuresystem/treasure_lua/modifier_treasure_dragon_king_come_back", LUA_MODIFIER_MOTION_NONE)

if modifier_treasure_dragon_king_come_back_buff_i == nil then 
    modifier_treasure_dragon_king_come_back_buff_i = class({})
end

function modifier_treasure_dragon_king_come_back_buff_i:DeclareFunctions()
	return {
        MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,
    }
end

function modifier_treasure_dragon_king_come_back_buff_i:GetModifierBonusStats_Intellect()
    return self:GetStackCount()
end

function modifier_treasure_dragon_king_come_back_buff_i:IsHidden()
    return true
end

function modifier_treasure_dragon_king_come_back_buff_i:IsPurgable()
    return false
end
 
function modifier_treasure_dragon_king_come_back_buff_i:RemoveOnDeath()
    return false
end