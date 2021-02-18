---------------------------------------------------------------------------
-- 宝物：邪恶面具
---------------------------------------------------------------------------
LinkLuaModifier("modifier_treasure_heart_curse","treasuresystem/treasure_lua/modifier_treasure_heart_curse", LUA_MODIFIER_MOTION_NONE)

if modifier_treasure_evil_mask == nil then 
    modifier_treasure_evil_mask = class({})
end

function modifier_treasure_evil_mask:GetTexture()
    if self:GetDuration() < 0 then
        return "buff/modifier_treasure_evil_mask"
    end
    return "buff/modifier_treasure_keep_changing"
end

-- function modifier_treasure_evil_mask:IsPurgable()
--     return false
-- end

-- function modifier_treasure_evil_mask:RemoveOnDeath()
--     return false
-- end

-- function modifier_treasure_evil_mask:IsAura()
--     return true
-- end

-- function modifier_treasure_evil_mask:GetAuraRadius()
--     return 400
-- end

-- function modifier_treasure_evil_mask:GetAuraSearchTeam()
--     return DOTA_UNIT_TARGET_TEAM_ENEMY
-- end

-- function modifier_treasure_evil_mask:GetAuraSearchType()
--     return DOTA_UNIT_TARGET_BASIC
-- end

-- function modifier_treasure_evil_mask:GetAuraSearchFlags()
--     return DOTA_UNIT_TARGET_FLAG_NONE
-- end

-- function modifier_treasure_evil_mask:GetModifierAura()
--     return "modifier_treasure_evil_mask_buff"
-- end

function modifier_treasure_evil_mask:IsDebuff()
	return false 
end
function modifier_treasure_evil_mask:IsHidden()
	return false
end
function modifier_treasure_evil_mask:IsPurgable()
	return false
end
function modifier_treasure_evil_mask:IsPurgeException()
	return false
end
function modifier_treasure_evil_mask:RemoveOnDeath()
    return false
end
function modifier_treasure_evil_mask:OnCreated(kv)
    if not IsServer() then
        return
    end
    self:StartIntervalThink(1)
end
function modifier_treasure_evil_mask:OnIntervalThink()
    if self:GetCaster():HasModifier("modifier_treasure_wizardry_mask") then
        self:GetCaster():AddNewModifier(self:GetCaster(),nil,"modifier_treasure_heart_curse",{})
        return
    end 
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
        enemy[i]:AddNewModifier(self:GetCaster(), self, "modifier_treasure_evil_mask_buff", {duration = 2})
    end       
    self:StartIntervalThink(2)
end

--------------------------------------------------------------------------------

LinkLuaModifier("modifier_treasure_evil_mask_buff","treasuresystem/treasure_lua/modifier_treasure_evil_mask", LUA_MODIFIER_MOTION_NONE)

if modifier_treasure_evil_mask_buff == nil then
    modifier_treasure_evil_mask_buff = class({})
end

function modifier_treasure_evil_mask_buff:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
    }
end

function modifier_treasure_evil_mask_buff:GetModifierPhysicalArmorBonus()
    if self:GetCaster():HasModifier("modifier_treasure_wizardry_mask") then
        return -15
    else
        return -8
    end
end

function modifier_treasure_evil_mask_buff:IsHidden()
    return true
end