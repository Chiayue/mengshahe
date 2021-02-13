---------------------------------------------------------------------------
-- 宝物：军团战鼓
---------------------------------------------------------------------------

if modifier_treasure_legion_drum == nil then 
    modifier_treasure_legion_drum = class({})
end

function modifier_treasure_legion_drum:GetTexture()
    if self:GetDuration() < 0 then
        return "buff/modifier_treasure_legion_drum"
    end
    return "buff/modifier_treasure_keep_changing"
end

-- function modifier_treasure_legion_drum:IsPurgable()
--     return false
-- end
 
-- function modifier_treasure_legion_drum:RemoveOnDeath()
--     return false
-- end

-- function modifier_treasure_legion_drum:IsAura()
--     return true
-- end

-- function modifier_treasure_legion_drum:GetAuraRadius()
--     return 400
-- end

-- function modifier_treasure_legion_drum:GetAuraSearchTeam()
--     return DOTA_UNIT_TARGET_TEAM_FRIENDLY
-- end

-- function modifier_treasure_legion_drum:GetAuraSearchType()
--     return DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC
-- end

-- function modifier_treasure_legion_drum:GetAuraSearchFlags()
--     return DOTA_UNIT_TARGET_FLAG_NONE
-- end

-- function modifier_treasure_legion_drum:GetModifierAura()
--     return "modifier_treasure_legion_drum_attack_damage"
-- end

function modifier_treasure_legion_drum:IsDebuff()
	return false 
end
function modifier_treasure_legion_drum:IsHidden()
	return false
end
function modifier_treasure_legion_drum:IsPurgable()
	return false
end
function modifier_treasure_legion_drum:IsPurgeException()
	return false
end
function modifier_treasure_legion_drum:OnCreated(kv)
    if not IsServer() then
        return
    end
    self:StartIntervalThink(0.1)
end
function modifier_treasure_legion_drum:OnIntervalThink() 
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
        ally[i]:AddNewModifier(self:GetCaster(), self, "modifier_treasure_legion_drum_attack_damage", {duration = 5})
    end       
    self:StartIntervalThink(5)
end

--------------------------------------------------------------------------
LinkLuaModifier( "modifier_treasure_legion_drum_attack_damage","treasuresystem/treasure_lua/modifier_treasure_legion_drum", LUA_MODIFIER_MOTION_NONE )

if modifier_treasure_legion_drum_attack_damage == nil then 
    modifier_treasure_legion_drum_attack_damage = class({})
end

function modifier_treasure_legion_drum_attack_damage:DeclareFunctions()
    return {
        MODIFIER_PROPERTY_DAMAGEOUTGOING_PERCENTAGE,
    }
end

function modifier_treasure_legion_drum_attack_damage:GetModifierDamageOutgoing_Percentage()
    local caster = self:GetCaster()
    if caster:HasModifier("modifier_treasure_legion_mystique") and caster:HasModifier("modifier_treasure_legion_arcanum") and caster:HasModifier("modifier_treasure_legion_flag") then
        return 200
    else 
        return 40
    end
end

function modifier_treasure_legion_drum_attack_damage:IsHidden()
    return true
end