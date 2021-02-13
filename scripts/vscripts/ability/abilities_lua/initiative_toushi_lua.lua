initiative_toushi_lua = class({})
initiative_toushi_lua_d = initiative_toushi_lua
initiative_toushi_lua_c = initiative_toushi_lua
initiative_toushi_lua_b = initiative_toushi_lua
initiative_toushi_lua_a = initiative_toushi_lua
initiative_toushi_lua_s = initiative_toushi_lua

function initiative_toushi_lua:OnSpellStart()

	self.speed = self:GetSpecialValueFor("speed")
	self.width_initial = self:GetSpecialValueFor("width_initial")
	self.width_end = self:GetSpecialValueFor("width_end")
	self.distance = self:GetSpecialValueFor("distance")

	local vPos = nil
	if self:GetCursorTarget() then
		vPos = self:GetCursorTarget():GetOrigin()
	else
		vPos = self:GetCursorPosition()
	end

	local vDirection = vPos - self:GetCaster():GetOrigin()	
	vDirection.z = 0.0
	vDirection = vDirection:Normalized()	
	self.speed = self.speed * ( self.distance / ( self.distance - self.width_initial ) )

	local info = {
		EffectName = "particles/units/heroes/hero_invoker/invoker_chaos_meteor.vpcf",
		Ability = self,
		vSpawnOrigin = self:GetCaster():GetOrigin(), 
		fStartRadius = self.width_initial,
		fEndRadius = self.width_end,
		vVelocity = vDirection * self.speed,
		fDistance = self.distance,
		Source = self:GetCaster(),
		iUnitTargetTeam = DOTA_UNIT_TARGET_TEAM_ENEMY,
		iUnitTargetType = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
	}
	ProjectileManager:CreateLinearProjectile( info )

end

--------------------------------------------------------------------------------

function initiative_toushi_lua:OnProjectileHit( hTarget, vLocation )

	if hTarget ~= nil and ( not hTarget:IsMagicImmune() ) and ( not hTarget:IsInvulnerable() ) then

		local vDirection = vLocation - self:GetCaster():GetOrigin()
		vDirection.z = 0.0
		vDirection = vDirection:Normalized()
		
		local nFXIndex = ParticleManager:CreateParticle( "particles/units/heroes/hero_windrunner/windrunner_windrun_dust_color.vpcf", PATTACH_ABSORIGIN_FOLLOW, hTarget )
		ParticleManager:SetParticleControlForward( nFXIndex, 1, vDirection )
		ParticleManager:ReleaseParticleIndex( nFXIndex )


		local center_positon = RotatePosition(self:GetCaster():GetOrigin(),QAngle(0, -180, 0), hTarget:GetOrigin()) 
		local knockbackModifierTable =
					{
					should_stun = 0.5,
					knockback_duration = 0.5,
					duration = 0.5,
					knockback_distance = 300,
					knockback_height = 100,
					center_x = center_positon.x,
					center_y = center_positon.y,
					center_z = center_positon.z
					}

			-- 敌人击飞   系统自带的击飞 modifier 
		hTarget:AddNewModifier( self:GetCaster(), self, "modifier_knockback", knockbackModifierTable )
		self:GetCaster():EmitSound("TG.axejump")--调用音效

		local damage = {
			victim = hTarget,
			attacker = self:GetCaster(),
			damage = self:GetSpecialValueFor("damage")+self:GetCaster():GetStrength()*self:GetSpecialValueFor("attr_damage"),	
			damage_type = DAMAGE_TYPE_PHYSICAL,
			ability = self
		}
		ApplyDamage( damage )
 	end
end
