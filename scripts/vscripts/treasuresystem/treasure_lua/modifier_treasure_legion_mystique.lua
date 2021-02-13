---------------------------------------------------------------------------
-- 宝物：军团秘法
---------------------------------------------------------------------------

if modifier_treasure_legion_mystique== nil then 
    modifier_treasure_legion_mystique = class({})
end

function modifier_treasure_legion_mystique:GetTexture()
    if self:GetDuration() < 0 then
        return "buff/modifier_treasure_legion_mystique"
    end
    return "buff/modifier_treasure_keep_changing"
end

-- function modifier_treasure_legion_mystique:IsPurgable()
--     return false
-- end
 
-- function modifier_treasure_legion_mystique:RemoveOnDeath()
--     return false
-- end

-- function modifier_treasure_legion_mystique:IsAura()
--     return true
-- end

-- function modifier_treasure_legion_mystique:GetAuraRadius()
--     return 400
-- end

-- function modifier_treasure_legion_mystique:GetAuraSearchTeam()
--     return DOTA_UNIT_TARGET_TEAM_FRIENDLY
-- end

-- function modifier_treasure_legion_mystique:GetAuraSearchType()
--     return DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC
-- end

-- function modifier_treasure_legion_mystique:GetAuraSearchFlags()
--     return DOTA_UNIT_TARGET_FLAG_NONE
-- end

-- function modifier_treasure_legion_mystique:GetModifierAura()
--     return "modifier_treasure_legion_mystique_mana_regen"
-- end

function modifier_treasure_legion_mystique:IsDebuff()
	return false 
end
function modifier_treasure_legion_mystique:IsHidden()
	return false
end
function modifier_treasure_legion_mystique:IsPurgable()
	return false
end
function modifier_treasure_legion_mystique:IsPurgeException()
	return false
end
function modifier_treasure_legion_mystique:OnCreated(kv)
    if not IsServer() then
        return
    end
    self:StartIntervalThink(0.1)
end
function modifier_treasure_legion_mystique:OnIntervalThink() 
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
        ally[i]:AddNewModifier(self:GetCaster(), self, "modifier_treasure_legion_mystique_mana_regen", {duration = 5})
    end       
    self:StartIntervalThink(5)
end

--------------------------------------------------------------------------
LinkLuaModifier( "modifier_treasure_legion_mystique_mana_regen","treasuresystem/treasure_lua/modifier_treasure_legion_mystique", LUA_MODIFIER_MOTION_NONE )

if modifier_treasure_legion_mystique_mana_regen == nil then 
    modifier_treasure_legion_mystique_mana_regen = class({})
end

function modifier_treasure_legion_mystique_mana_regen:DeclareFunctions()
    return {
        MODIFIER_PROPERTY_MANA_REGEN_CONSTANT,
    }
end

function modifier_treasure_legion_mystique_mana_regen:GetModifierConstantManaRegen()
    local caster = self:GetCaster()
    if caster:HasModifier("modifier_treasure_legion_arcanum") and caster:HasModifier("modifier_treasure_legion_drum") and caster:HasModifier("modifier_treasure_legion_flag") then
        return 3
    else 
        return 1
    end
end

function modifier_treasure_legion_mystique_mana_regen:IsHidden()
    return true
end