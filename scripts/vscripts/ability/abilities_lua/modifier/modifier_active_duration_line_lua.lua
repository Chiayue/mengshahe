modifier_active_duration_line_lua = class({})

--------------------------------------------------------------------------------

function modifier_active_duration_line_lua:IsHidden()
	return true
end

--------------------------------------------------------------------------------

function modifier_active_duration_line_lua:OnCreated( kv )
    if IsServer() then
        -- DeepPrintTable(self:GetAbility())
		self.speed = self:GetAbility():GetSpecialValueFor( "shot_speed" )
		self.width_initial = self:GetAbility():GetSpecialValueFor( "width_initial" )
		self.width_end = self:GetAbility():GetSpecialValueFor( "width_end" )
		self.distance = self:GetAbility():GetSpecialValueFor( "distance" )
		self.space_time = self:GetAbility():GetSpecialValueFor( "space_time" )
        self.duration = self:GetAbility():GetSpecialValueFor( "duration" )
		-- EmitSoundOnLocationForAllies( self:GetParent():GetOrigin(), "Ability.PreLightStrikeArray", self.Caster )
		
		-- local nFXIndex = ParticleManager:CreateParticleForTeam( "particles/units/heroes/hero_alchemist/alchemist_acid_spray_cinside.vpcf", PATTACH_WORLDORIGIN, self.Caster, self.Caster:GetTeamNumber() )
		-- ParticleManager:SetParticleControl( nFXIndex, 0, self:GetParent():GetOrigin() )
		-- ParticleManager:SetParticleControl( nFXIndex, 1, Vector( self.radius, 1, 1 ) )
        -- ParticleManager:ReleaseParticleIndex( nFXIndex )
		
		self:SetStackCount(1)
        self:StartIntervalThink( self.space_time )
	end
end

--------------------------------------------------------------------------------

function modifier_active_duration_line_lua:OnIntervalThink()
	if IsServer() then
		
		self:SetStackCount(self:GetStackCount() + 1)

		-- local vPos = nil
		-- if self:GetAbility():GetCursorTarget() then
		-- 	vPos = self:GetAbility():GetCursorTarget():GetOrigin()
		-- else
		-- 	vPos = self:GetAbility():GetCursorPosition()
		-- end

		local vPos = self:GetAbility().endpos

		local vDirection = vPos - self:GetAbility().Origin
		vDirection.z = 0.0
		vDirection = vDirection:Normalized()

		local Velocity = self.speed * ( self.distance / ( self.distance - self.width_initial ) )

		local info = {
			EffectName = "particles/units/heroes/hero_lina/lina_spell_dragon_slave.vpcf",
			Ability = self:GetAbility(),
			vSpawnOrigin = self:GetAbility().Origin, 
			fStartRadius = self.width_initial,
			fEndRadius = self.width_end,
			vVelocity = vDirection * Velocity,
			fDistance = self.distance,
			Source = self:GetAbility():GetCaster(),
			iUnitTargetTeam = DOTA_UNIT_TARGET_TEAM_ENEMY,
			iUnitTargetType = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
		}

		ProjectileManager:CreateLinearProjectile( info )

		if self.duration < self:GetStackCount() then
			self:StartIntervalThink(-1)
		end

		-- UTIL_Remove( self:GetParent() )
	end
end

-- function modifier_active_duration_line_lua:OnProjectileHit( hTarget, vLocation )
-- 	print(">>>>>>>>>>>>>>>>>>  OnProjectileHit>>>>>>>>>>>>>>>>>>>>>>>>")
-- 	if hTarget ~= nil and ( not hTarget:IsMagicImmune() ) and ( not hTarget:IsInvulnerable() ) then
-- 		local damage = {
-- 			victim = hTarget,
-- 			attacker = self:GetCaster(),
-- 			damage = self.damage,
-- 			damage_type = DAMAGE_TYPE_MAGICAL,
-- 			ability = self
-- 		}

-- 		ApplyDamage( damage )

-- 		local vDirection = vLocation - self:GetCaster():GetOrigin()
-- 		vDirection.z = 0.0
-- 		vDirection = vDirection:Normalized()
		
-- 		local nFXIndex = ParticleManager:CreateParticle( "particles/units/heroes/hero_windrunner/windrunner_spell_powershot_trail_h.vpcf", PATTACH_ABSORIGIN_FOLLOW, hTarget )
-- 		ParticleManager:SetParticleControlForward( nFXIndex, 1, vDirection )
-- 		ParticleManager:ReleaseParticleIndex( nFXIndex )
-- 	end

-- 	return false
-- end
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------