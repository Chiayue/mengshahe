---------------------------------------------------------------------------
-- 宝物羁绊：巫术面具，邪恶面具，解锁【诅咒之心】
---------------------------------------------------------------------------

if modifier_treasure_heart_curse == nil then 
    modifier_treasure_heart_curse = class({})
end

function modifier_treasure_heart_curse:GetTexture()
    if self:GetDuration() < 0 then
        return "buff/modifier_treasure_heart_curse"
    end
    return "buff/modifier_treasure_keep_changing"
end

function modifier_treasure_heart_curse:IsDebuff()
	return false 
end
function modifier_treasure_heart_curse:IsHidden()
	return false
end
function modifier_treasure_heart_curse:IsPurgable()
	return false
end
function modifier_treasure_heart_curse:IsPurgeException()
	return false
end
function modifier_treasure_heart_curse:RemoveOnDeath()
    return false
end
function modifier_treasure_heart_curse:OnCreated(kv)
    if not IsServer() then
        return
    end
    self:GetCaster():RemoveModifierByName("modifier_treasure_wizardry_mask")
    self:GetCaster():RemoveModifierByName("modifier_treasure_evil_mask")
    self:StartIntervalThink(0.1)
end
function modifier_treasure_heart_curse:OnIntervalThink() 
    local enemy = FindUnitsInRadius(
		DOTA_TEAM_GOODGUYS,
		self:GetCaster():GetAbsOrigin(),
		nil,
		400,
		DOTA_UNIT_TARGET_TEAM_ENEMY,
		DOTA_UNIT_TARGET_BASIC,
		DOTA_UNIT_TARGET_FLAG_NONE,
		FIND_ANY_ORDER,
		false
    )
    for i=1,#enemy do 
        enemy[i]:AddNewModifier(self:GetCaster(), self, "modifier_treasure_heart_curse_buff", {duration = 2})
    end       
    self:StartIntervalThink(2)
end

--------------------------------------------------------------------------------

LinkLuaModifier("modifier_treasure_heart_curse_buff","treasuresystem/treasure_lua/modifier_treasure_heart_curse", LUA_MODIFIER_MOTION_NONE)

if modifier_treasure_heart_curse_buff == nil then
    modifier_treasure_heart_curse_buff = class({})
end

function modifier_treasure_heart_curse_buff:DeclareFunctions()
	return {
        MODIFIER_PROPERTY_MAGICAL_RESISTANCE_DIRECT_MODIFICATION,
        MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
    }
end

function modifier_treasure_heart_curse_buff:GetModifierMagicalResistanceDirectModification()
    return -1 * self:GetParent():GetBaseMagicalResistanceValue() * 0.2
end

function modifier_treasure_heart_curse_buff:GetModifierPhysicalArmorBonus()
    return -15
end

function modifier_treasure_heart_curse_buff:IsHidden()
    return true
end