---------------------------------------------------------------------------
-- 宝物：三相之力
---------------------------------------------------------------------------

if modifier_treasure_three_phase_power == nil then 
    modifier_treasure_three_phase_power = class({})
end

function modifier_treasure_three_phase_power:DeclareFunctions()
	return {
        MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
        MODIFIER_PROPERTY_STATS_AGILITY_BONUS,
        MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,
    }
end

function modifier_treasure_three_phase_power:GetModifierBonusStats_Strength()
    local parent = self:GetParent()
    local max = 0
    local strength = parent:GetBaseStrength()
    if max < strength then
        max = strength
    end
    local agility = parent:GetBaseAgility()
    if max < agility then
        max = agility
    end
    local intellect = parent:GetBaseIntellect()
    if max < intellect then
        max = intellect
    end
    if  max - strength > 0 then
        return max - strength + 150
    else
        return 150
    end
end
 
function modifier_treasure_three_phase_power:GetModifierBonusStats_Agility()
    local parent = self:GetParent()
    local max = 0
    local strength = parent:GetBaseStrength()
    if max < strength then
        max = strength
    end
    local agility = parent:GetBaseAgility()
    if max < agility then
        max = agility
    end
    local intellect = parent:GetBaseIntellect()
    if max < intellect then
        max = intellect
    end
    if  max - agility > 0 then
        return max - agility + 150
    else
        return 150
    end
end
 
function modifier_treasure_three_phase_power:GetModifierBonusStats_Intellect()
    local parent = self:GetParent()
    local max = 0
    local strength = parent:GetBaseStrength()
    if max < strength then
        max = strength
    end
    local agility = parent:GetBaseAgility()
    if max < agility then
        max = agility
    end
    local intellect = parent:GetBaseIntellect()
    if max < intellect then
        max = intellect
    end
    if  max - intellect > 0 then
        return max - intellect + 150
    else
        return 150
    end
end

function modifier_treasure_three_phase_power:GetTexture()
    if self:GetDuration() < 0 then
        return "buff/modifier_treasure_three_phase_power"
    end
    return "buff/modifier_treasure_keep_changing"
end
 
function modifier_treasure_three_phase_power:IsHidden()
    return false
end

function modifier_treasure_three_phase_power:IsPurgable()
    return false
end
 
function modifier_treasure_three_phase_power:RemoveOnDeath()
    return false
end

function modifier_treasure_three_phase_power:OnCreated()
    if IsServer() then
        local parent = self:GetParent()
        parent:RemoveModifierByName("modifier_treasure_three_phase_power_i")
        parent:RemoveModifierByName("modifier_treasure_three_phase_power_a")
        parent:RemoveModifierByName("modifier_treasure_three_phase_power_s")
    end
end