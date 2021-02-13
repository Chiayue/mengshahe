---------------------------------------------------------------------------
-- 宝物：石堂城长枪
---------------------------------------------------------------------------

if modifier_treasure_stone_hall_city_spear == nil then 
    modifier_treasure_stone_hall_city_spear = class({})
end

function modifier_treasure_stone_hall_city_spear:GetTexture()
    if self:GetDuration() < 0 then
        return "buff/modifier_treasure_stone_hall_city_spear"
    end
    return "buff/modifier_treasure_keep_changing"
end

function modifier_treasure_stone_hall_city_spear:DeclareFunctions()
	return {
        MODIFIER_EVENT_ON_DEATH,
        MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,
    }
end

function modifier_treasure_stone_hall_city_spear:OnDeath(params)
    if IsMyKilledBadGuys(self:GetParent(), params) then
        self:IncrementStackCount()
    end
end

function modifier_treasure_stone_hall_city_spear:GetModifierPreAttack_BonusDamage()
    return self:GetStackCount() * 2
end

function modifier_treasure_stone_hall_city_spear:IsPurgable()
    return false
end
 
function modifier_treasure_stone_hall_city_spear:RemoveOnDeath()
    return false
end

function modifier_treasure_stone_hall_city_spear:OnCreated(kv)
    if IsServer() then
        local parent = self:GetParent()
        if parent:HasModifier("modifier_treasure_stone_hall_city_armor") and parent:HasModifier("modifier_treasure_stone_hall_city_cloak") then
            parent:AddNewModifier(parent, nil, "modifier_treasure_stone_hall_city_king", nil)
        end
    end
end

function modifier_treasure_stone_hall_city_spear:OnDestroy() 
    if IsServer() then
        self:GetParent():RemoveModifierByName("modifier_treasure_stone_hall_city_king")
    end
end