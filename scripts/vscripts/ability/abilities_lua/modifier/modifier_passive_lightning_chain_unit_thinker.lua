
local sParticle = "particles/units/heroes/hero_zuus/zuus_arc_lightning_head.vpcf"


if modifier_passive_lightning_chain_unit_thinker == nil then
	modifier_passive_lightning_chain_unit_thinker = class({})
end

function modifier_passive_lightning_chain_unit_thinker:Precache(context)
	PrecacheResource( "particle", sParticle, context )
	PrecacheResource( "soundfile", "sounds/weapons/hero/zuus/arc_lightning.vsnd", context )
	PrecacheResource( "soundfile", "sounds/weapons/hero/zuus/general_attack1.vsnd", context )

end

--------------------------------------------------
if modifier_passive_lightning_chain_unit_thinker == nil then
	modifier_passive_lightning_chain_unit_thinker = class({})
end

-- function modifier_passive_lightning_chain_unit_thinker:IsHidden() 
-- 	return true
-- end

function modifier_passive_lightning_chain_unit_thinker:OnCreated(params)
	if IsServer() then
		self.nMaxTargets = params.damage_amount or 10
		self.damage = params.basedamage
		self:StartIntervalThink( 0.1 )
	end
end


-- function modifier_passive_lightning_chain_unit_thinker:GetAttributes()
-- 	return MODIFIER_ATTRIBUTE_MULTIPLE
-- end

function modifier_passive_lightning_chain_unit_thinker:OnIntervalThink()
	if IsServer() then
		local enemies = FindUnitsInRadius( 
			DOTA_TEAM_GOODGUYS, 
			self:GetParent():GetOrigin(), 
			self:GetParent(), 
			600, 
			DOTA_UNIT_TARGET_TEAM_ENEMY, 
			DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_CREEP, 
			0, 
			0, 
			false 
		)
		local crtUnit = self:GetParent()
		local nextUnit
		local flClosestDist = 0.0
		-- 选取范围最近的1个单位
		if enemies  then
			for i,enemy in pairs(enemies) do
				local isHit = false
				for k,hited in ipairs(self:GetAbility().hited_unit) do
					if enemy == hited  then
						isHit = true
					end
				end
				if not isHit then
					if enemy:IsAlive() then
						local vCastDistance = enemy:GetOrigin() - self:GetParent():GetOrigin()
						local DistanceBetweenUnit  = vCastDistance:Length()
						if nextUnit == nil or DistanceBetweenUnit < flClosestDist then
							nextUnit = enemy
							flClosestDist = DistanceBetweenUnit
						end
					end
				end
			end
		end
		if nextUnit and #self:GetAbility().hited_unit < self.nMaxTargets then
			table.insert(self:GetAbility().hited_unit,nextUnit)
			self:HitTarget( crtUnit,nextUnit)
		end
		if crtUnit and crtUnit:IsAlive() then
			local damage = {
				victim = crtUnit,
				attacker = self:GetCaster(),
				damage = self.damage,
				damage_type = DAMAGE_TYPE_MAGICAL,
				ability = self:GetAbility()
			}
			ApplyDamage( damage )
		end
		self:Destroy()
	end
end

function modifier_passive_lightning_chain_unit_thinker:HitTarget( hOrigin,hTarget)
	if hTarget == nil then
		return
	end
	local lightningBolt = ParticleManager:CreateParticle(sParticle, PATTACH_WORLDORIGIN, hOrigin)
	ParticleManager:SetParticleControl(lightningBolt,0,Vector(hOrigin:GetAbsOrigin().x,hOrigin:GetAbsOrigin().y,hOrigin:GetAbsOrigin().z + hOrigin:GetBoundingMaxs().z ))   
	ParticleManager:SetParticleControl(lightningBolt,1,Vector(hTarget:GetAbsOrigin().x,hTarget:GetAbsOrigin().y,hTarget:GetAbsOrigin().z + hTarget:GetBoundingMaxs().z ))
	hTarget:AddNewModifier( 
		hOrigin, 
		self:GetAbility(), 
		"modifier_passive_lightning_chain_unit_thinker", 
		{ duration = 1,basedamage = self.damage,damage_amount = self.nMaxTargets} 
	)
	
end
