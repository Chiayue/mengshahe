---------------------------------------------------------------------------
-- 宝物：石鬼面具
---------------------------------------------------------------------------

if modifier_treasure_stone_ghost_mask == nil then 
    modifier_treasure_stone_ghost_mask = class({})
end

function modifier_treasure_stone_ghost_mask:GetTexture()
    if self:GetDuration() < 0 then
        return "buff/modifier_treasure_stone_ghost_mask"
    end
    return "buff/modifier_treasure_keep_changing"
end

function modifier_treasure_stone_ghost_mask:IsPurgable()
    return false
end

function modifier_treasure_stone_ghost_mask:RemoveOnDeath()
    return false
end

function modifier_treasure_stone_ghost_mask:OnCreated(kv)
    if IsServer() then
        self:StartIntervalThink(1)
    end
end

function modifier_treasure_stone_ghost_mask:OnIntervalThink()
    local parent = self:GetParent()
    if IsNight() then
        if not parent:HasModifier("modifier_treasure_stone_ghost_mask_buff") then
            parent:AddNewModifier(parent, nil, "modifier_treasure_stone_ghost_mask_buff", nil)
        end
    else
        if parent:HasModifier("modifier_treasure_stone_ghost_mask_buff") then
            parent:RemoveModifierByName("modifier_treasure_stone_ghost_mask_buff")
        end
    end
end

function modifier_treasure_stone_ghost_mask:OnDestroy()
    if IsServer() then
        self:GetParent():RemoveModifierByName("modifier_treasure_stone_ghost_mask_buff")
    end
end

-------------------------------------------------------------------------

LinkLuaModifier("modifier_treasure_stone_ghost_mask_buff","treasuresystem/treasure_lua/modifier_treasure_stone_ghost_mask", LUA_MODIFIER_MOTION_NONE)

if modifier_treasure_stone_ghost_mask_buff == nil then 
    modifier_treasure_stone_ghost_mask_buff = class({})
end

function modifier_treasure_stone_ghost_mask_buff:DeclareFunctions()
	return {
        MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
        MODIFIER_PROPERTY_STATS_AGILITY_BONUS,
        MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,
        MODIFIER_PROPERTY_HEAL_AMPLIFY_PERCENTAGE_TARGET,
        MODIFIER_PROPERTY_HP_REGEN_AMPLIFY_PERCENTAGE,
    }
end

function modifier_treasure_stone_ghost_mask_buff:GetModifierBonusStats_Strength()
    return 200
end

function modifier_treasure_stone_ghost_mask_buff:GetModifierBonusStats_Agility()
    return 200
end

function modifier_treasure_stone_ghost_mask_buff:GetModifierBonusStats_Intellect()
    return 200
end

function modifier_treasure_stone_ghost_mask_buff:GetModifierHealAmplify_PercentageTarget()
    return 50
end

function modifier_treasure_stone_ghost_mask_buff:GetModifierHPRegenAmplify_Percentage()
    return 50
end

function modifier_treasure_stone_ghost_mask_buff:IsHidden() 
    return true
end

function modifier_treasure_stone_ghost_mask_buff:IsPurgable() 
    return false
end

function modifier_treasure_stone_ghost_mask_buff:RemoveOnDeath() 
    return false
end