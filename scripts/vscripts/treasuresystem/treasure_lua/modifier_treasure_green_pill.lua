---------------------------------------------------------------------------
-- 宝物：绿色药丸
---------------------------------------------------------------------------

if modifier_treasure_green_pill == nil then 
    modifier_treasure_green_pill = class({})
end

function modifier_treasure_green_pill:GetTexture()
    if self:GetDuration() < 0 then
        return "buff/modifier_treasure_green_pill"
    end
    return "buff/modifier_treasure_keep_changing"
end

function modifier_treasure_green_pill:DeclareFunctions()
	return {
        MODIFIER_PROPERTY_STATS_AGILITY_BONUS,
    }
end

function modifier_treasure_green_pill:GetModifierBonusStats_Agility()
    return 200
end

function modifier_treasure_green_pill:IsPurgable()
    return false
end
 
function modifier_treasure_green_pill:RemoveOnDeath()
    return false
end

function modifier_treasure_green_pill:OnCreated(kv) 
    if IsServer() then
        self:StartIntervalThink(1)
    end
end

function modifier_treasure_green_pill:OnIntervalThink()
    local parent = self:GetParent()
    parent:AddNewModifier(parent, nil, "modifier_treasure_green_pill_debuff", nil)
    if parent:HasModifier("modifier_treasure_red_pill") and parent:HasModifier("modifier_treasure_blue_pill") then
        parent:AddNewModifier(parent, nil, "modifier_treasure_resistance_max", nil)
    end
    self:StartIntervalThink(-1)
end

-------------------------------------------------------------------------

LinkLuaModifier("modifier_treasure_green_pill_debuff","treasuresystem/treasure_lua/modifier_treasure_green_pill", LUA_MODIFIER_MOTION_NONE)

if modifier_treasure_green_pill_debuff == nil then 
    modifier_treasure_green_pill_debuff = class({})
end

function modifier_treasure_green_pill_debuff:DeclareFunctions()
	return {
        MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
        MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,
    }
end

function modifier_treasure_green_pill_debuff:GetModifierBonusStats_Strength()
    return -50
end

function modifier_treasure_green_pill_debuff:GetModifierBonusStats_Intellect()
    return -50
end

function modifier_treasure_green_pill_debuff:IsHidden() 
    return true
end

function modifier_treasure_green_pill_debuff:IsPurgable() 
    return false
end

function modifier_treasure_green_pill_debuff:RemoveOnDeath() 
    return false
end