LinkLuaModifier( "modifier_archon_agi_quickshot_passive", "ability/abilities_lua/archon_agi_quickshot_passive.lua",LUA_MODIFIER_MOTION_NONE )

-------------------------------------------------
--Abilities
if archon_agi_quickshot_passive == nil then
	archon_agi_quickshot_passive = class({})
end

function archon_agi_quickshot_passive:GetIntrinsicModifierName()
 	return "modifier_archon_agi_quickshot_passive"
end

function archon_agi_quickshot_passive:OnProjectileHit( hTarget, vLocation )
	local attacker = self:GetCaster()
	local damage = attacker:GetAverageTrueAttackDamage(hTarget)
	local info = {
		victim = hTarget,
		attacker = self:GetCaster(),
		damage = damage,
		damage_type = self:GetAbilityDamageType(),
	}
	ApplyDamage(info)
end
--------------------------------------------------------------------------------
-- modifier
if modifier_archon_agi_quickshot_passive == nil then
	modifier_archon_agi_quickshot_passive = class({})
end


--------------------------------------------------------------------------------
function modifier_archon_agi_quickshot_passive:IsDebuff()
	return false
end

function modifier_archon_agi_quickshot_passive:OnCreated( kv )
	-- self.chance = self:GetAbility():GetSpecialValueFor( "chance" )
	--self.great_cleave_radius = self:GetAbility():GetSpecialValueFor( "great_cleave_radius" )
end

--------------------------------------------------------------------------------

function modifier_archon_agi_quickshot_passive:OnRefresh( kv )
	-- self.chance = self:GetAbility():GetSpecialValueFor( "chance" )
	--self.great_cleave_radius = self:GetAbility():GetSpecialValueFor( "great_cleave_radius" )
end
----------------------

function modifier_archon_agi_quickshot_passive:OnAttack( params )
	if not IsServer() then
		return
	end
	if params then
		if params.attacker ~= self:GetParent() then
			return
		end
		local caster = self:GetAbility():GetCaster() -- 这是一个实体
		local target = params.target
		local caster_location = caster:GetAbsOrigin()
		local projectile_speed = caster.GetProjectileSpeed(caster)
		local ability = self:GetAbility()
		local radius = ability:GetSpecialValueFor("range")
		-- local projectile_speed = ability:GetSpecialValueFor("shot_speed")
		local max_targets = ability:GetSpecialValueFor("counts")
		local target_type = ability:GetAbilityTargetType()
		local target_team = ability:GetAbilityTargetTeam()
		local target_flags = ability:GetAbilityTargetFlags()
		local caster_location = target:GetAbsOrigin()
		-- local attack_target = 
		
		local split_shot_targets = FindUnitsInRadius(
			caster:GetTeamNumber(), 
			caster:GetAbsOrigin(), 
			target, 
			radius, 
			target_team, 
			target_type, 
			target_flags, 
			FIND_CLOSEST, 
			false
		)

		-- Create projectiles for units that are not the casters current attack target
		for _,v in pairs(split_shot_targets) do
			if v:GetTeamNumber() ~= caster:GetTeamNumber() then
				if v ~= params.target then
					local projectile_info = {
						EffectName = "particles/units/heroes/hero_medusa/medusa_base_attack.vpcf",
						Ability = ability,
						vSpawnOrigin = caster_location,
						Target = v,
						Source = caster,
						bHasFrontalCone = false,
						iMoveSpeed = projectile_speed,
						bReplaceExisting = false,
						bProvidesVision = false
					}
					ProjectileManager:CreateTrackingProjectile(projectile_info)
					max_targets = max_targets - 1
				end
				-- If we reached the maximum amount of targets then break the loop
				if max_targets == 0 then break end
			end
		end
	end
	
end
--------------------------------------------------------------------------------

function modifier_archon_agi_quickshot_passive:DeclareFunctions()
	local funcs = {
		-- MODIFIER_EVENT_ON_ATTACK_LANDED,
		MODIFIER_EVENT_ON_ATTACK ,
	}
	return funcs
end

--------------------------------------------------------------------------------

function modifier_archon_agi_quickshot_passive:OnAttackLanded( params )

	-- if random <= self.chance then
	-- 	self.speed = self:GetAbility():GetSpecialValueFor( "shot_speed" )
	-- 	self.width_initial = self:GetAbility():GetSpecialValueFor( "width_initial" )
	-- 	self.width_end = self:GetAbility():GetSpecialValueFor( "width_end" )
	-- 	self.distance = self:GetAbility():GetSpecialValueFor( "distance" )
	-- 	self.damage = self:GetAbility():GetSpecialValueFor( "damage" ) + self:GetCaster():GetAgility() * 2
	-- 	local vPos = nil

	-- 	if params.target then
	-- 		vPos =  params.target:GetOrigin()
	-- 	else
	-- 		vPos = params.attacker:GetOrigin()
	-- 	end

	-- 	local vDirection = vPos - params.attacker:GetOrigin()
	-- 	vDirection.z = 0.0
	-- 	vDirection = vDirection:Normalized()

	-- 	self.speed = self.speed * ( self.distance / ( self.distance - self.width_initial ) )

	-- 	local info = {
	-- 		EffectName = "particles/units/heroes/hero_windrunner/windrunner_spell_powershot.vpcf",
	-- 		Ability = self,
	-- 		vSpawnOrigin = params.attacker:GetOrigin(), 
	-- 		fStartRadius = self.width_initial,
	-- 		fEndRadius = self.width_end,
	-- 		vVelocity = vDirection * self.speed,
	-- 		fDistance = self.distance,
	-- 		Source = params.attacker,
	-- 		iUnitTargetTeam = DOTA_UNIT_TARGET_TEAM_ENEMY,
	-- 		iUnitTargetType = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
	-- 	}

	-- 	ProjectileManager:CreateLinearProjectile( info )
	-- end
end

function modifier_archon_agi_quickshot_passive:OnProjectileHit( params )
	-- local caster = params.attacker
	-- local target = params.target
	-- local ability = self:GetAbility()

	-- local damage_table = {}

	-- damage_table.attacker = caster
	-- damage_table.victim = target
	-- damage_table.damage_type = ability:GetAbilityDamageType()
	-- damage_table.damage = params.damage

	-- ApplyDamage(damage_table)
end