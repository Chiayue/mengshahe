---------------------------------------------------------------------------
-- 宝物：石堂城斗篷
---------------------------------------------------------------------------

if modifier_treasure_stone_hall_city_cloak == nil then 
    modifier_treasure_stone_hall_city_cloak = class({})
end
function modifier_treasure_stone_hall_city_cloak:GetTexture()
    if self:GetDuration() < 0 then
        return "buff/modifier_treasure_stone_hall_city_cloak"
    end
    return "buff/modifier_treasure_keep_changing"
end
function modifier_treasure_stone_hall_city_cloak:DeclareFunctions()
	return {
        MODIFIER_EVENT_ON_DEATH,
        MODIFIER_PROPERTY_EXTRA_HEALTH_BONUS,
    }
end

function modifier_treasure_stone_hall_city_cloak:OnDeath(params)
    local parent = self:GetParent()
    if IsMyKilledBadGuys(parent, params) then
        self:IncrementStackCount()
        parent:CalculateStatBonus(true)
        parent:Heal(50, nil)
    end
end

function modifier_treasure_stone_hall_city_cloak:GetModifierExtraHealthBonus(params)
    return self:GetStackCount() * 20
end

function modifier_treasure_stone_hall_city_cloak:IsPurgable()
    return false
end
 
function modifier_treasure_stone_hall_city_cloak:RemoveOnDeath()
    return false
end

function modifier_treasure_stone_hall_city_cloak:OnCreated(kv) 
    if IsServer() then
        local parent = self:GetParent()
        if parent:HasModifier("modifier_treasure_stone_hall_city_armor") and parent:HasModifier("modifier_treasure_stone_hall_city_spear") then
            parent:AddNewModifier(parent, nil, "modifier_treasure_stone_hall_city_king", nil)
        end
    end
end

function modifier_treasure_stone_hall_city_cloak:OnDestroy() 
    if IsServer() then
        self:GetParent():RemoveModifierByName("modifier_treasure_stone_hall_city_king")
    end
end