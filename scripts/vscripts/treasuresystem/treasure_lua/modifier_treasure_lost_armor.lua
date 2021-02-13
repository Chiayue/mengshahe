---------------------------------------------------------------------------
-- 宝物：遗失之物 - 腐蚀护甲
---------------------------------------------------------------------------

if modifier_treasure_lost_armor == nil then 
    modifier_treasure_lost_armor = class({})
end

function modifier_treasure_lost_armor:GetTexture()
    if self:GetDuration() < 0 then
        return "buff/modifier_treasure_lost_armor"
    end
    return "buff/modifier_treasure_keep_changing"
end

function modifier_treasure_lost_armor:DeclareFunctions()
	return {
        MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
    }
end

function modifier_treasure_lost_armor:GetModifierPhysicalArmorBonus(event)
    return 10
end

function modifier_treasure_lost_armor:OnCreated(kv)
    if IsServer() then
        self:StartIntervalThink(1)
    end
end

function modifier_treasure_lost_armor:OnIntervalThink()
    local parent = self:GetParent()
    ApplyDamage({
        victim = parent,
        attacker = parent,
        damage = 66,
        damage_type = DAMAGE_TYPE_PURE,
    })
end
 
function modifier_treasure_lost_armor:IsPurgable()
    return false
end
 
function modifier_treasure_lost_armor:RemoveOnDeath()
    return false
end