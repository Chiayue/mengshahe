archon_agi_quickshot_lua = class({})
--------------------------------------------------------------------------------

function archon_agi_quickshot_lua:OnSpellStart()
	self.speed = self:GetSpecialValueFor( "shot_speed" )
	self.width_initial = self:GetSpecialValueFor( "width_initial" )
	self.width_end = self:GetSpecialValueFor( "width_end" )
	self.distance = self:GetSpecialValueFor( "distance" )
	self.damage = self:GetSpecialValueFor( "damage" ) + self:GetCaster():GetAgility() * 2
	self.Origin = self:GetCaster():GetOrigin()
	-- EmitSoundOn( "Hero_Windrunner.DragonSlave.Cast", self:GetCaster() )

	local vPos = nil
	if self:GetCursorTarget() then
		vPos = self:GetCursorTarget():GetOrigin()
	else
		vPos = self:GetCursorPosition()
	end

	local vDirection = vPos - self.Origin
	vDirection.z = 0.0
	vDirection = vDirection:Normalized()

	self.speed = self.speed * ( self.distance / ( self.distance - self.width_initial ) )

	local info = {
		EffectName = "particles/units/heroes/hero_windrunner/windrunner_spell_powershot.vpcf",
		Ability = self,
		vSpawnOrigin = self.Origin, 
		fStartRadius = self.width_initial,
		fEndRadius = self.width_end,
		vVelocity = vDirection * self.speed,
		fDistance = self.distance,
		Source = self:GetCaster(),
		iUnitTargetTeam = DOTA_UNIT_TARGET_TEAM_ENEMY,
		iUnitTargetType = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
	}

	ProjectileManager:CreateLinearProjectile( info )
	-- EmitSoundOn( "Hero_Windrunner.DragonSlave", self:GetCaster() )
end

--------------------------------------------------------------------------------

function archon_agi_quickshot_lua:OnProjectileHit( hTarget, vLocation )
	if hTarget ~= nil and ( not hTarget:IsMagicImmune() ) and ( not hTarget:IsInvulnerable() ) then
		local damage = {
			victim = hTarget,
			attacker = self:GetCaster(),
			damage = self.damage,
			damage_type = DAMAGE_TYPE_MAGICAL,
			ability = self
		}

		ApplyDamage( damage )

		local vDirection = vLocation - self:GetCaster():GetOrigin()
		vDirection.z = 0.0
		vDirection = vDirection:Normalized()
		
		local nFXIndex = ParticleManager:CreateParticle( "particles/units/heroes/hero_windrunner/windrunner_spell_powershot_trail_h.vpcf", PATTACH_ABSORIGIN_FOLLOW, hTarget )
		ParticleManager:SetParticleControlForward( nFXIndex, 1, vDirection )
		ParticleManager:ReleaseParticleIndex( nFXIndex )
	end

	return false
end

--------------------------------------------------------------------------------
--------------------------------------------------------------------------------