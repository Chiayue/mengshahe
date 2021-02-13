initiative_sickle_lua = class({})
initiative_sickle_lua_d = initiative_sickle_lua
initiative_sickle_lua_c = initiative_sickle_lua
initiative_sickle_lua_b = initiative_sickle_lua
initiative_sickle_lua_a = initiative_sickle_lua
initiative_sickle_lua_s = initiative_sickle_lua

function initiative_sickle_lua:OnSpellStart()

	self.speed = self:GetSpecialValueFor("speed")
	self.width_initial = self:GetSpecialValueFor("width_initial")
	self.width_end = self:GetSpecialValueFor("width_end")
	self.distance = self:GetSpecialValueFor("distance")
	self.speed = self.speed * ( self.distance / ( self.distance - self.width_initial ) )
	self.damage = {
		attacker = self:GetCaster(),
		damage = self:GetSpecialValueFor("damage")+self:GetCaster():GetStrength()*self:GetSpecialValueFor("attr_damage"),	
		damage_type = DAMAGE_TYPE_MAGICAL,
		ability = self
	}
	local num = 0
	local abilityLV = 0
	
	if self:GetAbilityName() == "initiative_sickle_lua_d" then
		abilityLV = 1
	elseif self:GetAbilityName() == "initiative_sickle_lua_c" then
		abilityLV = 2
	elseif self:GetAbilityName() == "initiative_sickle_lua_b" then
		abilityLV = 3
	elseif self:GetAbilityName() == "initiative_sickle_lua_a" then
		abilityLV = 4
	elseif self:GetAbilityName() == "initiative_sickle_lua_s" then
		abilityLV = 5
	end

	local a = self:GetCursorPosition()
	local b = self:GetCaster():GetOrigin()
	local offset = self:GetCursorPosition()
	if a.x-b.x < 0 then
		offset.x = b.x-self.distance*math.cos(math.atan((b.y-a.y)/(b.x-a.x)))
		offset.y = b.y-self.distance*math.sin(math.atan((b.y-a.y)/(b.x-a.x)))
	else
		offset.x = b.x+self.distance*math.cos(math.atan((b.y-a.y)/(b.x-a.x)))
		offset.y = b.y+self.distance*math.sin(math.atan((b.y-a.y)/(b.x-a.x)))
	end
	Timers:CreateTimer(0.1, function()
		local vDirection = offset - self:GetCaster():GetOrigin()	
		vDirection.z = 0.0
		vDirection = vDirection:Normalized()	

		local info = {
			EffectName = "particles/diy_particles/shredder_chakram_ice.vpcf",
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
		self:GetCaster():EmitSound("sishen.liandao")
		Timers:CreateTimer(0.5, function()
	--子弹跟踪返回
			-- local iParticleID = ParticleManager:CreateParticle("particles/diy_particles/shredder_chakram_ice.vpcf", PATTACH_CUSTOMORIGIN, nil)
			-- ParticleManager:SetParticleControl(iParticleID, 0, offset)
			-- ParticleManager:SetParticleControlEnt(iParticleID, 1, self:GetCaster(), PATTACH_POINT_FOLLOW, "attach_saw", self:GetCaster():GetAbsOrigin(), true)
			-- -- ParticleManager:SetParticleControl(iParticleID, 2, Vector(self.speed, 0, 0))
			-- -- ParticleManager:SetParticleControl(iParticleID, 14, Vector(self.width_initial, 1, 1))
			-- -- ParticleManager:SetParticleControl(iParticleID, 15, Vector(0, 0, 0))
			-- -- ParticleManager:SetParticleControl(iParticleID, 16, Vector(0, 0, 0))
	--实际效果
			local cpos = self:GetCaster():GetOrigin()
			local vDirection = self:GetCaster():GetOrigin() - offset
			vDirection.z = 0.0
			vDirection = vDirection:Normalized()
			info = {
				EffectName = "",
				Ability = self,
				vSpawnOrigin = offset, 
				fStartRadius = self.width_initial,
				fEndRadius = self.width_end,
				vVelocity = vDirection * self.speed,
				fDistance = math.sqrt((cpos.x-offset.x)*(cpos.x-offset.x)+(cpos.y-offset.y)*(cpos.y-offset.y)),
				Source = self:GetCaster(),
				iUnitTargetTeam = DOTA_UNIT_TARGET_TEAM_ENEMY,
				iUnitTargetType = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
			}
			ProjectileManager:CreateLinearProjectile( info )
		
			ProjectileManager:CreateTrackingProjectile(
					{
						Target			= self:GetCaster(),
						vSourceLoc		= offset,
						Ability			= self,
						EffectName		= "particles/diy_particles/shredder_chakram_ice_end.vpcf",
						iMoveSpeed		= self.speed,
						ExtraData = {
							iParticleID = iParticleID,
							bIsReturn 	= true,
						}
					})
		end)
		num = num + 1
		if num < abilityLV then
			return 0.5
		end 
	end)
end

--子弹碰撞单位或达目的地
function initiative_sickle_lua:OnProjectileHit_ExtraData(hTarget, vLocation, ExtraData)
	if hTarget and hTarget ~= self:GetCaster() then
		self.damage.victim = hTarget,
		ApplyDamage( self.damage )
 	end
end
--子弹运动中
-- function initiative_sickle_lua:OnProjectileThink_ExtraData(vLocation, ExtraData)

-- end
