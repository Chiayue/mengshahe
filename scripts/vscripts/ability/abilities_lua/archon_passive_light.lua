LinkLuaModifier( "modifier_archon_passive_light", "ability/abilities_lua/archon_passive_light.lua",LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_archon_passive_light_debuff", "ability/abilities_lua/archon_passive_light.lua",LUA_MODIFIER_MOTION_NONE )

-------------------------------------------------
--Abilities
if archon_passive_light == nil then
	archon_passive_light = class({})
end

if modifier_archon_passive_light_debuff == nil then
	modifier_archon_passive_light_debuff = class({})
end

function archon_passive_light:GetIntrinsicModifierName()
 	return "modifier_archon_passive_light"
end
--------------------------------------------------
if modifier_archon_passive_light == nil then
	modifier_archon_passive_light = class({})
end

function modifier_archon_passive_light:DeclareFunctions()
	local funcs = {
		MODIFIER_EVENT_ON_ATTACK_LANDED,
	}
	return funcs
end

function modifier_archon_passive_light:IsHidden()
	return true
end

function modifier_archon_passive_light:OnAttackLanded( params )
	if params.attacker ~= self:GetParent() then
		return 0
	end
	if not RollPercentage(25) then
		return
	end
	local hTarget = params.target
	local abil_damage = self:GetCaster():GetStrength() + self:GetCaster():GetAgility() + self:GetCaster():GetIntellect()
	local aoe = self:GetAbility():GetSpecialValueFor( "aoe" )
	local damage = {
		victim = hTarget,
		attacker = self:GetCaster(),
		damage = abil_damage * 0.5,
		damage_type = self:GetAbility():GetAbilityDamageType(),
	}
	ApplyDamage( damage )

	-- 创建效果
	local EffectName = "particles/units/heroes/hero_omniknight/omniknight_purification.vpcf"

	local nFXIndex = ParticleManager:CreateParticle( EffectName, PATTACH_ABSORIGIN_FOLLOW, self:GetCaster() )
	local health_bouns = abil_damage * 0.5
	local allies = FindUnitsInRadius(
		self:GetCaster():GetTeamNumber(), 
		self:GetCaster():GetOrigin(), 
		self:GetCaster(), 
		aoe, 
		DOTA_UNIT_TARGET_TEAM_FRIENDLY, 
		DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, 
		0, 0, false 
	)
	for _,ally in pairs(allies) do
		if ally ~= nil  then
			ally:Heal(health_bouns,self:GetCaster())
			-- PopupHealing(ally, health_bouns)
			ParticleManager:CreateParticle( "particles/units/heroes/hero_omniknight/omniknight_purification_d_glow.vpcf", PATTACH_ABSORIGIN_FOLLOW, ally )
		end
	end
end

