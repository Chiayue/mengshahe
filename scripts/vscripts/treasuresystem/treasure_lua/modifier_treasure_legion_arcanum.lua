---------------------------------------------------------------------------
-- 宝物：军团秘药
---------------------------------------------------------------------------

if modifier_treasure_legion_arcanum == nil then 
    modifier_treasure_legion_arcanum = class({})
end

function modifier_treasure_legion_arcanum:GetTexture()
    if self:GetDuration() < 0 then
        return "buff/modifier_treasure_legion_arcanum"
    end
    return "buff/modifier_treasure_keep_changing"
end

-- function modifier_treasure_legion_arcanum:IsPurgable()
--     return false
-- end
 
-- function modifier_treasure_legion_arcanum:RemoveOnDeath()
--     return false
-- end

-- function modifier_treasure_legion_arcanum:IsAura()
--     return true
-- end

-- function modifier_treasure_legion_arcanum:GetAuraRadius()
--     return 400
-- end

-- function modifier_treasure_legion_arcanum:GetAuraSearchTeam()
--     return DOTA_UNIT_TARGET_TEAM_FRIENDLY
-- end

-- function modifier_treasure_legion_arcanum:GetAuraSearchType()
--     return DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC
-- end

-- function modifier_treasure_legion_arcanum:GetAuraSearchFlags()
--     return DOTA_UNIT_TARGET_FLAG_NONE
-- end

-- function modifier_treasure_legion_arcanum:GetModifierAura()
--     return "modifier_treasure_legion_arcanum_hp_regen"
-- end

function modifier_treasure_legion_arcanum:IsDebuff()
	return false 
end
function modifier_treasure_legion_arcanum:IsHidden()
	return false
end
function modifier_treasure_legion_arcanum:IsPurgable()
	return false
end
function modifier_treasure_legion_arcanum:IsPurgeException()
	return false
end
function modifier_treasure_legion_arcanum:OnCreated(kv)
    if not IsServer() then
        return
    end
    self:StartIntervalThink(0.1)
end
function modifier_treasure_legion_arcanum:OnIntervalThink() 
    local ally = FindUnitsInRadius(
		DOTA_TEAM_GOODGUYS,
		self:GetCaster():GetAbsOrigin(),
		nil,
		400,
		DOTA_UNIT_TARGET_TEAM_FRIENDLY,
		DOTA_UNIT_TARGET_HERO+DOTA_UNIT_TARGET_BASIC,
		DOTA_UNIT_TARGET_FLAG_NONE,
		FIND_ANY_ORDER,
		false
    )
    for i=1,#ally do 
        ally[i]:AddNewModifier(self:GetCaster(), self, "modifier_treasure_legion_arcanum_hp_regen", {duration = 5})
    end       
    self:StartIntervalThink(5)
end

--------------------------------------------------------------------------
LinkLuaModifier( "modifier_treasure_legion_arcanum_hp_regen","treasuresystem/treasure_lua/modifier_treasure_legion_arcanum", LUA_MODIFIER_MOTION_NONE )

if modifier_treasure_legion_arcanum_hp_regen == nil then 
    modifier_treasure_legion_arcanum_hp_regen = class({})
end

function modifier_treasure_legion_arcanum_hp_regen:DeclareFunctions()
    return {
        MODIFIER_PROPERTY_HEALTH_REGEN_CONSTANT,
    }
end

function modifier_treasure_legion_arcanum_hp_regen:GetModifierConstantHealthRegen()
    local caster = self:GetCaster()
    if caster:HasModifier("modifier_treasure_legion_mystique") and caster:HasModifier("modifier_treasure_legion_drum") and caster:HasModifier("modifier_treasure_legion_flag") then
        return 3000
    else 
        return 300
    end
end

function modifier_treasure_legion_arcanum_hp_regen:IsHidden()
    return true
end