---------------------------------------------------------------------------
-- 宝物：石堂城之王
---------------------------------------------------------------------------

if modifier_treasure_stone_hall_city_king == nil then 
    modifier_treasure_stone_hall_city_king = class({})
end

function modifier_treasure_stone_hall_city_king:DeclareFunctions()
	return {
        MODIFIER_EVENT_ON_DEATH,
    }
end

function modifier_treasure_stone_hall_city_king:OnDeath(params)
    if IsMyKilledBadGuys(self:GetParent(), params) and RollPercentage(30) then
        self:GetParent():FindModifierByName("modifier_treasure_stone_hall_city_king_buff"):IncrementStackCount()
    end
end

function modifier_treasure_stone_hall_city_king:IsHidden()
    return true
end

function modifier_treasure_stone_hall_city_king:IsPurgable()
    return false
end
 
function modifier_treasure_stone_hall_city_king:RemoveOnDeath()
    return false
end

function modifier_treasure_stone_hall_city_king:OnCreated(params)
    if IsServer() then
        local parent = self:GetParent()
        parent:AddNewModifier(parent, nil, "modifier_treasure_stone_hall_city_king_buff", nil)
    end
end

------------------------------------------------------------------------------------

LinkLuaModifier("modifier_treasure_stone_hall_city_king_buff","treasuresystem/treasure_lua/modifier_treasure_stone_hall_city_king", LUA_MODIFIER_MOTION_NONE)

if modifier_treasure_stone_hall_city_king_buff == nil then 
    modifier_treasure_stone_hall_city_king_buff = class({})
end

function modifier_treasure_stone_hall_city_king_buff:IsHidden()
    return true
end

function modifier_treasure_stone_hall_city_king_buff:IsPurgable()
    return false
end
 
function modifier_treasure_stone_hall_city_king_buff:RemoveOnDeath()
    return false
end

function modifier_treasure_stone_hall_city_king_buff:DeclareFunctions()
    return {
        MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
        MODIFIER_PROPERTY_STATS_AGILITY_BONUS,
        MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,
    }
end

function modifier_treasure_stone_hall_city_king_buff:GetModifierBonusStats_Strength()
    return self:GetStackCount()
end

function modifier_treasure_stone_hall_city_king_buff:GetModifierBonusStats_Agility()
    return self:GetStackCount()
end

function modifier_treasure_stone_hall_city_king_buff:GetModifierBonusStats_Intellect()
    return self:GetStackCount()
end