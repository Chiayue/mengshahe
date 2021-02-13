---------------------------------------------------------------------------
-- 宝物：石堂城板甲
---------------------------------------------------------------------------

if modifier_treasure_stone_hall_city_armor == nil then 
    modifier_treasure_stone_hall_city_armor = class({})
end

function modifier_treasure_stone_hall_city_armor:GetTexture()
    if self:GetDuration() < 0 then
        return "buff/modifier_treasure_stone_hall_city_armor"
    end
    return "buff/modifier_treasure_keep_changing"
end

function modifier_treasure_stone_hall_city_armor:DeclareFunctions()
	return {
        MODIFIER_EVENT_ON_DEATH,
        MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
    }
end

function modifier_treasure_stone_hall_city_armor:OnDeath(params)
    if IsMyKilledBadGuys(self:GetParent(), params) then
        self:IncrementStackCount()
    end
end

function modifier_treasure_stone_hall_city_armor:GetModifierPhysicalArmorBonus(params)
    return math.floor(self:GetStackCount() / 80)
end

function modifier_treasure_stone_hall_city_armor:IsPurgable()
    return false
end
 
function modifier_treasure_stone_hall_city_armor:RemoveOnDeath()
    return false
end

function modifier_treasure_stone_hall_city_armor:OnCreated(kv) 
    if IsServer() then
        local parent = self:GetParent()
        if parent:HasModifier("modifier_treasure_stone_hall_city_cloak") and parent:HasModifier("modifier_treasure_stone_hall_city_spear") then
            parent:AddNewModifier(parent, nil, "modifier_treasure_stone_hall_city_king", nil)
        end
    end
end

function modifier_treasure_stone_hall_city_armor:OnDestroy() 
    if IsServer() then
        self:GetParent():RemoveModifierByName("modifier_treasure_stone_hall_city_king")
    end
end