---------------------------------------------------------------------------
-- 宝物：巫术面具
---------------------------------------------------------------------------

if modifier_treasure_wizardry_mask == nil then 
    modifier_treasure_wizardry_mask = class({})
end

function modifier_treasure_wizardry_mask:GetTexture()
    if self:GetDuration() < 0 then
        return "buff/modifier_treasure_wizardry_mask"
    end
    return "buff/modifier_treasure_keep_changing"
end

-- function modifier_treasure_wizardry_mask:IsPurgable()
--     return false
-- end

-- function modifier_treasure_wizardry_mask:RemoveOnDeath()
--     return false
-- end

-- function modifier_treasure_wizardry_mask:IsAura()
--     return true
-- end

-- function modifier_treasure_wizardry_mask:GetAuraRadius()
--     return 400
-- end

-- function modifier_treasure_wizardry_mask:GetAuraSearchTeam()
--     return DOTA_UNIT_TARGET_TEAM_ENEMY
-- end

-- function modifier_treasure_wizardry_mask:GetAuraSearchType()
--     return DOTA_UNIT_TARGET_BASIC
-- end

-- function modifier_treasure_wizardry_mask:GetAuraSearchFlags()
--     return DOTA_UNIT_TARGET_FLAG_NONE
-- end

-- function modifier_treasure_wizardry_mask:GetModifierAura()
--     return "modifier_treasure_wizardry_mask_buff"
-- end

function modifier_treasure_wizardry_mask:IsDebuff()
	return false 
end
function modifier_treasure_wizardry_mask:IsHidden()
	return false
end
function modifier_treasure_wizardry_mask:IsPurgable()
	return false
end
function modifier_treasure_wizardry_mask:IsPurgeException()
	return false
end
function modifier_treasure_wizardry_mask:RemoveOnDeath()
    return false
end
function modifier_treasure_wizardry_mask:OnCreated(kv)
    if not IsServer() then
        return
    end
    self:StartIntervalThink(0.1)
end
function modifier_treasure_wizardry_mask:OnIntervalThink() 
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
        enemy[i]:AddNewModifier(self:GetCaster(), self, "modifier_treasure_wizardry_mask_buff", {duration = 2})
    end       
    self:StartIntervalThink(2)
end

--------------------------------------------------------------------------------

LinkLuaModifier("modifier_treasure_wizardry_mask_buff","treasuresystem/treasure_lua/modifier_treasure_wizardry_mask", LUA_MODIFIER_MOTION_NONE)

if modifier_treasure_wizardry_mask_buff == nil then
    modifier_treasure_wizardry_mask_buff = class({})
end

function modifier_treasure_wizardry_mask_buff:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_MAGICAL_RESISTANCE_DIRECT_MODIFICATION,
    }
end

function modifier_treasure_wizardry_mask_buff:GetModifierMagicalResistanceDirectModification()
    if self:GetCaster():HasModifier("modifier_treasure_evil_mask") then
        return -1 * self:GetParent():GetBaseMagicalResistanceValue() * 0.2
    else
        return -1 * self:GetParent():GetBaseMagicalResistanceValue() * 0.1
    end
end

function modifier_treasure_wizardry_mask_buff:IsHidden()
    return true
end