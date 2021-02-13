---------------------------------------------------------------------------
-- 宝物：完美石鬼面具
---------------------------------------------------------------------------

if modifier_treasure_stone_ghost_mask_perfect == nil then 
    modifier_treasure_stone_ghost_mask_perfect = class({})
end
function modifier_treasure_stone_ghost_mask_perfect:GetTexture()
    if self:GetDuration() < 0 then
        return "buff/modifier_treasure_stone_ghost_mask_perfect"
    end
    return "buff/modifier_treasure_keep_changing"
end
function modifier_treasure_stone_ghost_mask_perfect:DeclareFunctions()
	return {
        MODIFIER_EVENT_ON_DEATH,
        MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
        MODIFIER_PROPERTY_STATS_AGILITY_BONUS,
        MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,
    }
end

function modifier_treasure_stone_ghost_mask_perfect:OnDeath(params)
    local parent = self:GetParent()
    if params.unit == parent and parent:FindModifierByName("modifier_treasure_cast_redstone") and parent:FindModifierByName("modifier_treasure_stone_ghost_mask") then
        self:SetStackCount(self:GetStackCount() + 300)
    end
end

function modifier_treasure_stone_ghost_mask_perfect:GetModifierBonusStats_Strength(params)
    local parent = self:GetParent()
    if parent:FindModifierByName("modifier_treasure_cast_redstone") and parent:FindModifierByName("modifier_treasure_stone_ghost_mask") then
        return self:GetStackCount()
    end
    return 0
end

function modifier_treasure_stone_ghost_mask_perfect:GetModifierBonusStats_Agility(params)
    local parent = self:GetParent()
    if parent:FindModifierByName("modifier_treasure_cast_redstone") and parent:FindModifierByName("modifier_treasure_stone_ghost_mask") then
        return self:GetStackCount()
    end
    return 0
end

function modifier_treasure_stone_ghost_mask_perfect:GetModifierBonusStats_Intellect(params)
    local parent = self:GetParent()
    if parent:FindModifierByName("modifier_treasure_cast_redstone") and parent:FindModifierByName("modifier_treasure_stone_ghost_mask") then
        return self:GetStackCount()
    end
    return 0
end

function modifier_treasure_stone_ghost_mask_perfect:IsPurgable()
    return false
end

function modifier_treasure_stone_ghost_mask_perfect:RemoveOnDeath()
    return false
end

function modifier_treasure_stone_ghost_mask_perfect:OnCreated(table)
    self:SetStackCount(0)
end